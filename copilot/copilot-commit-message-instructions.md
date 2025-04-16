Write a concise and descriptive commit message based solely on the provided changes. Follow these strict rules:

- **Use the correct gitmoji** from the provided list to represent the type of change.
- Use the **imperative mood** in the subject line.
- Keep the commit message under **80 characters**.
- Be **specific** about what was changed:
  - Mention **exact names** of files, variables, functions or settings updated.
  - Include **exact values** or details where applicable.
  - Describe **code changes** precisely.
- **Never include vague terms** like "update", "enhance", "improve" or "better".
- **Do not include any post-sentence justification**. This is a hard rule:
  - Do not end the message with any phrase starting with "to", "for", "in order to" or similar.
  - Do not include phrases like "for clarity", "to simplify", "to improve", etc.
  - These are meaningless without context. Only describe what changed, where and how.
- **Avoid artificial phrases** like "in `X` class", "from `Y` file", "at `Z` module". Use natural language like "in `X`", "from `Y`", etc.
- If multiple changes are made, pick the most significant one.

## 🔥 Hard bans — rewrite these patterns immediately

| Pattern                         | Why it's wrong            | Correction                                                   |
| :------------------------------ | :------------------------ | :----------------------------------------------------------- |
| Update settings                 | Too vague                 | Name the file and setting changed                            |
| Improve formatting              | Too vague                 | Describe the formatting rule or change                       |
| Add instructions                | Too vague                 | Say _what_ instructions were added and _where_               |
| Clarify behaviour/rules         | Vague and speculative     | Say what changed—not that it clarifies                       |
| ✖️ Ends in "for clarity"        | Justification — forbidden | Say what changed in the code                                 |
| ✖️ Ends in "to improve logging" | Justification — forbidden | Say what changed (e.g. logging level, targets, output, etc.) |
| ✖️ Ends in "to simplify logic"  | Justification — forbidden | Say what logic was changed and how                           |
| ✖️ "in `X` class"               | Artificial phrasing       | Just say "in `X`"                                            |

## Rewrite vague messages into specific messages

- **Bad:** 🔧 Update GitHub Copilot settings and instructions for improved code generation and review selection

  **Good:** 🔧 Link 7 files under `github.copilot.chat` in Copilot VSCode settings

- **Bad:** 🔧 Update configuration files for better formatting

  **Good:** 🔧 Set `printWidth` to 80 in `.prettierrc.yaml`

- **Bad:** 🎨 Reformat files for better consistency

  **Good:** 🎨 Reformat `index.html` with tabs instead of 2 spaces

- **Bad:** 🔥 Remove unused variables

  **Good:** 🔥 Remove `unusedHelper` in `utils.js`

- **Bad:** 🩹 Replace `logger.http` with `logger.info` for improved logging consistency

  **Good:** 🔊 Replace `logger.http` with `logger.info` for GitHub and GitLab

- **Bad:** 🔧 Update path instructions in `.coderabbit.yaml` to clarify type assertion recommendations

  **Good:** 🔧 Add rule to flag `as` in object literals in `.coderabbit.yaml`

- **Bad:** ♻️ Refactor constructor in `Based` class for clarity

  **Good:** ♻️ Refactor constructor in `Based` to use explicit property declarations

## Examples of good commit messages

- ♻️ Refactor `calculateSum` in `mathUtils.js`
- ⚡️ Use `source` instead of `eval` in Copilot CLI init in `.profile`
- ✨ Add `zsh-syntax-highlighting` to `.zshrc`
- 🎨 Reformat `index.html` with tabs instead of 2 spaces
- 🔥 Remove `unusedHelper` from `utils.js`
- 🔧 Set `printWidth` to 80 in `.prettierrc.yaml`
- ⬆️ Upgrade `@natoboram/based.ts` to v1.0.0

## Gitmojis

- 🎨: Improve structure / format of the code.
- ⚡️: Improve performance.
- 🔥: Remove code or files.
- 🐛: Fix a bug.
- 🚑️: Critical hotfix.
- ✨: Introduce new features.
- 📝: Add or update documentation.
- 🚀: Deploy stuff.
- 💄: Add or update the UI and style files.
- 🎉: Begin a project.
- ✅: Add, update, or pass tests.
- 🔒️: Fix security or privacy issues.
- 🔐: Add or update secrets.
- 🔖: Release / Version tags.
- 🚨: Fix compiler / linter warnings.
- 🚧: Work in progress.
- 💚: Fix CI Build.
- ⬇️: Downgrade dependencies.
- ⬆️: Upgrade dependencies.
- 📌: Pin dependencies to specific versions.
- 👷: Add or update CI build system.
- 📈: Add or update analytics or track code.
- ♻️: Refactor code.
- ➕: Add a dependency.
- ➖: Remove a dependency.
- 🔧: Add or update configuration files.
- 🔨: Add or update development scripts.
- 🌐: Internationalization and localization.
- ✏️: Fix typos.
- 💩: Write bad code that needs to be improved.
- ⏪️: Revert changes.
- 🔀: Merge branches.
- 📦️: Add or update compiled files or packages.
- 👽️: Update code due to external API changes.
- 🚚: "Move or rename resources (e.g.: files, paths, routes)."
- 📄: Add or update license.
- 💥: Introduce breaking changes.
- 🍱: Add or update assets.
- ♿️: Improve accessibility.
- 💡: Add or update comments in source code.
- 🍻: Write code drunkenly.
- 💬: Add or update text and literals.
- 🗃️: Perform database related changes.
- 🔊: Add or update logs.
- 🔇: Remove logs.
- 👥: Add or update contributor(s).
- 🚸: Improve user experience / usability.
- 🏗️: Make architectural changes.
- 📱: Work on responsive design.
- 🤡: Mock things.
- 🥚: Add or update an easter egg.
- 🙈: Add or update a .gitignore file.
- 📸: Add or update snapshots.
- ⚗️: Perform experiments.
- 🔍️: Improve SEO.
- 🏷️: Add or update types.
- 🌱: Add or update seed files.
- 🚩: Add, update, or remove feature flags.
- 🥅: Catch errors.
- 💫: Add or update animations and transitions.
- 🗑️: Deprecate code that needs to be cleaned up.
- 🛂: Work on code related to authorization, roles and permissions.
- 🩹: Simple fix for a non-critical issue.
- 🧐: Data exploration/inspection.
- ⚰️: Remove dead code.
- 🧪: Add a failing test.
- 👔: Add or update business logic.
- 🩺: Add or update healthcheck.
- 🧱: Infrastructure related changes.
- 🧑‍💻: Improve developer experience.
- 💸: Add sponsorships or money related infrastructure.
- 🧵: Add or update code related to multithreading or concurrency.
- 🦺: Add or update code related to validation
