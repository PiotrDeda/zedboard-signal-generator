`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 06:21:06 PM
// Design Name: 
// Module Name: decoder
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


module decoder(
    input clk, rst, rd,
    output logic en
    );
    
    logic en_rd, en_off;
    
    
    always @(posedge rst, negedge rd)
        if (rst)
            en_rd <= 1'b0;
        else if (en_off)
            en_rd <= 1'b0;
        else 
            en_rd <= 1'b1;
        
    
    always @(posedge clk, posedge rst)
        if (rst)
            en_off <= 1'b0;
        else if (en_rd)
            en_off <= 1'b1;
        else
            en_off <= 1'b0;
            
    assign en = en_rd ? (en_off ? 1'b0: 1'b1): 1'b0;
endmodule
