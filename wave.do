onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_Pipes/dut/clk
add wave -noupdate /tb_Pipes/dut/reset
add wave -noupdate -radix binary /tb_Pipes/dut/instr_even
add wave -noupdate -radix binary /tb_Pipes/dut/instr_odd
add wave -noupdate -radix unsigned /tb_Pipes/dut/pc
add wave -noupdate -radix unsigned /tb_Pipes/dut/pc_wb
add wave -noupdate /tb_Pipes/dut/branch_taken
add wave -noupdate -radix unsigned /tb_Pipes/dut/format_even
add wave -noupdate -radix unsigned /tb_Pipes/dut/format_odd
add wave -noupdate -radix binary /tb_Pipes/dut/op_even
add wave -noupdate -radix binary /tb_Pipes/dut/op_odd
add wave -noupdate -radix unsigned /tb_Pipes/dut/unit_even
add wave -noupdate -radix unsigned /tb_Pipes/dut/unit_odd
add wave -noupdate -radix decimal /tb_Pipes/dut/rt_addr_even
add wave -noupdate -radix decimal /tb_Pipes/dut/rt_addr_odd
add wave -noupdate /tb_Pipes/dut/ra_even
add wave -noupdate /tb_Pipes/dut/rb_even
add wave -noupdate /tb_Pipes/dut/rc_even
add wave -noupdate /tb_Pipes/dut/ra_odd
add wave -noupdate /tb_Pipes/dut/rb_odd
add wave -noupdate /tb_Pipes/dut/rt_st_odd
add wave -noupdate /tb_Pipes/dut/ra_even_fwd
add wave -noupdate /tb_Pipes/dut/rb_even_fwd
add wave -noupdate /tb_Pipes/dut/rc_even_fwd
add wave -noupdate /tb_Pipes/dut/ra_odd_fwd
add wave -noupdate /tb_Pipes/dut/rb_odd_fwd
add wave -noupdate /tb_Pipes/dut/rt_st_odd_fwd
add wave -noupdate -radix decimal /tb_Pipes/dut/imm_even
add wave -noupdate -radix decimal /tb_Pipes/dut/imm_odd
add wave -noupdate /tb_Pipes/dut/reg_write_even
add wave -noupdate /tb_Pipes/dut/reg_write_odd
add wave -noupdate /tb_Pipes/dut/rt_even_wb
add wave -noupdate /tb_Pipes/dut/rt_odd_wb
add wave -noupdate -radix decimal /tb_Pipes/dut/rt_addr_even_wb
add wave -noupdate -radix decimal /tb_Pipes/dut/rt_addr_odd_wb
add wave -noupdate /tb_Pipes/dut/reg_write_even_wb
add wave -noupdate /tb_Pipes/dut/reg_write_odd_wb
add wave -noupdate /tb_Pipes/dut/rf/registers
add wave -noupdate /tb_Pipes/dut/ev/fw_wb
add wave -noupdate -radix decimal /tb_Pipes/dut/ev/fw_addr_wb
add wave -noupdate -radix binary /tb_Pipes/dut/ev/fw_write_wb
add wave -noupdate /tb_Pipes/dut/od/fw_wb
add wave -noupdate -radix decimal /tb_Pipes/dut/od/fw_addr_wb
add wave -noupdate -radix binary /tb_Pipes/dut/od/fw_write_wb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 271
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {194 ns}
