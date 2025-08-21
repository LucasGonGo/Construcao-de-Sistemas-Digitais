TOP = top_tb

VERILOG_BASE = .

VERILOG_SRC = \
	$(VERILOG_BASE)/debounce.v \
	$(VERILOG_BASE)/counter.v \
	$(VERILOG_BASE)/dspl_drv_NexysA7.v \
	$(VERILOG_BASE)/top.v \
	$(VERILOG_BASE)/top_tb.v
	
TIME = 1ms

all:

# Command line simulation using ModelSim
# run simulation with 'make modelsim-top TIME=10ms' to run for 10ms
modelsim:
	vlib mylib
	vmap work ./mylib
	vlog -work mylib $(VERILOG_SRC)

modelsim-top: modelsim
	vsim $(GUI) mylib.$(TOP) -voptargs=+acc -c -do "vcd file ${TOP}.vcd -compress; vcd add /*; run ${TIME}; quit"
	
modelsim-all: modelsim
	vsim $(GUI) mylib.$(TOP) -voptargs=+acc -c -do "vcd file ${TOP}.vcd -compress; vcd add -r /*; run ${TIME}; quit"

modelsim-wave: modelsim
	vsim $(GUI) mylib.$(TOP) -voptargs=+acc -do "add wave -r /*; run ${TIME};"
	

# Command line simulation using Icarus Verilog 
iverilog:
	iverilog -g2005-sv $(VERILOG_SRC)
	
iverilog-vcd: iverilog
	vvp a.out -lxt

# Display waveforms
wave-vcd:
	@if [ -f "$(TOP).vcd" ]; then \
		gtkwave $(TOP).vcd --rcvar 'fontname_signals Monospace 12' --rcvar 'fontname_waves Monospace 12'; \
	else \
		gtkwave $(TOP).vcd.gz --rcvar 'fontname_signals Monospace 12' --rcvar 'fontname_waves Monospace 12'; \
	fi

# Clean all generated files
clean:
	@ rm -rf simu work mylib
	@ rm -f $(TOP)
	@ rm -f $(TOP).vcd.gz
	@ rm -f $(TOP).vcd $(TOP).ghw
	@ rm -f *.txt *.ini *.vsim transcript *.out
