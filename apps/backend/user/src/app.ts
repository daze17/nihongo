import 'reflect-metadata';
import type { INestApplication } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { Logger } from 'nestjs-pino';
import { AppModule } from './app.module.js';
import { ProblemDetailsFilter } from './common/problem-details.filter.js';
import { AppConfig } from './config/app-config.js';

/** Builds and configures the app. Shared by main.ts and e2e tests. API routes and their /v1 prefix come from @repo/contract. */
export async function createApp(): Promise<INestApplication> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { bufferLogs: true });
  app.disable('x-powered-by');
  const config = app.get(AppConfig);

  app.useLogger(app.get(Logger));
  app.enableShutdownHooks();
  app.useGlobalFilters(new ProblemDetailsFilter());
  app.enableCors({ origin: config.env.CORS_ORIGINS.length ? config.env.CORS_ORIGINS : false });

  return app;
}
