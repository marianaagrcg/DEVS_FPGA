`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:30:54 PM
// Design Name:
// Module Name: SIMULATOR
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Parallel DEVS Simulator with FIFO logic
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected done signal logic
// Revision 0.03 - Added FIFO logic for input port x
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`define WIDTH_PORT 8 // Defines the width of the data port
`define WIDTH_TIME 8 // Defines the width of the time variables
`define FIFO_DEPTH 5 // Defines the depth of the FIFO queue

module simulator (
    input wire [`WIDTH_PORT-1:0] x,    // Input port for external events
    input wire [`WIDTH_TIME-1:0] at,   // Time of the next external event
    input wire [`WIDTH_TIME-1:0] star, // Time of the next internal event
    input wire clk,                    
    input wire rst,                    

    output reg [`WIDTH_PORT-1:0] y,    // Output port for events
    output reg [`WIDTH_TIME-1:0] done  // The "done" signal, indicating an event has finished
);

    // Registers
    reg [`WIDTH_TIME-1:0] tn; // Time of the next transition
    reg [`WIDTH_TIME-1:0] tL; // Time of the last event
    reg [`WIDTH_PORT-1:0] fifo_x [`FIFO_DEPTH-1:0]; // FIFO for storing input events
    reg [2:0] fifo_head;
    reg [2:0] fifo_tail;
    reg fifo_empty;
    reg fifo_full;
    reg [`WIDTH_PORT-1:0] fifo_peek_val; // Value at the head of the FIFO without dequeuing

    // State machine states
    localparam S_IDLE = 2'b00;      // Idle state, waiting for events
    localparam S_EXTERNAL = 2'b01;  // State for handling external transitions (λ)
    localparam S_INTERNAL = 2'b10;  // State for handling internal transitions (δ)
    reg [1:0] state;
    
    // Cycle counter for two-cycle transitions
    reg [1:0] cycle_count;
    
    // Synchronous sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Asynchronous reset to initial state
            tn <= 'd0;
            tL <= 'd0;
            y <= 'd0;
            done <= 'd0;
            state <= S_IDLE;
            cycle_count <= 'd0;
            // FIFO reset
            fifo_head <= 3'b0;
            fifo_tail <= 3'b0;
            fifo_empty <= 1'b1;
            fifo_full <= 1'b0;
            fifo_peek_val <= 'd0;
        end else begin
            
            // Logic to handle the FIFO in the IDLE state
            if (state == S_IDLE) begin
                // Enqueue logic: if there's an input and the FIFO isn't full
                if (x != 'd0 && !fifo_full) begin
                    fifo_x[fifo_tail] <= x;
                    fifo_tail <= fifo_tail + 1;
                    if (fifo_tail + 1 == fifo_head) begin
                        fifo_full <= 1'b1;
                    end
                    fifo_empty <= 1'b0;
                end
            end
            
            // Main state machine logic
            case (state)
                S_IDLE: begin
                    done <= 'd0;
                    // Check for external transition (at time >= current time and FIFO is not empty)
                    if (at >= tn && !fifo_empty) begin
                        state <= S_EXTERNAL;
                        cycle_count <= 'd0; 
                        // Dequeue and "peek" logic for the external transition
                        fifo_peek_val <= fifo_x[fifo_head];
                        fifo_head <= fifo_head + 1;
                        if (fifo_head + 1 == fifo_tail) begin
                            fifo_empty <= 1'b1;
                        end
                        fifo_full <= 1'b0;
                    // Check for internal transition (star time is not the last event time)
                    end else if (star != tL) begin
                        state <= S_INTERNAL;
                        cycle_count <= 'd0; 
                    end
                end

                S_EXTERNAL: begin // Logic for λ (External Transition)
                    if (cycle_count == 1) begin // After 2 complete cycles
                        y <= fifo_peek_val; // Output the value from the FIFO
                        done <= at;          // Set done signal to the current time
                        state <= S_IDLE;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                
                S_INTERNAL: begin // Logic for δ (Internal Transition)
                    if (cycle_count == 1) begin // After 2 complete cycles
                        tL <= star;        // Update last event time
                        tn <= star + 1;    // Update next transition time
                        done <= star;      // Set done signal to the current time
                        state <= S_IDLE;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule