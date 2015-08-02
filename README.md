git-commit-filetree
===================

Overview
--------

`git-commit-filetree` is a git command that takes an arbitrary tree
of files (typically not part of a Git repository's working copy) and
commits that file tree to the end of a given branch. It can be run as a
standalone script, or installed as a git command.

Usage: `git commit-filetree <branch> <path>`

### Motivation

This command allows you to do builds on one branch of a repo and then
commit the build output to a separate branch of the same repo. This
avoids making a second clone of the repo with its own working copy,
doing the commit there, and then moving the new commit from the second
repo to the first.

### Usage with Github.io

A classic use case is when you're using your own build system to create
a static website to be hosted on
[github.io](https://help.github.com/categories/github-pages-basics/).
The procedure is as follows:

* Check out your repo's `master` branch (or whichever branch contains your
  source code and build system).
* Build your site into an output directory (e.g., `./_site`).
* Run `git commit-filetree gh-pages ./_site`. This will update the `gh-pages`
  branch with the new version of the site under the `./_site` directory.
* `git push --all` to upload your latest source and generated site to Github.
* Github.io will start serving the new version of the site from the
  `gh-pages` branch.

Missing Features
----------------

The following features are still missing from this version of the
program.

* Test fixes for Git 2.5.x (or perhaps all of Git 2.x) due to a
  format change git log's `%d` format.
* Update the reflog after doing the commit.
* Add the ability to specify a commit message.
  (This should allow a token to substitute the current HEAD commit at
  the time git-commit-filetree was run, e.g., `%h`.)
* Manual page.

Installation and Invocation
---------------------------

The script can be invoked in one of two ways. In both cases,
you'll need to ensure that the executable bit is set.

* Directly from the command line. E.g.,
  `./git-commit-filetree mybranch myfiles`.
* Copy the script to any directory in your path and invoke it through
  `git commit-filetree mybranch myfiles`.

The second method will allow you to use `git` parameters before the
`commit-filetree` command, such as `-C`, `--git-dir`, `--work-tree`, and
so on.

### Usage with Windows

The standard Git installation for Windows includes the Bash shell, and
so it appears that Windows has everything necessary to run this command.
However, we've not tried it. If you wish to get it working, we would
appreciate any feedback you could offer.

Testing
-------

The test framework uses shell scripts that generate output conforming to
the [TAP Specification](https://testanything.org/tap-specification.html).

The top-level `Test` script will run the tests using perl's `prove`
program, which is part of the standard install on most GNU/Linux
systems. However, you should be able to use other TAP test harnesses
should the need arise. If you have any difficulty, please feel free to
contact the authors for help.

Authors and History
-------------------

* Curt J. Sampson <<cjs@cynic.net>>
* Nishant Rodrigues <<nishantjr@gmail.com>>

cjs and Nishant together came up with the general idea.

Nishant did the heavy lifting to figure out exactly how to use the
Git plumbing to get the job done. (It turned out to be a little more
complex than we'd thought due to Git's propensity to want to stage
things through an index file rather than just directly create a tree
object. Perhaps that's for performance reasons in the more general case
of git use.)

cjs wrote the test framework and tests, and the `git-commit-filetree`
command framework (error handling, usage messages, etc.).
