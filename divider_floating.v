`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2019 07:17:53 PM
// Design Name: 
// Module Name: divider_floating
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

module divider_floating(input clk,
input wire [31:0]a,
input wire [31:0]b,
output reg [31:0]product
);
//product=a/b
//requires 2 	clk, 1 for multiplication other for rest operations

//wire [31:0]a = 31'h40800000;  //4
//wire [31:0]b = 31'h40800000;  //4
//reg [31:0]product;

//test cases;; use only IEEE754 format single precision
//assign a = 32'h40800000;  //4
//assign b = 32'h40f8a3d7;  //7.77
//enmd test cases

wire [24:0]temp_a;//={1'b1,a[22:0]};
wire [24:0]temp_b;//={1'b1,b[22:0]};

assign temp_a={1'b0,1'b1,a[22:0]};
assign temp_b={1'b0,1'b1,b[22:0]};

//division registers
reg[23:0]qut;
reg[23:0]qut_b;
reg[24:0]remin;
//reg complete;
//initial complete =1;
reg carry_flag;
reg stop_flag;
reg [4:0]counter;
reg [4:0]shift_e;

//case
parameter c0 = 5'd0;
parameter c1 = 5'd1;
parameter c2 = 5'd2;
parameter c3 = 5'd3;
parameter c4 = 5'd4;
parameter c5 = 5'd5;
parameter c6 = 5'd6;
parameter c7 = 5'd7;
parameter c8 = 5'd8;
parameter c9 = 5'd9;
parameter c10 = 5'd10;
parameter c11 = 5'd11;
parameter c12 = 5'd12;
parameter c13 = 5'd13;
parameter c14 = 5'd14;
parameter c15 = 5'd15;
parameter c16 = 5'd16;
parameter c17 = 5'd17;
parameter c18 = 5'd18;
parameter c19 = 5'd19;
parameter c20 = 5'd20;
parameter c21 = 5'd21;
parameter c22 = 5'd22;
parameter c23 = 5'd23;
parameter c24 = 5'd24;
parameter c25 = 5'd25;
parameter c26 = 5'd26;
parameter c27 = 5'd27;
parameter c28 = 5'd28;
parameter c29 = 5'd29;
parameter c30 = 5'd30;
parameter c31 = 5'd31;
//end case define
initial counter = c31;
initial qut=0;
initial carry_flag=0;
initial stop_flag=0;

always@(negedge clk)
begin
if(counter==5'd31)
begin
counter=5'd0;
remin = {1'b0,1'b1,a[22:0]};
end
else if(remin==0)
begin
if(stop_flag==0)
begin
counter = c24;
stop_flag=1;
end
end
end

always@(negedge clk)
begin
if(carry_flag==1)
begin
remin=remin<<1;
carry_flag=0;
end
end

always@(posedge clk)
begin
case(counter)

c30:
begin
if(a[30:23]==0)
product=0;
else if(b[30:0]==0)
product=32'hffffffff;	//infinity
else if(b[22:0]==0)
product[22:0]=a[22:0];
else
counter=c0;
end

c0:
begin
if(temp_b<=remin)
begin
qut[23]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[23]=0;
remin = remin<<1;
end
counter = c1;
end

c1:
begin
counter = c2;
if(temp_b<=remin)
begin
qut[22]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[22]=0;
remin = remin<<1;
end
end

c2:
begin
counter = c3;
if(temp_b<=remin)
begin
qut[21]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[21]=0;
remin = remin<<1;
end
end

c3:
begin
counter = c4;
if(temp_b<=remin)
begin
qut[20]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[20]=0;
remin = remin<<1;
end
end

c4:
begin
counter = c5;
if(temp_b<=remin)
begin
qut[19]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[19]=0;
remin = remin<<1;
end
end

c5:
begin
counter = c6;
if(temp_b<=remin)
begin
qut[18]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[18]=0;
remin = remin<<1;
end
end

c6:
begin
counter = c7;
if(temp_b<=remin)
begin
qut[17]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[17]=0;
remin = remin<<1;
end
end

c7:
begin
counter = c8;
if(temp_b<=remin)
begin
qut[16]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[16]=0;
remin = remin<<1;
end
end

c8:
begin
counter = c9;
if(temp_b<=remin)
begin
qut[15]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[15]=0;
remin = remin<<1;
end
end

c9:
begin
counter = c10;
if(temp_b<=remin)
begin
qut[14]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[14]=0;
remin = remin<<1;
end
end

c10:
begin
counter = c11;
if(temp_b<=remin)
begin
qut[13]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[13]=0;
remin = remin<<1;
end
end

c11:
begin
counter = c12;
if(temp_b<=remin)
begin
qut[12]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[12]=0;
remin = remin<<1;
end
end

c12:
begin
counter = c13;
if(temp_b<=remin)
begin
qut[11]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[11]=0;
remin = remin<<1;
end
end

c13:
begin
counter = c14;
if(temp_b<=remin)
begin
qut[10]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[10]=0;
remin = remin<<1;
end
end

c14:
begin
counter = c15;
if(temp_b<=remin)
begin
qut[9]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[9]=0;
remin = remin<<1;
end
end

c15:
begin
counter = c16;
if(temp_b<=remin)
begin
qut[8]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[8]=0;
remin = remin<<1;
end
end

c16:
begin
counter = 5'd17;
if(temp_b<=remin)
begin
qut[7]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[7]=0;
remin = remin<<1;
end
end

c17:
begin
counter = c18;
if(temp_b<=remin)
begin
qut[6]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[6]=0;
remin = remin<<1;
end
end

c18:
begin
counter = c19;
if(temp_b<=remin)
begin
qut[5]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[5]=0;
remin = remin<<1;
end
end

c19:
begin
counter = c20;
if(temp_b<=remin)
begin
qut[4]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[4]=0;
remin = remin<<1;
end
end

c20:
begin
counter = c21;
if(temp_b<=remin)
begin
qut[3]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[3]=0;
remin = remin<<1;
end
end

c21:
begin
counter = c22;
if(temp_b<=remin)
begin
qut[2]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[2]=0;
remin = remin<<1;
end
end

c22:
begin
counter = c23;
if(temp_b<=remin)
begin
qut[1]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[1]=0;
remin = remin<<1;
end
end

c23:
begin
counter = c24;
if(temp_b<=remin)
begin
qut[0]=1;
remin = remin-temp_b;
carry_flag=1;
end
else
begin
qut[0]=0;
remin = remin<<1;
//setting initial for shift_e
shift_e=0;
end
end

c24:
begin
counter=c25;
///for shift count
if(qut[23]==1)
shift_e=5'd1;
else if(qut[22]==1)
shift_e=5'd2;
else if(qut[21]==1)
shift_e=5'd3;
else if(qut[20]==1)
shift_e=5'd4;
else if(qut[19]==1)
shift_e=5'd5;
else if(qut[18]==1)
shift_e=5'd6;
else if(qut[17]==1)
shift_e=5'd7;
else if(qut[16]==1)
shift_e=5'd8;
else if(qut[15]==1)
shift_e=5'd9;
else if(qut[14]==1)
shift_e=5'd10;
else if(qut[13]==1)
shift_e=5'd11;
else if(qut[12]==1)
shift_e=5'd12;
else if(qut[11]==1)
shift_e=5'd13;
else if(qut[10]==1)
shift_e=5'd14;
else if(qut[9]==1)
shift_e=5'd15;
else if(qut[8]==1)
shift_e=5'd16;
else if(qut[7]==1)
shift_e=5'd17;
else if(qut[6]==1)
shift_e=5'd18;
else if(qut[5]==1)
shift_e=5'd19;
else if(qut[4]==1)
shift_e=5'd20;
else if(qut[3]==1)
shift_e=5'd21;
else if(qut[2]==1)
shift_e=5'd22;
else if(qut[1]==1)
shift_e=5'd23;
else
shift_e=5'd24;
//end for shift count
end

c25:
begin
product[31] = a[31]^b[31];               //sign
product[30:23] = a[30:23]-b[30:23]+127-shift_e+1; //exponents
qut_b=qut<<(shift_e-1);
product[22:0]=qut_b[22:0];
 //return reset
counter = c31;
qut=0;
carry_flag=0;
stop_flag=0;

end

endcase	//end case
end	//end psoedge clk


endmodule
