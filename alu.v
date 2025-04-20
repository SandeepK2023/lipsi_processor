module alu(
    input [7:0] acc_out, rd_data,
    input [3:0] alu_ctrl,
    output reg [7:0] acc_in
);

// ALU (Arithmetic Logic Unit)
// Performs operations based on alu_ctrl input
// Uses acc_out and rd_data as operands
// Result is assigned to acc_in
// 'c' is a carry/borrow bit used in ADC and SBB operations

reg c = 1'b0;

always @(*) begin
    case (alu_ctrl)
        4'b1000: {c, acc_in} = acc_out + rd_data;        // ADD
        4'b1001: {c, acc_in} = acc_out - rd_data;        // SUB
        4'b1010: {c, acc_in} = acc_out + rd_data + c;    // ADC (Add with carry)
        4'b1011: {c, acc_in} = acc_out - rd_data - c;    // SBB (Subtract with borrow)
        4'b1100: acc_in = acc_out & rd_data;             // AND
        4'b1101: acc_in = acc_out | rd_data;             // OR
        4'b1110: acc_in = acc_out ^ rd_data;             // XOR
        4'b1111: acc_in = rd_data;                       // LOAD
        4'b0100: acc_in = acc_out << 1'b1;               // Logical Shift Left
        4'b0101: acc_in = acc_out >> 1'b1;               // Logical Shift Right
        4'b0110: acc_in = acc_out <<< 1'b1;              // Arithmetic Shift Left
        4'b0111: acc_in = acc_out >>> 1'b1;              // Arithmetic Shift Right
        default: acc_in = acc_out;                       // default
        // Note: acc_out is unsigned; <<< and >>> only behave differently if signed
    endcase
end

endmodule
