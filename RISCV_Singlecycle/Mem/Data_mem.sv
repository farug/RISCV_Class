`timescale 1ns / 1ps

module Data_mem #(parameter Depth = 128, Width = 32 , DMemInitFile="") (
    input clk,reset,we0,
    input [Width-1:0] wr_din0,
    input [(Width/8)-1:0] wr_strb,rd_strb,
    input [$clog2(Depth)+1:0] rd_addr0,wr_addr0,
    output [Width-1:0] rd_dout0
);

    logic [Width-1:0] mem [Depth-1:0];

    initial begin // readmemh a bagla
        #1;
        /*mem[0] = 32'd4;
        mem[1] = 32'd10;
        mem[2] = 32'd5;
        mem[3] = 32'd7;
        mem[4] = 32'd5;
        mem[5] = 32'd8;*/

        $readmemh(DMemInitFile,mem);
    end

    wire [$clog2(Depth)-1:0] rd_addr0p,wr_addr0p;

    assign rd_addr0p = rd_addr0 >> 2;
    assign wr_addr0p = wr_addr0 >> 2;
    integer i;
    parameter k = Depth ;
    always_ff @(posedge clk or negedge reset) begin
        if(!reset) begin
            for (i =0 ;i<k ;i=i+1 ) begin
                mem[i] <= 'd0;
            end
        end
        else if(we0) begin
            if (wr_strb == 4'b0001) begin
                mem[wr_addr0p][7:0] <= wr_din0[7:0];
            end
            else if (wr_strb == 4'b0010) begin
                mem[wr_addr0p][15:8] <= wr_din0[7:0];
            end
            else if (wr_strb == 4'b0011) begin
                mem[wr_addr0p][15:0] <= wr_din0[15:0];
            end
            else if (wr_strb == 4'b0100) begin
                mem[wr_addr0p][23:16] <= wr_din0[7:0];
            end
            else if (wr_strb == 4'b0110) begin
                mem[wr_addr0p][23:8] <= wr_din0[15:0];
            end
            else if (wr_strb == 4'b1000) begin
                mem[wr_addr0p][31:24] <= wr_din0[7:0];
            end
            else if (wr_strb == 4'b1100) begin
                mem[wr_addr0p][31:16] <= wr_din0[15:0];
            end
            else if (wr_strb == 4'b1111) begin
                mem[wr_addr0p] <= wr_din0;
            end
            else begin
                mem <= mem;
            end
        end
        else begin
            mem <= mem;
        end
    end


    assign rd_dout0[7:0] = (rd_strb[0]) ? mem[rd_addr0p][7:0] : 8'd0;
    assign rd_dout0[15:8] = (rd_strb[1]) ? mem[rd_addr0p][15:8] : (rd_strb[0]) ? 8'hff: 8'd0;
    assign rd_dout0[23:16] = (rd_strb[2]) ? mem[rd_addr0p][23:16] : (rd_strb[0] | rd_strb[1]) ? 8'hff : 8'd0 ;
    assign rd_dout0[31:24] = (rd_strb[3]) ? mem[rd_addr0p][31:24] : (rd_strb[0] | rd_strb[1] | rd_strb[2]) ? 8'hff : 8'd0;

endmodule