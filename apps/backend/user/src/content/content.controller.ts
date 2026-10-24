import { Controller } from '@nestjs/common';
import { Implement, implement } from '@orpc/nest';
import { contract } from '@repo/contract';
import { ContentService } from './content.service.js';

/** Implements `contract.content`. Paths, methods and output validation come from the contract. */
@Controller()
export class ContentController {
  constructor(private readonly content: ContentService) {}

  @Implement(contract.content)
  router() {
    return {
      manifest: implement(contract.content.manifest).handler(() => this.content.manifest()),
      kana: implement(contract.content.kana).handler(() => this.content.listKana()),
    };
  }
}
