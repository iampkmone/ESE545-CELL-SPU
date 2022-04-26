onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/clk
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/reset
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/ra_odd_addr
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/rb_odd_addr
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/ra_even_addr
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/rb_even_addr
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/rc_odd_addr
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/rc_even_addr
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/op
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/tmp_op
add wave -noupdate -childformat {{/tb_InstructionFetch/ins_fetch/decode/state.mask -radix binary}} -expand -subitemconfig {/tb_InstructionFetch/ins_fetch/decode/state.mask {-height 16 -radix binary}} /tb_InstructionFetch/ins_fetch/decode/state
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/stall
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/stall_odd_raw
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/stall_even_raw
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_even
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_odd
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_odd_issue
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_odd1_issue
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_even_issue
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/instr_even1_issue
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first_cyc
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_ra_odd_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_rb_odd_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_rc_odd_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_ra_even_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_rb_even_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/is_rc_even_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 407
configure wave -valuecolwidth 40
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
WaveRestoreZoom {136 ns} {326 ns}
