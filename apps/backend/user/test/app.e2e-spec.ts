import type { NestFastifyApplication } from "@nestjs/platform-fastify";
import { contentManifest, createDb } from "@repo/db";
import request from "supertest";

import { createTestApp } from "./setup_app";
import { TEST_DATABASE_URL } from "./constants";

// Runs against the docker-compose Postgres, database `nihongo_test` (see global_setup.ts).
describe("API (e2e)", () => {
  let app: NestFastifyApplication;

  beforeAll(async () => {
    ({ app } = await createTestApp());
  });

  afterAll(async () => {
    await app?.close();
  });

  it("GET /health reports the database up", async () => {
    const res = await request(app.getHttpServer()).get("/health").expect(200);
    expect(res.body.info.database.status).toBe("up");
  });

  it("GET /v1/content/manifest returns the seeded version", async () => {
    const res = await request(app.getHttpServer())
      .get("/v1/content/manifest")
      .expect(200);
    expect(res.body).toMatchObject({ version: 1, counts: { kana: 5 } });
  });

  it("GET /v1/content/kana returns schema-shaped rows", async () => {
    const res = await request(app.getHttpServer())
      .get("/v1/content/kana")
      .expect(200);
    expect(res.body[0]).toMatchObject({
      id: "hira-a",
      char: "あ",
      script: "hiragana",
    });
  });

  it("GET /openapi.json is generated from the oRPC contract", async () => {
    const res = await request(app.getHttpServer())
      .get("/openapi.json")
      .expect(200);
    expect(Object.keys(res.body.paths)).toEqual(
      expect.arrayContaining([
        "/v1/content/manifest",
        "/v1/content/kana",
        "/v1/me",
      ]),
    );
  });

  it("GET /docs serves the API reference in dev", async () => {
    const res = await request(app.getHttpServer()).get("/docs").expect(200);
    expect(res.text).toContain('data-url="/openapi.json"');
  });

  it("unknown routes return problem+json", async () => {
    const res = await request(app.getHttpServer())
      .get("/v1/does-not-exist")
      .expect(404);
    expect(res.headers["content-type"]).toMatch(/application\/problem\+json/);
    expect(res.body).toMatchObject({ status: 404, title: "Not Found" });
  });

  // Keep last: removes the manifest row from the test database.
  it("oRPC errors are returned as problem+json", async () => {
    const { db, close } = createDb(TEST_DATABASE_URL, { max: 1 });
    await db.delete(contentManifest);
    await close();
    const res = await request(app.getHttpServer())
      .get("/v1/content/manifest")
      .expect(404);
    expect(res.headers["content-type"]).toMatch(/application\/problem\+json/);
    expect(res.body).toMatchObject({
      status: 404,
      title: "Not Found",
      code: "NOT_FOUND",
      detail: "Content has not been published yet",
      instance: "/v1/content/manifest",
    });
  });
});
