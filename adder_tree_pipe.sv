`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2020 20:36:50
// Design Name: 
// Module Name: adder_tree_pipe
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


module adder_tree_comb #(
parameter WIDTH = 8, //Cantidad de bits que usa cada elemento del arreglo
parameter LENGTH = 512)//Largo del arreglo
 (
input logic clk,
input logic [WIDTH - 1:0]array_a[LENGTH-1:0],
input logic [WIDTH - 1:0]array_b[LENGTH-1:0],
output logic [$clog2(LENGTH*2) + WIDTH:0]result
    );
    
localparam STAGES = $clog2(LENGTH*2);  //Calculo del numero de etapas necesarias para la operacion.

generate 
    for(genvar i = 0; i < STAGES; i++) begin: stage
        logic [WIDTH + i:0]inside_sum[LENGTH/(2**i) -1 :0];//Generacion de variables internas.
        if(i == 0)
            for(genvar j = 0; j < LENGTH; j++)
                assign inside_sum[j] = array_a[j] + array_b[j]; //Primera etapa donde se suman los valores de los arreglos.
        else if( i == STAGES - 1) begin
                assign   result = stage[i-1].inside_sum[0]  + stage[i-1].inside_sum[1];  //Asignacion de etapa final
        end   
        else
            for(genvar k = 0; k < LENGTH/(2**i); k++)
                assign inside_sum[k] = stage[i-1].inside_sum[k*2] + stage[i-1].inside_sum[k*2 + 1]; //Asignacion de etapas intermedias
        end
endgenerate

endmodule
