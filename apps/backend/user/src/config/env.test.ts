import { describe, expect, it } from 'vitest';
import { parseEnv } from './env.js';

describe('parseEnv', () => {
  it('applies defaults', () => {
    const env = parseEnv({ DATABASE_URL: 'postgres://u:p@localhost:5432/db' });
    expect(env.PORT).toBe(3000);
    expect(env.NODE_ENV).toBe('development');
    expect(env.CORS_ORIGINS).toEqual([]);
  });

  it('rejects a non-postgres database url', () => {
    expect(() => parseEnv({ DATABASE_URL: 'mysql://localhost/db' })).toThrow(/DATABASE_URL/);
  });

  it('splits CORS origins', () => {
    const env = parseEnv({
      DATABASE_URL: 'postgres://localhost/db',
      CORS_ORIGINS: 'https://a.dev, https://b.dev',
    });
    expect(env.CORS_ORIGINS).toEqual(['https://a.dev', 'https://b.dev']);
  });
});
