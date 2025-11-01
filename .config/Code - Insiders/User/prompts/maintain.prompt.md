---
agent: agent
name: maintain
description: Applies small refactors to improve maintainability
argument-hint: Files and folders that need refactoring
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
export const FooBar = {
	foo: "foo",
	bar: "bar",
} as const

export type FooBar = (typeof FooBar)[keyof typeof FooBar]
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
