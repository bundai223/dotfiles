#! /bin/bash
# gvim for cygwin
# Please copy this file to /bin/*

if [ $# -eq 0 ]; then
  ${VIMPATH}
else
  ${VIMPATH}  $(cygpath -aw $*) &
fi

