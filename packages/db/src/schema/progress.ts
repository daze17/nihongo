import { sql } from 'drizzle-orm';
import {
  date,
  doublePrecision,
  index,
  integer,
  pgEnum,
  pgTable,
  primaryKey,
  real,
  smallint,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';
import { users } from './users.js';

const updatedAt = () =>
  timestamp('updated_at', { withTimezone: true })
    .notNull()
    .defaultNow()
    .$onUpdate(() => sql`now()`);

/** One row per user. Mirrors the app's local user_stats table for sync. */
export const userStats = pgTable('user_stats', {
  userId: uuid('user_id')
    .primaryKey()
    .references(() => users.id, { onDelete: 'cascade' }),
  totalXp: integer('total_xp').notNull().default(0),
  currentStreak: integer('current_streak').notNull().default(0),
  longestStreak: integer('longest_streak').notNull().default(0),
  lastActiveDate: date('last_active_date'),
  /** IANA zone, used by the nightly streak audit. */
  timezone: text('timezone').notNull().default('UTC'),
  streakFreezes: smallint('streak_freezes').notNull().default(0),
  hearts: smallint('hearts').notNull().default(5),
  heartsRefillAt: timestamp('hearts_refill_at', { withTimezone: true }),
  gems: integer('gems').notNull().default(0),
  updatedAt: updatedAt(),
});

export const lessonProgress = pgTable(
  'lesson_progress',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    lessonId: text('lesson_id').notNull(),
    completedAt: timestamp('completed_at', { withTimezone: true }),
    bestAccuracy: real('best_accuracy'),
    attempts: integer('attempts').notNull().default(0),
    updatedAt: updatedAt(),
  },
  (t) => [
    primaryKey({ columns: [t.userId, t.lessonId] }),
    index('lesson_progress_user_updated_idx').on(t.userId, t.updatedAt),
  ],
);

export const itemType = pgEnum('item_type', ['kana', 'kanji', 'vocab', 'sentence']);

/** FSRS state per learnable item. The scheduler runs on device; this is the synced copy. */
export const itemReviews = pgTable(
  'item_reviews',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    itemId: text('item_id').notNull(),
    itemType: itemType('item_type').notNull(),
    stability: doublePrecision('stability').notNull(),
    difficulty: doublePrecision('difficulty').notNull(),
    due: timestamp('due', { withTimezone: true }).notNull(),
    lastReview: timestamp('last_review', { withTimezone: true }),
    reps: integer('reps').notNull().default(0),
    lapses: integer('lapses').notNull().default(0),
    updatedAt: updatedAt(),
  },
  (t) => [
    primaryKey({ columns: [t.userId, t.itemId] }),
    index('item_reviews_user_due_idx').on(t.userId, t.due),
    index('item_reviews_user_updated_idx').on(t.userId, t.updatedAt),
  ],
);

export const achievementsUnlocked = pgTable(
  'achievements_unlocked',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    achievementId: text('achievement_id').notNull(),
    unlockedAt: timestamp('unlocked_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.achievementId] })],
);

export const syncLog = pgTable(
  'sync_log',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    deviceId: text('device_id').notNull(),
    syncedAt: timestamp('synced_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [primaryKey({ columns: [t.userId, t.deviceId] })],
);
