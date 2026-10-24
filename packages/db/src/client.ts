import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema/index.js';

export interface CreateDbOptions {
  /** Max pool size. Keep small per instance; Neon pools on its side too. */
  max?: number;
}

export function createDb(databaseUrl: string, options: CreateDbOptions = {}) {
  const sql = postgres(databaseUrl, { max: options.max ?? 10, onnotice: () => {} });
  const db = drizzle(sql, { schema, casing: 'snake_case' });
  return { db, sql, close: () => sql.end({ timeout: 5 }) };
}

export type Database = ReturnType<typeof createDb>['db'];
