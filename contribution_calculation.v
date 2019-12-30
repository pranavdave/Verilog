`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2019 06:33:49 PM
// Design Name: 
// Module Name: contribution_calculation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Will give most weightage column of sensing matrix taking input of "y"
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module contribution_calculation(input clk,
input wire[95:0] buff_y,
output reg[1:0]column_no);
/////////////////////////////////////////////test//////////////
//buff_y=c15000004000000041260000;
/////////////////////////////////////end test//////////////
////////////////define variable for column finding////////////////////////////////
reg [31:0]max_buff;
reg [1:0]max_count;
reg[2:0]delay_count=0;
reg[1:0] i=0;
///////////////define variable for column finding////////////////////////////////
//defining constant ensing matrix values
wire [31:0]A[0:2][0:3];			// defining 3x4 matrix
assign A[0][0] = 32'h3f000000;	//0.5
assign A[0][1] = 32'hbfc00000;	//-1.5
assign A[0][2] = 32'hbf400000;	//-0.75  
assign A[0][3] = 32'hbf600000;	//-0.875
assign A[1][0] = 32'h3f400000;	//0.75
assign A[1][1] = 32'h3f000000;	//0.5
assign A[1][2] = 32'hbf400000;	//-0.75
assign A[1][3] = 32'hbfa00000;	//-1.25
assign A[2][0] = 32'h3f400000;	//0.75
assign A[2][1] = 32'hbe000000;	//-0.125
assign A[2][2] = 32'h3fb00000;	//1.375
assign A[2][3] = 32'h3e800000;	//0.25
//end defining constant ensing matrix values
///divding wire of input
wire [31:0]y1;
wire [31:0]y2;
wire [31:0]y3;
assign y1 = buff_y[95:64];
assign y2 = buff_y[63:32];
assign y3 = buff_y[31:0];
///end dividing wires of input
//////add no. of columns///
reg [31:0]column[0:3];
//reg [31:0]column2;
//reg [31:0]column3;
//reg [31:0]column4;
///end add no. of columns///
//////adders and multipliers buffers
wire [31:0]mul00;
wire [31:0]mul01;
wire [31:0]mul02;
wire [31:0]mul10;
wire [31:0]mul11;
wire [31:0]mul12;
wire [31:0]mul20;
wire [31:0]mul21;
wire [31:0]mul22;
wire [31:0]mul30;
wire [31:0]mul31;
wire [31:0]mul32;
wire [31:0]add00;
wire [31:0]add01;
wire [31:0]add10;
wire [31:0]add11;
wire [31:0]add20;
wire [31:0]add21;
wire [31:0]add30;
wire [31:0]add31;
//////end adders and multipliers buffers
//////////////////////////////////////////////////////
floating_multiplication mult00(clk,A[0][0],y1,mul00);
floating_multiplication mult01(clk,A[1][0],y2,mul01);
floating_multiplication mult02(clk,A[2][0],y3,mul02);
floating_multiplication mult10(clk,A[0][1],y1,mul10);
floating_multiplication mult11(clk,A[1][1],y2,mul11);
floating_multiplication mult12(clk,A[2][1],y3,mul12);
floating_multiplication mult20(clk,A[0][2],y1,mul20);
floating_multiplication mult21(clk,A[1][2],y2,mul21);
floating_multiplication mult22(clk,A[2][2],y3,mul22);
floating_multiplication mult30(clk,A[0][3],y1,mul30);
floating_multiplication mult31(clk,A[1][3],y2,mul31);
floating_multiplication mult32(clk,A[2][3],y3,mul32);
//////////////////////////////////////////////////////
floating_adder ad00(clk,mul00,mul01,add00);
floating_adder ad01(clk,add00,mul02,add01);
floating_adder ad10(clk,mul10,mul11,add10);
floating_adder ad11(clk,add10,mul12,add11);
floating_adder ad20(clk,mul20,mul21,add20);
floating_adder ad21(clk,add20,mul22,add21);
floating_adder ad30(clk,mul30,mul31,add30);
floating_adder ad31(clk,add30,mul32,add31);
//////////////////////////////////////////////////////
////////////////////making positive value/////////////////////////
always@(posedge clk)
begin
column[0]={1'b0,add01[30:0]};
column[1]={1'b0,add11[30:0]};
column[2]={1'b0,add21[30:0]};
column[3]={1'b0,add31[30:0]};
///////////////////////////////////
column_no=max_count;
end
/////////////////////end postive value////////////////////
///////////////test//////////////
//result for test input 
// after 3 clk cycle
// column1 40320000 = 2.78125
// column2 4199a000	= 19.203125
// column3 41b42000 = 22.515625
// column4 41378000 = 11.46875
///////////end test//////////////
///////////neeed to find now maximum of above columns//////////

always@(negedge clk)
begin
if(delay_count==4)
begin
	max_buff=column[0];
	for(i=2'b00;i<2'b11;i=i+1'b1)
	begin
		if(column[i]>max_buff)
		begin
			max_buff=column[i];
			max_count=i;
		end
		else
		begin
			max_count=0;
		end
	end	
	delay_count=0;
end
else
begin
	delay_count=delay_count+1;
end
end
//////////end neeed to find now maximum of above columns///////
endmodule
