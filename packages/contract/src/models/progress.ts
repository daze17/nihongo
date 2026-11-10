import {
  achievementsUnlocked,
  itemReviews,
  lessonProgress,
  syncLog,
  userStats,
} from "@repo/db/schema";
import { createSelectSchema } from "drizzle-zod";
import type { z } from "zod";

export const UserStatsModel = createSelectSchema(userStats);
export type UserStatsModel = z.infer<typeof UserStatsModel>;

export const LessonProgressModel = createSelectSchema(lessonProgress);
export type LessonProgressModel = z.infer<typeof LessonProgressModel>;

export const ItemReviewModel = createSelectSchema(itemReviews);
export type ItemReviewModel = z.infer<typeof ItemReviewModel>;

export const AchievementUnlockedModel =
  createSelectSchema(achievementsUnlocked);
export type AchievementUnlockedModel = z.infer<typeof AchievementUnlockedModel>;

export const SyncLogModel = createSelectSchema(syncLog);
export type SyncLogModel = z.infer<typeof SyncLogModel>;
