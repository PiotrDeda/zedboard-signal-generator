`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 05:45:46 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer #(parameter ndb = 22) (input clk, button_in, output button_db);

logic [ndb-1:0] cnt = {ndb{1'b0}};
logic deb;

always @(posedge clk) 
    if (button_in)
        if (cnt != {ndb{1'b1}})
            cnt <= cnt + 1'b1;
    else
        cnt <= {ndb{1'b0}};

always @(posedge clk)
    if (cnt == {ndb{1'b1}})
        deb  <= 1'b1;
    else
        deb <= 1'b0;
       
assign button_db = deb;

endmodule
