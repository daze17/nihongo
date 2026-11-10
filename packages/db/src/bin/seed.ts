// CLI entry, kept out of the package index: top-level await cannot be require()d.
import { seed } from "../seed";

const url = process.env.DATABASE_URL;
if (!url) throw new Error("DATABASE_URL is not set");
console.log("seeded", await seed(url));
