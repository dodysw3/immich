import { Mocked, vitest } from 'vitest';
import { DatabaseExtension, ImmichEnvironment, ImmichWorker, LogFormat } from 'src/enum.js';
import { ConfigRepository, EnvData } from 'src/repositories/config.repository.js';
import type { RepositoryInterface } from 'src/types.js';

export const envData: EnvData = {
  port: 2283,
  environment: ImmichEnvironment.Production,
  logFormat: LogFormat.Console,

  buildMetadata: {},
  bull: {
    config: {
      connection: {},
      prefix: 'immich_bull',
    },
    queues: [{ name: 'queue-1' }],
  },

  cls: {
    config: {},
  },

  database: {
    config: {
      connectionType: 'parts',
      database: 'immich',
      host: 'database',
      port: 5432,
      username: 'postgres',
      password: 'postgres',
    },
    skipMigrations: false,
    vectorExtension: DatabaseExtension.VectorChord,
  },

  helmet: {
    config: {},
  },

  licensePublicKey: {
    client: 'client-public-key',
    server: 'server-public-key',
  },

  versionCheck: {
    url: 'https://version.immich.cloud/version',
  },

  network: {
    trustedProxies: [],
    apiKeyAllowedNetworks: ['loopback', 'uniquelocal', '100.64.0.0/10'],
  },

  otel: {
    metrics: {
      hostMetrics: false,
    },
  },

  redis: {
    host: 'redis',
    port: 6379,
    db: 0,
  },

  resourcePaths: {
    lockFile: 'build-lock.json',
    geodata: {
      dateFile: '/build/geodata/geodata-date.txt',
      admin1: '/build/geodata/admin1CodesASCII.txt',
      admin2: '/build/geodata/admin2Codes.txt',
      cities500: '/build/geodata/cities500.txt',
      countryInfo: '/build/geodata/countryInfo.txt',
      naturalEarthCountriesPath: 'build/ne_10m_admin_0_countries.geojson',
    },
    web: {
      root: '/build/www',
      indexHtml: '/build/www/index.html',
    },
    corePlugin: '/build/plugins/immich-plugin-core',
  },

  setup: {
    allow: true,
  },

  storage: {
    ignoreMountCheckErrors: false,
  },

  telemetry: {
    apiPort: 8081,
    microservicesPort: 8082,
    metrics: new Set(),
  },

  workers: [ImmichWorker.Api, ImmichWorker.Microservices],

  plugins: {
    external: {
      allow: true,
      installFolder: '/app/data/plugins',
    },
  },

  pdf: {
    enabled: true,
    ocrEnabled: true,
    ocrProvider: 'immich',
    maxPagesPerDoc: 250,
    maxFileSizeMb: null,
    minEmbeddedTextLength: 10,
    unlimitedOcr: { timeoutMs: 120_000 },
  },

  aiImageInterpretation: {
    enabled: false,
    model: 'unsloth/Muse-Glimmer-30B-GGUF',
    quant: 'UD-Q3_K_XL',
    publicUrl: 'http://public-ai-endpoint/interpret',
    publicModel: 'mai/muse-spark-1.3-contributor',
    publicConcurrency: 8,
    promptVersion: 'image-interpretation-1.0.0',
    timeoutMs: 900_000,
    maxEdge: 1600,
    maxPixels: 16_000_000,
    concurrency: 1,
    reconcileStaggerMs: 5000,
    // Test mock keeps pre-flag behavior: deliveries never skip on existing runs.
    skipIfInterpreted: false,
    videoContext: false,
    discord: { includeThumbnail: true },
  },

  aiInterpretSearch: {
    enabled: false,
    model: 'bge-m3-Q8_0',
    timeoutMs: 30_000,
    minScore: 0.4,
  },

  aiVideoCaptioning: {
    enabled: true,
    model: 'lfm3-omni-2b',
    timeoutMs: 120_000,
    segmentSeconds: 5,
    framesPerSegment: 3,
    adaptive: false,
    probeFps: 2,
    minSegmentSeconds: 2,
    maxSegmentSeconds: 20,
    changeBudget: 40,
    cutThreshold: 35,
    frameEdge: 672,
    maxDurationSec: 300,
    language: 'en',
    concurrency: 1,
  },

  aiVideoTranscription: {
    enabled: false,
    model: 'faster-whisper-large-v3',
    timeoutMs: 600_000,
    language: '',
    maxDurationSec: 300,
  },

  aiAudioEvents: {
    enabled: false,
    context: false,
    threshold: 0.15,
    maxDurationSec: 300,
    timeoutMs: 60_000,
  },

  videoFaceScan: {
    enabled: true,
    onCaption: true,
    framesBudget: 32,
    deadlineMs: 60_000,
    groupThreshold: 0.55,
    exemplarMerge: true,
    minGapMs: 1500,
    saturation: 6,
    identitiesCap: 30,
  },

  noColor: false,
};

export const mockEnvData = (config: Partial<EnvData>) => ({ ...envData, ...config });
export const newConfigRepositoryMock = (): Mocked<RepositoryInterface<ConfigRepository>> => {
  return {
    getEnv: vitest.fn().mockReturnValue(mockEnvData({})),
    getWorker: vitest.fn().mockReturnValue(ImmichWorker.Api),
    isDev: vitest.fn().mockReturnValue(false),
    isProduction: vitest.fn().mockReturnValue(true),
  };
};
