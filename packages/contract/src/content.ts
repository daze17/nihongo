import { oc } from '@orpc/contract';
import { Kana } from '@repo/schema';
import { z } from 'zod';

export const ContentManifest = z.object({
  /** Bumped every time content is published. The app re-downloads when it changes. */
  version: z.number().int().positive(),
  publishedAt: z.iso.datetime(),
  counts: z.object({ kana: z.number().int().nonnegative() }),
});
export type ContentManifest = z.infer<typeof ContentManifest>;

export const contentContract = {
  manifest: oc
    .route({
      method: 'GET',
      path: '/v1/content/manifest',
      summary: 'Current content version',
      tags: ['content'],
    })
    .output(ContentManifest),

  kana: oc
    .route({
      method: 'GET',
      path: '/v1/content/kana',
      summary: 'All kana entries',
      tags: ['content'],
    })
    .output(z.array(Kana)),
};
