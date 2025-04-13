vlib work
vlog APB.sv APB_slave_pkg.sv Interface.sv testbench.sv top.sv  +cover -covercells
vsim -voptargs="+cover=bcfst+top/APB_slave_pkg" work.top -cover
add wave *
coverage save APB.ucdb -onexit
run -all
quit -sim
vcover report APB.ucdb -details -all -output coverage_rpt.txt