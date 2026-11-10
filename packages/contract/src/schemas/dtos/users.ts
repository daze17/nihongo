import { z } from "zod";

export const MeResponseBody = z.object({
  id: z.uuid(),
  email: z.email().nullable(),
  emailVerified: z.boolean(),
  name: z.string().nullable(),
  pictureUrl: z.url().nullable(),
  createdAt: z.iso.datetime(),
});
export type MeResponseBody = z.infer<typeof MeResponseBody>;
