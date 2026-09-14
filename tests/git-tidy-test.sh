#!/bin/bash
set -euo pipefail

script_dir=$(cd "$(dirname "$0")/.." && pwd)
fixture_root=$(mktemp -d "${TMPDIR:-/tmp}/git-tidy-test.XXXXXX")
trap 'rm -rf "$fixture_root"' EXIT

export GIT_AUTHOR_NAME=test
export GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test
export GIT_COMMITTER_EMAIL=test@example.com

remote=$fixture_root/remote.git
seed=$fixture_root/seed
repo=$fixture_root/repo

git init --bare --quiet "$remote"
git init --quiet "$seed"
git -C "$seed" switch --quiet -c main
printf 'base\n' > "$seed/file"
git -C "$seed" add file
git -C "$seed" commit --quiet -m base
git -C "$seed" remote add origin "$remote"
git -C "$seed" push --quiet -u origin main
git -C "$remote" symbolic-ref HEAD refs/heads/main
git clone --quiet "$remote" "$repo"

git -C "$repo" switch --quiet -c merged
printf 'merged\n' >> "$repo/file"
git -C "$repo" commit --quiet -am merged
git -C "$repo" switch --quiet main
git -C "$repo" merge --quiet --ff-only merged
git -C "$repo" push --quiet origin main
git -C "$repo" worktree add --quiet "$fixture_root/merged worktree" merged

git -C "$repo" branch dirty main
git -C "$repo" worktree add --quiet "$fixture_root/dirty" dirty
printf 'dirty\n' >> "$fixture_root/dirty/file"

git -C "$repo" branch locked main
git -C "$repo" worktree add --quiet "$fixture_root/locked" locked
git -C "$repo" worktree lock --reason active "$fixture_root/locked"

git -C "$repo" branch unmerged main
git -C "$repo" worktree add --quiet "$fixture_root/unmerged" unmerged
printf 'unmerged\n' >> "$fixture_root/unmerged/file"
git -C "$fixture_root/unmerged" commit --quiet -am unmerged

git -C "$repo" worktree add --quiet --detach "$fixture_root/detached" main

output=$(cd "$repo" && "$script_dir/scripts/git-tidy" --no-worktrees)
test -d "$fixture_root/merged worktree"
case "$output" in *"merged (in use by worktree)"*) ;; *) echo "--no-worktrees did not preserve worktree branch" >&2; exit 1 ;; esac

output=$(cd "$repo" && "$script_dir/scripts/git-tidy" --dry-run)
case "$output" in *"Would remove worktrees: 2"*) ;; *) echo "dry run found the wrong removal count" >&2; exit 1 ;; esac
case "$output" in *"Would delete branches: 1"*) ;; *) echo "dry run found the wrong branch count" >&2; exit 1 ;; esac
test -d "$fixture_root/merged worktree"
test -d "$fixture_root/detached"

progress=$fixture_root/progress
output=$(cd "$repo" && "$script_dir/scripts/git-tidy" 2>"$progress")
case "$output" in *"Removed worktrees: 2"*) ;; *) echo "run removed the wrong number of worktrees" >&2; exit 1 ;; esac
case "$output" in *"Kept worktrees: 3"*) ;; *) echo "run kept the wrong number of worktrees" >&2; exit 1 ;; esac
grep -qx 'Removing worktrees: 0/2' "$progress"
grep -qx 'Removing worktrees: 2/2' "$progress"
test ! -e "$fixture_root/merged worktree"
test ! -e "$fixture_root/detached"
test -d "$fixture_root/dirty"
test -d "$fixture_root/locked"
test -d "$fixture_root/unmerged"
git -C "$repo" show-ref --verify --quiet refs/heads/dirty
git -C "$repo" show-ref --verify --quiet refs/heads/locked
git -C "$repo" show-ref --verify --quiet refs/heads/unmerged
if git -C "$repo" show-ref --verify --quiet refs/heads/merged; then
  echo "merged branch was not deleted after its worktree" >&2
  exit 1
fi

printf 'git-tidy tests passed\n'
