import {
  createLocalJWKSet,
  exportJWK,
  generateKeyPair,
  type JWTVerifyGetKey,
  SignJWT,
} from "jose";

import { AUTH0_CLAIM_NAMESPACE } from "@/common/constants/auth.constants";

import { TEST_AUDIENCE, TEST_DOMAIN } from "./constants";

export { TEST_AUDIENCE, TEST_DOMAIN };

/** A throwaway RS256 key pair standing in for an Auth0 tenant. */
export const fakeAuth0 = async () => {
  const { privateKey, publicKey } = await generateKeyPair("RS256");
  const jwk = {
    ...(await exportJWK(publicKey)),
    kid: "test-key",
    alg: "RS256",
    use: "sig",
  };
  const keys: JWTVerifyGetKey = createLocalJWKSet({ keys: [jwk] });

  const token = async (
    sub: string,
    options: {
      profile?: Record<string, unknown>;
      audience?: string;
      issuer?: string;
      expiresIn?: string;
    } = {},
  ) => {
    const claims = Object.fromEntries(
      Object.entries(options.profile ?? {}).map(([key, value]) => [
        AUTH0_CLAIM_NAMESPACE + key,
        value,
      ]),
    );
    return new SignJWT(claims)
      .setProtectedHeader({ alg: "RS256", kid: "test-key" })
      .setSubject(sub)
      .setIssuer(options.issuer ?? `https://${TEST_DOMAIN}/`)
      .setAudience(options.audience ?? TEST_AUDIENCE)
      .setIssuedAt()
      .setExpirationTime(options.expiresIn ?? "5m")
      .sign(privateKey);
  };

  return { keys, token };
};
