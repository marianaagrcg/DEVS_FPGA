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
// Description: Top-level module that coordinates the DEVS simulation.
//
// Dependencies: coordinator.v, simulator.v
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected step update logic
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`define WIDTH_TIME 8 // Defines the width of the time variables
`define WIDTH_PORT 8 // Defines the width of the data port

module root_coordinator (
    input wire [`WIDTH_TIME-1:0] done, // The "done" signal from the coordinator
    input wire clk,                    // Clock signal
    input wire rst,                    // Reset signal
    output wire [`WIDTH_TIME-1:0] step // The "step" signal for the coordinator
);

    // Assigns the coordinator's "done" signal to the "step" signal,
    // which allows the time to advance in the simulation.
    assign step = done + 1;
    
endmodule