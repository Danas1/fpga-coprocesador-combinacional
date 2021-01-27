`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2020 21:04:19
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Envia un pulso cada vez que se detecta cierto numero de pulsos de la señal.// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_counter
    #(parameter MAX_COUNT = 10)(
    input logic clk, sig, rst,
    output logic max_reached, [4:0]count
    );
    logic edge_det;
    pos_edge_det(.clk(clk), .sig(sig), .edge_det(edge_det));
    always_ff @(posedge clk)begin
        if(rst) begin
            count <= 0;
            max_reached <= 0;
        end
        else if(edge_det) begin
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
