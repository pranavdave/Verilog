`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2018 09:06:54 PM
// Design Name: 
// Module Name: multiplication
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

module floating_multiplication(input clk,
input wire [31:0]a,
input wire [31:0]b,
output reg [31:0]product
);
//requires 2 clk, 1 for multiplication other for rest operations

//wire [31:0]a = 31'h40800000;  //4
//wire [31:0]b = 31'h40800000;  //4
//reg [31:0]product;

//test cases;; use only IEEE754 format single precision
//assign a = 32'h40800000;  //4
//assign b = 32'h40f8a3d7;  //7.77
//enmd test cases

wire [47:0] buff;  // buffer for normalising after multplication of mantissa
wire [23:0]temp_a;//={1'b1,a[22:0]};
wire [23:0]temp_b;//={1'b1,b[22:0]};

//always@(negedge clk)
//begin
assign temp_a={1'b1,a[22:0]};
assign temp_b={1'b1,b[22:0]};
assign buff=temp_a*temp_b;     //multiplication of mantissa
//end

always@(posedge clk)
begin
if(a[30:23]==0)
product=0;
else if(b[30:23]==0)
product=0;
else if(a[30:23]==8'hff)
product=32'h7f800000;
else if(b[30:23]==8'hff)
product=32'h7f800000;
else
begin
//buff=temp_a*temp_b;     //multiplication of mantissa
product[31] = a[31]^b[31];               //sign
product[30:23] = a[30:23]+b[30:23]-127; //exponents    
//////////////////////////////// begin of normalising selecting most significant bits
if(buff[47]==1)
begin
product[22:0] = buff[46:24];
product[30:23] = a[30:23]+b[30:23]-127+1;
end
else if(buff[46]==1)
begin
product[22:0] = buff[45:23];
product[30:23] = a[30:23]+b[30:23]-127;
end
else if(buff[45]==1)
begin
product[22:0] = buff[44:22];
product[30:23] = a[30:23]+b[30:23]-127-1;
end
else if(buff[44]==1)
begin
product[22:0] = buff[43:21];
product[30:23] = a[30:23]+b[30:23]-127-2;
end
else if(buff[43]==1)
begin
product[22:0] = buff[42:20];
product[30:23] = a[30:23]+b[30:23]-127-3;
end
else if(buff[42]==1)
begin
product[22:0] = buff[41:19];
product[30:23] = a[30:23]+b[30:23]-127-4;
end
else if(buff[41]==1)
begin
product[22:0] = buff[40:18];
product[30:23] = a[30:23]+b[30:23]-127-5;
end
else if(buff[40]==1)
begin
product[22:0] = buff[39:17];
product[30:23] = a[30:23]+b[30:23]-127-6;
end
else if(buff[39]==1)
begin
product[22:0] = buff[38:16];
product[30:23] = a[30:23]+b[30:23]-127-7;
end
else if(buff[38]==1)
begin
product[22:0] = buff[37:15];
product[30:23] = a[30:23]+b[30:23]-127-8;
end
else if(buff[37]==1)
begin
product[22:0] = buff[36:14];
product[30:23] = a[30:23]+b[30:23]-127-9;
end
else if(buff[36]==1)
begin
product[22:0] = buff[35:13];
product[30:23] = a[30:23]+b[30:23]-127-10;
end
else if(buff[35]==1)
begin
product[22:0] = buff[34:12];
product[30:23] = a[30:23]+b[30:23]-127-11;
end
else if(buff[34]==1)
begin
product[22:0] = buff[33:11];
product[30:23] = a[30:23]+b[30:23]-127-12;
end
else if(buff[33]==1)
begin
product[22:0] = buff[32:10];
product[30:23] = a[30:23]+b[30:23]-127-13;
end
else if(buff[32]==1)
begin
product[22:0] = buff[31:9];
product[30:23] = a[30:23]+b[30:23]-127-14;
end
else if(buff[31]==1)
begin
product[22:0] = buff[30:8];
product[30:23] = a[30:23]+b[30:23]-127-15;
end
else if(buff[30]==1)
begin
product[22:0] = buff[29:7];
product[30:23] = a[30:23]+b[30:23]-127-16;
end
else if(buff[29]==1)
begin
product[22:0] = buff[28:6];
product[30:23] = a[30:23]+b[30:23]-127-17;
end
else if(buff[28]==1)
begin
product[22:0] = buff[27:5];
product[30:23] = a[30:23]+b[30:23]-127-18;
end
else if(buff[27]==1)
begin
product[22:0] = buff[26:4];
product[30:23] = a[30:23]+b[30:23]-127-19;
end
else if(buff[26]==1)
begin
product[22:0] = buff[25:3];
product[30:23] = a[30:23]+b[30:23]-127-20;
end
else if(buff[25]==1)
begin
product[22:0] = buff[24:2];
product[30:23] = a[30:23]+b[30:23]-127-21;
end
else if(buff[24]==1)
begin
product[22:0] = buff[23:1];
product[30:23] = a[30:23]+b[30:23]-127-22;
end
else
begin
product[22:0] = buff[22:0];
product[30:23] = a[30:23]+b[30:23]-127-23;
end
/////////////////////////////// end of normalising selecting most significant bits
end
end

endmodule
