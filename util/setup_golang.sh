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
go get code.google.com/p/go.tools/cmd/goimports # go formatter.

echo godoc
go get code.google.com/p/go.tools/cmd/godoc     # go document viewer.

echo vet
go get code.google.com/p/go.tools/cmd/vet       # go static analyser.

echo cover
go get code.google.com/p/go.tools/cmd/cover     # go measure coverage on test.

echo gocode
go get github.com/nsf/gocode                    # go completions for editor.

# install tool made by go.
go get github.com/motemen/ghq        # git repos manager
go get github.com/peco/peco/cmd/peco # search interface looks like unite.vim
