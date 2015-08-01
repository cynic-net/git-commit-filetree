#!/bin/bash

cd $(dirname $0)/..
mkdir -p tmp
PATH=$(cd $(dirname $0)/.. && /bin/pwd):$PATH

GIT_AUTHOR_EMAIL=author@example.com
GIT_AUTHOR_NAME='The Author'
GIT_COMMITTER_EMAIL=committer@example.com
GIT_COMMITTER_NAME='The Committer'

#----------------------------------------------------------------------

CURRENT_TEST_NUMBER=0
CURRENT_TEST_NAME=

test_name() {
    CURRENT_TEST_NUMBER=$(expr $CURRENT_TEST_NUMBER + 1)
    CURRENT_TEST_NAME="$*"
}

test_pass() {
    echo ok $CURRENT_TEST_NUMBER - "$CURRENT_TEST_NAME"
}

test_fail() {
    echo not ok $CURRENT_TEST_NUMBER - "$CURRENT_TEST_NAME"
}

test_equal() {
    local expected="$1" actual="$2"
    local not=''

    [ -z "$3" ] || {
        not=not
        echo "# Extra arguments passed to test_equal."
        return
    }

    [ "$expected" == "$actual" ] || not=not
    echo $not ok $CURRENT_TEST_NUMBER - "$CURRENT_TEST_NAME"
    [ -n "$not" ] && {
        echo "# Expected: '$expected'"
        echo "#   Actual: '$actual'"
    }
}
