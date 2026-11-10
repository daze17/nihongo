import { Inject, Injectable } from "@nestjs/common";
import { type User, users } from "@repo/db";

import { databaseProviderToken } from "@/common/constants/provider_tokens.constants";
import type {
  Database,
  DbExecutor,
} from "@/modules/database/database.providers";

export interface AuthProfile {
  auth0Sub: string;
  email: string | null;
  emailVerified: boolean;
  name: string | null;
  pictureUrl: string | null;
}

/** The only place the users table is queried. */
@Injectable()
export class UserRepository {
  constructor(@Inject(databaseProviderToken) private readonly db: Database) {}

  /**
   * Creates the user on first sign-in. Later sign-ins refresh profile fields the
   * token carries and keep stored values the token leaves out.
   */
  async upsertFromAuth(
    profile: AuthProfile,
    db: DbExecutor = this.db,
  ): Promise<User> {
    const known = Object.fromEntries(
      Object.entries({
        email: profile.email,
        emailVerified: profile.email === null ? null : profile.emailVerified,
        name: profile.name,
        pictureUrl: profile.pictureUrl,
      }).filter(([, value]) => value !== null),
    );
    const [row] = await db
      .insert(users)
      .values(profile)
      .onConflictDoUpdate({
        target: users.auth0Sub,
        set: { ...known, updatedAt: new Date() },
      })
      .returning();
    if (!row) throw new Error("upsert returned no row");
    return row;
  }
}
