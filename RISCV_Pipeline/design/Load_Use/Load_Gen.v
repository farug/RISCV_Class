module Load_Gen (
    input Flag0,Flag1,Flag2,
    input [31:0] Load_Use00,Load_Use10,Load_Use11,Load_Use01,Mux_FW_0,Mux_FW_1,
    input [31:0] Load_Use02,Load_Use12,
    output [31:0] Load_Use0,Load_Use1
);
    assign Load_Use0 = (Flag0) ? Load_Use00 : (Flag1) ? Load_Use01  : (Flag2) ?Load_Use02: Mux_FW_0;
    assign Load_Use1 = (Flag0) ? Load_Use10 : (Flag1) ? Load_Use11 :(Flag2) ? Load_Use12 : Mux_FW_1;
endmodule