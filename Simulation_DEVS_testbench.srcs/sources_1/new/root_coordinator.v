`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2025 04:57:04 PM
// Design Name: 
// Module Name: root_coordinator
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


module root_coordinator (
    input wire clk,
    input wire rst_n,
    input wire start_sim_in,
    output wire done_out
);
    
    // Cables de conexión
    wire at_w, q_w, done_s_w, done_c_w;

    // Instancia del Coordinator
    coordinator CM_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_in(start_sim_in),
        .done_in(done_s_w),
        .at_out(at_w),
        .q_out(q_w),
        .done_out(done_c_w)
    );

    // Instancia del Simulator
    simulator AM_inst (
        .clk(clk),
        .rst_n(rst_n),
        .at_in(at_w),
        .q_in(q_w),
        .done_out(done_s_w)
    );
    
    assign done_out = done_c_w;

endmodule
