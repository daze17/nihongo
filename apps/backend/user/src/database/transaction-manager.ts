import { Injectable } from '@nestjs/common';
import type { Database } from '@repo/db';
import type { DbExecutor } from './db-executor.js';
import { InjectDb } from './inject-db.js';

/**
 * Runs several repository calls in one transaction.
 *
 *   await this.tx.run(async (tx) => {
 *     await this.progress.upsertMany(rows, tx);
 *     await this.stats.bumpXp(userId, xp, tx);
 *   });
 */
@Injectable()
export class TransactionManager {
  constructor(@InjectDb() private readonly db: Database) {}

  run<T>(fn: (tx: DbExecutor) => Promise<T>): Promise<T> {
    return this.db.transaction((tx) => fn(tx));
  }
}
