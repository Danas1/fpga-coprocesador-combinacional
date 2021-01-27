`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2020 16:50:20
// Design Name: 
// Module Name: BCD_to_7Segment
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


module BCD_to_7Segment(
    input logic [3:0]num,
    output logic [6:0]seg
    
    );
    //logic [6:0]seg;
    //assign seg ={CA,CB,CC,CD,CE,CF,CG};
    
    always_comb begin
        case(num)
            0 : seg = 7'b0000001;
            1 : seg = 7'b1001111;
            2 : seg = 7'b0010010;
            3 : seg = 7'b0000110;
            4 : seg = 7'b1001100;
            5 : seg = 7'b0100100;
            6 : seg = 7'b0100000;
            7 : seg = 7'b0001111;
            8 : seg = 7'b0000000;
            9 : seg = 7'b0000100;
        default: seg = 7'b1111111;
        endcase
    end
    
endmodule
