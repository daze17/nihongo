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
pnpm backend:dev                     # NestJS on :3000, Swagger at /docs
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
apps/backend         NestJS 12 API: config, Drizzle, health, content, problem+json errors
packages/schema      zod schemas, source of truth
packages/db          Drizzle client, schema and migrations
packages/content     content pipeline (dictionary data -> lesson JSON)
packages/tsconfig    shared tsconfig presets
packages/eslint-config
```

## API endpoints so far

| Route                      | Purpose                    |
| -------------------------- | -------------------------- |
| `GET /health/live`         | Liveness, no dependencies  |
| `GET /health`              | Readiness, pings Postgres  |
| `GET /v1/content/manifest` | Content version and counts |
| `GET /v1/content/kana`     | Kana rows from Postgres    |
| `GET /docs`                | Swagger UI, dev only       |

## Backend in Docker

```sh
docker build -f apps/backend/Dockerfile -t nihongo-backend .
docker run --rm --network nihongo_default -p 3100:8080 \
  -e DATABASE_URL=postgres://nihongo:nihongo@postgres:5432/nihongo nihongo-backend
```

TypeScript is pinned to 6.x because typescript-eslint and the NestJS CLI do not support TypeScript 7 yet.
# nihongo
