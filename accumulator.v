module accumulator(
    input clk, acc_en, reset,
    input [7:0] acc_in,
    output reg [7:0] acc_out
);

// Accumulator Register
// On rising edge of clk:
// If acc_en is high, then load acc_in into acc_out

always @(posedge clk) begin
    if (reset) acc_out <= 8'd0;
    else if (acc_en) acc_out <= acc_in;
end

endmodule
