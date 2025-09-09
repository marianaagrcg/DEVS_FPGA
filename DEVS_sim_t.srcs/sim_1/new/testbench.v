`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 01:24:43 PM
// Design Name: 
// Module Name: testbench
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

    // Clock frequency parameter: 50 MHz -> 20 ns period
    parameter CLK_PERIOD = 20;

    // Signals to connect to the top-level design
    reg clk;
    reg rst_n;
    reg start_sim_in;
    wire done_out;

    // Internal wires for monitoring signals inside the UUT (Unit Under Test)
    wire at_w, q_w, done_s_w, done_c_w;
    wire [7:0] next_time_s_w, next_time_c_w;
    reg [7:0] current_time_mon;
    
    // Instantiate the top-level design module (Unit Under Test)
    root_coordinator UUT (
        .clk(clk),
        .rst_n(rst_n),
        .start_sim_in(start_sim_in),
        .done_out(done_out)
    );

    // Connections to monitor internal signals of the UUT for debugging
    assign at_w = UUT.CM_inst.at_out;
    assign q_w = UUT.CM_inst.q_out;
    assign done_s_w = UUT.AM_inst.done_out;
    assign done_c_w = UUT.CM_inst.done_out;
    assign next_time_s_w = UUT.AM_inst.next_time_out;
    assign next_time_c_w = UUT.CM_inst.next_time_out;
    
    // Monitor the current time register 
    always @(posedge clk) begin
      current_time_mon <= UUT.current_time_reg;
    end

    // Clock generator
    always begin
        clk = 1'b0;
        #(CLK_PERIOD / 2);
        clk = 1'b1;
        #(CLK_PERIOD / 2);
    end

    // Stimulus logic (reset and simulation start)
    initial begin
        // 1. Initialize all signals
        clk = 1'b0;
        rst_n = 1'b0; // Active-low reset
        start_sim_in = 1'b0;

       // 2. Hold reset for 100ns (5 clock cycles)
        #40;
        rst_n = 1'b1; // Release reset

        // 3. Start the first simulation cycle
        @(posedge clk);
        start_sim_in = 1'b1;

        // 4. Wait for the cycle to complete and then de-assert start
        @(posedge done_out); // Wait for the 'done' signal to go high
        start_sim_in = 1'b0;

        // 5. Wait for a couple of cycles and start a new simulation cycle
        #40; // Wait 40ns (2 cycles)
        start_sim_in = 1'b1;
        @(posedge done_out); // Wait for the second cycle to complete
        start_sim_in = 1'b0;
        
        // Wait one extra cycle to allow the time register to update
        @(posedge clk); 
        
        // 6. Display final simulation results to the console
        $display("-------------------------------------------");
        $display("Complete Simulation.");
        $display("The final value of 'done_out' is: %b", done_out);
        $display("The final value of time is: %d", UUT.current_time_reg);
        $display("-------------------------------------------");

        // 7. End the simulation
        #100;
        $finish;
    end
    
    // Optional: Monitor and display the state of key signals in the console
    initial begin
        $monitor("Tiempo=%0t: clk=%b, rst_n=%b, start=%b, @=%b, q=%b, done_sim=%b, done_coord=%b, S.next_time=%d, C.next_time=%d",
            $time, clk, rst_n, start_sim_in, at_w, q_w, done_s_w, done_c_w, next_time_s_w, next_time_c_w);
    end

endmodule