#!/bin/sh

BLANK='#00000000'
CLEAR='#44475a'
DEFAULT='#ff00ffcc'
TEXT='#ff00ffcc'
WRONG='#ff5555'
VERIFYING='#50fa7b'

i3lock \
  --insidever-color=$CLEAR \
  --ringver-color=$VERIFYING \
  \
  --insidewrong-color=$CLEAR \
  --ringwrong-color=$WRONG \
  \
  --inside-color=$BLANK \
  --ring-color=$DEFAULT \
  --line-color=$BLANK \
  --separator-color=$DEFAULT \
  \
  --verif-color=$TEXT \
  --wrong-color=$TEXT \
  --time-color=$TEXT \
  --date-color=$TEXT \
  --layout-color=$TEXT \
  --keyhl-color=$WRONG \
  --bshl-color=$WRONG \
  \
  --screen 1 \
  --blur 5 \
  --clock \
  --indicator \
  --time-str="%H:%M" \
  --date-str="%A, %d/%m/%Y" \
  --keylayout 1
