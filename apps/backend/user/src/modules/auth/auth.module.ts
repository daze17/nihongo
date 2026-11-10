import { Global, Module } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { APP_GUARD } from "@nestjs/core";

import { auth0KeysProviderToken } from "@/common/constants/provider_tokens.constants";
import { Auth0AuthGuard } from "@/common/guards/auth0_auth.guard";

import {
  auth0KeysFactory,
  Auth0VerifierService,
} from "./auth0_verifier.service";

/** Auth0 token verification. Sign-in UI and social providers live in Auth0. */
@Global()
@Module({
  providers: [
    {
      provide: auth0KeysProviderToken,
      inject: [ConfigService],
      useFactory: auth0KeysFactory,
    },
    Auth0VerifierService,
    { provide: APP_GUARD, useClass: Auth0AuthGuard },
  ],
  exports: [Auth0VerifierService],
})
export class AuthModule {}
