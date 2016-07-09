#!/bin/bash

if [ ! -f "$1" ]; then
  echo "Configuration file does not exist!"
  exit 1
fi

BOARD=`echo "$1" | sed -r 's/\w+\_(\w+)\_(\w+)\.dump/\1/'`
FCS=`echo "$1" | sed -r 's/\w+\_(\w+)\_(\w+)\.dump/\2/'`
BOARD_DEFAULTS=defaults_"$BOARD"_"$FCS".dump

echo "Board defaults file: $BOARD_DEFAULTS"
if [ ! -f "$BOARD_DEFAULTS" ]; then
  echo "Default configuration file does not exist!"
  exit 1
fi

echo "CHANGES:"
echo
diff --unchanged-line-format="" --old-line-format="" --new-line-format="%L" "$BOARD_DEFAULTS" "$1"
