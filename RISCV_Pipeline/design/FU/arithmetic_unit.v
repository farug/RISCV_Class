`timescale 1ns / 1ps

module Arithmetic_Unit (
    input [31:0] A,B,
    output [31:0] S,
    output C,V,Z,N,
    input AS
);

    wire [31:0] Bp;
    wire Ci;
    wire [7:0] Cp;
    wire cprew;

    assign Bp = (AS) ? B^{32{1'b1}} : B;
    assign Ci = AS;
    //first 4 bit

    CLA_4 CLA1(.X(A[3:0]),.Y(Bp[3:0]),.c0(Ci),.cout(Cp[0]),.S(S[3:0]));

    //second 4 bit

    CLA_4 CLA2(.X(A[7:4]),.Y(Bp[7:4]),.c0(Cp[0]),.cout(Cp[1]),.S(S[7:4]));

    //third 4 bit

    CLA_4 CLA3(.X(A[11:8]),.Y(Bp[11:8]),.c0(Cp[1]),.cout(Cp[2]),.S(S[11:8]));

    //fourth 4 bit

    CLA_4 CLA4(.X(A[15:12]),.Y(Bp[15:12]),.c0(Cp[2]),.cout(Cp[3]),.S(S[15:12]));

    //fifth 4 bit

    CLA_4 CLA5(.X(A[19:16]),.Y(Bp[19:16]),.c0(Cp[3]),.cout(Cp[4]),.S(S[19:16]));

    // sixth 4 bit

    CLA_4 CLA6(.X(A[23:20]),.Y(Bp[23:20]),.c0(Cp[4]),.cout(Cp[5]),.S(S[23:20]));

    //seventh 4 bit

    CLA_4 CLA7(.X(A[27:24]),.Y(Bp[27:24]),.c0(Cp[5]),.cout(Cp[6]),.S(S[27:24]));

    // eigth 4 bit

    CLA_4 CLA8(.X(A[31:28]),.Y(Bp[31:28]),.c0(Cp[6]),.cout(Cp[7]),.S(S[31:28]),.cprew(cprew));

    assign C = Cp[7];

    assign Z = ~(|S);

    assign V = cprew^Cp[7];

    assign N = S[31];
endmodule