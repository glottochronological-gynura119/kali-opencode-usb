# AGENTS.md — opencode-shannon-plugin

OpenCode plugin for autonomous penetration testing via Docker-based security tools.

## Build & Run Commands

```bash
bun run build          # Bundle with bun + emit declarations with tsc
bun run clean          # rm -rf dist
bun run typecheck      # tsc --noEmit (type-check only, no output)
bun run test           # bun test (no test files exist yet)
bun run clean && bun run build   # Full clean rebuild
```

Build is two-step: `bun build src/index.ts --outdir dist --target bun --format esm` then `tsc --emitDeclarationOnly`.

There are no tests, no linter, and no formatter configured. Rely on `tsc --noEmit` for correctness.

## Project Structure

```
src/
  index.ts              Plugin entry — registers all tools and hooks
  types.ts              Shared interfaces (ShannonToolInput, ShannonToolOutput, etc.)
  system-prompt.ts      System prompt constant injected into chat
  tools/                One directory per tool (14 tools total)
  hooks/                Hook implementations (authorization, progress, session)
  config/               Zod-based config schema + loader
  docker/               DockerManager singleton class
  commands/             CLI command definitions
  skills/               Markdown skill files (pentest guides)
```

### Tool directory layout

Full tools have 2–4 files:

```
src/tools/shannon-recon/
  index.ts              Barrel re-export (one line)
  tools.ts              Factory function(s) returning ToolDefinition
  types.ts              Tool-specific arg/result interfaces (optional)
  constants.ts          Description string constants (optional)
```

Simple tools (logic-audit, cloud-recon, api-fuzzer) put everything in `index.ts`.

## TypeScript Configuration

- **Target/Module**: ESNext, ESM (`"type": "module"` in package.json)
- **Module resolution**: `bundler`
- **Strict mode**: enabled (`strict: true`)
- **verbatimModuleSyntax**: enabled — use `import type` for type-only imports
- **noUncheckedIndexedAccess**: enabled — indexed access returns `T | undefined`
- **noImplicitOverride**: enabled
- **Types**: `bun-types` (not `@types/node`)

## Code Style

### Formatting

- **Indentation**: 2 spaces
- **Quotes**: double quotes (`"..."`)
- **Semicolons**: omitted (no trailing semicolons)
- **Trailing commas**: yes, in multi-line objects/arrays/params
- **Max line length**: not enforced, but keep readable (~100-120 chars)

### Imports

Order (separated by blank line when mixing groups):

1. External packages (`@opencode-ai/plugin`, `zod`, `picocolors`)
2. Internal absolute (`../../types`, `../../docker`)
3. Local relative (`./tools`, `./types`, `./constants`)

```typescript
import { tool, type ToolDefinition } from "@opencode-ai/plugin"
import type { ShannonToolInput } from "../../types"
import { SHANNON_RECON_DESCRIPTION } from "./constants"
```

Use `import type { ... }` for type-only imports — enforced by `verbatimModuleSyntax`.

Use `import * as fs from "fs"` for Node builtins (some files use `node:` prefix, but this is inconsistent — match the file you're editing).

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Tool factory | `createShannonXxx` | `createShannonRecon()` |
| Hook factory | `createShannonXxxHook` | `createShannonProgressTrackerHook()` |
| Tool name (registered) | `snake_case` | `shannon_recon`, `shannon_idor_test` |
| Interfaces/Types | `PascalCase` | `ShannonToolOutput`, `DockerExecutionResult` |
| Constants | `UPPER_SNAKE_CASE` | `SHANNON_RECON_DESCRIPTION` |
| Helper functions | `camelCase` (module-level, not exported) | `formatAutoResults()` |
| Directory names | `kebab-case` | `shannon-auth-session/` |
| Config schema | `PascalCase` + `Schema` suffix | `ShannonConfigSchema` |
| Zod import alias | always `z` | `import { z } from "zod"` |

### Tool Implementation Pattern

Every tool follows this exact factory pattern:

```typescript
import { tool, type ToolDefinition } from "@opencode-ai/plugin"

export function createShannonXxx(): ToolDefinition {
  return tool({
    description: "Short description of what the tool does.",
    args: {
      target: tool.schema.string().describe("The target URL or IP"),
      command: tool.schema.string().describe("The command to execute"),
      timeout: tool.schema.number().optional().describe("Timeout in ms"),
      mode: tool.schema.enum(["manual", "auto"]).optional().describe("Testing mode"),
    },
    async execute(args) {
      const output: string[] = []
      // ... build output
      return output.join("\n")
    },
  })
}
```

Key rules:
- Args defined with `tool.schema.*().describe("...")` — every arg needs `.describe()`
- Enum args: `tool.schema.enum(["value1", "value2"])`
- Object args: `tool.schema.object({ key: tool.schema.string() }).optional()`
- Return type is always `string` (output lines joined with `"\n"`)
- Output uses markdown formatting (`##`, `**`, `` ` ``, `---`)

### Barrel Exports

Every `index.ts` is a single-line re-export:

```typescript
export { createShannonRecon } from "./tools"
export type { ShannonReconArgs } from "./types"
```

### Error Handling

```typescript
// In tool execute functions — return error as string, never throw
try {
  // ... operation
} catch (error) {
  return `ERROR: ${error instanceof Error ? error.message : String(error)}`
}

// In infrastructure code (docker, config) — throw with descriptive message
throw new Error(`Docker container failed to start: ${stderr}`)

// Non-critical checks (file existence, optional config) — empty catch
try {
  const data = fs.readFileSync(path, "utf-8")
} catch {}
```

Tools never throw — they return `"ERROR: ..."` strings. Infrastructure code throws.

### Logging

Use `picocolors` (imported as `pc`) for console output:

```typescript
import pc from "picocolors"

console.log(pc.cyan("[ShannonPlugin] Loading..."))    // Info/progress
console.log(pc.green("[ShannonPlugin] Done"))          // Success
console.log(pc.yellow("[ShannonPlugin] Warning..."))   // Warning
console.log(pc.red("[ShannonPlugin] Failed..."))       // Error
```

Prefix all log lines with `[ShannonPlugin]`.

### Config / Zod Schemas

```typescript
import { z } from "zod"

const MySchema = z.object({
  field: z.string().describe("What this field does"),
  optional_field: z.boolean().optional().default(false),
})

type MyConfig = z.infer<typeof MySchema>
```

Use `.describe()` on every Zod field. Infer types with `z.infer<>` — don't duplicate as interfaces.

### Classes vs Functions

- **Singleton services** (DockerManager): use `class` with `private` fields
- **Everything else**: plain functions. Tool factories, helpers, hooks — all functions

### Type Safety

- Use `Record<string, unknown>` for loosely-typed objects, not `any`
- Use `error instanceof Error ? error.message : String(error)` in catch blocks
- Prefer nullish coalescing `??` over `||` for defaults
- Never use `as any`, `@ts-ignore`, or `@ts-expect-error`
- Use `import type` for all type-only imports

## Plugin Registration (src/index.ts)

New tools are registered in the `tools` record in `src/index.ts`:

```typescript
const tools: Record<string, any> = {
  shannon_my_tool: createShannonMyTool(),
}
```

Feature-gated tools use config checks:

```typescript
if (config.shannon.browser_testing) {
  tools.shannon_browser = createShannonBrowser()
}
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `@opencode-ai/plugin` | Plugin SDK — `tool()`, `ToolDefinition`, plugin types |
| `zod` | Config schema validation |
| `picocolors` | Terminal color output |
| `js-yaml` | YAML config parsing |
| `jsonc-parser` | JSONC config parsing |
