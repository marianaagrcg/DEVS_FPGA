`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 12:03:22 PM
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
    input clk,
    input rst_n,
    input done_in,
    input done_rc,
    output reg at_out,
    output reg q_out,
    output reg done_out_rc
);

// Definición de estados
parameter IDLE = 3'b000;
parameter SEND_AT = 3'b001;
parameter WAIT_DONE1 = 3'b010;
parameter SEND_Q = 3'b011;
parameter WAIT_DONE2 = 3'b100;
parameter COMPLETE = 3'b101;
reg [2:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @* begin
    next_state = state;
    at_out = 1'b0;
    q_out = 1'b0;
    done_out_rc = 1'b0;

    case (state)
        IDLE: begin
            if (done_rc) begin // El Root Coordinator inicia la secuencia
                next_state = SEND_AT;
            end
        end
        SEND_AT: begin
            at_out = 1'b1; // Envía @
            next_state = WAIT_DONE1;
        end
        WAIT_DONE1: begin
            if (done_in) begin // Espera la señal 'done' del Simulator
                next_state = SEND_Q;
            end
        end
        SEND_Q: begin
            q_out = 1'b1; // Envía q
            next_state = WAIT_DONE2;
        end
        WAIT_DONE2: begin
            if (done_in) begin
                next_state = COMPLETE;
            end
        end
        COMPLETE: begin
            done_out_rc = 1'b1; // Señaliza al Root Coordinator que ha terminado
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule
