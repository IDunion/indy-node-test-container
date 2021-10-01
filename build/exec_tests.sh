#!/bin/bash
set -e

PIP_OPTS="-q"
if [ "$1" == "-v" ]
  then 
    # verbose mode
    PIP_OPTS=""
    PYTEST_OPTS="-v"
  else
    TEST_PATH="$1"   
fi
if [ -z "$TEST_PATH" ]
  then
    if [ -z "$2" ]
      then
        echo "Test path not specified"
        exit -1
      else TEST_PATH="$2"
    fi
fi

# echo -e "[...]Downgrading PIP version"
# pip install pip==9.0.3 $PIP_VERSION

PIP_VERSION=$(pip --version)
echo -e "[...]Using PIP version $PIP_VERSION"


echo -e "[...]\t Installing 'indy-plenum' from local path"
cd indy-plenum
pip install -e .[tests] $PIP_OPTS
cd ..

echo -e "[...]\t Installing 'indy-node' from local path"
cd indy-node
pip install -e .[tests] $PIP_OPTS


echo -e "[...]\t Executing tests on path '$TEST_PATH'"
pytest $PYTEST_OPTS $TEST_PATH