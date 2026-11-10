import { defineConfig } from "tsup";

export default defineConfig({
  // bin/* are CLI entries (top-level await), kept out of the package index.
  entry: [
    "src/index.ts",
    "src/schema/index.ts",
    "src/bin/migrate.ts",
    "src/bin/seed.ts",
  ],
  format: ["esm"],
  dts: true,
  sourcemap: true,
  clean: true,
  splitting: true,
  treeshake: true,
});
