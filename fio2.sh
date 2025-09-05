#!/bin/bash

# Directory for results
RESULTS=~/fio_nvme_tests
mkdir -p $RESULTS

# Device under test (adjust to your NVMe LUN path!)
DEV=/dev/nvme0n1

# Common settings
RUNTIME=120        # 2 minutes per test
IODEPTH=32         # good for NVMe; can raise to 64 or 128
NUMJOBS=8          # simulate multiple DB sessions
BLOCKSIZE=8k       # common DB block size
SIZE=10G           # amount of data to hit per job

# Sequential write (like RMAN backup)
fio --name=seqwrite --rw=write --bs=1M \
    --numjobs=$NUMJOBS --iodepth=$IODEPTH --runtime=$RUNTIME \
    --time_based --filename=$DEV --size=$SIZE \
    --group_reporting > $RESULTS/seqwrite.log

# Sequential read (like full table scan or restore)
fio --name=seqread --rw=read --bs=1M \
    --numjobs=$NUMJOBS --iodepth=$IODEPTH --runtime=$RUNTIME \
    --time_based --filename=$DEV --size=$SIZE \
    --group_reporting > $RESULTS/seqread.log

# Random read (queries hitting indexes, small row fetches)
fio --name=randread --rw=randread --bs=$BLOCKSIZE \
    --numjobs=$NUMJOBS --iodepth=$IODEPTH --runtime=$RUNTIME \
    --time_based --filename=$DEV --size=$SIZE \
    --group_reporting > $RESULTS/randread.log

# Random write (OLTP inserts/updates, redo logs)
fio --name=randwrite --rw=randwrite --bs=$BLOCKSIZE \
    --numjobs=$NUMJOBS --iodepth=$IODEPTH --runtime=$RUNTIME \
    --time_based --filename=$DEV --size=$SIZE \
    --group_reporting > $RESULTS/randwrite.log

# Mixed 70% read / 30% write (typical DB workload)
fio --name=mixed --rw=randrw --rwmixread=70 --bs=$BLOCKSIZE \
    --numjobs=$NUMJOBS --iodepth=$IODEPTH --runtime=$RUNTIME \
    --time_based --filename=$DEV --size=$SIZE \
    --group_reporting > $RESULTS/mixed.log

echo "All tests complete. Results saved in $RESULTS"
