`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2020 17:16:15
// Design Name: 
// Module Name: sipo_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sipo_reg
#(parameter WIDTH = 8,
LENGTH = 1024) (
input logic [WIDTH-1:0]ser_in,
input logic clk, enable_write,
output logic [WIDTH-1:0]par_out[LENGTH-1:0]
    );
    
always_ff @(posedge clk)begin
    if(enable_write) begin
        par_out[LENGTH - 1] <= ser_in;
        for(int i = 1; i < LENGTH ; i++) begin
            par_out[LENGTH -i - 1] <= par_out[LENGTH - i]; 
        end
    end
end   
endmodule
