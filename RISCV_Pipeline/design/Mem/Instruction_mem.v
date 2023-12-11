`timescale 1ns / 1ps

module InstructionMem #(parameter Depth = 128, Width = 32) (
    input clk,reset,we0,
    input [Width-1:0] wr_din0,
    input [$clog2(Depth)+1:0] rd_addr0,wr_addr0,
    output [Width-1:0] rd_dout0
);

    reg [Width-1:0] mem [Depth-1:0];

    wire [$clog2(Depth)-1:0] wr_addr0p,rd_addr0p;

    assign wr_addr0p= wr_addr0 >>2;
    assign rd_addr0p = rd_addr0 >>2;

    integer i;
    parameter k = Depth ;
    always @(posedge clk or negedge reset) begin
        if(!reset) begin
            for (i =0 ;i<k ;i=i+1 ) begin
                mem[i] <= 'd0;
            end
        end
        else if(we0) begin
            mem[wr_addr0p] <= wr_din0;
        end
    end

    assign rd_dout0 = mem[rd_addr0p];

endmodule
