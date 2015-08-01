git-commit-filetree
-------------------

`git-commit-filetree` is a git command that takes an arbitrary tree of
files and creates a commit of them appended to a given branch. It can
also be run as a standalone script.

Usage:

    git commit-filetree <branch> <path>

The main purpose of this command is to allow you to commit builds made
on one branch of a repo to another branch without having to set up a
second repo and working copy.

A classic use case is when you're using your own build system to a
static website to be hosted on `github.io`. You would check out your
repo's `master` branch, build your site into an output directory (e.g.,
`output/site`) and then run `git commit-filetree gh-pages output/site`
to commit the new version of the site to the `gh-pages` branch. Then a
`git push --all` will upload both the updated source and updated build
and github.io will start serving the new version of the site on the
`gh-pages` branch.
