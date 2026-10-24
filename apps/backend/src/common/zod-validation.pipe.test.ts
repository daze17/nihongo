import { BadRequestException } from '@nestjs/common';
import { Kana } from '@repo/schema';
import { describe, expect, it } from 'vitest';
import { ZodValidationPipe } from './zod-validation.pipe.js';

describe('ZodValidationPipe', () => {
  const pipe = new ZodValidationPipe(Kana);

  it('returns parsed data when valid', () => {
    const k = { id: 'hira-a', char: 'あ', romaji: 'a', script: 'hiragana', row: 'a' };
    expect(pipe.transform(k)).toEqual(k);
  });

  it('throws 400 with field paths when invalid', () => {
    try {
      pipe.transform({ id: 'nope' });
      expect.unreachable();
    } catch (e) {
      expect(e).toBeInstanceOf(BadRequestException);
      const body = (e as BadRequestException).getResponse() as { errors: { path: string }[] };
      expect(body.errors.map((x) => x.path)).toContain('char');
    }
  });
});
