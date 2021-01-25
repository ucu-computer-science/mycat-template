#!/usr/bin/bash
{
    BINDIR=${1:-./build}
    TESTDIR=${2:-./tests}

    # Test 2: help flags
    echo "# Test 2: help flags"
    $BINDIR/mycat -h > /dev/null \
        || >&2 echo "mycat fails with -h"
    $BINDIR/mycat --help > /dev/null \
        || >&2 echo "mycat fails with --help"
    diff <($BINDIR/mycat nonexistentfile -h 2> /dev/null) <($BINDIR/mycat -h) &> /dev/null \
        || >&2 echo "mycat tries to read files with -h"
    diff <($BINDIR/mycat nonexistentfile --help 2> /dev/null) <($BINDIR/mycat --help) &> /dev/null \
        || >&2 echo "mycat tries to read files with --help"

    # Test 3: error behavior
    echo
    echo "# Test 3: error behavior"
    [[ -n $($BINDIR/mycat nonexistentfile 2> /dev/stdout > /dev/null) ]] \
        || >&2 echo "mycat prints error message to stdout instead of stderr"
    ! $BINDIR/mycat nonexistentfile &> /dev/null \
        || >&2 echo "mycat does not set the error code"

    # Test 4: file reading
    echo
    echo "# Test 4: file reading"
    diff <($BINDIR/mycat $TESTDIR/smallfile.txt 2> /dev/null) <(cat $TESTDIR/smallfile.txt) &> /dev/null \
        || >&2 echo "mycat output differs from cat on the small file"
    diff <($BINDIR/mycat $TESTDIR/war_and_peace.txt 2> /dev/null) <(cat $TESTDIR/war_and_peace.txt) &> /dev/null \
        || >&2 echo "mycat output differs from cat on the big file"
    diff <($BINDIR/mycat $TESTDIR/smallfile.txt $TESTDIR/war_and_peace.txt 2> /dev/null) <(cat $TESTDIR/smallfile.txt $TESTDIR/war_and_peace.txt) &> /dev/null \
        || >&2 echo "mycat output differs from cat on the multiple files"
    [[ -z $($BINDIR/mycat $TESTDIR/smallfile.txt nonexistentfile $TESTDIR/war_and_peace.txt 2> /dev/null) ]] \
        || >&2 echo "mycat prints something to stdout (probably file content) when among multiple files one is nonexistent"

    # Test 5: -A flag
    echo
    echo "# Test 5: -A flag"
    $BINDIR/mycat -A $TESTDIR/txtfiles.zip \
        || >&2 echo "mycat fails on reading zip archive with -A"
    
    # Test 6: signal bombing
    echo
    echo "# Test 6: signal bombing"
    diff <($BINDIR/signal_bomber $BINDIR/mycat $TESTDIR/war_and_peace.txt 2> /dev/null) <(cat $TESTDIR/war_and_peace.txt) &> /dev/null \
        || >&2 echo "mycat output differs from cat during signal bombing"
    $BINDIR/signal_bomber $BINDIR/mycat -A $TESTDIR/txtfiles.zip \
        || >&2 echo "mycat fails on reading zip archive with -A during signal bombing"

    # Test 7: valgrind
    echo
    echo "# Test 7: valgrind"
    valgrind $BINDIR/mycat $TESTDIR/war_and_peace.txt &> /dev/null \
        || >&2 echo "valgrind errors on reading big files"
    valgrind $BINDIR/mycat -A $TESTDIR/txtfiles.zip &> /dev/null \
        || >&2 echo "valgrind errors on reading zip archive with -A"
}
