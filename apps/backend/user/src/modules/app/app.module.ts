import { Module, RequestMethod } from "@nestjs/common";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { LoggerModule } from "nestjs-pino";

import {
  type Configuration,
  configuration,
  validate,
} from "@/config/configuration";
import { AuthModule } from "@/modules/auth/auth.module";
import { ContentModule } from "@/modules/content/content.module";
import { DatabaseModule } from "@/modules/database/database.module";
import { DocsModule } from "@/modules/docs/docs.module";
import { HealthModule } from "@/modules/health/health.module";
import { OrpcModule } from "@/modules/orpc/orpc.module";
import { UserModule } from "@/modules/user/user.module";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      ignoreEnvFile: true,
      load: [configuration],
      validate,
    }),
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService<Configuration, true>) => {
        const { logLevel, isProduction } = configService.get("app", {
          infer: true,
        });
        return {
          exclude: [
            { method: RequestMethod.ALL, path: "health" },
            { method: RequestMethod.ALL, path: "health/{*path}" },
          ],
          pinoHttp: {
            level: logLevel,
            redact: ["req.headers.authorization", "req.headers.cookie"],
            ...(isProduction
              ? {}
              : {
                  transport: {
                    target: "pino-pretty",
                    options: { singleLine: true },
                  },
                }),
          },
        };
      },
    }),
    DatabaseModule,
    OrpcModule,
    AuthModule,
    HealthModule,
    ContentModule,
    UserModule,
    DocsModule,
  ],
})
export class AppModule {}
