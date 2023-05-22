#!/bin/bash

tmpfile=$(mktemp)

adb shell screencap -p > $tmpfile
mogrify -resize 50% $tmpfile
osascript -e "set the clipboard to (read (POSIX file \"$tmpfile\") as JPEG picture)"

rm $tmpfile
