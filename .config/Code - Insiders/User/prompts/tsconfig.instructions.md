---
applyTo: "**/tsconfig.json,**/tsconfig.*.json"
---

## Regular projects

If you need help, use the `typescript-docs` skill.

## Composite projects

Those guidelines are for composite projects. A project is only composite if it contains the `references` property or if it's referenced by other projects.

### Solution

A good practice is to have a "solution" `tsconfig.json` file that simply has references to all of the leaf-node projects.

```jsonc
{
	"compilerOptions": {
		/* Projects */
		"composite": true,

		/* Modules */
		// `rootDir` must contain all other projects.
		"rootDir": "src",

		/* Emit */
		// Composite projects may not disable declaration emit.
		"declaration": true,
	},

	// Those are the entrypoints of the application. They determine what should be compiled.
	"include": ["src/index.*.ts", "src/index.ts", "src/main.*.ts", "src/main.ts"],

	// Explicitly unset `exclude` and `files` to avoid importing something unnecessary from the default values.
	"exclude": [],
	"files": [],

	"references": [
		{ "path": "src/adapters/tsconfig.json" },
		{ "path": "src/commander/tsconfig.json" },
		{ "path": "src/consts/tsconfig.json" },
	],
}
```

### Leaves

Leaf-node projects are referenced by other projects.

```jsonc
{
	// Import the `compilerOptions` from the solution file.
	"extends": "../../tsconfig.json",

	// Leaf-node projects only include their own files.
	"include": ["."],

	// Explicitly unset `exclude` and `files` to avoid importing something unnecessary from the solution file.
	"exclude": [],
	"files": [],

	// To use files from other projects, add them to the references. Beware of circular dependencies.
	"references": [{ "path": "../consts/tsconfig.json" }],
}
```

### Outsiders

External scripts shouldn't be compiled but can still benefit from type checking and linting. Those can be included in a separate `tsconfig.eslint.json`. Note that ESLint does not support project references.

```jsonc
{
	"extends": "./tsconfig.json",
	"compilerOptions": { "checkJs": true },
	"include": ["eslint.config.ts", "src", "vitest.config.ts"],
	"exclude": [],
	"references": [],
}
```
