#! /bin/bash

function usage()
{
    "usage : bash setup_golang.sh"
}

# not setting GOPATH
if [ ! $GOPATH ]; then
    exit 1
fi

if [ ! -d $GOPATH ]; then
    mkdir -p $GOPATH
fi


# go utility tools.
echo goimports
go get golang.org/x/tools/cmd/goimports # go formatter.

echo godoc
go get golang.org/x/tools/cmd/godoc     # go document viewer.

echo vet
go get golang.org/x/tools/cmd/vet       # go static analyser.

echo cover
go get golang.org/x/tools/cmd/cover     # go measure coverage on test.

echo gocode
go get github.com/nsf/gocode                    # go completions for editor.

echo golint
go get github.com/golang/lint                   # go lint

# install tool made by go.
go get github.com/motemen/ghq        # git repos manager
go get github.com/peco/peco/cmd/peco # search interface looks like unite.vim
