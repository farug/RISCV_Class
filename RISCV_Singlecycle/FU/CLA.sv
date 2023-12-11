`timescale 1ns / 1ps

module CLA_4(
    input [3:0]X,
    input [3:0]Y,
    input c0,
    output cout,
    output [3:0]S,
    output cprew
);
wire [3:1]C;
wire [3:0]g;
wire [3:0]p;

assign S[0]=X[0]^Y[0]^c0;
assign g[0]=X[0]&Y[0];
assign p[0]=X[0]|Y[0];
assign C[1]=(p[0]&c0)|g[0];

assign S[1]=X[1]^Y[1]^C[1];
assign g[1]=X[1]&Y[1];
assign p[1]=X[1]|Y[1];
assign C[2]=(p[1]&C[1])|g[1];

assign S[2]=X[2]^Y[2]^C[2];
assign g[2]=X[2]&Y[2];
assign p[2]=X[2]|Y[2];
assign C[3]=(p[2]&C[2])|g[2];

assign S[3]=X[3]^Y[3]^C[3];
assign g[3]=X[3]&Y[3];
assign p[3]=X[3]|Y[3];
assign cout=(p[3]&C[3])|g[3];

assign cprew = C[3];

endmodule