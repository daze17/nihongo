import { TEST_AUDIENCE, TEST_DATABASE_URL, TEST_DOMAIN } from "./constants";

// ConfigModule validates the environment when AppModule is imported, so set it first.
Object.assign(process.env, {
  APP_ENV: "test",
  LOG_LEVEL: "warn",
  DATABASE_URL: TEST_DATABASE_URL,
  AUTH0_DOMAIN: TEST_DOMAIN,
  AUTH0_AUDIENCE: TEST_AUDIENCE,
});
