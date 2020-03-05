`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:00:34 05/28/2015 
// Design Name: 
// Module Name:    encoder8_3 
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
module encoder8_3(
    input [7:0] data,
    output reg [2:0] O,
    output V
    );

assign V = |data; // Reduction
always @(data) begin
    casex(data)
        8'b00000001 : O = 0;
        8'b0000001x : O = 1;
        8'b000001xx : O = 2;
        8'b00001xxx : O = 3;
        8'b0001xxxx : O = 4;
        8'b001xxxxx : O = 5;
        8'b01xxxxxx : O = 6;
        8'b1xxxxxxx : O = 7;
        default: O = 3'bx;
    endcase
end
endmodule
