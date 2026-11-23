---
name: golang-deslop
description: Keeps Go code lean by limiting comments and avoiding premature abstractions, and keeps commit messages and PR descriptions short. ALWAYS use this skill whenever writing, generating, editing, refactoring, or reviewing Go (Golang) code, including .go files, Go tests, and Go code review or PR review, and whenever writing a git commit message or pull request description for Go changes. Apply it even when the user does not mention style, comments, or abstractions, and alongside any other Go skill.
---

# Go de-slop

Apply these rules to every piece of Go code you write, and check for them in every Go code you review.

## 0. Load the relevant golang-* skills first

Before writing or reviewing Go code, invoke the matching `cc-skills-golang:golang-*` skills with the Skill tool. Start with `cc-skills-golang:golang-how-to`, which reads the task and loads the right set. Then add any obvious ones it missed:

| Task involves | Skills |
|---|---|
| Any Go code | `golang-code-style`, `golang-naming` |
| Errors, logging | `golang-error-handling` |
| Tests | `golang-testing` (+ `golang-stretchr-testify` if used) |
| Goroutines, channels, locks | `golang-concurrency`, `golang-context` |
| Interfaces, structs, API design | `golang-structs-interfaces`, `golang-design-patterns` |
| Restructuring existing code | `golang-refactoring` |
| gRPC, database, CLI | `golang-grpc`, `golang-database`, `golang-cli` |
| Security review | `golang-security`, `golang-safety` |
| Performance | `golang-performance`, `golang-benchmark` |
| Go docs, READMEs | `golang-documentation` |
| Dependencies, go.mod | `golang-dependency-management` |

Load only what the task needs, and load each skill once per session. If a golang-* skill conflicts with this one on comment length, abstraction, or commit/PR verbosity, this skill wins.

## 1. Keep comments minimal

- A comment is at most 5 lines. Go longer only when strictly necessary, for example a non-obvious algorithm, a subtle concurrency invariant, or a required package/API doc.
- Comment the *why*, never the *what*. If the code already says it, delete the comment.
- Don't narrate steps (`// Create the client`, `// Loop over items`, `// Return the result`).
- Don't leave comments about the change itself (`// Added X`, `// Now uses Y instead of Z`, `// Fixed bug`). That belongs in the commit message.
- Doc comments on exported identifiers stay: one or two sentences starting with the identifier name.
- No decorative banners or section-divider comments.

```go
// Bad
// processItems processes the items.
// It takes a slice of items and loops over them.
// For each item it calls validate, and if validation
// fails it returns the error. Otherwise it appends
// the item to the result slice and finally returns it.
// This ensures that only valid items are returned.
func processItems(items []Item) ([]Item, error) {

// Good
// processItems returns the valid items, stopping at the first invalid one.
func processItems(items []Item) ([]Item, error) {
```

## 2. Avoid premature abstractions

- Write the code inline first. Extract a helper only when the same pattern shows up clearly and repeatedly (roughly 3+ call sites), or when a function is too long to follow.
- Don't add an interface that has only one implementation, unless a consumer needs it (for example a test double at a package boundary). Accept interfaces where they're consumed; don't pre-declare them next to the implementation.
- Don't write single-use wrappers, pass-through functions, or helpers that just rename a stdlib call.
- Don't add config structs, functional options, generics, or factories for flexibility nobody has asked for yet.
- Don't create `utils`, `helpers`, or `common` packages to hold one or two functions.
- Two similar blocks of code are fine. Duplication is cheaper than the wrong abstraction.

```go
// Bad: one caller, adds indirection only
func buildURL(base, path string) string { return base + path }

// Good: inline it
url := base + path
```

## 3. Never use functions that panic

- Never call `Must...` functions (`regexp.MustCompile`, `template.Must`, `uuid.MustParse`, etc.) or any other function that intentionally panics on error.
- Always use the error-returning alternative (`regexp.Compile`, `template.New(...).Parse`, `uuid.Parse`) and handle or propagate the error, so the caller controls how it's reported.
- Don't write your own `Must...` helpers or `panic` on errors either.

```go
// Bad
re := regexp.MustCompile(pattern)

// Good
re, err := regexp.Compile(pattern)
if err != nil {
	return fmt.Errorf("compile pattern %q: %w", pattern, err)
}
```

## 4. Keep commit messages and PR descriptions minimal

- Commit messages: a short imperative subject line (under ~72 chars). Add a body only when the *why* isn't obvious, and keep it to a few lines.
- PR descriptions: a few sentences or bullets on what changed and why. Add testing notes only if they're non-obvious.
- Get straight to the point. No filler ("This PR aims to..."), no restating the diff file by file, no marketing tone, no template sections that nobody requires.
- Keep any required attribution or trailer lines.
- These rules limit length, not format. When the repo, the user, or another skill requires a format (conventional commits, an issue ID, fixed PR sections), use that format and keep each part short.

```text
# Bad
refactor(user): refactor the user service to improve code quality and maintainability

This commit refactors the user service. It updates the GetUser function
to use the new cache, adds error handling, updates the tests, and
improves overall readability of the code.

# Good
perf(user): cache lookups in GetUser

Profile page was hitting the DB on every render.
```

## When reviewing

Flag violations of these rules with file:line and a concrete fix: the shortened comment, the inlined code, or the error-returning alternative to a `Must...` call. When you generate code yourself, check it against these rules before presenting it.
