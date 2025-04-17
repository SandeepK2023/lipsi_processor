module mux_4_to_1(
    input [7:0] i0, i1, i2, i3, 
    input s0, s1,
    output [7:0] y
);

// 4-to-1 Multiplexer
// Selects one of four 8-bit inputs based on s1 and s0

// Selection logic:
//   s1 s0 | y
//   ------|------------
//    0  0 | i0 (PC + 1)
//    0  1 | i1 (acc_out)
//    1  0 | i2 (rd_data)
//    1  1 | i3 (0)

assign y = (s1 ? (s0 ? i3 : i2) : (s0 ? i1 : i0));

endmodule
