#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

usage() {
  echo "usage: wait-checks.sh <pr-url> [<sha>]" >&2
  exit 2
}

[[ $# -ge 1 && $# -le 2 && $1 =~ ^https://github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]] || usage
repo="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
sha="${2:-$(git rev-parse HEAD)}"
register_seconds="${WAIT_CHECKS_REGISTER_SECONDS:-180}"
# A foreground command stops after 10 minutes, and a subagent runs the script in the foreground.
# 480 keeps 2 minutes for the last sleep and the last gh calls.
max_seconds="${WAIT_CHECKS_MAX_SECONDS:-480}"

# Immediately after a push, GitHub has no checks for the new commit.
# Without this wait, `gh pr checks` reports the old commit or no checks.
# A new commit can also give an API error for a short time, so an error is -1.
deadline=$((SECONDS + register_seconds))
while :; do
  runs=$(gh api "repos/$repo/commits/$sha/check-runs" --jq .total_count 2>/dev/null) || runs=-1
  statuses=$(gh api "repos/$repo/commits/$sha/status" --jq .total_count 2>/dev/null) || statuses=-1
  ((runs > 0 || statuses > 0)) && break
  if ((SECONDS >= deadline)); then
    if ((runs < 0 || statuses < 0)); then
      echo "cannot read the checks of $sha in $repo" >&2
      exit 1
    fi
    echo "sha: $sha"
    echo "result: none"
    exit 0
  fi
  sleep 15
done

# The PR head can be behind the push, and more workflows can register.
until [[ $(gh pr view "$1" --json headRefOid --jq .headRefOid 2>/dev/null) == "$sha" ]]; do
  if ((SECONDS >= deadline)); then
    echo "the head of the PR is not $sha" >&2
    exit 1
  fi
  sleep 15
done
sleep 15

# After 3 consecutive gh errors, stop the wait: the gh call below then fails and shows the error.
errors=0
while ((SECONDS < max_seconds)); do
  if pending=$(gh pr checks "$1" --json bucket --jq 'any(.[]; .bucket == "pending")' 2>/dev/null); then
    [[ $pending == false ]] && break
    errors=0
  elif ((++errors >= 3)); then
    break
  fi
  sleep 30
done

checks=$(gh pr checks "$1" --json name,bucket,link)
result=$(jq -r '
  if any(.[]; .bucket == "pending") then "pending"
  elif any(.[]; .bucket == "fail" or .bucket == "cancel") then "failed"
  else "passed" end' <<<"$checks")

echo "sha: $sha"
echo "result: $result"
jq -r '.[] | select(.bucket != "pass" and .bucket != "skipping") | "\(.bucket)\t\(.name)\t\(.link)"' <<<"$checks"
