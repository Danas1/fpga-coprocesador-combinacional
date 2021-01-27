`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2020 17:32:50
// Design Name: 
// Module Name: 7_segment_driver
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

module sev_segment_driver(
    input logic clk,rst, [3:0]num[7:0],
    output logic CA,CB,CC,CD,CE,CF,CG, [7:0]AN
    );
   
    //initial AN = 8'b01111111;
    logic [6:0]seg_nxt;
    logic [19:0]count;
    logic [3:0]num_nxt;
    logic [7:0]AN_nxt;
    logic en_change;
    
    always_ff @(posedge clk or posedge rst) begin //Contador
        if(rst) begin
            count <= 0;
            en_change <= 0;
        end
        else if(count > 200000) begin
            count <= 0;
            en_change <= 1; //Permite el cambio de anodo
        end        
        else begin
            count <= count + 1; 
            en_change <= 0;
        end          
    end
        
    always_ff @(posedge clk or posedge rst)  begin //Cambio de estado
        if(rst) begin 
            {CA,CB,CC,CD,CE,CF,CG} <= 0;
            AN <= 8'b11111110;
        end
        else if(en_change) begin
            {CA,CB,CC,CD,CE,CF,CG} <= seg_nxt;
            AN <= AN_nxt;
        end
    end
    
    always_comb begin
            case(AN)
            8'b01111111:AN_nxt = 8'b10111111;
            8'b10111111:AN_nxt = 8'b11011111;
            8'b11011111:AN_nxt = 8'b11101111;
            8'b11101111:AN_nxt = 8'b11110111;
            8'b11110111:AN_nxt = 8'b11111011;
            8'b11111011:AN_nxt = 8'b11111101;
            8'b11111101:AN_nxt = 8'b11111110;
            8'b11111110:AN_nxt = 8'b01111111;         
            default AN_nxt = 8'b11111110;
            endcase
            case(AN_nxt)
            8'b01111111:num_nxt = num[0];
            8'b10111111:num_nxt = num[1];
            8'b11011111:num_nxt = num[2];
            8'b11101111:num_nxt = num[3];
            8'b11110111:num_nxt = num[4];
            8'b11111011:num_nxt = num[5];
            8'b11111101:num_nxt = num[6];
            8'b11111110:num_nxt = num[7];         
            default num_nxt = 10;
            endcase            
      end
  
            
          
    BCD_to_7Segment(.num(num_nxt), .seg(seg_nxt));
endmodule
