NOTE: This is more complex than it seems, and requires a lot of thinking about
the standard workflow, though the code should be pretty simple in the end.

Repos:
    A: repo of current working directory (nothing to do with this)
    B: repo containing files-to-be-commited
    C: repo to which we're committing (--git-dir)

source: Checked out branch in C, or "nothing" if C is a bare repo
target: Branch in C to be commited to.

0.  Look at git-sh-setup.
1.  Do a fetch on target repo.
2.  IF      source
        AND source has source-tracking
        AND source-tracking is ahead
        FAIL
3.  IF target is ancestor of target-tracking
       Do update-ref
    ELSE IF target-tracking is ancestor of target
       Do nothing
    ELSE
       FAIL
