import type { ConfigService } from "@nestjs/config";

import type { Configuration } from "@/config/configuration";
import { fakeAuth0, TEST_AUDIENCE, TEST_DOMAIN } from "@/test/fake_auth0";

import {
  Auth0VerifierService,
  AuthNotConfiguredError,
  InvalidTokenError,
} from "./auth0_verifier.service";

const configService = (auth0: Configuration["auth0"]) =>
  ({ get: () => auth0 }) as unknown as ConfigService<Configuration, true>;

describe("Auth0VerifierService", () => {
  let auth0: Awaited<ReturnType<typeof fakeAuth0>>;
  let verifier: Auth0VerifierService;

  beforeAll(async () => {
    auth0 = await fakeAuth0();
    verifier = new Auth0VerifierService(
      configService({ domain: TEST_DOMAIN, audience: TEST_AUDIENCE }),
      auth0.keys,
    );
  });

  it("returns the subject and namespaced profile claims", async () => {
    const token = await auth0.token("google-oauth2|123", {
      profile: {
        email: "bat@example.mn",
        email_verified: true,
        name: "Бат",
        picture: "https://x/p.png",
      },
    });
    await expect(verifier.verify(token)).resolves.toEqual({
      sub: "google-oauth2|123",
      email: "bat@example.mn",
      emailVerified: true,
      name: "Бат",
      picture: "https://x/p.png",
    });
  });

  it("treats missing profile claims as null", async () => {
    const claims = await verifier.verify(await auth0.token("facebook|9"));
    expect(claims).toMatchObject({
      sub: "facebook|9",
      email: null,
      emailVerified: false,
    });
  });

  it.each([
    ["another audience", { audience: "https://someone-else" }],
    ["another issuer", { issuer: "https://evil.example/" }],
    ["an expired token", { expiresIn: "-1m" }],
  ])("rejects %s", async (_, options) => {
    const token = await auth0.token("auth0|1", options);
    await expect(verifier.verify(token)).rejects.toBeInstanceOf(
      InvalidTokenError,
    );
  });

  it("rejects garbage", async () => {
    await expect(verifier.verify("not-a-jwt")).rejects.toBeInstanceOf(
      InvalidTokenError,
    );
  });

  it("reports missing configuration instead of rejecting every user", async () => {
    const unconfigured = new Auth0VerifierService(
      configService({ domain: undefined, audience: TEST_AUDIENCE }),
      null,
    );
    await expect(unconfigured.verify("x")).rejects.toBeInstanceOf(
      AuthNotConfiguredError,
    );
  });
});
