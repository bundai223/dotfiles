#!/bin/bash

TOOLS_PATH=/usr/local

export GOROOT=${TOOLS_PATH}/go
export GOPATH=~/go
## go lang
if [ "$GOROOT" != "" ]; then
  export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

export PATH=/usr/local/go/bin:$PATH
