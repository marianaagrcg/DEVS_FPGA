`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:31:04 PM
// Design Name:
// Module Name: simulator
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Parallel DEVS Simulator
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


// Define parameters from specification
`define WP 8 // WIDTH_PORT
`define WT 8 // WIDTH_TIME

module simulator (
    // Inputs
    input wire clk,
    input wire rst,
    input wire [`WP-1:0] x_in,
    input wire [`WT-1:0] at_in,   // External transition time (@)
    input wire [`WT-1:0] star_in, // Internal transition time (*)

    // Outputs
    output reg [`WP-1:0] y_out,
    output reg [`WT-1:0] done_out
);
    // Internal registers for DEVS state and time management
    reg [`WT-1:0] tn; // Time of next internal event
    reg [`WT-1:0] tL; // Time of last event

    // FIFO for input events - simulates event storage
    localparam FIFO_DEPTH = 5;
    reg [`WP-1:0] x_fifo [FIFO_DEPTH-1:0];
    reg [2:0] fifo_write_ptr;
    reg [2:0] fifo_read_ptr;
    reg fifo_empty;
    reg fifo_full;
    
    // FSM for internal delay (e.g., for λ and δ functions)
    localparam S_IDLE = 2'b00;
    localparam S_LAMBDA = 2'b01;
    localparam S_DELTA = 2'b10;
    reg [1:0] state;
    reg [1:0] counter;
    
    // Asynchronous reset and synchronous logic for registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tn <= 0;
            tL <= 0;
            y_out <= 0;
            done_out <= 0;
            state <= S_IDLE;
            counter <= 0;
            fifo_write_ptr <= 0;
            fifo_read_ptr <= 0;
            fifo_empty <= 1'b1;
            fifo_full <= 1'b0;
        end else begin
            // State machine to simulate internal delays and handle transitions
            case (state)
                S_IDLE: begin
                    // Priority: External Transition (@) over Internal Transition (*)
                    if (at_in > tL && at_in <= tn) begin
                        state <= S_LAMBDA;
                        counter <= 0;
                        done_out <= 0; // Clear done until transition is complete
                        
                        // FIFO write logic
                        if (!fifo_full) begin
                            x_fifo[fifo_write_ptr] <= x_in;
                            fifo_write_ptr <= fifo_write_ptr + 1;
                            if (fifo_write_ptr == FIFO_DEPTH - 1) begin
                                fifo_full <= 1'b1;
                            end
                            fifo_empty <= 1'b0;
                        end
                    end
                    // Check for internal transition (*)
                    else if (star_in > tL && star_in == tn) begin
                        state <= S_DELTA;
                        counter <= 0;
                        done_out <= 0; // Clear done until transition is complete
                    end
                end
                
                S_LAMBDA: begin
                    if (counter == 2'd1) begin // Simulates 2-cycle delay for lambda
                        // Lógica de salida λ
                        if (!fifo_empty) begin
                            y_out <= x_fifo[fifo_read_ptr];
                            fifo_read_ptr <= fifo_read_ptr + 1;
                            if (fifo_read_ptr == FIFO_DEPTH - 1) begin
                                fifo_empty <= 1'b1;
                            end
                            fifo_full <= 1'b0;
                        end
                        
                        // Actualizar estado y tiempos después de λ
                        tL <= at_in;
                        done_out <= at_in;
                        state <= S_IDLE;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                S_DELTA: begin
                    if (counter == 2'd1) begin // Simulates 2-cycle delay for delta
                        // Lógica de transición δ
                        tL <= star_in;
                        tn <= star_in + 1;
                        done_out <= tn; // Signal completion with the calculated next time
                        state <= S_IDLE;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule