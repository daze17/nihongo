import { Global, Inject, Module, type OnApplicationShutdown } from '@nestjs/common';
import { createDb } from '@repo/db';
import { AppConfig } from '../config/app-config.js';

export const DB_HANDLE = Symbol('DB_HANDLE');
export const DRIZZLE = Symbol('DRIZZLE');

type DbHandle = ReturnType<typeof createDb>;

@Global()
@Module({
  providers: [
    {
      provide: DB_HANDLE,
      inject: [AppConfig],
      useFactory: (config: AppConfig): DbHandle =>
        createDb(config.env.DATABASE_URL, { max: config.env.DATABASE_POOL_MAX }),
    },
    { provide: DRIZZLE, inject: [DB_HANDLE], useFactory: (h: DbHandle) => h.db },
  ],
  exports: [DRIZZLE, DB_HANDLE],
})
export class DatabaseModule implements OnApplicationShutdown {
  constructor(@Inject(DB_HANDLE) private readonly handle: DbHandle) {}

  async onApplicationShutdown() {
    await this.handle.close();
  }
}
