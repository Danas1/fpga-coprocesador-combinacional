`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2020 21:41:08
// Design Name: 
// Module Name: Display_coproc
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

module Display_coproc(
input logic clk, 
input logic [18:0]in_num_to_disp,
input logic [7:0]op,
output logic CA,CB,CC,CD,CE,CF,CG,
output logic [7:0]AN
    );
    
 logic [7:0]prev_op,act_op;
 logic enable_display;
 logic sig;
 logic [19:0]count;
 logic rst;
 logic [18:0]num_to_disp;
// logic [18:0]num_to_disp;
 
 //assign num_to_disp = 123456;
 
 assign enable_display = prev_op == `manDist;
 assign rst = ~enable_display;
 
 always_ff @(posedge clk)begin
    if(enable_display) num_to_disp <= in_num_to_disp;
 end
 always_ff @(posedge clk) begin
    act_op <= op;
    if(act_op != op) 
        prev_op <= act_op;
 end
 
always_ff @(posedge clk) begin
    if(~enable_display)
        count <= 0;
    else if(count < num_to_disp)
        count <= count + 1;
    else if(count == num_to_disp)
        count <= count;
    else
        count <= 0;       
end

always_ff @(posedge clk) begin
    if(~enable_display)
        sig <= 0;
    else if(count < num_to_disp)
        sig <= 1;
    else
        sig <= 0;  
end

logic [3:0]digit[7:0];
logic [3:0]aux_digit[7:0];
logic max1,max2,max3,max4,max5,max6,max7,max8;

sig_on_counter #(9) dig_1(.clk(clk), .sig(sig), .rst(rst), .count(digit[7]), .max_reached(max1));
pulse_counter #(9) dig_2(.clk(clk), .sig(max1), .rst(rst), .count(digit[6]), .max_reached(max2));
pulse_counter #(9) dig_3(.clk(clk), .sig(max2), .rst(rst), .count(digit[5]), .max_reached(max3));
pulse_counter #(9) dig_4(.clk(clk), .sig(max3), .rst(rst), .count(digit[4]), .max_reached(max4));
pulse_counter #(9) dig_5(.clk(clk), .sig(max4), .rst(rst), .count(digit[3]), .max_reached(max5));
pulse_counter #(9) dig_6(.clk(clk), .sig(max5), .rst(rst), .count(digit[2]), .max_reached(max6));
pulse_counter #(9) dig_7(.clk(clk), .sig(max6), .rst(rst), .count(digit[1]), .max_reached(max7));
pulse_counter #(9) dig_8(.clk(clk), .sig(max7), .rst(rst), .count(digit[0]), .max_reached(max8));

always_ff @(posedge clk) begin
    if(enable_display) begin
        for(int i = 0; i < 8; i++)
            aux_digit[i] <= digit[i];
    end
    else
        for(int i = 0; i < 8; i++)
            aux_digit[i] <= 10;
end

sev_segment_driver SAD(.clk(clk), .rst(0), .num(aux_digit),
.CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG),
.AN(AN)
);
endmodule
