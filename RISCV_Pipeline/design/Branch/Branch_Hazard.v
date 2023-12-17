module Branch_Hazard (
    input clk,
    input V,C,N,Z,L,
    input [6:0] opcode,
    input [31:0] PC,
    output reg MPC,
    output [31:0] PC_prev,
    output V_o,C_o,N_o,Z_o,L_o,
    output reg reset,
    output [6:0] opcode_o
);

    always @(posedge clk) begin
        reset = (opcode == 7'b1100011) ? 1'b0 : 1'b1;
        MPC = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
    end
    
    assign V_o = V;
    assign C_o = C;
    assign N_o = N;
    assign Z_o = Z;
    assign L_o = L;
    assign PC_prev = PC;
    assign opcode_o = opcode;

endmodule