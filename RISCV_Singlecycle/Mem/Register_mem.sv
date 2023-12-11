`timescale 1ns / 1ps

module Register_mem #(parameter Depth = 32, Width = 32) (
    input clk,reset,we0,
    input [Width-1:0] wr_din0,
    input [$clog2(Depth)-1:0] rd_addr0,wr_addr0,rd_addr1,
    input [2:0] funct3,
    output [Width-1:0] rd_dout0,rd_dout1
);

    logic [Width-1:0] mem [Depth-1:0];

    integer i;
    parameter k = Depth ;
    always_ff @(posedge clk or negedge reset) begin
        if(!reset) begin
            for (i =0 ;i<k ;i=i+1 ) begin
                mem[i] <= 'd0;
            end
        end
        else if (we0&(wr_addr0 == 'd0)) begin
            mem[wr_addr0] <= 'd0;
        end
        else if(we0) begin
            case (funct3)
                3'b100:  mem[wr_addr0] <= {24'd0,wr_din0[7:0]};  //LBU 
                3'b101: mem[wr_addr0] <= {16'd0,wr_din0[15:0]};  //LHU
                default: mem[wr_addr0] <= wr_din0;
            endcase  
        end
    end

    assign rd_dout0 = mem[rd_addr0];
    assign rd_dout1 = mem[rd_addr1];

    

endmodule