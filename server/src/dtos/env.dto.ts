import z from 'zod';
import { ImmichEnvironmentSchema, LogFormatSchema, LogLevelSchema } from 'src/enum.js';
import { IsIPRange } from 'src/validation.js';

// TODO import from sql-tools once the swagger plugin supports external enums
enum DatabaseSslMode {
  Disable = 'disable',
  Allow = 'allow',
  Prefer = 'prefer',
  Require = 'require',
  VerifyFull = 'verify-full',
}

const DatabaseSslModeSchema = z.enum(DatabaseSslMode).describe('Database SSL mode').meta({ id: 'DatabaseSslMode' });
const absolutePath = z.string().regex(/^\//, 'Must be an absolute path').optional();
/**
Treat certain strings as booleans and coerce them to boolean
Ideal for environment variables that are strings but should be treated as booleans
@docs https://zod.dev/api?id=stringbool
*/
const stringBool = z.stringbool();

const discordWebhookUrl = z
  .string()
  .url()
  .refine((value) => {
    const url = new URL(value);
    return (
      url.protocol === 'https:' &&
      ['discord.com', 'canary.discord.com', 'ptb.discord.com'].includes(url.hostname) &&
      /^\/api\/webhooks\/\d+\/[A-Za-z0-9_-]+\/?$/.test(url.pathname) &&
      !url.username &&
      !url.password &&
      !url.hash
    );
  }, 'Must be an HTTPS Discord webhook URL');

const trustedProxiesSchema = z
  .string()
  .optional()
  .transform((s) =>
    s
      ? s
          .split(',')
          .map((x) => x.trim())
          .filter(Boolean)
      : undefined,
  )

  .pipe(z.union([z.undefined(), IsIPRange({ requireCIDR: false })]));

export const EnvSchema = z
  .object({
    IMMICH_API_METRICS_PORT: z.coerce.number().int().optional(),
    IMMICH_BUILD_DATA: z.string().optional(),
    IMMICH_BUILD: z.string().optional(),
    IMMICH_BUILD_URL: z.string().optional(),
    IMMICH_BUILD_IMAGE: z.string().optional(),
    IMMICH_BUILD_IMAGE_URL: z.string().optional(),
    IMMICH_CONFIG_FILE: z.string().optional(),
    IMMICH_HELMET_FILE: z.string().optional(),
    IMMICH_ENV: ImmichEnvironmentSchema.optional(),
    IMMICH_HOST: z.string().optional(),
    IMMICH_IGNORE_MOUNT_CHECK_ERRORS: stringBool.optional(),
    IMMICH_LOG_LEVEL: LogLevelSchema.optional(),
    IMMICH_LOG_FORMAT: LogFormatSchema.optional(),
    IMMICH_MEDIA_LOCATION: absolutePath,
    IMMICH_MICROSERVICES_METRICS_PORT: z.coerce.number().int().optional(),
    IMMICH_ALLOW_EXTERNAL_PLUGINS: stringBool.optional(),
    IMMICH_PLUGINS_INSTALL_FOLDER: absolutePath,
    IMMICH_PORT: z.coerce.number().int().optional(),
    IMMICH_REPOSITORY: z.string().optional(),
    IMMICH_REPOSITORY_URL: z.string().optional(),
    IMMICH_SOURCE_REF: z.string().optional(),
    IMMICH_SOURCE_COMMIT: z.string().optional(),
    IMMICH_SOURCE_URL: z.string().optional(),
    IMMICH_TELEMETRY_INCLUDE: z.string().optional(),
    IMMICH_TELEMETRY_EXCLUDE: z.string().optional(),
    IMMICH_THIRD_PARTY_SOURCE_URL: z.string().optional(),
    IMMICH_THIRD_PARTY_BUG_FEATURE_URL: z.string().optional(),
    IMMICH_THIRD_PARTY_DOCUMENTATION_URL: z.string().optional(),
    IMMICH_THIRD_PARTY_SUPPORT_URL: z.string().optional(),
    IMMICH_ALLOW_SETUP: stringBool.optional(),
    IMMICH_API_KEY_ALLOWED_NETWORKS: trustedProxiesSchema,
    IMMICH_TRUSTED_PROXIES: trustedProxiesSchema,
    IMMICH_WORKERS_INCLUDE: z.string().optional(),
    IMMICH_WORKERS_EXCLUDE: z.string().optional(),
    PDF_ENABLE: stringBool.optional(),
    PDF_OCR_ENABLE: stringBool.optional(),
    PDF_OCR_PROVIDER: z.enum(['immich', 'unlimited-ocr']).optional(),
    PDF_MAX_PAGES_PER_DOC: z.coerce.number().int().min(1).optional(),
    PDF_MAX_FILE_SIZE_MB: z.coerce.number().int().min(1).optional(),
    PDF_MIN_EMBEDDED_TEXT_LENGTH: z.coerce.number().int().min(1).optional(),
    UNLIMITED_OCR_URL: z.string().url().optional(),
    UNLIMITED_OCR_API_KEY: z.string().min(1).optional(),
    UNLIMITED_OCR_TIMEOUT_MS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_ENABLED: stringBool.optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_URL: z.string().url().optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_PUBLIC_URL: z.string().url().optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_PUBLIC_MODEL: z.string().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_PUBLIC_CONCURRENCY: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_API_KEY: z.string().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_MODEL: z.string().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_QUANT: z.string().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_PROMPT_VERSION: z.string().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_TIMEOUT_MS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_MAX_EDGE: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_MAX_PIXELS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_CONCURRENCY: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_RECONCILE_STAGGER_MS: z.coerce.number().int().min(0).optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_SKIP_IF_INTERPRETED: stringBool.optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_VIDEO_CONTEXT: stringBool.optional(),
    IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_WEBHOOK_URL: z.preprocess(
      (value) => (value === '' ? undefined : value),
      discordWebhookUrl.optional(),
    ),
    IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_INCLUDE_THUMBNAIL: stringBool.optional(),
    IMMICH_AI_VIDEO_CAPTIONING_ENABLED: stringBool.optional(),
    IMMICH_AI_VIDEO_CAPTIONING_URL: z.string().url().optional(),
    IMMICH_AI_VIDEO_CAPTIONING_API_KEY: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.string().min(1).optional(),
    ),
    IMMICH_AI_VIDEO_CAPTIONING_MODEL: z.string().min(1).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_TIMEOUT_MS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_SEGMENT_SECONDS: z.coerce.number().int().min(1).max(60).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_FRAMES_PER_SEGMENT: z.coerce.number().int().min(1).max(16).optional(),
    // Adaptive change-driven windows (probe fps, window bounds in seconds,
    // diff thresholds on 0-255 grayscale scores; see ai-video-captioning.ts).
    IMMICH_AI_VIDEO_CAPTIONING_ADAPTIVE: stringBool.optional(),
    IMMICH_AI_VIDEO_CAPTIONING_PROBE_FPS: z.coerce.number().min(0.5).max(8).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_MIN_SEGMENT_SECONDS: z.coerce.number().min(0.5).max(60).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_MAX_SEGMENT_SECONDS: z.coerce.number().min(1).max(120).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_CHANGE_BUDGET: z.coerce.number().min(1).max(255).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_CUT_THRESHOLD: z.coerce.number().min(1).max(255).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_FRAME_EDGE: z.coerce.number().int().min(64).max(4096).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_MAX_DURATION_SEC: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_LANGUAGE: z.string().min(2).max(8).optional(),
    IMMICH_AI_VIDEO_CAPTIONING_CONCURRENCY: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_ENABLED: stringBool.optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_URL: z.string().url().optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_MODEL: z.string().min(1).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_TIMEOUT_MS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_LANGUAGE: z.string().max(8).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_MAX_DURATION_SEC: z.coerce.number().int().min(1).optional(),
    // Bounded chunked extraction: full-duration processing in ~chunkSec windows
    // with a small overlap, instead of one whole-video WAV request.
    IMMICH_AI_VIDEO_TRANSCRIPTION_CHUNK_SEC: z.coerce.number().int().min(30).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_CHUNK_OVERLAP_SEC: z.coerce.number().int().min(0).max(30).optional(),
    IMMICH_AI_VIDEO_TRANSCRIPTION_CONCURRENCY: z.coerce.number().int().min(1).optional(),
    // Suggest-only AI rotation (RightWayUp ONNX in the ML container). The tier
    // must stay in lockstep with the runKey identity, so changing it forks
    // run keys and re-suggests affected assets.
    IMMICH_ORIENTATION_ENABLED: stringBool.optional(),
    IMMICH_ORIENTATION_MODEL_TIER: z.enum(['fast', 'balanced']).optional(),
    IMMICH_ORIENTATION_THRESHOLD: z.coerce.number().min(0).max(1).optional(),
    // YAMNet audio-events sidecar (video-audio-events-v1). Empty values (compose
    // `${VAR:-}` passthroughs) mean "unset" instead of crash-looping the boot.
    IMMICH_AI_AUDIO_EVENTS_ENABLED: z.preprocess((value) => (value === '' ? undefined : value), stringBool.optional()),
    // Whether stored events also feed the interpretation prompt (tagging and
    // the viewer overlay run regardless while the lane is enabled).
    IMMICH_AI_AUDIO_EVENTS_CONTEXT: z.preprocess((value) => (value === '' ? undefined : value), stringBool.optional()),
    IMMICH_AI_AUDIO_EVENTS_URL: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.string().url().optional(),
    ),
    IMMICH_AI_AUDIO_EVENTS_THRESHOLD: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.coerce.number().min(0.05).max(1).optional(),
    ),
    IMMICH_AI_AUDIO_EVENTS_MAX_DURATION_SEC: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.coerce.number().int().min(1).optional(),
    ),
    IMMICH_AI_AUDIO_EVENTS_TIMEOUT_MS: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.coerce.number().int().min(1).optional(),
    ),
    IMMICH_AI_INTERPRET_SEARCH_ENABLED: stringBool.optional(),
    IMMICH_AI_INTERPRET_SEARCH_URL: z.string().url().optional(),
    IMMICH_AI_INTERPRET_SEARCH_API_KEY: z.preprocess(
      (value) => (value === '' ? undefined : value),
      z.string().min(1).optional(),
    ),
    IMMICH_AI_INTERPRET_SEARCH_MODEL: z.string().min(1).optional(),
    IMMICH_AI_INTERPRET_SEARCH_TIMEOUT_MS: z.coerce.number().int().min(1).optional(),
    IMMICH_AI_INTERPRET_SEARCH_MIN_SCORE: z.coerce.number().min(0).max(1).optional(),
    IMMICH_TRANSCRIPTION_SEARCH_ENABLED: stringBool.optional(),
    IMMICH_VIDEO_FACE_SCAN_ENABLED: stringBool.optional(),
    IMMICH_VIDEO_FACE_SCAN_ON_CAPTION: stringBool.optional(),
    IMMICH_VIDEO_FACE_SCAN_FRAMES_BUDGET: z.coerce.number().int().min(1).max(96).optional(),
    IMMICH_VIDEO_FACE_SCAN_DEADLINE_MS: z.coerce.number().int().min(1000).optional(),
    IMMICH_VIDEO_FACE_SCAN_GROUP_THRESHOLD: z.coerce.number().min(0.1).max(0.9).optional(),
    IMMICH_VIDEO_FACE_SCAN_EXEMPLAR_MERGE: stringBool.optional(),
    IMMICH_VIDEO_FACE_SCAN_MIN_GAP_MS: z.coerce.number().int().min(100).optional(),
    IMMICH_VIDEO_FACE_SCAN_SATURATION: z.coerce.number().int().min(1).max(32).optional(),
    IMMICH_VIDEO_FACE_SCAN_IDENTITIES_CAP: z.coerce.number().int().min(1).max(200).optional(),
    DB_DATABASE_NAME: z.string().optional(),
    DB_HOSTNAME: z.string().optional(),
    DB_PASSWORD: z.string().optional(),
    DB_PORT: z.coerce.number().int().optional(),
    DB_SKIP_MIGRATIONS: stringBool.optional(),
    DB_SSL_MODE: DatabaseSslModeSchema.optional(),
    DB_URL: z.string().optional(),
    DB_USERNAME: z.string().optional(),
    DB_VECTOR_EXTENSION: z.enum(['pgvector', 'vectorchord']).optional(),
    NO_COLOR: z.string().optional(),
    REDIS_HOSTNAME: z.string().optional(),
    REDIS_PORT: z.coerce.number().int().optional(),
    REDIS_DBINDEX: z.coerce.number().int().optional(),
    REDIS_USERNAME: z.string().optional(),
    REDIS_PASSWORD: z.string().optional(),
    REDIS_SOCKET: z.string().optional(),
    REDIS_URL: z.string().optional(),
  })
  .refine((env) => env.PDF_OCR_PROVIDER !== 'unlimited-ocr' || Boolean(env.UNLIMITED_OCR_URL), {
    message: 'UNLIMITED_OCR_URL is required when PDF_OCR_PROVIDER=unlimited-ocr',
    path: ['UNLIMITED_OCR_URL'],
  })
  .meta({ id: 'EnvDto' });
