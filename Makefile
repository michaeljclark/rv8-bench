#
# rv8-bench
#

CFLAGS = -Os -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-linux-musl-
I386 = i386-linux-musl-
X86_64 = x86_64-linux-musl-

PROGRAMS = aes dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))
I386_PROGS = $(addprefix bin/i386/, $(PROGRAMS))
X86_64_PROGS = $(addprefix bin/x86_64/, $(PROGRAMS))

ALL_PROGS = $(RV32_PROGS) $(RV64_PROGS) $(I386_PROGS) $(X86_64_PROGS)
STRIPPED_PROGS = $(addsuffix .stripped, $(ALL_PROGS))

all: $(ALL_PROGS) $(STRIPPED_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%: src/%.c
	@mkdir -p $(@D)
	$(RV32)gcc $(LDFLAGS) $(CFLAGS) $< -o $@

bin/riscv32/%.stripped: bin/riscv32/%
	$(RV32)strip --strip-debug $< -o $@

bin/riscv64/%: src/%.c
	@mkdir -p $(@D)
	$(RV64)gcc $(LDFLAGS) $(CFLAGS) $< -o $@

bin/riscv64/%.stripped: bin/riscv64/%
	$(RV64)strip --strip-debug $< -o $@

bin/i386/%: src/%.c
	@mkdir -p $(@D)
	$(I386)gcc $(LDFLAGS) $(CFLAGS) $< -o $@

bin/i386/%.stripped: bin/i386/%
	$(I386)strip --strip-debug $< -o $@

bin/x86_64/%: src/%.c
	@mkdir -p $(@D)
	$(X86_64)gcc $(LDFLAGS) $(CFLAGS) $< -o $@

bin/x86_64/%.stripped: bin/x86_64/%
	$(X86_64)strip --strip-debug $< -o $@
