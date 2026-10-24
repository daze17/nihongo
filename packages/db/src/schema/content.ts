import { sql } from 'drizzle-orm';
import { integer, jsonb, pgTable, text, timestamp } from 'drizzle-orm/pg-core';

/**
 * Content tables are read-only to clients and filled by the content pipeline.
 * Each row keeps the full validated JSON payload so the shape is owned by
 * packages/schema, with a few columns pulled out for querying.
 */
const contentColumns = {
  id: text('id').primaryKey(),
  payload: jsonb('payload').notNull(),
  version: integer('version').notNull().default(1),
  updatedAt: timestamp('updated_at', { withTimezone: true })
    .notNull()
    .defaultNow()
    .$onUpdate(() => sql`now()`),
};

export const kana = pgTable('kana', { ...contentColumns, script: text('script').notNull() });
export const kanji = pgTable('kanji', { ...contentColumns, jlpt: integer('jlpt') });
export const vocab = pgTable('vocab', { ...contentColumns, jlpt: integer('jlpt') });
export const sentences = pgTable('sentences', { ...contentColumns });
export const units = pgTable('units', {
  ...contentColumns,
  position: integer('position').notNull(),
});
export const lessons = pgTable('lessons', {
  ...contentColumns,
  unitId: text('unit_id').notNull(),
  position: integer('position').notNull(),
});

/** Single-row table with the overall content version the app compares against. */
export const contentManifest = pgTable('content_manifest', {
  id: integer('id').primaryKey().default(1),
  version: integer('version').notNull(),
  publishedAt: timestamp('published_at', { withTimezone: true }).notNull().defaultNow(),
});
