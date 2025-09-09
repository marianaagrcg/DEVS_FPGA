`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 04:38:05 PM
// Design Name: 
// Module Name: root_coordinatorr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: / 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module root_coordinator (
//    input wire clk,
//    input wire reset,
//    input wire [31:0] done_o,
//    output wire start_sim
//);

//    reg start_sim_reg;

//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            start_sim_reg <= 1'b0;
//        end else if (done_o == 32'hDEADBEEF) begin
//            // La simulación terminó
//            start_sim_reg <= 1'b0;
//        end else begin
//            // Inicia la simulación si no se ha iniciado
//            start_sim_reg <= 1'b1;
//        end
//    end
    
    assign start_sim = start_sim_reg;

endmodule