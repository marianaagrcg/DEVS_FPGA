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


`define WT 8 // WIDTH_TIME
`define WP 8 // WIDTH_PORT

module root_coordinator (
    // Input
    input wire clk,
    input wire rst,
    input wire [`WP-1:0] x_in_tb,
    output wire [`WT-1:0] step_out // Step signal for the testbench
);
    // Internal signals for module connection
    wire [`WT-1:0] at_w, star_w, done_c_w, done_s_w;
    wire [`WP-1:0] y_w;
    reg [`WT-1:0] next_step_reg;

    // Logic for the next step based on the done signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_step_reg <= 1; // Start the simulation at time 1
        end else begin
            next_step_reg <= next_step_reg + 1;
        end
    end

    // Coordinator instantiation
    coordinator CM_inst (
        .clk(clk),
        .rst(rst),
        .step_in(next_step_reg),
        .done_I_in(done_s_w), // Assuming a single simulator for simplicity
        .at_out(at_w),
        .star_out(star_w),
        .done_O_out(done_c_w)
    );

    // Simulator instantiation
    simulator AM_inst (
        .clk(clk),
        .rst(rst),
        .x_in(x_in_tb),
        .at_in(at_w),
        .star_in(star_w),
        .y_out(y_w),
        .done_out(done_s_w)
    );

    // Assign the top-level output
    assign step_out = next_step_reg;
endmodule
