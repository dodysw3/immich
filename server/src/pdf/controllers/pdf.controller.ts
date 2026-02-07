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
import { AssetMediaCreateDto } from 'src/dtos/asset-media.dto';
import { AssetResponseDto } from 'src/dtos/asset-response.dto';
import {
  PdfAssetResponseDto,
  PdfPageResponseDto,
} from 'src/pdf/dto/pdf-response.dto';
import { ApiTag, Permission } from 'src/enum';
import { Auth, Authenticated, FileResponse } from 'src/middleware/auth.guard';
import { FileUploadInterceptor } from 'src/middleware/file-upload.interceptor';
import { LoggingRepository } from 'src/repositories/logging.repository';
import { AssetMediaService } from 'src/services/asset-media.service';
import { AssetMediaResponseDto } from 'src/dtos/asset-media-response.dto';
import { PdfService } from 'src/pdf/services/pdf.service';
import { UUIDParamDto } from 'src/validation';

const PDF_ROUTE = 'pdf';

@ApiTags(ApiTag.Pdf)
@Controller(PDF_ROUTE)
export class PdfController {
  constructor(
    private logger: LoggingRepository,
    private service: PdfService,
    private assetMediaService: AssetMediaService,
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
    description: 'PDF file to upload with metadata',
    schema: {
      type: 'object',
      properties: {
        assetData: {
          type: 'string',
          format: 'binary',
        },
        deviceAssetId: {
          type: 'string',
          description: 'Device asset ID',
        },
        deviceId: {
          type: 'string',
          description: 'Device ID',
        },
        fileCreatedAt: {
          type: 'string',
          format: 'date-time',
          description: 'File creation date',
        },
        fileModifiedAt: {
          type: 'string',
          format: 'date-time',
          description: 'File modification date',
        },
        isFavorite: {
          type: 'boolean',
          description: 'Mark as favorite',
        },
      },
      required: ['assetData', 'deviceAssetId', 'deviceId', 'fileCreatedAt', 'fileModifiedAt'],
    },
  })
  @ApiResponse({
    status: 201,
    description: 'PDF uploaded successfully',
    type: AssetResponseDto,
  })
  @Endpoint({
    summary: 'Upload PDF',
    description: 'Upload a PDF file to the server. PDF files are automatically processed with text extraction and OCR support.',
  })
  async uploadPdf(
    @Auth() auth: AuthDto,
    @Body() dto: AssetMediaCreateDto,
  ): Promise<AssetMediaResponseDto> {
    // Validate that the file is a PDF
    const file = dto.assetData as Express.Multer.File;
    if (!file) {
      throw new Error('No file uploaded');
    }

    if (!file.originalname.toLowerCase().endsWith('.pdf') && file.mimetype !== 'application/pdf') {
      throw new Error('File must be a PDF');
    }

    // Use the existing AssetMediaService to handle the upload
    // The PDF processing will be triggered automatically by the MetadataService
    // which detects PDF files and queues the PdfProcessing job
    return this.assetMediaService.uploadAsset(auth, dto, dto.assetData as any);
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
