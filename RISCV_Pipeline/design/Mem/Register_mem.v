`timescale 1ns / 1ps

module Register_mem #(parameter Depth = 32, Width = 32) (
    input clk,reset,we0,
    input [Width-1:0] wr_din0,
    input [$clog2(Depth)-1:0] rd_addr0,wr_addr0,rd_addr1,
    output reg [Width-1:0] rd_dout0,rd_dout1
);

    reg [Width-1:0] mem [Depth-1:0];

    integer i;
    parameter k = Depth ;
    always @(posedge clk or negedge reset) begin
        if(!reset) begin
            for (i =0 ;i<k ;i=i+1 ) begin
                mem[i] <= 'd0;
            end
        end
        else if (we0&(wr_addr0 == 'd0)) begin
            mem[wr_addr0] <= 'd0;
        end
        else if(we0) begin
            mem[wr_addr0] <= wr_din0;
        end
    end

    always @(negedge clk) begin
        rd_dout0 <= mem[rd_addr0];
        rd_dout1 <= mem[rd_addr1];
    end


    //assign rd_dout0 = mem[rd_addr0];
    //assign rd_dout1 = mem[rd_addr1];

    

endmodule