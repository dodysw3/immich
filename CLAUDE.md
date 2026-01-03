# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Immich is a high-performance self-hosted photo and video management solution. This is a monorepo containing multiple packages managed with pnpm workspaces.

**Package Manager:** pnpm 10.24.0+ (required)
**Node Version:** 24.11.1 (specified in web/package.json volta config)

## Monorepo Structure

- **web/** - SvelteKit frontend (TypeScript, Svelte 5, TailwindCSS)
- **server/** - NestJS backend API (TypeScript, PostgreSQL, Kysely/TypeORM)
- **mobile/** - Flutter mobile app (Dart)
- **machine-learning/** - Python FastAPI ML service (ONNX Runtime)
- **cli/** - TypeScript CLI tool for bulk uploads
- **open-api/typescript-sdk/** - Auto-generated TypeScript SDK (shared by web/cli)
- **e2e/** - End-to-end tests
- **docs/** - Documentation site

## Development Commands

### Web Frontend

```bash
cd web
pnpm dev                    # Start dev server on http://localhost:3000
pnpm build                  # Production build
pnpm check:svelte           # Svelte type checking
pnpm check:typescript       # TypeScript type checking
pnpm check:code             # Format + lint + type check
pnpm lint                   # Run ESLint
pnpm lint:fix               # Auto-fix linting issues
pnpm format                 # Check formatting with Prettier
pnpm format:fix             # Auto-fix formatting
pnpm test                   # Run tests
pnpm test:cov               # Run tests with coverage
pnpm test:watch             # Run tests in watch mode
```

### Backend Server

```bash
cd server
npm run start:dev           # Start dev server with watch mode
npm run start:debug         # Start with debugger on port 9230
npm run build               # Build for production
npm run check               # TypeScript type checking
npm run check:code          # Format + lint + type check
npm run lint                # Run ESLint
npm run lint:fix            # Auto-fix linting issues
npm run test                # Run tests
npm run test:cov            # Run tests with coverage
npm run test:medium         # Run medium/integration tests
```

### Database Migrations

```bash
cd server
npm run migrations:generate <MigrationName>   # Generate migration from schema changes
npm run migrations:create <MigrationName>     # Create empty migration
npm run migrations:run                         # Run pending migrations
npm run migrations:debug                       # Show migration status
```

### OpenAPI SDK Generation

When backend API changes, regenerate the TypeScript SDK:

```bash
cd server
npm run build                          # Build server first
node dist/bin/sync-open-api.js         # Generate OpenAPI spec
cd ../open-api
npm run sync                           # Generate TypeScript SDK
```

## Architecture Patterns

### Web Frontend (Svelte 5)

#### Manager Pattern

Managers encapsulate complex stateful logic using Svelte 5 runes. They are singleton instances exported from modules.

**Location:** `/web/src/lib/managers/`

**Key Managers:**
- **TimelineManager** - Virtual scrolling, asset loading, timeline grouping by month/day
- **ActivityManager** - Album activities (comments, likes) with caching
- **AuthManager**, **ThemeManager**, **UploadManager** - Various app-level concerns

**Pattern:**
```typescript
class FooManager {
  #data = $state<T[]>([]);          // Private reactive state
  showOverlay = $state(false);      // Public reactive state
  #computed = $derived(...);        // Derived state

  get data() { return this.#data; } // Getter for private state

  // Public methods
  async load() { ... }
  clear() { ... }
}

export const fooManager = new FooManager(); // Singleton export
```

**Important:** When clearing state, preserve UI toggle states across navigation (e.g., don't reset `showOverlay` flags).

#### Store Pattern

**Location:** `/web/src/lib/stores/`

Two types of stores:
- **Traditional Svelte stores** (`.store.ts`) - Using `writable`, `readable`, `derived`
- **Runes-based stores** (`.svelte.ts`) - Using Svelte 5 `$state` and `$derived`

Use runes for new code. Existing stores are being migrated gradually.

#### Virtual Scrolling Architecture

**Base:** `VirtualScrollManager` - Abstract class managing scroll calculations
**Implementation:** `TimelineManager extends VirtualScrollManager`

Key concepts:
- Assets grouped by month/day hierarchy
- Lazy loading of assets on viewport intersection
- Deferred layout calculations for performance
- WebSocket integration for real-time updates

#### Component Organization

- **Timeline components** - Month/day/asset layouts with virtualization
- **Action components** (`/components/timeline/actions/`) - Reusable action buttons (Archive, Delete, Share)
- **Asset viewer** - Photo/video viewer with OCR, face recognition overlays
- Use Svelte 5 snippets for flexible composition

### Backend (NestJS)

#### Three-Tier Architecture

1. **Controllers** (`/server/src/controllers/`)
   - Handle HTTP requests with decorators
   - Delegate to services
   - Use custom decorators: `@Authenticated`, `@Endpoint`, `@Chunked`

2. **Services** (`/server/src/services/`)
   - Business logic layer
   - All extend `BaseService` which injects ALL repositories
   - Use `requireAccess()` for permission checks
   - Use `getConfig()`, `updateConfig()` for settings

3. **Repositories** (`/server/src/repositories/`)
   - Data access layer
   - Use Kysely for type-safe SQL queries
   - No interfaces - direct class injection
   - Use `@InjectKysely()` decorator for DB injection

**Important:** All services inherit access to all repositories via `BaseService`. This is intentional for simplicity.

#### Database Layer

**Dual ORM Approach:**
- **TypeORM** - Used ONLY for migrations (`/server/src/schema/migrations/`)
- **Kysely** - Used for ALL runtime queries (type-safe SQL builder)

**Schema organization:**
- `/server/src/schema/tables/` - Table definitions
- `/server/src/schema/functions.ts` - SQL helper functions
- `/server/src/schema/index.ts` - Exported `DB` type

**Composable Query Pattern:**
```typescript
// Create reusable query fragments
const withExif = (qb) => qb.select((eb) =>
  jsonObjectFrom(eb.selectFrom('asset_exif').selectAll()).as('exifInfo')
);

// Compose based on options
let query = db.selectFrom('asset').selectAll();
if (options.exifInfo) query = withExif(query);
return await query.executeTakeFirst();
```

**Parameter Chunking:** PostgreSQL has a 65,535 parameter limit. Use `@Chunked` decorator on repository methods that accept large arrays:
```typescript
@Chunked({ paramIndex: 0 })
async getByIds(ids: string[]) { ... }
```

#### Custom Decorators

- `@Chunked` - Auto-chunks large parameter arrays
- `@GenerateSql` - Generates SQL from methods for debugging
- `@OnJob` - Marks methods as job handlers
- `@Endpoint` - Combines decorators for API documentation

### API Contract (OpenAPI → TypeScript SDK)

**Flow:**
1. Backend decorators → OpenAPI spec generation
2. OpenAPI spec → TypeScript SDK generation (using custom templates in `/open-api/templates/`)
3. Web/CLI import SDK from workspace: `import { getAssetInfo } from '@immich/sdk'`

**Always regenerate SDK after backend API changes.**

## Common Patterns

### State Persistence Across Navigation

For UI toggles (like overlay visibility), don't reset the state in `clear()` methods:

```typescript
class Manager {
  showOverlay = $state(false);
  #data = $state<T[]>([]);

  clear() {
    this.#data = [];
    // DON'T reset showOverlay - keep state across navigation
  }
}
```

### Event-Driven Communication

**Frontend EventManager:**
```typescript
import { eventManager } from '$lib/managers/event-manager.svelte';

// Type-safe events
eventManager.on('AlbumUpdate', (album) => { ... });
eventManager.emit('AlbumUpdate', updatedAlbum);
```

**Backend EventRepository:**
Used for cross-service communication within the server.

### Permission Checks

Always use `requireAccess` in services before data operations:
```typescript
await this.requireAccess({
  auth,
  permission: Permission.AssetRead,
  ids: [assetId]
});
```

### File Structure Conventions

- **Web routes:** File-based routing in `/web/src/routes/`
  - `(user)/` - Authenticated routes
  - `admin/` - Admin routes
  - `auth/` - Auth routes
  - `+page.svelte` - Page component
  - `+page.ts` - Data loading
  - `[[optional]]/` - Optional route segments

- **Server structure:**
  - Controllers handle routes
  - Services handle business logic
  - Repositories handle data access
  - All follow NestJS module pattern

## Type Safety

- **Web → Server:** Use generated `@immich/sdk` types
- **Database queries:** Kysely provides compile-time type checking
- **API contracts:** OpenAPI spec ensures frontend/backend alignment

## Testing

### Web Tests
Located in `/web/src/lib/` alongside source files (`.spec.ts`).
Uses Vitest + Testing Library.

### Server Tests
- Unit tests: `/server/test/*.spec.ts`
- Medium tests: `/server/test/*.medium-spec.ts`

### E2E Tests
Located in `/e2e/` - Full integration tests across the stack.

## Important Notes

- **Never skip hooks** - Don't use `--no-verify` on git commits
- **OCR coordinates** - Use normalized 0-1 range (x1-x4, y1-y4 for 4 corners, supports rotation/skew)
- **Face coordinates** - Use image-native absolute pixels (boundingBoxX1, Y1, X2, Y2 with imageWidth, imageHeight)
- **Asset visibility** - `AssetVisibility.Timeline` (regular), `Archive` (archived), `Hidden`, `Locked`
- **Migrations** - Always use TypeORM for migrations, Kysely for runtime queries
- **Svelte 5** - Use runes (`$state`, `$derived`) for new code, not legacy stores
