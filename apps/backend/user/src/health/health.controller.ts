import { Controller, Get } from '@nestjs/common';
import { HealthCheck, HealthCheckService } from '@nestjs/terminus';
import { DatabaseHealthIndicator } from './database.health.js';

/** Infrastructure endpoints. Deliberately plain Nest, not part of the oRPC contract. */
@Controller('health')
export class HealthController {
  constructor(
    private readonly health: HealthCheckService,
    private readonly database: DatabaseHealthIndicator,
  ) {}

  /** Liveness: the process is up. Never touches dependencies. */
  @Get('live')
  live() {
    return { status: 'ok' };
  }

  /** Readiness: the instance can serve traffic. Used by Fly.io health checks. */
  @Get()
  @HealthCheck()
  ready() {
    return this.health.check([() => this.database.isHealthy()]);
  }
}
