`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 06:00:39 PM
// Design Name: 
// Module Name: memory
//////////////////////////////////////////////////////////////////////////////////

module memory #(parameter bits = 16, deep = 200) (input clk, rst, input [1:0] select, output logic [bits-1:0] data);

localparam nb = $clog2(deep);
logic [nb-1:0] cnt;

//deklaracja pami?ci 
(*ram_style = "block"*) reg [bits-1:0] mem [1:deep];
//inicjalizacja pami?ci
initial $readmemh("sin.mem", mem);

always @(posedge clk, posedge rst)
    if(rst)
        cnt <= 1'b0;
    else if (cnt == deep)
        cnt <= 1'b0;
    else
        cnt <= cnt + 1'b1;

always @(posedge clk)
    data <= mem[cnt];

endmodule
