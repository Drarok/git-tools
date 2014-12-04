# Git Tools

## Introduction

This is a collection of little scripts that I use regularly whilst working with Git.

## Installation

**TL;DR:**
```bash
git clone https://github.com/Drarok/git-tools.git
cd git-tools
./install.sh
```

## The Tools

### git-dead-branch

Lists (and optionally removes) branches that have been merged to develop or master.

```bash
develop $ git dead-branch
feature/new-buttons
fix/something-cool

develop $ git dead-branch --cleanup
feature/new-buttons
Deleted branch feature/new-buttons (was 2dd9a39).
fix/something-cool
Deleted branch fix/something-cool (was a3a5173).
```

### git-merged

If you currently have a branch checked out that has been merged upstream (such as when you still have your merged Pull Request checked out), you can use this to tidy up. This of is as saying "This branch has been merged to *branch*".
It switches to the destination branch (develop by default), does a `pull`, then deletes the branch you were on.
Finally, it also performs a prune on the remote, keeping the list of remote branches in sync with upstream.

```bash
feature/new-buttons $ git merged develop
f628724..93a5b00  develop -> origin/develop
Deleted branch feature/new-buttons (was 2dd9a39).
develop $

hotfix/emergency-kittens $ git merged master
a5b8751..36c5316  master -> origin/master
Deleted branch hotfix/emergency-kittens (was 6adb76d).
master $
```

### git-publish
