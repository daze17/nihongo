import { Injectable, NotFoundException } from '@nestjs/common';
import { type Database, contentManifest, kana } from '@repo/db';
import { count, eq } from 'drizzle-orm';
import { InjectDb } from '../database/inject-db.js';

@Injectable()
export class ContentService {
  constructor(@InjectDb() private readonly db: Database) {}

  async manifest() {
    const [row] = await this.db.select().from(contentManifest).where(eq(contentManifest.id, 1));
    if (!row) throw new NotFoundException('Content has not been published yet');
    const [kanaCount] = await this.db.select({ n: count() }).from(kana);
    return {
      version: row.version,
      publishedAt: row.publishedAt.toISOString(),
      counts: { kana: kanaCount?.n ?? 0 },
    };
  }

  async listKana() {
    const rows = await this.db.select({ payload: kana.payload }).from(kana).orderBy(kana.id);
    return rows.map((r) => r.payload);
  }
}
