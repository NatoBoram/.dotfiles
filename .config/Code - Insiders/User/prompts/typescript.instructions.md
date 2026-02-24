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

### Remove comments that repeat the next line

#### Bad

```ts
// Assign `"foo"` to `bar`.
const bar = "foo"
```

#### Good

```ts
const bar = "foo"
```

### Turn comments preceding declarations into TSDocs

#### Bad

```ts
// ...
const foo = "bar"
```

#### Good

```ts
/** ... */
const foo = "bar"
```

## Control flow

You'll notice that Prettier can get pretty unweildy with deeply nested code. This is a good indicator that you should refactor your code.

### Prefer early returns

#### Bad

```ts
if (foo) {
	if (bar) {
		baz()
	}
}
```

#### Good

```ts
if (!foo || !bar) return
baz()
```

### Avoid scope-wide scopes

The solution is simple: Make a function.

#### Bad

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

#### Good

Notice that the function `foo` isn't even needed anymore.

```ts
async function baz() {
	// Good: the error handling was moved to the parent function.
	const b = await bar().catch((error: unknown) => {
		console.error("An error occurred.", error)
	})
}
```

### Avoid closures

#### Bad

```ts
function foo() {
	const baz = true

	function bar() {
		baz
	}

	bar()
}
```

#### Good

```ts
function bar(baz: boolean) {
	baz
}

function foo() {
	const baz = true
	bar(baz)
}
```

### Replace usage of `if` on enums by `switch`

#### Bad

```ts
if (foo === "bar") {
	// ...
} else if (foo === "baz") {
	// ...
}
```

#### Good

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

### Avoid `try`/`catch`

`try`/`catch` is a control flow that's akin to an undeterministic `goto`.

#### Bad

```ts
try {
	await foo()
} catch (e) {
	console.error(e)
}
```

#### Good

```ts
const result = await foo().catch((error: unknown) => {
	console.error("An error occurred", { error })
})
```

## Immutability

### Prefer `const` over `let`

Whenever you have a mutable variable, consider making a function that gives you the correct result directly. This allows reading the parent function while only focusing on the flow that actually matters.

The solution is simple: Make a function.

#### Bad

```ts
let foo
if (bar) {
	foo = "baz"
}
```

#### Good

```ts
function getFoo(bar: boolean): string | undefined {
	if (bar) return "baz"
	return
}

const foo = getFoo(bar)
```

### Prefer `readonly`

In interfaces and classes, mark properties as `readonly` whenever possible. Immutability is to be expected; mutability is the exception. When there's a non-`readonly` property, it signals that there's something somewhere in the codebase potentially doing something terribly wrong.

If a property must be mutable, document why with a TSDoc comment.

#### Bad

```ts
interface Foo {
	bar: string
	baz: number
}
```

#### Good

```ts
interface Foo {
	readonly bar: string
	/** ... */
	baz: number
}
```

## Linting

### Don't disable it

Always try to fix the issue first.

#### Bad

```ts
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
```

#### Good

```ts
// @ts-expect-error The library has a bug where the `foo` property is missing.
```

## Logging

### Add causes to errors

#### Bad

```ts
throw new Error(`Couldn't foo bar #${bar.id}.`)
```

#### Good

```ts
throw new Error(`Couldn't foo a bar.`, { cause: { bar } })
```

### Log full errors

#### Bad

```ts
console.log("An error has occurred.", { error: error.message })
```

#### Good

```ts
console.error("An error has occurred.", { error })
```

## Modernization

### Don't use `enum`

#### Bad

```ts
enum FooBar {
	foo = "foo",
	bar = "bar",
}
```

#### Good

```ts
const FooBar = {
	foo: "foo",
	bar: "bar",
} as const

type FooBar = (typeof FooBar)[keyof typeof FooBar]
```

### Split type imports from value imports

#### Bad

```ts
import { Bar, type Foo } from "baz"
```

#### Good

```ts
import type { Foo } from "baz"
import { Bar } from "baz"
```

## Purity

### Avoid side-effects

See your code linearly instead of as a spaghetti plate. Stuff goes in, undergoes transformations, stuff goes out.

#### Bad

```ts
const bars: Bar[] = []
foos.forEach(foo => bars.push(foo.bar))
```

#### Good

```ts
const bars = foos.map(({ bar }) => bar)
```

### Move data accesses up to have more pure functions down

#### Bad

```ts
function foo(bar: string): string {
	const baz = getBaz()
	return bar + baz
}
```

#### Good

```ts
function foo(bar: string, baz: string): string {
	return bar + baz
}
```

### Pass the full object to prevent data loss

#### Bad

```ts
function foo(date: string) {}
```

#### Good

```ts
function foo(date: Date) {}
```

## Simplification

### Use intermediate variables in string interpolations

Putting logic inside of a string interpolation makes the entire function harder to read. In those cases, use an intermediate variable to make the string more readable.

#### Bad

```ts
const foo = `
${bar ? "baz" : "qux"}
`
```

#### Good

```ts
const bazqux = bar ? "baz" : "qux"
const foo = `
${bazqux}
`
```

### Simplify boolean expressions

#### Bad

```ts
if (bar.length > 0 ? true : false) {
	// ...
}
```

#### Good

```ts
if (bar) {
	// ...
}
```

### Make interfaces for inline types

#### Bad

```ts
function foo(): { bar: string } {
	return { bar: "bar" }
}
```

#### Good

```ts
interface Foo {
	readonly bar: string
}

function foo(): Foo {
	return { bar: "bar" }
}
```

### Pop complex ternaries by making new functions

#### Bad

```ts
const foo = bar
	? (() => {
			// ...
		})()
	: undefined
```

#### Good

```ts
function baz(bar: boolean) {
	if (!bar) return

	// ...
}

const foo = baz(bar)
```

## Typing

### Don't use type assertions

Don't pretend something is something else. Instead, take the time to properly investigate the issue and use an adapter or a type guard. Request more context from code files from the user if needed.

#### Bad

```ts
const foo = bar as unknown as Foo
```

#### Good

```ts
// Good: use an adapter
const foo = toFoo(bar)
```

```ts
// Good: use a type guard
if (!isFoo(bar)) return
const foo = bar
```

### Don't do tuples

Prefer interfaces.

#### Bad

```ts
const foo = ["bar", true]
```

#### Good

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
