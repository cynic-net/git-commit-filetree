git-commit-filetree
===================

Overview
--------

`git-commit-filetree` is a git command that takes an arbitrary tree
of files (typically not part of a Git repository's working copy) and
commits that tree to the tip of a given branch. It can be run as a
standalone script or installed as a git subcommand.

Usage: `git commit-filetree <branch> <path>`

### Motivation

This command allows you to do builds on one branch of a repo and then
commit the build output to a separate branch of the same repo. This
avoids making a second clone of the repo with its own working copy,
doing the commit there, and then moving the new commit from the second
repo to the first.

### Usage with GitHub Pages

A classic use case is when you're using your own build system to
create a static website to be hosted on [`github.io`]. The procedure
is as follows:

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

* Deal with cases when the local branch to which we're committing is
  behind its remote tracking branch. Normally we'd want the local branch
  to be fast-forwarded to match the remote before doing our commit.
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
  `path/to/git-commit-filetree mybranch myfiles`.
* Copy the script to any directory in your path and invoke it through
  `git commit-filetree mybranch myfiles`.

The second method will allow you to use `git` options before the
`commit-filetree` command, such as `-C`, `--git-dir`, `--work-tree`,
and so on.

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
instead. If you have any difficulty, please feel free to contact the
authors for help.


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


Copying and Usage
-----------------

![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png)
To the extent possible under law,
<a rel="dct:publisher"
    href="https://github.com/cjs-cynic-net/git-commit-filetree">
    <span property="dct:title">Curt J. Sampson and Nishant Rodrigues</span></a>
have waived all copyright and related or neighboring rights to
<span property="dct:title">git-commit-filetree</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
content="JP" about="https://github.com/cjs-cynic-net/git-commit-filetree">
Japan</span>.

### Attribution

Though attribution is not required, we would appreciate it
if, should you use this code in your own works, you name
the authors and provide a link back to the [original source
repository](https://github.com/cynic-net/git-commit-filetree).

### Further Information

See the `COPYING` file in this repository for complete information. To
sumarize:

The authors have with this deed has dedicated the work to the public
domain by waiving all of their rights to the work worldwide under
copyright law, including all related and neighboring rights, to the
extent allowed by law.

You can copy, modify, distribute and perform the work, even for
commercial purposes, all without asking permission. However:

* In no way are the patent or trademark rights of any person affected by
  CC0, nor are the rights that other persons may have in the work or in
  how the work is used, such as publicity or privacy rights.

* We who associated our work with this deed make no warranties about
  the work, and disclaim liability for all uses of the work, to the
  fullest extent permitted by applicable law.

* When using or citing the work, you should not imply endorsement by the
  authors.



<!-------------------------------------------------------------------->
[`github.io`]: https://help.github.com/categories/github-pages-basics/
