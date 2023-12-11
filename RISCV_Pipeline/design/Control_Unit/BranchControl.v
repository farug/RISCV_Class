`timescale 1ns / 1ps

module BranchControl (
    input [2:0] funct3,
    input V,C,N,Z,L,
    output reg Branch
);

    always @(*) begin
        case (funct3)
            3'b000: begin //BEQ
                if (Z) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end 
            3'b001: begin //BNE
                if (!Z) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end
            3'b100: begin //BLT
                if (N^V) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end
            3'b101: begin //BGE
                if (!(N^V)) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end
            3'b110: begin //BLTU
                if (L) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end
            3'b111: begin //BGEU
                if (!L) begin
                    Branch = 1'b1;
                end
                else begin
                    Branch = 1'b0;
                end
            end
            default: Branch=1'b0;
        endcase
    end
endmodule