`timescale 1ns / 1ps

module FW_Unit (
    input [4:0] RS1,RS2,RD,
    input RW,
    output FW0,FW1
);
    wire FW0p,FW1p;
    assign FW0p = ((RS1==RD)&RW) ? 1'b1 : 1'b0;
    assign FW1p = ((RS2==RD)&RW) ? 1'b1 : 1'b0;

    assign FW0 = (RD=='d0) ? 1'b0 : FW0p;
    assign FW1 = (RD=='d0) ? 1'b0 : FW1p;
endmodule