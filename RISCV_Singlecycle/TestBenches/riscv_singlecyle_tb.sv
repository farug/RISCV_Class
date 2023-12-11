`timescale 1ns / 1ps

module riscv_singlecycle_tb #(IMEMINITFILE="C:/Users/omer/Documents/GitHub/Dersler/MTH-RISCV/RISCV/FilesToRead/All_Instr/Instruction_Mem.hex",
DMEMINITFILE="")();

// /home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/FilesToRead/Instruction_bublesort.instr for linux machie
// /home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/FilesToRead/Bubblwsort.data for linux machine
// C:/Users/omer/Documents/GitHub/Dersler/MTH-RISCV/RISCV/FilesToRead/BubbleSort/Bubblwsort.data windows
logic clk_i,rst_ni;
wire [31:0] rf_data_hex;

// Write a macchine code to test
 riscv_singlecycle #(.DMemInitFile(DMEMINITFILE),.IMemInitFile(IMEMINITFILE)) uut (.clk_i(clk_i),.rst_ni(rst_ni),.rf_data_hex(rf_data_hex));

//generating clk
 always begin
	clk_i = ~clk_i;
	#5;
end

//Clk initial value
initial begin
	clk_i = 1'b1;
end

// Variable for file operation
int fd;

// Checking Value
int a;
initial begin
    fd = $fopen("C:/Users/omer/Documents/GitHub/Dersler/MTH-RISCV/RISCV/logs/All_Instructions.log","w");
    rst_ni = 1'b0;
    #10;
    rst_ni = 1'b1;
    #10;
    $fwrite(fd,"LUI     ");
    a= 600*(2**12);
    if(a == uut.dp.rm.mem[1]) begin
        $fwrite(fd,"TRUE\n");
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    #10;
    $fwrite(fd,"AUIPC     ");
    a= (200*(2**12))+4;
    if(a == uut.dp.rm.mem[2]) begin
        $fwrite(fd,"TRUE\n");
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    #11;
    $fwrite(fd,"SB     ");
    a= 4;
    if(uut.dm.mem[5][15:8] == uut.dp.rm.mem[2][7:0]) begin
        $fwrite(fd,"TRUE\n");
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    #20;
    $fwrite(fd,"BNE and ADDI     "); 
    a= 10;
    if(uut.dp.rm.mem[3] == a) begin
        $fwrite(fd,"TRUE\n");
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    #20;
    $fwrite(fd,"JAL and SUB     "); 
    a= -10;
    if(uut.dp.rm.mem[5] == a) begin
        $fwrite(fd,"TRUE\n");
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    #30;
    $fwrite(fd,"BEQ and ADD and AND     "); 
    a= -10;
    if((uut.dp.rm.mem[6] == (uut.dp.rm.mem[1] + uut.dp.rm.mem[2])) ) begin
        if (uut.dp.rm.mem[7] == (uut.dp.rm.mem[3] & uut.dp.rm.mem[2])) begin
            $fwrite(fd,"TRUE\n");
        end
        else begin
            $fwrite(fd,"FALSE\n");
        end
    end
    else begin
        $fwrite(fd,"FALSE\n");
    end
    $fclose(fd);
    $finish;
end
endmodule