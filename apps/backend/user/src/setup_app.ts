import { ConfigService } from "@nestjs/config";
import type { NestFastifyApplication } from "@nestjs/platform-fastify";
import { Logger } from "nestjs-pino";

import { AllExceptionsFilter } from "@/common/exception_filters/all_exceptions.filter";
import { HttpExceptionsFilter } from "@/common/exception_filters/http_exceptions.filter";
import type { Configuration } from "@/config/configuration";

/** Shared by main.ts and the e2e tests so both run the same app. */
export const setupApp = (app: NestFastifyApplication) => {
  const configService = app.get(ConfigService<Configuration, true>);
  const logger = app.get(Logger);

  app.useLogger(logger);
  app.enableShutdownHooks();
  // Nest tries filters last-registered first: HttpException → problem, anything else → 500.
  app.useGlobalFilters(
    new AllExceptionsFilter(logger),
    new HttpExceptionsFilter(logger),
  );

  const corsOrigins = configService.get("app.corsOrigins", { infer: true });
  if (corsOrigins.length > 0) {
    app.enableCors({ origin: corsOrigins, credentials: true });
  }

  return app;
};
