import type { Database } from '@repo/db';

/** Either the root client or an open transaction. Repository methods accept one so callers can compose them in a transaction. */
export type DbExecutor = Database | Parameters<Parameters<Database['transaction']>[0]>[0];
