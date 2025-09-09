`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2025 05:50:39 PM
// Design Name: 
// Module Name: devs_system_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define WP 8 // WIDTH_PORT
`define WT 8 // WIDTH_TIME

module devs_system_top (
    // Entradas del Testbench
    input wire clk,
    input wire rst,
    input wire [`WP-1:0] x_in_tb,
    
    // Salidas para el Testbench (para depuración)
    output wire [`WT-1:0] step_out // Señal de paso del sistema
);
    // Declaración de las señales internas
    // Estas señales se usan para conectar el módulo root_coordinator
    wire [`WT-1:0] step_out_w;

    // Instanciación del módulo root_coordinator
    root_coordinator root_coordinator_inst (
        .clk(clk),
        .rst(rst),
        .x_in_tb(x_in_tb),
        .step_out(step_out_w)
    );
    
    // Asignación de la salida del módulo instanciado a la salida del módulo top-level
    assign step_out = step_out_w;

endmodule
