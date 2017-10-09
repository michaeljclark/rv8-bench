set term svg size 640,480
set auto x
set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101

set ylabel "Retired Operations" offset 2,0,0
set yrange [0:1e10]

set grid xtics ytics

set output "svg/operations-O3-64.svg"
set title "rv8-bench (Retired Operations -O3 64-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-O3-instret':xtic(1) ti col, \
	'' u 'native-x86-64-O3-uops-executed' ti col, \
	'' u 'native-x86-64-O3-uops-issued' ti col, \
	'' u 'native-x86-64-O3-uops-retired-all' ti col, \
	'' u 'native-x86-64-O3-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv64-O3-instret' ti col

set output "svg/operations-O2-64.svg"
set title "rv8-bench (Retired Operations -O2 64-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-O2-instret':xtic(1) ti col, \
	'' u 'native-x86-64-O2-uops-executed' ti col, \
	'' u 'native-x86-64-O2-uops-issued' ti col, \
	'' u 'native-x86-64-O2-uops-retired-all' ti col, \
	'' u 'native-x86-64-O2-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv64-O2-instret' ti col

set output "svg/operations-Os-64.svg"
set title "rv8-bench (Retired Operations -Os 64-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-Os-instret':xtic(1) ti col, \
	'' u 'native-x86-64-Os-uops-executed' ti col, \
	'' u 'native-x86-64-Os-uops-issued' ti col, \
	'' u 'native-x86-64-Os-uops-retired-all' ti col, \
	'' u 'native-x86-64-Os-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv64-Os-instret' ti col

set yrange [0:2e10]

set output "svg/operations-O3-32.svg"
set title "rv8-bench (Retired Operations -O3 32-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-32-O3-instret':xtic(1) ti col, \
	'' u 'native-x86-32-O3-uops-executed' ti col, \
	'' u 'native-x86-32-O3-uops-issued' ti col, \
	'' u 'native-x86-32-O3-uops-retired-all' ti col, \
	'' u 'native-x86-32-O3-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv32-O3-instret' ti col

set output "svg/operations-O2-32.svg"
set title "rv8-bench (Retired Operations -O2 32-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-32-O2-instret':xtic(1) ti col, \
	'' u 'native-x86-32-O2-uops-executed' ti col, \
	'' u 'native-x86-32-O2-uops-issued' ti col, \
	'' u 'native-x86-32-O2-uops-retired-all' ti col, \
	'' u 'native-x86-32-O2-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv32-O2-instret' ti col

set output "svg/operations-Os-32.svg"
set title "rv8-bench (Retired Operations -Os 32-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-32-Os-instret':xtic(1) ti col, \
	'' u 'native-x86-32-Os-uops-executed' ti col, \
	'' u 'native-x86-32-Os-uops-issued' ti col, \
	'' u 'native-x86-32-Os-uops-retired-all' ti col, \
	'' u 'native-x86-32-Os-uops-retired-slots' ti col, \
	'' u 'rv-sim-riscv32-Os-instret' ti col
