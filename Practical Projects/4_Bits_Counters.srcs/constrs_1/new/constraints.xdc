## Botón (btn[4] corresponde al botón central)
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33 PULLDOWN true} [get_ports {btn}]

## LEDs (LED[3:0])
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {LED[0]}]   ;# LSB
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports {LED[3]}]   ;# MSB

## Clock (50 MHz)
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports {clk}]

## Display de 7 segmentos - dígitos (digit[3:0])
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {digit[0]}]  ;# LSB
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {digit[1]}]
set_property -dict {PACKAGE_PIN G5 IOSTANDARD LVCMOS33} [get_ports {digit[2]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {digit[3]}]  ;# MSB

## Display de 7 segmentos - segmentos (Seven_Seg[7:0])
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[7]}] ;# A
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[6]}] ;# B
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[5]}] ;# C
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[4]}] ;# D
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[3]}] ;# E
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[2]}] ;# F
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[1]}] ;# G
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {Seven_Seg[0]}] ;# DP (punto decimal)
