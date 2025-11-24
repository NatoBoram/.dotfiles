---
agent: agent
description: Update the path instructions for CodeRabbit's code reviews.
argument-hint: The list of pull requests that you want to analyze.
tools:
  - edit/editFiles
  - github.vscode-pull-request-github/activePullRequest
  - github.vscode-pull-request-github/openPullRequest
  - github/github-mcp-server/pull_request_read
  - github/github-mcp-server/search_pull_requests
  - search/fileSearch
  - search/readFile
  - todos
---

Let's update CodeRabbit's code review path instructions based on recently closed and recently reviewed pull requests.

1. Use #tool:github.vscode-pull-request-github/activePullRequest
2. Use #tool:github/github-mcp-server/search_pull_requests to find recently closed and recently reviewed pull requests in this repository
3. Use #tool:github/github-mcp-server/pull_request_read to read code review comments that are *not* from `@coderabbitai[bot]` in all pull requests found in this session
   * List the types top-level code review comments (and their `html_url` and their `user.login`) left by humans that were *missed* by `@coderabbitai[bot]`; we are going to need those for later.
   * The goal is to know the *difference* between the code review comments left by humans and those left by `@coderabbitai[bot]` so we can update the path instructions accordingly.
4. Use #tool:search/fileSearch to find the `.coderabbit?(.*).y?(a)ml` file
5. Use #tool:search/readFile to read the `reviews.path_instructions` from the found configuration file
6. Plan your update out loud.
   * List the rules that need to be updated.
   * List the rules that need to be added.
   * Your update should merge intelligently by preserving valuable content while updating outdated instructions.
   * Focus on code review comment types that `@coderabbitai[bot]` has missed raising in recent reviews.
   * Avoid generic advice ("write tests", "handle errors"); focus on *this* project's specific approaches.
7. Use #tool:edit/editFiles to update the `reviews.path_instructions` section of the configuration file with your planned changes

Here's the schema for `reviews.path_instructions`:

```yaml
reviews: # Settings related to reviews.
  path_instructions: # Provide specific additional guidelines for code review based on file paths.
    - path: # File path glob pattern. Example: **/*.js
      instructions: # Provides specific additional guidelines for code review based on file paths.
```
