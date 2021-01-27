`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2020 16:21:48
// Design Name: 
// Module Name: coprocesador
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
`define eucDist 104
`define WIDTH 8 //Nuero de bits de cada elemento de los arreglos
`define LENGTH 1024 //Largo de los arreglos con los que se trabajara.




module coprocesador(
    input logic sys_clk, rx, 
    output logic tx, led, CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0]AN
    );
    
    //Creacion de señales 
    logic ena_A, wea_A, wea_B;
    logic [7:0]data_transmit; //Resultado de la operacion a enviar
    logic [7:0]rx_data; //Byte recivido desde el uart
    logic transmit; //Señal que indica cuand transmitir.
    logic is_transmitting;
    logic received; //Avisa cuando se recibio un byte
    logic [7:0]op; // Operacion que se le envia al procesador
    logic op_finished;
    logic [7:0]data_write;    //Datos que se escriben en la memoria.
    logic write_op_finished, proc_op_finished;
    logic [7:0]out_a[1023:0];
    logic [7:0]out_b[1023:0];
    logic clk, locked;

   clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
    // Status and control signals
    .reset(0), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk)
    );      // input clk_in1
    
 //Instanciacion UART 
uart_basic #(40_000_000, 115200) uwart(
.clk(clk),
.reset(0),
.rx(rx),
.rx_data(rx_data),
.rx_ready(received),
.tx(tx),
.tx_start(transmit),
.tx_data(data_transmit),
.tx_busy(is_transmitting));
    //Contador para dir.

//registros sipo de memoria.
sipo_reg #(`WIDTH, `LENGTH) mem_A(
.clk(clk),
.enable_write(wea_A),
.ser_in(data_write),
.par_out(out_a)
);

sipo_reg #(`WIDTH, `LENGTH) mem_B(
.clk(clk),
.enable_write(wea_B),
.ser_in(data_write),
.par_out(out_b)
);
//Modulo que controla la esritura en los registros.
write_mem(
.clk(clk),
.received(received), 
.op(op), 
.op_finished(write_op_finished), 
.wea_A(wea_A), 
.wea_B(wea_B), 
.data_in(rx_data), 
.data_write(data_write)
);


always_comb begin 
    if(op == `writeVec_A || op == `writeVec_B) 
        op_finished = write_op_finished;
    else 
        op_finished = proc_op_finished;
end

//Instanciacion del decodificador de comandos.
command_decoder(
.clk(clk),
 .data_in(rx_data),
 .op(op),
 .received(received),
 .op_finished(op_finished)
 );

Procesador(
    .clk(clk), 
    .is_transmitting(is_transmitting), 
    .op(op), 
    .out_a(out_a),
    .out_b(out_b), 
    .data_transmit(data_transmit), 
    .transmit(transmit),
    .op_finished(proc_op_finished),
    .CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG),
    .AN(AN)
    );
    

endmodule
