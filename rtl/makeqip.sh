#!/bin/sh

echo -n > CoCo2.qip
for vhd in $(find . -name "*.vhd"); do
	echo "set_global_assignment -name VHDL_FILE [file join $::quartus(qip_path) $vhd      ]" >> CoCo2.qip
done

for vhd in $(find . -name "*.v"); do
	echo "set_global_assignment -name VERILOG_FILE [file join $::quartus(qip_path) $vhd      ]" >> CoCo2.qip
done

for vhd in $(find . -name "*.sv"); do
	echo "set_global_assignment -name SYSTEMVERILOG_FILE [file join $::quartus(qip_path) $vhd      ]" >> CoCo2.qip
done

