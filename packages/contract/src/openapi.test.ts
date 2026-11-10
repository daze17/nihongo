import { describe, expect, it } from "vitest";
import { generateOpenApi } from "./openapi";

describe("generateOpenApi", () => {
  it("includes every contract path with its method", async () => {
    const doc = await generateOpenApi();
    expect(Object.keys(doc.paths ?? {}).sort()).toEqual([
      "/v1/content/kana",
      "/v1/content/manifest",
      "/v1/me",
    ]);
    expect(doc.paths?.["/v1/content/manifest"]?.get).toBeDefined();
  });

  it("marks signed-in routes with the Auth0 bearer scheme", async () => {
    const doc = await generateOpenApi();
    expect(doc.paths?.["/v1/me"]?.get?.security).toEqual([{ auth0: [] }]);
    expect(doc.paths?.["/v1/content/kana"]?.get?.security).toBeUndefined();
    expect(doc.components?.securitySchemes?.auth0).toMatchObject({
      scheme: "bearer",
    });
  });

  it("derives response schemas from zod", async () => {
    const doc = await generateOpenApi();
    const res = doc.paths?.["/v1/content/kana"]?.get?.responses?.["200"] as {
      content: Record<string, { schema: { type: string } }>;
    };
    expect(res.content["application/json"]?.schema.type).toBe("array");
  });
});
