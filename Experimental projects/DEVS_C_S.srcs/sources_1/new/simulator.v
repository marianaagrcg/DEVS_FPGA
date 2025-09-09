`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 12:03:22 PM
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
reg [1:0] counter;
reg next_done_out;
reg [1:0] next_counter; // <-- Nueva señal para la lógica del próximo valor del contador

// Lógica síncrona para actualizar los registros en el flanco de reloj
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        counter <= 2'b00;
        done_out <= 1'b0;
    end else begin
        state <= next_state;
        counter <= next_counter; // <-- Ahora el contador se actualiza con la nueva señal
        done_out <= next_done_out;
    end
end

// Lógica combinacional para determinar el próximo estado, la próxima salida, y el próximo valor del contador
always @* begin
    // Valores por defecto
    next_state = state;
    next_done_out = 1'b0;
    next_counter = counter; // <-- El próximo valor es el actual por defecto

    case (state)
        IDLE: begin
            if (at_in) begin
                next_state = WAIT_AT;
                next_counter = 2'b00; // <-- Asigna el valor inicial aquí
            end else if (q_in) begin
                next_state = WAIT_Q;
                next_counter = 2'b00; // <-- Asigna el valor inicial aquí
            end
        end
        WAIT_AT: begin
            if (counter == 2'b01) begin // En el segundo ciclo de 2
                next_done_out = 1'b1;
            end
            if (counter == 2'b10) begin // Después de 2 ciclos
                next_state = IDLE;
            end else begin
                next_counter = counter + 1; // <-- Incrementa el contador
            end
        end
        WAIT_Q: begin
            if (counter == 2'b00) begin // En el primer ciclo de 1
                next_done_out = 1'b1;
            end
            if (counter == 2'b01) begin // Después de 1 ciclo
                next_state = IDLE;
            end else begin
                next_counter = counter + 1; // <-- Incrementa el contador
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule