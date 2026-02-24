# CLAUDE.md

## Project Overview

This is the **RealWorld** project — a full-stack Medium.com clone that serves as a reference implementation and specification baseline. Any frontend can work with any backend because all implementations adhere to the same API contract. The repo includes a reference backend API, API/E2E test specs, shared CSS theme, and documentation.

## Tech Stack

**Backend API (`apps/api/`)**
- Runtime: Node.js
- Framework: Nitro (UnJS)
- Language: TypeScript
- Database: SQLite via Prisma ORM
- Auth: JWT (`jsonwebtoken`) + bcryptjs

**Documentation (`apps/documentation/`)**
- Framework: Astro + Starlight
- Styling: Tailwind CSS v4
- Package manager: Bun

**Testing**
- API tests: Hurl and Bruno
- E2E tests: Playwright (TypeScript)
- API spec: OpenAPI 3.0 YAML

## Key Directories

```
apps/
  api/                    # Reference backend (Nitro + Prisma + SQLite)
    server/routes/        # API route handlers
    server/models/        # TypeScript interfaces
    server/utils/         # Auth, hashing, token, mapper utilities
    prisma/schema.prisma  # DB schema (User, Article, Comment, Tag)
    prisma/seed.ts        # DB seed script
  documentation/          # Astro docs site
    src/content/docs/     # Markdown documentation pages

specs/
  api/                    # API specification and tests
    openapi.yml           # OpenAPI 3.0 spec
    hurl/                 # Hurl HTTP test files (13 files)
    bruno/                # Bruno API collection (auto-generated from Hurl)
  e2e/                    # Playwright E2E test suite
    *.spec.ts             # 13 test specs (auth, articles, comments, etc.)
    helpers/              # Test utilities

assets/
  theme/styles.css        # Shared CSS theme for all frontend implementations
```

## Build & Run Commands

All commands run from the project root via `make`.

### API Reference Implementation

```bash
make reference-implementation-setup                             # Install deps, generate Prisma client
make reference-implementation-run-for-hurl                     # Start dev server (port 3000)
make reference-implementation-test-with-hurl                   # Start server, run Hurl tests, teardown
make reference-implementation-test-with-bruno                  # Start server, run Bruno tests, teardown
make reference-implementation-test-with-hurl-and-already-launched-server  # Run Hurl against running server
```

### Documentation

```bash
make documentation-setup    # Install deps (Bun)
make documentation-dev      # Dev server at localhost:4321
make documentation-build    # Production build
make documentation-preview  # Preview production build
```

### Bruno Collection

```bash
make bruno-generate   # Regenerate Bruno collection from Hurl files
make bruno-check      # Verify Bruno collection is up-to-date (used in CI)
```

### Cleanup

```bash
make running-processes-clean    # Kill lingering dev server processes
make non-default-files-clean    # Remove node_modules and dev SQLite DB
```

## Database

Prisma schema models: `User`, `Article`, `Comment`, `Tag`

```bash
# From apps/api/
npm run db:generate   # Generate Prisma client
npm run db:seed       # Seed the database
```

## CI/CD

GitHub Actions workflows in `.github/workflows/`:
- `bruno-check.yml` — verifies Bruno collection matches Hurl source
- `deploy-docs.yml` — builds and deploys documentation site
- `codeql.yml` — security scanning
