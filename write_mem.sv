`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2020 13:42:55
// Design Name: 
// Module Name: write_mem
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


module write_mem(
input logic clk, received,
input logic [7:0]data_in, op,
output logic [7:0]data_write,
output logic op_finished,  wea_A, wea_B
    );
 
    //Recepcion y escritura.
logic [9:0]count;
logic enable_a, enable_b, writing, operating;
assign enable_a = (op == `writeVec_A) ;
assign enable_b = (op == `writeVec_B) ;
assign operating = enable_a || enable_b;
assign writing = (enable_a || enable_b) && received && ~op_finished;
//Conteo de datos escritos.
always_ff @(posedge clk) begin //Determina cuantas veces se ha escrito un dato.
    if(writing) count <= count + 1;
    else if(operating)count <= count;
    else count <= 0;
end

always_ff @(posedge clk) begin //Determina cuando termina de escribir en memoria.
    if(count == 1023 && writing) op_finished <= 1;
    else op_finished <= 0;
end

always_ff @(posedge clk) begin //Habilita la escritura de un dato en alguno de los dos registros.
    if(enable_a && received) begin
        wea_A <= 1;
        wea_B <= 0;
        end
    else if(enable_b && received) begin
        wea_B <= 1;
        wea_A <= 0;
        end
    else begin
        wea_A <= 0;
        wea_B <= 0;
    end
end

always_ff @(posedge clk)begin
    data_write <= data_in;
end
endmodule
