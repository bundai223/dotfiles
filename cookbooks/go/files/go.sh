#!/bin/bash

TOOLS_PATH=/usr/local

which go>/dev/null 2>&1 || export GOROOT=${TOOLS_PATH}/go
export GOPATH=~/go
## go lang
if [ "$GOROOT" != "" ]; then
  export PATH=$GOROOT/bin:$PATH
fi
if [ "$GOPATH" != "" ]; then
  export PATH=$GOPATH/bin:$PATH
fi
