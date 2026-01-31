---
agent: agent
name: maintain
description: Applies small refactors to improve maintainability
argument-hint: Code, files and folders that need refactoring
---

Turn mutable variables into constants by making new functions.

```ts
let foo
if (bar) {
	foo = "baz"
}
```

```ts
function getFoo(bar: boolean): string | undefined {
	if (bar) return "baz"
	return
}

const foo = getFoo(bar)
```

Reduce nesting by using early returns.

```ts
if (foo) {
	if (bar) {
		baz()
	}
}
```

```ts
if (!foo || !bar) return
baz()
```

Use intermediate variables to extract logic from string interpolation.

```ts
const foo = `
${bar ? "baz" : "qux"}
`
```

```ts
const bazqux = bar ? "baz" : "qux"
const foo = `
${bazqux}
`
```

Turn enums into const assertions.

```ts
enum FooBar {
	foo = "foo",
	bar = "bar",
}
```

```ts
const FooBar = {
	foo: "foo",
	bar: "bar",
} as const

type FooBar = (typeof FooBar)[keyof typeof FooBar]
```

Add causes to errors.

```ts
throw new Error(`Couldn't foo bar #${bar.id}.`)
```

```ts
throw new Error(`Couldn't foo a bar.`, { cause: { bar } })
```

Simplify boolean expressions.

```ts
if (bar.length > 0 ? true : false) {
	// ...
}
```

```ts
if (bar.length) {
	// ...
}
```

Replace usage of `if` on enums by `switch`.

```ts
if (foo === "bar") {
	// ...
} else if (foo === "baz") {
	// ...
}
```

```ts
switch (foo) {
	case "bar":
		// ...
		return
	case "baz":
		// ...
		return
}
```

Log full errors.

```ts
console.log("An error has occurred.", { error: error.message })
```

```ts
console.error("An error has occurred.", { error })
```

Make interfaces for inline types.

```ts
function foo(): { bar: string } {
	return { bar: "bar" }
}
```

```ts
interface Foo {
	readonly bar: string
}

function foo(): Foo {
	return { bar: "bar" }
}
```

Remove comments that repeat the next line.

```ts
// Assign `"foo"` to `bar`.
const bar = "foo"
```

```ts
const bar = "foo"
```

Split type imports from value imports.

```ts
import { Bar, type Foo } from "baz"
```

```ts
import type { Foo } from "baz"
import { Bar } from "baz"
```

Make interfaces immutables. If they can't be immutable, add a TSDoc comment explaining why.

```ts
interface Foo {
	bar: string
	baz: number
}
```

```ts
interface Foo {
	readonly bar: string
	/** ... */
	baz: number
}
```

Pop scope-wide scopes.

```ts
async function foo(): Promise<Bar | undefined> {
	// Bad: the entire scope of the function is used by a `try`.
	try {
		return await bar()
	} catch (error) {
		console.log("An error occurred.", error)
		return
	}
}

async function baz() {
	const f = await foo()
}
```

```ts
async function baz() {
	// Good: the error handling was moved to the parent function
	const b = await bar().catch((error: unknown) => {
		console.error("An error occurred.", error)
	})
}
```

Turn comments preceding declarations into TSDocs.

```ts
// ...
const foo = "bar"
```

```ts
/** ... */
const foo = "bar"
```

Pop complex ternaries by making new functions.

```ts
const foo = bar
	? (() => {
			// ...
		})()
	: undefined
```

```ts
function baz(bar: boolean) {
	if (!bar) return

	// ...
}

const foo = baz(bar)
```
