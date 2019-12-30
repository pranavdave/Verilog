`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2019 12:53:19 PM
// Design Name: 
// Module Name: matrix_multi
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


module matrix_multi(input clk,
input wire[127:0] buff_x,
output wire[95:0] buff_y);
//buff_x = (4x1) matrix of 32 bit each element = 128 bits
//buff_y = (3x1) matrix of 32 bit each element = 96 bits
//buff_a = (3x4) matrix of 32 bit each element = 384 bits

//test
//x =  4080000040e0000040c0000000000000
//end test

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

wire [31:0]x1;
wire [31:0]x2;
wire [31:0]x3;
wire [31:0]x4;
assign x1 = buff_x[127:96];
assign x2 = buff_x[95:64];
assign x3 = buff_x[63:32];
assign x4 = buff_x[31:0];

wire [31:0]add00;
wire [31:0]add01;
wire [31:0]add02;
wire [31:0]add10;
wire [31:0]add11;
wire [31:0]add12;
wire [31:0]add20;
wire [31:0]add21;
wire [31:0]add22;

wire [31:0]mul00;
wire [31:0]mul01;
wire [31:0]mul02;
wire [31:0]mul03;
wire [31:0]mul10;
wire [31:0]mul11;
wire [31:0]mul12;
wire [31:0]mul13;
wire [31:0]mul20;
wire [31:0]mul21;
wire [31:0]mul22;
wire [31:0]mul23;

/////////////////////////////////////////////////////
floating_multiplication mult00(clk,A[0][0],x1,mul00);
floating_multiplication mult01(clk,A[0][1],x2,mul01);
floating_multiplication mult02(clk,A[0][2],x3,mul02);
floating_multiplication mult03(clk,A[0][3],x4,mul03);
/////////////////////////////////////////////////////
floating_multiplication mult10(clk,A[1][0],x1,mul10);
floating_multiplication mult11(clk,A[1][1],x2,mul11);
floating_multiplication mult12(clk,A[1][2],x3,mul12);
floating_multiplication mult13(clk,A[1][3],x4,mul13);
/////////////////////////////////////////////////////
floating_multiplication mult20(clk,A[2][0],x1,mul20);
floating_multiplication mult21(clk,A[2][1],x2,mul21);
floating_multiplication mult22(clk,A[2][2],x3,mul22);
floating_multiplication mult23(clk,A[2][3],x4,mul23);
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
floating_adder ad00(clk,mul00,mul01,add00);
floating_adder ad01(clk,mul02,mul03,add01);
floating_adder ad02(clk,add00,add01,add02);
/////////////////////////////////////////////////////
floating_adder ad10(clk,mul10,mul11,add10);
floating_adder ad11(clk,mul12,mul13,add11);
floating_adder ad12(clk,add10,add11,add12);
/////////////////////////////////////////////////////
floating_adder ad20(clk,mul20,mul21,add20);
floating_adder ad21(clk,mul22,mul23,add21);
floating_adder ad22(clk,add20,add21,add22);
/////////////////////////////////////////////////////

assign buff_y[95:64]=add02;
assign buff_y[63:32]=add12;
assign buff_y[31:0]=add22;

endmodule