#!/bin/bash
# install go

# refs https://golang.org/dl/
#OS_TYPE=linux-386
OS_TYPE=linux-amd64
GO_VERSION=1.8

ZIPNAME=go${GO_VERSION}.${OS_TYPE}.tar.gz
set +eu
CHECK_VERSION=$(go version|grep ${GO_VERSION})
set -eu

if [ -z "${CHECK_VERSION}" ]; then
  wget http://golang.org/dl/${ZIPNAME}
  sudo tar zxvf ${ZIPNAME} -C /usr/local
  rm ${ZIPNAME}
fi

PATH=/usr/local/go/bin/:$PATH
export PATH

