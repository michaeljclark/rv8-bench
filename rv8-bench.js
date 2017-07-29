var child_process = require('child_process');

var benchmarks = [ 'aes', 'dhrystone', 'miniz', 'norx', 'primes', 'qsort', 'sha512' ];
var targets    = [ 'rv-sim-riscv32', 'rv-sim-riscv64', 'rv-jit-riscv32', 'rv-jit-riscv64',
                   'qemu-riscv32', 'qemu-riscv64', 'qemu-aarch64', 'native-i386', 'native-x86_64' ];
var opts       = [ 'O3', 'Os' ];

function padl(n, width, z) {
  z = z || ' ';
  n = n + '';
  return (n.length >= width ? '' : new Array(width - n.length + 1).join(z)) + n;
}

function padr(n, width, z) {
  z = z || ' ';
  n = n + '';
  return n + (n.length >= width ? '' : new Array(width - n.length + 1).join(z));
}

function repeat(width, z) {
  z = z || ' ';
  return new Array(width).join(z);
}

function bench_cmd(bench, cmd, args)
{
  var start = process.hrtime();
  var obj = child_process.spawnSync(cmd, args)
  var elapsed = process.hrtime(start);
  var elapsed_secs = elapsed[0] + elapsed[1] / 1000000000.0
  var data = [];
  if (obj.status == 0) {
    var dmips = obj.stdout.toString().match(/\s([0-9]+)\sDMIPS/);
    //dhrystone mips
    if (dmips) {
      data['dmips'] = dmips[1];
    }
    // riscv instructions retired
    var rv_inst = obj.stdout.toString().match(/instret\s+:\s+([0-9]+)/m);
    if (rv_inst) {
      data['rv_inst'] = rv_inst[1];
    }
    // x86 cycles
    var x86_cycles = obj.stderr.toString().match(/([0-9,]+)\s+cycles/m);
    if (x86_cycles) {
      data['x86_cycles'] = x86_cycles[1].split(',').join('');
    }
    // x86 instructions retired
    var x86_inst = obj.stderr.toString().match(/([0-9,]+)\s+instructions/m);
    if (x86_inst) {
      data['x86_inst'] = x86_inst[1].split(',').join('');
    }
    // unfused domain, uops sent to execution port
    var x86_uops_executed = obj.stderr.toString().match(/([0-9,]+)\s+r1b1/m);
    if (x86_uops_executed) {
      data['x86_uops_executed'] = x86_uops_executed[1].split(',').join('');
    }
    // fused domain, uops issued
    var x86_uops_issued = obj.stderr.toString().match(/([0-9,]+)\s+r10e/m);
    if (x86_uops_issued) {
      data['x86_uops_issued'] = x86_uops_issued[1].split(',').join('');
    }
    // fused domain, uop retirement slots used
    var x86_uops_retired_slots = obj.stderr.toString().match(/([0-9,]+)\s+r2c2/m);
    if (x86_uops_retired_slots) {
      data['x86_uops_retired_slots'] = x86_uops_retired_slots[1].split(',').join('');
    }
    // unfused domain, uops retired all
    var x86_uops_retired_all = obj.stderr.toString().match(/([0-9,]+)\s+r1c2/m);
    if (x86_uops_retired_all) {
      data['x86_uops_retired_all'] = x86_uops_retired_all[1].split(',').join('');
    }
    data['runtime'] = elapsed_secs;
  } else {
    data['error'] = true;
  }
  return data;
}

function bench_header()
{
  console.log(padr('Benchmark', 15) + ' | ' + padr('System', 15) + ' | ' + padr('Opt', 3) + ' | Runtime');
}

function bench_add_row(db, bench, system, opt, data)
{
  console.log(padr(bench, 15) + ' | ' + padr(system, 15) + ' | ' + padr(opt, 3) + ' | ' + data['runtime']);
}

function bench_sim(db, benchmarks, target, opt, runs)
{
  var system = 'rv-sim-' + target;
  bench_header();
  benchmarks.forEach(function(bench) {
    for (var i = 0; i < runs; i++) {
      var data = bench_cmd(bench, 'rv-sim',
        ['-E', 'bin/' + target + '/' + bench + "." + opt]);
      bench_add_row(db, bench, system, opt, data);
    }
  });
}

function bench_jit(db, benchmarks, target, opt, runs)
{
  var system = 'rv-jit-' + target;
  bench_header();
  benchmarks.forEach(function(bench) {
    for (var i = 0; i < runs; i++) {
      var data = bench_cmd(bench, 'rv-jit',
        ['bin/' + target + '/' + bench + "." + opt]);
      bench_add_row(db, bench, system, opt, data);
    }
  });
}

function bench_qemu(db, benchmarks, target, opt, runs)
{
  var system = 'qemu-' + target;
  bench_header();
  benchmarks.forEach(function(bench) {
    for (var i = 0; i < runs; i++) {
      var data = bench_cmd(bench, 'qemu-' + target,
        ['bin/' + target + '/' + bench + "." + opt]);
      bench_add_row(db, bench, system, opt, data);
    }
  });
}

function bench_native(db, benchmarks, target, opt, runs)
{
  var system = 'native-' + target;
  bench_header();
  benchmarks.forEach(function(bench) {
    for (var i = 0; i < runs; i++) {
      var data = bench_cmd(bench, 'perf',
         ['stat', '-e', 'cycles,instructions,r1b1,r10e,r2c2,r1c2', 'bin/' + target + '/' + bench + "." + opt]);
      bench_add_row(db, bench, system, opt, data);
    }
  });
}

function bench(target, opt, runs)
{
  var db = [];
  switch (target) {
    case 'rv-sim-riscv32': bench_sim(db, benchmarks, 'riscv32', opt, runs); break;
    case 'rv-sim-riscv64': bench_sim(db, benchmarks, 'riscv64', opt, runs); break;
    case 'rv-jit-riscv32': bench_jit(db, benchmarks, 'riscv32', opt, runs); break;
    case 'rv-jit-riscv64': bench_jit(db, benchmarks, 'riscv64', opt, runs); break;
    case 'qemu-riscv32': bench_qemu(db, benchmarks, 'riscv32', opt, runs); break;
    case 'qemu-riscv64': bench_qemu(db, benchmarks, 'riscv64', opt, runs); break;
    case 'qemu-aarch64': bench_qemu(db, benchmarks, 'aarch64', opt, runs); break;
    case 'native-i386': bench_native(db, benchmarks, 'i386', opt, runs); break;
    case 'native-x86_64': bench_native(db, benchmarks, 'x86_64', opt, runs); break;
  }
}

if (process.argv.length != 5) {
   console.log('usage: npm start <arch> <opt> <runs>');
   console.log('');
   console.log('<arch> rv-sim-riscv32, rv-sim-riscv64, rv-jit-riscv32, rv-jit-riscv64');
   console.log('       qemu-riscv32, qemu-riscv64, qemu-aarch64, native-i386, native-x86_64');
   console.log('');
   console.log('<opt>  O3, Os');
   console.log('');
   process.exit();
}

var target = process.argv[2], opt = process.argv[3], runs = parseInt(process.argv[4]);

if (targets.indexOf(target) == -1) {
  console.log('unknown target ' + target);
  process.exit();
} else if (opts.indexOf(opt) == -1) {
  console.log('unknown opt ' + opt);
  process.exit();
}

bench(target, opt, runs);
