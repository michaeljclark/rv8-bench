set term svg
set auto x
set style data histogram
set style histogram rowstacked
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set xtics nomirror rotate by -60

set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101

set ylabel "Frequency (count)" offset 2,0,0

set grid xtics ytics

filenames = "aes bigint dhrystone miniz norx primes qsort sha512"

do for [file in filenames] {
  infile1 = sprintf('stats/rv-hist-riscv64-%s-O3.dir/hist-inst.csv',file)
  infile2 = sprintf('stats/rv-hist-riscv64-%s-Os.dir/hist-inst.csv',file)
  outfile = sprintf('svg/instructions-%s-rv64-1.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s instructions riscv64 -O3 vs -Os)',file)
  plot infile1 using 2:xtic(1) title 'O3', infile2 using 2:xtic(1) title 'Os'
}

do for [file in filenames] {
  infile = sprintf('stats/rv-hist-inst-riscv64-%s.csv',file)
  outfile = sprintf('svg/instructions-%s-rv64-2.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s instructions riscv64 -O3 vs -Os)',file)
  plot infile using 2:xtic(1) ti col, '' using 3 ti col
}