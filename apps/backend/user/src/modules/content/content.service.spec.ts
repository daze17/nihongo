import { ORPCError } from "@orpc/nest";

import type { ContentRepository } from "./content.repository";
import { ContentService } from "./content.service";

const fakeRepository = (overrides: Partial<ContentRepository> = {}) =>
  ({
    findManifest: async () => ({
      version: 2,
      publishedAt: new Date("2026-10-24T00:00:00Z"),
    }),
    countKana: async () => 46,
    listKanaPayloads: async () => [],
    ...overrides,
  }) as ContentRepository;

describe("ContentService", () => {
  it("builds the manifest from repository rows", async () => {
    const service = new ContentService(fakeRepository());
    await expect(service.manifest()).resolves.toEqual({
      version: 2,
      publishedAt: "2026-10-24T00:00:00.000Z",
      counts: { kana: 46 },
    });
  });

  it("throws NOT_FOUND when nothing is published", async () => {
    const service = new ContentService(
      fakeRepository({ findManifest: async () => undefined }),
    );
    await expect(service.manifest()).rejects.toBeInstanceOf(ORPCError);
    await expect(service.manifest()).rejects.toMatchObject({
      code: "NOT_FOUND",
    });
  });
});
