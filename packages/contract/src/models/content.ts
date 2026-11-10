import {
  contentManifest,
  kana,
  kanji,
  lessons,
  sentences,
  units,
  vocab,
} from "@repo/db/schema";
import { createSelectSchema } from "drizzle-zod";
import type { z } from "zod";

export const KanaModel = createSelectSchema(kana);
export type KanaModel = z.infer<typeof KanaModel>;

export const KanjiModel = createSelectSchema(kanji);
export type KanjiModel = z.infer<typeof KanjiModel>;

export const VocabModel = createSelectSchema(vocab);
export type VocabModel = z.infer<typeof VocabModel>;

export const SentenceModel = createSelectSchema(sentences);
export type SentenceModel = z.infer<typeof SentenceModel>;

export const UnitModel = createSelectSchema(units);
export type UnitModel = z.infer<typeof UnitModel>;

export const LessonModel = createSelectSchema(lessons);
export type LessonModel = z.infer<typeof LessonModel>;

export const ContentManifestModel = createSelectSchema(contentManifest);
export type ContentManifestModel = z.infer<typeof ContentManifestModel>;
