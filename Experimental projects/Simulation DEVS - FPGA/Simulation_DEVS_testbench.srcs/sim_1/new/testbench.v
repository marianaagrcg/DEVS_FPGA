`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 08/15/2025 04:32:59 PM
// Design Name: 
// Module Name: tb_root_coordinator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for root_coordinator
//
// Dependencies: root_coordinator.v, coordinator.v, simulator.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_root_coordinator;

    // Parámetros
    localparam CLK_PERIOD = 20; // 20 ns (50 MHz)

    // Señales de testbench
    reg clk;
    reg rst_n;
    reg start_sim_in;
    wire done_out;

    // Instancia del módulo a probar
    root_coordinator DUT (
        .clk(clk),
        .rst_n(rst_n),
        .start_sim_in(start_sim_in),
        .done_out(done_out)
    );
    
    // Conexión para ver las señales internas
    wire at_w;
    wire q_w;
    wire done_s_w;;
    assign at_w = DUT.at_w;
    assign q_w = DUT.q_w;
    assign done_s_w = DUT.done_s_w;

    // Generación del reloj
    always begin
        #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Secuencia de estímulos
    initial begin
        // 1. Inicializar señales
        clk = 1'b0;
        rst_n = 1'b0;
        start_sim_in = 1'b0;

        // 2. Aplicar reset
        #10 rst_n = 1'b1;

        // 3. Esperar a que el sistema se estabilice
        #20;

        // 4. Iniciar la simulación (se activa start_sim_in por 1 ciclo)
        start_sim_in = 1'b1;
        #10 start_sim_in = 1'b0;

        // 5. Esperar la señal de finalización
        @(posedge done_out);
        $display("Simulación completada en el tiempo %0t", $time);

        // 6. Terminar la simulación
        #200;
        $finish;
    end
    
    // Opcional: monitorear señales para depuración
    initial begin
        $monitor("Time=%0t | clk=%b, rst_n=%b, start_sim_in=%b, at_w=%b, q_w=%b, done_out=%b",
            $time, clk, rst_n, start_sim_in, at_w, q_w, done_out);
    end

endmodule