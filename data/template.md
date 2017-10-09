## Benchmark results

This document contains [rv8-bench](https://github.com/rv8-io/rv8-bench/)
results compiled using GCC 7.1.0 and musl libc. The results include runtime
and instructions per second comparisons for the QEMU and rv8 JIT engines
and native x86. The benchmark suite is compiled for aarch64, arm32, riscv64,
riscv32, x86-64 and x86-32.

The results include runtime neutral metrics such as retired RISC-V
instructions, x86 micro-ops, executable file sizes plus dynamic register and
instruction  histograms for RISC-V.

#### Benchmark source

The following sources have been used to run the benchmarks:

- rv8 - [https://github.com/rv8-io/rv8/](https://github.com/rv8-io/rv8/)
- rv8-bench - [https://github.com/rv8-io/rv8-bench/](https://github.com/rv8-io/rv8-bench/)
- qemu-riscv - [https://github.com/riscv/riscv-qemu/](https://github.com/riscv/riscv-qemu/)
- musl-riscv-toolchain - [https://github.com/rv8-io/musl-riscv-toolchain/](https://github.com/rv8-io/musl-riscv-toolchain/)

#### Benchmark metrics

The following benchmark metrics have been plotted and tabulated:

- [Runtimes](#runtimes)
- [Optimisation](#optimisation)
- [Instructions Per Second](#instructions-per-second)
- [Retired Micro-ops](#retired-micro-ops)
- [Executable File Sizes](#executable-file-sizes)
- [Dynamic Register Usage](#dynamic-register-usage)
- [Dynamic Instruction Usage](#dynamic-instruction-usage)

#### Benchmark details

The [rv8-bench](https://github.com/rv8-io/rv8-bench/)
benchmark suite contains the following test programs:

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

#### Compiler details

The following compiler architectures, versions, compile options
and runtime libraries are used to run the benchmarks:

Architecture | Compiler  | C Library | Compile options
:--          | :--       | :--       | :--
x86-32       | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
x86-64       | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
riscv32      | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
riscv64      | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
arm32        | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
aarch64      | GCC 7.2.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`

#### Measurement details

- Dynamic instruction counts are measured using `rv-sim -E`
- Benchmarks are run 20 times and the best result is taken
- All programs are compiled as position independent executables (`-fPIE`)
- Host: Intel® 6th-gen Core™ i7-5557U Broadwell (3.10-3.40GHz, 4MB cache)
- x86-64 μops measured with
  - `perf stat -e cycles,instructions,r1b1,r10e,r2c2,r1c2 <cmd>`


### Runtimes

Runtime results comparing qemu, rv8 and native x86:

![benchmark runtimes -O3 64-bit]({{ site.url }}/plots/runtime-O3-64.svg)

_Figure 1: Benchmark runtimes -O3 64-bit_

TABLE runtime-O3-64

TABLE ratio-O3-64

![benchmark runtimes -O2 64-bit]({{ site.url }}/plots/runtime-O2-64.svg)

_Figure 2: Benchmark runtimes -O2 64-bit_

TABLE runtime-O2-64

TABLE ratio-O2-64

![benchmark runtimes -Os 64-bit]({{ site.url }}/plots/runtime-Os-64.svg)

_Figure 3: Benchmark runtimes -Os 64-bit_

TABLE runtime-Os-64

TABLE ratio-Os-64

![benchmark runtimes -O3 32-bit]({{ site.url }}/plots/runtime-O3-32.svg)

_Figure 4: Benchmark runtimes -O3 32-bit_

TABLE runtime-O3-32

TABLE ratio-O3-32

![benchmark runtimes -O2 32-bit]({{ site.url }}/plots/runtime-O2-32.svg)

_Figure 5: Benchmark runtimes -O2 32-bit_

TABLE runtime-O2-32

TABLE ratio-O2-32

![benchmark runtimes -Os 32-bit]({{ site.url }}/plots/runtime-Os-32.svg)

_Figure 6: Benchmark runtimes -Os 32-bit_

TABLE runtime-Os-32

TABLE ratio-Os-32


### Optimisation

Runtimes and ratios for optimisation levels (-O3, -O2 and -Os):

![optimisation comparison native x86-64, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-x86-64.svg )

_Figure 7: Optimisation native x86-64, -O3, -O2 and -Os_

TABLE opt-x86-64

![optimisation comparison native x86-32, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-x86-32.svg )

_Figure 8: Optimisation native x86-32, -O3, -O2 and -Os_

TABLE opt-x86-32

![optimisation comparison rv8 riscv64, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-riscv64.svg )

_Figure 9: Optimisation rv8 riscv64, -O3, -O2 and -Os_

TABLE opt-riscv64

![optimisation comparison rv8 riscv32, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-riscv32.svg )

_Figure 10: Optimisation rv8 riscv32, -O3, -O2 and -Os_

TABLE opt-riscv32


### Instructions Per Second

Instructions per second in millions comparing qemu, rv8 and native x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/mips-O3-64.svg)

_Figure 11: Millions of Instructions Per Second -O3 64-bit_

TABLE mips-O3-64

![operation counts -O2 64-bit]({{ site.url }}/plots/mips-O2-64.svg)

_Figure 12: Millions of Instructions Per Second -O2 64-bit_

TABLE mips-O2-64

![operation counts -Os 64-bit]({{ site.url }}/plots/mips-Os-64.svg)

_Figure 13: Millions of Instructions Per Second -Os 64-bit_

TABLE mips-Os-64

![operation counts -O3 32-bit]({{ site.url }}/plots/mips-O3-32.svg)

_Figure 14: Millions of Instructions Per Second -O3 32-bit_

TABLE mips-O3-32

![operation counts -O2 32-bit]({{ site.url }}/plots/mips-O2-32.svg)

_Figure 15: Millions of Instructions Per Second -O2 32-bit_

TABLE mips-O2-32

![operation counts -Os 32-bit]({{ site.url }}/plots/mips-Os-32.svg)

_Figure 16: Millions of Instructions Per Second -Os 32-bit_

TABLE mips-Os-32


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

_Figure 17: Retired operation counts -O3 64-bit_

TABLE operations-O3-64

![operation counts -Os 64-bit]({{ site.url }}/plots/operations-O2-64.svg)

_Figure 18: Retired operation counts -O2 64-bit_

TABLE operations-O2-64

![operation counts -O2 64-bit]({{ site.url }}/plots/operations-Os-64.svg)

_Figure 19: Retired operation counts -Os 64-bit_

TABLE operations-Os-64

![operation counts -O3 32-bit]({{ site.url }}/plots/operations-O3-32.svg)

_Figure 20: Retired operation counts -O3 32-bit_

TABLE operations-O3-32

![operation counts -O2 32-bit]({{ site.url }}/plots/operations-O2-32.svg)

_Figure 21: Retired operation counts -O2 32-bit_

TABLE operations-O2-32

![operation counts -Os 32-bit]({{ site.url }}/plots/operations-Os-32.svg)

_Figure 22: Retired operation counts -Os 32-bit_

TABLE operations-Os-32


### Executable File Sizes

GCC stripped executable sizes comparing aarch64, riscv32, riscv64, x86-32 and x86-64:

![benchmark filesizes -O3]({{ site.url }}/plots/filesize-O3.svg)

_Figure 23: Compiled file sizes -O3_

TABLE filesize-O3

![benchmark filesizes -O2]({{ site.url }}/plots/filesize-O2.svg)

_Figure 24: Compiled file sizes -O2_

TABLE filesize-O2

![benchmark filesizes -Os]({{ site.url }}/plots/filesize-Os.svg)

_Figure 25: Compiled file sizes -Os_

TABLE filesize-Os


### Dynamic Register Usage

Dynamic register usage results comparing riscv64 -O3, -O2, -Os

![aes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-aes-rv64-1.svg)

_Figure 26: Dynamic register usage - aes -O3, -O2, -Os (sorted by frequency)_

![aes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-aes-rv64-2.svg)

_Figure 27: Dynamic register usage - aes -O3, -O2, -Os (sorted by alphabetically)_

![bigint register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-bigint-rv64-1.svg)

_Figure 28: Dynamic register usage - bigint -O3, -O2, -Os (sorted by frequency)_

![bigint register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-bigint-rv64-2.svg)

_Figure 29: Dynamic register usage - bigint -O3, -O2, -Os (sorted by alphabetically)_

![dhrystone register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-dhrystone-rv64-1.svg)

_Figure 30: Dynamic register usage - dhrystone -O3, -O2, -Os (sorted by frequency)_

![dhrystone register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-dhrystone-rv64-2.svg)

_Figure 31: Dynamic register usage - dhrystone -O3, -O2, -Os (sorted by alphabetically)_

![miniz register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-miniz-rv64-1.svg)

_Figure 32: Dynamic register usage - miniz -O3, -O2, -Os (sorted by frequency)_

![miniz register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-miniz-rv64-2.svg)

_Figure 33: Dynamic register usage - miniz -O3, -O2, -Os (sorted by alphabetically)_

![norx register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-norx-rv64-1.svg)

_Figure 34: Dynamic register usage - norx -O3, -O2, -Os (sorted by frequency)_

![norx register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-norx-rv64-2.svg)

_Figure 35: Dynamic register usage - norx -O3, -O2, -Os (sorted by alphabetically)_

![primes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-primes-rv64-1.svg)

_Figure 36: Dynamic register usage - primes -O3, -O2, -Os (sorted by frequency)_

![primes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-primes-rv64-2.svg)

_Figure 37: Dynamic register usage - primes -O3, -O2, -Os (sorted by alphabetically)_

![qsort register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-qsort-rv64-1.svg)

_Figure 38: Dynamic register usage - qsort -O3, -O2, -Os (sorted by frequency)_

![qsort register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-qsort-rv64-2.svg)

_Figure 39: Dynamic register usage - qsort -O3, -O2, -Os (sorted by alphabetically)_

![sha512 register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-sha512-rv64-1.svg)

_Figure 40: Dynamic register usage - sha512 -O3, -O2, -Os (sorted by frequency)_

![sha512 register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-sha512-rv64-2.svg)

_Figure 41: Dynamic register usage - sha512 -O3, -O2, -Os (sorted by alphabetically)_


### Dynamic Instruction Usage

Dynamic instruction usage results comparing riscv64 -O3, -O2, -Os

![aes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-aes-rv64-1.svg)

_Figure 42: Dynamic instruction usage - aes -O3, -O2, -Os (sorted by frequency)_

![aes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-aes-rv64-2.svg)

_Figure 43: Dynamic instruction usage - aes -O3, -O2, -Os (sorted by alphabetically)_

![bigint instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-bigint-rv64-1.svg)

_Figure 44: Dynamic instruction usage - bigint -O3, -O2, -Os (sorted by frequency)_

![bigint instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-bigint-rv64-2.svg)

_Figure 45: Dynamic instruction usage - bigint -O3, -O2, -Os (sorted by alphabetically)_

![dhrystone instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-dhrystone-rv64-1.svg)

_Figure 46: Dynamic instruction usage - dhrystone -O3, -O2, -Os (sorted by frequency)_

![dhrystone instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-dhrystone-rv64-2.svg)

_Figure 47: Dynamic instruction usage - dhrystone -O3, -O2, -Os (sorted by alphabetically)_

![miniz instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-miniz-rv64-1.svg)

_Figure 48: Dynamic instruction usage - miniz -O3, -O2, -Os (sorted by frequency)_

![miniz instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-miniz-rv64-2.svg)

_Figure 49: Dynamic instruction usage - miniz -O3, -O2, -Os (sorted by alphabetically)_

![norx instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-norx-rv64-1.svg)

_Figure 50: Dynamic instruction usage - norx -O3, -O2, -Os (sorted by frequency)_

![norx instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-norx-rv64-2.svg)

_Figure 51: Dynamic instruction usage - norx -O3, -O2, -Os (sorted by alphabetically)_

![primes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-primes-rv64-1.svg)

_Figure 52: Dynamic instruction usage - primes -O3, -O2, -Os (sorted by frequency)_

![primes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-primes-rv64-2.svg)

_Figure 53: Dynamic instruction usage - primes -O3, -O2, -Os (sorted by alphabetically)_

![qsort instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-qsort-rv64-1.svg)

_Figure 54: Dynamic instruction usage - qsort -O3, -O2, -Os (sorted by frequency)_

![qsort instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-qsort-rv64-2.svg)

_Figure 55: Dynamic instruction usage - qsort -O3, -O2, -Os (sorted by alphabetically)_

![sha512 instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-sha512-rv64-1.svg)

_Figure 56: Dynamic instruction usage - sha512 -O3, -O2, -Os (sorted by frequency)_

![sha512 instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-sha512-rv64-2.svg)

_Figure 57: Dynamic instruction usage - sha512 -O3, -O2, -Os (sorted by alphabetically)_
