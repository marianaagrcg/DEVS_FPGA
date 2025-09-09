
# Clock signal
set_property -dict { PACKAGE_PIN N11    IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports {clk}];

#Reset Button
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {rst_n_in}]; #Button-center

#Start Button
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {start_btn_in}]; #Button-top

#Leds
set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { done_out_led }];
set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { at_led }];
set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { q_led }];
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { done_s_led }];