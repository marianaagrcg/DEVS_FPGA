`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 01:19:43 PM
// Design Name: 
// Module Name: coordinator
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


module coordinator (
    input wire clk,
    input wire rst_n,
    input wire start_in, //Signal to start a new simulation cycle
    input wire done_in,
    input wire [7:0] current_time_in, 
    input wire [7:0] next_time_in,
    output reg at_out, //Ex. transition output to the simulator
    output reg q_out, //Int. transition output to the simulator
    output reg done_out,
    output reg [7:0] next_time_out
);

    //SM definition for the coordinator's sequential behavior
    localparam IDLE           = 3'b000;
    localparam SEND_AT        = 3'b001;
    localparam WAIT_DONE1     = 3'b010;
    localparam SEND_Q         = 3'b011;
    localparam WAIT_DONE2     = 3'b100;
    localparam COMPLETE       = 3'b101;
    localparam SEND_CONFLUENT = 3'b110; 

    reg [2:0] state, next_state;

    // Sequential logic (state register)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic (next state and outputs)
    always @* begin
        // Default assignments
        next_state = state;
        at_out = 1'b0;
        q_out = 1'b0;
        done_out = 1'b0;
        next_time_out = current_time_in;

        case (state)
            IDLE: begin
                if (start_in) begin
                    // Force a confluent transition in the second cycle (when current_time_in is 1)
                    if (current_time_in == 8'd1) begin
                        next_state = SEND_CONFLUENT;
                    end else begin
                        next_state = SEND_AT;
                    end
                end
            end
            
            SEND_CONFLUENT: begin
                // Assert both 'at' and 'q' simultaneously to simulate a confluent event
                at_out = 1'b1;
                q_out = 1'b1; 
                next_state = WAIT_DONE1;
            end
            
            SEND_AT: begin
            //Assert at 'at' event
                at_out = 1'b1;
                next_state = WAIT_DONE1;
            end
            WAIT_DONE1: begin
                // Wait for the simulators's 'done' signal
                if (done_in) begin
                    // If it was a confluent transition, the cycle is complete
                    if (current_time_in == 8'd1) begin
                        next_state = COMPLETE;
                    end else begin
                        //Otherwise, proceed to the next sequential event 'q'
                        next_state = SEND_Q;
                    end
                end
            end
            SEND_Q: begin
                //Asser 'q' event
                q_out = 1'b1;
                next_state = WAIT_DONE2;
            end
            WAIT_DONE2: begin
                //Wait for the second 'done' signal (for the 'q' event)
                if (done_in) begin
                    next_state = COMPLETE;
                end
            end
            COMPLETE: begin
                //Signal completion to the root coordinator and pass the next time
                done_out = 1'b1;
                next_time_out = next_time_in;
                //Return to IDLE state to prepare for the next simulation cycle
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule