`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 02:55:12 PM
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
    input clk,
    input rst_n,
    input at_in,
    input q_in,
    output reg done_out
);

// Definición de estados
parameter IDLE = 2'b00;
parameter WAIT_AT = 2'b01;
parameter WAIT_Q = 2'b10;
reg [1:0] state, next_state;
reg [26:0] counter; // Contador de 27 bits para segundos
reg next_done_out;
reg [26:0] next_counter; // Señal del próximo valor del contador

// Definición de los valores de espera en ciclos (para 50 MHz)
localparam WAIT_CYCLES_AT = 27'd100000000; // 2 segundos
localparam WAIT_CYCLES_Q  = 27'd50000000;  // 1 segundo

// Lógica síncrona para actualizar los registros en el flanco de reloj
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 27'd0;
        done_out <= 1'b0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        done_out <= next_done_out;
    end
end

// Lógica combinacional para determinar el próximo estado, la próxima salida, y el próximo valor del contador
always @* begin
    next_state = state;
    next_done_out = 1'b0;
    next_counter = counter;

    case (state)
        IDLE: begin
            if (at_in) begin
                next_state = WAIT_AT;
                next_counter = 27'd0; // Reiniciar contador
            end else if (q_in) begin
                next_state = WAIT_Q;
                next_counter = 27'd0; // Reiniciar contador
            end
        end
        WAIT_AT: begin
            // El pulso 'done' se activa en el último ciclo (WAIT_CYCLES_AT - 1)
            if (counter == WAIT_CYCLES_AT - 1) begin
                next_done_out = 1'b1;
                next_state = IDLE;
            end else begin
                next_counter = counter + 1;
            end
        end
        WAIT_Q: begin
            // El pulso 'done' se activa en el último ciclo (WAIT_CYCLES_Q - 1)
            if (counter == WAIT_CYCLES_Q - 1) begin
                next_done_out = 1'b1;
                next_state = IDLE;
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
