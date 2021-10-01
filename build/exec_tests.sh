#!/bin/bash
set -e

PIP_OPTS="-q"

while getopts pv opt
do
   case $opt in
        p) INSTALL_PLENUM="YES";;
        v) # verbose mode
           PIP_OPTS=""
           PYTEST_OPTS="-v";;
    esac
done

if [ -n "${!OPTIND}" ]
    then
      TEST_PATH=${!OPTIND}
fi

if [ -z "$TEST_PATH" ]
  then
    echo "Test path not specified!"
    exit -1
fi

# echo -e "[...]Downgrading PIP version"
# pip install pip==9.0.3 $PIP_VERSION

PIP_VERSION=$(pip --version)
echo -e "[...]\t Using PIP version '$PIP_VERSION'"

if [ ! -z "$INSTALL_PLENUM" ]
  then
    echo -e "[...]\t Installing 'indy-plenum' from local path"
    cd indy-plenum
    pip install -e .[tests] $PIP_OPTS
    cd ..
  else
    echo -e "[...]\t Using installed version of 'indy-plenum'"
fi

echo -e "[...]\t Installing 'indy-node' from local path"
cd indy-node
pip install -e .[tests] $PIP_OPTS


echo -e "[...]\t Executing tests on path '$TEST_PATH'"
pytest $PYTEST_OPTS $TEST_PATH