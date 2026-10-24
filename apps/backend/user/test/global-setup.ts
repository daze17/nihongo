import { createDb, runMigrations, seed } from '@repo/db';

/**
 * Runs once before the e2e suite against the docker-compose Postgres
 * (`pnpm services:up`). Recreates a dedicated test database so runs are
 * isolated from dev data and from each other.
 */
export default async function setup() {
  const adminUrl = process.env.DATABASE_URL ?? 'postgres://nihongo:nihongo@localhost:5432/nihongo';
  const testUrl = new URL(adminUrl);
  testUrl.pathname = '/nihongo_test';

  const { sql: admin, close } = createDb(adminUrl, { max: 1 });
  try {
    await admin`select 1`;
  } catch {
    throw new Error(`Postgres is not reachable at ${adminUrl}. Run \`pnpm services:up\` first.`);
  }
  await admin.unsafe('drop database if exists nihongo_test with (force)');
  await admin.unsafe('create database nihongo_test');
  await close();

  await runMigrations(testUrl.toString());
  await seed(testUrl.toString());

  process.env.TEST_DATABASE_URL = testUrl.toString();
}
