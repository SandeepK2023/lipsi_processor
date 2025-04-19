module lipsi_processor(
    input clk, reset,
    output [7:0] acc,
    output [3:0] seg_ctrl,
    output [6:0] seg_led
//    output [3:0] state, next_state,
//    output [7:0] rd_data, output [3:0] alu_ctrl, output [7:0] acc_in,
//    output [3:0] alu_ctrl_store
);

    // Internal wires
    wire [3:0] state, next_state;
    wire [3:0] alu_ctrl;
    wire [7:0] rd_data;
    wire [7:0] acc_in;
    wire [3:0] alu_ctrl_store;
    wire [1:0] mux_pc_rd;
    wire [7:0] rd_addr, wr_addr, wr_data;
    wire [7:0] pc_in, pc_out, pc_plus_1;
    wire [7:0] acc_out;
    
    assign acc = acc_out;

    wire fetch, small_addr;
    wire mux_wr_addr;
    
    assign wr_en = mux_wr_addr;

    // Memory module: handles both instruction fetch and data storage
    memory m1(
        .clk(clk), 
        .wr_en(wr_en), 
        .fetch(fetch | reset), 
        .reset(reset),
        .rd_addr(pc_in), 
        .wr_addr(wr_addr), 
        .wr_data(wr_data),
        .rd_data(rd_data), 
        .small_addr(small_addr) 
        
    );

    // Mux to select write address: 0 or rd_data
    mux_2_to_1 mux1(
        .i0(8'd0), 
        .i1(rd_data), 
        .y(wr_addr), 
        .s(mux_wr_addr)
    );

    // Mux to select write data: acc_out or pc_out
    mux_2_to_1 mux2(
        .i0(acc_out), 
        .i1(pc_out), 
        .y(wr_data), 
        .s(mux_wr_data)
    );

    // 4-to-1 Mux to select next PC input
    mux_4_to_1 mux3(
        .i0(pc_plus_1), 
        .i1(acc_out), 
        .i2(rd_data), 
        .i3(8'd0),
        .y(pc_in), 
        .s1(mux_pc_rd[1] | reset), 
        .s0(mux_pc_rd[0] | reset)
    );

    // Program Counter module
    pc p1(
        .clk(clk), 
        .pc_en(pc_en), 
        .reset(reset), 
        .pc_in(pc_in), 
        .pc_out(pc_out)
    );

    // Adds 1 to PC for next instruction fetch
    add_1 a1(
        .pc_out(pc_out), 
        .pc_plus_1(pc_plus_1)
    );

    // Accumulator to hold intermediate results
    accumulator acc1(
        .clk(clk),
        .reset(reset), 
        .acc_en(acc_en), 
        .acc_in(acc_in), 
        .acc_out(acc_out)
    );

    // ALU: performs arithmetic/logic operations
    alu alu1(
        .acc_out(acc_out), 
        .rd_data(rd_data), 
        .alu_ctrl(alu_ctrl),
        .acc_in(acc_in)
    );

    // Control Unit: FSM that orchestrates operation based on instruction
    ctrl_unit c1(
        .clk(clk), 
        .instruction(rd_data), 
        .alu_ctrl_store(alu_ctrl), 
        .pc_en(pc_en), 
        .reset(reset),
        .acc_en(acc_en), 
        .mux_pc_rd(mux_pc_rd), 
        .wr_addr(mux_wr_addr),
        .wr_data(mux_wr_data),
        .A(acc_out), 
        .fetch(fetch), 
        .small_addr(small_addr),
        .state(state), 
        .next_state(next_state)
    );
    
    // Seven segment display
    seven_segment seven_seg_display(.seg_led(seg_led), .seg_ctrl(seg_ctrl),.q(acc),.clk(clk),.reset(reset));

endmodule
