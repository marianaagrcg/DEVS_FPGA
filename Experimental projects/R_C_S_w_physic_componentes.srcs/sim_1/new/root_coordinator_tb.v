`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 01:06:17 PM
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

`timescale 1ns / 1ps

module root_coordinator_tb;

    // Declaración de señales para conectar al DUT (Design Under Test)
    reg clk;
    reg rst_n_in;
    reg start_btn_in;
    wire done_out_led;
    wire at_led;
    wire q_led;
    wire done_s_led;

    // Instancia del módulo principal (Root Coordinator)
    root_coordinator UUT (
        .clk(clk),
        .rst_n_in(rst_n_in),
        .start_btn_in(start_btn_in),
        .done_out_led(done_out_led),
        .at_led(at_led),
        .q_led(q_led),
        .done_s_led(done_s_led)
    );
    
    //----------------------------------------------------------------------
    // NOTE: El código del módulo root_coordinator ha sido añadido aquí
    //       para asegurar que el simulador pueda encontrar su definición.
    //----------------------------------------------------------------------
    /*
    module root_coordinator (
      input clk, 
      input rst_n_in,
      input start_btn_in,
      output done_out_led,
      output at_led,
      output q_led,
      output done_s_led
    );

    // Parámetros y señales internas
    localparam AT_DELAY = 2_000_000_000; // 2 segundos
    localparam Q_DELAY = 1_000_000_000;  // 1 segundo
    localparam DONE_S_DELAY = 20_000_000; // 200 ms
    localparam DEBOUNCE_DELAY = 20_000_000; // 20 ms

    wire start_btn_debounced;
    wire start_btn_pulse;

    // Instancias de módulos
    debounce u_debounce (
        .clk(clk),
        .rst_n_in(rst_n_in),
        .btn_in(start_btn_in),
        .debounced_out(start_btn_debounced)
    );

    pulse_stretcher u_pulse_stretcher (
        .clk(clk),
        .rst_n_in(rst_n_in),
        .trigger_in(start_btn_debounced),
        .pulse_out(start_btn_pulse)
    );
    
    // Módulo principal del simulador
    simulator u_simulator (
        .clk(clk),
        .rst_n_in(rst_n_in),
        .start_in(start_btn_pulse),
        .done_out(done_out_led),
        .at_out(at_led),
        .q_out(q_led),
        .done_s_out(done_s_led)
    );

    endmodule
    */

    // Generación del reloj (50 MHz, período de 20 ns)
    always #10 clk = ~clk; // Alterna el reloj cada 10ns para un período de 20ns (50MHz)

    // Generación de estímulos de entrada
    initial begin
        // Inicialización de señales
        clk = 1'b0;
        rst_n_in = 1'b0; // Activa reset al inicio
        start_btn_in = 1'b1; // Botón de inicio en estado no presionado (pull-up)

        // Aplicar reset por un corto tiempo
        #100; // Espera 100 ns
        rst_n_in = 1'b1; // Desactiva reset

        // Esperar un tiempo para que el sistema se estabilice en IDLE
        #200;

        // Simular una pulsación del botón de inicio
        // El debouncer necesita 20ms para limpiar la señal
        // Entonces, mantendremos el botón presionado por un poco más de 20ms
        start_btn_in = 1'b0; // Presionar el botón
        #30_000_000; // Mantener presionado por 30 ms (30,000,000 ns)
        start_btn_in = 1'b1; // Soltar el botón

        // Esperar un tiempo suficiente para observar toda la secuencia de LEDs
        // La secuencia completa dura 2 segundos + 1 segundo = 3 segundos
        // Más el tiempo de los extensores de pulso
        // Dividimos el retardo total en partes que quepan en un entero de 32 bits
        #2_000_000_000; // Espera 2 segundos
        #2_000_000_000; // Espera otros 2 segundos (total 4 segundos de simulación después de la pulsación)

        $finish; // Terminar la simulación
    end

endmodule
