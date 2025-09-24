#!/bin/bash
# Test different blackout methods to find what works

DISPLAY="${DISPLAY:-:1}"
OUTPUT=$(DISPLAY="$DISPLAY" xrandr | grep " connected" | head -1 | awk '{print $1}')

echo "Testing blackout methods on display $DISPLAY, output $OUTPUT"
echo "Press Enter after each test to continue..."
echo

echo "TEST 1: Brightness to 0"
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 0
read -p "Is screen black? Press Enter to restore..."
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 1

echo "TEST 2: Brightness to 0.001" 
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 0.001
read -p "Is screen black? Press Enter to restore..."
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 1

echo "TEST 3: Brightness 0.1 (should be dim but visible)"
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 0.1
read -p "Is screen very dim? Press Enter to restore..."
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --brightness 1

echo "TEST 4: Gamma to black (might cause color issues)"
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --gamma 0:0:0
read -p "Is screen black? Press Enter to restore..."
DISPLAY="$DISPLAY" xrandr --output "$OUTPUT" --gamma 1:1:1

echo "All tests complete. Screen restored to normal."
echo
echo "Which test worked best? Use that in your blackout script."