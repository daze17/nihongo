import { fileURLToPath } from 'node:url';
import { hiraganaRowA } from '@repo/content';
import { sql } from 'drizzle-orm';
import { createDb } from './client.js';
import { contentManifest, kana } from './schema/index.js';

/** Upserts bundled content. Idempotent: safe to run on every deploy. */
export async function seed(databaseUrl: string) {
  const { db, close } = createDb(databaseUrl, { max: 1 });
  try {
    await db.transaction(async (tx) => {
      for (const k of hiraganaRowA) {
        await tx
          .insert(kana)
          .values({ id: k.id, script: k.script, payload: k })
          .onConflictDoUpdate({ target: kana.id, set: { payload: k, script: k.script } });
      }
      await tx
        .insert(contentManifest)
        .values({ id: 1, version: 1 })
        .onConflictDoUpdate({ target: contentManifest.id, set: { publishedAt: sql`now()` } });
    });
    return { kana: hiraganaRowA.length };
  } finally {
    await close();
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error('DATABASE_URL is not set');
  console.log('seeded', await seed(url));
}
