prefijo        ?= sim
dir_fuentes    ?= src
dir_resultados ?= resultados
dir_trabajo    ?= build
dir_asm	       ?= asm

resultados := $(abspath $(dir_resultados))
trabajo    := $(abspath $(dir_trabajo))
fuentes    := $(abspath $(dir_fuentes))
r_trabajo = $(shell realpath --relative-to $(resultados) $(trabajo))
r_resultados = $(shell realpath --relative-to $(trabajo) $(resultados))
r_fuentes = $(shell realpath --relative-to $(trabajo) $(fuentes))

sims 	   := $(basename $(notdir $(wildcard $(fuentes)/$(prefijo)_*.v)))
ops 	   := -g2005-sv

blancos := $(patsubst $(prefijo)_%,%,$(sims))

arch_fuentes = $(wildcard $(fuentes)/*.v)
arch_producidos = $(wildcard $(resultados)/*) $(wildcard $(trabajo)/*)

.PHONY: all clean asm $(blancos)

all : $(blancos)

ifeq ($(strip $(arch_producidos)), )
clean :
else
clean :
	rm  $(arch_producidos)
endif

$(trabajo):
	mkdir $(trabajo)
$(resultados): | $(trabajo)
	mkdir $(resultados)

netlistsvg = $(let nsvg,$(shell which netlistsvg),$(if $(wildcard $(nsvg).cmd),$(nsvg).cmd,$(nsvg)))

define plantilla =
$(1): | $(resultados)
	cd $(trabajo) && iverilog $(ops) -I$(r_fuentes) -s $(2) -o$(2) $(r_fuentes)/$(2).v
	cd $(resultados) && vvp $(r_trabajo)/$(2)
ifneq ($(netlistsvg),)
diagrama_$(1): | $(resultados)
	cd $(trabajo) && yosys -q -p "read_verilog -I$(r_fuentes) $(r_fuentes)/$(1).v; prep -top $(1); write_json -compat-int $(1).json"
	cd $(trabajo) && sed -i 's/"inout"/"output"/g' $(1).json
	cd $(trabajo) && $(netlistsvg) $(1).json -o $(resultados)/$(1).svg
endif
endef

$(foreach blanco,$(blancos),$(eval $(call plantilla,$(blanco),$(prefijo)_$(blanco))))

define plantilla_nuevo_ent =
module $(1) (
    output Y,
    input  a,
    input  b
);
    assign Y = a & b;
endmodule
endef
define plantilla_nuevo_sim = 
`include "$(1).v"
module sim_$(1) ;
    integer i;
    reg a,b;
    wire Y;
    $(1) dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $$dumpfile("$(1).vcd");
        $$dumpvars(0);
        for (i=0;i<4;i = i + 1) begin
            {a,b} = i[1:0];
            #10;
        end
    end
endmodule
endef


nuevoent = $(patsubst nuevo_%,%,$@)
narchent = $(addsuffix .v,$(addprefix $(fuentes)/,$(nuevoent)))
narchsim = $(addsuffix .v,$(addprefix $(fuentes)/sim_,$(nuevoent)))
preexistente = $(nuevoent) preexistente, omitido
creado       = $(nuevoent) creado con ejemplo $(file >$(narchent),$(call plantilla_nuevo_ent,$(nuevoent)))$(file >$(narchsim),$(call plantilla_nuevo_sim,$(nuevoent)))

nuevo_%:
	echo $(if $(wildcard $(narchent) $(narchsim)),$(preexistente),$(creado))

topent = $(patsubst bin_%,%,$@)
yosys_log = $(topent).yosys_log
bin_%: | $(resultados)
	cd $(trabajo) && yosys -p "read_verilog -I$(r_fuentes) $(r_fuentes)/$(topent).v ; synth_ice40 -json $(topent).json -top $(topent)" -l $(yosys_log)
	cd $(trabajo) && nextpnr-ice40 --hx4k --json $(topent).json --pcf $(fuentes)/$(topent).pcf --package tq144 --asc $(topent).asc --log $(topent).pnr_log
	cd $(trabajo) && icepack $(topent).asc $(r_resultados)/$(topent).bin

progbin = $(patsubst prog_%,%.bin,$@)
prog_%:
	cd $(resultados) && iceprog $(progbin)

asm:
	$(MAKE) -C $(dir_asm)

asm_%:
	$(MAKE) -C $(dir_asm) $(patsubst asm_%,%,$@)

modo_vhdl:
	cp -f Makefile-vhdl Makefile
