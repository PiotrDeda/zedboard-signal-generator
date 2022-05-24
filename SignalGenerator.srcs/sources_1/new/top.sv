`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2022 06:18:12 PM
// Design Name: 
// Module Name: top
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


module top #(parameter bits = 16) (input clk, rst, en, output SYNC, SCLK, D0, D1);

logic [bits-1:0] data = 16'b0000_0000_1000_0000;
assign D1 = 1'b0;

debouncer deb (.clk(clk), .button_in(en), .button_db(en_deb));

spi #(.bits(bits)) spiToPmod (
    .clk(clk), .rst(rst), .en(en_deb),
    .data2trans(data),
    .ss(SYNC), .sclk(SCLK), .mosi(D0)
);

endmodule
