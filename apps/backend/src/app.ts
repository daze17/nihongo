import 'reflect-metadata';
import { type INestApplication, VersioningType } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { Logger } from 'nestjs-pino';
import { AppModule } from './app.module.js';
import { ProblemDetailsFilter } from './common/problem-details.filter.js';
import { AppConfig } from './config/app-config.js';

/** Builds and configures the app. Shared by main.ts, the OpenAPI script and e2e tests. */
export async function createApp(): Promise<INestApplication> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, { bufferLogs: true });
  app.disable('x-powered-by');
  const config = app.get(AppConfig);

  app.useLogger(app.get(Logger));
  app.enableShutdownHooks();
  app.enableVersioning({ type: VersioningType.URI, defaultVersion: '1' });
  app.useGlobalFilters(new ProblemDetailsFilter());
  app.enableCors({ origin: config.env.CORS_ORIGINS.length ? config.env.CORS_ORIGINS : false });

  return app;
}

export function buildOpenApi(app: INestApplication) {
  const doc = new DocumentBuilder()
    .setTitle('Nihongo API')
    .setDescription('Auth, sync and content for the Nihongo mobile app')
    .setVersion('1')
    .addBearerAuth()
    .build();
  return SwaggerModule.createDocument(app, doc);
}
