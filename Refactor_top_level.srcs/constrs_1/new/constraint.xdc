# Archivo de restricciones para el módulo 'top_level' en la placa EDGE Artix 7

# --- Restricción de Reloj (50 MHz) ---
# Define el reloj principal del sistema.
# Pin N11 es el reloj de 50 MHz de la placa EDGE Artix 7.
create_clock -period 20.000 -name clk [get_ports clk]
set_property PACKAGE_PIN N11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# --- Restricciones de Pin y Estándar de I/O ---
# Asigna cada puerto lógico de tu diseño a un pin físico de la FPGA.
# Los estándares de I/O se establecen como LVCMOS33 según la documentación de la placa.

# Entrada de Reset
# Asignado al botón superior (pb[0]) en el pin K13.
set_property PACKAGE_PIN K13 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PULLDOWN true [get_ports rst]

# Bus de entrada x_in_tb[7:0]
# Asignado a los 8 interruptores (sw[0] a sw[7]).
set_property PACKAGE_PIN L5 [get_ports x_in_tb[0]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[0]]
set_property PACKAGE_PIN L4 [get_ports x_in_tb[1]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[1]]
set_property PACKAGE_PIN M4 [get_ports x_in_tb[2]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[2]]
set_property PACKAGE_PIN M2 [get_ports x_in_tb[3]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[3]]
set_property PACKAGE_PIN M1 [get_ports x_in_tb[4]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[4]]
set_property PACKAGE_PIN N3 [get_ports x_in_tb[5]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[5]]
set_property PACKAGE_PIN N2 [get_ports x_in_tb[6]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[6]]
set_property PACKAGE_PIN N1 [get_ports x_in_tb[7]]
set_property IOSTANDARD LVCMOS33 [get_ports x_in_tb[7]]

# Bus de salida y_out_tb[7:0]
# Asignado a los 8 primeros LEDs (led[0] a led[7]).
set_property PACKAGE_PIN J3 [get_ports y_out_tb[0]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[0]]
set_property PACKAGE_PIN H3 [get_ports y_out_tb[1]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[1]]
set_property PACKAGE_PIN J1 [get_ports y_out_tb[2]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[2]]
set_property PACKAGE_PIN K1 [get_ports y_out_tb[3]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[3]]
set_property PACKAGE_PIN L3 [get_ports y_out_tb[4]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[4]]
set_property PACKAGE_PIN L2 [get_ports y_out_tb[5]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[5]]
set_property PACKAGE_PIN K3 [get_ports y_out_tb[6]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[6]]
set_property PACKAGE_PIN K2 [get_ports y_out_tb[7]]
set_property IOSTANDARD LVCMOS33 [get_ports y_out_tb[7]]

# Bus de salida done_out_tb[7:0]
# Asignado a los 8 últimos LEDs (led[8] a led[15]).
set_property PACKAGE_PIN K5 [get_ports done_out_tb[0]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[0]]
set_property PACKAGE_PIN P6 [get_ports done_out_tb[1]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[1]]
set_property PACKAGE_PIN R7 [get_ports done_out_tb[2]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[2]]
set_property PACKAGE_PIN R6 [get_ports done_out_tb[3]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[3]]
set_property PACKAGE_PIN T5 [get_ports done_out_tb[4]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[4]]
set_property PACKAGE_PIN R5 [get_ports done_out_tb[5]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[5]]
set_property PACKAGE_PIN T10 [get_ports done_out_tb[6]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[6]]
set_property PACKAGE_PIN T9 [get_ports done_out_tb[7]]
set_property IOSTANDARD LVCMOS33 [get_ports done_out_tb[7]]
