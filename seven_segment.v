module seven_segment(
    output reg [6:0] seg_led,
    output reg [3:0] seg_ctrl,
    input [7:0] q,
    input clk,
    reset
);

// Segment patterns for digits 0 to 15 (Hex values)
localparam n0  = 7'b1000000;
localparam n1  = 7'b1111001;
localparam n2  = 7'b0100100;
localparam n3  = 7'b0110000;
localparam n4  = 7'b0011001;
localparam n5  = 7'b0010010;
localparam n6  = 7'b0000010;
localparam n7  = 7'b1111000;
localparam n8  = 7'b0000000;
localparam n9  = 7'b0011000;
localparam n10 = 7'b0100000;
localparam n11 = 7'b0000011;
localparam n12 = 7'b0100111;
localparam n13 = 7'b0100001;
localparam n14 = 7'b0000100;
localparam n15 = 7'b0001110;

// State encoding
localparam S0 = 1'b0;
localparam S1 = 1'b1;

reg state, next_state;
wire clklow;

// Instantiate clock divider
clock_divider clk_div(
    .clk(clk),
    .reset(reset),
    .clklow(clklow)
);

// State transition on slower clock edge
always @(posedge clklow)
    state <= next_state;

// Define state transitions
always @(state)
begin
    case(state)
        S0: next_state = S1;
        S1: next_state = S0;
    endcase
end

// Output logic based on current state and input q
always @(state, q)
begin
    case(state)
        S0: begin
            seg_ctrl = 4'b1110; // Enable first digit
            case(q[3:0])        // Display lower nibble
                4'd0 : seg_led = n0;
                4'd1 : seg_led = n1;
                4'd2 : seg_led = n2;
                4'd3 : seg_led = n3;
                4'd4 : seg_led = n4;
                4'd5 : seg_led = n5;
                4'd6 : seg_led = n6;
                4'd7 : seg_led = n7;
                4'd8 : seg_led = n8;
                4'd9 : seg_led = n9;
                4'd10: seg_led = n10;
                4'd11: seg_led = n11;
                4'd12: seg_led = n12;
                4'd13: seg_led = n13;
                4'd14: seg_led = n14;
                4'd15: seg_led = n15;
            endcase
        end

        S1: begin
            seg_ctrl = 4'b1101; // Enable second digit
            case(q[7:4])        // Display upper nibble
                4'd0 : seg_led = n0;
                4'd1 : seg_led = n1;
                4'd2 : seg_led = n2;
                4'd3 : seg_led = n3;
                4'd4 : seg_led = n4;
                4'd5 : seg_led = n5;
                4'd6 : seg_led = n6;
                4'd7 : seg_led = n7;
                4'd8 : seg_led = n8;
                4'd9 : seg_led = n9;
                4'd10: seg_led = n10;
                4'd11: seg_led = n11;
                4'd12: seg_led = n12;
                4'd13: seg_led = n13;
                4'd14: seg_led = n14;
                4'd15: seg_led = n15;
            endcase
        end
    endcase
end 

endmodule
