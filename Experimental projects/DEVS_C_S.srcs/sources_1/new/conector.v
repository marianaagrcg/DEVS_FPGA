`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 12:03:22 PM
// Design Name: 
// Module Name: conector
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
    input clk,
    input rst_n,
    output done_out
);

wire at_w, q_w, done_s_w, done_c_w;

// Instancia del Coordinator
coordinator C_inst (
    .clk(clk),
    .rst_n(rst_n),
    .done_in(done_s_w), // Conectado a la salida 'done' del Simulator
    .done_rc(done_c_w), // Se activa en el RC
    .at_out(at_w),
    .q_out(q_w),
    .done_out_rc(done_c_w)
);

// Instancia del Simulator
simulator S_inst (
    .clk(clk),
    .rst_n(rst_n),
    .at_in(at_w),
    .q_in(q_w),
    .done_out(done_s_w)
);

// Lógica de inicio del Root Coordinator (simplificada)
reg start_sequence = 1'b1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        start_sequence <= 1'b0;
    end else begin
        // La simulación empieza una vez, o si lo necesitas, puedes poner
        // una entrada externa para iniciarla.
        if (done_c_w) begin
            start_sequence <= 1'b0;
        end
    end
end
assign done_out = done_c_w; // La salida del Root Coordinator es la que recibe del C

endmodule