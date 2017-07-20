var benchmarks = [ 'aes', 'dhrystone', 'miniz', 'norx', 'primes', 'qsort', 'sha512' ];

function pad(n, width, z) {
  z = z || ' ';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function bench_cmd(bench, type, cmd)
{
  console.log(pad(bench, 15) + ' | ' + type + ' | ' + cmd);
}

function bench_sim(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, "rv-sim-" + target, "time rv-sim " + "bin/" + target + "/" + bench);
  });
}

function bench_jit(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, "rv-jit-" + target, "time rv-jit " + "bin/" + target + "/" + bench);
  });
}

function bench_qemu(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, "qemu-" + target, "time qemu-" + target + " bin/" + target + "/" + bench);
  });
}

function bench_native(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
     bench_cmd(bench, "native-" + target, "time perf stat -e instructions,r1c2 bin/" + target + "/" + bench);
  });
}

if (process.argv.length != 3) {
   console.log("usage: npm start (rv32-sim|rv64-sim|rv32-jit|rv64-jit|rv32-qemu|rv64-qemu|i386|x86_64)");
   process.exit();
}

var target = process.argv[2];

switch (target) {
  case 'rv32-sim': bench_sim(benchmarks, 'riscv32'); break;
  case 'rv64-sim': bench_sim(benchmarks, 'riscv64'); break;
  case 'rv32-jit': bench_jit(benchmarks, 'riscv32'); break;
  case 'rv64-jit': bench_jit(benchmarks, 'riscv64'); break;
  case 'rv32-qemu': bench_qemu(benchmarks, 'riscv32'); break;
  case 'rv64-qemu': bench_qemu(benchmarks, 'riscv64'); break;
  case 'i386': bench_native(benchmarks, 'i386'); break;
  case 'x86_64': bench_native(benchmarks, 'x86_64'); break;
  default: console.log("unknown target " + target); break;
}
