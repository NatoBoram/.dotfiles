---
applyTo: "**/*.test.js,**/*.test.ts"
name: Vitest
---

Tests in TypeScript use `vitest`.

## Form

- Place test files next to the implementation files, at `${file}.test.ts`.

## Content

- Don't duplicate code; import existing code instead, even if it's private. I'll most likely import it myself.
- Store the tested function's output in an intermediate variable so that the `expect` line can be read as an English sentence.
- The thing to be expected must be a literal value.
- Use the `describe` block to name the thing that is being tested.
- Use the `expect` function that comes from the test's context.
- Use the `test` block to name the value (like `true`) or the kind of value (like "invalid") that is being tested.

## Examples

```ts
import { describe, test } from "vitest"
import { getLeftPadding } from "./apply_docstrings.ts"

describe("getLeftPadding", () => {
	test("spaces", ({ expect }) => {
		const padding = getLeftPadding("  hello")
		expect(padding).toBe("  ")
	})

	test("tabs", ({ expect }) => {
		const padding = getLeftPadding("\thello")
		expect(padding).toBe("\t")
	})
})
```
