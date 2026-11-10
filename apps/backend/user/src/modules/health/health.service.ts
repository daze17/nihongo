import { Inject, Injectable } from "@nestjs/common";
import { HealthIndicatorService } from "@nestjs/terminus";

import { databaseClientProviderToken } from "@/common/constants/provider_tokens.constants";
import type { DatabaseClient } from "@/modules/database/database.providers";

@Injectable()
export class HealthService {
  constructor(
    @Inject(databaseClientProviderToken)
    private readonly client: DatabaseClient,
    private readonly healthIndicatorService: HealthIndicatorService,
  ) {}

  async isDatabaseHealthy(key = "database") {
    const indicator = this.healthIndicatorService.check(key);
    const started = performance.now();
    try {
      await this.client.sql`select 1`;
      return indicator.up({
        latencyMs: Math.round(performance.now() - started),
      });
    } catch (error) {
      return indicator.down({
        message: error instanceof Error ? error.message : String(error),
      });
    }
  }
}
