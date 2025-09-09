`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:31:21 PM
// Design Name:
// Module Name: coordinator
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Parallel DEVS Coordinator
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`define WT 8 // WIDTH_TIME

module coordinator (
    //Inputs
    input wire clk,
    input wire rst,
    input wire [`WT-1:0] step_in, // Global step time
    input wire [`WT-1:0] done_I_in, // Done signal from the simulator

    //Outputs
    output reg [`WT-1:0] at_out,  // External transition time to simulator
    output reg [`WT-1:0] star_out, // Internal transition time to simulator
    output reg [`WT-1:0] done_O_out
);

    // Internal state machine to manage the simulation cycle
    localparam IDLE      = 2'b00;
    localparam SEND_AT   = 2'b01;
    localparam WAIT_AT   = 2'b10;
    localparam SEND_STAR = 2'b11;
    reg [1:0] state;

    // Internal registers for synchronization and min calculation
    reg [`WT-1:0] min_done;
    reg [`WT-1:0] last_step; // To detect a new step from root_coordinator

    // State and synchronization logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            at_out <= 0;
            star_out <= 0;
            done_O_out <= 0;
            min_done <= -1; // Initialize with max value
            last_step <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (step_in != last_step) begin // New step from root_coordinator
                        at_out <= step_in;
                        star_out <= 0;
                        state <= SEND_AT;
                        last_step <= step_in;
                    end
                end
                SEND_AT: begin
                    // Wait for done_I from child
                    if (done_I_in == step_in) begin
                        min_done <= done_I_in;
                        state <= WAIT_AT;
                        at_out <= 0; // Clear the signal
                    end
                end
                WAIT_AT: begin
                    star_out <= step_in;
                    state <= SEND_STAR;
                end
                SEND_STAR: begin
                    // Wait for done_I from child
                    if (done_I_in == step_in) begin
                        min_done <= done_I_in;
                        done_O_out <= min_done;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
