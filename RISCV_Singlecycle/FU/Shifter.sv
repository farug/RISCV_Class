`timescale 1ns / 1ps

module Shifter (
    input [31:0] B,
    input [1:0] H_Sel,
    input [4:0] rs2,
    output logic [31:0] H
);
    always_comb begin
        case (H_Sel)
            2'b00: H= B << rs2;   //sll 
            2'b01: H= B >> rs2; //Srl
            2'b11: H= $signed(B) >>> rs2; //Sra
            default: H = 32'b0;
        endcase
    end
endmodule