rv8-bench
===============

The rv8 benchmark suite contains a small set of currently integer
centric benchmarks for regression testing of the rv8 binary
translation engine. The suite contains the following test programs:

- qsort
- aes
- norx
- dhrystone
- primes
- miniz
- sha512

## Dependencies

rv8-bench depends on the following software:

- [rv8](https://github.com/rv8-io/rv8/)
- [riscv-qemu](https://github.com/riscv/riscv-qemu/)
- [musl-riscv-toolchain-7.1.0-2](https://github.com/rv8-io/musl-riscv-toolchain/releases/tag/v7.1.0-2)
- [Node.js](https://nodejs.org/)

_Installing Node.js on macOS with brew_
```
brew install node
```

_Installing Node.js on Debian Stretch_
```
sudo apt-get install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
```

_Installing musl-riscv-toolchain_
```
git clone https://github.com/rv8-io/musl-riscv-toolchain.git
cd musl-riscv-toolchain
for i in riscv32 riscv64 i386 x86_64 arm aarch64; do sh bootstrap.sh $i ; done
```

_Installing rv8_
```
git clone https://github.com/rv8-io/rv8.git
cd rv8
git submodule update --init
make -j4 && sudo make install
```

_Installing riscv-qemu_
```
git clone https://github.com/riscv/riscv-qemu.git
cd riscv-qemu
git submodule update --init
./configure --target-list=riscv64-softmmu,riscv32-softmmu
make -j4 && sudo make install
```

## Building

To build the rv8 benchmarks for riscv32, riscv64, i386 and
x86_64 run `make` in the rv8-bench directory:

```
cd rv8-bench
make
```

## Running

To see how to run the benchmarks execute `npm start` for usage instructions:

```
npm start bench <benchmark> <target> <opt> <runs>
npm start gather
```
