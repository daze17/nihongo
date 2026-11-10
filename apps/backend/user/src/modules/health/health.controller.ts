import { Controller, Get } from "@nestjs/common";
import { HealthCheck, HealthCheckService } from "@nestjs/terminus";

import { Public } from "@/common/decorators/public";

import { HealthService } from "./health.service";

/** Infrastructure endpoints. Plain Nest, not part of the oRPC contract. */
@Public()
@Controller("health")
export class HealthController {
  constructor(
    private readonly healthCheckService: HealthCheckService,
    private readonly healthService: HealthService,
  ) {}

  /** Liveness: the process is up. Never touches dependencies. */
  @Get("live")
  live() {
    return { status: "ok" };
  }

  /** Readiness: the instance can serve traffic. Used by Fly.io health checks. */
  @Get()
  @HealthCheck()
  ready() {
    return this.healthCheckService.check([
      () => this.healthService.isDatabaseHealthy(),
    ]);
  }
}
