# syntax=docker/dockerfile:1.7
# Build from the repo root:  docker build -f apps/backend/Dockerfile -t nihongo-backend .

FROM node:22-slim AS base
ENV PNPM_HOME=/pnpm PATH=/pnpm:$PATH
RUN corepack enable
WORKDIR /repo

# 1. Fetch deps using only the lockfile, so this layer caches across source changes.
FROM base AS deps
COPY pnpm-lock.yaml pnpm-workspace.yaml package.json ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch

# 2. Build the api and the workspace packages it depends on.
FROM deps AS build
COPY . .
RUN --mount=type=cache,id=pnpm,target=/pnpm/store \
    pnpm install --offline --frozen-lockfile --filter "backend..." \
 && pnpm turbo run build --filter=backend \
 && pnpm --filter=backend deploy --prod --legacy /out \
 && cp -r packages/db/migrations /out/migrations

# 3. Minimal runtime: compiled JS, prod deps, migrations.
FROM node:22-slim AS runtime
ENV NODE_ENV=production PORT=8080
WORKDIR /app
COPY --from=build --chown=node:node /out ./
USER node
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=3s --start-period=10s \
  CMD node -e "fetch('http://127.0.0.1:'+process.env.PORT+'/health/live').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["node", "dist/main.js"]
