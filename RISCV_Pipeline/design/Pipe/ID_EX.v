module ID_EX (
    input clk,reset,
    input MP_in,
    input [31:0] IMM_in,PC_in,
    input [31:0] A_in,B_in,
    input MB_in,
    input [3:0] STRB_in,
    input MD_in,RW_in,
    input [4:0] RD_in,RS2_in,RS1_in,
    input MW_in,
    input [3:0] FS_in,
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    input FW0_in,FW1_in,FW00_id_in,FW01_id_in,FW10_id_in,FW11_id_in,
    input FW02_in,FW12_in,
    output reg MP_out,
    output reg [31:0] IMM_out,PC_out,A_out,B_out,
    output reg MB_out,
    output reg [3:0] STRB_out,
    output reg MD_out,RW_out,
    output reg [4:0] RD_out,RS2_out,RS1_out,
    output reg MW_out,
    output reg [3:0] FS_out,
    output reg [6:0] opcode_out,
    output reg [2:0] funct3_out,
    output reg FW0_out,FW1_out,FW00_id_out,FW01_id_out,FW10_id_out,FW11_id_out,
    output reg FW02_id_out,FW12_id_out,
    output reg reset_out
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            MP_out <= 'd0;
            IMM_out <= 'd0;
            PC_out <= 'd0;
            A_out <= 'd0;
            B_out <= 'd0;
            MB_out <= 'd0;
            STRB_out <= 'd0;
            MD_out <= 'd0;
            RW_out <= 'd0;
            RD_out <= 'd0;
            MW_out <= 'd0;
            FS_out <= 'd0;
            opcode_out <= 'd0;
            funct3_out <= 'd0;
            FW0_out <= 'd0;
            FW1_out <= 'd0;
            FW00_id_out <= 'd0;
            FW01_id_out <= 'd0;
            FW10_id_out <= 'd0;
            FW11_id_out <= 'd0;
            RS2_out <= 'd0;
            RS1_out <= 'd0;
            reset_out <= reset;
            FW02_id_out <= 'd0;
            FW12_id_out <= 'd0;
        end
        else begin
            MP_out <= MP_in;
            IMM_out <= IMM_in;
            PC_out <= PC_in;
            A_out <= A_in;
            B_out <= B_in;
            MB_out <= MB_in;
            STRB_out <= STRB_in;
            MD_out <= MD_in;
            RW_out <= RW_in;
            RD_out <= RD_in;
            MW_out <= MW_in;
            FS_out <= FS_in;
            opcode_out <= opcode_in;
            funct3_out <= funct3_in;
            FW0_out <= FW0_in;
            FW1_out <= FW1_in;
            FW00_id_out <= FW00_id_in;
            FW01_id_out <= FW01_id_in;
            FW10_id_out <= FW10_id_in;
            FW11_id_out <= FW11_id_in;
            RS2_out <= RS2_in;
            RS1_out <= RS1_in;
            reset_out <= 'd0;
            FW02_id_out <= FW02_in;
            FW12_id_out <= FW12_in;
        end
        
    end
endmodule