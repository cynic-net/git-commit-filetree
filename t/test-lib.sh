#!/usr/bin/env bash

cd $(dirname $0)/..
mkdir -p tmp
PATH=$(cd $(dirname $0)/../bin && /bin/pwd):$PATH

export TZ=UTC
export GIT_AUTHOR_EMAIL=author@example.com
export GIT_AUTHOR_NAME='The Author'
export GIT_COMMITTER_EMAIL=committer@example.com
export GIT_COMMITTER_NAME='The Committer'

#----------------------------------------------------------------------

CURRENT_TEST_NUMBER=0
CURRENT_TEST_NAME=

start_test() {
    CURRENT_TEST_NUMBER=$(expr $CURRENT_TEST_NUMBER + 1)
    CURRENT_TEST_NAME="$*"
    ENCOUNTERED_FAILURE=false
}

end_test() {
    $ENCOUNTERED_FAILURE && echo -n 'not '
    echo ok $CURRENT_TEST_NUMBER - "$CURRENT_TEST_NAME" $*
}

fail_test() {
    ENCOUNTERED_FAILURE=true
}

expect_fails() {
    #   Run the passed-in assertion and expect that it fails.
    #   This involves some tricky handling of $ENCOUNTERED_FAILURE
    #   (which kinda feels like an error-preservation monad).
    #   This trickiness probably demonstrates design deficiences in
    #   our so-called "test framework."
    #
    local old_ENCOUNTERED_FAILURE=$ENCOUNTERED_FAILURE
    ENCOUNTERED_FAILURE=false
    echo "# Expecting failure for" "$@"
    "$@"
    if $ENCOUNTERED_FAILURE; then
        #   As expected; cleanup failure so this doesn't cause test to fail.
        ENCOUNTERED_FAILURE=$old_ENCOUNTERED_FAILURE
    else
        echo "# Expected failure did not occur"
        ENCOUNTERED_FAILURE=true
    fi
}

test_equal() {
    local expected="$1" actual="$2"
    local not=''

    [ -z "$3" ] || {
        not=not
        echo "# Extra arguments passed to test_equal."
        return
    }

    [ "$expected" == "$actual" ] || {
        fail_test
        echo "# Expected: '$expected'"
        echo "#   Actual: '$actual'"
    }
    return 0
}
