`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:31:21 PM
// Design Name:
// Module Name: coordinator
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Parallel DEVS Coordinator
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`define WIDTH_TIME 8

module coordinator (
    //Inputs
    input wire [`WIDTH_TIME-1:0] step,
    input wire [`WIDTH_TIME-1:0] done_I,

    input wire clk,
    input wire rst,

    //Outputs
    output reg [`WIDTH_TIME-1:0] at,
    output reg [`WIDTH_TIME-1:0] star,
    output reg [`WIDTH_TIME-1:0] done_O
);

    // Registros internos para la lógica de "espera"
    reg received_done_I;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            at <= 'd0;
            star <= 'd0;
            done_O <= 'd0;
            received_done_I <= 1'b0;
        end else begin
            // Lógica para el primer wait
            if (step > at) begin
                at <= step;
                received_done_I <= 1'b0; // Resetea el flag al recibir un nuevo step
            end

            // Lógica para el segundo wait
            if (!received_done_I && done_I != 'd0) begin
                received_done_I <= 1'b1;
            end
            
            // Lógica de "todos los done_I han llegado"
            // Suponiendo que 'done_I' es una única entrada
            if (received_done_I) begin
                 star <= done_I;
                 // Asume que done_O se actualiza con el mínimo de los done_I.
                 // Para un solo simulador, done_O = done_I
                 done_O <= done_I;
            end
        end
    end
endmodule
