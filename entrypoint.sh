#!/bin/bash
FILE=/app/mochizuki.conf
if test -f "$FILE"; then
    echo "Configuration found"
    mochizuki
else
    echo "Configuration not found"
    exit 1
fi
