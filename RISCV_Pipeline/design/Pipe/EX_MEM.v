module EX_MEM (
    input clk,reset,
    input V_in,C_in,N_in,Z_in,L_in,
    input [31:0] G_in,PC_in,
    input [31:0] RS1_out_in,Data_out_in,
    input [3:0] STRB_in,
    input MD_in,
    input [4:0] RD_in,RS2_in,RS1_in,
    input RW_in,MW_in,
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    input [31:0] IMM_in,
    output reg V_out,C_out,N_out,Z_out,L_out,
    output reg [31:0] G_out,
    output reg [31:0] RS1_out_out,Data_out_out,
    output reg [3:0] STRB_out,
    output reg MD_out,
    output reg [4:0] RD_out,RS2_out,RS1_out,
    output reg RW_out,MW_out,
    output reg [6:0] opcode_out,
    output reg [2:0] funct3_out,
    output reg [31:0] IMM_out,PC_out,
    output reg reset_out
);
    always @(posedge clk or negedge reset) begin
        if(!reset) begin
            V_out <= 'd0;
            C_out <= 'd0;
            N_out <= 'd0;
            Z_out <= 'd0;
            L_out <= 'd0;
            G_out <= 'd0;
            RS1_out_out <= 'd0;
            Data_out_out <= 'd0;
            STRB_out <= 'd0;
            MD_out <= 'd0;
            RD_out <= 'd0;
            RW_out <= 'd0;
            MW_out <= 'd0;
            opcode_out <= 'd0;
            funct3_out <= 'd0;
            IMM_out <= 'd0;
            PC_out <= 'd0;  
            RS2_out <= 'd0;
            RS1_out <= 'd0;
            reset_out <= reset;
        end
        else begin
            V_out <= V_in;
            C_out <= C_in;
            N_out <= N_in;
            Z_out <= Z_in;
            L_out <= L_in;
            G_out <= G_in;
            RS1_out_out <= RS1_out_in;
            Data_out_out <= Data_out_in;
            STRB_out <= STRB_in;
            MD_out <= MD_in;
            RD_out <= RD_in;
            RW_out <= RW_in;
            MW_out <= MW_in;
            opcode_out <= opcode_in;
            funct3_out <= funct3_in;
            IMM_out <= IMM_in;
            PC_out <= PC_in;
            RS2_out <= RS2_in;
            RS1_out <= RS1_in;
            reset_out <= 'd0;
        end 
    end
endmodule