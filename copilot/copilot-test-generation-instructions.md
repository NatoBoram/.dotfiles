# Tests

## TypeScript

Tests in TypeScript use `vitest`. Use `describe` to name the function that it's testing and `test` to name the value of the variable that's changing.

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
