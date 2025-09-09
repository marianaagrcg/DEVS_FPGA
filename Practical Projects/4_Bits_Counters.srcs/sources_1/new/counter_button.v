`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 02:57:29 PM
// Design Name: 
// Module Name: counter_button
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


module contador_binario_7seg (
    input clk,
    input btn,
    output reg [3:0] LED, // salidas del contador
    output reg [7:0] Seven_Seg, // a, b, c, d, e, f, g, dp
    output reg [3:0] digit // para activar un solo dígito
);

    reg [19:0] debounce = 0;
    reg btn_sync_0, btn_sync_1;
    reg last_btn_state = 0;

    // Sincronizador para el botón
    always @(posedge clk) begin
        btn_sync_0 <= btn;
        btn_sync_1 <= btn_sync_0;
    end

    // Contador con detección de flanco de subida
    always @(posedge clk) begin
        debounce <= debounce + 1;

        if (btn_sync_1 && !last_btn_state) begin
            LED <= LED + 1;
        end

        last_btn_state <= btn_sync_1;
    end

    // Activar solo el dígito 0 del display
    always @(*) begin
        digit = 4'b1110; // activa solo el menos significativo (digit[0])
    end

    // Tabla de verdad para display de 7 segmentos (sin punto decimal)
    always @(*) begin
        case (LED)
            4'd0: Seven_Seg = 8'b00000011; // 0
            4'd1: Seven_Seg = 8'b10011111; // 1
            4'd2: Seven_Seg = 8'b00100101; // 2
            4'd3: Seven_Seg = 8'b00001101; // 3
            4'd4: Seven_Seg = 8'b10011001; // 4
            4'd5: Seven_Seg = 8'b01001001; // 5
            4'd6: Seven_Seg = 8'b01000001; // 6
            4'd7: Seven_Seg = 8'b00011111; // 7
            4'd8: Seven_Seg = 8'b00000001; // 8
            4'd9: Seven_Seg = 8'b00001001; // 9
            4'd10: Seven_Seg = 8'b00010001; // A
            4'd11: Seven_Seg = 8'b11000001; // b
            4'd12: Seven_Seg = 8'b01100011; // C
            4'd13: Seven_Seg = 8'b10000101; // d
            4'd14: Seven_Seg = 8'b01100001; // E
            4'd15: Seven_Seg = 8'b01110001; // F
            default: Seven_Seg = 8'b11111111;
        endcase
    end

endmodule

