---
name: architecture-report
description: Generate a comprehensive Mermaid architecture report for any codebase. Creates frontend, backend, data flow, and dependency diagrams with verification.
argument-hint: "[frontend-only | backend-only | full]"
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash
---

# Architecture Report Generator

Generate a full architecture report for this codebase with verified Mermaid diagrams.

## Phase 1: Discovery

Explore the codebase to understand:
- Overall architecture pattern (monolith, microservices, monorepo)
- Frontend framework, key components, routing, state management
- Backend framework, routes, controllers, services, middleware
- Database layer, ORM, models, migrations
- External integrations and dependencies

## Phase 2: Diagram Generation

Create diagrams based on $ARGUMENTS (`frontend-only`, `backend-only`, or `full` — default is `full`):

**1. Frontend Architecture** (`graph TD`)
- Pages/routes, shared components, state management, API client layer
- 15–25 nodes max, grouped by responsibility

**2. Backend Architecture** (`graph TD`)
- Entry point, middleware, route groups, services, data layer
- Grouped by layer: routing → services → data

**3. Data Flow** (`sequenceDiagram`)
- The most important user action traced through all layers
- Client → route handler → service → database → response, including error branches

**4. Dependency Map** (`graph LR`)
- Application in the centre, consumers on the left, dependencies on the right
- Third-party APIs, databases, caches, queues, auth providers, CDN, CI/CD

## Phase 3: Verification

Before writing any file, for each diagram:
- Grep and Read to confirm every referenced component actually exists
- Verify connections match real imports and function calls
- Check for missing major components
- Validate Mermaid syntax is correct
- Fix anything found

## Phase 4: Output

```bash
mkdir -p docs/architecture
```

For each diagram:
1. Save as `.mmd` file in `docs/architecture/`
2. Render to SVG — install mmdc if missing, then render:
```bash
npx mmdc -i <file>.mmd -o <file>.svg -t dark
```

Then write `docs/architecture/ARCHITECTURE.md` with:
- Project overview paragraph
- Each diagram embedded as `![Alt](./filename.svg)`
- Component reference table with file paths
- Generation date

## Phase 5: Confirm

List all output files and confirm each SVG is non-empty. Report any components that were omitted and why.
