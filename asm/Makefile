prefijo_arch := riscv64-unknown-elf-
as := $(prefijo_arch)as
ld := $(prefijo_arch)ld
hexdump := hexdump
objcopy := $(prefijo_arch)objcopy
opt_objcopy := -O binary
opt_as := -march=rv32i -mabi=ilp32
opt_ld := -b elf32-littleriscv
opt_hexdump := -e '/4 "%08x\n"'
guion := guion.ld
progs := $(basename $(notdir $(wildcard *.s)))

salida := ../resultados

.PHONY : $(progs)
all: $(progs)

resultados := $(wildcard *.o *.elf *.bin *.mem)
ifneq ($(resultados),)
clean:
	rm $(resultados)
else
clean:
endif

%.o: %.s
	$(as) $(opt_as) -o $@ $<

%.elf: %.o $(guion)
	$(ld) $(opt_ld) -T $(guion) -o $@ $<

%.bin: %.elf
	$(objcopy) $(opt_objcopy) $< $@

%.mem: %.bin
	$(hexdump) $(opt_hexdump) $< >$@

define plantilla_prog =
$(1): $(1).mem
	mv $(1).mem $(salida)/$(1).mem
endef
$(foreach prog,$(progs),$(eval $(call plantilla_prog,$(prog))))
