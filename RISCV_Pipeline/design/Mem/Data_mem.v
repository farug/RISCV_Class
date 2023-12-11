`timescale 1ns / 1ps

module Data_mem #(parameter Depth = 128, Width = 32) (
    input clk,reset,we0,
    input [Width-1:0] wr_din0,
    input [(Width/8)-1:0] wr_strb,
    input [$clog2(Depth)+1:0] rd_addr0,wr_addr0,
    output [Width-1:0] rd_dout0
);

    reg [Width-1:0] mem [Depth-1:0];
    wire [6:0] wr_addr0p,rd_addr0p;

    initial begin
        #1;
        $readmemh("C:/Users/omer/Desktop/Okul/Dersler_22-23_2.half/EHB425E/HW-08/verilog/bubble_sort.data",mem);
    end

    assign rd_addr0p = rd_addr0 >> 2;
    assign wr_addr0p = wr_addr0 >> 2;
    integer i;
    parameter k = Depth ;
    always @(posedge clk or negedge reset) begin
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
                mem[wr_addr0p][15:8] <= wr_din0[15:8];
            end
            else if (wr_strb == 4'b0011) begin
                mem[wr_addr0p][15:0] <= wr_din0[15:0];
            end
            else if (wr_strb == 4'b0100) begin
                mem[wr_addr0p][23:16] <= wr_din0[23:16];
            end
            else if (wr_strb == 4'b0110) begin
                mem[wr_addr0p][23:8] <= wr_din0[23:8];
            end
            else if (wr_strb == 4'b1000) begin
                mem[wr_addr0p][31:24] <= wr_din0[31:24];
            end
            else if (wr_strb == 4'b1100) begin
                mem[wr_addr0p][31:16] <= wr_din0[31:16];
            end
            else if (wr_strb == 4'b1111) begin
                mem[wr_addr0p] <= wr_din0;
            end
        end
    end

    assign rd_dout0 = mem[rd_addr0p];

endmodule