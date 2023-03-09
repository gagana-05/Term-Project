module tb();

reg clk;
reg reset;
reg mem_rbusy;
reg mem_wbusy;
reg [31:0] mem_rdata;

wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire [3:0] mem_wmask;
wire mem_rstrb;

// module instantiation

FemtoRV32 UUT(clk, mem_addr, mem_wdata, mem_wmask, mem_rdata, mem_rstrb, mem_rbusy, mem_wbusy, reset);




endmodule