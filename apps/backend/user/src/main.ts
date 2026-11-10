import { NestFactory } from "@nestjs/core";
import {
  FastifyAdapter,
  type NestFastifyApplication,
} from "@nestjs/platform-fastify";
import { ConfigService } from "@nestjs/config";

import type { Configuration } from "@/config/configuration";
import { AppModule } from "@/modules/app/app.module";
import { setupApp } from "@/setup_app";

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(),
    { bufferLogs: true },
  );
  setupApp(app);

  const configService = app.get(ConfigService<Configuration, true>);
  await app.listen(configService.get("app.port", { infer: true }), "0.0.0.0");
}

void bootstrap();
