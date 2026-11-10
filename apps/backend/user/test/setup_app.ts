import {
  FastifyAdapter,
  type NestFastifyApplication,
} from "@nestjs/platform-fastify";
import { Test } from "@nestjs/testing";

import { auth0KeysProviderToken } from "@/common/constants/provider_tokens.constants";
import { AppModule } from "@/modules/app/app.module";
import { setupApp } from "@/setup_app";

import { fakeAuth0 } from "./fake_auth0";

/** Boots the real app on Fastify, with Auth0's keys replaced by a local key set. */
export const createTestApp = async () => {
  const auth0 = await fakeAuth0();
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(auth0KeysProviderToken)
    .useValue(auth0.keys)
    .compile();

  const app = setupApp(
    moduleRef.createNestApplication<NestFastifyApplication>(
      new FastifyAdapter(),
      { bufferLogs: true },
    ),
  );
  await app.init();
  await app.getHttpAdapter().getInstance().ready();

  return { app, auth0 };
};
