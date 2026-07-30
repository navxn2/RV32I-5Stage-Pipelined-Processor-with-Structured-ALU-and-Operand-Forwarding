

// This is the Memory stage and it has asynchronous read but synchronous write operations .

module MEMORY_STAGE(
    input clk,
    input write_mem_control,
    input [31:0] alu_result,    
    input [31:0] write_data,   
    output [31:0] read_data     
);

    reg [31:0] mem [0:1023];
    always @(posedge clk) begin
        if(write_mem_control) begin
            mem[alu_result[11:2]] <= write_data;
        end
    end
    assign read_data = mem[alu_result[11:2]];

endmodule