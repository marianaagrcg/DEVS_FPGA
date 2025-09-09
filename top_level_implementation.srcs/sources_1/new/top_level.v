`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:32:10 PM
// Design Name:
// Module Name: TOP
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Top-level module for the DEVS system, connecting all sub-modules.
//
// Dependencies: root_coordinator.v, coordinator.v, simulator.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module top_level (
    // Inputs from Testbench
    input wire clk,
    input wire rst,
    input wire [`WIDTH_PORT-1:0] x_in_tb,
    
    // Outputs to Testbench
    output wire [`WIDTH_PORT-1:0] y_out_tb,
    output wire [`WIDTH_TIME-1:0] done_out_tb
);

    // Wires for internal connections
    wire [`WIDTH_TIME-1:0] at_w, star_w;
    wire [`WIDTH_TIME-1:0] step_w;
    wire [`WIDTH_TIME-1:0] done_simulator_w;
    wire [`WIDTH_TIME-1:0] done_coordinator_w;

    // Instantiate sub-modules
    root_coordinator dut_root_coord (
        .done(done_coordinator_w),
        .clk(clk),
        .rst(rst),
        .step(step_w)
    );

    coordinator dut_coord (
        .step(step_w),
        .done_I(done_simulator_w),
        .clk(clk),
        .rst(rst),
        .at(at_w),
        .star(star_w),
        .done_O(done_coordinator_w)
    );

    simulator dut_sim (
        .x(x_in_tb),
        .at(at_w),
        .star(star_w),
        .clk(clk),
        .rst(rst),
        .y(y_out_tb),
        .done(done_simulator_w)
    );

    // Connect outputs to testbench
    assign done_out_tb = done_simulator_w;

endmodule
