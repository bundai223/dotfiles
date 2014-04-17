#! /bin/bash
TRASH=~/.Trash

if [ ! -d $TRASH ]; then
  mkdir -p $TRASH
fi

for i do
  mv $i $TRASH
done

