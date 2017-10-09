#
# rv8-bench
#

CFLAGS = -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-linux-musl-
I386 = i386-linux-musl-
X86_64 = x86_64-linux-musl-
ARM32 = arm-linux-musleabihf-
ARM64 = aarch64-linux-musl-

PROGRAMS = aes bigint dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))
I386_PROGS = $(addprefix bin/i386/, $(PROGRAMS))
X86_64_PROGS = $(addprefix bin/x86_64/, $(PROGRAMS))
ARM32_PROGS = $(addprefix bin/arm/, $(PROGRAMS))
ARM64_PROGS = $(addprefix bin/aarch64/, $(PROGRAMS))

ALL_PROGS = $(RV32_PROGS) $(RV64_PROGS) $(I386_PROGS) $(X86_64_PROGS) $(ARM32_PROGS) $(ARM64_PROGS)
O3_PROGS = $(addsuffix .O3, $(ALL_PROGS)) $(addsuffix .O3.stripped, $(ALL_PROGS))
O2_PROGS = $(addsuffix .O2, $(ALL_PROGS)) $(addsuffix .O2.stripped, $(ALL_PROGS))
OS_PROGS = $(addsuffix .Os, $(ALL_PROGS)) $(addsuffix .Os.stripped, $(ALL_PROGS))

all: $(O3_PROGS) $(O2_PROGS) $(OS_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv32/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv32/%.O3.stripped: bin/riscv32/%.O3
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv32/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv32/%.O2.stripped: bin/riscv32/%.O2
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv32/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv32/%.Os.stripped: bin/riscv32/%.Os
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@

bin/riscv64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3.stripped: bin/riscv64/%.O3
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2.stripped: bin/riscv64/%.O2
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os.stripped: bin/riscv64/%.Os
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@

bin/i386/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/i386/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/i386/%.O3.stripped: bin/i386/%.O3
	@echo STRIP $@ ; $(I386)strip --strip-all $< -o $@
bin/i386/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/i386/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/i386/%.O2.stripped: bin/i386/%.O2
	@echo STRIP $@ ; $(I386)strip --strip-all $< -o $@
bin/i386/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/i386/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(I386)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/i386/%.Os.stripped: bin/i386/%.Os
	@echo STRIP $@ ; $(I386)strip --strip-all $< -o $@

bin/x86_64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/x86_64/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/x86_64/%.O3.stripped: bin/x86_64/%.O3
	@echo STRIP $@ ; $(X86_64)strip --strip-all $< -o $@
bin/x86_64/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/x86_64/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/x86_64/%.O2.stripped: bin/x86_64/%.O2
	@echo STRIP $@ ; $(X86_64)strip --strip-all $< -o $@
bin/x86_64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/x86_64/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(X86_64)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/x86_64/%.Os.stripped: bin/x86_64/%.Os
	@echo STRIP $@ ; $(X86_64)strip --strip-all $< -o $@

bin/arm/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/arm/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/arm/%.O3.stripped: bin/arm/%.O3
	@echo STRIP $@ ; $(ARM32)strip --strip-all $< -o $@
bin/arm/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/arm/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/arm/%.O2.stripped: bin/arm/%.O2
	@echo STRIP $@ ; $(ARM32)strip --strip-all $< -o $@
bin/arm/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/arm/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM32)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/arm/%.Os.stripped: bin/arm/%.Os
	@echo STRIP $@ ; $(ARM32)strip --strip-all $< -o $@

bin/aarch64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/aarch64/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/aarch64/%.O3.stripped: bin/aarch64/%.O3
	@echo STRIP $@ ; $(ARM64)strip --strip-all $< -o $@
bin/aarch64/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/aarch64/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/aarch64/%.O2.stripped: bin/aarch64/%.O2
	@echo STRIP $@ ; $(ARM64)strip --strip-all $< -o $@
bin/aarch64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/aarch64/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(ARM64)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/aarch64/%.Os.stripped: bin/aarch64/%.Os
	@echo STRIP $@ ; $(ARM64)strip --strip-all $< -o $@
