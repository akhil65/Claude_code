---
name: architecture-report
description: Generate a full architecture report for any codebase. Explores the project, produces four Mermaid diagrams (frontend, backend, data flow, dependencies), renders them to SVG, and writes an ARCHITECTURE.md to docs/architecture/. Use when the user asks for an architecture overview, system diagram, or codebase documentation.
argument-hint: "[frontend-only | backend-only | full] [output-dir]"
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash
---

Generate a complete architecture report for this project by following every step below. If $ARGUMENTS contains `frontend-only`, generate only the frontend diagram. If it contains `backend-only`, generate only the backend diagram. Otherwise generate all 4 (default). A second argument overrides the output directory (default: `docs/architecture`).

## Step 1 — Explore the codebase

Use the Explore subagent to thoroughly understand the project before writing anything. Investigate:

- Top-level directory structure and monorepo layout (workspaces, apps/, packages/, src/, etc.)
- Package manager and all `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` files
- Framework and runtime (Next.js, Nitro, Django, Rails, Spring, etc.)
- Frontend: pages/routes, layout components, state management (Redux, Zustand, Context, Pinia, etc.), API client layer
- Backend: entry point, middleware stack, route groups / controllers, service / business logic layer
- Database: ORM, schema/models, migration setup
- Auth mechanism (JWT, session, OAuth, API key, etc.)
- External integrations: third-party APIs called, cloud services, queues, CDN, storage
- CI/CD: GitHub Actions, GitLab CI, CircleCI, Dockerfile, deployment targets
- Environment variables and secrets

Do not write any files yet. Build a complete mental model first.

## Step 2 — Generate Mermaid diagrams

Create the output directory:

```bash
mkdir -p docs/architecture
```

Write the following `.mmd` files. Tailor each diagram to what actually exists in this project — do not invent layers or components that are absent. Keep each diagram to 15–25 nodes and use clear, concise labels.

### 2a. `frontend.mmd` — Frontend Architecture (`graph TD`)

Include:
- Build pipeline / framework (Vite, Webpack, Next.js, etc.)
- Content or data layer (pages, routes, content collections)
- Layout and shared UI components
- State management (stores, context, reducers) — omit if none exists
- Styling pipeline
- Build output / hosting target

### 2b. `backend.mmd` — Backend Architecture (`graph TD`)

Include:
- Entry point / server initialisation and config
- Middleware stack (CORS, auth, logging, validation)
- Route groups or controllers (group related endpoints rather than listing each individually)
- Utilities / service layer (hashing, token generation, mappers, etc.)
- ORM / query layer and key database models
- Infrastructure (database file, env vars)

### 2c. `dataflow.mmd` — Key Data Flow (`sequenceDiagram`)

Pick the single most representative request in the application (login, checkout, document creation, etc.) and trace it end-to-end:
- Client initiates request
- Each middleware or handler that touches it
- Every external call (DB query, cache lookup, third-party API)
- The response path back through each layer
- Error branches (validation failure, auth failure, not-found)

### 2d. `dependencies.mmd` — External Dependencies (`graph LR`)

Put the application in the centre. Show on the left: external consumers (browsers, mobile clients, other services, test runners). Show on the right: everything the app depends on at runtime and deployment time (database, cache, queues, CDN, auth providers, hosting, CI/CD). Use dashed arrows (`-.->`) for deployment/CI relationships and solid arrows for runtime data flow.

## Step 3 — Verify every diagram

Before rendering, for each diagram:
- Grep and Read to confirm every referenced component actually exists in the codebase
- Verify connections match real imports, function calls, or config
- Check for any missing major components that should be included
- Validate Mermaid syntax is correct (correct diagram type keyword, no unclosed subgraphs, valid arrow syntax)
- Fix anything found before moving on

## Step 4 — Render SVGs

Run the render script from the repo root:

```bash
bash .claude/skills/architecture-report/render.sh
```

The script checks for `npx`, renders every `.mmd` file in `docs/architecture/` to a dark-themed SVG at 1200px wide, validates each output is non-empty, and prints a rendered/failed summary. It exits with a non-zero code if any diagram fails.

If a render fails, inspect the error printed to stderr, fix the `.mmd` source, and re-run the script.

## Step 5 — Write ARCHITECTURE.md

Write `docs/architecture/ARCHITECTURE.md` with the following structure. Fill in every section with content specific to this project — do not use placeholder text.

```markdown
# Architecture Overview

**Date:** <today's date>

## Project Overview

<One paragraph: what the project does, its overall architecture pattern (monolith / monorepo / microservices), primary tech stack, and how the major pieces relate to one another.>

---

## Frontend Architecture

<One short paragraph describing the frontend: framework, routing, styling, state management, and any notable patterns or constraints.>

![Frontend Architecture](./frontend.svg)

---

## Backend Architecture

<One short paragraph describing the backend: framework, middleware, route organisation, service layer, and auth approach.>

![Backend Architecture](./backend.svg)

---

## Data Flow

<One short paragraph identifying which flow is shown and why it was chosen as representative. Call out any non-obvious steps.>

![<Flow name> Data Flow](./dataflow.svg)

---

## Dependencies & Integrations

<One short paragraph summarising the external surface area — what the app calls at runtime, where it is deployed, and how CI/CD works.>

![Dependencies & Integrations](./dependencies.svg)

---

## Component Summary

| Component | Type | Path |
|---|---|---|
<One row per major component. Cover: entry points, middleware, route groups, services/utilities, ORM layer, database, key config files, frontend pages/layouts, styling, CI/CD workflows.>
```

## Step 6 — Confirm and report

After all files are written, run:

```bash
ls -lh docs/architecture/
```

Then report back with:
- A confirmation that all 9 files exist (`frontend.mmd`, `frontend.svg`, `backend.mmd`, `backend.svg`, `dataflow.mmd`, `dataflow.svg`, `dependencies.mmd`, `dependencies.svg`, `ARCHITECTURE.md`)
- A one-sentence description of what each diagram shows for this specific project
- Any caveats (e.g. a layer that was absent and therefore omitted, or a diagram that was simplified due to complexity)

Do **not** commit or push unless the user explicitly asks.
