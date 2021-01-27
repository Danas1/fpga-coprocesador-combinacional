`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2020 09:12:43
// Design Name: 
// Module Name: read_vec_sipo
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


module read_vec_sipo #(
parameter WIDTH = 8,
parameter LENGTH = 1024
)
(
input logic clk,
input logic [WIDTH-1 :0]out_a[LENGTH-1:0],
input logic [WIDTH-1:0]out_b[LENGTH-1:0],
input logic [7:0]op,
output logic calc_ready,
output logic [WIDTH-1:0]out[LENGTH-1:0]
    );
    
logic [WIDTH-1:0]aux_result[LENGTH-1:0];
logic enable_operation;


assign enable_operation = (op == `readVec_A) || (op == `readVec_B);
assign calc_ready = enable_operation;
 
 
always_comb begin
    if(op == `readVec_A)
        out = out_a;
    else
        out = out_b;
end 


//transmiter #(LENGTH) read_tx(
//.clk(clk),
//.byte_to_send(aux_result),
//.tx_data(byte_send),
//.op_finished(op_finished),
//.transmit(transmit),
//.is_transmitting(is_transmitting),
//.calc_finished(calc_ready)
//);

endmodule
