`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 05:12:58 PM
// Design Name: 
// Module Name: tb
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


module tb();

logic clk, rst, rx, SYNC, SCLK, D0, D1, tx;

top uut (.clk(clk), .rst(rst), .rx(rx), .SYNC(SYNC), .SCLK(SCLK), .D0(D0), .D1(D1), .tx(tx));

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    rst = 1'b0;
    #1 rst = 1'b1;
    #3 rst = 1'b0;
end

initial
begin
    repeat (5000) @(posedge clk);
    $finish;
end

endmodule
