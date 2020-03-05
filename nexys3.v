`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:35 05/19/2015 
// Design Name: 
// Module Name:    nexys3 
// Project Name: 
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
module nexys3(
    input clk,
    input btnU,
    input btnL,
    input btnD,
    input btnR,

    output Hsync,
    output Vsync,
    output reg [2:0] vgaRed,
    output reg [2:0] vgaGreen,
    output reg [1:0] vgaBlue
    );

clock _clock (
     .clk_in(clk),
     .clk_out50(clk50),
     .clk_outDB(clkdb)
     );

// Assign buttons
wire left;
debouncer _dbLeft(
    .dbfreq(clkdb),
    .btn_in(btnL),
    .btn_out(left)
    );
wire right;
debouncer _dbRight(
    .dbfreq(clkdb),
    .btn_in(btnR),
    .btn_out(right)
    );
wire select;
debouncer _dbSelect(
    .dbfreq(clkdb),
    .btn_in(btnD),
    .btn_out(select)
    );
wire reset;
debouncer _dbReset(
    .dbfreq(clkdb),
    .btn_in(btnU),
    .btn_out(reset)
    );

// VGA controller
reg clr = 0;
wire Hs;
assign Hsync = ~Hs;
wire Vs;
assign Vsync = ~Vs;
wire [10:0] PixelX;
wire [10:0] PixelY;
wire vidon;
vga_800x600 _vga(
    .clk(clk50),
    .clr(clr),
    .hsync(Hs),
    .vsync(Vs),
    .PixelX(PixelX),
    .PixelY(PixelY),
    .vidon(vidon)
    );

// Initialize game logic
wire [2:0] R;
wire [2:0] G;
wire [1:0] B;
connect4 _connect4(
    .clk(clk50),
    .PixelX(PixelX),
    .PixelY(PixelY),
    .left(left),
    .right(right),
    .select(select),
    .reset(reset),
    .R(R),
    .G(G),
    .B(B)
    );

// Output pixel values
always @(clk50) begin
    if (vidon) begin
        vgaRed[2:0] = R;
        vgaGreen[2:0] = G;
        vgaBlue[1:0] = B;
        end
    else begin
        vgaRed[2:0] = 3'b000;
        vgaGreen[2:0] = 3'b000;
        vgaBlue[1:0] = 2'b00;
        end
    end

endmodule
