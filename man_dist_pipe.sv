`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2020 20:35:31
// Design Name: 
// Module Name: man_dist_pipe
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
`define manDist 103

module man_dist_comb #(
parameter WIDTH = 8,
parameter LENGTH = 1024
)
(
input logic clk,
input logic [WIDTH-1 :0]out_a[LENGTH-1:0],
input logic [WIDTH-1:0]out_b[LENGTH-1:0],
input logic [7:0]op,
output logic calc_ready,
output logic [7:0]aux_result[2:0],
output logic [18:0]result
    );

//PARAMETROS
localparam ADDER_STAGES = $clog2(LENGTH);
localparam STAGES = ADDER_STAGES + 2; //etapas de pipeline antes de que un calculo este listo.
localparam int BYTES_RESULT = $ceil( $bits(result) / 8.0);

//LOGICA INTERNA
logic [$clog2(STAGES):0] count; //Cuenta los ciclos que han pasado desde que inicio la operacion.
logic [WIDTH-1:0]diff[LENGTH-1:0];  //Variable para almacenar el valor absoluto de la dif. entre elementos de los vectores.
logic [WIDTH-1:0]aux_diff[LENGTH-1:0];
//logic [$clog2(LENGTH) + WIDTH:0]result; //Resultado de la operacion.
logic enable_operation;
//Determina cuando en la salida esta estabilizado el resultado.


//
assign enable_operation = op == `manDist;
//assign calc_ready = count == 1;


// OPERACION A REALIZAR
always_comb begin //Primera etapa donde se obtiene el valor absoluto de la diferencia entre los elementos de ambos vectores.
        for(int i = 0; i < LENGTH; i++)begin
            if(out_a[i] > out_b[i])
                diff[i] = out_a[i] - out_b[i];
            else
                diff[i] = out_b[i] - out_a[i];
        end  
end



adder_tree_comb adder_tree(
    .clk(clk),
    .array_a(diff[511:0]),
    .array_b(diff[1023:512]),
    .result(result)
);

//Espera a que la salida se estabilize.
always_ff @(posedge clk) begin 
    if(~enable_operation) begin
        calc_ready<=0;
    end
    else
        calc_ready<= 1;
end

always_comb begin
        aux_result[0] = result[7:0];
        aux_result[1] = result[15:8];
        aux_result[2] = 8'(result[18:16]);  
end




endmodule
