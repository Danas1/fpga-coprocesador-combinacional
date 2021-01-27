`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2020 04:21:19
// Design Name: 
// Module Name: Procesador
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
`define readVec_A 99
`define readVec_B 100
`define sumVec 101
`define avgVec 102
`define manDist 103
`define eucDist 

module Procesador(
    input logic clk, is_transmitting,
    input logic [7:0]op, 
    input logic [7:0]out_a[1023:0],
    input logic [7:0]out_b[1023:0],
    output logic [7:0]data_transmit, 
    output logic transmit, op_finished,
    output logic CA,CB,CC,CD,CE,CF,CG,
    output logic [7:0]AN
    );

logic [7:0]result[1023:0];
logic [7:0]result_sum_avg[1023:0];
logic [7:0]result_man_dist[1023:0];
logic [7:0]result_read[1023:0];
logic calc_f_read,calc_f_man,calc_f_sum, calc_ready;
logic [18:0]num_to_disp;

always_ff @(posedge clk) begin
    if(op == `manDist && calc_f_man) begin
        result[0:2] <= result_man_dist[0:2];
        calc_ready <= 1;
    end
    else if(op == `readVec_A || op == `readVec_B  && calc_f_read)begin
        result <= result_read;
        calc_ready <= 1;
        end
    else if(op == `sumVec|| op == `avgVec && calc_f_sum)begin
        result <= result_sum_avg;
        calc_ready <= 1;
        end
    else 
        calc_ready <= 0;
end


read_vec_sipo read( 
.clk(clk),
.out_a(out_a),
.out_b(out_b),
.op(op),
.out(result_read),
.calc_ready(calc_f_read)
);
 
 
sum_avg_vec_comb sum(
.clk(clk),
.out_a(out_a),
.out_b(out_b),
.op(op),
.calc_ready(calc_f_sum),
.aux_result(result_sum_avg)
);

    
man_dist_comb manhattan(
.clk(clk),
.out_a(out_a),
.out_b(out_b),
.op(op),
.calc_ready(calc_f_man),
.aux_result(result_man_dist[2:0]),
.result(num_to_disp)
);



transmiter tx_uart(
.clk(clk),
.byte_to_send(result),
.tx_data(data_transmit),
.op(op),
.op_finished(op_finished),
.transmit(transmit),
.is_transmitting(is_transmitting),
.calc_finished(calc_ready)
);

Display_coproc(
.clk(clk), 
.in_num_to_disp(num_to_disp),
.op(op),
.CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG),
.AN(AN)
  );
   

endmodule
