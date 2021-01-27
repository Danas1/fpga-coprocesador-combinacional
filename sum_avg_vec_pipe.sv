`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2020 08:41:27
// Design Name: 
// Module Name: sum_avg_vec_pipe
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


module sum_avg_vec_comb #(
parameter WIDTH = 8,
parameter LENGTH = 1024
)
(
input logic clk,
input logic [WIDTH-1 :0]out_a[LENGTH-1:0],
input logic [WIDTH-1:0]out_b[LENGTH-1:0],
input logic [7:0]op,
output logic calc_ready,
output logic [7:0]aux_result[1023:0]
    );

localparam STAGES = 3;
localparam BYTES_TO_TRANSMIT = 1024; //Se asumira que se trabaja con vectores con elementos de 8 bits.
logic [$clog2(STAGES):0] count; //Cuenta los ciclos que han pasado desde que inicio la operacion.
logic enable_operation;
logic [WIDTH:0]result[LENGTH - 1:0];

assign enable_operation  = (op ==`sumVec || op == `avgVec);
assign calc_ready = count == 1;
//OPERACION
always_comb begin
    for(int i = 0; i < LENGTH; i++) begin
        result[i] = out_a[i] + out_b[i];
    end
end

always_comb begin
    for(int j =0; j < LENGTH; j++)
        aux_result[j] <= result[j][8:1]; //Asigna los bits mas significativos al resultado a enviar.
end

//Espera a que la salida se estabilize.
always_ff @(posedge clk) begin 
    if(~enable_operation) begin
        count<=0;
    end
    else 
        count <= 1;
end




endmodule
