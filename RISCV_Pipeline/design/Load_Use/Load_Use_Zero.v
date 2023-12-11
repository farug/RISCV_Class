module Load_Use_Zero (
    input [31:0] Mux_FW_0,Mux_FW_1,
    input [31:0] Data_in,
    input [4:0] RD,RS1,RS2,
    input MD,
    output [31:0] Load_Use0,Load_Use1,
    output Flag
);
    assign Load_Use0 = ((RD==RS1)&MD) ? Data_in : Mux_FW_0;
    assign Load_Use1 = ((RD==RS2)&MD) ? Data_in : Mux_FW_1;

    assign Flag = (((RD==RS2)|(RD==RS1))&MD) ? 1'b1 : 1'b0;
endmodule