import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Res,
  StreamableFile,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBody, ApiConsumes, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Response } from 'express';
import { Endpoint } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import { AssetResponseDto } from 'src/dtos/asset-response.dto';
import {
  PdfAssetResponseDto,
  PdfPageResponseDto,
} from 'src/pdf/dto/pdf-response.dto';
import { ApiTag, Permission } from 'src/enum';
import { Auth, Authenticated, FileResponse } from 'src/middleware/auth.guard';
import { FileUploadInterceptor, getFiles } from 'src/middleware/file-upload.interceptor';
import { LoggingRepository } from 'src/repositories/logging.repository';
import { PdfService } from 'src/pdf/services/pdf.service';
import { UUIDParamDto } from 'src/validation';
import { mimeTypes } from 'src/utils/mime-types';
import { UploadFiles } from 'src/types';

const PDF_ROUTE = 'pdf';

@ApiTags(ApiTag.Pdf)
@Controller(PDF_ROUTE)
export class PdfController {
  constructor(
    private logger: LoggingRepository,
    private service: PdfService,
  ) {
    this.logger.setContext(PdfController.name);
  }

  /**
   * Upload a PDF file using the dedicated PDF upload endpoint
   */
  @Post('upload')
  @Authenticated({ permission: Permission.AssetUpload })
  @UseInterceptors(FileUploadInterceptor)
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description: 'PDF file to upload',
    schema: {
      type: 'object',
      properties: {
        assetData: {
          type: 'string',
          format: 'binary',
        },
      },
      required: ['assetData'],
    },
  })
  @ApiResponse({
    status: 201,
    description: 'PDF uploaded successfully',
    type: AssetResponseDto,
  })
  @Endpoint({
    summary: 'Upload PDF',
    description: 'Upload a PDF file to the server using the dedicated PDF upload endpoint.',
  })
  async uploadPdf(
    @Auth() auth: AuthDto,
    files: UploadFiles,
    @Body() dto: any,
  ): Promise<AssetResponseDto> {
    const { file } = getFiles(files);
    if (!file) {
      throw new Error('No file uploaded');
    }

    // Validate file type
    if (!file.originalName.toLowerCase().endsWith('.pdf')) {
      throw new Error('File must be a PDF');
    }

    // TODO: Implement PDF upload logic
    // This will use AssetMediaService under the hood but with PDF-specific handling
    throw new Error('PDF upload not yet implemented - use AssetMediaService for now');
  }

  /**
   * Get all PDF assets for the authenticated user
   */
  @Get('assets')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get all PDFs',
    description: 'Get all PDF assets owned by the authenticated user.',
  })
  async getPdfAssets(@Auth() auth: AuthDto): Promise<AssetResponseDto[]> {
    return this.service.getPdfAssets(auth);
  }

  /**
   * Get PDF metadata with pages
   */
  @Get('assets/:id')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF details',
    description: 'Get PDF metadata with pages for a specific asset.',
  })
  async getPdfAsset(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
  ): Promise<PdfAssetResponseDto> {
    return this.service.getPdfAsset(auth, id);
  }

  /**
   * Get all pages for a PDF asset
   */
  @Get('assets/:id/pages')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF pages',
    description: 'Get all pages for a specific PDF asset.',
  })
  async getPdfPages(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
  ): Promise<PdfPageResponseDto[]> {
    return this.service.getPdfPages(auth, id);
  }

  /**
   * Get a specific page with image
   */
  @Get('assets/:id/pages/:pageNumber')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get PDF page',
    description: 'Get a specific page from a PDF asset.',
  })
  async getPdfPage(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Param('pageNumber') pageNumber: string,
  ): Promise<PdfPageResponseDto> {
    return this.service.getPdfPage(auth, id, parseInt(pageNumber, 10));
  }

  /**
   * Download the original PDF file
   */
  @Get('assets/:id/download')
  @Authenticated({ permission: Permission.AssetDownload })
  @Endpoint({
    summary: 'Download PDF',
    description: 'Download the original PDF file.',
  })
  async downloadPdf(
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Res() res: Response,
  ): Promise<void> {
    const filePath = await this.service.getPdfDownloadPath(auth, id);
    res.download(filePath, 'document.pdf');
  }

  /**
   * Get page image
   */
  @Get('page/:id/image')
  @Authenticated({ permission: Permission.AssetRead })
  @Endpoint({
    summary: 'Get page image',
    description: 'Get the page preview image.',
  })
  async getPageImage(
    @Param() { id }: UUIDParamDto,
    @Res() res: Response,
  ): Promise<void> {
    const imagePath = await this.service.getPageImagePath(id);
    res.sendFile(imagePath);
  }
}
