import { Injectable } from '@nestjs/common';
import { ORPCError } from '@orpc/nest';
import type { ContentManifest } from '@repo/contract';
import type { Kana } from '@repo/schema';
import { ContentRepository } from './content.repository.js';

/** Business rules for content. Talks to ContentRepository, never to the database directly. */
@Injectable()
export class ContentService {
  constructor(private readonly repo: ContentRepository) {}

  async manifest(): Promise<ContentManifest> {
    const row = await this.repo.findManifest();
    if (!row) throw new ORPCError('NOT_FOUND', { message: 'Content has not been published yet' });
    return {
      version: row.version,
      publishedAt: row.publishedAt.toISOString(),
      counts: { kana: await this.repo.countKana() },
    };
  }

  async listKana(): Promise<Kana[]> {
    // Payloads are validated by the seed on write and by the contract on output.
    return (await this.repo.listKanaPayloads()) as Kana[];
  }
}
