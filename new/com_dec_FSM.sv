`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2020 03:32:03
// Design Name: 
// Module Name: com_dec_FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:  Maquina de estado que controla el estado en el que se encuentra el coprocesador.
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

module com_dec_FSM(
    input logic clk, [7:0]data_in, op_finished,
    output logic [7:0]op, enable_a, enable_b
    );
    
 
//Declarations:------------------------------

 //FSM states type:
 typedef enum logic [3:0] {A, B, C, D, E, F, G, H, I} state;
 state pr_state, nx_state;

 //Statements:--------------------------------
initial begin
    nx_state <= A;
end
 //FSM state register:
 always_ff @(posedge clk) begin
	pr_state <= nx_state;
end
 //FSM combinational logic:
 always_comb
	case (pr_state)
		A: begin
			enable_a = 0;
			enable_b = 0;
			op = `idle;
            case (data_in)
            `writeVec_A : nx_state = B;
            `writeVec_B : nx_state = C;
            `readVec_A : nx_state = D;
            `readVec_B : nx_state = E;
            `sumVec : nx_state = F;
            `avgVec : nx_state = G;
            `manDist : nx_state = H;
            `eucDist: nx_state = I;
            default nx_state = A;
                        endcase
		end
 
		B: begin
            op = `writeVec_A;
            enable_a = 1;
            enable_b = 0;
			if (op_finished) nx_state = A;
			else nx_state = B;
		end
		C: begin
            op = `writeVec_B;
            enable_a = 0;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = C;
		end
		D: begin
            op = `readVec_A;
            enable_a = 1;
            enable_b = 0;
			if (op_finished) nx_state = A;
			else nx_state = D;
		end

		E: begin
            op = `readVec_B;
            enable_a = 0;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = E;
		end

		F: begin
            op = `sumVec;
            enable_a = 1;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = F;	
		end
		
		G: begin
            op = `avgVec;
            enable_a = 1;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = G;
		end
		
		H: begin
            op = `manDist;
            enable_a = 1;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = H;
		end

		I: begin
            op = `eucDist;
            enable_a = 1;
            enable_b = 1;
			if (op_finished) nx_state = A;
			else nx_state = I;
		end
		default begin
		    op = `idle;
		    enable_a = 0;
		    enable_b = 0;
		    nx_state = A;
		    end
	endcase

endmodule
