`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 01:19:31 PM
// Design Name: 
// Module Name: simulator
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


module simulator (
    input wire clk,
    input wire rst_n,
    input wire at_in, //External transition input event from coordinator 
    input wire q_in, //Internal transition input event from coordinator
    input wire [7:0] current_time_in,       
    output reg done_out, // Output signal to indicate the simulation cycle is complete
    output reg [7:0] next_time_out     
);
    
    //Internal parameters
    //This is the ta(s) function from the DEVS formalism
    localparam WAIT_CYCLES_AT = 2'd2; // 2 cycles for '@'
    localparam WAIT_CYCLES_Q  = 2'd1; // 1 cycles for 'q'
    localparam WAIT_CYCLES_CONFLUENT = WAIT_CYCLES_AT + WAIT_CYCLES_Q; // 3 cycles for a confluente transition '@' y 'q'

    //SM definition for the simulator's internal behavior
    localparam IDLE          = 2'b00;
    localparam WAIT_AT       = 2'b01;
    localparam WAIT_Q        = 2'b10;
    localparam WAIT_CONFLUENT= 2'b11;

    //Registers for state and counter
    reg [1:0] state, next_state;
    reg [1:0] counter, next_counter;
    
    // Register to store the calculated next time
    reg [7:0] next_counter_time;

    // Sequential logic (state and counter registers)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: initialize all registers
            state <= IDLE;
            counter <= 2'b00;
            done_out <= 1'b0;
            next_time_out <= 0;
        end else begin
            //Update state and counter on clock edge
            state <= next_state;
            counter <= next_counter;
            // The done_out signal is asserted for one cycle when the state
            // transitions back to IDLE. This is a handshake mechanism.
            done_out <= (next_state == IDLE) && (state != IDLE);
            //Update next_time-out only when returning to IDLE state
            if (next_state == IDLE) begin
                next_time_out <= next_counter_time;
            end
        end
    end
    
    // Combinational logic (next state and next counter)
    always @* begin
    //Default assignments to prevent latches
        next_state = state;
        next_counter = counter;
        next_counter_time = next_time_out;

        case (state)
            IDLE: begin
                //Trasition based on input events 
                if (at_in && q_in) begin
                    //Confluent transition 
                    next_state = WAIT_CONFLUENT;
                    next_counter = 2'b00;
                end else if (at_in) begin
                    //External transition @
                    next_state = WAIT_AT;
                    next_counter = 2'b00;
                end else if (q_in) begin
                    //External transition q
                    next_state = WAIT_Q;
                    next_counter = 2'b00;
                end
            end
            WAIT_AT: begin
                // Wait for the required number of cycles for 'at'
                if (counter == WAIT_CYCLES_AT - 1) begin
                    next_state = IDLE;
                    // Calculate the new time for the next simulation cycle
                    next_counter_time = current_time_in + 1;
                end else begin
                    next_counter = counter + 1;
                end
            end
            WAIT_Q: begin
                //Wait dor the required number of cycles for 'q'
                if (counter == WAIT_CYCLES_Q - 1) begin
                    next_state = IDLE;
                    next_counter_time = current_time_in + 1;
                end else begin
                    next_counter = counter + 1;
                end
            end
            WAIT_CONFLUENT: begin 
                //Wait for the required number of cycles for the confluent transition
                if (counter == WAIT_CYCLES_CONFLUENT - 1) begin
                    next_state = IDLE;
                    next_counter_time = current_time_in + 1;
                end else begin
                    next_counter = counter + 1;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
