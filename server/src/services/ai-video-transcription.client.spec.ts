import { once } from 'node:events';
import { createServer } from 'node:http';
import { AiVideoTranscriptionClient } from 'src/services/ai-video-transcription.client.js';

it.each(['isolate', 'transcribe'] as const)(
  'keeps capacity, worker failure, and legacy %s requests distinct',
  async (route) => {
    let status = 503;
    let body: unknown = { code: 'gpu_capacity', retryable: true };
    let dualGpu = true;
    const received: { path?: string; requestClass?: string | string[]; body: unknown }[] = [];
    const server = createServer((req, res) => {
      void Array.fromAsync(req)
        .then((chunks) => {
          received.push({
            path: req.url,
            requestClass: req.headers['x-immich-transcription-class'],
            body: JSON.parse(Buffer.concat(chunks).toString()),
          });
          res.writeHead(status, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify(body));
        })
        .catch((error) => res.destroy(error));
    });
    server.listen(0, '127.0.0.1');
    try {
      await once(server, 'listening');
      const address = server.address();
      if (!address || typeof address === 'string') {
        throw new Error('Expected a TCP listener');
      }
      const url = `http://127.0.0.1:${address.port}`;
      const client = new AiVideoTranscriptionClient(
        {
          getEnv: () => ({ aiVideoTranscription: { url, voiceIsolationUrl: url, timeoutMs: 1000, dualGpu } }),
        } as never,
        { warn: vi.fn(), debug: vi.fn() } as never,
        { jobs: { recordCounter: vi.fn(), recordHistogram: vi.fn() } } as never,
      );
      const audio = Buffer.from('audio-fixture');
      const call = () => {
        const options = dualGpu ? { requestClass: 'backfill' as const } : undefined;
        return route === 'isolate' ? client.isolateVoice(audio, options) : client.transcribe(audio, options);
      };
      await expect(call()).rejects.toMatchObject({ code: 'gpu_capacity' });
      status = 502;
      body = { code: 'gpu_worker_unavailable' };
      await expect(call()).rejects.toMatchObject({ code: 'endpoint_error' });
      status = 503;
      body = { code: 'gpu_capacity', retryable: false };
      await expect(call()).rejects.toMatchObject({ code: 'endpoint_error' });
      dualGpu = false;
      body = { code: 'gpu_capacity', retryable: true };
      await expect(call()).rejects.toMatchObject({ code: 'endpoint_error' });
      status = 200;
      body =
        route === 'isolate'
          ? { audio: audio.toString('base64'), sampleRate: 16_000 }
          : { noSpeech: true, language: null, languageProbability: null, segments: [] };
      await expect(call()).resolves.toEqual(
        route === 'isolate'
          ? audio
          : expect.objectContaining({
              noSpeech: true,
              segments: [],
              language: undefined,
              languageProbability: undefined,
            }),
      );
      expect(received.map(({ requestClass }) => requestClass)).toEqual([
        'backfill',
        'backfill',
        'backfill',
        undefined,
        undefined,
      ]);
      expect(received.every((entry) => entry.path === `/${route}`)).toBe(true);
      expect(received.at(-1)?.body).toEqual({
        audio: audio.toString('base64'),
        ...(route === 'isolate' && { outputSampleRate: 16_000 }),
      });
    } finally {
      server.close();
      server.closeAllConnections();
    }
  },
);
