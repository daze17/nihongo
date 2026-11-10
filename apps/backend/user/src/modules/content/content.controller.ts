import { Controller } from "@nestjs/common";
import { Implement, implement } from "@orpc/nest";
import { contract } from "@repo/contract";

import { Public } from "@/common/decorators/public";

import { ContentService } from "./content.service";

/** Implements `contract.content`. Paths, methods and output validation come from the contract. */
@Public()
@Controller()
export class ContentController {
  constructor(private readonly contentService: ContentService) {}

  @Implement(contract.content)
  router() {
    return {
      manifest: implement(contract.content.manifest).handler(() =>
        this.contentService.manifest(),
      ),
      kana: implement(contract.content.kana).handler(() =>
        this.contentService.listKana(),
      ),
    };
  }
}
