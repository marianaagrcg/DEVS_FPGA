`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2025 04:56:20 PM
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
    input wire at_in,
    input wire q_in,
    output reg done_out
);
    
    // Parámetros de espera
    localparam WAIT_CYCLES_AT = 2'd2; // 2 ciclos para '@'
    localparam WAIT_CYCLES_Q  = 2'd1; // 1 ciclo para 'q'

    // Estados de la máquina
    localparam IDLE    = 2'b00;
    localparam WAIT_AT = 2'b01;
    localparam WAIT_Q  = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] counter;
    reg next_done_out;
    reg [1:0] next_counter;
    
    // Lógica síncrona
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            counter <= 2'b00;
            done_out <= 1'b0;
        end else begin
            state <= next_state;
            counter <= next_counter;
            done_out <= next_done_out;
        end
    end

    // Lógica combinacional
    always @* begin
        next_state = state;
        next_counter = counter;
        next_done_out = 1'b0; // Valor por defecto

        case (state)
            IDLE: begin
                if (at_in) begin
                    next_state = WAIT_AT;
                    next_counter = 2'b00;
                end else if (q_in) begin
                    next_state = WAIT_Q;
                    next_counter = 2'b00;
                end
            end
            WAIT_AT: begin
                if (counter == WAIT_CYCLES_AT - 1) begin
                    next_done_out = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_counter = counter + 1;
                end
            end
            WAIT_Q: begin
                if (counter == WAIT_CYCLES_Q - 1) begin
                    next_done_out = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_counter = counter + 1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule