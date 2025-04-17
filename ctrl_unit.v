module ctrl_unit(
    output reg [1:0] mux_pc_rd,      // MUX selection for PC read
    output reg wr_addr,              // Write address signal
    output reg wr_data,              // Write data signal
    output reg pc_en,                // PC enable signal
    output reg acc_en,               // Accumulator enable signal
    output reg fetch,                // Fetch signal
    output reg small_addr,           // Small address signal
    output reg [3:0] alu_ctrl_store, // Store ALU control signal
    output reg [3:0] state,          // Current state
    output reg [3:0] next_state,     // Next state
    input reset,                     // Reset input signal
    input [7:0] A,                   // 8-bit input A
    input [7:0] instruction,         // 8-bit instruction input
    input clk                        // Clock signal
);

// Internal register for ALU control
reg [3:0] alu_ctrl;

// State definitions (S0 to S11)
parameter S0  = 4'd0;
parameter S1  = 4'd1;
parameter S2  = 4'd2;
parameter S3  = 4'd3;
parameter S4  = 4'd4;
parameter S5  = 4'd5;
parameter S6  = 4'd6;
parameter S7  = 4'd7;
parameter S8  = 4'd8;
parameter S9  = 4'd9;
parameter S10 = 4'd10;
parameter S11 = 4'd11;

// Always block to store ALU control signal on clock edge
always @(posedge clk)
begin
    alu_ctrl_store <= alu_ctrl;
end

// Always block for updating the state on clock edge with reset functionality
always @(posedge clk)
begin
    if (reset)
        state <= S0; // Reset the state to S0
    else
        state <= next_state; // Transition to the next state
end

// Always block for state transition logic based on current state and instruction
always @(instruction, state)
begin
    if (reset) next_state <= S0;
    else begin 
    case(state)
        S0: begin
            if (instruction[7] == 0)
                next_state = S1; // Transition to S1 if instruction[7] is 0
            else begin
                case(instruction[7:4])
                    4'b1000: next_state = S2;
                    4'b1001: next_state = S3;
                    4'b1010: next_state = S4;
                    4'b1011: next_state = S6;
                    4'b1100: next_state = S8;
//                    4'b1101:begin if (instruction[1:0]==2'b00 ||(A==8'd0 && instruction[1:0]==2'b10)||(A!=8'd0 && instruction[1:0]==2'b11))
//                                    next_state=S9;
//                                  else if ((A!=8'd0 && instruction[1:0]==2'b10)||(A==8'd0 && instruction[1:0]==2'b11))
//                                    next_state=S10;
//                            end
                    4'b1101: begin
                        case(instruction[1:0])
                            2'b00: next_state = S9;
                            2'b10: begin
                                if (A == 8'b00) next_state = S9;
                                else next_state = S10;
                            end
                            2'b11: begin
                                if (A == 8'b00) next_state = S10;
                                else next_state = S9;
                            end
                        endcase
                    end
                    4'b1110: next_state = S0;
                    4'b1111: next_state = S11;
                    default: next_state = S0;
                endcase
            end
        end
        
        // States that return to S0
        S1, S2, S3, S5, S7, S8, S9, S10: next_state = S0;
        
        // State S4 transitions to S5
        S4: next_state = S5;
        
        // State S6 transitions to S7
        S6: next_state = S7;
        
        // State S11 stays in S11
        S11: next_state = S11;
        
        // Default case to return to S0
        default: next_state = S0;
    endcase
    end
end

// Always block for controlling signals based on current state and instruction
always @(instruction, state)
begin
    case(state)
        // State S0 logic
        S0: if (instruction[7] == 0) begin
            mux_pc_rd = 2'b10;
            wr_addr = 0;
            pc_en = 0; 
            acc_en = 0;
            alu_ctrl = {1'b1, instruction[6:4]};
            fetch = 0;
            small_addr = 1;
        end else begin
            case(instruction[7:4])
                4'b1000: begin
                    wr_addr = 1;
                    wr_data = 0;
                    pc_en = 0; 
                    acc_en = 0;
                    alu_ctrl = 4'b0000;
                    fetch = 0;
                    small_addr = 1;
                end
                4'b1001: begin
                    mux_pc_rd = 2'b01;
                    wr_addr = 1;
                    wr_data = 1;
                    pc_en = 0; 
                    acc_en = 0;
                    fetch = 0;
                    alu_ctrl = 4'b0000;
                    small_addr = 1;
                end
                4'b1010: begin
                    mux_pc_rd = 2'b10;
                    wr_addr = 0;
                    pc_en = 0; 
                    acc_en = 0;
                    fetch = 0;
                    alu_ctrl = 4'b0000;
                    small_addr = 1;
                end
                4'b1011: begin
                    mux_pc_rd = 2'b10;
                    wr_addr = 0;
                    pc_en = 0; 
                    acc_en = 0;
                    fetch = 0;
                    alu_ctrl = 4'b0000;
                    small_addr = 1;
                end
                4'b1100: begin
                    mux_pc_rd = 2'b00;
                    wr_addr = 0;
                    pc_en = 1; 
                    acc_en = 0;
                    fetch = 1;
                    alu_ctrl = {1'b1, instruction[2:0]};
                end
                4'b1101: begin
                    mux_pc_rd = 2'b00;
                    wr_addr = 0;
                    pc_en = 1; 
                    acc_en = 0;
                    fetch = 1;
                    alu_ctrl = 4'b0000;
                end
                4'b1110: begin
                    mux_pc_rd = 2'b00;
                    wr_addr = 0;
                    pc_en = 1; 
                    acc_en = 1;
                    fetch = 1;
                    alu_ctrl = {2'b01, instruction[1:0]};
                end
                4'b1111: begin
                    mux_pc_rd = 2'b10;
                    wr_addr = 0;
                    pc_en = 0; 
                    acc_en = 0;
                    fetch = 1;
                    alu_ctrl = 4'b0000;
                end
                default: begin
                    mux_pc_rd = 2'b11;
                    wr_addr = 0;
                    pc_en = 0;
                    acc_en = 0;
                    alu_ctrl = 4'b0000;
                    fetch = 1;
                end
            endcase
        end
        
        // States with specific signal controls
        S1: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 1;
            fetch = 1;
        end
        
        S2: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 0;
            fetch = 1;
        end
        
        S3: begin
            mux_pc_rd = 2'b01;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 0;
            fetch = 1;
        end
        
        S4: begin
            mux_pc_rd = 2'b01;
            wr_addr = 0;
            pc_en = 0; 
            acc_en = 0;
            fetch = 0;
            small_addr = 0;
        end
        
        S5: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 1;
            fetch = 1;
        end
        
        S6: begin
            wr_addr = 1;
            wr_data = 0;
            pc_en = 0; 
            acc_en = 0;
            fetch = 0;
            small_addr = 0;
        end
        
        S7: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 0;
            fetch = 1;
        end
        
        S8: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 1;
            fetch = 1;
        end
        
        S9: begin
            mux_pc_rd = 2'b10;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 0;
            fetch = 1;
        end
        
        S10: begin
            mux_pc_rd = 2'b00;
            wr_addr = 0;
            pc_en = 1; 
            acc_en = 0;
            fetch = 1;
        end
        
        // State S11 logic
        S11: begin
            mux_pc_rd = 2'b11;
            wr_addr = 0;
            pc_en = 0;
            acc_en = 0;
            alu_ctrl = 4'b0000;
            fetch = 1;
        end
        
        // Default case to handle unexpected states
        default: begin
            mux_pc_rd = 2'b11;
            wr_addr = 0;
            pc_en = 0;
            acc_en = 0;
            alu_ctrl = 4'b0000;
            fetch = 1;
        end
    endcase
end

endmodule
