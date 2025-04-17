module mux_2_to_1(
    input [7:0] i0, i1,
    input s,
    output [7:0] y
);

// 2-to-1 Multiplexer
// If s = 0: output y = i0
// If s = 1: output y = i1

assign y = (s ? i1 : i0);

endmodule
