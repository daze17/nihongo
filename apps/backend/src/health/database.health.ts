import { Inject, Injectable } from '@nestjs/common';
import { HealthIndicatorService } from '@nestjs/terminus';
import type { createDb } from '@repo/db';
import { DB_HANDLE } from '../database/database.module.js';

@Injectable()
export class DatabaseHealthIndicator {
  constructor(
    @Inject(DB_HANDLE) private readonly handle: ReturnType<typeof createDb>,
    private readonly health: HealthIndicatorService,
  ) {}

  async isHealthy(key = 'database') {
    const indicator = this.health.check(key);
    const started = performance.now();
    try {
      await this.handle.sql`select 1`;
      return indicator.up({ latencyMs: Math.round(performance.now() - started) });
    } catch (err) {
      return indicator.down({ message: err instanceof Error ? err.message : String(err) });
    }
  }
}
