`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 07:17:53 PM
// Design Name: 
// Module Name: fast_sq_inv
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

module fast_sq_inv(input clk,
output reg[31:0]y4);
wire[31:0]x;
reg[31:0]magic=32'h5f3759df;
wire[31:0]shift_x;
wire[31:0]y0;
reg [31:0] dedh=32'h3fc00000;
reg [31:0] adha=32'h3f000000;

assign x=32'h40800000; /// testing for 4
assign shift_x=x>>1;
assign y0=magic-shift_x;

///iteration begins
reg [31:0]y_in;
wire [31:0]y_out;
wire [31:0] temp11,temp12,temp13,temp14,temp15;
//slack managment
reg [3:0]count_clk;
initial count_clk=0;
always@(posedge clk)
begin
if(count_clk ==0)
y_in=y0;

if(count_clk==4)
y_in=y_out;

if(count_clk==8)
y_in=y_out;

if(count_clk==12)
y_in=y_out;

if(count_clk==15)
y4=y_out;

count_clk=count_clk+1;
end
//end slack managment
////iteration1
floating_multiplication floating_multiplication11(clk,y_in,dedh,temp11);			//#1,1clk
floating_multiplication floating_multiplication12(clk,x,adha,temp12);				//#1,1clk
floating_multiplication floating_multiplication13(clk,y_in,y_in,temp13);			//#1,1clk
floating_multiplication floating_multiplication14(clk,y_in,temp12,temp14);			//#2,1clk
floating_multiplication floating_multiplication15(clk,temp13,temp14,temp15);		//#3,1clk
floating_adder add11(clk,temp11,{1'b1,temp15[30:0]},y_out);							//#4,1clk

endmodule
