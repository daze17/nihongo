import { Global, Module } from '@nestjs/common';
import { AppConfig } from './app-config.js';
import { parseEnv } from './env.js';

@Global()
@Module({
  providers: [{ provide: AppConfig, useFactory: () => new AppConfig(parseEnv()) }],
  exports: [AppConfig],
})
export class ConfigModule {}
