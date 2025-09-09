`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 01:19:59 PM
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
    input wire start_sim_in, //Signal to begin the entire simulation process
    output wire done_out //Final completion signal for the testbench
);

    // Parameter to define the bit width for time registers
    localparam TIME_WIDTH = 8;

    // Intern signals to connect the sub-modules
    wire at_w, q_w, done_s_w, done_c_w;
    wire [TIME_WIDTH-1:0] next_time_c_w, next_time_s_w;
    reg [TIME_WIDTH-1:0] current_time_reg;

    // Synchronous logic for the simulation time
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_time_reg <= 0;
        end else if (done_c_w) begin
            // Advance the simulation time when the coordinator finishes its cycle
            // This is the core of the DEVS time management
            current_time_reg <= next_time_c_w;
        end
    end

    // Instantiation of the 'coordinator' module.
    coordinator CM_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_in(start_sim_in),
        .done_in(done_s_w),
        .current_time_in(current_time_reg), // Nuevo: pasa el tiempo actual
        .next_time_in(next_time_s_w),       // Nuevo: recibe el tiempo del simulator
        .at_out(at_w),
        .q_out(q_w),
        .done_out(done_c_w),
        .next_time_out(next_time_c_w)       // Nuevo: recibe el tiempo del coordinator
    );

    // Instantiation of the 'simulator' (atomic) module
    simulator AM_inst (
        .clk(clk),
        .rst_n(rst_n),
        .at_in(at_w),
        .q_in(q_w),
        .current_time_in(current_time_reg), // Nuevo: pasa el tiempo actual
        .done_out(done_s_w),
        .next_time_out(next_time_s_w)       // Nuevo: recibe el tiempo del simulator
    );
    
    //Assign the top-level output
    assign done_out = done_c_w;

endmodule
