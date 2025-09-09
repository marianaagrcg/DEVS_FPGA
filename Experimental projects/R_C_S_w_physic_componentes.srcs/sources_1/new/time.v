`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 06:19:32 PM
// Design Name: 
// Module Name: time
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


// Módulo para extender un pulso corto a una duración visible
module pulse_stretcher #(
    parameter DURATION = 27'd50000000 // 1 segundo a 50 MHz
) (
    input clk,
    input rst_n,
    input pulse_in, // Pulso de un ciclo que queremos extender
    output reg led_out // Salida extendida para el LED
);

reg [26:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 27'd0;
        led_out <= 1'b0;
    end else begin
        // Si llega un nuevo pulso, reiniciamos el contador y encendemos el LED
        if (pulse_in) begin
            counter <= 27'd0;
            led_out <= 1'b1;
        end 
        // Si el LED está encendido y el contador no ha llegado a su límite
        else if (led_out) begin
            if (counter < DURATION - 1) begin
                counter <= counter + 1;
            end else begin
                // Si el contador llegó a su límite, apagamos el LED
                led_out <= 1'b0;
                counter <= 27'd0;
            end
        end
    end
end

endmodule
