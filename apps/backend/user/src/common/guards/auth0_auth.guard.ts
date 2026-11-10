import {
  type CanActivate,
  type ExecutionContext,
  Injectable,
  ServiceUnavailableException,
  UnauthorizedException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import type { FastifyReply } from "fastify";

import { IS_PUBLIC_KEY } from "@/common/decorators/public";
import type { AuthedRequest } from "@/common/types/authed_request";
import {
  Auth0VerifierService,
  AuthNotConfiguredError,
  InvalidTokenError,
} from "@/modules/auth/auth0_verifier.service";

/**
 * Global guard. Every route needs `Authorization: Bearer <Auth0 access token>`
 * unless it is marked @Public(). Verified claims go on `request.auth`.
 */
@Injectable()
export class Auth0AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly verifier: Auth0VerifierService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const http = context.switchToHttp();
    const request = http.getRequest<AuthedRequest>();
    const token = /^Bearer\s+(\S+)$/i.exec(
      request.headers.authorization ?? "",
    )?.[1];

    const reject = (detail: string) => {
      http.getResponse<FastifyReply>().header("WWW-Authenticate", "Bearer");
      return new UnauthorizedException(detail);
    };

    if (!token) throw reject("Missing bearer token");
    try {
      request.auth = await this.verifier.verify(token);
      return true;
    } catch (error) {
      if (error instanceof InvalidTokenError) {
        throw reject("Invalid or expired token");
      }
      if (error instanceof AuthNotConfiguredError) {
        throw new ServiceUnavailableException(
          "Sign-in is not configured on this server",
        );
      }
      throw error;
    }
  }
}
