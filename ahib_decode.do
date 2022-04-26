onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_InstructionFetch/ins_fetch/clk
add wave -noupdate /tb_InstructionFetch/ins_fetch/reset
add wave -noupdate /tb_InstructionFetch/ins_fetch/ins_cache
add wave -noupdate -expand /tb_InstructionFetch/ins_fetch/instr_d
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first_odd
add wave -noupdate /tb_InstructionFetch/ins_fetch/stall
add wave -noupdate /tb_InstructionFetch/ins_fetch/read_enable
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/pc
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/pc_wb
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/pc_check
add wave -noupdate -radix hexadecimal /tb_InstructionFetch/ins_fetch/decode/instr_even
add wave -noupdate -radix hexadecimal /tb_InstructionFetch/ins_fetch/decode/instr_odd
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/branch_taken
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/stall_first
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first.instr
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first.reg_write
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first.even_valid
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/first.odd_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/first.rt_addr
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/stall_second
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/second.instr
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/second.reg_write
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/second.even_valid
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/second.odd_valid
add wave -noupdate -radix decimal /tb_InstructionFetch/ins_fetch/decode/second.rt_addr
add wave -noupdate -childformat {{/tb_InstructionFetch/ins_fetch/decode/first.imm -radix decimal} {/tb_InstructionFetch/ins_fetch/decode/first.rt_addr -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/first.ra_addr -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/first.rb_addr -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/first.rc_addr -radix unsigned}} -expand -subitemconfig {/tb_InstructionFetch/ins_fetch/decode/first.imm {-height 16 -radix decimal} /tb_InstructionFetch/ins_fetch/decode/first.rt_addr {-height 16 -radix unsigned} /tb_InstructionFetch/ins_fetch/decode/first.ra_addr {-height 16 -radix unsigned} /tb_InstructionFetch/ins_fetch/decode/first.rb_addr {-height 16 -radix unsigned} /tb_InstructionFetch/ins_fetch/decode/first.rc_addr {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/first
add wave -noupdate -childformat {{/tb_InstructionFetch/ins_fetch/decode/second.imm -radix decimal} {/tb_InstructionFetch/ins_fetch/decode/second.rt_addr -radix decimal} {/tb_InstructionFetch/ins_fetch/decode/second.ra_addr -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/second.rb_addr -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/second.rc_addr -radix unsigned}} -expand -subitemconfig {/tb_InstructionFetch/ins_fetch/decode/second.imm {-height 16 -radix decimal} /tb_InstructionFetch/ins_fetch/decode/second.rt_addr {-height 16 -radix decimal} /tb_InstructionFetch/ins_fetch/decode/second.ra_addr {-height 16 -radix unsigned} /tb_InstructionFetch/ins_fetch/decode/second.rb_addr {-height 16 -radix unsigned} /tb_InstructionFetch/ins_fetch/decode/second.rc_addr {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/second
add wave -noupdate -radix unsigned -childformat {{{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[0]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[1]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[2]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[3]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[4]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[5]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[6]} -radix unsigned}} -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[0]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[1]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[2]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[3]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[4]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[5]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even[6]} {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_even
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/reg_write_delay_even
add wave -noupdate -radix unsigned -childformat {{{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[0]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[1]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[2]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[3]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[4]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[5]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[6]} -radix unsigned}} -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[0]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[1]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[2]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[3]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[4]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[5]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd[6]} {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/rt_addr_delay_odd
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/reg_write_delay_odd
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/rf/rt_addr_even
add wave -noupdate -radix unsigned -childformat {{{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[6]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[5]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[4]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[3]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[2]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[1]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[0]} -radix unsigned}} -expand -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[6]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[5]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[4]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[3]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[2]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[1]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay[0]} {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/rt_addr_delay
add wave -noupdate -radix binary -childformat {{{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[6]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[5]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[4]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[3]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[2]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[1]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[0]} -radix binary}} -expand -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[6]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[5]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[4]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[3]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[2]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[1]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay[0]} {-height 16 -radix binary}} /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fp1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx2/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx2/rt_addr_delay
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx2/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/ev/b1/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/ev/b1/rt_addr_delay
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/pipe/ev/b1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_delay
add wave -noupdate -radix unsigned -childformat {{{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_addr_delay[1]} -radix unsigned} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_addr_delay[0]} -radix unsigned}} -expand -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_addr_delay[1]} {-height 16 -radix unsigned} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_addr_delay[0]} {-height 16 -radix unsigned}} /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/rt_addr_delay
add wave -noupdate -radix binary -childformat {{{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/reg_write_delay[1]} -radix binary} {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/reg_write_delay[0]} -radix binary}} -expand -subitemconfig {{/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/reg_write_delay[1]} {-height 16 -radix binary} {/tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/reg_write_delay[0]} {-height 16 -radix binary}} /tb_InstructionFetch/ins_fetch/decode/pipe/ev/fx1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/p1/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/od/p1/rt_addr_delay
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/pipe/od/p1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/ls1/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/od/ls1/rt_addr_delay
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/pipe/od/ls1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/br1/rt_delay
add wave -noupdate -radix unsigned /tb_InstructionFetch/ins_fetch/decode/pipe/od/br1/rt_addr_delay
add wave -noupdate -radix binary /tb_InstructionFetch/ins_fetch/decode/pipe/od/br1/reg_write_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/br1/pc_delay
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/br1/branch_delay
add wave -noupdate -expand /tb_InstructionFetch/ins_fetch/decode/pipe/rf/registers
add wave -noupdate /tb_InstructionFetch/ins_fetch/decode/pipe/od/ls1/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {331 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 404
configure wave -valuecolwidth 265
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
WaveRestoreZoom {201 ns} {533 ns}
