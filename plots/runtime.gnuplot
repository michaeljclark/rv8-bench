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
set yrange [0:10]

set grid xtics ytics

set output "svg/runtime-O3-64.svg"
set title "rv8-bench (Runtime -O3 64-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-O3-runtime':xtic(1) ti col, \
	'' u 'rv-jit-riscv64-O3-runtime' ti 'rv8-riscv64-O3-runtime', \
	'' u 'qemu-riscv64-O3-runtime' ti col, \
	'' u 'qemu-aarch64-O3-runtime' ti col

set output "svg/runtime-Os-64.svg"
set title "rv8-bench (Runtime -Os 64-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-64-Os-runtime':xtic(1) ti col, \
	'' u 'rv-jit-riscv64-Os-runtime' ti 'rv8-riscv64-Os-runtime', \
	'' u 'qemu-riscv64-Os-runtime' ti col, \
	'' u 'qemu-aarch64-Os-runtime' ti col

set yrange [0:6]

set output "svg/runtime-O3-32.svg"
set title "rv8-bench (Runtime -O3 32-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-32-O3-runtime':xtic(1) ti col, \
	'' u 'rv-jit-riscv32-O3-runtime' ti 'rv8-riscv32-O3-runtime', \
	'' u 'qemu-riscv32-O3-runtime' ti col

set output "svg/runtime-Os-32.svg"
set title "rv8-bench (Runtime -Os 32-bit)"
plot 'data/benchmarks.dat' using \
	'native-x86-32-Os-runtime':xtic(1) ti col, \
	'' u 'rv-jit-riscv32-Os-runtime' ti 'rv8-riscv32-Os-runtime', \
	'' u 'qemu-riscv32-Os-runtime' ti col
