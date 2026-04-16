#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

echo "Today Date is: $TIMESTAMP"

echo "$(pwd)"

# echo "$( ls -a )"

echo "$( who )"

echo "$( uptime )"

echo "$( df -h / )"

echo "$( ls -1 | wc -l )"
echo "$( head -n 4 16.Loops-install.sh )"