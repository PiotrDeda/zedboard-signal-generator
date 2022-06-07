`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 06:00:39 PM
// Design Name: 
// Module Name: memory
//////////////////////////////////////////////////////////////////////////////////

module memory #(parameter bits = 16, deep = 200) (input clk, rst, [1:0] select, [5:0] ampl, output logic [bits-1:0] data);

localparam nb = $clog2(deep);
logic [nb-1:0] cnt;

(*ram_style = "block"*) reg [bits-1:0] mem_sin [1:deep];
initial $readmemh("sin.mem", mem_sin);

(*ram_style = "block"*) reg [bits-1:0] mem_saw [1:deep];
initial $readmemh("saw.mem", mem_saw);

(*ram_style = "block"*) reg [bits-1:0] mem_tri [1:deep];
initial $readmemh("tri.mem", mem_tri);

(*ram_style = "block"*) reg [bits-1:0] mem_exp [1:deep];
initial $readmemh("exp.mem", mem_exp);

always @(posedge clk, posedge rst)
    if(rst)
        cnt <= 1'b1;
    else if (cnt == deep)
        cnt <= 1'b1;
    else
        cnt <= cnt + 1'b1;

always @(posedge clk)
    if (select == 2'b00)
        data <= mem_saw[cnt] * (ampl + 1) / 64;
    else if (select == 2'b01)
        data <= mem_tri[cnt] * (ampl + 1) / 64;
    else if (select == 2'b10)
        data <= mem_sin[cnt] * (ampl + 1) / 64;
    else
        data <= mem_exp[cnt] * (ampl + 1) / 64;

endmodule
