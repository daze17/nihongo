import { oc } from "@orpc/contract";
import { Kana } from "@repo/schema";
import { z } from "zod";

import { ContentManifestResponseBody } from "@/schemas/dtos/content";

export const contentContract = {
  manifest: oc
    .route({
      method: "GET",
      path: "/v1/content/manifest",
      summary: "Current content version",
      tags: ["content"],
    })
    .output(ContentManifestResponseBody),

  kana: oc
    .route({
      method: "GET",
      path: "/v1/content/kana",
      summary: "All kana entries",
      tags: ["content"],
    })
    .output(z.array(Kana)),
};
