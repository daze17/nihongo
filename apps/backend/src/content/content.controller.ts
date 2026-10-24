import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ContentService } from './content.service.js';

@ApiTags('content')
@Controller('content')
export class ContentController {
  constructor(private readonly content: ContentService) {}

  @Get('manifest')
  @ApiOkResponse({ description: 'Current content version. The app re-downloads when it changes.' })
  manifest() {
    return this.content.manifest();
  }

  @Get('kana')
  @ApiOkResponse({ description: 'All kana entries, validated by @repo/schema.' })
  kana() {
    return this.content.listKana();
  }
}
