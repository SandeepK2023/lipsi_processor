`timescale 1us / 1ns

module testbench;
    reg clk, reset;
    wire [7:0] acc;
//    wire [3:0] state, next_state;
//    wire [7:0] rd_data;
//    wire [3:0] alu_ctrl;
//    wire [7:0] acc_in;
//    wire [3:0] alu_ctrl_store;

    lipsi_processor lip1 (
        clk, 
        reset, 
        acc
        // ,state, next_state, rd_data, alu_ctrl, acc_in, alu_ctrl_store 
    );

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #10 reset = 1'b0;
        
        #4000 reset = 1'b1;
        #100 reset = 1'b0;
        #4000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule
