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

set yrange [0:2.5]

set output "svg/fusion-64.svg"
set title "rv8-bench (Runtime fusion=on,off 64-bit)"
plot 'data/benchmarks.dat' using \
	'rv-jit-df-riscv64-O3-runtime':xtic(1) ti 'rv8-fuse-off-riscv64-O3-runtime', \
	'' u 'rv-jit-df-riscv64-Os-runtime' ti 'rv8-fuse-off-riscv64-Os-runtime', \
	'' u 'rv-jit-riscv64-O3-runtime' ti 'rv8-fuse-on-riscv64-O3-runtime', \
	'' u 'rv-jit-riscv64-Os-runtime' ti 'rv8-fuse-on-riscv64-Os-runtime'

set yrange [0:4]

set output "svg/fusion-32.svg"
set title "rv8-bench (Runtime fusion=on,off 32-bit)"
plot 'data/benchmarks.dat' using \
	'rv-jit-df-riscv32-O3-runtime':xtic(1) ti 'rv8-fuse-off-riscv32-O3-runtime', \
	'' u 'rv-jit-df-riscv32-Os-runtime' ti 'rv8-fuse-off-riscv32-Os-runtime', \
	'' u 'rv-jit-riscv32-O3-runtime' ti 'rv8-fuse-on-riscv32-O3-runtime', \
	'' u 'rv-jit-riscv32-Os-runtime' ti 'rv8-fuse-on-riscv32-Os-runtime'
