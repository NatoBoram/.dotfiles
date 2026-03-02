---
title: TypeScript 5.6
layout: docs
permalink: /docs/handbook/release-notes/typescript-5-6.html
oneline: TypeScript 5.6 Release Notes
---

## Disallowed Nullish and Truthy Checks

Maybe you've written a regex and forgotten to call `.test(...)` on it:

```ts
if (/0x[0-9a-f]/) {
	// Oops! This block always runs.
	// ...
}
```

or maybe you've accidentally written `=>` (which creates an arrow function) instead of `>=` (the greater-than-or-equal-to operator):

```ts
if (x => 0) {
	// Oops! This block always runs.
	// ...
}
```

or maybe you've tried to use a default value with `??`, but mixed up the precedence of `??` and a comparison operator like `<`:

```ts
function isValid(
	value: string | number,
	options: any,
	strictness: "strict" | "loose",
) {
	if (strictness === "loose") {
		value = +value
	}
	return value < options.max ?? 100
	// Oops! This is parsed as (value < options.max) ?? 100
}
```

or maybe you've misplaced a parenthesis in a complex expression:

```ts
if (
	isValid(primaryValue, "strict") ||
	isValid(secondaryValue, "strict") ||
	isValid(primaryValue, "loose" || isValid(secondaryValue, "loose"))
) {
	//                           ^^^^ 👀 Did we forget a closing ')'?
}
```

None of these examples do what the author intended, but they're all valid JavaScript code.
Previously TypeScript also quietly accepted these examples.

But with a little bit of experimentation, we found that many _many_ bugs could be caught from flagging down suspicious examples like above.
In TypeScript 5.6, the compiler now errors when it can syntactically determine a truthy or nullish check will always evaluate in a specific way.
So in the above examples, you'll start to see errors:

```ts
if (/0x[0-9a-f]/) {
	//  ~~~~~~~~~~~~
	// error: This kind of expression is always truthy.
}

if (x => 0) {
	//  ~~~~~~
	// error: This kind of expression is always truthy.
}

function isValid(
	value: string | number,
	options: any,
	strictness: "strict" | "loose",
) {
	if (strictness === "loose") {
		value = +value
	}
	return value < options.max ?? 100
	//     ~~~~~~~~~~~~~~~~~~~
	// error: Right operand of ?? is unreachable because the left operand is never nullish.
}

if (
	isValid(primaryValue, "strict") ||
	isValid(secondaryValue, "strict") ||
	isValid(primaryValue, "loose" || isValid(secondaryValue, "loose"))
) {
	//                    ~~~~~~~
	// error: This kind of expression is always truthy.
}
```

Similar results can be achieved by enabling the ESLint `no-constant-binary-expression` rule, and you can [see some of the results they achieved in their blog post](https://eslint.org/blog/2022/07/interesting-bugs-caught-by-no-constant-binary-expression/);
but the new checks TypeScript performs does not have perfect overlap with the ESLint rule, and we also believe there is a lot of value in having these checks built into TypeScript itself.

Note that certain expressions are still allowed, even if they are always truthy or nullish.
Specifically, `true`, `false`, `0`, and `1` are all still allowed despite always being truthy or falsy, since code like the following:

```ts
while (true) {
	doStuff()

	if (something()) {
		break
	}

	doOtherStuff()
}
```

is still idiomatic and useful, and code like the following:

```ts
if (true || inDebuggingOrDevelopmentEnvironment()) {
	// ...
}
```

is useful while iterating/debugging code.

If you're curious about the implementation or the sorts of bugs it catches, take a look at [the pull request that implemented this feature](https://github.com/microsoft/TypeScript/pull/59217).

## Iterator Helper Methods

JavaScript has a notion of _iterables_ (things which we can iterate over by calling a `[Symbol.iterator]()` and getting an iterator) and _iterators_ (things which have a `next()` method which we can call to try to get the next value as we iterate).
By and large, you don't typically have to think about these things when you toss them into a `for`/`of` loop, or `[...spread]` them into a new array.
But TypeScript does model these with the types `Iterable` and `Iterator` (and even `IterableIterator` which acts as both!), and these types describe the minimal set of members you need for constructs like `for`/`of` to work on them.

`Iterable`s (and `IterableIterator`s) are nice because they can be used in all sorts of places in JavaScript - but a lot of people found themselves missing methods on `Array`s like `map`, `filter`, and for some reason `reduce`.
That's why [a recent proposal was brought forward in ECMAScript](https://github.com/tc39/proposal-iterator-helpers) to add many methods (and more) from `Array` onto most of the `IterableIterator`s that are produced in JavaScript.

For example, every generator now produces an object that also has a `map` method and a `take` method.

```ts
function* positiveIntegers() {
	let i = 1
	while (true) {
		yield i
		i++
	}
}

const evenNumbers = positiveIntegers().map(x => x * 2)

// Output:
//    2
//    4
//    6
//    8
//   10
for (const value of evenNumbers.take(5)) {
	console.log(value)
}
```

The same is true for methods like `keys()`, `values()`, and `entries()` on `Map`s and `Set`s.

```ts
function invertKeysAndValues<K, V>(map: Map<K, V>): Map<V, K> {
	return new Map(map.entries().map(([k, v]) => [v, k]))
}
```

You can also extend the new `Iterator` object:

```ts
/**
 * Provides an endless stream of `0`s.
 */
class Zeroes extends Iterator<number> {
	next() {
		return { value: 0, done: false } as const
	}
}

const zeroes = new Zeroes()

// Transform into an endless stream of `1`s.
const ones = zeroes.map(x => x + 1)
```

And you can adapt any existing `Iterable`s or `Iterator`s into this new type with `Iterator.from`:

```ts
Iterator.from(...).filter(someFunction);
```

Now, we have to talk about naming.

Earlier we mentioned that TypeScript has types for `Iterable` and `Iterator`;
however, like we mentioned, these act sort of like "protocols" to ensure certain operations work.
_That means that not every value that is declared `Iterable` or `Iterator` in TypeScript will have those methods we mentioned above._

But there is still a new **runtime value** called `Iterator`.
You can reference `Iterator`, as well as `Iterator.prototype`, as actual values in JavaScript.
This is a bit awkward since TypeScript already defines its own thing called `Iterator` purely for type-checking.
So due to this unfortunate name clash, TypeScript needs to introduce a separate type to describe these native/built-in iterable iterators.

TypeScript 5.6 introduces a new type called `IteratorObject`.
It is defined as follows:

```ts
interface IteratorObject<T, TReturn = unknown, TNext = unknown>
	extends Iterator<T, TReturn, TNext> {
	[Symbol.iterator](): IteratorObject<T, TReturn, TNext>
}
```

Lots of built-in collections and methods produce subtypes of `IteratorObject`s (like `ArrayIterator`, `SetIterator`, `MapIterator`, and more), and both the core JavaScript and DOM types in `lib.d.ts`, along with `@types/node`, have been updated to use this new type.

Similarly, there is a `AsyncIteratorObject` type for parity.
`AsyncIterator` does not yet exist as a runtime value in JavaScript that brings the same methods for `AsyncIterable`s, [but it is an active proposal](https://github.com/tc39/proposal-async-iterator-helpers) and this new type prepares for it.

We'd like to thank [Kevin Gibbons](https://github.com/bakkot) who contributed [the changes for these types](https://github.com/microsoft/TypeScript/pull/58222), and who is one of the co-authors of [the proposal](https://github.com/tc39/proposal-iterator-helpers).

## Strict Builtin Iterator Checks (and `--strictBuiltinIteratorReturn`)

When you call the `next()` method on an `Iterator<T, TReturn>`, it returns an object with a `value` and a `done` property.
This is modeled with the type `IteratorResult`.

```ts
type IteratorResult<T, TReturn = any> =
	| IteratorYieldResult<T>
	| IteratorReturnResult<TReturn>

interface IteratorYieldResult<TYield> {
	done?: false
	value: TYield
}

interface IteratorReturnResult<TReturn> {
	done: true
	value: TReturn
}
```

The naming here is inspired by the way a generator function works.
Generator functions can `yield` values, and then `return` a final value - but the types between the two can be unrelated.

```ts
function abc123() {
	yield "a"
	yield "b"
	yield "c"
	return 123
}

const iter = abc123()

iter.next() // { value: "a", done: false }
iter.next() // { value: "b", done: false }
iter.next() // { value: "c", done: false }
iter.next() // { value: 123, done: true }
```

With the new `IteratorObject` type, we discovered some difficulties in allowing safe implementations of `IteratorObject`s.
At the same time, there's been a long standing unsafety with `IteratorResult` in cases where `TReturn` was `any` (the default!).
For example, let's say we have an `IteratorResult<string, any>`.
If we end up reaching for the `value` of this type, we'll end up with `string | any`, which is just `any`.

```ts
function* uppercase(iter: Iterator<string, any>) {
	while (true) {
		const { value, done } = iter.next()
		yield value.toUppercase() // oops! forgot to check for `done` first and misspelled `toUpperCase`

		if (done) {
			return
		}
	}
}
```

It would be hard to fix this on every `Iterator` today without introducing a lot of breaks, but we can at least fix it with most `IteratorObject`s that get created.

TypeScript 5.6 introduces a new intrinsic type called `BuiltinIteratorReturn` and a new `--strict`-mode flag called `--strictBuiltinIteratorReturn`.
Whenever `IteratorObject`s are used in places like `lib.d.ts`, they are always written with `BuiltinIteratorReturn` type for `TReturn` (though you'll see the more-specific `MapIterator`, `ArrayIterator`, `SetIterator` more often).

```ts
interface MapIterator<T>
	extends IteratorObject<T, BuiltinIteratorReturn, unknown> {
	[Symbol.iterator](): MapIterator<T>
}

// ...

interface Map<K, V> {
	// ...

	/**
	 * Returns an iterable of key, value pairs for every entry in the map.
	 */
	entries(): MapIterator<[K, V]>

	/**
	 * Returns an iterable of keys in the map
	 */
	keys(): MapIterator<K>

	/**
	 * Returns an iterable of values in the map
	 */
	values(): MapIterator<V>
}
```

By default, `BuiltinIteratorReturn` is `any`, but when `--strictBuiltinIteratorReturn` is enabled (possibly via `--strict`), it is `undefined`.
Under this new mode, if we use `BuiltinIteratorReturn`, our earlier example now correctly errors:

```ts
function* uppercase(iter: Iterator<string, BuiltinIteratorReturn>) {
	while (true) {
		const { value, done } = iter.next()
		yield value.toUppercase()
		//    ~~~~~ ~~~~~~~~~~~
		// error! ┃      ┃
		//        ┃      ┗━ Property 'toUppercase' does not exist on type 'string'. Did you mean 'toUpperCase'?
		//        ┃
		//        ┗━ 'value' is possibly 'undefined'.

		if (done) {
			return
		}
	}
}
```

You'll typically see `BuiltinIteratorReturn` paired up with `IteratorObject` throughout `lib.d.ts`.
In general, we recommend being more explicit around the `TReturn` in your own code when possible.

For more information, you can [read up on the feature here](https://github.com/microsoft/TypeScript/pull/58243).

## Support for Arbitrary Module Identifiers

JavaScript allows modules to export bindings with invalid identifier names as string literals:

```ts
const banana = "🍌"

export { banana as "🍌" }
```

Likewise, it allows modules to grab imports with these arbitrary names and bind them to valid identifiers:

```ts
import { "🍌" as banana } from "./foo"

/**
 * om nom nom
 */
function eat(food: string) {
	console.log("Eating", food)
}

eat(banana)
```

This seems like a cute party trick (if you're as fun as we are at parties), but it has its uses for interoperability with other languages (typically via JavaScript/WebAssembly boundaries), since other languages may have different rules for what constitutes a valid identifier.
It can also be useful for tools that generate code, like esbuild [with its `inject` feature](https://esbuild.github.io/api/#inject).

TypeScript 5.6 now allows you to use these arbitrary module identifiers in your code!
We'd like to thank [Evan Wallace](https://github.com/evanw) who [contributed this change to TypeScript](https://github.com/microsoft/TypeScript/pull/58640)!

## The `--noUncheckedSideEffectImports` Option

In JavaScript it's possible to `import` a module without actually importing any values from it.

```ts
import "some-module"
```

These imports are often called _side effect imports_ because the only useful behavior they can provide is by executing some side effect (like registering a global variable, or adding a polyfill to a prototype).

In TypeScript, this syntax has had a pretty strange quirk: if the `import` could be resolved to a valid source file, then TypeScript would load and check the file.
On the other hand, if no source file could be found, TypeScript would silently ignore the `import`!

This is surprising behavior, but it partially stems from modeling patterns in the JavaScript ecosystem.
For example, this syntax has also been used with special loaders in bundlers to load CSS or other assets.
Your bundler might be configured in such a way where you can include specific `.css` files by writing something like the following:

```tsx
import "./button-component.css"

export function Button() {
	// ...
}
```

Still, this masks potential typos on side effect imports.
That's why TypeScript 5.6 introduces a new compiler option called `--noUncheckedSideEffectImports`, to catch these cases.
When `--noUncheckedSideEffectImports` is enabled, TypeScript will now error if it can't find a source file for a side effect import.

```ts
import "oops-this-module-does-not-exist"
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// error: Cannot find module 'oops-this-module-does-not-exist' or its corresponding type declarations.
```

When enabling this option, some working code may now receive an error, like in the CSS example above.
To work around this, users who want to just write side effect `import`s for assets might be better served by writing what's called an _ambient module declaration_ with a wildcard specifier.
It would go in a global file and look something like the following:

```ts
// ./src/globals.d.ts

// Recognize all CSS files as module imports.
declare module "*.css" {}
```

In fact, you might already have a file like this in your project!
For example, running something like `vite init` might create a similar `vite-env.d.ts`.

While this option is currently off by default, we encourage users to give it a try!

For more information, [check out the implementation here](https://github.com/microsoft/TypeScript/pull/58941).

## The `--noCheck` Option

TypeScript 5.6 introduces a new compiler option, `--noCheck`, which allows you to skip type checking for all input files.
This avoids unnecessary type-checking when performing any semantic analysis necessary for emitting output files.

One scenario for this is to separate JavaScript file generation from type-checking so that the two can be run as separate phases.
For example, you could run `tsc --noCheck` while iterating, and then `tsc --noEmit` for a thorough type check.
You could also run the two tasks in parallel, even in `--watch` mode, though note you'd probably want to specify a separate `--tsBuildInfoFile` path if you're truly running them at the same time.

`--noCheck` is also useful for emitting declaration files in a similar fashion.
In a project where `--noCheck` is specified on a project that conforms to `--isolatedDeclarations`, TypeScript can quickly generate declaration files without a type-checking pass.
The generated declaration files will rely purely on quick syntactic transformations.

Note that in cases where `--noCheck` is specified, but a project does _not_ use `--isolatedDeclarations`, TypeScript may still perform as much type-checking as necessary to generate `.d.ts` files.
In this sense, `--noCheck` is a bit of a misnomer; however, the process will be lazier than a full type-check, only calculating the types of unannotated declarations.
This should be much faster than a full type-check.

`noCheck` is also available via the TypeScript API as a standard option.
Internally, `transpileModule` and `transpileDeclaration` already used `noCheck` to speed things up (at least as of TypeScript 5.5).
Now any build tool should be able to leverage the flag, taking a variety of custom strategies to coordinate and speed up builds.

For more information, see [the work done in TypeScript 5.5 to power up `noCheck` internally](https://github.com/microsoft/TypeScript/pull/58364), along with the relevant work to make it publicly available [on the command line](https://github.com/microsoft/TypeScript/pull/58839) and

## Allow `--build` with Intermediate Errors

TypeScript's concept of _project references_ allows you to organize your codebase into multiple projects and create dependencies between them.
Running the TypeScript compiler in `--build` mode (or `tsc -b` for short) is the built-in way of actually conducting that build across projects and figuring out which projects and files need to be compiled.

Previously, using `--build` mode would assume `--noEmitOnError` and immediately stop the build if any errors were encountered.
This meant that "downstream" projects could never be checked and built if any of their "upstream" dependencies had build errors.
In theory, this is a very cromulent approach - if a project has errors, it is not necessarily in a coherent state for its dependencies.

In reality, this sort of rigidity made things like upgrades a pain.
For example, if `projectB` depends on `projectA`, then people more familiar with `projectB` can't proactively upgrade their code until their dependencies are upgraded.
They are blocked by work on upgrading `projectA` first.

As of TypeScript 5.6, `--build` mode will continue to build projects even if there are intermediate errors in dependencies.
In the face of intermediate errors, they will be reported consistently and output files will be generated on a best-effort basis;
however, the build will continue to completion on the specified project.

If you want to stop the build on the first project with errors, you can use a new flag called `--stopOnBuildErrors`.
This can be useful when running in a CI environment, or when iterating on a project that's heavily depended upon by other projects.

Note that to accomplish this, TypeScript now always emits a `.tsbuildinfo` file for any project in a `--build` invocation (even if `--incremental`/`--composite` is not specified).
This is to keep track of the state of how `--build` was invoked and what work needs to be performed in the future.

You can [read more about this change here on the implementation](https://github.com/microsoft/TypeScript/pull/58838).

## Region-Prioritized Diagnostics in Editors

When TypeScript's language service is asked for the _diagnostics_ for a file (things like errors, suggestions, and deprecations), it would typically require checking the _entire file_.
Most of the time this is fine, but in extremely large files it can incur a delay.
That can be frustrating because fixing a typo should feel like a quick operation, but can take _seconds_ in a big-enough file.

To address this, TypeScript 5.6 introduces a new feature called _region-prioritized diagnostics_ or _region-prioritized checking_.
Instead of just requesting diagnostics for a set of files, editors can now also provide a relevant region of a given file - and the intent is that this will typically be the region of the file that is currently visible to a user.
The TypeScript language server can then choose to provide two sets of diagnostics: one for the region, and one for the file in its entirety.
This allows editing to feel _way_ more responsive in large files so you're not waiting as long for thoes red squiggles to disappear.

For some specific numbers, in our testing [on TypeScript's own `checker.ts`](https://github.com/microsoft/TypeScript/blob/7319968e90600102892a79142fb804bcbe384160/src/compiler/checker.ts), a full semantic diagnostics response took 3330ms.
In contrast, the response for the first region-based diagnostics response took 143ms!
While the remaining whole-file response took about 3200ms, this can make a huge difference for quick edits.

This feature also includes quite a bit of work to also make diagnostics report more consistently throughout your experience.
Due the way our type-checker leverages caching to avoid work, subsequent checks between the same types could often have a different (typically shorter) error message.
Technically, lazy out-of-order checking could cause diagnostics to report differently between two locations in an editor - even before this feature - but we didn't want to exacerbate the issue.
With recent work, we've ironed out many of these error inconsistencies.

Currently, this functionality is available in Visual Studio Code for TypeScript 5.6 and later.

For more detailed information, [take a look at the implementation and write-up here](https://github.com/microsoft/TypeScript/pull/57842).

## Granular Commit Characters

TypeScript's language service now provides its own _commit characters_ for each completion item.
Commit characters are specific characters that, when typed, will automatically commit the currently-suggested completion item.

What this means is that over time your editor will now more frequently commit to the currently-suggested completion item when you type certain characters.
For example, take the following code:

```ts
declare let food: {
    eat(): any;
}

let f = (foo/**/
```

If our cursor is at `/**/`, it's unclear if the code we're writing is going to be something like `let f = (food.eat())` or `let f = (foo, bar) => foo + bar`.
You could imagine that the editor might be able to auto-complete differently depending on which character we type out next.
For instance, if we type in the period/dot character (`.`), we probably want the editor to complete with the variable `food`;
but if we type the comma character (`,`), we might be writing out a parameter in an arrow function.

Unfortunately, previously TypeScript just signaled to editors that the current text might define a new parameter name so that _no_ commit characters were safe.
So hitting a `.` wouldn't do anything even if it was "obvious" that the editor should auto-complete with the word `food`.

TypeScript now explicitly lists which characters are safe to commit for each completion item.
While this won't _immediately_ change your day-to-day experience, editors that support these commit characters should see behavioral improvements over time.
To see those improvements right now, you can now [use the TypeScript nightly extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-typescript-next) with [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/).
Hitting `.` in the code above correctly auto-completes with `food`.

For more information, see [the pull request that added commit characters](https://github.com/microsoft/TypeScript/pull/59339) along with our [adjustments to commit characters depending on context](https://github.com/microsoft/TypeScript/pull/59523).

## Exclude Patterns for Auto-Imports

TypeScript's language service now allows you to specify a list of regular expression patterns which will filter away auto-import suggestions from certain specifiers.
For example, if you want to exclude all "deep" imports from a package like `lodash`, you could configure the following preference in Visual Studio Code:

```json5
{
	"typescript.preferences.autoImportSpecifierExcludeRegexes": ["^lodash/.*$"],
}
```

Or going the other way, you might want to disallow importing from the entry-point of a package:

```json5
{
	"typescript.preferences.autoImportSpecifierExcludeRegexes": ["^lodash$"],
}
```

One could even avoid `node:` imports by using the following setting:

```json5
{
	"typescript.preferences.autoImportSpecifierExcludeRegexes": ["^node:"],
}
```

Note that if you want to specify certain flags like `i` or `u`, you will need to surround your regular expression with slashes.
When providing surrounding slashes, you'll need to escape other inner slashes.

```json5
{
	"typescript.preferences.autoImportSpecifierExcludeRegexes": [
		"^./lib/internal", // no escaping needed
		"/^.\\/lib\\/internal/", // escaping needed - note the leading and trailing slashes
		"/^.\\/lib\\/internal/i", // escaping needed - we needed slashes to provide the 'i' regex flag
	],
}
```

In Visual Studio Code, the same settings can be applied for JavaScript through `javascript.preferences.autoImportSpecifierExcludeRegexes`.

For more information, [see the implementation here](https://github.com/microsoft/TypeScript/pull/59543).

## Notable Behavioral Changes

This section highlights a set of noteworthy changes that should be acknowledged and understood as part of any upgrade.
Sometimes it will highlight deprecations, removals, and new restrictions.
It can also contain bug fixes that are functionally improvements, but which can also affect an existing build by introducing new errors.

### `lib.d.ts`

Types generated for the DOM may have an impact on type-checking your codebase.
For more information, [see linked issues related to DOM and `lib.d.ts` updates for this version of TypeScript](https://github.com/microsoft/TypeScript/issues/58764).

### `.tsbuildinfo` is Always Written

To enable `--build` to continue building projects even if there are intermediate errors in dependencies, and to support `--noCheck` on the command line, TypeScript now always emits a `.tsbuildinfo` file for any project in a `--build` invocation.
This happens regardless of whether `--incremental` is actually on.
[See more information here](https://github.com/microsoft/TypeScript/pull/58626).

### Respecting File Extensions and `package.json` from within `node_modules`

Before Node.js implemented support for ECMAScript modules in v12, there was never a good way for TypeScript to know whether `.d.ts` files it found in `node_modules` represented JavaScript files authored as CommonJS or ECMAScript modules.
When the vast majority of npm was CommonJS-only, this didn't cause many problems - if in doubt, TypeScript could just assume that everything behaved like CommonJS.
Unfortunately, if that assumption was wrong it could allow unsafe imports:

```ts
// node_modules/dep/index.d.ts
export declare function doSomething(): void

// index.ts
// Okay if "dep" is a CommonJS module, but fails if
// it's an ECMAScript module - even in bundlers!
import dep from "dep"
dep.doSomething()
```

In practice, this didn't come up very often.
But in the years since Node.js started supporting ECMAScript modules, the share of ESM on npm has grown.
Fortunately, Node.js also introduced a mechanism that can help TypeScript determine if a file is an ECMAScript module or a CommonJS module: the `.mjs` and `.cjs` file extensions and the `package.json` `"type"` field.
TypeScript 4.7 added support for understanding these indicators, as well as authoring `.mts` and `.cts` files;
however, TypeScript would _only_ read those indicators under `--module node16` and `--module nodenext`, so the unsafe import above was still a problem for anyone using `--module esnext` and `--moduleResolution bundler`, for example.

To solve this, TypeScript 5.6 collects module format information and uses it to resolve ambiguities like the one in the example above in _all_ `module` modes (except `amd`, `umd`, and `system`).
Format-specific file extensions (`.mts` and `.cts`) are respected anywhere they're found, and the `package.json` `"type"` field is consulted inside `node_modules` dependencies, regardless of the `module` setting.
Previously, it was technically possible to produce CommonJS output into a `.mjs` file or vice versa:

```ts
// main.mts
export default "oops"

// $ tsc --module commonjs main.mts
// main.mjs
Object.defineProperty(exports, "__esModule", { value: true })
exports.default = "oops"
```

Now, `.mts` files never emit CommonJS output, and `.cts` files never emit ESM output.

Note that much of this behavior was provided in pre-release versions of TypeScript 5.5 ([implementation details here](https://github.com/microsoft/TypeScript/pull/57896)), but in 5.6 this behavior is only extended to files within `node_modules`.

More details are available [on the change here](https://github.com/microsoft/TypeScript/pull/58825).

### Correct `override` Checks on Computed Properties

Previously, computed properties marked with `override` did not correctly check for the existence of a base class member.
Similarly, if you used `noImplicitOverride`, you would not get an error if you _forgot_ to add an `override` modifier to a computed property.

TypeScript 5.6 now correctly checks computed properties in both cases.

```ts
const foo = Symbol("foo")
const bar = Symbol("bar")

class Base {
	[bar]() {}
}

class Derived extends Base {
	override [foo]() {}
	//           ~~~~~
	// error: This member cannot have an 'override' modifier because it is not declared in the base class 'Base'.

	[bar]() {}
	//  ~~~~~
	// error under noImplicitOverride: This member must have an 'override' modifier because it overrides a member in the base class 'Base'.
}
```

This fix was contributed thanks to [Oleksandr Tarasiuk](https://github.com/a-tarasyuk) in [this pull request](https://github.com/microsoft/TypeScript/pull/57146).
