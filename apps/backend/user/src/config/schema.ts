import { z } from "zod";

/** `FOO=` in .env means unset, not an empty value. */
const optional = <T extends z.ZodType>(schema: T) =>
  z.preprocess(
    (value) => (value === "" ? undefined : value),
    schema.optional(),
  );

/** Every environment variable the API reads. Validated once at startup. */
export const ENV = z
  .object({
    APP_ENV: z
      .enum(["development", "test", "production"])
      .default("development"),
    APP_PORT: z.coerce.number().int().positive().default(3000),
    LOG_LEVEL: z
      .enum(["fatal", "error", "warn", "info", "debug", "trace"])
      .default("info"),
    DATABASE_URL: z.url({ protocol: /^postgres(ql)?$/ }),
    DATABASE_POOL_MAX: z.coerce.number().int().positive().default(10),
    CORS_ORIGINS: z
      .string()
      .default("")
      .transform((value) =>
        value
          .split(",")
          .map((origin) => origin.trim())
          .filter(Boolean),
      ),
    /** Auth0 tenant host, e.g. `nihongo.jp.auth0.com`. No scheme, no slash. */
    AUTH0_DOMAIN: optional(
      z
        .string()
        .regex(/^[a-z0-9.-]+$/i, "host name only, e.g. nihongo.jp.auth0.com"),
    ),
    /** Identifier of the Auth0 API, e.g. `https://api.nihongo.app`. */
    AUTH0_AUDIENCE: optional(z.string()),
  })
  .refine(
    (env) =>
      env.APP_ENV !== "production" || (env.AUTH0_DOMAIN && env.AUTH0_AUDIENCE),
    {
      message: "AUTH0_DOMAIN and AUTH0_AUDIENCE are required in production",
      path: ["AUTH0_DOMAIN"],
    },
  );

export type ENV = z.infer<typeof ENV>;
