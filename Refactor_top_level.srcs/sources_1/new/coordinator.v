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

`define WIDTH_TIME 8 // Defines the width of the time variables

module coordinator (
    //Inputs
    input wire [`WIDTH_TIME-1:0] step,  // Input from the root coordinator
    input wire [`WIDTH_TIME-1:0] done_I, // "done" signal from the simulator
    input wire clk,                     // Clock signal
    input wire rst,                     // Reset signal

    //Outputs
    output reg [`WIDTH_TIME-1:0] at,    // Time for next external event (to simulator)
    output reg [`WIDTH_TIME-1:0] star,  // Time for next internal event (to simulator)
    output reg [`WIDTH_TIME-1:0] done_O // "done" signal to the root coordinator
);

    // Internal registers for "wait" logic
    reg received_done_I;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Asynchronous reset
            at <= 'd0;
            star <= 'd0;
            done_O <= 'd0;
            received_done_I <= 1'b0;
        end else begin
            // Logic for the first wait (for a new `step` value)
            if (step > at) begin
                at <= step;
                received_done_I <= 1'b0; // Reset the flag when a new step is received
            end

            // Logic for the second wait (for the `done_I` signal)
            if (!received_done_I && done_I != 'd0) begin
                received_done_I <= 1'b1;
            end
            // Logic for "all done_I signals have arrived"
            // (assuming `done_I` is a single input)
            if (received_done_I) begin
                 star <= done_I;
                 // `done_O` is updated with the minimum of all `done_I`s.
                 // For a single simulator, `done_O` is simply `done_I`.
                 done_O <= done_I;
            end
        end
    end
endmodule