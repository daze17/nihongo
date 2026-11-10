import { Inject, Injectable } from "@nestjs/common";

import { databaseProviderToken } from "@/common/constants/provider_tokens.constants";

import type { Database, DbExecutor } from "./database.providers";

/**
 * Runs several repository calls in one transaction.
 *
 *   await this.transactionWorkService.run(async (tx) => {
 *     await this.progressRepository.upsertMany(rows, tx);
 *     await this.statsRepository.bumpXp(userId, xp, tx);
 *   });
 */
@Injectable()
export class TransactionWorkService {
  constructor(@Inject(databaseProviderToken) private readonly db: Database) {}

  run<T>(work: (tx: DbExecutor) => Promise<T>): Promise<T> {
    return this.db.transaction((tx) => work(tx));
  }
}
