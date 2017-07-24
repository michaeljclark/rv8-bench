var child_process = require('child_process');

var benchmarks = [ 'aes', 'dhrystone', 'miniz', 'norx', 'primes', 'qsort', 'sha512' ];

function pad(n, width, z) {
  z = z || ' ';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function bench_cmd(bench, type, cmd, args)
{
  var start = process.hrtime();
  var obj = child_process.spawnSync(cmd, args)
  var elapsed = process.hrtime(start);
  var elapsed_secs = elapsed[0] + elapsed[1] / 1000000000.0
  if (obj.status == 0) {
    var append = "";
    var dmips = obj.stdout.toString().match(/\s([0-9]+)\sDMIPS/);
    //dhrystone mips
    if (dmips) {
      append += ' | dmips=' + dmips[1];
    }
    // riscv instructions retired
    var rv_inst = obj.stdout.toString().match(/instret\s+:\s+([0-9]+)/m);
    if (rv_inst) {
      append += ' | rv_inst=' + rv_inst[1];
    }
    // x86 instructions retired
    var x86_inst = obj.stderr.toString().match(/([0-9,]+)\s+instructions/m);
    if (x86_inst) {
      append += ' | x86_inst=' + x86_inst[1].split(',').join('');
    }
    // unfused domain, uops sent to execution port
    var x86_uops_executed = obj.stderr.toString().match(/([0-9,]+)\s+r1b1/m);
    if (x86_uops_executed) {
      append += ' | x86_uops_executed=' + x86_uops_executed[1].split(',').join('');
    }
    // fused domain, uops issued
    var x86_uops_issued = obj.stderr.toString().match(/([0-9,]+)\s+r10e/m);
    if (x86_uops_issued) {
      append += ' | x86_uops_issued=' + x86_uops_issued[1].split(',').join('');
    }
    // fused domain, uop retirement slots used
    var x86_uops_retired_slots = obj.stderr.toString().match(/([0-9,]+)\s+r2c2/m);
    if (x86_uops_retired_slots) {
      append += ' | x86_uops_retired_slots=' + x86_uops_retired_slots[1].split(',').join('');
    }
    // unfused domain, uops retired all
    var x86_uops_retired_all = obj.stderr.toString().match(/([0-9,]+)\s+r1c2/m);
    if (x86_uops_retired_all) {
      append += ' | x86_uops_retired_all=' + x86_uops_retired_all[1].split(',').join('');
    }
    console.log(pad(bench, 15) + ' | ' + type + ' | time=' + elapsed_secs + append);
  } else {
    console.log(pad(bench, 15) + ' | ' + type + ' | error');
  }
}

function bench_sim(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, 'rv-sim-' + target, 'rv-sim',
      ['-E', 'bin/' + target + '/' + bench]);
  });
}

function bench_jit(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, 'rv-jit-' + target, 'rv-jit',
      ['bin/' + target + '/' + bench]);
  });
}

function bench_qemu(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
    bench_cmd(bench, 'qemu-' + target, 'qemu-' + target,
      ['bin/' + target + '/' + bench]);
  });
}

function bench_native(benchmarks, target)
{
  benchmarks.forEach(function(bench) {
     bench_cmd(bench, 'native-' + target, 'perf',
       ['stat', '-e', 'instructions,r1b1,r10e,r2c2,r1c2', 'bin/' + target + '/' + bench]);
  });
}

if (process.argv.length != 3) {
   console.log('usage: npm start (rv32-sim|rv64-sim|rv32-jit|rv64-jit|rv32-qemu|rv64-qemu|i386|x86_64)');
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
  default: console.log('unknown target ' + target); break;
}
