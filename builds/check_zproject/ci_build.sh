#!/usr/bin/env bash
set -ex

cd $REPO_DIR/..
git clone --quiet --depth 1 https://github.com/zeromq/libzmq libzmq.git
git clone --quiet --depth 1 https://github.com/zeromq/czmq czmq.git
cd -

cd $REPO_DIR/..
git clone --quiet --depth 1 https://github.com/zeromq/zproject zproject.git
cd zproject.git
export PATH=$PATH:`pwd`

cd $REPO_DIR/..
git clone https://github.com/imatix/gsl.git gsl.git
cd gsl.git/src
make
export PATH=$PATH:`pwd`

# As we will overwrite this script file make sure bash loads the
# next lines into memory before executing
# http://stackoverflow.com/questions/21096478/overwrite-executing-bash-script-files
{
    cd $REPO_DIR
    gsl project.xml

    # keep an eye on git version used by CI
    git --version
    if [[ $(git --no-pager diff -w) ]]; then
        git --no-pager diff -w
        echo "There are diffs between current code and code generated by zproject!"
        exit 1
    fi
    if [[ $(git status -s) ]]; then
        git status -s
        echo "zproject generated new files!"
        exit 1
    fi
}
