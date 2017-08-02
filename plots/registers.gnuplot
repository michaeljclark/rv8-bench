set term svg
set auto x
set style data histogram
set style histogram rowstacked
set style fill solid border -1
set boxwidth 0.9
set xtic scale 0

set ylabel "Frequency (count)" offset 2,0,0

set grid xtics ytics

filenames = "aes dhrystone miniz norx primes qsort sha512"

do for [file in filenames] {
  infile1 = sprintf('stats/rv-hist-riscv64-%s-O3.dir/hist-reg.csv',file)
  infile2 = sprintf('stats/rv-hist-riscv64-%s-Os.dir/hist-reg.csv',file)
  outfile = sprintf('svg/registers-%s-rv64-1.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s registers riscv64 -O3 vs -Os)',file)
  plot infile1 using 2:xtic(1) title 'O3', infile2 using 2:xtic(1) title 'Os'
}

do for [file in filenames] {
  infile = sprintf('stats/rv-hist-riscv64-%s.csv',file)
  outfile = sprintf('svg/registers-%s-rv64-2.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s registers riscv64 -O3 vs -Os)',file)
  plot infile using 2:xtic(1) ti col, '' using 3 ti col
}