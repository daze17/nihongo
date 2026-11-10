import { hiraganaRowA } from "@repo/content";
import { sql } from "drizzle-orm";
import { createDb } from "./client";
import { contentManifest, kana } from "./schema/index";

/** Upserts bundled content. Idempotent: safe to run on every deploy. */
export async function seed(databaseUrl: string) {
  const { db, close } = createDb(databaseUrl, { max: 1 });
  try {
    await db.transaction(async (tx) => {
      for (const k of hiraganaRowA) {
        await tx
          .insert(kana)
          .values({ id: k.id, script: k.script, payload: k })
          .onConflictDoUpdate({
            target: kana.id,
            set: { payload: k, script: k.script },
          });
      }
      await tx
        .insert(contentManifest)
        .values({ id: 1, version: 1 })
        .onConflictDoUpdate({
          target: contentManifest.id,
          set: { publishedAt: sql`now()` },
        });
    });
    return { kana: hiraganaRowA.length };
  } finally {
    await close();
  }
}
