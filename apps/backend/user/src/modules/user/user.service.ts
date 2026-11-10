import { Injectable } from "@nestjs/common";
import { ORPCError } from "@orpc/nest";
import type { MeResponseBody } from "@repo/contract";

import type { AuthClaims } from "@/common/types/authed_request";

import { UserRepository } from "./user.repository";

@Injectable()
export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  /** Returns the signed-in user, creating them on their first request. */
  async me(claims: AuthClaims): Promise<MeResponseBody> {
    const row = await this.userRepository.upsertFromAuth({
      auth0Sub: claims.sub,
      email: claims.email,
      emailVerified: claims.emailVerified,
      name: claims.name,
      pictureUrl: claims.picture,
    });
    if (row.deletedAt) {
      throw new ORPCError("FORBIDDEN", { message: "This account was deleted" });
    }
    return {
      id: row.id,
      email: row.email,
      emailVerified: row.emailVerified,
      name: row.name,
      pictureUrl: row.pictureUrl,
      createdAt: row.createdAt.toISOString(),
    };
  }
}
