import { Controller, Get, Header, NotFoundException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { generateOpenApi } from "@repo/contract";

import { Public } from "@/common/decorators/public";
import type { Configuration } from "@/config/configuration";

const SCALAR = "https://cdn.jsdelivr.net/npm/@scalar/api-reference@1.73.1";

/** Dev-only API reference. The spec is generated from the oRPC contract. */
@Public()
@Controller()
export class DocsController {
  constructor(
    private readonly configService: ConfigService<Configuration, true>,
  ) {}

  @Get("openapi.json")
  spec() {
    this.assertDev();
    const port = this.configService.get("app.port", { infer: true });
    return generateOpenApi([{ url: `http://localhost:${port}` }]);
  }

  @Get("docs")
  @Header("content-type", "text/html; charset=utf-8")
  docs() {
    this.assertDev();
    return `<!doctype html><html><head><title>Nihongo API</title><meta charset="utf-8"></head>
<body><script id="api-reference" data-url="/openapi.json"></script><script src="${SCALAR}"></script></body></html>`;
  }

  private assertDev() {
    if (this.configService.get("app.isProduction", { infer: true })) {
      throw new NotFoundException();
    }
  }
}
