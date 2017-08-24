<a href="https://rv8.io/"><img style="float: right;" src="/images/rv8.svg"></a>

## rv8 benchmarks

This document contains [rv8-bench](https://github.com/rv8-io/rv8-bench/)
benchmark results for GCC 7.1.0 and musl libc on an Intel Core i7 Broadwell CPU.

The following sources are used:

- rv8 - [https://github.com/rv8-io/rv8/](https://github.com/rv8-io/rv8/)
- rv8-bench - [https://github.com/rv8-io/rv8-bench/](https://github.com/rv8-io/rv8-bench/)
- qemu-riscv - [https://github.com/riscv/riscv-qemu/](https://github.com/riscv/riscv-qemu/)
- musl-riscv-toolchain - [https://github.com/rv8-io/musl-riscv-toolchain/](https://github.com/rv8-io/musl-riscv-toolchain/)

The following results have been plotted:

- [Runtimes](#runtimes)
- [Instructions Per Second](#instructions-per-second)
- [Macro-op Fusion](#macro-op-fusion)
- [Retired Micro-ops](#retired-micro-ops)
- [Executable File Sizes](#executable-file-sizes)
- [Dynamic Register Usage](#dynamic-register-usage)

**Benchmark details**

Benchmark | Type        | Description
:--       | :--         | :--
aes       | crypto      | encrypt, decrypt and compare 30MiB of data
bigint    | numeric     | compute 23 ^ 111121 and count base 10 digits
dhrystone | synthetic   | synthetic integer workload
miniz     | compression | compress, decompress and compare 8MiB of data
norx      | crypto      | encrypt, decrypt and compare 30MiB of data
primes    | numeric     | calculate largest prime number below 33333333
qsort     | sorting     | sort array containing 50 million items
sha512    | digest      | calculate SHA-512 hash of 64MiB of data

**Compiler details**

Architecture | Compiler  | C Library | Compile options
:--          | :--       | :--       | :--
x86-32       | GCC 7.1.0 | musl libc | `'-O3 -fPIE'`, `'-Os -fPIE'`
x86-64       | GCC 7.1.0 | musl libc | `'-O3 -fPIE'`, `'-Os -fPIE'`
riscv32      | GCC 7.1.0 | musl libc | `'-O3 -fPIE'`, `'-Os -fPIE'`
riscv64      | GCC 7.1.0 | musl libc | `'-O3 -fPIE'`, `'-Os -fPIE'`
aarch64      | GCC 7.1.0 | musl libc | `'-O3 -fPIE'`, `'-Os -fPIE'`

**Measurement details**

- rv8 benchmarks use `rv-jit`
- Dynamic instruction counts are measured using `rv-sim -E`
- QEMU benchmarks use `qemu-riscv32`, `qemu-riscv64` and `qemu-aarch64`
- Benchmarks are run 20 times and the best result is taken
- Intel® 6th-gen Core™ i7-5557U Broadwell (3.10GHz, 3.40GHz Turbo, 4MB cache)
- x86-64 μops measured with
  - `perf stat -e cycles,instructions,r1b1,r10e,r2c2,r1c2 <cmd>`


### Runtimes

Runtime results comparing qemu, rv8 and native x86:

![benchmark runtimes -O3 64-bit]({{ site.url }}/plots/runtime-O3-64.svg)
_Figure 1: Benchmark runtimes -O3 64-bit_

TABLE runtime-O3-64

TABLE ratio-O3-64

![benchmark runtimes -Os 64-bit]({{ site.url }}/plots/runtime-Os-64.svg)
_Figure 2: Benchmark runtimes -Os 64-bit_

TABLE runtime-Os-64

TABLE ratio-Os-64

![benchmark runtimes -O3 32-bit]({{ site.url }}/plots/runtime-O3-32.svg)
_Figure 3: Benchmark runtimes -O3 32-bit_

TABLE runtime-O3-32

TABLE ratio-O3-32

![benchmark runtimes -Os 32-bit]({{ site.url }}/plots/runtime-Os-32.svg)
_Figure 4: Benchmark runtimes -Os 32-bit_

TABLE runtime-Os-32

TABLE ratio-Os-32


### Instructions Per Second

Instructions per second in millions comparing rv8 and native x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/mips-O3-64.svg)
_Figure 5: Millions of Instructions Per Second -O3 64-bit_

TABLE mips-O3-64

![operation counts -Os 64-bit]({{ site.url }}/plots/mips-Os-64.svg)
_Figure 6: Millions of Instructions Per Second -Os 64-bit_

TABLE mips-Os-64

![operation counts -O3 32-bit]({{ site.url }}/plots/mips-O3-32.svg)
_Figure 7: Millions of Instructions Per Second -O3 32-bit_

TABLE mips-O3-32

![operation counts -Os 32-bit]({{ site.url }}/plots/mips-Os-32.svg)
_Figure 8: Millions of Instructions Per Second -Os 32-bit_

TABLE mips-Os-32


### Macro-op Fusion

Runtimes and ratios for rv8 macro-op fusion (fusion=on,off):

![fusion runtimes and ratios 64-bit]({{ site.url }}/plots/fusion-64.svg)
_Figure 9: Fusion disabled and enabled runtimes -Os 64-bit_

TABLE fusion-O3-64

TABLE fusion-Os-64

![fusion runtimes and ratios 32-bit]({{ site.url }}/plots/fusion-32.svg)
_Figure 10: Fusion disabled and enabled runtimes -Os 32-bit_

TABLE fusion-O3-32

TABLE fusion-Os-32


### Retired Micro-ops

The following table describes the measured x86 performance counters:

counter       | x86 event mask              | description
:------------ | :-------------------------- | :-----------------------------------
instret       | `INST_RETIRED`              | instructions retired
uops-executed | `UOPS_EXECUTED.THREAD`      | uops executed
uops-issued   | `UOPS_ISSUED.ANY`           | uops issued
uops-slots    | `UOPS_RETIRED.RETIRE_SLOTS` | uop retirement slots used
uops-retired  | `UOPS_RETIRED.ANY`          | uops retired

Total retired micro-op/instruction counts comparing RISC-V and x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/operations-O3-64.svg)
_Figure 11: Retired operation counts -O3 64-bit_

TABLE operations-O3-64

![operation counts -Os 64-bit]({{ site.url }}/plots/operations-Os-64.svg)
_Figure 12: Retired operation counts -Os 64-bit_

TABLE operations-Os-64

![operation counts -O3 32-bit]({{ site.url }}/plots/operations-O3-32.svg)
_Figure 13: Retired operation counts -O3 32-bit_

TABLE operations-O3-32

![operation counts -Os 32-bit]({{ site.url }}/plots/operations-Os-32.svg)
_Figure 14: Retired operation counts -Os 32-bit_

TABLE operations-Os-32


### Executable File Sizes

GCC stripped executable sizes comparing aarch64, riscv32, riscv64, x86-32 and x86-64:

![benchmark filesizes -O3]({{ site.url }}/plots/filesize-O3.svg)
_Figure 15: Compiled file sizes -O3_

TABLE filesize-O3

![benchmark filesizes -Os]({{ site.url }}/plots/filesize-Os.svg)
_Figure 16: Compiled file sizes -Os_

TABLE filesize-Os


### Dynamic Register Usage

Dynamic register usage results comparing riscv64 -O3 vs -Os

![aes register usage -O3 vs -Os]({{ site.url }}/plots/registers-aes-rv64-1.svg)
_Figure 17: Dynamic register usage - aes -O3 vs -Os (sorted by frequency)_

![aes register usage -O3 vs -Os]({{ site.url }}/plots/registers-aes-rv64-2.svg)
_Figure 18: Dynamic register usage - aes -O3 vs -Os (sorted by alphabetically)_

![bigint register usage -O3 vs -Os]({{ site.url }}/plots/registers-bigint-rv64-1.svg)
_Figure 19: Dynamic register usage - bigint -O3 vs -Os (sorted by frequency)_

![bigint register usage -O3 vs -Os]({{ site.url }}/plots/registers-bigint-rv64-2.svg)
_Figure 20: Dynamic register usage - bigint -O3 vs -Os (sorted by alphabetically)_

![dhrystone register usage -O3 vs -Os]({{ site.url }}/plots/registers-dhrystone-rv64-1.svg)
_Figure 21: Dynamic register usage - dhrystone -O3 vs -Os (sorted by frequency)_

![dhrystone register usage -O3 vs -Os]({{ site.url }}/plots/registers-dhrystone-rv64-2.svg)
_Figure 22: Dynamic register usage - dhrystone -O3 vs -Os (sorted by alphabetically)_

![miniz register usage -O3 vs -Os]({{ site.url }}/plots/registers-miniz-rv64-1.svg)
_Figure 23: Dynamic register usage - miniz -O3 vs -Os (sorted by frequency)_

![miniz register usage -O3 vs -Os]({{ site.url }}/plots/registers-miniz-rv64-2.svg)
_Figure 24: Dynamic register usage - miniz -O3 vs -Os (sorted by alphabetically)_

![norx register usage -O3 vs -Os]({{ site.url }}/plots/registers-norx-rv64-1.svg)
_Figure 25: Dynamic register usage - norx -O3 vs -Os (sorted by frequency)_

![norx register usage -O3 vs -Os]({{ site.url }}/plots/registers-norx-rv64-2.svg)
_Figure 26: Dynamic register usage - norx -O3 vs -Os (sorted by alphabetically)_

![primes register usage -O3 vs -Os]({{ site.url }}/plots/registers-primes-rv64-1.svg)
_Figure 27: Dynamic register usage - primes -O3 vs -Os (sorted by frequency)_

![primes register usage -O3 vs -Os]({{ site.url }}/plots/registers-primes-rv64-2.svg)
_Figure 28: Dynamic register usage - primes -O3 vs -Os (sorted by alphabetically)_

![qsort register usage -O3 vs -Os]({{ site.url }}/plots/registers-qsort-rv64-1.svg)
_Figure 29: Dynamic register usage - qsort -O3 vs -Os (sorted by frequency)_

![qsort register usage -O3 vs -Os]({{ site.url }}/plots/registers-qsort-rv64-2.svg)
_Figure 30: Dynamic register usage - qsort -O3 vs -Os (sorted by alphabetically)_

![sha512 register usage -O3 vs -Os]({{ site.url }}/plots/registers-sha512-rv64-1.svg)
_Figure 31: Dynamic register usage - sha512 -O3 vs -Os (sorted by frequency)_

![sha512 register usage -O3 vs -Os]({{ site.url }}/plots/registers-sha512-rv64-2.svg)
_Figure 32: Dynamic register usage - sha512 -O3 vs -Os (sorted by alphabetically)_
