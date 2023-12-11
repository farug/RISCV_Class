`timescale 1ns / 1ps

module G_Product (
    input [31:0] G1,G2,A,B,
    input FW00,FW10,FW01,FW11,FW02,FW12,
    output [31:0] G_generate0,G_generate1
);
    assign G_generate0 = {{32{(FW00&(~FW01)&(~FW02))}}&G1}|{{32{((~FW00)&FW01&(~FW02))}}&G2}|{{32{((~FW00)&(~FW01)&(FW02))}}&A};
    assign G_generate1 = {{32{(FW10&(~FW11)&(~FW12))}}&G1}|{{32{((~FW10)&(FW11)&(~FW12))}}&G2}|{{32{((~FW10)&(~FW11)&(FW12))}}&B};
endmodule