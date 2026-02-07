import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Endpoint, HistoryBuilder } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import {
  PdfDocumentPageParamsDto,
  PdfDocumentParamsDto,
  PdfDocumentQueryDto,
  PdfDocumentResponseDto,
  PdfDocumentSearchDto,
  PdfPageResponseDto,
  PdfSearchResultDto,
} from 'src/dtos/pdf.dto';
import { ApiTag, Permission } from 'src/enum';
import { Auth, Authenticated } from 'src/middleware/auth.guard';
import { PdfService } from 'src/services/pdf.service';

@ApiTags(ApiTag.Documents)
@Controller('documents')
export class PdfController {
  constructor(private service: PdfService) {}

  @Get()
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'List PDF documents',
    description: 'List PDF documents owned by the authenticated user.',
    history: new HistoryBuilder().added('v2.5.6').alpha('v2.5.6'),
  })
  getDocuments(@Auth() auth: AuthDto, @Query() dto: PdfDocumentQueryDto): Promise<PdfDocumentResponseDto[]> {
    return this.service.getDocuments(auth, dto);
  }

  @Get('search')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Search PDF documents',
    description: 'Search PDF text and return matching documents with matching page numbers.',
    history: new HistoryBuilder().added('v2.5.6').alpha('v2.5.6'),
  })
  searchDocuments(@Auth() auth: AuthDto, @Query() dto: PdfDocumentSearchDto): Promise<PdfSearchResultDto[]> {
    return this.service.search(auth, dto);
  }

  @Get(':id')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF document metadata',
    description: 'Get metadata for a single PDF document.',
    history: new HistoryBuilder().added('v2.5.6').alpha('v2.5.6'),
  })
  getDocument(@Auth() auth: AuthDto, @Param() { id }: PdfDocumentParamsDto): Promise<PdfDocumentResponseDto> {
    return this.service.getDocument(auth, id);
  }

  @Get(':id/pages')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF pages',
    description: 'Get all indexed pages for a PDF document.',
    history: new HistoryBuilder().added('v2.5.6').alpha('v2.5.6'),
  })
  getPages(@Auth() auth: AuthDto, @Param() { id }: PdfDocumentParamsDto): Promise<PdfPageResponseDto[]> {
    return this.service.getPages(auth, id);
  }

  @Get(':id/pages/:pageNumber')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF page',
    description: 'Get one indexed page for a PDF document.',
    history: new HistoryBuilder().added('v2.5.6').alpha('v2.5.6'),
  })
  getPage(
    @Auth() auth: AuthDto,
    @Param() { id, pageNumber }: PdfDocumentPageParamsDto,
  ): Promise<PdfPageResponseDto> {
    return this.service.getPage(auth, id, pageNumber);
  }
}
