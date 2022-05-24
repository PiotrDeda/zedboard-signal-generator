`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 04:43:41 PM
// Design Name: 
// Module Name: clkdiv
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

module clock_divider #(parameter div = 50) (input clk, rst, output logic clkslow);

localparam nb = $clog2(div);

logic [nb-1:0] cnt;

always @(posedge clk, posedge rst)
    if (rst)
        cnt <= {nb{1'b0}};
    else if (cnt == div - 1)
        cnt <= {nb{1'b0}};
    else
        cnt <= cnt + 1'b1;

always @(posedge clk, posedge rst)
    if (rst)
        clkslow <= 1'b0;
    else if (cnt == div - 1)
        clkslow <= 1'b1;
    else
        clkslow <= 1'b0;

endmodule
