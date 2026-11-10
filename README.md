# Nihongo

Duolingo-style Japanese learning app. Flutter mobile app and TypeScript packages in a Turborepo monorepo.
See [PLAN.md](PLAN.md) for the full build plan.

## Requirements

- Flutter stable, Xcode + CocoaPods, Android Studio
- Node 22 (`nvm use` reads `.nvmrc`) and pnpm 10
- Docker Desktop

## Getting started

```sh
nvm use
pnpm install
cp .env.example .env        # already matches docker-compose defaults
pnpm services:up            # Docker: postgres :5432, redis :6380, minio :9000 (console :9001)
pnpm db:migrate && pnpm db:seed
(cd apps/mobile && flutter pub get)
```

## Everyday commands

```sh
pnpm turbo run lint typecheck test   # everything, cached
pnpm --filter mobile dev             # flutter run
pnpm backend:dev                     # user API (apps/backend/user) on :3000, API reference at /docs
pnpm test:e2e                        # API e2e against the Docker Postgres (db nihongo_test)
pnpm db:generate                     # new migration after editing packages/db/src/schema
pnpm db:studio                       # browse the database
pnpm --filter @repo/schema test      # one package
pnpm format                          # prettier for TS/JSON/YAML
pnpm --filter mobile format          # dart format
pnpm services:down
```

## Layout

```
apps/mobile          Flutter app (scripts in package.json bridge to Turbo)
apps/backend/user    NestJS 12 API for the mobile app, implementing the oRPC contract
apps/backend/admin   (later) NestJS API for the admin and teacher web app
packages/schema      zod schemas, source of truth
packages/contract    oRPC contract: every endpoint's path, input and output
packages/db          Drizzle client, schema and migrations
packages/content     content pipeline (dictionary data -> lesson JSON)
packages/tsconfig    shared tsconfig presets
packages/eslint-config
```

## Backend layers

```
controller  ──▶  service  ──▶  repository  ──▶  Postgres (Drizzle)
oRPC contract    business rules   queries only
```

- **Controller** implements the oRPC contract and calls a service. No logic.
- **Service** holds the business rules and throws `ORPCError`. It never touches the database.
- **Repository** (`*.repository.ts`) is the only place that imports Drizzle. It returns plain rows. Each method takes an optional transaction so services can combine calls with `TransactionManager.run()`.

Backend apps live in `apps/backend/`:

- `apps/backend/user` is the API the mobile app calls: content today, then auth, profile and sync.
- `apps/backend/admin` will be a separate API for the admin and teacher web app, with its own guards and deploy.

Both share `packages/contract`, `packages/db` and `packages/schema`.

ESLint enforces this: importing `drizzle-orm` or the database injector outside a repository fails `pnpm lint`.

## Adding an endpoint

1. Declare it in `packages/contract` with `oc.route({ method, path })`, `.input()` and `.output()` zod schemas.
2. Add the query to a repository, the logic to a service, and implement the route in a controller with `@Implement(contract.x.y)`. Throw `ORPCError('NOT_FOUND', ...)` from the service for expected errors.
3. `pnpm --filter @repo/contract openapi` writes `packages/contract/dist/openapi.json` for the Dart client.

Every error, from oRPC or Nest, comes back as `application/problem+json`.

## API endpoints so far

| Route                      | Purpose                                            |
| -------------------------- | -------------------------------------------------- |
| `GET /health/live`         | Liveness, no dependencies                          |
| `GET /health`              | Readiness, pings Postgres                          |
| `GET /v1/content/manifest` | Content version and counts                         |
| `GET /v1/content/kana`     | Kana rows from Postgres                            |
| `GET /v1/me`               | Signed-in user, created on first call (Auth0)      |
| `GET /openapi.json`        | OpenAPI spec generated from the contract, dev only |
| `GET /docs`                | Scalar API reference, dev only                     |

## Auth0 setup

Sign-in (Google, Facebook, Apple, email) runs on Auth0. The API only checks Auth0 access
tokens (`apps/backend/user/src/auth`) and creates a `users` row on the first `GET /v1/me`.
Without Auth0 settings the app stays in guest mode and `/v1/me` answers 503.

1. Create an Auth0 tenant. The Japan region is closest to Mongolia.
2. **APIs → Create API**: identifier `https://api.nihongo.app`, signing RS256. Turn on
   **Allow Offline Access** so the app gets refresh tokens.
3. **Applications → Create Application → Native**, then set both lists below. Replace
   `DOMAIN` with your tenant domain. Turn on refresh token rotation.
   - Allowed Callback URLs and Allowed Logout URLs:
     ```
     com.bilguun.nihongo://DOMAIN/ios/com.bilguun.nihongo/callback,
     com.bilguun.nihongo://DOMAIN/android/com.bilguun.nihongo/callback
     ```
4. **Authentication → Social**: add Google, Facebook and Apple, and enable each for the
   native app. Auth0's built-in Google keys only work for testing. Production needs your own
   Google OAuth client, a Meta app (public Facebook login needs Meta's app review), and an
   Apple Services ID with a Sign in with Apple key. Email sign-in uses the default database
   connection or Passwordless email.
5. **Actions → Library → Create Action (Post Login)**, deploy it, and add it to the Login flow.
   Access tokens only carry the user id by default; this adds the profile the API stores:

   ```js
   exports.onExecutePostLogin = async (event, api) => {
     const ns = "https://nihongo.app/";
     const u = event.user;
     if (u.email) {
       api.accessToken.setCustomClaim(ns + "email", u.email);
       api.accessToken.setCustomClaim(
         ns + "email_verified",
         Boolean(u.email_verified),
       );
     }
     if (u.name) api.accessToken.setCustomClaim(ns + "name", u.name);
     if (u.picture) api.accessToken.setCustomClaim(ns + "picture", u.picture);
   };
   ```

6. Backend: set `AUTH0_DOMAIN` and `AUTH0_AUDIENCE` in `.env`.
7. Mobile: copy `apps/mobile/config/dev.example.json` to `apps/mobile/config/dev.json` and fill
   it in. `pnpm dev` passes it to `flutter run`. Android reads the same file for its callback.

## User API in Docker

```sh
docker build -f apps/backend/user/Dockerfile -t nihongo-backend-user .
docker run --rm --network nihongo_default -p 3100:8080 \
  -e DATABASE_URL=postgres://nihongo:nihongo@postgres:5432/nihongo nihongo-backend-user
```

TypeScript is pinned to 6.x because typescript-eslint and the NestJS CLI do not support TypeScript 7 yet.

# nihongo
