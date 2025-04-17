module add_1(
    input [7:0] pc_out,
    output [7:0] pc_plus_1
);

// Adds 1 to the current PC value
// Used to increment the Program Counter (PC)

assign pc_plus_1 = pc_out + 1'b1;

endmodule
