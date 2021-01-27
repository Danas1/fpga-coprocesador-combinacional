`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2020 17:48:36
// Design Name: 
// Module Name: sig_on_counter
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


module sig_on_counter
    #(parameter MAX_COUNT = 10)(
    input logic clk, sig, rst,
    output logic max_reached, [4:0]count
    );
    //logic edge_det;
    //pos_edge_det(.clk(clk), .sig(sig), .edge_det(edge_det));
    always_ff @(posedge clk)begin
        if(rst) begin
            count <= 0;
            max_reached <= 0;
        end
        else if(sig) begin
            if(count < MAX_COUNT)begin
                count <= count + 1;
                max_reached <= 0;
            end
            else if(count == MAX_COUNT) begin
                count <= 0;
                max_reached <= 1;
            end
            else begin
                count <= count;
                max_reached <= 0;
            end
        end
    end
    
endmodule
