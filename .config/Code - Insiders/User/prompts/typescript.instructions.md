---
applyTo: "**/*.js,**/*.ts"
name: TypeScript
description: Write maintainable TypeScript code
---

## Table of contents

- Comments
- Control flow
- Immutability
- Linting
- Logging
- Modernization
- Purity
- Simplification
- Typing

## Comments

Remove comments that repeat the next line.

```ts
// Assign `"foo"` to `bar`.
const bar = "foo"
```

```ts
const bar = "foo"
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

## Control flow

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
	// Good: the error handling was moved to the parent function.
	const b = await bar().catch((error: unknown) => {
		console.error("An error occurred.", error)
	})
}
```

Move function declarations to the top level.

```ts
function foo() {
	const baz = true

	function bar() {
		baz
	}

	bar()
}
```

```ts
function bar(baz: boolean) {
	baz
}

function foo() {
	const baz = true
	bar(baz)
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

## Immutability

Avoid mutable variables by making new functions.

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

## Linting

Do not disable linting.

```ts
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
```

```ts
// @ts-expect-error The library has a bug where the `foo` property is missing.
```

## Logging

Add causes to errors.

```ts
throw new Error(`Couldn't foo bar #${bar.id}.`)
```

```ts
throw new Error(`Couldn't foo a bar.`, { cause: { bar } })
```

Log full errors.

```ts
console.log("An error has occurred.", { error: error.message })
```

```ts
console.error("An error has occurred.", { error })
```

## Modernization

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

Split type imports from value imports.

```ts
import { Bar, type Foo } from "baz"
```

```ts
import type { Foo } from "baz"
import { Bar } from "baz"
```

## Purity

Avoid side-effects.

```ts
const bars: Bar[] = []
foos.forEach(foo => bars.push(foo.bar))
```

```ts
const bars = foos.map(({ bar }) => bar)
```

## Simplification

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

## Typing

Don't pretend something is something else. Instead, use an adapter or a type guard.

```ts
const foo = bar as unknown as Foo
```

```ts
// Good: use an adapter
const foo = toFoo(bar)
```

```ts
// Good: use a type guard
if (!isFoo(bar)) return
const foo = bar
```

Don't do tuples, create an interface instead.

```ts
const foo = ["bar", true]
```

```ts
interface Foo {
	readonly bar: string
	readonly baz: boolean
}

const foo: Foo = {
	bar: "bar",
	baz: true,
}
```
