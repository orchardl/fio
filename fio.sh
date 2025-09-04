#!/bin/bash
# vm-datastore-test.sh
# Run a set of IO benchmarks using fio and save results to a file.

RESULTS="fio_results_$(hostname)_$(date +%F_%H-%M-%S).log"

echo "Starting I/O tests on $(hostname)..." | tee $RESULTS

# Sequential write test
echo -e "\n=== Sequential Write (1G, 4k blocks) ===" | tee -a $RESULTS
fio --name=seqwrite --ioengine=libaio --rw=write --bs=4k --size=1G --numjobs=1 --runtime=60 --time_based --group_reporting | tee -a $RESULTS

# Sequential read test
echo -e "\n=== Sequential Read (1G, 4k blocks) ===" | tee -a $RESULTS
fio --name=seqread --ioengine=libaio --rw=read --bs=4k --size=1G --numjobs=1 --runtime=60 --time_based --group_reporting | tee -a $RESULTS

# Random write test
echo -e "\n=== Random Write (4k, 60s) ===" | tee -a $RESULTS
fio --name=randwrite --ioengine=libaio --rw=randwrite --bs=4k --size=1G --numjobs=1 --runtime=60 --time_based --group_reporting | tee -a $RESULTS

# Random read test
echo -e "\n=== Random Read (4k, 60s) ===" | tee -a $RESULTS
fio --name=randread --ioengine=libaio --rw=randread --bs=4k --size=1G --numjobs=1 --runtime=60 --time_based --group_reporting | tee -a $RESULTS

# Mixed workload
echo -e "\n=== Mixed Read/Write (70% read, 30% write, 4k, 60s) ===" | tee -a $RESULTS
fio --name=mixed --ioengine=libaio --rw=randrw --rwmixread=70 --bs=4k --size=1G --numjobs=1 --runtime=60 --time_based --group_reporting | tee -a $RESULTS

echo -e "\nAll tests complete. Results saved to $RESULTS"
