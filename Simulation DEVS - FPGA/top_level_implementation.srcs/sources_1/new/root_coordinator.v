`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:31:54 PM
// Design Name:
// Module Name: root_coordinator
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Módulo principal que coordina la simulación DEVS.
//
// Dependencies: coordinator.v, simulator.v
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected step update logic
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


`define WIDTH_TIME 8
`define WIDTH_PORT 8

module root_coordinator (
    input wire [`WIDTH_TIME-1:0] done,
    input wire clk,
    input wire rst,
    output wire [`WIDTH_TIME-1:0] step
);
    // Asigna el done del coordinador al step, lo que permite el avance del tiempo.
    assign step = done + 1;
endmodule


