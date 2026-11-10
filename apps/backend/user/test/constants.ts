// No `@/` imports here: Jest's globalSetup does not apply moduleNameMapper.
export const TEST_DATABASE_URL =
  "postgres://nihongo:nihongo@localhost:5432/nihongo_test";
export const TEST_DOMAIN = "nihongo-test.auth0.local";
export const TEST_AUDIENCE = "https://api.nihongo.test";
