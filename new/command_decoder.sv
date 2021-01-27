`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2020 18:11:39
// Design Name: 
// Module Name: command_decoder
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

`define idle 0
`define writeVec_A 97
`define writeVec_B 98
`define readVec_A 99
`define readVec_B 100
`define sumVec 101
`define avgVec 102
`define manDist 103


module command_decoder(
    input logic clk,  received, op_finished,
    input logic [7:0]data_in,
    output logic [7:0]op
    );
//Declarations:------------------------------
logic [7:0]FSM_in;

//Maquina de estado que controla la operacion que se realiza.
always_comb begin //Bloquea las operaciones mientras no se haya terminado la anterior.
    if(op == `idle && received) FSM_in = data_in;
    else FSM_in = 0;
end

com_dec_FSM (.clk(clk), .data_in(FSM_in),  .op(op), .op_finished(op_finished));


endmodule
