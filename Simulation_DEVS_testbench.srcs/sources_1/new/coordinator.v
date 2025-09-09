`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2025 04:56:42 PM
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
    input wire start_in,
    input wire done_in,
    output reg at_out,
    output reg q_out,
    output reg done_out
);

    // Estados de la máquina
    localparam IDLE       = 3'b000;
    localparam SEND_AT    = 3'b001;
    localparam WAIT_DONE1 = 3'b010;
    localparam SEND_Q     = 3'b011;
    localparam WAIT_DONE2 = 3'b100;
    localparam COMPLETE   = 3'b101;
    
    reg [2:0] state, next_state;
    
    // Lógica síncrona
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Lógica combinacional
    always @* begin
        next_state = state;
        at_out = 1'b0;
        q_out = 1'b0;
        done_out = 1'b0;
        
        case (state)
            IDLE: begin
                if (start_in) begin
                    next_state = SEND_AT;
                end
            end
            SEND_AT: begin
                at_out = 1'b1;
                next_state = WAIT_DONE1;
            end
            WAIT_DONE1: begin
                if (done_in) begin
                    next_state = SEND_Q;
                end
            end
            SEND_Q: begin
                q_out = 1'b1;
                next_state = WAIT_DONE2;
            end
            WAIT_DONE2: begin
                if (done_in) begin
                    next_state = COMPLETE;
                end
            end
            COMPLETE: begin
                done_out = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule