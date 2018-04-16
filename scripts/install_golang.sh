#! /bin/bash

function usage()
{
  'usage : bash install_golang.sh'
  '  please set $GOPATH and $GOROOT'
}

install_golang()
{
  # Already installed?
  go version && return 0

  # install go
  #OS_TYPE=linux-386
  OS_TYPE=linux-amd64
  GO_VERSION=1.7.4
  ZIPNAME=go${GO_VERSION}.${OS_TYPE}.tar.gz
  set +eu
  CHECK_VERSION=$(go version|grep ${GO_VERSION})
  set -eu
  if [ -z "${CHECK_VERSION}" ]; then
    wget http://golang.org/dl/${ZIPNAME}
    sudo tar zxvf ${ZIPNAME} -C /usr/local
    rm ${ZIPNAME}
  fi
}

# go utility tools.
install_from_goget()
{
  echo goimports
  go get golang.org/x/tools/cmd/goimports # go formatter.

  echo godoc
  go get golang.org/x/tools/cmd/godoc     # go document viewer.

  echo gocode
  go get github.com/nsf/gocode            # go completions for editor.

  # install tool made by go.
  echo ghq
  go get github.com/motemen/ghq        # git repos manager
  echo peco
  go get github.com/peco/peco/cmd/peco # search interface looks like unite.vim

  #echo vet
  #go get golang.org/x/tools/cmd/vet       # go static analyser.
  #echo cover
  #go get golang.org/x/tools/cmd/cover     # go measure coverage on test.
  #echo golint
  #go get github.com/golang/lint           # go lint
}



# not setting GOPATH
if [ ! $GOPATH ]; then
  usage
  exit 1
fi
if [ ! $GOROOT ]; then
  usage
  exit 1
fi

if [ ! -d $GOPATH ]; then
  mkdir -p $GOPATH
fi

install_golang
install_from_goget

