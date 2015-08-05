#/bin/bash
. t/test-lib.sh
set -e

echo "1..8"

branch=testbr
repo=tmp/test/repo
files=tmp/test/files
export GIT_AUTHOR_DATE=2000-01-01T00:00:00
export GIT_COMMITTER_DATE=2001-01-01T00:00:00

git="git --git-dir=$repo/.git --work-tree=$repo"
git_show_refs="$git show-ref"

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

start_test 'Check we fail when branch does not exist'
make_test_repo
test_equal "Invalid ref: refs/heads/testbr
128" \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 2

start_test 'Check we fail when untracked files are in the working copy.'
make_test_repo
$git branch $branch
touch $repo/untracked
test_equal 'Cannot commit with untracked files in working copy.
1' \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 3

start_test 'Check we fail when working copy is dirty'
make_test_repo
$git branch $branch
touch $repo/three
$git add three
test_equal 'Cannot commit with uncommited files in working copy.
1' \
    "$($git commit-filetree 2>&1 $branch $files; echo $?)"
end_test

##### 4

start_test 'Check commit message'

make_test_repo
$git branch $branch
echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files

test_equal 'Build from source commit 737b0f4.' \
    "$($git log -1 --color=never --format=%B $branch)"

end_test


##### 5

start_test 'Check commit'

make_test_repo
$git branch $branch
test_equal "737b0f4390513917f3a19eece0dcd6a04e5deca3 refs/heads/master
737b0f4390513917f3a19eece0dcd6a04e5deca3 refs/heads/testbr" \
            "$($git_show_refs)"

echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files

test_equal "003e5987f3852ef5ad25ebd23b968de5f5104550 refs/heads/testbr" \
            "$($git_show_refs $branch)"

end_test

##### 6

start_test 'Check commit with refs/heads/branchname'

make_test_repo
$git branch $branch

echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree refs/heads/$branch $files

test_equal "003e5987f3852ef5ad25ebd23b968de5f5104550 refs/heads/testbr" \
            "$($git_show_refs $branch)"

end_test

##### 7

start_test 'Check commit when script is run standalone'

make_test_repo
$git branch $branch

echo bar > $files/one
echo bar > $files/subdir/two
(cd $repo && ../../../git-commit-filetree $branch ../files)

test_equal "003e5987f3852ef5ad25ebd23b968de5f5104550 refs/heads/testbr" \
            "$($git_show_refs $branch)"

end_test

##### 8

start_test 'Check we do not commit if it would be an empty commit.'
make_test_repo
$git branch $branch
echo bar > $files/one
echo bar > $files/subdir/two
$git commit-filetree $branch $files
$git commit-filetree $branch $files
$git commit-filetree $branch $files
test_equal "003e5987f3852ef5ad25ebd23b968de5f5104550 refs/heads/testbr" \
            "$($git_show_refs $branch)"

end_test
