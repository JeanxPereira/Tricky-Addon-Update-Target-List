#!/system/bin/sh

MODPATH=${0%/*}
OUTPUT="$MODPATH/exclude-list"

. $MODPATH/util_func.sh

find_busybox
check_wget

# Fetch Xposed module package names
wget --no-check-certificate -q -O - "https://modules.lsposed.org/modules.json" 2>/dev/null | \
grep -o '"name":"[^"]*","description":' | \
awk -F'"' '{print $4}' > "$OUTPUT"

# Fetch additional package names
wget --no-check-certificate -q -O - "https://raw.githubusercontent.com/KOWX712/Tricky-Addon-Update-Target-List/master/more-excldue.json" 2>/dev/null | \
grep -o '"package-name": *"[^"]*"' | \
awk -F'"' '{print $4}' >> "$OUTPUT"

if [ ! -s "$OUTPUT" ]; then
    echo "Error: Failed to fetch data." > "$OUTPUT"
    exit 1
fi