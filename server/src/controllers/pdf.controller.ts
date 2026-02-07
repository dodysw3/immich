import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Endpoint, HistoryBuilder } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import { PdfSearchQueryDto } from 'src/dtos/pdf.dto';
import { ApiTag, Permission } from 'src/enum';
import { Auth, Authenticated } from 'src/middleware/auth.guard';
import { PdfService } from 'src/services/pdf.service';
import { UUIDParamDto } from 'src/validation';

@ApiTags(ApiTag.Documents)
@Controller('documents')
export class PdfController {
  constructor(private service: PdfService) {}

  @Get()
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'List PDF documents',
    description: "List all PDF documents for the authenticated user, with metadata and thumbnail info.",
    history: new HistoryBuilder().added('v1').beta('v1'),
  })
  getDocuments(@Auth() auth: AuthDto) {
    return this.service.getDocuments(auth);
  }

  @Get('search')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Search PDF documents',
    description: 'Full-text search across all PDF documents owned by the user.',
    history: new HistoryBuilder().added('v1').beta('v1'),
  })
  searchDocuments(@Auth() auth: AuthDto, @Query() dto: PdfSearchQueryDto) {
    return this.service.searchDocuments(auth, dto.query);
  }

  @Get(':id')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF document metadata',
    description: 'Retrieve metadata for a specific PDF document.',
    history: new HistoryBuilder().added('v1').beta('v1'),
  })
  getDocument(@Auth() auth: AuthDto, @Param() { id }: UUIDParamDto) {
    return this.service.getDocument(auth, id);
  }

  @Get(':id/pages')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF pages',
    description: 'Retrieve all pages with extracted text for a specific PDF document.',
    history: new HistoryBuilder().added('v1').beta('v1'),
  })
  getPages(@Auth() auth: AuthDto, @Param() { id }: UUIDParamDto) {
    return this.service.getPages(auth, id);
  }

  @Get(':id/pages/:pageNumber')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get a single PDF page',
    description: 'Retrieve text content for a specific page of a PDF document.',
    history: new HistoryBuilder().added('v1').beta('v1'),
  })
  getPage(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Param('pageNumber') pageNumber: string,
  ) {
    return this.service.getPage(auth, id, Number.parseInt(pageNumber, 10));
  }
}
