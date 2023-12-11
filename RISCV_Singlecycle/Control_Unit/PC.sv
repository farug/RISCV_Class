`timescale 1ns / 1ps

module ProgramCounter (
input clk,reset,
    input Branch,
    input [6:0] opcode,
    input [31:0]Imm,RS1_in,
    output logic [31:0] PC

);

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            PC <= 'd0;
        end
        else begin
            case (opcode)
            7'b1100011: begin // Branch
                if (Branch) begin
                    PC <= PC + Imm;
                end
                else begin
                    PC <= PC+4;
                end
            end
            7'b1100111: begin //JALR  this is wrong PC {rs1+IMM,1'b0} https://www.youtube.com/watch?v=u0t5sZwcGUM check this
                PC <= (RS1_in+Imm)&32'hfffe; // I am not sure if that works changing the lsb to 0
            end
            7'b1101111: begin //JAL
                PC <= PC+Imm;
            end
            default : PC <= PC +4;
            endcase
        end
    end

endmodule