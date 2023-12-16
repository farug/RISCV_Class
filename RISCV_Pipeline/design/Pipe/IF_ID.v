
module IF_ID (
    input clk,reset,
    input MP_in,MB_in,MD_in,MW_in,RW_in,
    input [3:0] FS_in,STRB_in,
    input [4:0] RD_in,RS1_in,RS2_in,
    input [2:0] funct3_in,
    input [6:0] opcode_in,
    input [31:0] IMM_in,PC_in,
    output reg MP_out,MB_out,MD_out,MW_out,RW_out,
    output reg [3:0] FS_out,STRB_out,
    output reg [4:0] RD_out,RS1_out,RS2_out,
    output reg [2:0] funct3_out,
    output reg [6:0] opcode_out,
    output reg [31:0] IMM_out,PC_out,
    output reg reset_out
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            MP_out <= 'd0;
            MB_out <= 'd0;
            MD_out <= 'd0;
            MW_out <= 'd0;
            RW_out <= 'd0;
            FS_out <= 'd0;
            STRB_out <= 'd0;
            RD_out <= 'd0;
            RS1_out <= 'd0;
            RS2_out <= 'd0;
            funct3_out <= 'd0;
            opcode_out <= 'd0;
            IMM_out <= 'd0;
            PC_out <= 'd0;
            reset_out <= reset;
        end
        else begin
            MP_out <= MP_in;
            MB_out <= MB_in;
            MD_out <= MD_in;
            MW_out <= MW_in;
            RW_out <= RW_in;
            FS_out <= FS_in;
            STRB_out <= STRB_in;
            RD_out <= RD_in;
            RS1_out <= RS1_in;
            RS2_out <= RS2_in;
            funct3_out <= funct3_in;
            opcode_out <= opcode_in;
            IMM_out <= IMM_in;
            PC_out <= PC_in;
            reset_out <= 'd1;
        end
        
    end
endmodule