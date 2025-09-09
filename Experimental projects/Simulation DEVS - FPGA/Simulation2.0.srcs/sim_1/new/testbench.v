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
// Dependencies: root_coordinator.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

 // Parameters using `define
`define WP 8
`define WT 8

module my_testbench; 
    // Signals
    reg clk;
    reg rst;
    reg [`WP-1:0] x_in_tb;
    wire [`WT-1:0] step_out;
    
    // Instantiate the top-level module
    root_coordinator dut (
        .clk(clk),
        .rst(rst),
        .x_in_tb(x_in_tb),
        .step_out(step_out)
    );
    
    // Clock generation (50MHz -> 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test stimulus and waveform dumping
    initial begin
        // Dump all signals to a VCD file for waveform analysis
        $dumpfile("my_devs_simulation.vcd");
        $dumpvars(0, my_testbench);
        
        // Monitor key signals in the console
        $monitor("Time=%0t | clk=%0b | rst=%0b | x_in_tb=%0h | root_step_out=%0d | coordinator_at=%0d | coordinator_star=%0d | simulator_done=%0d | simulator_y_out=%0h",
                  $time, clk, rst, x_in_tb, dut.step_out, dut.CM_inst.at_out, dut.CM_inst.star_out, dut.AM_inst.done_out, dut.AM_inst.y_out);
        
        // --- Simulation sequence ---
        
        $display("-------------------------------------------");
        $display("LOG: Starting Simulation");
        $display("-------------------------------------------");

        // 1. Initial Reset
        $display("LOG: Time %0t | Applying reset...", $time);
        rst = 1;
        x_in_tb = 0;
        #20; // Hold reset for one clock cycle
        $display("LOG: Time %0t | Reset released. Starting simulation logic...", $time);
        
        rst = 0;
        #20; // Start simulation. root_coordinator will set step_out to 1
        $display("LOG: Time %0t | Coordinator sends first 'at' signal. `at_out` should be 1.", $time);
        
        // 2. External event at time 3 (t=60ns). root_coordinator sends step=1, then receives done from coordinator
        // The coordinator will send at=1 to the simulator
        $display("LOG: Time %0t | External event (x_in_tb = 8'hAA) arrives.", $time);
        x_in_tb = 8'hAA;
        #40; // Wait for the event to propagate. This is where the done signal will come back
        $display("LOG: Time %0t | Waiting for the 'done' signal from the simulator.", $time);
        
        // 3. Another external event at a later time
        // Let's force a new event at a new time step
        // root_coordinator will get the done signal and update its step, then the cycle repeats
        $display("LOG: Time %0t | New external event (x_in_tb = 8'hBB) arrives. Root will update step.", $time);
        x_in_tb = 8'hBB;
        #60; // Wait for propagation
        $display("LOG: Time %0t | Waiting for 'done' from the second external event.", $time);

        // 4. Test internal transition (star)
        // Since we are not simulating internal logic, this is a conceptual test
        // The system will transition on its own based on its internal state (tn)
        // We'll just wait a long time to see it self-propagate
        $display("LOG: Time %0t | Clearing input. Letting the system handle internal transitions.", $time);
        x_in_tb = 8'h00; // Clear input
        #150;
        
        $display("-------------------------------------------");
        $display("LOG: Simulation Finished");
        $display("-------------------------------------------");
        $finish; // End simulation
    end
endmodule
