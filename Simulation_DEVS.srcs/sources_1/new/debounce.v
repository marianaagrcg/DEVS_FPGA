`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 04:22:55 PM
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
    input button_in,
    output button_out
);
    // Parámetros para el debouncer (20ms a 50MHz)
    localparam DEBOUNCE_DELAY_CYCLES = 27'd1000000;
    
    reg [26:0] counter;
    reg button_in_sync;
    reg button_in_sync_d;
    reg button_out_reg;
    
    // Sincronizar la entrada asíncrona
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            button_in_sync <= 1'b0;
            button_in_sync_d <= 1'b0;
        end else begin
            button_in_sync <= button_in;
            button_in_sync_d <= button_in_sync;
        end
    end
    
    // Lógica principal del debouncer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 27'd0;
            button_out_reg <= 1'b0;
        end else begin
            // Detecta un flanco de bajada (botón presionado)
            if (button_in_sync_d == 1'b1 && button_in_sync == 1'b0) begin
                counter <= 27'd0;
            end 
            
            // Cuenta hasta que el botón se ha mantenido estable por 20ms
            if (counter < DEBOUNCE_DELAY_CYCLES && button_in_sync == 1'b0) begin
                counter <= counter + 1;
            end else if (counter == DEBOUNCE_DELAY_CYCLES && button_out_reg == 1'b0) begin
                button_out_reg <= 1'b1;
            end
            
            // Si el botón se suelta, resetea el contador y la salida
            if (button_in_sync == 1'b1 && button_out_reg == 1'b1) begin
                counter <= 27'd0;
                button_out_reg <= 1'b0;
            end
        end
    end
    
    assign button_out = button_out_reg;

endmodule

