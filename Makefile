#
# rv8-bench
#

CFLAGS = -Ofast -fPIE
LDFLAGS = -static

CC_RV32 = riscv32-linux-musl-gcc
CC_RV64 = riscv64-linux-musl-gcc
CC_I386 = i386-linux-musl-gcc
CC_X86_64 = x86_64-linux-musl-gcc

PROGRAMS = aes dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))
I386_PROGS = $(addprefix bin/i386/, $(PROGRAMS))
X86_64_PROGS = $(addprefix bin/x86_64/, $(PROGRAMS))

all: $(RV32_PROGS) $(RV64_PROGS) $(I386_PROGS) $(X86_64_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%: src/%.c
	@mkdir -p $(@D)
	$(CC_RV32) $(LDFLAGS) $(CFLAGS) $< -o $@

bin/riscv64/%: src/%.c
	@mkdir -p $(@D)
	$(CC_RV64) $(LDFLAGS) $(CFLAGS) $< -o $@

bin/i386/%: src/%.c
	@mkdir -p $(@D)
	$(CC_I386) $(LDFLAGS) $(CFLAGS) $< -o $@

bin/x86_64/%: src/%.c
	@mkdir -p $(@D)
	$(CC_X86_64) $(LDFLAGS) $(CFLAGS) $< -o $@
