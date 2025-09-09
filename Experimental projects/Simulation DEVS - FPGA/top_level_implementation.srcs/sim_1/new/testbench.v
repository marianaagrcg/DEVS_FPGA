`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:32:10 PM
// Design Name:
// Module Name: my_testbench
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Testbench for the DEVS system
//
// Dependencies: TOP.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module testbench;
    // Parameters using `define
    `define WIDTH_PORT 8
    `define WIDTH_TIME 8
    
    // Signals for top-level module
    reg clk;
    reg rst;
    reg [`WIDTH_PORT-1:0] x_in_tb;
    wire [`WIDTH_PORT-1:0] y_out_tb;
    wire [`WIDTH_TIME-1:0] done_out_tb;
    
    // Instantiate the top-level module
    top_level dut (
        .clk(clk),
        .rst(rst),
        .x_in_tb(x_in_tb),
        .y_out_tb(y_out_tb),
        .done_out_tb(done_out_tb)
    );
    
    // Clock generation (50MHz -> 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test stimulus and waveform dumping
    initial begin
        // Dump all signals to a VCD file for waveform analysis
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
        
        // Monitor key signals in the console
        $monitor("Time=%0t | clk=%0b | rst=%0b | x_in=%0h | y_out=%0h | done=%0d | at=%0d | star=%0d",
                  $time, clk, rst, x_in_tb, y_out_tb, done_out_tb, dut.at_w, dut.star_w);
        
        // --- Simulation sequence ---
        
        $display("-------------------------------------------");
        $display("LOG: Starting Simulation");
        $display("-------------------------------------------");

        // 1. Initial Reset
        $display("LOG: Time %0t | Applying reset...", $time);
        rst = 1;
        x_in_tb = 'd0;
        #20; // Hold reset for one clock cycle
        $display("LOG: Time %0t | Reset released. Starting simulation logic...", $time);
        
        rst = 0;
        #20; // Wait for one cycle to start the simulation process
        $display("LOG: Time %0t | System should now be processing initial state.", $time);
        
        // 2. External event
        $display("LOG: Time %0t | Injecting external event (x_in_tb = 8'hAA).", $time);
        x_in_tb = 8'hAA;
        #40; // Wait for the event to propagate through the system
        
        // 3. Another external event
        $display("LOG: Time %0t | Injecting a new external event (x_in_tb = 8'hBB).", $time);
        x_in_tb = 8'hBB;
        #60; // Wait for propagation
        
        // 4. Clear input and wait for internal transitions
        $display("LOG: Time %0t | Clearing input. Letting the system handle internal transitions.", $time);
        x_in_tb = 'd0;
        #150;
        
        $display("-------------------------------------------");
        $display("LOG: Simulation Finished");
        $display("-------------------------------------------");
        $finish; // End simulation
    end

endmodule