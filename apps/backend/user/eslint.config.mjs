import base from "@repo/eslint-config";

const DB_ACCESS = {
  paths: [
    {
      name: "@/common/constants/provider_tokens.constants",
      importNames: ["databaseProviderToken", "databaseClientProviderToken"],
      message:
        "Only *.repository.ts files may query the database. Inject a repository instead (controller → service → repository).",
    },
  ],
  patterns: [
    {
      group: ["drizzle-orm", "drizzle-orm/*"],
      message:
        "Only *.repository.ts files may query the database. Inject a repository instead (controller → service → repository).",
    },
  ],
};

export default [
  ...base,
  {
    rules: {
      // Nest DI reads constructor parameter types at runtime; type-only imports would erase them.
      "@typescript-eslint/consistent-type-imports": "off",
      // Nest modules are often empty decorated classes.
      "@typescript-eslint/no-extraneous-class": "off",
    },
  },
  {
    // Layering: controllers and services never touch Drizzle.
    files: ["src/**/*.ts"],
    ignores: [
      "src/**/*.repository.ts",
      "src/modules/database/**",
      "src/modules/health/**",
    ],
    rules: { "no-restricted-imports": ["error", DB_ACCESS] },
  },
];
