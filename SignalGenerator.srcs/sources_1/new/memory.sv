`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 06:00:39 PM
// Design Name: 
// Module Name: memory
//////////////////////////////////////////////////////////////////////////////////

module memory #(parameter deep = 16) (input clk, rd, wr, 
    input [$clog2(deep)-1:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out);

//deklaracja pami?ci 
(*ram_style = "block"*) reg [7:0] mem [1:deep];
//inicjalizacja pami?ci
initial $readmemh("init_mem.mem", mem);

always @(posedge clk)
    if(wr)
        mem[addr] <= data_in;   //zapis do pami?ci
    else if(rd)
        data_out <= mem[addr];  //odczyt z pami?ci

endmodule
