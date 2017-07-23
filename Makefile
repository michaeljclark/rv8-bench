#
# rv8-bench
#

CFLAGS = -Os -fPIE -g0
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

all: $(RV32_PROGS) $(RV64_PROGS) $(I386_PROGS) $(X86_64_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%: src/%.c
	@mkdir -p $(@D)
	$(RV32)gcc $(LDFLAGS) $(CFLAGS) $< -o $@
	$(RV32)strip --strip-debug $@

bin/riscv64/%: src/%.c
	@mkdir -p $(@D)
	$(RV64)gcc $(LDFLAGS) $(CFLAGS) $< -o $@
	$(RV64)strip --strip-debug $@

bin/i386/%: src/%.c
	@mkdir -p $(@D)
	$(I386)gcc $(LDFLAGS) $(CFLAGS) $< -o $@
	$(I386)strip --strip-debug $@

bin/x86_64/%: src/%.c
	@mkdir -p $(@D)
	$(X86_64)gcc $(LDFLAGS) $(CFLAGS) $< -o $@
	$(X86_64)strip --strip-debug $@
