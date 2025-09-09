`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 02:54:21 PM
// Design Name: 
// Module Name: debounce
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

module debounce (
    input clk,
    input rst_n,
    input button_in, // Entrada del botón sin debouncing
    output reg button_out // Salida del botón con debouncing (pulso limpio)
);

// Parámetros para el tiempo de debouncing
// Para un reloj de 50 MHz, 20 ms (milisegundos) son 1,000,000 ciclos.
// Puedes ajustar este valor si necesitas un tiempo de debouncing diferente.
localparam DEBOUNCE_TIME_CYCLES = 20'd1000000; // 20 ms @ 50 MHz

reg [19:0] counter; // Contador para el tiempo de debouncing
reg button_sync1, button_sync2; // Registros para sincronizar la entrada asíncrona
reg button_state; // Estado actual del botón debounced

// Sincronización de la entrada asíncrona del botón
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        button_sync1 <= 1'b1;
        button_sync2 <= 1'b1;
    end else begin
        button_sync1 <= button_in;
        button_sync2 <= button_sync1;
    end
end

// Lógica de debouncing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 20'd0;
        button_state <= 1'b1;
        button_out <= 1'b0;
    end else begin
        if (button_sync2 != button_state) begin // Si hay un cambio potencial
            counter <= counter + 1; // Incrementa el contador
            if (counter == DEBOUNCE_TIME_CYCLES - 1) begin // Si el tiempo de debouncing ha pasado
                button_state <= button_sync2; // Actualiza el estado debounced
                counter <= 20'd0; // Reinicia el contador
            end
        end else begin // No hay cambio o el estado ya es estable
            counter <= 20'd0; // Reinicia el contador
        end
        
        // Genera un pulso de un ciclo cuando el botón pasa de 0 a 1 (presionado)
        // O simplemente mantiene el estado debounced, según lo que necesites.
        // Para este caso, queremos un pulso para iniciar la secuencia.
        // Si quieres que button_out sea el estado sostenido del botón, usa:
        // button_out <= button_state;
        
        // Para un pulso de un ciclo cuando se presiona:
        if (button_state == 1'b1 && button_sync2 == 1'b0 && counter == DEBOUNCE_TIME_CYCLES - 1) begin
            button_out <= 1'b1; // Activa el pulso
        end else begin
            button_out <= 1'b0; // Desactiva el pulso en el siguiente ciclo
        end
    end
end

endmodule