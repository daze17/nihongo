import type { FastifyRequest } from "fastify";

export interface AuthClaims {
  /** Auth0 user id, e.g. `google-oauth2|1098…`. */
  sub: string;
  email: string | null;
  emailVerified: boolean;
  name: string | null;
  picture: string | null;
}

/** Request after Auth0AuthGuard: verified claims are on `auth`. */
export type AuthedRequest = FastifyRequest & { auth?: AuthClaims };

/** Claims set by Auth0AuthGuard. Throws if the route is marked @Public(). */
export const authOf = (request: AuthedRequest): AuthClaims => {
  if (!request.auth) {
    throw new Error("authOf() used on a @Public() route");
  }
  return request.auth;
};
