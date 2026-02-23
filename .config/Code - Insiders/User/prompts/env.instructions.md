---
applyTo: "**/.env,**/.env.*,**/.env.*.local,**/.env.local,**/env.*"
name: .env
description: Load environment variables from .env[.<NODE_ENV>][.local] files.
---

Environment variables should be loaded in the following priority order:

1. `.env.${NODE_ENV}.local`
2. `.env.${NODE_ENV}`
3. `.env.local`
4. `.env`

`${NODE_ENV}` represents the environment where the project will be deployed, usually `development`, `production` or `test`.

Files ending in `.local` are gitignored. The other files are committed to the repository and should contain all default and empty values.
