import { OpenAPIGenerator } from '@orpc/openapi';
import { ZodToJsonSchemaConverter } from '@orpc/zod/zod4';
import { contract } from './contract.js';

const generator = new OpenAPIGenerator({ schemaConverters: [new ZodToJsonSchemaConverter()] });

/** Builds the OpenAPI document straight from the contract. No server or database needed. */
export function generateOpenApi(servers: { url: string; description?: string }[] = []) {
  return generator.generate(contract, {
    info: {
      title: 'Nihongo API',
      version: '1',
      description: 'Auth, sync and content for the Nihongo mobile app.',
    },
    servers,
  });
}
