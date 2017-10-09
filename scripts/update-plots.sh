#!/bin/bash

keynum() {
	nl data/keylist.txt | grep $1 | awk '{ print $1; }'
}

substitute() {
	cp $1 $2
	for i in $(cat data/keylist.txt | grep -v '#'); do
		n=$(keynum $i)
		k=$(echo  $i | tr '-' '_')
		sed -i '' "s#$k#\$$n#g" $2
	done
}

# gather benchmark results
npm start gather

# join Os and O3 histograms
for i in aes bigint dhrystone miniz norx primes qsort sha512;
do
	# rename zero register to x0
	sed -i '' s#zero#x0# stats/rv-hist-riscv64-$i-O3.dir/hist-reg.csv
	sed -i '' s#zero#x0# stats/rv-hist-riscv64-$i-Os.dir/hist-reg.csv

	# combine O3 and Os register histograms
	join <(sort -k1,1 stats/rv-hist-riscv64-$i-O3.dir/hist-reg.csv) \
		 <(sort -k1,1 stats/rv-hist-riscv64-$i-O2.dir/hist-reg.csv) \
		 >stats/rv-hist-reg-riscv64-$i.tmp.1
	join <(sort -k1,1 stats/rv-hist-reg-riscv64-$i.tmp.1) \
		 <(sort -k1,1 stats/rv-hist-riscv64-$i-Os.dir/hist-reg.csv) \
		 >stats/rv-hist-reg-riscv64-$i.tmp.2
	echo "register O3 O2 Os" > stats/rv-hist-reg-riscv64-$i.csv
	grep -v register <stats/rv-hist-reg-riscv64-$i.tmp.2 >>stats/rv-hist-reg-riscv64-$i.csv

	# combine O3 and Os instruction histograms
	join <(sort -k1,1 stats/rv-hist-riscv64-$i-O3.dir/hist-inst.csv) \
		 <(sort -k1,1 stats/rv-hist-riscv64-$i-O2.dir/hist-inst.csv) \
		 >stats/rv-hist-inst-riscv64-$i.tmp.1
	join <(sort -k1,1 stats/rv-hist-inst-riscv64-$i.tmp.1) \
		 <(sort -k1,1 stats/rv-hist-riscv64-$i-Os.dir/hist-inst.csv) \
		 >stats/rv-hist-inst-riscv64-$i.tmp.2
	echo "opcode O3 O2 Os" > stats/rv-hist-inst-riscv64-$i.csv
	grep -v opcode <stats/rv-hist-inst-riscv64-$i.tmp.2 >>stats/rv-hist-inst-riscv64-$i.csv

	# remove temporary files
	rm -f stats/rv-hist-*-riscv64-$i.tmp.*
done

# substitute names with column numbers for the mips plot
grep -v benchmark data/benchmarks.dat >data/benchmarks_noheader.dat
substitute plots/mips.gnuplot.template plots/mips.gnuplot

# generate the plots
#gnuplot plots/fusion.gnuplot
gnuplot plots/filesize.gnuplot
gnuplot plots/mips.gnuplot
gnuplot plots/operations.gnuplot
gnuplot plots/optimisation.gnuplot
gnuplot plots/registers.gnuplot
gnuplot plots/instructions.gnuplot
gnuplot plots/runtime.gnuplot
