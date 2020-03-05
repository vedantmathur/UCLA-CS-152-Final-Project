`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:23 05/19/2015 
// Design Name: 
// Module Name:    vga_800x600 
// Project Name: https://github.com/ThePedestrian/FPGA-Simple-Maze-Game-Using-VGA-Output
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module vga_800x600(
input wire clk, //100Mhz master clock
input wire clr, // ????
output reg hsync, // 1  bit horizontal sync
output reg vsync,
output reg [10:0] PixelX,
output reg [10:0] PixelY,
output reg vidon
    );

/*
    Questions to be answered:
    - everything
*/
parameter TotalHorizontalPixels = 11'd1040; // width of each row
parameter HorizontalSyncWidth = 11'd120; //
parameter VerticalSyncWidth = 11'd6;

parameter TotalVerticalLines = 11'd666;
parameter HorizontalBackPorchTime = 11'd184 ;
parameter HorizontalFrontPorchTime = 11'd984 ;
parameter VerticalBackPorchTime = 11'd43 ;
parameter VerticalFrontPorchTime = 11'd643;

reg VerticalSyncEnable;

reg [10:0] HorizontalCounter;
reg [10:0] VerticalCounter;

//Counter for the horizontal sync signal
always @(posedge clk)
begin
	if(clr == 1)
		HorizontalCounter <= 0;
	else
		begin
			if(HorizontalCounter == TotalHorizontalPixels - 1)
				begin //the counter has hreached the end of a horizontal line
					HorizontalCounter<=0;
					VerticalSyncEnable <= 1;
				end
			else
				begin 
					HorizontalCounter<=HorizontalCounter+1; 
					VerticalSyncEnable <=0;
				end
		end
end

//Generate the hsync pulse
//Horizontal Sync is low when HorizontalCounter is 0-127

always @(*)
begin
	if((HorizontalCounter<HorizontalSyncWidth))
		hsync = 1;
	else
		hsync = 0;
end

//Counter for the vertical sync

always @(posedge clk)
begin
	if(clr == 1)
		VerticalCounter<=0;
	else
	begin
		if(VerticalSyncEnable == 1)
			begin
				if(VerticalCounter==TotalVerticalLines-1)
					VerticalCounter<=0;
				else
					VerticalCounter<=VerticalCounter+1;
			end
	end
end

//generate the vsync pulse
always @(*)
begin
	if(VerticalCounter < VerticalSyncWidth)
		vsync = 1;
	else
		vsync = 0;
end

always @(posedge clk)
begin
	if((HorizontalCounter<HorizontalFrontPorchTime) && (HorizontalCounter>HorizontalBackPorchTime) && (VerticalCounter<VerticalFrontPorchTime) && (VerticalCounter>VerticalBackPorchTime))
		begin
			vidon <= 1;
			PixelX<= HorizontalCounter - HorizontalBackPorchTime;
			PixelY<= VerticalCounter - VerticalBackPorchTime;
		end
	else
		begin
			vidon <= 0;
			PixelX<=0;
			PixelY<=0;
		end
end

endmodule
