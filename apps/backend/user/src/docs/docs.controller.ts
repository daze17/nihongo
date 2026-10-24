import { Controller, Get, Header, NotFoundException } from '@nestjs/common';
import { generateOpenApi } from '@repo/contract';
import { AppConfig } from '../config/app-config.js';

const SCALAR = 'https://cdn.jsdelivr.net/npm/@scalar/api-reference@1.73.1';

/** Dev-only API reference. The spec is generated from the oRPC contract. */
@Controller()
export class DocsController {
  constructor(private readonly config: AppConfig) {}

  @Get('openapi.json')
  spec() {
    this.assertDev();
    return generateOpenApi([{ url: `http://localhost:${this.config.env.PORT}` }]);
  }

  @Get('docs')
  @Header('content-type', 'text/html; charset=utf-8')
  docs() {
    this.assertDev();
    return `<!doctype html><html><head><title>Nihongo API</title><meta charset="utf-8"></head>
<body><script id="api-reference" data-url="/openapi.json"></script><script src="${SCALAR}"></script></body></html>`;
  }

  private assertDev() {
    if (this.config.isProduction) throw new NotFoundException();
  }
}
