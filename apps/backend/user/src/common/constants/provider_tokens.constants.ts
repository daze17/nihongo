/** postgres.js client and its `close()`; closed on shutdown. */
export const databaseClientProviderToken = Symbol("DATABASE_CLIENT");

/** Drizzle client. Only `*.repository.ts` files inject it. */
export const databaseProviderToken = Symbol("DATABASE");

/** Key set that checks Auth0 token signatures. Replaced with a local key set in tests. */
export const auth0KeysProviderToken = Symbol("AUTH0_KEYS");
