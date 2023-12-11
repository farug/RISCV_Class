`timescale 1ns / 1ps
module InstructionDecoder (
    input [31:0] Instruction,
    input [8:0] Address_mem,
    output logic MW,RW,MD,MB,MP,
    output logic [3:0] FS,
    output logic [4:0] RD,RS1,RS2,
    output [6:0] opcode,
    output [2:0] funct3,
    output logic [3:0] STRB
);

//instruction decoding wires and assignments;
wire [4:0] rd,rs1,rs2;
wire [6:0] funct7;

assign opcode = Instruction[6:0];
assign funct3 = Instruction[14:12];
assign funct7 = Instruction[31:25];
assign rs1 = Instruction[19:15];
assign rs2 = Instruction[24:20];
assign rd = Instruction[11:7];

always_comb begin
    case (opcode)
                7'b0110011: begin //R type
                    FS = {funct7[5],funct3};
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = rs1;
                    RS2 = rs2;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b0;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
                7'b0010011: begin //I type some part of it
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = rs1;
                    RS2 = rs2;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b0;
                    STRB = 4'd0;
                    if ((funct3 == 3'b101) | (funct3 == 3'b001)) begin //SRAI, SRLI,SLLI
                        FS = {funct7[5],funct3};
                    end 
                    else begin // ANDI,ORI,XORI,SLTIU,SLTI,ADDI
                        FS = {1'b0,funct3};
                    end 
                end
                7'b1100111: begin //JALR
                    FS = {1'b0,funct3};
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = rs1;
                    RS2 = 'd0;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
                7'b1101111: begin //JAL
                    FS = 4'd0;
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = rs1;
                    RS2 = 'd0;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
                7'b0110111: begin //LUI
                    FS = 4'd0;
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = 'd0;
                    RS2 = 'd0;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
                7'b0010111: begin //AUIPC
                    FS = 4'd0;
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = 'd0;
                    RS2 = 'd0;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b1;
                    STRB = 4'd0;
                end
                7'b1100011: begin // Branch Instructions
                    case (funct3)
                        3'b000: begin // BEQ
                            FS = 4'b1000;
                        end 
                        3'b001: begin //BNE
                            FS = 4'b1000;
                        end
                        3'b100: begin //BLT
                            FS = 4'b1000;
                        end
                        3'b101: begin //BGE
                            FS = 4'b1000;
                        end
                        3'b110: begin //BLTU
                            FS = 4'b0011;
                        end
                        3'b111: begin //BGEU
                            FS = 4'b0011;
                        end
                    endcase
                    MW = 1'b0;
                    RW = 1'b0;
                    RS1 = rs1;
                    RS2 = rs2;
                    RD = 'd0;
                    MD = 1'b0;
                    MB = 1'b0;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
                7'b0000011: begin // Load
                    FS = 4'd0;
                    MW = 1'b0;
                    RW = 1'b1;
                    RS1 = rs1;
                    RS2 = 'd0;
                    RD = rd;
                    MD = 1'b1;
                    MB = 1'b1;
                    MP = 1'b0;
                    case (funct3)
                        3'b000: begin
                            STRB = 4'b0001 << (Address_mem%4); // LB STRB i diger yerlerde sifira cek
                        end 
                        3'b001: begin //LH
                            STRB = 4'b0011 << (Address_mem%4); 
                        end
                        3'b010: begin //LW
                            STRB =  4'b1111;
                        end
                        3'b100: begin //LBU
                            STRB = 4'b0001;
                        end
                        3'b101: begin // LHU
                            STRB = 4'b0011;
                        end
                        default: STRB = 4'b1111;
                    endcase
                end
                7'b0100011: begin //Store
                    FS = 4'd0;
                    MW = 1'b1;
                    RW = 1'b0;
                    RS1 = rs1;
                    RS2 = rs2;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b1;
                    MP = 1'b0;
                    case (funct3)
                        3'b000: begin
                            STRB = 4'b0001 << (Address_mem%4); 
                        end 
                        3'b001: begin
                            STRB = 4'b0011 << (Address_mem%4); 
                        end
                        3'b010: begin
                            STRB =  4'b1111;
                        end
                        default: STRB = 4'b1111;
                    endcase
                end
                default: begin
                    FS = 4'd0;
                    MW = 1'b1;
                    RW = 1'b0;
                    RS1 = rs1;
                    RS2 = rs2;
                    RD = rd;
                    MD = 1'b0;
                    MB = 1'b0;
                    MP = 1'b0;
                    STRB = 4'd0;
                end
    endcase
end
endmodule


