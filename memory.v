module memory(
    input clk, wr_en, fetch, small_addr, reset, 
    input [7:0] rd_addr, wr_addr, wr_data,
    output reg [7:0] rd_data
    
);

integer i;

// 512 x 8-bit memory
// Lower 256 locations for data/register memory
// Upper 256 locations for instruction memory (accessed when fetch = 1)
reg [7:0] memo [511:0];

// Memory access on rising edge of clock
always @(posedge clk) begin
    if (reset) begin
    
        for (i = 0; i < 256; i = i + 1) memo[i] <= 8'd0;

        //Factorial 5
        memo[9'd256] <= 8'hc7;
        memo[9'd257] <= 8'h05;
        memo[9'd258] <= 8'h81;
        memo[9'd259] <= 8'hc7;
        memo[9'd260] <= 8'h01;
        memo[9'd261] <= 8'h84;
        memo[9'd262] <= 8'h71;
        memo[9'd263] <= 8'h82;
        memo[9'd264] <= 8'h74;
        memo[9'd265] <= 8'h83;
        memo[9'd266] <= 8'hc7;
        memo[9'd267] <= 8'h00;
        memo[9'd268] <= 8'h75;
        memo[9'd269] <= 8'h03;
        memo[9'd270] <= 8'h85;
        memo[9'd271] <= 8'h72;
        memo[9'd272] <= 8'hc1;
        memo[9'd273] <= 8'h01;
        memo[9'd274] <= 8'h82;
        memo[9'd275] <= 8'hd3;
        memo[9'd276] <= 8'h0c;
        memo[9'd277] <= 8'h75;
        memo[9'd278] <= 8'h84;
        memo[9'd279] <= 8'h71;
        memo[9'd280] <= 8'hc1;
        memo[9'd281] <= 8'h01;
        memo[9'd282] <= 8'h81;
        memo[9'd283] <= 8'hc1;
        memo[9'd284] <= 8'h01;
        memo[9'd285] <= 8'hd3;
        memo[9'd286] <= 8'h07;
        memo[9'd287] <= 8'h74;
        memo[9'd288] <= 8'hff;
    
        // On reset, read first instruction
        rd_data <= memo[9'd256];
    end 
    
    else begin
        if (fetch) begin
            // Instruction fetch from instruction memory
            rd_data <= memo[{fetch, rd_addr}];
        end else if (small_addr == 1) begin
            // Accessing only 4-bit address (zero extended)
            if (wr_en) begin
                memo[{fetch, 4'b0000, wr_addr[3:0]}] <= wr_data;
            end else begin
                rd_data <= memo[{fetch, 4'b0000, rd_addr[3:0]}];
            end
        end else begin
            // Regular 8-bit address memory access
            if (wr_en) begin
                memo[{fetch, wr_addr}] <= wr_data;
            end else begin
                rd_data <= memo[{fetch, rd_addr}];
            end
        end
    end
end

endmodule

//Sum of first n numbers
//    memo[9'd256] = 8'b11000111;
//    memo[9'd257] = 8'd10;
//    memo[9'd258] = 8'b10000001;
//    memo[9'd259] = 8'b10000010;
//    memo[9'd260] = 8'b11000001;
//    memo[9'd261] = 8'b00000001;
//    memo[9'd262] = 8'b10000001;
//    memo[9'd263] = 8'b00000010;
//    memo[9'd264] = 8'b10000010;
//    memo[9'd265] = 8'b01110001;
//    memo[9'd266] = 8'b11010011;
//    memo[9'd267] = 8'b00000100;
//    memo[9'd268] = 8'b01110010;
//    memo[9'd269] = 8'b11111111;
