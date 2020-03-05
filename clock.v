`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:34:11 05/14/2015 
// Design Name: 
// Module Name:    clock 
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
module clock(
    input clk_in,  // 100Mhz master clock
    output clk_out50,
    output clk_outDB
    );

Clock50 _clock50 (
    .CLK_IN(clk_in),
    .CLK_OUT(clk_out50),
    .CLKDB_OUT(clk_outDB)
    );

// 50Mhz clock
//reg hz50_en = 1;
//integer hz50_count = 0;
//assign clk_out50 = hz50_en;
//always @(posedge clk_in) begin
//    hz50_count = hz50_count + 1;
//    if (hz50_count == 2) begin
//        hz50_en = ~hz50_en;
//        hz50_count = 0;
//    end
//end

//reg db_en = 1;     // 800Hz?
//integer db_count = 0;
//assign clk_outD = db_en;
//always @(posedge clk3) begin
//    db_count = db_count + 1;
//    if (db_count == 22'b1001100010010110100000) begin
//        db_en = ~db_en;
//        db_count = 0;
//    end
//end

endmodule
