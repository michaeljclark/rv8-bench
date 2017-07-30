/*
 * rv8-bench
 */

var fs = require("fs");
var child_process = require('child_process');

var benchmarks = [ 'aes', 'dhrystone', 'miniz', 'norx', 'primes', 'qsort', 'sha512' ];

var targets    = [ 'rv-sim-riscv32', 'rv-sim-riscv64', 'rv-jit-riscv32', 'rv-jit-riscv64',
                   'qemu-riscv32', 'qemu-riscv64', 'qemu-aarch64', 'native-i386', 'native-x86_64',
                   'size-riscv32', 'size=riscv64', 'size-aarch64', 'size-i386', 'size-x86_64' ];

var opts       = [ 'O3', 'Os' ];

var fmt_time   = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['runtime', 8] ]

var fmt_inst   = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['runtime', 8], ['instret', 8] ]

var fmt_size    = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['filesize', 8] ]

var row_count = 0;
var last_fmt = null;

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

function benchmark_cmd(bench, cmd, args)
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
      data['instret'] = rv_inst[1];
    }
    // x86 cycles
    var x86_cycles = obj.stderr.toString().match(/([0-9,]+)\s+cycles/m);
    if (x86_cycles) {
      data['cycles'] = x86_cycles[1].split(',').join('');
    }
    // x86 instructions retired
    var x86_inst = obj.stderr.toString().match(/([0-9,]+)\s+instructions/m);
    if (x86_inst) {
      data['instret'] = x86_inst[1].split(',').join('');
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
    data['runtime'] = Math.round(elapsed_secs* 1000) / 1000;
  } else {
    data['error'] = true;
  }
  return data;
}

function benchmark_format_headings(fmt)
{
  var output = "";
  for (var i = 0; i < fmt.length; i++) {
    if (i != 0) output += ' | ' ;
    output += padr(fmt[i][0], fmt[i][1]);
  }
  return output;
}

function benchmark_format_rule(fmt)
{
  var output = "";
  for (var i = 0; i < fmt.length; i++) {
    if (i != 0) output += ' | ' ;
    output += padr(repeat(fmt[i][1], '-'), fmt[i][1]);
  }
  return output;
}

function benchmark_format_row(fmt, data)
{
  var output = "";
  for (var i = 0; i < fmt.length; i++) {
    if (i != 0) output += ' | ' ;
    output += padr(data[fmt[i][0]], fmt[i][1]);
  }
  return output;
}

function benchmark_print_heading(fmt)
{
  console.log(benchmark_format_headings(fmt));
  console.log(benchmark_format_rule(fmt));
}

function benchmark_print_row(fmt, data)
{
  if (fmt != last_fmt || row_count % 20 == 0) {
    benchmark_print_heading(fmt);
  }
  console.log(benchmark_format_row(fmt, data));
  row_count++;
  last_fmt = fmt;
}

function benchmark_add_row(db, benchmark, system, opt, data)
{
  data['benchmark'] = benchmark;
  data['system'] = system;
  data['opt'] = opt;
}

function benchmark_size(db, benchmark, target, opt, runs)
{
  var system = 'size-' + target;
  var binary = 'bin/' + target + '/' + benchmark + "." + opt + ".stripped";
  var stats = fs.statSync(binary);
  var data = {
    runtime: 0,
    filesize: stats.size
  };
  benchmark_add_row(db, benchmark, system, opt, data);
  benchmark_print_row(fmt_size, data);
}

function benchmark_sim(db, benchmark, target, opt, runs)
{
  var system = 'rv-sim-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'rv-sim',
      ['-E', 'bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(db, benchmark, system, opt, data);
    benchmark_print_row(fmt_inst, data);
  }
  // TODO - gather register and instruction frequencies
}

function benchmark_jit(db, benchmark, target, opt, runs)
{
  var system = 'rv-jit-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'rv-jit',
      ['bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(db, benchmark, system, opt, data);
    benchmark_print_row(fmt_time, data);
  }
}

function benchmark_qemu(db, benchmark, target, opt, runs)
{
  var system = 'qemu-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'qemu-' + target,
      ['bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(db, benchmark, system, opt, data);
    benchmark_print_row(fmt_time, data);
  }
}

function benchmark_native(db, benchmark, target, opt, runs)
{
  var system = 'native-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'perf',
       ['stat', '-e', 'cycles,instructions,r1b1,r10e,r2c2,r1c2',
        'bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(db, benchmark, system, opt, data);
    benchmark_print_row(fmt_inst, data);
  }
}

function benchmark_run(db, benchmark, target, opt, runs)
{
  switch (target) {
    case 'rv-sim-riscv32': benchmark_sim(db, benchmark, 'riscv32', opt, runs); break;
    case 'rv-sim-riscv64': benchmark_sim(db, benchmark, 'riscv64', opt, runs); break;
    case 'rv-jit-riscv32': benchmark_jit(db, benchmark, 'riscv32', opt, runs); break;
    case 'rv-jit-riscv64': benchmark_jit(db, benchmark, 'riscv64', opt, runs); break;
    case 'qemu-riscv32': benchmark_qemu(db, benchmark, 'riscv32', opt, runs); break;
    case 'qemu-riscv64': benchmark_qemu(db, benchmark, 'riscv64', opt, runs); break;
    case 'qemu-aarch64': benchmark_qemu(db, benchmark, 'aarch64', opt, runs); break;
    case 'native-i386': benchmark_native(db, benchmark, 'i386', opt, runs); break;
    case 'native-x86_64': benchmark_native(db, benchmark, 'x86_64', opt, runs); break;
    case 'size-riscv32': benchmark_size(db, benchmark, 'riscv32', opt, runs); break;
    case 'size-riscv64': benchmark_size(db, benchmark, 'riscv64', opt, runs); break;
    case 'size-aarch64': benchmark_size(db, benchmark, 'aarch64', opt, runs); break;
    case 'size-i386': benchmark_size(db, benchmark, 'i386', opt, runs); break;
    case 'size-x86_64': benchmark_size(db, benchmark, 'x86_64', opt, runs); break;
  }
}

function benchmark_peel_opt(db, benchmark, target, opt, runs)
{
  if (opt == 'all') {
    opts.forEach(function(opt) {
      benchmark_run(db, benchmark, target, opt, runs);
    });
  } else {
    benchmark_run(db, benchmark, target, opt, runs);
  }
}
function benchmark_peel_target(db, benchmark, target, opt, runs)
{
  if (target == 'all') {
    targets.forEach(function(target) {
      benchmark_peel_opt(db, benchmark, target, opt, runs);
    });
  } else {
    benchmark_peel_opt(db, benchmark, target, opt, runs);
  }
}

function benchmark_peel_benchmark(db, benchmark, target, opt, runs)
{
  if (benchmark == 'all') {
    benchmarks.forEach(function(benchmark) {
      benchmark_peel_target(db, benchmark, target, opt, runs);
    });
  } else {
    benchmark_peel_target(db, benchmark, target, opt, runs);
  }
}

var db = [];

if (process.argv.length != 6) {
   console.log('usage: npm start <benchmark> <target> <opt> <runs>');
   console.log('');
   console.log('<benchmark>  [ all | ' + benchmarks.join(' | ') + ' ]');
   console.log('');
   console.log('<target>     [ all | ' + targets.join(' | ') + ' ]');
   console.log('');
   console.log('<opt>        [ all | ' + opts.join(' | ') + ' ]');
   console.log('');
   process.exit();
}

var benchmark = process.argv[2];
var target = process.argv[3];
var opt = process.argv[4];
var runs = parseInt(process.argv[5]);

if (benchmarks.indexOf(benchmark) == -1 && benchmark != 'all') {
  console.log('unknown benchmark ' + benchmark);
  process.exit();
} else if (targets.indexOf(target) == -1 && target != 'all') {
  console.log('unknown target ' + target);
  process.exit();
} else if (opts.indexOf(opt) == -1 && opt != 'all') {
  console.log('unknown opt ' + opt);
  process.exit();
}

console.log('benchmark  : ' + benchmark);
console.log('target     : ' + target);
console.log('opt        : ' + opt);
console.log('runs       : ' + runs);
console.log('');

benchmark_peel_benchmark(db, benchmark, target, opt, runs);
