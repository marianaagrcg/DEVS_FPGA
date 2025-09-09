`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 02:54:50 PM
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
    input clk,
    input rst_n_in,      // Entrada de reset físico (activo bajo)
    input start_btn_in,  // Entrada de botón físico para iniciar la simulación
    output done_out_led, // LED para indicar que la simulación completa ha terminado
    output at_led,       // LED para visualizar la señal '@'
    output q_led,        // LED para visualizar la señal 'q'
    output done_s_led    // LED para visualizar la señal 'done' del Simulator
);

// Cables internos para conectar los módulos
wire at_w, q_w, done_s_w, done_c_w;
wire start_btn_debounced; // Salida del debouncer para el botón de inicio
wire rst_n_debounced; // Salida del debouncer para el reset (si usas un botón para reset)

wire system_rst_n = rst_n_in;
wire at_led_stretcher, q_led_stretcher, done_s_led_stretcher, done_c_led_stretcher;

// Instancia del Debouncer para el botón de inicio
debounce start_btn_debouncer_inst (
    .clk(clk),
    .rst_n(system_rst_n), // El debouncer también se resetea
    .button_in(start_btn_in),
    .button_out(start_btn_debounced)
);

// Lógica para el reset (si rst_n_in es un botón, también podrías debouncarlo)
// Por simplicidad, asumimos que rst_n_in es una señal limpia o ya debounced.
// Si rst_n_in es un botón, deberías instanciar otro debouncer aquí.
//wire system_rst_n = rst_n_in; // Usamos la entrada de reset directamente

// Instancia del Coordinator
coordinator C_inst (
    .clk(clk),
    .rst_n(system_rst_n),
    .done_in(done_s_w),         // Conectado a la salida 'done' del Simulator
    .start_coord_in(start_btn_debounced), // <-- Conectado al botón debounced
    .at_out(at_w),
    .q_out(q_w),
    .done_out_rc(done_c_w)
);

// Instancia del Simulator
simulator S_inst (
    .clk(clk),
    .rst_n(system_rst_n),
    .at_in(at_w),
    .q_in(q_w),
    .done_out(done_s_w)
);


// *** Instancias de los extensores de pulso para cada LED ***
// Puedes ajustar el tiempo para cada uno según lo que necesites
pulse_stretcher #( .DURATION(27'd50000000) ) at_stretcher_inst ( // 200 ms
    .clk(clk),
    .rst_n(system_rst_n),
    .pulse_in(at_w),
    .led_out(at_led_stretcher)
);

pulse_stretcher #( .DURATION(27'd50000000) ) q_stretcher_inst ( // 200 ms
    .clk(clk),
    .rst_n(system_rst_n),
    .pulse_in(q_w),
    .led_out(q_led_stretcher)
);

pulse_stretcher #( .DURATION(27'd50000000) ) done_s_stretcher_inst ( // 1 segundo
    .clk(clk),
    .rst_n(system_rst_n),
    .pulse_in(done_s_w),
    .led_out(done_s_led_stretcher)
);

pulse_stretcher #( .DURATION(27'd50000000) ) done_c_stretcher_inst ( // 1 segundo
    .clk(clk),
    .rst_n(system_rst_n),
    .pulse_in(done_c_w),
    .led_out(done_c_led_stretcher)
);


// Conexiones a los LEDs de salida, usando las salidas de los extensores
assign done_out_led = done_c_led_stretcher; // LED para la finalización de la secuencia completa
assign at_led       = at_led_stretcher;      // LED para la señal '@'
assign q_led        = q_led_stretcher;       // LED para la señal 'q'
assign done_s_led   = done_s_led_stretcher;  // LED para la señal 'done' del Simulator

endmodule