---
name: gitmoji
description: An emoji guide for your commit messages
license: MIT
---

**Gitmoji is an emoji guide for commit messages.** Aims to be a standarization cheatsheet - guide for using [emojis](assets/gitmojis.yaml) on commit messages.

**Using emojis** on **commit messages** provides an **easy way** of **identifying the purpose or intention of a commit** with only looking at the emojis used.

## Specification

A gitmoji commit message consists is composed using the following pieces:

- **intention**: The intention you want to express with the commit, using an emoji from the [list](assets/gitmojis.yaml).
- **scope**: An optional string that adds contextual information for the scope of the change.
- **message**: A brief explanation of the change.

```
<intention> [scope?][:?] <message>
```

## Examples

- ⚡️ Lazyload home screen images.
- 🐛 Fix `onClick` event handler
- 🔖 Bump version `1.2.0`
- ♻️ (components): Transform classes to hooks
- 📈 Add analytics to the dashboard
- 🌐 Support Japanese language
- ♿️ (account): Improve modals a11y
