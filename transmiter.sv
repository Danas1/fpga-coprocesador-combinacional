`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2020 21:24:13
// Design Name: 
// Module Name: transmiter
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


module transmiter

(
input logic clk, calc_finished, is_transmitting,
input logic [7:0]byte_to_send[NUM_BYTES-1:0], 
input logic [7:0]op,
output logic [7:0]tx_data,
output logic transmit, op_finished
    );
localparam NUM_BYTES = 1024; //Maximo numero de bytes que se pueden transmitir.
localparam COUNT_SIZE = $clog2(NUM_BYTES);

logic ready_to_transmit;
logic [COUNT_SIZE :0]count; //Cuenta la cantidad de bytes que se han enviado.
logic [COUNT_SIZE :0]bytes_to_send; //Bytes que deben ser transmitidos segun la operacion.


assign ready_to_transmit = ~transmit && ~is_transmitting;   



always_comb begin
    if(op == `manDist) bytes_to_send = 3;
    else if( op== `idle) bytes_to_send = 0;
    else bytes_to_send = 1024;
end
 
  

 always_ff @(posedge clk)begin //Indica cuando se envio un byte
    if(calc_finished)begin
        if(transmit & ~is_transmitting) count <= count + 1;
        else count <= count;
    end
    else
        count <= 0;
end

always_ff @(posedge clk) begin
    if(calc_finished)begin
        if(ready_to_transmit)begin //Dispositivo esta listo para transmitir
            transmit <= 1;
            tx_data <= byte_to_send[count];       
        end
        else begin
            transmit <= 0;
            tx_data <= tx_data; 
        end
    end
    else begin
        transmit <= 0;
        tx_data <= tx_data;
    end         
end


always_ff @(posedge clk) begin
    if(count == (bytes_to_send) && transmit) op_finished <= 1;
    else op_finished <= 0;
end

endmodule
