#!/bin/sh
# flash-partition.sh <partition-name> <file>

PARTITION=$1
FILE=$2

if [ -z "$PARTITION" ] || [ -z "$FILE" ]; then
    echo "Usage: $0 <partition-name> <file>"
    echo "Example: $0 qspi-fpga design.bit"
    exit 1
fi

MTD_NUM=$(grep "$PARTITION" /proc/mtd | cut -d: -f1 | sed 's/mtd//')

if [ -z "$MTD_NUM" ]; then
    echo "Partition '$PARTITION' not found!"
    exit 1
fi

echo "Flashing '$FILE' to '$PARTITION' (/dev/mtd$MTD_NUM)..."
flashcp -v "$FILE" /dev/mtd$MTD_NUM

if [ $? -eq 0 ]; then
    echo "Success!"
else
    echo "Failed!"
    exit 1
fi

dd if=/dev/mtd0 of=/dev/null bs=1 count=1