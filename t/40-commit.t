#!/usr/bin/env bash
. t/test-lib.sh
set -e -o 'pipefail'

echo "1..11"

branch=testbr
repo=tmp/test/repo
files=tmp/test/files
export GIT_AUTHOR_DATE=2000-01-01T00:00:00
export GIT_COMMITTER_DATE=2001-01-01T00:00:00

git="git --git-dir=$repo/.git --work-tree=$repo"
git_show_refs="$git show-ref --abbrev=12"
assert_branch() {
    local output="$1"
    local pattern="${2:-$branch}"
    test_equal "$output" "$($git_show_refs "$pattern")"
}

make_test_repo() {
    rm -rf tmp/test
    mkdir -p $repo/subdir $files/subdir
    echo foo > $repo/one
    echo foo > $repo/subdir/two
    $git init -q
    $git add -A
    $git commit -q $date -m 'commit 1'
}

##### 1

start_test 'Fail when branch does not exist'
make_test_repo
test_equal "Invalid ref: refs/heads/testbr
128" \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 2

start_test 'Fail when untracked files are in the working copy.'
make_test_repo
$git branch $branch
touch $repo/untracked
test_equal 'Cannot commit with untracked files in working copy.
1' \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 3

start_test 'Fail when working copy is dirty'
make_test_repo
$git branch $branch
touch $repo/three
$git add three
test_equal 'Cannot commit with uncommited files in working copy.
1' \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 4

start_test 'Commit message correct'

make_test_repo
$git branch $branch
echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files

test_equal 'Build from source commit 737b0f4.' \
    "$($git log -1 --color=never --format=%B $branch)"

end_test


##### 5

start_test 'Commit data correct'

make_test_repo
$git branch $branch
assert_branch '737b0f439051 refs/heads/master' master
assert_branch '737b0f439051 refs/heads/testbr'

echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files
assert_branch '003e5987f385 refs/heads/testbr'

end_test

##### 6

start_test 'Commit branchname has refs/heads prefix'

make_test_repo
$git branch $branch

echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree refs/heads/$branch $files
assert_branch '003e5987f385 refs/heads/testbr'

end_test

##### 7

start_test 'Run script standalone (instead of as git subcommand)'

make_test_repo
$git branch $branch

echo bar > $files/one
echo bar > $files/subdir/two
(cd $repo && ../../../bin/git-commit-filetree $branch ../files)
assert_branch '003e5987f385 refs/heads/testbr'

end_test

##### 8

start_test 'No commit if commit would be empty'
make_test_repo
$git branch $branch
echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files
$git commit-filetree $branch $files
$git commit-filetree $branch $files
assert_branch '003e5987f385 refs/heads/testbr'
end_test

##### 9

start_test 'Reflog is updated'
make_test_repo
$git branch $branch
echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files
test_equal \
    '003e598 testbr@{0}: commit-filetree: Build from source commit 737b0f4.
737b0f4 testbr@{1}: branch: Created from master' \
    "$($git reflog --no-decorate $branch)"
end_test

##### 10

make_test_repo_with_two_branches() {
    make_test_repo

    #   Test branch to which we commit
    $git branch $branch
    assert_branch '737b0f439051 refs/heads/testbr'
    touch $files/one; $git commit-filetree $branch $files
    assert_branch '8a4cf12bef5f refs/heads/testbr'

    #   Test tracking branch with an additional commit
    $git branch $branch-tracking $branch
    assert_branch '8a4cf12bef5f refs/heads/testbr-tracking' $branch-tracking
    touch $files/two; $git commit-filetree $branch-tracking $files
    assert_branch 'fcb13b95f172 refs/heads/testbr-tracking' $branch-tracking
}

start_test 'Fast-forward commit branch'
make_test_repo_with_two_branches

#   Make test branch track test-tracking branch, but it's one commit behind.
$git branch --set-upstream-to=$branch-tracking $branch
assert_branch '8a4cf12bef5f refs/heads/testbr'

touch $files/three
test_equal $'\n0' "$($git commit-filetree 2>&1 $branch $files; echo $?)"
#   Parent commit is head of tracking branch.
expected_log="\
____________
fcb13b95f172
8a4cf12bef5f"
test_equal "$expected_log" \
    "$($git log -3 --abbrev=12 --pretty='format:%h %ct' $branch)"

#   If you want to view the commit graph
#$git log --all --graph --pretty=oneline --abbrev=12

end_test

##### 11

start_test 'Cannot fast-forward commit branch'
make_test_repo_with_two_branches

#   Add another commit to local branch that's not on tracking branch.
touch $files/four
$git commit-filetree $branch $files
assert_branch 'fe1296c53332 refs/heads/testbr'

#   Make test branch track test-tracking branch, but 1/1 ahead/behind
$git branch --set-upstream-to=$branch-tracking $branch

touch $files/three
test_equal 'Cannot fast-foward local branch to tracking branch head.
1' \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"

#   If you want to view the commit graph
#$git log --all --graph --pretty=oneline --abbrev=12

end_test
