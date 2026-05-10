import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsObject, IsString, Max, Min, ValidateNested } from 'class-validator';
import { ValidateBoolean } from 'src/validation';

export class TaskConfig {
  @ValidateBoolean({ description: 'Whether the task is enabled' })
  enabled!: boolean;
}

export class ModelConfig extends TaskConfig {
  @ApiProperty({ description: 'Name of the model to use' })
  @IsString()
  @IsNotEmpty()
  modelName!: string;
}

export class CLIPConfig extends ModelConfig {}

export class DuplicateDetectionConfig extends TaskConfig {
  @IsNumber()
  @Min(0.001)
  @Max(0.1)
  @Type(() => Number)
  @ApiProperty({
    type: 'number',
    format: 'double',
    description: 'Maximum distance threshold for duplicate detection',
  })
  maxDistance!: number;
}

export class FaceDetectionTilingMinDimWithFacesConfig {
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Minimum original image dimension to consider tiling' })
  dim!: number;

  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Minimum pass-1 face count when original dim threshold is met' })
  faces!: number;
}

export class FaceDetectionTilingTriggersConfig {
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Minimum pass-1 face count to trigger tiling' })
  minPass1Faces!: number;

  @Type(() => FaceDetectionTilingMinDimWithFacesConfig)
  @ValidateNested()
  @IsObject()
  minDimWithFaces!: FaceDetectionTilingMinDimWithFacesConfig;
}

export class FaceDetectionTilingConfig {
  @ValidateBoolean({ description: 'Enable tiled face detection for large/group photos' })
  enabled!: boolean;

  @IsNumber()
  @Min(128)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Tile size in pixels for tiled detection' })
  tileSize!: number;

  @IsNumber()
  @Min(0)
  @Max(0.9)
  @Type(() => Number)
  @ApiProperty({ type: 'number', format: 'double', description: 'Overlap ratio between adjacent tiles' })
  tileOverlap!: number;

  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Maximum number of tiles before downscaling' })
  maxTiles!: number;

  @Type(() => FaceDetectionTilingTriggersConfig)
  @ValidateNested()
  @IsObject()
  triggers!: FaceDetectionTilingTriggersConfig;
}

export class FacialRecognitionConfig extends ModelConfig {
  @IsNumber()
  @Min(0.1)
  @Max(1)
  @Type(() => Number)
  @ApiProperty({ type: 'number', format: 'double', description: 'Minimum confidence score for face detection' })
  minScore!: number;

  @IsNumber()
  @Min(0.1)
  @Max(2)
  @Type(() => Number)
  @ApiProperty({
    type: 'number',
    format: 'double',
    description: 'Maximum distance threshold for face recognition',
  })
  maxDistance!: number;

  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Minimum number of faces required for recognition' })
  minFaces!: number;

  @Type(() => FaceDetectionTilingConfig)
  @ValidateNested()
  @IsObject()
  tiling!: FaceDetectionTilingConfig;
}

export class OcrConfig extends ModelConfig {
  @IsNumber()
  @Min(1)
  @Type(() => Number)
  @ApiProperty({ type: 'integer', description: 'Maximum resolution for OCR processing' })
  maxResolution!: number;

  @IsNumber()
  @Min(0.1)
  @Max(1)
  @Type(() => Number)
  @ApiProperty({ type: 'number', format: 'double', description: 'Minimum confidence score for text detection' })
  minDetectionScore!: number;

  @IsNumber()
  @Min(0.1)
  @Max(1)
  @Type(() => Number)
  @ApiProperty({
    type: 'number',
    format: 'double',
    description: 'Minimum confidence score for text recognition',
  })
  minRecognitionScore!: number;
}
