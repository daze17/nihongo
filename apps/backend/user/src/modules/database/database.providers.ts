import { ConfigService } from "@nestjs/config";
import { createDb, type Database } from "@repo/db";

import {
  databaseClientProviderToken,
  databaseProviderToken,
} from "@/common/constants/provider_tokens.constants";
import type { Configuration } from "@/config/configuration";

export type { Database } from "@repo/db";

export type DatabaseClient = ReturnType<typeof createDb>;

/** Either the root client or an open transaction. Repository methods accept one so callers can compose them. */
export type DbExecutor =
  Database | Parameters<Parameters<Database["transaction"]>[0]>[0];

export const databaseProviders = [
  {
    provide: databaseClientProviderToken,
    inject: [ConfigService],
    useFactory: (
      configService: ConfigService<Configuration, true>,
    ): DatabaseClient => {
      const { url, poolMax } = configService.get("database", { infer: true });
      return createDb(url, { max: poolMax });
    },
  },
  {
    provide: databaseProviderToken,
    inject: [databaseClientProviderToken],
    useFactory: (client: DatabaseClient) => client.db,
  },
];
