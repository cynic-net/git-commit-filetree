#/bin/bash
. t/test-lib.sh
set -e

echo "1..5"

branch=testbr
repo=tmp/test/repo
files=tmp/test/files
export GIT_AUTHOR_DATE=2000-01-01T00:00:00
export GIT_COMMITTER_DATE=2001-01-01T00:00:00

git="git --git-dir=$repo --work-tree=$files"

make_test_repo() {
    rm -rf tmp/test
    mkdir -p $repo $files $files/subdir
    echo foo > $files/one
    echo foo > $files/subdir/two
    $git init -q
    $git add -A
    $git commit -q $date -m 'commit 1'
}

##### 1

start_test 'Check we fail when branch does not exist'
make_test_repo
test_equal 'fatal: invalid reference: $branch
128' \
    $($git --git-dir=$repo commit-filetree $branch $files; echo $?)
end_test '# TODO finish writing commit-filetree'

##### 2

start_test 'Check we fail when unknown files are in the working copy.'
make_test_repo
$git branch $branch
touch $files/unknown
test_equal 'Cannot commit with unknonwn files in working copy.
1' \
    $($git --git-dir=$repo commit-filetree $branch $files; echo $?)
end_test '# TODO finish writing commit-filetree'

##### 3

start_test 'Check we fail when working copy is dirty'
make_test_repo
$git branch $branch
touch $files/three
$git add three
test_equal 'Cannot commit with uncommited files in working copy.
1' \
    $($git --git-dir=$repo commit-filetree $branch $files; echo $?)
end_test '# TODO finish writing commit-filetree'

##### 4

start_test 'Check commit'

make_test_repo
$git branch $branch
test_equal "d065ff0 (HEAD, $branch, master) commit 1" \
            "$($git log --pretty=oneline --color=never)"

echo bar > $files/one
echo bar > $files/subdir/two
$git --git-dir=$repo commit-filetree $branch $files

test_equal "xxxxxxx ($branch) commit 2
d065ff0 (HEAD, master) commit 1" \
            "$($git log --pretty=oneline --color=never) $branch"

end_test '# TODO finish writing commit-filetree'

##### 4

start_test 'Check we do not commit if it would be an empty commit.'
make_test_repo
$git branch $branch
$git --git-dir=$repo commit-filetree $branch $files
$git --git-dir=$repo commit-filetree $branch $files
test_equal "xxxxxxx ($branch) commit 2
d065ff0 (HEAD, master) commit 1" \
            "$($git log --pretty=oneline --color=never) $branch"

end_test '# TODO finish writing commit-filetree'
