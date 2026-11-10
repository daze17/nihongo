import { parseEnv } from "./configuration";

const base = { DATABASE_URL: "postgres://u:p@localhost:5432/db" };

describe("parseEnv", () => {
  it("applies defaults", () => {
    const env = parseEnv(base);
    expect(env.APP_PORT).toBe(3000);
    expect(env.APP_ENV).toBe("development");
    expect(env.CORS_ORIGINS).toEqual([]);
  });

  it("requires Auth0 settings in production only", () => {
    expect(() => parseEnv({ ...base, APP_ENV: "production" })).toThrow(
      /AUTH0_DOMAIN/,
    );
    expect(() => parseEnv({ ...base, APP_ENV: "development" })).not.toThrow();
    const env = parseEnv({
      ...base,
      APP_ENV: "production",
      AUTH0_DOMAIN: "nihongo.jp.auth0.com",
      AUTH0_AUDIENCE: "https://api.nihongo.app",
    });
    expect(env.AUTH0_DOMAIN).toBe("nihongo.jp.auth0.com");
  });

  it("treats an empty value as unset", () => {
    expect(
      parseEnv({ ...base, AUTH0_DOMAIN: "" }).AUTH0_DOMAIN,
    ).toBeUndefined();
  });

  it("rejects a non-postgres database url", () => {
    expect(() => parseEnv({ DATABASE_URL: "mysql://localhost/db" })).toThrow(
      /DATABASE_URL/,
    );
  });

  it("splits CORS origins", () => {
    const env = parseEnv({
      ...base,
      CORS_ORIGINS: "https://a.dev, https://b.dev",
    });
    expect(env.CORS_ORIGINS).toEqual(["https://a.dev", "https://b.dev"]);
  });
});
