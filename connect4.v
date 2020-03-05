`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:15:45 05/21/2015 
// Design Name: 
// Module Name:    connect4 
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
module connect4(
    input clk, //100Mhz master clock
    input [10:0] PixelX, // x position of pixel being painted
    input [10:0] PixelY, // y pos of ^
    input left, 
    input right,
    input select, //bottom button to place piece
    input reset,
    output reg [2:0] R,
    output reg [2:0] G,
    output reg [1:0] B
    );

wire RED;           
assign RED = 0;
wire BLACK;
assign BLACK = 1;

reg currPlayer;                 // 0: Red, 1: Black
reg [2:0] currColumn;           // player's selection 
reg [7:0] gameStatePIECE [7:0]; // 
reg [7:0] gameStateSIDE [7:0];

// Initialize game state data
reg [3:0] i;
reg [3:0] j;
initial begin
	currColumn <= 3;
	currPlayer <= RED;
	for (i = 0; i < 8; i = i + 1) begin 
        for (j = 0; j < 8; j = j + 1) begin
            gameStatePIECE[i][j] <= 0;
            gameStateSIDE[i][j] <= 0;
            end
		end
end

// Input Left/Right
always @(posedge left or posedge right) begin
    if (left == 1 && currColumn == 0)
        currColumn <= 7; // Wrap around
    else if (left == 1)
        currColumn <= currColumn - 1;

    if (right == 1 && currColumn == 7)
        currColumn <= 0; // Wrap around
    else if (right == 1)
        currColumn <= currColumn + 1;
    end

// Input Select
wire [2:0] highPos; // 
wire isNotEmpty; // determines if the column is empty
encoder8_3 _encoder(
    .data(gameStatePIECE[currColumn]),
    .O(highPos),
    .V(isNotEmpty)
    );

always @(posedge clk) begin
    // Determine top most position with encoder
    if (select == 1)
        if (isNotEmpty == 0) begin //column is empty
            gameStatePIECE[currColumn][0] <= 1;
            gameStateSIDE[currColumn][0] <= currPlayer;
            currPlayer <= ~currPlayer; // Change player turn
            end
        else if (highPos < 7) begin
            gameStatePIECE[currColumn][highPos+1] <= 1;
            gameStateSIDE[currColumn][highPos+1] <= currPlayer;
            currPlayer <= ~currPlayer; // Change player turn
            end
        // Do nothing if highPos == 7; column full

	// Reset
	if (reset == 1) begin
		currPlayer <= RED;
		for (i = 0; i < 8; i = i + 1) begin 
			gameStatePIECE[i] <= 0;
			gameStateSIDE[i] <= 0;
			end
		end

    end

// Display pixels
integer pixelCol;
integer pixelRow;
always @(posedge clk) begin
    pixelCol <= (PixelX - 120) / 70;
    pixelRow <= (PixelY - 60) / 60;

    if (PixelX < 122 || PixelX > 680 || PixelY < 60 || PixelY > 538) begin
        // Show current player color on border
        if (currPlayer == BLACK) begin
            // Black border
            R = 3'b000;
            G = 3'b000;
            B = 2'b00;
            end
        else begin
            // Red border
            R = 3'b111;
            G = 3'b000;
            B = 2'b00;
            end
        end
    else if (gameStatePIECE[pixelCol][7-pixelRow] == 1 &&
        ((PixelX - (155+pixelCol*70))*(PixelX - (155+pixelCol*70)) +
        (PixelY - (90+pixelRow*60))*(PixelY - (90+pixelRow*60))) <250) begin //???????
        // Check piece color
        if (gameStateSIDE[pixelCol][7-pixelRow] == BLACK) begin
            // Black
            R = 3'b000;
            G = 3'b000;
            B = 2'b00;
            end
        else begin
            // Red
            R = 3'b111;
            G = 3'b000;
            B = 2'b00;
            end
        end
    else if (pixelCol % 2 == pixelRow % 2) begin
        // Yellow checkerboard squares
        R = 3'b111;
        G = 3'b111;
        B = 2'b00;
        // Highlight column if selected
        if (pixelCol == currColumn) begin
            R = 3'b111;
            G = 3'b111;
            B = 2'b11;
            end
        end
    else begin
        // Blue default checkerboard
        R = 3'b000;
        G = 3'b000;
        B = 2'b11;
        // Highlight column if selected
        if (pixelCol == currColumn) begin
            R = 3'b111;
            G = 3'b111;
            B = 2'b11;
            end
        end
    end

endmodule
