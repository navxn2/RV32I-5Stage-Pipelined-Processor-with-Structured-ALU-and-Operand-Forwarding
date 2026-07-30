

module INSTRUCTION_MEMORY(
    input [31:0] addr,
    output [31:0] instr
);

   reg [31:0] mem [0:1023];

    initial begin
        $readmemh("code.mem", mem);
    end
    assign instr = mem[addr[11:2]];

endmodule