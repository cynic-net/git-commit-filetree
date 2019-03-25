#!/usr/bin/env bash
. t/test-lib.sh
echo '1..6'


##### 1
start_test 'expect_fails'
expect_fails test_equal 0 1
test_equal 1 1              # Ensure subsequent assertions not broken.
end_test

#### 2
start_test 'expect_fails fails passing assertion'
expect_fails test_equal 0 0
if $ENCOUNTERED_FAILURE; then
    #   Ok, it does fail properly; carry on.
    ENCOUNTERED_FAILURE=false
    true
else
    echo '# expect_fails did not fail a passing assertion'
    ENCOUNTERED_FAILURE=true
fi
end_test

#### 3
start_test 'expect_fails keeps previous failure state'
test_equal 0 1
expect_fails test_equal 0 1
if $ENCOUNTERED_FAILURE; then
    #   Ok, it does fail properly; carry on.
    ENCOUNTERED_FAILURE=false
else
    echo '# expect_fails didn not fail a passing assertion'
    ENCOUNTERED_FAILURE=true
fi
end_test

##### 4
start_test 'test_equal success'
test_equal 'abc' 'abc'
end_test

##### 5
start_test 'test_equal failure'
expect_fails test_equal 'abc' 'XYZ'
end_test

##### 6
start_test 'test_equal glob'
test_equal 'a*' 'abc'
expect_fails test_equal 'abc' 'Abc'
test_equal '[Aa]bc' 'Abc'
test_equal '[Aa]bc' 'abc'
expect_fails test_equal 'abc' '[Aa]bc'
end_test
