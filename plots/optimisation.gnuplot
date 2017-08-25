set term svg
set auto x
set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101

set ylabel "Runtime (secs)" offset 2,0,0

set grid xtics ytics

set yrange [0:2.0]

set output "svg/optimisation-x86.svg"
set title "rv8-bench (Optimisation native x86 -O3 vs -Os)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-O3-runtime':xtic(1) ti 'native-x86-64-O3-runtime', \
	'' u 'native-x86-64-Os-runtime' ti 'native-x86-64-Os-runtime', \
	'' u 'native-x86-32-O3-runtime' ti 'native-x86-32-O3-runtime', \
	'' u 'native-x86-32-Os-runtime' ti 'native-x86-32-Os-runtime'

set yrange [0:4]

set output "svg/optimisation-riscv.svg"
set title "rv8-bench (Optimisation rv8 riscv -O3 vs -Os)"
plot 'data/benchmarks.dat' using \
	'rv-jit-riscv64-O3-runtime':xtic(1) ti 'rv8-riscv64-O3-runtime', \
	'' u 'rv-jit-riscv64-Os-runtime' ti 'rv8-riscv64-Os-runtime', \
	'' u 'rv-jit-riscv32-O3-runtime' ti 'rv8-riscv32-O3-runtime', \
	'' u 'rv-jit-riscv32-Os-runtime' ti 'rv8-riscv32-Os-runtime'
