`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2019 01:52:32 PM
// Design Name: 
// Module Name: floating_adder
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


module floating_adder(input clk,
input wire [31:0]a,
input wire [31:0]b,
output reg [31:0]sum
);
reg control;  // 0=add, 1=sub
reg [24:0]buffer_sum;
reg [23:0]a_buff_m;                   // for putting '1' begining of mantissa
reg [23:0]b_buff_m;                   // for putting '1' begining of mantissa
reg [7:0]a_buff_e;                   // for operating exponents
reg [7:0]b_buff_e;                   // for operating exponents
reg [7:0]expo_compare_agb;         // exponent a greater than b
reg [7:0]expo_compare_bga;         // exponent b greater than a
//reg subtract_sign_buffer;			//stores subtract_sign_buffer 
reg sub_sign_compare_buffer;    // for checking what is bigger in subtration for sign
//test registers
reg test_equal;
//assign a=32'h40a00000;	//5
//assign a=32'h3f400000;	//0.75
//assign a=32'hbf400000;	//-0.75
//assign a=32'h3f5d0000;	//0.86328125
//assign a=32'hbf5d0000;	//-0.86328125
//assign a=32'h41c80000;	//25
//assign b=32'hc1c80000;	//-25
//assign a=32'h41d80000;	//27
//assign a=32'hc1d80000;	//-27
//assign a=32'h41f80000;	//31
//assign a=32'hc1f80000;	//-31
//assign b=32'hbf800000;	//-1
//end test registers

always@(posedge clk)
begin
if(a[31]+b[31]==0)
begin
control=0;
end
else if (a[31]+b[31] ==2'b10)
begin
control=0;
end
else
begin
control=1;
end
//resting values

//end resting values
end

always@(negedge clk)
begin
expo_compare_agb = a[30:23]-b[30:23];   //getting value for shifting
expo_compare_bga = b[30:23]-a[30:23];   //getting value for shifting
a_buff_m = {1'b1,a[22:0]};
b_buff_m = {1'b1,b[22:0]};
a_buff_e = a[30:23];
b_buff_e = b[30:23];


if(control==0)  //addittion
begin
sum[31]=a[31];          //assigning value of sign bit
if(a[30:23]==b[30:23])  //expon equal
begin
buffer_sum[24:0]=a_buff_m[23:0]+b_buff_m[23:0];
    if(buffer_sum[24]==1)
	begin
	sum[22:0]=buffer_sum[23:1];
    sum[30:23]=a[30:23]+1;
    end
	else
	begin
    sum[22:0]=buffer_sum[22:0];
	sum[30:23]=a[30:23];
	end
end

else if(a[30:23]>b[30:23])   //mantissa a is greater than b
begin
    b_buff_m = b_buff_m>>expo_compare_agb;
    b_buff_e[7:0] = b_buff_e[7:0]+expo_compare_agb;

    buffer_sum[24:0]=a_buff_m[23:0]+b_buff_m[23:0];
	if(buffer_sum[24]==1)
	begin
	sum[22:0]=buffer_sum[23:1];
	sum[30:23]=a[30:23]+1;
	end
	else
	begin
	sum[22:0]=buffer_sum[22:0];
	sum[30:23]=a[30:23];
	end
end

else                    //mantissa b is greater than a
begin
   a_buff_m = a_buff_m>>expo_compare_bga;
   a_buff_e[7:0] = a_buff_e[7:0]+expo_compare_bga;

    buffer_sum[24:0]=a_buff_m[23:0]+b_buff_m[23:0];
    if(buffer_sum[24]==1)
	begin
	sum[22:0]=buffer_sum[23:1];
    sum[30:23]=b[30:23]+1;
    end
	else
	begin
    sum[22:0]=buffer_sum[22:0];
	sum[30:23]=b[30:23];
	end
end
end

else        //subtration
begin

if(b[30:23]==a[30:23])
	begin
		sum[31]=a[31];
	end	
	
else if(a[30:23]>b[30:23])   		//mantissa a is greater than b
	begin
		b_buff_m = b_buff_m>>expo_compare_agb;
		b_buff_e[7:0] = b_buff_e[7:0]+expo_compare_agb;
		sum[31]=a[31];
	end
	

else if(b[30:23]>a[30:23])		//mantissa b is greater than a
	begin
		a_buff_m = a_buff_m>>expo_compare_bga;
		a_buff_e[7:0] = a_buff_e[7:0]+expo_compare_bga;
		sum[31]=b[31];
   end


//test
if(a[30:23]==b[30:23])
test_equal=1;
//end test

	//////for sign/////
	if(a_buff_m>b_buff_m)
	begin
		buffer_sum[23:0]=a_buff_m[23:0]-b_buff_m[23:0];
	end
	else
	begin
		sum[31]=b[31];
		buffer_sum[23:0]=b_buff_m[23:0]-a_buff_m[23:0];
	end
	////for sign/////
	if(buffer_sum[23]==1)
	begin
	sum[22:0]=buffer_sum[22:0];
	sum[30:23]=b_buff_e[7:0];
	end
	else if (buffer_sum[22]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-1;
	sum[22:0]=buffer_sum<<1;
	end
	else if (buffer_sum[21]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-2;
	sum[22:0]=buffer_sum<<2;
	end
	else if (buffer_sum[20]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-3;
	sum[22:0]=buffer_sum<<3;
	end
	else if (buffer_sum[19]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-4;
	sum[22:0]=buffer_sum<<4;
	end
	else if (buffer_sum[18]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-5;
	sum[22:0]=buffer_sum<<5;
	end
	else if (buffer_sum[17]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-6;
	sum[22:0]=buffer_sum<<6;
	end
	else if (buffer_sum[16]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-7;
	sum[22:0]=buffer_sum<<7;
	end
	else if (buffer_sum[15]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-8;
	sum[22:0]=buffer_sum<<8;
	end
	else if (buffer_sum[14]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-9;
	sum[22:0]=buffer_sum<<9;
	end
	else if (buffer_sum[13]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-10;
	sum[22:0]=buffer_sum<<10;
	end
	else if (buffer_sum[12]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-11;
	sum[22:0]=buffer_sum<<11;
	end
	else if (buffer_sum[11]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-12;
	sum[22:0]=buffer_sum<<12;
	end
	else if (buffer_sum[10]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-13;
	sum[22:0]=buffer_sum<<13;
	end
	else if (buffer_sum[9]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-14;
	sum[22:0]=buffer_sum<<14;
	end
	else if (buffer_sum[8]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-15;
	sum[22:0]=buffer_sum<<15;
	end
	else if (buffer_sum[7]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-16;
	sum[22:0]=buffer_sum<<16;
	end
	else if (buffer_sum[6]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-17;
	sum[22:0]=buffer_sum<<17;
	end
	else if (buffer_sum[5]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-18;
	sum[22:0]=buffer_sum<<18;
	end
	else if (buffer_sum[4]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-19;
	sum[22:0]=buffer_sum<<19;
	end
	else if (buffer_sum[3]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-20;
	sum[22:0]=buffer_sum<<20;
	end
	else if (buffer_sum[2]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-21;
	sum[22:0]=buffer_sum<<21;
	end
	else if (buffer_sum[1]==1)
	begin
	sum[30:23]=b_buff_e[7:0]-20;
	sum[22:0]=buffer_sum<<20;
	end
	else
	begin
	sum[30:23]=b_buff_e[7:0]-21;
	sum[22:0]=buffer_sum<<21;
	end

end

end

endmodule
