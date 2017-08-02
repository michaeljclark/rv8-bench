/*
 * rv8-bench
 */

var fs = require("fs");
var child_process = require('child_process');

var benchmarks = [ 'aes', 'dhrystone', 'miniz', 'norx', 'primes', 'qsort', 'sha512' ];

var targets    = [ 'rv-hist-riscv32',
                   'rv-hist-riscv64',
                   'rv-sim-riscv32',
                   'rv-sim-riscv64',
                   'rv-jit-riscv32',
                   'rv-jit-riscv64',
                   'qemu-riscv32',
                   'qemu-riscv64',
                   'qemu-aarch64',
                   'native-i386',
                   'native-x86_64',
                   'size-riscv32',
                   'size-riscv64',
                   'size-aarch64',
                   'size-i386',
                   'size-x86_64' ];

var opts       = [ 'O3', 'Os' ];

var fmt_time   = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['runtime', 8] ]

var fmt_inst   = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['runtime', 8], ['instret', 8] ]

var fmt_size    = [ ['benchmark', 15], ['system', 15], ['opt', 3], ['filesize', 8] ]

var stats_dir   = "./stats"
var data_dir    = "./data"

var max_sim_runs = 5;

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
  var data = {};
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
    console.log('');
    benchmark_print_heading(fmt);
  }
  console.log(benchmark_format_row(fmt, data));
  row_count++;
  last_fmt = fmt;
}

function benchmark_add_row(benchmark, system, opt, data)
{
  data['benchmark'] = benchmark;
  data['system'] = system;
  data['opt'] = opt;
  if (!fs.existsSync(stats_dir)){
    fs.mkdirSync(stats_dir);
  }
  var path = stats_dir + '/' + system + '.json';
  var contents, arr;
  try {
    contents = fs.readFileSync(path);
  } catch (error) {}
  if (contents) {
    arr = JSON.parse(contents);
    arr.push(data);
  } else {
    arr = [ data ];
  }
  fs.writeFileSync(path, JSON.stringify(arr));
}

function benchmark_size(benchmark, target, opt, runs)
{
  var system = 'size-' + target;
  var binary = 'bin/' + target + '/' + benchmark + "." + opt + ".stripped";
  var stats = fs.statSync(binary);
  var data = {
    runtime: 0,
    filesize: stats.size
  };
  benchmark_add_row(benchmark, system, opt, data);
  benchmark_print_row(fmt_size, data);
}

function benchmark_hist(benchmark, target, opt, runs)
{
  var system = 'rv-hist-' + target;
  var hist_dir = stats_dir + '/' + system + '.dir';
  if (!fs.existsSync(stats_dir)){
    fs.mkdirSync(stats_dir);
  }
  if (!fs.existsSync(hist_dir)){
    fs.mkdirSync(hist_dir);
  }
  var data = benchmark_cmd(benchmark, 'rv-sim',
    ['-I', '-R', '-D', hist_dir, '-E', 'bin/' + target + '/' + benchmark + "." + opt]);
  benchmark_add_row(benchmark, system, opt, data);
  benchmark_print_row(fmt_inst, data);
}

function benchmark_sim(benchmark, target, opt, runs)
{
  var system = 'rv-sim-' + target;
  for (var i = 0; i < Math.min(runs, max_sim_runs); i++) {
    var data = benchmark_cmd(benchmark, 'rv-sim',
      ['-E', 'bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(benchmark, system, opt, data);
    benchmark_print_row(fmt_inst, data);
  }
}

function benchmark_jit(benchmark, target, opt, runs)
{
  var system = 'rv-jit-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'rv-jit',
      ['bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(benchmark, system, opt, data);
    benchmark_print_row(fmt_time, data);
  }
}

function benchmark_qemu(benchmark, target, opt, runs)
{
  var system = 'qemu-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'qemu-' + target,
      ['bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(benchmark, system, opt, data);
    benchmark_print_row(fmt_time, data);
  }
}

function benchmark_native(benchmark, target, opt, runs)
{
  var system = 'native-' + target;
  for (var i = 0; i < runs; i++) {
    var data = benchmark_cmd(benchmark, 'perf',
       ['stat', '-e', 'cycles,instructions,r1b1,r10e,r2c2,r1c2',
        'bin/' + target + '/' + benchmark + "." + opt]);
    benchmark_add_row(benchmark, system, opt, data);
    benchmark_print_row(fmt_inst, data);
  }
}

function benchmark_run(benchmark, target, opt, runs)
{
  switch (target) {
    case 'rv-hist-riscv32': benchmark_hist(benchmark, 'riscv32', opt, runs); break;
    case 'rv-hist-riscv64': benchmark_hist(benchmark, 'riscv64', opt, runs); break;
    case 'rv-sim-riscv32': benchmark_sim(benchmark, 'riscv32', opt, runs); break;
    case 'rv-sim-riscv64': benchmark_sim(benchmark, 'riscv64', opt, runs); break;
    case 'rv-jit-riscv32': benchmark_jit(benchmark, 'riscv32', opt, runs); break;
    case 'rv-jit-riscv64': benchmark_jit(benchmark, 'riscv64', opt, runs); break;
    case 'qemu-riscv32': benchmark_qemu(benchmark, 'riscv32', opt, runs); break;
    case 'qemu-riscv64': benchmark_qemu(benchmark, 'riscv64', opt, runs); break;
    case 'qemu-aarch64': benchmark_qemu(benchmark, 'aarch64', opt, runs); break;
    case 'native-i386': benchmark_native(benchmark, 'i386', opt, runs); break;
    case 'native-x86_64': benchmark_native(benchmark, 'x86_64', opt, runs); break;
    case 'size-riscv32': benchmark_size(benchmark, 'riscv32', opt, runs); break;
    case 'size-riscv64': benchmark_size(benchmark, 'riscv64', opt, runs); break;
    case 'size-aarch64': benchmark_size(benchmark, 'aarch64', opt, runs); break;
    case 'size-i386': benchmark_size(benchmark, 'i386', opt, runs); break;
    case 'size-x86_64': benchmark_size(benchmark, 'x86_64', opt, runs); break;
  }
}

function benchmark_peel_opt(benchmark, target, opt, runs)
{
  if (opt == 'all') {
    opts.forEach(function(opt) {
      benchmark_run(benchmark, target, opt, runs);
    });
  } else {
    benchmark_run(benchmark, target, opt, runs);
  }
}
function benchmark_peel_target(benchmark, target, opt, runs)
{
  if (target == 'all') {
    targets.forEach(function(target) {
      benchmark_peel_opt(benchmark, target, opt, runs);
    });
  } else {
    benchmark_peel_opt(benchmark, target, opt, runs);
  }
}

function benchmark_peel_benchmark(benchmark, target, opt, runs)
{
  if (benchmark == 'all') {
    benchmarks.forEach(function(benchmark) {
      benchmark_peel_target(benchmark, target, opt, runs);
    });
  } else {
    benchmark_peel_target(benchmark, target, opt, runs);
  }
}

function benchmark_gather_all()
{
  var keys = {};
  var gather = {};
  benchmarks.forEach(function(benchmark) {
    gather[benchmark] = {};
  });
  targets.forEach(function(target) {
    var path = stats_dir + '/' + target + '.json';
    var contents = fs.readFileSync(path);
    var arr = JSON.parse(contents);
    opts.forEach(function(opt) {
      benchmarks.forEach(function(benchmark) {
        var best_runtime = -1, best_index = -1;
        for (var i = 0; i < arr.length; i++) {
          var data = arr[i];
          if (data['opt'] != opt) continue;
          if (data['benchmark'] != benchmark) continue;
          if (best_runtime == -1 || data['runtime'] > best_runtime) {
            best_index = i;
            best_runtime = data['runtime'];
          }
        }
        if (best_index == -1) return;
        var data = arr[best_index];
        for (var key in data) {
          if (!data.hasOwnProperty(key)) continue;
          if (key == 'benchmark') continue;
          if (key == 'opt') continue;
          if (key == 'system') continue;
          if (key == 'dmips') continue;
          if (key == 'runtime' && target.startsWith('size')) continue;
          if (target.startsWith('rv-hist')) continue;
          var new_key = target + '-' + opt + '-' + key;
          new_key = new_key.replace(/_/g, '-');
          new_key = new_key.replace(/^size-/, '');
          new_key = new_key.replace(/x86-uops/, 'uops');
          new_key = new_key.replace(/i386/, 'x86-32');
          gather[benchmark][new_key] = data[key];
          keys[new_key] = true;
        }
      });
    });
  });

  // sort keys
  var keylist = [];
  for (var key in keys) {
    if (keys.hasOwnProperty(key)) {
      keylist.push(key);
    }
  }
  keylist.sort();

  // write format line
  var arr = [];
  var format = 'benchmark';
  for (var i = 0; i < keylist.length; i++) {
    format += '\t' + keylist[i];
    console.log(keylist[i]);
  }
  arr.push(format);

  // write data, one row per benchmark
  benchmarks.forEach(function(benchmark) {
    var data = gather[benchmark];
    var row = benchmark;
    for (var i = 0; i < keylist.length; i++) {
      row += '\t' + gather[benchmark][keylist[i]];
    }
    arr.push(row);
  });
  arr.push('');

  // write to file
  if (!fs.existsSync(data_dir)) {
    fs.mkdirSync(data_dir);
  }
  fs.writeFileSync(data_dir + '/benchmarks.dat', arr.join("\n"));
}

function benchmark_print_all()
{
  targets.forEach(function(target) {
    var path = stats_dir + '/' + target + '.json';
    var contents = fs.readFileSync(path);
    var arr = JSON.parse(contents);
    opts.forEach(function(opt) {
      benchmarks.forEach(function(benchmark) {
        var best_runtime = -1, best_index = -1;
        for (var i = 0; i < arr.length; i++) {
          var data = arr[i];
          if (data['opt'] != opt) continue;
          if (data['benchmark'] != benchmark) continue;
          if (best_runtime == -1 || data['runtime'] > best_runtime) {
            best_index = i;
            best_runtime = data['runtime'];
          }
        }
        if (best_index == -1) return;
        var data = arr[best_index];
        if ('filesize' in data) {
          benchmark_print_row(fmt_size, data);
        } else if ('instret' in data) {
          benchmark_print_row(fmt_inst, data);
        } else {
          benchmark_print_row(fmt_time, data);
        }
      });
    });
  });
}

var help_or_error = false;

var task = process.argv[2];
if (task == "gather" && process.argv.length == 3) {
  //
} else if (task == "print" && process.argv.length == 3) {
  //
} else if (task == "bench" && process.argv.length == 7) {
  //
} else {
  help_or_error = true;
}

if (help_or_error) {
   console.log('usage: npm start gather');
   console.log('');
   console.log('usage: npm start print');
   console.log('');
   console.log('usage: npm start bench <benchmark> <target> <opt> <runs>');
   console.log('');
   console.log('<benchmark>  [ all | ' + benchmarks.join(' | ') + ' ]');
   console.log('');
   console.log('<target>     [ all | ' + targets.join(' | ') + ' ]');
   console.log('');
   console.log('<opt>        [ all | ' + opts.join(' | ') + ' ]');
   console.log('');
   process.exit();
}

if (task == "gather")
{
  benchmark_gather_all();
}

if (task == "print")
{
  benchmark_print_all();
}

if (task == "bench")
{
  var benchmark = process.argv[3];
  var target = process.argv[4];
  var opt = process.argv[5];
  var runs = parseInt(process.argv[6]);

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

  benchmark_peel_benchmark(benchmark, target, opt, runs);
}