#!/bin/bash
for i in aes dhrystone miniz norx primes qsort sha512; do
	sed -i '' s#zero#x0# stats/rv-hist-riscv64-$i-O3.dir/hist-reg.csv
	sed -i '' s#zero#x0# stats/rv-hist-riscv64-$i-Os.dir/hist-reg.csv
	join <(sort -k1,1 stats/rv-hist-riscv64-$i-O3.dir/hist-reg.csv) <(sort -k1,1 stats/rv-hist-riscv64-$i-Os.dir/hist-reg.csv) >stats/rv-hist-riscv64-$i.tmp
	echo "register O3 Os" > stats/rv-hist-riscv64-$i.csv
	grep -v register <stats/rv-hist-riscv64-$i.tmp >>stats/rv-hist-riscv64-$i.csv
	rm -f stats/rv-hist-riscv64-$i.tmp
done
