import {
  Global,
  Inject,
  Module,
  type OnApplicationShutdown,
} from "@nestjs/common";

import { databaseClientProviderToken } from "@/common/constants/provider_tokens.constants";

import { type DatabaseClient, databaseProviders } from "./database.providers";
import { TransactionWorkService } from "./transaction_work.service";

@Global()
@Module({
  providers: [...databaseProviders, TransactionWorkService],
  exports: [...databaseProviders, TransactionWorkService],
})
export class DatabaseModule implements OnApplicationShutdown {
  constructor(
    @Inject(databaseClientProviderToken)
    private readonly client: DatabaseClient,
  ) {}

  async onApplicationShutdown() {
    await this.client.close();
  }
}
