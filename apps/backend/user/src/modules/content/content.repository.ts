import { Inject, Injectable } from "@nestjs/common";
import { contentManifest, count, eq, kana } from "@repo/db";

import { databaseProviderToken } from "@/common/constants/provider_tokens.constants";
import type {
  Database,
  DbExecutor,
} from "@/modules/database/database.providers";

export interface ManifestRow {
  version: number;
  publishedAt: Date;
}

/**
 * The only place content tables are queried. Returns plain rows; no HTTP or oRPC concerns.
 * Every method takes an optional executor so it can join a caller's transaction.
 */
@Injectable()
export class ContentRepository {
  constructor(@Inject(databaseProviderToken) private readonly db: Database) {}

  async findManifest(
    db: DbExecutor = this.db,
  ): Promise<ManifestRow | undefined> {
    const [row] = await db
      .select({
        version: contentManifest.version,
        publishedAt: contentManifest.publishedAt,
      })
      .from(contentManifest)
      .where(eq(contentManifest.id, 1));
    return row;
  }

  async countKana(db: DbExecutor = this.db): Promise<number> {
    const [row] = await db.select({ n: count() }).from(kana);
    return row?.n ?? 0;
  }

  async listKanaPayloads(db: DbExecutor = this.db): Promise<unknown[]> {
    const rows = await db
      .select({ payload: kana.payload })
      .from(kana)
      .orderBy(kana.id);
    return rows.map((row) => row.payload);
  }
}
