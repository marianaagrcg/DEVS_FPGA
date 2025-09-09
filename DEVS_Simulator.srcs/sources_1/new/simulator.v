`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 12:55:35 PM
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


module devs_switch_led_counter (
    input wire clk,
    input wire rst,

    input wire sw_q,      // evento tipo q
    input wire sw_at,     // evento tipo @

    output reg led        // se activa cuando se cumple el retardo
);

    reg [31:0] counter;   // contador de ciclos
    reg [31:0] target;    // cuántos ciclos esperar
    reg waiting;          // si estamos esperando entregar evento

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            target <= 0;
            waiting <= 0;
            led <= 0;
        end else begin
            led <= 0;  // por defecto, LED apagado

            // Si no estamos esperando, revisamos si llegó un evento
            if (!waiting) begin
                if (sw_q) begin
                    target <= 1;       // 1 ciclo para q
                    counter <= 0;
                    waiting <= 1;
                end else if (sw_at) begin
                    target <= 2;       // 2 ciclos para @
                    counter <= 0;
                    waiting <= 1;
                end
            end else begin
                counter <= counter + 1;
                if (counter == target - 1) begin
                    led <= 1;         // encender LED cuando se cumpla el tiempo
                    waiting <= 0;     // listo para recibir otro evento
                end
            end
        end
    end

endmodule

