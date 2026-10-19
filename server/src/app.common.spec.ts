import type { NextFunction, Request, Response } from 'express';
import { createApiKeyNetworkGuard } from 'src/app.common.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';

const DEFAULT_NETWORKS = ['loopback', 'uniquelocal', '100.64.0.0/10'];

describe('createApiKeyNetworkGuard', () => {
  let warn: ReturnType<typeof vi.fn>;
  let next: ReturnType<typeof vi.fn>;
  let res: { status: ReturnType<typeof vi.fn>; json: ReturnType<typeof vi.fn> };

  const setup = (allowedNetworks: string[] = DEFAULT_NETWORKS) => {
    warn = vi.fn();
    next = vi.fn();
    res = { status: vi.fn().mockReturnThis(), json: vi.fn() };
    const guard = createApiKeyNetworkGuard(allowedNetworks, { warn } as Pick<LoggingRepository, 'warn'>);

    const run = (req: { headers?: Record<string, string>; query?: Record<string, string>; ip?: string }) => {
      next.mockClear();
      res.status.mockClear();
      res.json.mockClear();
      guard(
        { method: 'GET', path: '/api/users/me', headers: {}, query: {}, ...req } as unknown as Request,
        res as unknown as Response,
        next as NextFunction,
      );
      return { blocked: next.mock.calls.length === 0 };
    };

    return { run };
  };

  it('blocks an x-api-key header from a public address', () => {
    const { run } = setup();
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '203.0.113.9' }).blocked).toBe(true);
    expect(res.status).toHaveBeenCalledWith(403);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ statusCode: 403, message: 'API key authentication is not allowed from this network' }),
    );
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it('blocks an apiKey query param from a public address', () => {
    const { run } = setup();
    expect(run({ query: { apiKey: 'key' }, ip: '203.0.113.9' }).blocked).toBe(true);
    expect(next).not.toHaveBeenCalled();
  });

  it('blocks a public IPv6 address', () => {
    const { run } = setup();
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '2606:4700::1111' }).blocked).toBe(true);
  });

  it('blocks when the client address is unknown', () => {
    const { run } = setup();
    expect(run({ headers: { 'x-api-key': 'key' } }).blocked).toBe(true);
  });

  it('allows private, docker, loopback, CGNAT and ULA clients', () => {
    const { run } = setup();
    const allowed = [
      '192.168.20.5',
      '10.1.2.3',
      '172.18.0.3',
      '127.0.0.1',
      '::ffff:192.168.20.5',
      '100.123.191.105',
      'fd12:3455:67::1',
    ];
    for (const ip of allowed) {
      expect(run({ headers: { 'x-api-key': 'key' }, ip }).blocked).toBe(false);
    }
  });

  it('lets requests without an API key through regardless of address', () => {
    const { run } = setup();
    expect(run({ ip: '203.0.113.9' }).blocked).toBe(false);
    expect(run({ headers: {}, query: {}, ip: '198.51.100.1' }).blocked).toBe(false);
  });

  it('honors a narrowed allowlist', () => {
    const { run } = setup(['127.0.0.1/32']);
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '192.168.20.5' }).blocked).toBe(true);
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '127.0.0.1' }).blocked).toBe(false);
  });

  it('can be opened to every network', () => {
    // proxy-addr rejects 0.0.0.0/0, so "allow all" is expressed as the two IPv4 and two IPv6 half-ranges
    const { run } = setup(['0.0.0.0/1', '128.0.0.0/1', '::/1', '8000::/1']);
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '203.0.113.9' }).blocked).toBe(false);
    expect(run({ headers: { 'x-api-key': 'key' }, ip: '2606:4700::1111' }).blocked).toBe(false);
  });
});
