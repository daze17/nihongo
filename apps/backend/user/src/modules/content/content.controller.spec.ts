import { call } from "@orpc/server";

import { ContentController } from "./content.controller";
import type { ContentService } from "./content.service";

const fakeService = (overrides: Partial<ContentService> = {}) =>
  ({
    manifest: async () => ({
      version: 3,
      publishedAt: "2026-10-24T00:00:00.000Z",
      counts: { kana: 5 },
    }),
    listKana: async () => [
      { id: "hira-a", char: "あ", romaji: "a", script: "hiragana", row: "a" },
    ],
    ...overrides,
  }) as ContentService;

describe("ContentController (contract)", () => {
  it("returns the manifest", async () => {
    const controller = new ContentController(fakeService());
    await expect(
      call(controller.router().manifest, undefined),
    ).resolves.toMatchObject({ version: 3 });
  });

  it("rejects output that breaks the contract", async () => {
    const controller = new ContentController(
      fakeService({ listKana: async () => [{ id: "bad" }] as never }),
    );
    await expect(
      call(controller.router().kana, undefined),
    ).rejects.toMatchObject({ code: "INTERNAL_SERVER_ERROR" });
  });
});
