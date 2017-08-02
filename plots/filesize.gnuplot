set title "rv8-bench (File size -O3)"
set term svg
set output "svg/filesize.svg"
set auto x
set yrange [0:10]
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0
set ylabel "Filesize (bytes)" offset 2,0,0
set yrange [0:150000]
plot 'data/benchmarks.dat' using \
	'aarch64-O3-filesize':xtic(1) ti col, \
	'' u 'i386-O3-filesize' ti col, \
	'' u 'riscv32-O3-filesize' ti col, \
	'' u 'riscv64-O3-filesize' ti col, \
	'' u 'x86-64-O3-filesize' ti col
