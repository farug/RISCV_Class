module Branch_Hazard (
    input V,C,N,Z,L,
    input [6:0] opcode,
    input [31:0] PC,
    output MPC,
    output [31:0] PC_prev,
    output V_o,C_o,N_o,Z_o,L_o,reset,
    output [6:0] opcode_o
);
    
    assign MPC = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
    assign reset = (opcode == 7'b1100011) ? 1'b0 : 1'b1;
    assign V_o = V;
    assign C_o = C;
    assign N_o = N;
    assign Z_o = Z;
    assign L_o = L;
    assign PC_prev = PC;
    assign opcode_o = opcode;

endmodule