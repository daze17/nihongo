// CLI entry, kept out of the package index: top-level await cannot be require()d.
import { runMigrations } from "../migrate";

const url = process.env.DATABASE_URL;
if (!url) throw new Error("DATABASE_URL is not set");
await runMigrations(url);
console.log("migrations applied");
