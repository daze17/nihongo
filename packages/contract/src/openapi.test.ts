import { describe, expect, it } from 'vitest';
import { generateOpenApi } from './openapi.js';

describe('generateOpenApi', () => {
  it('includes every contract path with its method', async () => {
    const doc = await generateOpenApi();
    expect(Object.keys(doc.paths ?? {}).sort()).toEqual([
      '/v1/content/kana',
      '/v1/content/manifest',
    ]);
    expect(doc.paths?.['/v1/content/manifest']?.get).toBeDefined();
  });

  it('derives response schemas from zod', async () => {
    const doc = await generateOpenApi();
    const res = doc.paths?.['/v1/content/kana']?.get?.responses?.['200'] as {
      content: Record<string, { schema: { type: string } }>;
    };
    expect(res.content['application/json']?.schema.type).toBe('array');
  });
});
