import { Module } from '@nestjs/common';
import { LoggerModule } from 'nestjs-pino';
import { AppConfig } from './config/app-config.js';
import { ConfigModule } from './config/config.module.js';
import { DatabaseModule } from './database/database.module.js';
import { DocsModule } from './docs/docs.module.js';
import { HealthModule } from './health/health.module.js';
import { OrpcModule } from './orpc/orpc.module.js';
import { ContentModule } from './content/content.module.js';

@Module({
  imports: [
    ConfigModule,
    LoggerModule.forRootAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({
        pinoHttp: {
          level: config.env.LOG_LEVEL,
          redact: ['req.headers.authorization', 'req.headers.cookie'],
          autoLogging: { ignore: (req) => req.url?.startsWith('/health') ?? false },
          transport: config.isProduction
            ? undefined
            : { target: 'pino-pretty', options: { singleLine: true } },
        },
      }),
    }),
    DatabaseModule,
    OrpcModule,
    HealthModule,
    ContentModule,
    DocsModule,
  ],
})
export class AppModule {}
