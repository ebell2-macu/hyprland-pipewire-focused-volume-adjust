#!/usr/bin/env bash
# Get the PID of the currently focused window
APP_ID=$(hyprctl activewindow | awk '/pid:/ {print $2}')

# Get all child PIDs of the parent process
CHILD_PIDS=$(pgrep -P $APP_ID)
CHILD_PIDS="$APP_ID $CHILD_PIDS"
# Initialize the stream ID variable
STREAM_ID=""

# Check each child PID for a matching PipeWire stream
for PID in $CHILD_PIDS; do
  MATCHES=$(wpctl status | grep "pid:$PID" | awk '{print $1}' | tr -d '.')
  for MATCH in $MATCHES; do
    # Inspect each match to check for associated objects
    INSPECT_OUTPUT=$(wpctl inspect -a $MATCH)
    if echo "$INSPECT_OUTPUT" | grep -q 'associated objects:'; then
      ASSOCIATED_OBJECT=$(echo "$INSPECT_OUTPUT" | grep -A 1 'associated objects:' | awk '/id/ {print $3}' | sed 's/,//')
      if [ -n "$ASSOCIATED_OBJECT" ]; then
        STREAM_ID=$ASSOCIATED_OBJECT
        break 2
      fi
    fi
  done
done

# Check if the argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <amount>"
  echo "Example: $0 0.5- (to decrease by 5%)"
  echo "Example: $0 1.0+ (to increase by 10%)"
  exit 1
fi

# Adjust the volume based on the provided parameter
if [ -n "$STREAM_ID" ]; then
  if [ "$1" == "toggle" ]; then
    wpctl set-mute "$STREAM_ID" toggle
  else
    wpctl set-volume "$STREAM_ID" "$1"
  fi
else
  echo "No valid audio stream found for PID $APP_ID or its children"
fi
