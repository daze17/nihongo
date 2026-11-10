import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/index.ts", "src/write-openapi.ts"],
  format: ["esm"],
  dts: true,
  sourcemap: true,
  clean: true,
  splitting: true,
  treeshake: true,
});
