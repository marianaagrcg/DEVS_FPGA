# Clock (la placa da 50 MHz en el conector dedicado)
set_property PACKAGE_PIN N11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]

#rst button center
set_property PACKAGE_PIN M14 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# Eventos: usa dos switches como ev_q y ev_at
# (Reemplaza las PACKAGE_PIN con las que estén en el master XDC para SW0 y SW1)
 # ejemplo: SW0
#set_property PACKAGE_PIN L5 [get_ports {ev_q}]   
#set_property IOSTANDARD LVCMOS33 [get_ports {ev_q}]

## ejemplo: SW1
#set_property PACKAGE_PIN L4 [get_ports {ev_at}]    
#set_property IOSTANDARD LVCMOS33 [get_ports {ev_at}]

## Indicador de done: LED0
## (Reemplaza PACKAGE_PIN con el pin real de LED0 según el master XDC)
set_property PACKAGE_PIN L3 [get_ports done_out]
set_property IOSTANDARD LVCMOS33 [get_ports done_out]
