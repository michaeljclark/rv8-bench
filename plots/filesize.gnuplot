set term svg
set auto x
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set ylabel "Filesize (bytes)" offset 2,0,0
set yrange [0:150000]

set output "svg/filesize-O3.svg"
set title "rv8-bench (Filesize -O3)"
plot 'data/benchmarks.dat' using \
	'aarch64-O3-filesize':xtic(1) ti col, \
	'' u 'riscv32-O3-filesize' ti col, \
	'' u 'riscv64-O3-filesize' ti col, \
	'' u 'x86-32-O3-filesize' ti col, \
	'' u 'x86-64-O3-filesize' ti col

set output "svg/filesize-Os.svg"
set title "rv8-bench (Filesize -Os)"
plot 'data/benchmarks.dat' using \
	'aarch64-Os-filesize':xtic(1) ti col, \
	'' u 'riscv32-Os-filesize' ti col, \
	'' u 'riscv64-Os-filesize' ti col, \
	'' u 'x86-32-Os-filesize' ti col, \
	'' u 'x86-64-Os-filesize' ti col
