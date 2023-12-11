`timescale 1ns / 1ps

module PC_tb;

logic clk,reset;
logic Branch;
logic [6:0] opcode;
logic [31:0] Imm,RS1_in;
wire [31:0] PC;


ProgramCounter uut (.clk(clk),.reset(reset),.Branch(Branch),.opcode(opcode),.Imm(Imm),.RS1_in(RS1_in),.PC(PC));

//generating clk
always begin
	clk = ~clk;
	#5;
end

//Clk initial value
initial begin
	clk = 1'b1;
end

//Integer for log file
int fd;
reg [31:0] PC_tmp;


//Testbench
initial begin
	//opening the log file
	fd = $fopen("/home/omer/Desktop/Dersler-git/Dersler/MTH-RISCV/RISCV/logs/PC.log","w");

	//Assigning to predict PC
	PC_tmp = 0;

	reset =1'b0;
	Branch = 1'b0;
	opcode = 7'd0;
	Imm = 32'd0;
	RS1_in = 32'd0;
	#5;
	//Branch Condition
	reset=1'b1;
	Branch = 1'b1;
	opcode = 7'b1100011;
	Imm = 32'd20;
	RS1_in = 32'd5;
	PC_tmp = PC_tmp+Imm;
	#10;
	if ( PC == PC_tmp ) begin 
	       $fwrite(fd,"True For Branch Condition\n-------------------------\n");
       	end
	else begin
	 	$fwrite(fd,"False For Branch Condition\n------------------------\n");	
	end
	
	//JAL Condition
	reset=1'b1;
	Branch = 1'b1;
	opcode = 7'b1101111;
	Imm = 32'd40;
	RS1_in = 32'd5;
	#5;
	PC_tmp = PC_tmp + Imm;
	#5;
	if (PC == PC_tmp ) begin
		$fwrite(fd,"True for JAL instruction\n-------------------------\n");
	end
	else begin
		$fwrite(fd,"False for JAL instruction\n--------------------------\n ");
	end

	//JALR Condition
	reset=1'b1;
	Branch = 1'b1;
	opcode = 7'b1100111;
	Imm = 32'd60;
	RS1_in = 32'd15;
	#5;
	PC_tmp =  (Imm + RS1_in)&32'hFFFE;
	#5;
	if (PC == PC_tmp ) begin
		$fwrite(fd,"True for JALR  instruction\n------------------------\n");
	end
	else begin
		$fwrite(fd,"False for JALR instruction\n---------------------------\n");
	end
	#5;
	//Regular case
	reset=1'b1;
	Branch = 1'b1;
	opcode = 7'd0;
	Imm = 32'd60;
	RS1_in = 32'd25;
	#5;
	PC_tmp = PC_tmp+4;
	#5;
	if(PC == PC_tmp) begin
		$fwrite(fd,"True for regular cases\n--------------------------\n");
	end
	else begin
		$fwrite(fd,"False for regular cases\n---------------------------\n");
	end
	#5;
	$fclose(fd);
	$finish;
end
// Branch =>  PC = PC + IMM 7'b1100011: opcode for branch
//JAL => PC = PC+IMM   7'b1101111: opcode for JAL
//JALR => PC = PC+RS1_in+IMM , Check it again too much magic here  7'b1100111 PC <= RS1_in,Imm with LSB 0
//opcode for JALR

endmodule
