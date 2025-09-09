`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2025 04:26:41 PM
// Design Name: 
// Module Name: root_coordinator_tb
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

module testbench;
    
    reg clk;
    reg rst_n;
    reg start_sim_in;
    wire done_out;
    
    // Variables para las señales internas
    wire at_w;
    wire q_w;
    wire done_s_w;

    root_coordinator RC_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_sim_in(start_sim_in),
        .done_out(done_out)
    );
    
    // Conectar las señales internas para poder monitorearlas
    assign at_w = RC_inst.at_w;
    assign q_w = RC_inst.q_w;
    assign done_s_w = RC_inst.done_s_w;

    always #10 clk = ~clk;

    initial begin
        // Generar un archivo de volcado de datos (dump file)
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        $display("Simulación comenzada a tiempo: %t", $time);

        clk = 1'b0;
        rst_n = 1'b0;

        #20;
        rst_n = 1'b1;

        #20;

        start_sim_in = 1'b1;
        #20;
        start_sim_in = 1'b0;

        #200;
        
        $finish;
    end
endmodule