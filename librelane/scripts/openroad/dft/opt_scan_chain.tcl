source $::env(SCRIPTS_DIR)/openroad/common/io.tcl

puts "opt_scan_chain::Optimizing scan chain wire length" 

read_current_odb

set_dft_config -max_chains 1 -clock_mixing clock_mix \
-max_length $::env(DFT_MAX_LENGTH) \
-scan_enable_name_pattern $::env(DFT_SCAN_EN_PORT) \
-scan_in_name_pattern     $::env(DFT_SCAN_TDI_PORT) \
-scan_out_name_pattern    $::env(DFT_SCAN_TDO_PORT)  

report_dft_config

# minimize wire length
report_dft_plan -verbose
execute_dft_plan

write_views
