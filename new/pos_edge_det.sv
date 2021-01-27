`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 21:51:52
// Design Name: 
// Module Name: pos_edge_det
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


module pos_edge_det(
    input logic clk, sig,
    output logic edge_det
    );
    logic sig_aux,sig_aux2;
    always_ff @(posedge clk) begin
        sig_aux2<= sig_aux;
        sig_aux <= sig;
        if(sig_aux && ~sig_aux2)
            edge_det <= 1;
        else
            edge_det <= 0;  
    end
endmodule
