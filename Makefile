#
# rv8-bench
#

CFLAGS = -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-linux-musl-
I386 = i386-linux-musl-
X86_64 = x86_64-linux-musl-
ARM64 = aarch64-linux-musl-

PROGRAMS = aes dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))
I386_PROGS = $(addprefix bin/i386/, $(PROGRAMS))
X86_64_PROGS = $(addprefix bin/x86_64/, $(PROGRAMS))
ARM64_PROGS = $(addprefix bin/aarch64/, $(PROGRAMS))

ALL_PROGS = $(RV32_PROGS) $(RV64_PROGS) $(I386_PROGS) $(X86_64_PROGS) $(ARM64_PROGS)
O3_PROGS = $(addsuffix .O3, $(ALL_PROGS)) $(addsuffix .O3.stripped, $(ALL_PROGS))
OS_PROGS = $(addsuffix .Os, $(ALL_PROGS)) $(addsuffix .Os.stripped, $(ALL_PROGS))

all: $(O3_PROGS) $(OS_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv32/%.O3.stripped: bin/riscv32/%.O3
	@echo STRIP $@ ; $(RV32)strip --strip-debug $< -o $@
bin/riscv32/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv32/%.Os.stripped: bin/riscv32/%.Os
	@echo STRIP $@ ; $(RV32)strip --strip-debug $< -o $@

bin/riscv64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3.stripped: bin/riscv64/%.O3
	@echo STRIP $@ ; $(RV64)strip --strip-debug $< -o $@
bin/riscv64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os.stripped: bin/riscv64/%.Os
	@echo STRIP $@ ; $(RV64)strip --strip-debug $< -o $@

bin/i386/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/i386/%.O3.stripped: bin/i386/%.O3
	@echo STRIP $@ ; $(I386)strip --strip-debug $< -o $@
bin/i386/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/i386/%.Os.stripped: bin/i386/%.Os
	@echo STRIP $@ ; $(I386)strip --strip-debug $< -o $@

bin/x86_64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/x86_64/%.O3.stripped: bin/x86_64/%.O3
	@echo STRIP $@ ; $(X86_64)strip --strip-debug $< -o $@
bin/x86_64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/x86_64/%.Os.stripped: bin/x86_64/%.Os
	@echo STRIP $@ ; $(X86_64)strip --strip-debug $< -o $@

bin/aarch64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/aarch64/%.O3.stripped: bin/aarch64/%.O3
	@echo STRIP $@ ; $(ARM64)strip --strip-debug $< -o $@
bin/aarch64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/aarch64/%.Os.stripped: bin/aarch64/%.Os
	@echo STRIP $@ ; $(ARM64)strip --strip-debug $< -o $@
