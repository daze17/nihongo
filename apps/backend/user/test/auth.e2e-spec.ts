import type { NestFastifyApplication } from "@nestjs/platform-fastify";
import { createDb, eq, users } from "@repo/db";
import request from "supertest";

import type { fakeAuth0 } from "./fake_auth0";
import { createTestApp } from "./setup_app";
import { TEST_DATABASE_URL } from "./constants";

// Tokens are signed with a local key that replaces Auth0's published keys.
describe("Auth (e2e)", () => {
  let app: NestFastifyApplication;
  let auth0: Awaited<ReturnType<typeof fakeAuth0>>;
  const db = createDb(TEST_DATABASE_URL, { max: 1 });

  beforeAll(async () => {
    ({ app, auth0 } = await createTestApp());
    await db.db.delete(users);
  });

  afterAll(async () => {
    await app?.close();
    await db.close();
  });

  it("GET /v1/me without a token is a 401 problem", async () => {
    const res = await request(app.getHttpServer()).get("/v1/me").expect(401);
    expect(res.headers["content-type"]).toContain("application/problem+json");
    expect(res.headers["www-authenticate"]).toBe("Bearer");
    expect(res.body).toMatchObject({
      status: 401,
      detail: "Missing bearer token",
    });
  });

  it("GET /v1/me rejects a token for another audience", async () => {
    const token = await auth0.token("google-oauth2|1", {
      audience: "https://other",
    });
    await request(app.getHttpServer())
      .get("/v1/me")
      .set("Authorization", `Bearer ${token}`)
      .expect(401);
  });

  it("public routes need no token", async () => {
    await request(app.getHttpServer()).get("/health/live").expect(200);
  });

  it("GET /v1/me creates the user on first sign-in, then updates the profile", async () => {
    const first = await auth0.token("facebook|42", {
      profile: { email: "bat@example.mn", email_verified: true, name: "Бат" },
    });
    const created = await request(app.getHttpServer())
      .get("/v1/me")
      .set("Authorization", `Bearer ${first}`)
      .expect(200);
    expect(created.body).toMatchObject({
      email: "bat@example.mn",
      emailVerified: true,
      name: "Бат",
      pictureUrl: null,
    });

    // A later token without email keeps the stored email and updates the name.
    const second = await auth0.token("facebook|42", {
      profile: { name: "Бат-Эрдэнэ" },
    });
    const updated = await request(app.getHttpServer())
      .get("/v1/me")
      .set("Authorization", `Bearer ${second}`)
      .expect(200);
    expect(updated.body).toMatchObject({
      id: created.body.id,
      email: "bat@example.mn",
      name: "Бат-Эрдэнэ",
    });

    const rows = await db.db
      .select()
      .from(users)
      .where(eq(users.auth0Sub, "facebook|42"));
    expect(rows).toHaveLength(1);
  });
});
