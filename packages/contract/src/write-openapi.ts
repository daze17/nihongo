import { mkdirSync, writeFileSync } from 'node:fs';
import { generateOpenApi } from './openapi.js';

// `pnpm --filter @repo/contract openapi` → dist/openapi.json, input for the Dart client generator.
const doc = await generateOpenApi([{ url: 'http://localhost:3000', description: 'local' }]);
mkdirSync('dist', { recursive: true });
writeFileSync('dist/openapi.json', JSON.stringify(doc, null, 2));
console.log(`openapi.json written (${Object.keys(doc.paths ?? {}).length} paths)`);
