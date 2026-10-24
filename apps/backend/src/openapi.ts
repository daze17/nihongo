import { mkdirSync, writeFileSync } from 'node:fs';
import { buildOpenApi, createApp } from './app.js';

// Writes dist/openapi.json without starting the server. The Dart client is generated from it.
const app = await createApp();
const doc = buildOpenApi(app);
mkdirSync('dist', { recursive: true });
writeFileSync('dist/openapi.json', JSON.stringify(doc, null, 2));
await app.close();
console.log(`openapi.json written (${Object.keys(doc.paths).length} paths)`);
