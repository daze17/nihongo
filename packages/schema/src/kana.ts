import { z } from 'zod';

export const KanaScript = z.enum(['hiragana', 'katakana']);
export type KanaScript = z.infer<typeof KanaScript>;

/** A single kana character, e.g. あ / a. */
export const Kana = z.object({
  id: z.string().regex(/^(hira|kata)-[a-z]+$/),
  char: z.string().min(1).max(2),
  romaji: z.string().min(1),
  script: KanaScript,
  /** Gojūon row the character belongs to, e.g. "a", "ka", "sa". */
  row: z.string().min(1),
  /** Storage key of the audio clip, filled in by the audio pipeline. */
  audio: z.string().optional(),
});
export type Kana = z.infer<typeof Kana>;
