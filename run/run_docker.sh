#!/bin/bash
set -e

while getopts hp:v opt
do
    case $opt in
        h) echo "Usage: run_docker.sh [-h|-p INDY_PLENUM_PATH |-v] [TEST_PATH]"
           echo "========================================"
           echo "Arguments:"
           echo "-h                         This help screen"
           echo "-p INDY_PLENUM_PATH        Install Indy Plenum from specified path (must resolve to absolute path)"
           echo "-v                         Verbose output"
           echo "TEST_PATH                  Path to test folder (relative to 'indy-node' root path)"
           echo
           echo "Environment variables:"
           echo "INDY_NODE_PATH   Path to 'indy-node' folder (must resolve to absolute path)"
           echo "DOCKER_IMAGE     Name or ID of Docker image to run"
           echo "TEST_PATH        Ignored if provided as command agument (see above)"
           exit 0;;
        p) TEST_OPTS="$TEST_OPTS -p"
           INDY_PLENUM_PATH=($OPTARG);;
        v) TEST_OPTS="$TEST_OPTS -v";;
    esac
done

if [ -z "$INDY_NODE_PATH" ]
    then
        echo "Path to 'indy-node' not provided! Please specify as 'INDY_NODE_PATH' envvar."
        exit -1    
fi

if [ -z "$DOCKER_IMAGE" ]
    then
        echo "Docker image not provided! Please specify as 'DOCKER_IMAGE' envvar."
        exit -1    
fi

if [ -n "${!OPTIND}" ]
    then
        TEST_PATH=${!OPTIND}
fi
if [ -z "$TEST_PATH" ]
    then
        echo "Test path not provided! Please specify either as 'TEST_PATH' envvar or command arg."
        exit -1    
fi

if [ -n "$TEST_OPTS" ]
    then
        echo "Used settings:"
        echo "INDY_NODE_PATH: $INDY_NODE_PATH"
        echo "INDY_PLENUM_PATH: $INDY_PLENUM_PATH"
        echo "DOCKER_IMAGE: $DOCKER_IMAGE"
        echo "TEST_PATH: $TEST_PATH"
fi

if [ -z "$INDY_PLENUM_PATH" ]
    then
        # need to set path to anything in order for the bind mount to work
        INDY_PLENUM_PATH=~
fi

docker run --mount src=$INDY_NODE_PATH,target=/home/indy/indy-node,type=bind --mount src=$INDY_PLENUM_PATH,target=/home/indy/indy-plenum,type=bind $DOCKER_IMAGE ./exec_tests.sh $TEST_OPTS $TEST_PATH
