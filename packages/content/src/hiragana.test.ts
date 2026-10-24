import { Kana } from '@repo/schema';
import { describe, expect, it } from 'vitest';
import { hiraganaRowA } from './hiragana.js';

describe('hiragana content', () => {
  it('every entry matches the Kana schema', () => {
    for (const k of hiraganaRowA) expect(Kana.safeParse(k).success).toBe(true);
  });

  it('ids are unique', () => {
    const ids = hiraganaRowA.map((k) => k.id);
    expect(new Set(ids).size).toBe(ids.length);
  });
});
