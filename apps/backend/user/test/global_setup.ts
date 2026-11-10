import { createDb, runMigrations, seed } from "@repo/db";

import { TEST_DATABASE_URL } from "./constants";

/**
 * Runs once before the e2e suite against the docker-compose Postgres
 * (`pnpm services:up`). Recreates a dedicated test database so runs are
 * isolated from dev data and from each other.
 */
export default async function globalSetup() {
  const adminUrl = new URL(TEST_DATABASE_URL);
  adminUrl.pathname = "/nihongo";

  const { sql: admin, close } = createDb(adminUrl.toString(), { max: 1 });
  try {
    await admin`select 1`;
  } catch {
    throw new Error(
      `Postgres is not reachable at ${adminUrl.host}. Run \`pnpm services:up\` first.`,
    );
  }
  await admin.unsafe("drop database if exists nihongo_test with (force)");
  await admin.unsafe("create database nihongo_test");
  await close();

  await runMigrations(TEST_DATABASE_URL);
  await seed(TEST_DATABASE_URL);
}
