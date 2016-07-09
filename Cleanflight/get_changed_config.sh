#!/bin/bash

BOARD=`echo "$1" | sed -r 's/\w+\_(\w+)\.dump/\1/'`
BOARD_DEFAULTS=defaults_"$BOARD".dump

echo "Board defaults file: $BOARD_DEFAULTS"

echo "CHANGES:"
echo
diff --unchanged-line-format="" --old-line-format="" --new-line-format="%L" "$1" "$BOARD_DEFAULTS"
