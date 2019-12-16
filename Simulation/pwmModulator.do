onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {Reset and clock} /pwmmodulator_tb/reset
add wave -noupdate -group {Reset and clock} /pwmmodulator_tb/clock
add wave -noupdate -expand -group Controls /pwmmodulator_tb/threeLevel
add wave -noupdate -expand -group Controls /pwmmodulator_tb/switchEvenOdd
add wave -noupdate -expand -group Controls /pwmmodulator_tb/doubleFrequency
add wave -noupdate -expand -group {Sine wave} -format Analog-Step -height 100 -max 500.0 -min -500.0 -radix decimal /pwmmodulator_tb/amplitude
add wave -noupdate -expand -group PWM /pwmmodulator_tb/pwmCountEn
add wave -noupdate -expand -group PWM -format Analog-Step -height 30 -max 1022.9999999999999 -radix unsigned /pwmmodulator_tb/I_DUT/sawtooth
add wave -noupdate -expand -group PWM /pwmmodulator_tb/pwm1
add wave -noupdate -expand -group PWM /pwmmodulator_tb/pwm2
add wave -noupdate -expand -group PWM -format Analog-Step -height 30 -max 1.0 -min -1.0 -radix decimal /pwmmodulator_tb/I_TB/pwm
add wave -noupdate -expand -group {Filtered output} -format Analog-Step -height 50 -max 1.0 -min -1.0 /pwmmodulator_tb/lowpass1
add wave -noupdate -expand -group {Filtered output} -format Analog-Step -height 50 -max 1.0 -min -1.0 /pwmmodulator_tb/lowpass2
add wave -noupdate -expand -group {Filtered output} -format Analog-Step -height 100 -max 2.0 -min -2.0 /pwmmodulator_tb/I_TB/pwmFiltered
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
configure wave -valuecolwidth 42
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {168 ms}
