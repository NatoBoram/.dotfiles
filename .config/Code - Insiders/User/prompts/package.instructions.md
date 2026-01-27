---
applyTo: "**/package.json"
name: package.json
---

Never edit dependency versions manually; always go through `pnpm` instead.

## Fields

Always include these fields.

```json
{
	"name": "@natoboram/example",
	"description": "An example package.",
	"homepage": "https://github.com/NatoBoram/example",
	"bugs": { "url": "https://github.com/NatoBoram/example/issues" },
	"license": "AGPL-3.0-or-later",
	"author": { "name": "Nato Boram", "url": "https://github.com/NatoBoram" },
	"funding": [
		{ "type": "individual", "url": "https://github.com/sponsors/NatoBoram" },
		{ "type": "patreon", "url": "https://www.patreon.com/NatoBoram" },
		{ "type": "individual", "url": "https://paypal.me/NatoBoram/5" }
	],
	"repository": "github:NatoBoram/example",
	"scripts": {
		"build": "tsgo",
		"build:watch": "tsgo --watch",
		"clean": "rm -rf coverage dist docs node_modules tsconfig.tsbuildinfo",
		"format": "prettier --write .",
		"lint": "eslint . && markdownlint-cli2 \"**/*.md\" && prettier --check .",
		"lint:fix": "eslint --fix --quiet .; markdownlint-cli2 \"**/*.md\" --fix; prettier --list-different --write .",
		"test": "vitest run",
		"test:watch": "vitest"
	},
	"devDependencies": {
		"@eslint/js": "",
		"@typescript/native-preview": "",
		"eslint": "",
		"eslint-config-prettier": "",
		"globals": "",
		"jiti": "",
		"markdownlint-cli2": "",
		"prettier": "",
		"typescript": "",
		"typescript-eslint": "",
		"vitest": ""
	},
	"type": "module"
}
```

### Published

For published packages:

```json
{
	"version": "0.0.0",
	"keywords": [],
	"files": ["dist", "!dist/**/*.test.*"],
	"scripts": { "docs": "typedoc", "test:coverage": "vitest run --coverage" },
	"devDependencies": { "@vitest/coverage-v8": "", "typedoc": "" }
}
```

Otherwise, add this field:

```json
{
	"private": true
}
```

### Binaries

For apps with command-line interfaces:

```json
{
	"bin": { "example": "dist/main.js" },
	"scripts": { "dev": "node src/main.ts", "start": "node dist/main.js" }
}
```

### Libraries

For packages that are consumed by other packages:

```json
{
	"exports": {
		".": { "types": "./dist/index.d.ts", "default": "./dist/index.js" }
	},
	"main": "dist/index.js",
	"types": "dist/index.d.ts",
	"module": "dist/index.js"
}
```

### Docker

For apps with Docker support:

```json
{
	"scripts": {
		"docker": "pnpm run docker:build && pnpm run docker:run",
		"docker:build": "docker build -t example .",
		"docker:kill": "docker ps --format '{{.Image}} {{.ID}}' | grep example | awk '{print $2}' | xargs -r docker kill",
		"docker:run": "docker run example"
	}
}
```
