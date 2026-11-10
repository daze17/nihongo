import { ENV } from "./schema";

/** Parses and validates environment variables. Throws one readable error. */
export const parseEnv = (
  source: Record<string, unknown> = process.env,
): ENV => {
  const result = ENV.safeParse(source);
  if (!result.success) {
    const issues = result.error.issues
      .map((issue) => `  ${issue.path.join(".")}: ${issue.message}`)
      .join("\n");
    throw new Error(`Invalid environment configuration:\n${issues}`);
  }
  return result.data;
};

/** ConfigModule `validate` hook: fails startup on a bad environment. */
export const validate = (config: Record<string, unknown>) => parseEnv(config);

/** Nested config read with `ConfigService.get("app.port", { infer: true })`. */
export const configuration = () => {
  const env = parseEnv();

  return {
    app: {
      env: env.APP_ENV,
      port: env.APP_PORT,
      isProduction: env.APP_ENV === "production",
      logLevel: env.LOG_LEVEL,
      corsOrigins: env.CORS_ORIGINS,
    },
    database: {
      url: env.DATABASE_URL,
      poolMax: env.DATABASE_POOL_MAX,
    },
    auth0: {
      domain: env.AUTH0_DOMAIN,
      audience: env.AUTH0_AUDIENCE,
    },
  };
};

export type Configuration = ReturnType<typeof configuration>;
