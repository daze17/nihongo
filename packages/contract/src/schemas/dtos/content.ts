import { z } from "zod";

export const ContentManifestResponseBody = z.object({
  /** Bumped every time content is published. The app re-downloads when it changes. */
  version: z.number().int().positive(),
  publishedAt: z.iso.datetime(),
  counts: z.object({ kana: z.number().int().nonnegative() }),
});
export type ContentManifestResponseBody = z.infer<
  typeof ContentManifestResponseBody
>;
