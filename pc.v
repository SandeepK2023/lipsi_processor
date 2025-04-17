module pc(
    input clk, pc_en, reset,
    input [7:0] pc_in,
    output reg [7:0] pc_out
);

// Program Counter (PC)
// On reset:       pc_out is cleared to 0
// If pc_en is 1:  pc_out is updated with pc_in on rising clock edge

always @(posedge clk) begin
    if (reset)
        pc_out <= 8'd0;
    else if (pc_en)
        pc_out <= pc_in;
end

endmodule
