`timescale 1ns / 1ps

module InstructionMem_tb
//Defining module parameters
#(Depth = 128,Width = 32, IMemInitFile="/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/FilesToRead/Instruction.mem")();

// Creating the signals to drive the module

logic clk_i,reset_ni;
logic we0_tb;
logic [Width-1:0] wr_din0_tb;
logic [$clog2(Depth)+1:0] rd_addr0_tb,wr_addr0_tb;

wire [Width-1:0] rd_dout0_tb;

// Creating the values for loops
int i;

// To open file
int fd;

// Date integers // Will be used in log file naming
int  y; //stands for year
int  m; //stands for month
int  d; //stands for day

// For the name of the log file that will be created
string filename;

// Making necessary connections
InstructionMem #(.IMemInitFile(IMemInitFile),.Depth(Depth),.Width(Width)) uut 
(.clk(clk_i),.reset(reset_ni),.we0(we0_tb),
.wr_din0(wr_din0_tb),.rd_addr0(rd_addr0_tb),.wr_addr0(wr_addr0_tb),
.rd_dout0(rd_dout0_tb));

// Loading the memory to be tested
logic [Width-1:0] mem_test [Depth-1:0];
// After creation of the memory file  is pointed here
initial begin
   $readmemb(IMemInitFile,mem_test);  //Dont forget to make it readmemh
end


// Generating the clock
always begin
    clk_i = ~clk_i;
    #5;
end
initial begin
    clk_i = 1'b1;
end

//The testbench
initial begin
    // Too much to handle for vivado
    //  Thooose date assignments are valid for linux 
    //y = $("date +%y"); // Year assignment
    //m = $system("date +%m"); // Month assignment
    //d = $system("date +%d"); // Day assignment
    //$sformat(filename,"/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/logs/InstructionMemory.%d.log",m);
    
    
    fd = $fopen("/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/logs/InstructionMemory.log","w"); // For linux machine

    
    reset_ni = 1'b0;
    we0_tb = 1'b0;
    wr_addr0_tb = 'd0;
    we0_tb = 1'b0;
    wr_din0_tb = 'd0;
    #10;
    reset_ni = 1'b1;
    for ( i=0 ;i< Depth ;i=i+1 ) begin
        rd_addr0_tb = 4*i;
        #5;
        $fwrite(fd,"Expected Value is = %h, Generated one is = %h",mem_test[i],rd_dout0_tb);
        $fwrite(fd,"Read addres is = %d ", rd_addr0_tb/4);
        if (mem_test[i] == rd_dout0_tb) begin
            $fdisplay(fd," True for %d",i);
        end
        else begin
            $fdisplay("False   ");
        end
        $fdisplay(fd,"\n--------------------------------------------------");
        #5;
    end
    $fclose(fd);
    $finish;
end


endmodule