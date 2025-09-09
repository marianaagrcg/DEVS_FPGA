`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/21/2025 05:30:54 PM
// Design Name:
// Module Name: SIMULATOR
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Parallel DEVS Simulator with FIFO logic
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Corrected done signal logic
// Revision 0.03 - Added FIFO logic for input port x
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`define WIDTH_PORT 8
`define WIDTH_TIME 8
`define FIFO_DEPTH 5

module simulator (
    input wire [`WIDTH_PORT-1:0] x,
    input wire [`WIDTH_TIME-1:0] at,
    input wire [`WIDTH_TIME-1:0] star,
    input wire clk,
    input wire rst,
    output reg [`WIDTH_PORT-1:0] y,
    output reg [`WIDTH_TIME-1:0] done
);

    // Registros
    reg [`WIDTH_TIME-1:0] tn;
    reg [`WIDTH_TIME-1:0] tL;
    reg [`WIDTH_PORT-1:0] fifo_x [`FIFO_DEPTH-1:0]; // FIFO de 5 elementos
    reg [2:0] fifo_head;
    reg [2:0] fifo_tail;
    reg fifo_empty;
    reg fifo_full;
    reg [`WIDTH_PORT-1:0] fifo_peek_val;

    // Estados para la máquina de estados
    localparam S_IDLE = 2'b00;
    localparam S_EXTERNAL = 2'b01;
    localparam S_INTERNAL = 2'b10;
    reg [1:0] state;
    
    // Contador para los 2 ciclos de las transiciones
    reg [1:0] cycle_count;

    // Lógica secuencial síncrona
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tn <= 'd0;
            tL <= 'd0;
            y <= 'd0;
            done <= 'd0;
            state <= S_IDLE;
            cycle_count <= 'd0;
            fifo_head <= 3'b0;
            fifo_tail <= 3'b0;
            fifo_empty <= 1'b1;
            fifo_full <= 1'b0;
            fifo_peek_val <= 'd0;
        end else begin
            // Lógica para manejar el FIFO en el estado IDLE
            if (state == S_IDLE) begin
                // Lógica de encolar
                if (x != 'd0 && !fifo_full) begin
                    fifo_x[fifo_tail] <= x;
                    fifo_tail <= fifo_tail + 1;
                    if (fifo_tail + 1 == fifo_head) begin
                        fifo_full <= 1'b1;
                    end
                    fifo_empty <= 1'b0;
                end
            end
            
            case (state)
                S_IDLE: begin
                    done <= 'd0;
                    if (at >= tn && !fifo_empty) begin
                        state <= S_EXTERNAL;
                        cycle_count <= 'd0; 
                        // Lógica de desencolar y "peek" para la transición externa
                        fifo_peek_val <= fifo_x[fifo_head];
                        fifo_head <= fifo_head + 1;
                        if (fifo_head + 1 == fifo_tail) begin
                            fifo_empty <= 1'b1;
                        end
                        fifo_full <= 1'b0;
                    end else if (star != tL) begin
                        state <= S_INTERNAL;
                        cycle_count <= 'd0; 
                    end
                end

                S_EXTERNAL: begin // Lógica para λ (Transición Externa)
                    if (cycle_count == 1) begin // 2 ciclos completos
                        y <= fifo_peek_val;
                        done <= at; 
                        state <= S_IDLE;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end

                S_INTERNAL: begin // Lógica para δ (Transición Interna)
                    if (cycle_count == 1) begin // 2 ciclos completos
                        tL <= star;
                        tn <= star + 1; 
                        done <= star;
                        state <= S_IDLE;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
