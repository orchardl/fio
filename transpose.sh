#!/bin/bash
# simple_fio_csv.sh
# Usage: ./transpose.sh fio_results_<name>.og fio_results.csv

if [ $# -ne 2 ]; then
    echo "Usage: $0 <fio_log_file> <fio_csv_file>"
    exit 1
fi

LOG="$1"
OUT="$2"

# Grab metrics
IOPS=$(grep -oP 'IOPS=\K[^,]+' "$LOG")
BW=$(grep -oP 'BW=\K\S+' "$LOG")
LAT=$(grep -oP '^\s*lat \([a-z]+\):.*avg=\K[^,]+' "$LOG")

# Turn them into arrays
IOPS_ARR=($IOPS)
BW_ARR=($BW)
LAT_ARR=($LAT)

# Labels
LABELS=("" "seqwrite" "seqread" "randwrite" "randread" "mixedread" "mixedwrite")

# Write header
echo "${LABELS[0]},IOPS,BW,Latency" > "$OUT"

# Write rows
for i in {1..6}; do
    echo "${LABELS[$i]},${IOPS_ARR[$((i-1))]},${BW_ARR[$((i-1))]},${LAT_ARR[$((i-1))]}" >> "$OUT"
done

echo "CSV written to $OUT"
