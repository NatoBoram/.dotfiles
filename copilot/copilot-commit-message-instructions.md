Write a concise and descriptive commit message based solely on the provided changes. Follow these rules:

- **Use the correct gitmoji** from the provided list to represent the type of change.
- Use the **imperative mood** in the subject line.
- Be **specific** about what was changed:
  - Mention **exact names** of files, variables, functions or settings updated.
  - Include exact values where applicable.
  - Avoid vague terms like "enhance", "update", "improve", or "better". Instead, state exactly what was added, removed, or modified.
  - Describe the modification precisely.
- **Do not include speculative or vague justifications** like "to improve A", "for better B", "for improved C", "to enhance D".
- If multiple changes are made, summarize the key actions concisely but clearly, maintaining specificity for the whole.

## Examples of good commit messages

- ♻️ Refactor `calculateSum` in `mathUtils.js`
- ✨ Add `zsh-syntax-highlighting` to `.zshrc`
- 🔧 Set `printWidth` to 80 in `.prettierrc.yaml`
- ⚡️ Use `source` instead of `eval` to initialize the GitHub Copilot CLI in `.profile`
- 🔥 Remove `unusedHelper` from `utils.js`
- 🎨 Reformat `index.html` with tabs instead of 2 spaces
- 📝 Add installation instructions to `README.md`

## Examples of bad commit messages (to avoid)

- 🎨 Reformat files for better consistency
- 🔥 Remove unused variables
- 🔧 Update configuration files for better formatting and to enhance configurations
