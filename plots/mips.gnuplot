set term svg
set auto x
set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101

set ylabel "MIPS (Millions of Instructions Per Second)" offset 2,0,0
set yrange [0:15e9]

set grid xtics ytics

set output "svg/mips-O3-64.svg"
set title "rv8-bench (MIPS -O3 64-bit)"
plot 'data/benchmarks_noheader.dat' using \
	($19/$20):xtic(1) title 'native-x86-64-O3-mips', \
	'' u ($50/$44) title 'rv-jit-riscv64-O3-mips'

set output "svg/mips-Os-64.svg"
set title "rv8-bench (MIPS -Os 64-bit)"
plot 'data/benchmarks_noheader.dat' using \
	($26/$27):xtic(1) title 'native-x86-64-Os-mips', \
	'' u ($52/$45) title 'rv-jit-riscv64-Os-mips'

set yrange [0:15e9]

set output "svg/mips-O3-32.svg"
set title "rv8-bench (MIPS -O3 32-bit)"
plot 'data/benchmarks_noheader.dat' using \
	($5/$6):xtic(1) title 'native-x86-32-O3-mips', \
	'' u ($46/$42) title 'rv-jit-riscv32-O3-mips'

set output "svg/mips-Os-32.svg"
set title "rv8-bench (MIPS -Os 32-bit)"
plot 'data/benchmarks_noheader.dat' using \
	($12/$13):xtic(1) title 'native-x86-32-Os-mips', \
	'' u ($48/$43) title 'rv-jit-riscv32-Os-mips'
