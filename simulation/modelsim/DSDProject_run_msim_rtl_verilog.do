transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/altera/14.0/DSDProject {C:/altera/14.0/DSDProject/seven_segment_decoder.v}
vlog -vlog01compat -work work +incdir+C:/altera/14.0/DSDProject {C:/altera/14.0/DSDProject/DSDProject.v}

