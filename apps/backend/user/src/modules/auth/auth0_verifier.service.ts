import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import {
  createRemoteJWKSet,
  errors,
  type JWTPayload,
  jwtVerify,
  type JWTVerifyGetKey,
} from "jose";

import { AUTH0_CLAIM_NAMESPACE } from "@/common/constants/auth.constants";
import { auth0KeysProviderToken } from "@/common/constants/provider_tokens.constants";
import type { AuthClaims } from "@/common/types/authed_request";
import type { Configuration } from "@/config/configuration";

export const auth0KeysFactory = (
  configService: ConfigService<Configuration, true>,
): JWTVerifyGetKey | null => {
  const domain = configService.get("auth0.domain", { infer: true });
  // jose caches the keys and re-fetches when Auth0 rotates them.
  return domain
    ? createRemoteJWKSet(new URL(`https://${domain}/.well-known/jwks.json`))
    : null;
};

export class AuthNotConfiguredError extends Error {}
export class InvalidTokenError extends Error {}

const text = (value: unknown) =>
  typeof value === "string" && value.length > 0 ? value : null;

/** Verifies Auth0 access tokens (RS256) for our API audience. No database access. */
@Injectable()
export class Auth0VerifierService {
  constructor(
    private readonly configService: ConfigService<Configuration, true>,
    @Inject(auth0KeysProviderToken)
    private readonly keys: JWTVerifyGetKey | null,
  ) {}

  async verify(token: string): Promise<AuthClaims> {
    const { domain, audience } = this.configService.get("auth0", {
      infer: true,
    });
    if (!domain || !audience || !this.keys) throw new AuthNotConfiguredError();

    let payload: JWTPayload;
    try {
      ({ payload } = await jwtVerify(token, this.keys, {
        issuer: `https://${domain}/`,
        audience,
        algorithms: ["RS256"],
      }));
    } catch (error) {
      // Bad, expired or foreign tokens are the client's problem. Network trouble
      // fetching Auth0's keys is ours and should surface as a 5xx.
      if (
        error instanceof errors.JOSEError &&
        !(error instanceof errors.JWKSTimeout)
      ) {
        throw new InvalidTokenError(error.code);
      }
      throw error;
    }
    if (!payload.sub) throw new InvalidTokenError("missing sub");

    const claim = (name: string) => payload[AUTH0_CLAIM_NAMESPACE + name];
    return {
      sub: payload.sub,
      email: text(claim("email")),
      emailVerified: claim("email_verified") === true,
      name: text(claim("name")),
      picture: text(claim("picture")),
    };
  }
}
