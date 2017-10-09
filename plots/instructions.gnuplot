set term svg size 640,480
set auto x
set xtic scale 0
set xtics nomirror rotate by -60
set style line 101 lc rgb '#606060' lt 1 lw 1
set border ls 101
set ylabel "Frequency (count)" offset 2,0,0
set grid xtics ytics

set style line 1 lt 1 lw 2.5 pt 7 ps 0.5 lc '#9400D3'
set style line 2 lt 1 lw 2.0 pt 7 ps 0.5 lc '#228B22'
set style line 3 lt 1 lw 1.5 pt 7 ps 0.5 lc '#00BFFF'

filenames = "aes bigint dhrystone miniz norx primes qsort sha512"

do for [file in filenames] {
  infile1 = sprintf('stats/rv-hist-riscv64-%s-O3.dir/hist-inst.csv',file)
  infile2 = sprintf('stats/rv-hist-riscv64-%s-O2.dir/hist-inst.csv',file)
  infile3 = sprintf('stats/rv-hist-riscv64-%s-Os.dir/hist-inst.csv',file)
  outfile = sprintf('svg/instructions-%s-rv64-1.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s instructions riscv64 -O3, -O2, -Os)',file)
  plot infile1 using 2:xtic(1) title 'O3' with linespoints ls 1, \
       infile2 using 2:xtic(1) title 'O2' with linespoints ls 2, \
       infile3 using 2:xtic(1) title 'Os' with linespoints ls 3
}

set style data histogram
set style fill solid border -1
set boxwidth 0.9
set style histogram rowstacked

do for [file in filenames] {
  infile = sprintf('stats/rv-hist-inst-riscv64-%s.csv',file)
  outfile = sprintf('svg/instructions-%s-rv64-2.svg',file)
  set output outfile
  set title sprintf('rv8-bench (%s instructions riscv64 -O3, -O2, -Os)',file)
  plot infile using 2:xtic(1) ti col, '' using 3 ti col, '' using 4 ti col
}
