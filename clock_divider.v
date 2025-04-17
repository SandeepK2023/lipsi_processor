module clock_divider(
    input clk,        // Input clock (high frequency)
    input reset,      // Active-high reset
    output reg clklow // Output divided (slow) clock
);

    reg [25:0] count; // 26-bit counter for dividing clock

    // Clock divider logic
    always @(posedge clk) begin
        if (count == 499_999) begin
            clklow <= ~clklow; // Toggle the output clock
            count <= 0;        // Reset counter
        end
        else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule
