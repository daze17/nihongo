import { describe, expect, it } from 'vitest';
import { Kana } from './kana.js';

describe('Kana schema', () => {
  it('accepts a valid hiragana entry', () => {
    const a = { id: 'hira-a', char: 'あ', romaji: 'a', script: 'hiragana', row: 'a' };
    expect(Kana.parse(a)).toEqual(a);
  });

  it('rejects an unknown script', () => {
    const bad = { id: 'hira-a', char: 'あ', romaji: 'a', script: 'kanji', row: 'a' };
    expect(Kana.safeParse(bad).success).toBe(false);
  });
});
