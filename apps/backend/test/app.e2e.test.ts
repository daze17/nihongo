import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { createApp } from '../src/app.js';

// Runs against the docker-compose Postgres, database `nihongo_test` (see global-setup.ts).
describe('API (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    process.env.DATABASE_URL = 'postgres://nihongo:nihongo@localhost:5432/nihongo_test';
    process.env.NODE_ENV = 'test';
    process.env.LOG_LEVEL = 'warn';
    app = await createApp();
    await app.init();
  });

  afterAll(async () => {
    await app?.close();
  });

  it('GET /health reports the database up', async () => {
    const res = await request(app.getHttpServer()).get('/health').expect(200);
    expect(res.body.info.database.status).toBe('up');
  });

  it('GET /v1/content/manifest returns the seeded version', async () => {
    const res = await request(app.getHttpServer()).get('/v1/content/manifest').expect(200);
    expect(res.body).toMatchObject({ version: 1, counts: { kana: 5 } });
  });

  it('GET /v1/content/kana returns schema-shaped rows', async () => {
    const res = await request(app.getHttpServer()).get('/v1/content/kana').expect(200);
    expect(res.body[0]).toMatchObject({ id: 'hira-a', char: 'あ', script: 'hiragana' });
  });

  it('unknown routes return problem+json', async () => {
    const res = await request(app.getHttpServer()).get('/v1/does-not-exist').expect(404);
    expect(res.headers['content-type']).toMatch(/application\/problem\+json/);
    expect(res.body).toMatchObject({ status: 404, title: 'Not Found' });
  });
});
