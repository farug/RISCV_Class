`timescale 1ns / 1ps

module ImmGenerator (
    input [31:0] instruction,
    output logic [31:0] Imm
);

    wire [6:0] opcode;

    assign opcode = instruction[6:0];
    always_comb begin
        case (opcode)
        7'b0110111: begin //LUI U type
            Imm = {instruction[31:12],12'd0};
        end
        7'b0010111: begin //AUIPC U type
            Imm = {instruction[31:12],12'd0};
        end
        7'b1101111: begin //JAL J type
            Imm = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'd0}; 
        end
        7'b1100011: begin //Branch B type
            Imm = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'd0};
        end 
        7'b1100111: begin //JALR I type
            Imm = {{20{instruction[31]}},instruction[31:20]};
        end
        7'b0000011: begin //Load I type
            Imm = {{20{instruction[31]}},instruction[31:20]};
        end
        7'b0100011: begin //Store  S type
            Imm = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
        end
        7'b0010011: begin //I type
            Imm = {{20{instruction[31]}},instruction[31:20]};
        end
        default: Imm = {32'd0}; // R type
        endcase
    end
endmodule