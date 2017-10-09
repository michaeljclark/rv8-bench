set term svg size 640,480
set auto x
set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101

set ylabel "Filesize (bytes)" offset 2,0,0
set yrange [0:150000]

set grid xtics ytics

set output "svg/filesize-O3.svg"
set title "rv8-bench (Filesize -O3)"
plot 'data/benchmarks.dat' using \
	'arm-O3-filesize':xtic(1) ti 'arm32-O3-filesize', \
	'' u 'aarch64-O3-filesize' ti col, \
	'' u 'riscv32-O3-filesize' ti col, \
	'' u 'riscv64-O3-filesize' ti col, \
	'' u 'x86-32-O3-filesize' ti col, \
	'' u 'x86-64-O3-filesize' ti col

set output "svg/filesize-O2.svg"
set title "rv8-bench (Filesize -O2)"
plot 'data/benchmarks.dat' using \
	'arm-O2-filesize':xtic(1) ti 'arm32-O2-filesize', \
	'' u 'aarch64-O2-filesize' ti col, \
	'' u 'riscv32-O2-filesize' ti col, \
	'' u 'riscv64-O2-filesize' ti col, \
	'' u 'x86-32-O2-filesize' ti col, \
	'' u 'x86-64-O2-filesize' ti col

set output "svg/filesize-Os.svg"
set title "rv8-bench (Filesize -Os)"
plot 'data/benchmarks.dat' using \
	'arm-Os-filesize':xtic(1) ti 'arm32-Os-filesize', \
	'' u 'aarch64-Os-filesize' ti col, \
	'' u 'riscv32-Os-filesize' ti col, \
	'' u 'riscv64-Os-filesize' ti col, \
	'' u 'x86-32-Os-filesize' ti col, \
	'' u 'x86-64-Os-filesize' ti col
