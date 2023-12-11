`timescale 1ns / 1ps

module ProgramCounter (
input clk,reset,stall,
    input Branch,
    input [6:0] opcode,
    input [31:0]Imm,RS1_in,PC_prev,
    output reg [31:0] PC

);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            PC <= 'd0;
        end
        else if (stall) begin
            PC <= PC-'d8;
        end
        else begin
            case (opcode)
            7'b1100011: begin // Branch
                if (Branch) begin
                    PC <= PC_prev + Imm;
                end
                else begin
                    PC <= PC+'d4;
                end
            end
            7'b1100111: begin //JALR
                PC <= PC_prev+RS1_in+Imm;
            end
            7'b1101111: begin //JAL
                PC <= PC_prev+Imm;
            end
            default : PC <= PC +'d4;
            endcase
        end
    end

endmodule