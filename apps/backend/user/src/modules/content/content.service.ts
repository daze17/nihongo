import { Injectable } from "@nestjs/common";
import { ORPCError } from "@orpc/nest";
import type { ContentManifestResponseBody } from "@repo/contract";
import type { Kana } from "@repo/schema";

import { ContentRepository } from "./content.repository";

/** Business rules for content. Talks to ContentRepository, never to the database directly. */
@Injectable()
export class ContentService {
  constructor(private readonly contentRepository: ContentRepository) {}

  async manifest(): Promise<ContentManifestResponseBody> {
    const row = await this.contentRepository.findManifest();
    if (!row) {
      throw new ORPCError("NOT_FOUND", {
        message: "Content has not been published yet",
      });
    }
    return {
      version: row.version,
      publishedAt: row.publishedAt.toISOString(),
      counts: { kana: await this.contentRepository.countKana() },
    };
  }

  async listKana(): Promise<Kana[]> {
    // Payloads are validated by the seed on write and by the contract on output.
    return (await this.contentRepository.listKanaPayloads()) as Kana[];
  }
}
