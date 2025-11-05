#!/bin/bash

LOG="/tmp/root_usage.log"
THRESHOLD=1073741824  # 1 GB in bytes

# Get current used space in bytes
CURRENT=$(df --output=used / | tail -1)

# If no log exists, initialize it
if [ ! -f "$LOG" ]; then
    echo "$CURRENT" > "$LOG"
    exit 0
fi

# Read previous value
PREVIOUS=$(cat "$LOG")
DIFF=$((CURRENT - PREVIOUS))

# Check if increase ≥ 1 GB
if [ "$DIFF" -ge "$THRESHOLD" ]; then
    echo "Disk usage increased by ≥ 1 GB: $((DIFF / 1024 / 1024)) MB"
    # Optional: send desktop notification
    notify-send "Disk Alert" "Root disk usage increased by ≥ 1 GB"
fi

# Update log
echo "$CURRENT" > "$LOG"
