set term svg
set auto x
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set ylabel "Runtime (secs)" offset 2,0,0
set yrange [0:10]

set output "svg/runtime-O3.svg"
set title "rv8-bench (Runtime -O3)"
plot 'data/benchmarks.dat' using \
	'qemu-aarch64-O3-runtime':xtic(1) ti col, \
	'' u 'qemu-riscv32-O3-runtime' ti col, \
	'' u 'qemu-riscv64-O3-runtime' ti col, \
	'' u 'rv-jit-riscv32-O3-runtime' ti col, \
	'' u 'rv-jit-riscv64-O3-runtime' ti col, \
	'' u 'native-x86-32-O3-runtime' ti col, \
	'' u 'native-x86-64-O3-runtime' ti col

set output "svg/runtime-Os.svg"
set title "rv8-bench (Runtime -Os)"
plot 'data/benchmarks.dat' using \
	'qemu-aarch64-Os-runtime':xtic(1) ti col, \
	'' u 'qemu-riscv32-Os-runtime' ti col, \
	'' u 'qemu-riscv64-Os-runtime' ti col, \
	'' u 'rv-jit-riscv32-Os-runtime' ti col, \
	'' u 'rv-jit-riscv64-Os-runtime' ti col, \
	'' u 'native-x86-32-Os-runtime' ti col, \
	'' u 'native-x86-64-Os-runtime' ti col
