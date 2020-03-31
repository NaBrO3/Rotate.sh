#!/bin/bash

SIZE=${SIZE-"1024 * 1024 * 1024"}
NROT=${NROT-"1024"}
FILE=${FILE-"app.log"}
SIZE=$(( $SIZE ))
NROT=$(( $NROT ))

if [ -f "$FILE" ]; then
  if [ `uname` = 'Darwin' ]; then
    BYTE=`stat -f%z "$FILE"`
  else
    BYTE=`stat -c%s "$FILE"`
  fi
else
  BYTE=0
fi

while read LINE; do
  BYTE=$((BYTE + 1 + ${#LINE}))
  if [ $BYTE -gt $SIZE ]; then
    for i in `seq $((NROT - 1)) -1 1`; do
      [ -f "$FILE.$i" ] && mv -f "$FILE.$i" "$FILE.$((i + 1))"
    done
    mv -f "$FILE" "$FILE.1"
    BYTE=0
  fi
  echo -e $LINE >> "$FILE"
done
