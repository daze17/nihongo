import { fileURLToPath } from "node:url";
import { migrate } from "drizzle-orm/postgres-js/migrator";
import { createDb } from "./client";

const migrationsFolder = fileURLToPath(
  new URL("../migrations", import.meta.url),
);

/** Applies pending migrations. Used by `pnpm db:migrate`, tests and the deploy release step. */
export async function runMigrations(databaseUrl: string) {
  const { db, close } = createDb(databaseUrl, { max: 1 });
  try {
    await migrate(db, { migrationsFolder });
  } finally {
    await close();
  }
}
