import { users } from "@repo/db/schema";
import { createSelectSchema } from "drizzle-zod";
import type { z } from "zod";

export const UserModel = createSelectSchema(users);
export type UserModel = z.infer<typeof UserModel>;
