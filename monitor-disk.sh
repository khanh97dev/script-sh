#!/bin/sh

LOG="/tmp/root_usage.log"
THRESHOLD=1073741824  # 1 GB in bytes

while true; do
    # Get current used space in bytes (multiply KB by 1024)
    CURRENT=$(df --output=used / | tail -1 | tr -d ' ')
    CURRENT=$((CURRENT * 1024))

    # If no log exists, initialize it
    if [ ! -f "$LOG" ]; then
        echo "$CURRENT" > "$LOG"
        sleep 300
        continue
    fi

    # Read previous value
    PREVIOUS=$(cat "$LOG")
    DIFF=$((CURRENT - PREVIOUS))

    # Check if increase ≥ 1 GB
    TIME=$(date +'%Y-%m-%d %H:%M:%S')

    if [ "$DIFF" -ge "$THRESHOLD" ]; then
        echo -ne "\r[$TIME] [ALERT] Disk usage increased by ≥ 1 GB: $((DIFF / 1024 / 1024)) MB"
    else
        echo -ne "\r[$TIME] [INFO] Disk usage unchanged. Prev: $((PREVIOUS / 1024 / 1024)) MB, Curr: $((CURRENT / 1024 / 1024)) MB"
    fi




    # Update log
    echo "$CURRENT" > "$LOG"

    # Wait 5 minutes before checking again
    sleep 300
done
