# Trackers

How to do each **tracker operation** for each tracker.
Use only the section for the tracker of the issue.
If you cannot tell which tracker the issue is from, ask the user.

The operations:

- **Read**: get the issue, its comments, images, attachments, and linked issues.
- **Branch**: get the branch name.
- **Write**: add or replace the `Agent notes` section at the end of the issue description, and keep the rest of the description as it is.
  A tracker section can permit a comment when the description cannot be edited.
- **Link**: link the PR to the issue.

## Linear

Match: a `linear.app` URL, or an ID like `ENG-123` when the Linear tools exist.
Load the Linear tools with ToolSearch.

- **Read**: `get_issue`, then `list_comments`.
  Read images with `extract_images`, and attachments with `get_attachment`.
  Read the parent issue, the sub-issues, the related and blocking issues, the project, and the linked Linear documents.
- **Branch**: the `gitBranchName` field from `get_issue`.
- **Write**: `save_issue` with `patch`.
  Use the Linear collapsible section:

  ```
  +++ Agent notes

  <notes>

  +++
  ```

  Verify with `get_issue`.
- **Link**: put the issue URL in the Notes section of the PR body.
  The Linear GitHub integration links the PR from the branch name.

## GitHub

Match: a `github.com/<owner>/<repo>/issues/<n>` URL, or `#<n>` for the current repo.

- **Read**: `gh issue view <url> --json number,title,body,comments,labels,milestone,url`.
  Read sub-issues and the parent issue with `gh api repos/<owner>/<repo>/issues/<n>/sub_issues` and `gh api repos/<owner>/<repo>/issues/<n>/parent`.
  Read the issues and PRs that the body and the comments link, with `gh`.
  View images with `WebFetch`.
  Name each image that you cannot read in the context summary.
- **Branch**: `<n>-<title in kebab-case>`, cut to 60 characters.
- **Write**: `gh issue edit <url> --body-file <file>`.
  Make the file from the current description, so that the rest of the description does not change:

  ```sh
  gh issue view <url> --json body --jq .body > <file>
  ```

  Do not type the description again.
  Edit only the `Agent notes` section in the file: replace it, or add it at the end.
  Use a `<details>` section:

  ```
  <details>
  <summary>Agent notes</summary>

  <notes>

  </details>
  ```

  Verify with `gh issue view`: the description outside the section must be the same as before.
  If the edit fails, for example because you cannot edit the issue, add the section as a comment that starts with 🤖: `gh issue comment <url> --body-file <file>`.
- **Link**: put `Closes <issue url>` in the Notes section of the PR body.

## Other trackers

Find a tool that can read the issue: search with ToolSearch for the tracker name, or use `WebFetch` for a public URL.

- **Read**: get all that the tool can get from the Read operation.
- **Branch**: `<issue-id>-<title in kebab-case>`, cut to 60 characters.
- **Write**: edit the description if the tool can.
  If it cannot, add the notes as a comment.
  If the tool cannot write, give the notes to the user to add.
  In each case, start the notes with 🤖.
- **Link**: put the issue URL in the Notes section of the PR body.

If no tool can read the issue, stop and ask the user for the issue content.
