#/bin/bash

. t/test-lib.sh

echo "1..3"

##### 1

test_name 'Check usage return value'
git commit-filetree  >/dev/null 2>&1
test_equal 129 $?

##### 2

test_name 'Check usage message (no args)'
expected="Usage: git commit-filetree <branch> <path>"
actual=$(git commit-filetree 2>&1 >/dev/null || true)
test_equal "$expected" "$actual"

##### 3

test_name 'Check usage message (1 arg)'
actual=$(git commit-filetree foobar 2>&1 >/dev/null || true)
test_equal "$expected" "$actual"

exit 0
