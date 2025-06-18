# Tests

## TypeScript

Tests in TypeScript use `vitest`.

- Use `describe` to name the function that it's testing and `test` to name the value of the variable that's changing.
- Don't duplicate code; import existing code instead, even if it's private. I'll most likely import it myself.
- Always use the `expect` that comes from `test` instead of importing it from `vitest`.

### Examples

```ts
import { describe, test } from "vitest"
import { getLeftPadding } from "./apply_docstrings.ts"

describe("getLeftPadding", () => {
	test("spaces", ({ expect }) => {
		const padding = getLeftPadding("    hello")
		expect(padding).toBe("    ")
	})

	test("tabs", ({ expect }) => {
		const padding = getLeftPadding("\thello")
		expect(padding).toBe("\t")
	})
})
```
