module REG4 (CLK, REGS_Read1, REGS_Read2, REGS_Write,
Addr1, Addr2, Data_In, Data_Out1, Data_Out2);
input CLK, REGS_Read1, REGS_Read2, REGS_Write;
input [1:0] Addr1, Addr2;
input [15:0] Data_In;
output [15:0] Data_Out1, Data_Out2;
reg [15:0] Data_Out1, Data_Out2;
reg [15:0] REG4 [0:3];
always @(*)                                              // asynchronous read
begin
if (REGS_Read1)
Data_Out1 = REG4[Addr1];
else
Data_Out1 = 'bZ;                                                // high impedance
if (REGS_Read2)
Data_Out2 = REG4[Addr2];
else
Data_Out2 = 'bZ;
end
always @(posedge CLK) // synchronous write
begin
if (REGS_Write)
REG4[Addr2] <= Data_In;
end
endmodule

module MEM4K (CLK, MEM_Read, MEM_Write, Addr, Data_In, Data_Out);
input CLK, MEM_Read, MEM_Write;
input [11:0] Addr; 
input [15:0] Data_In;
output [15:0] Data_Out;
reg [15:0] Data_Out;
reg [15:0] MEM4K [0:4095];
initial $readmemb("program.bin",MEM4K);   //Initialize Memory
always @(negedge CLK) // falling edge
begin
if (MEM_Read)
Data_Out<= MEM4K[Addr]; // synchronous read
else
Data_Out<= 'bZ;
if (MEM_Write)
MEM4K[Addr] <= Data_In; // synchronous write
end
endmodule

module ALU16 (OP, A, B, R, N, Z);
input [2:0] OP;
input [15:0] A, B;
output [15:0] R;
output N, Z;
reg [15:0] RI; // internal result
always @(*)
case (OP)
0 : RI = A; // Pass_A
1 : RI = A + B; // ADD
2 : RI = ~A; // INV
3 : RI = A & B; // AND
4 : RI = {A[14:0], 1'b0}; // SHL
5 : RI = {A[15], A[15:1]}; // ASHR
6 : RI = 0; // unassigned
7 : RI = B; // Pass_B
default : RI = 0;
endcase
assign R = RI;
assign N = RI[15];
assign Z = ~| RI;
endmodule

