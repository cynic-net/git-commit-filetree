#/bin/bash
. t/test-lib.sh
set -e
rm -rf tmp/test

echo "1..1"

branch=testbr
repo=tmp/test/repo
files=tmp/test/files
export GIT_AUTHOR_DATE=2000-01-01T00:00:00
export GIT_COMMITTER_DATE=2001-01-01T00:00:00

git="git --git-dir=$repo --work-tree=$files"

##### 1

start_test 'Check commit'
mkdir -p $repo $files $files/subdir
echo foo > $files/one
echo foo > $files/subdir/two
$git init -q
$git add -A
$git commit -q $date -m 'commit 1'
$git branch $branch

test_equal "d065ff0 (HEAD, $branch, master) commit 1" \
            "$($git log --pretty=oneline --color=never)"

echo bar > $files/one
echo bar > $files/subdir/two
echo XXXXX
$git --git-dir=$repo commit-filetree $branch $files

test_equal "d065ff0 (HEAD, master) commit 1" \
            "$($git log --pretty=oneline --color=never)"
test_equal "xxxxxxx ($branch) commit 2" \
            "$($git log --pretty=oneline --color=never) $branch"

end_test '# TODO finish writing commit-filetree'
