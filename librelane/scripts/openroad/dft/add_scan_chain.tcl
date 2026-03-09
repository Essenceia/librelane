source $::env(SCRIPTS_DIR)/openroad/common/io.tcl
source $::env(SCRIPTS_DIR)/openroad/dft/utils.tcl 
source $::env(SCRIPTS_DIR)/openroad/dft/helper.tcl

read_pnr_libs
read_lefs
read_current_netlist

set_dft_config -max_chains 1 -clock_mixing no_mix \
-scan_enable_name_pattern $::env(DFT_SCAN_EN_PORT) \
-scan_in_name_pattern     $::env(DFT_SCAN_TDI_PORT) \
-scan_out_name_pattern    $::env(DFT_SCAN_TDO_PORT)  

set existing_dont_touch [report_dont_touch]

# set don't touch on everything connected to jtag clk since it will be used
# to driver dft ff verif
set jtag_clk [get_clock $::env(JTAG_CLOCK_NAME)] 
exclude_from_scan_chain $jtag_clk

add_scan_chain

# cleanup dont touch to allow optimizations of implem
cleanup_dont_touch $jtag_clk

# check cleaned dont touch matches existing dont touch 
# if these don't match this means we might be removing some
# explicitly set dont touch we actually wanted to keep
set cleaned_dont_touch [report_dont_touch] 
if { $existing_dont_touch != $cleaned_dont_touch } {
	utl::error ADD_SCAN_CHAIN_TCL 1 "Custom error, dont touch list after cleanup doesnt match expected. Likely error in cleanup" 
}

set def_file [make_result_file scan_chain_inserted.def]
write_def $def_file

write_scan_chain_translate [make_result_file translation.csv] [odb::get_block]

write_views
