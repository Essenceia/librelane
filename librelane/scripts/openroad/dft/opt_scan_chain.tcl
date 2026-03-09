source $::env(SCRIPTS_DIR)/openroad/common/io.tcl

read_current_odb

report_dft_plan -verbose

# minimize wire length
execute_dft_plan

write_views
