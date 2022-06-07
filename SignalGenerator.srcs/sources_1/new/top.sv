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


module top #(parameter bits = 16, deep = 8) (input clk, rst, rx, output SYNC, SCLK, D0, D1, tx);

localparam nb = $clog2(deep);
logic en;
logic [bits-1:0] data;
logic [1:0] select;
logic [5:0] freq;
logic [5:0] ampl;

wire [3:0] s_axi_awaddr;
wire [31:0] s_axi_wdata;
wire [3:0] s_axi_wstrb = 4'b1111;
wire [1:0] s_axi_bresp;
wire [3:0] s_axi_araddr;
wire [31:0] s_axi_rdata;
wire [1:0] s_axi_rresp;

wire [7:0] data_tr, data_rec;
wire [nb-1:0] addr;
  

// IP-core Xilinx UART z AXI4-Lite
axi_uartlite_0 slave_axi (
  .s_axi_aclk(clk),               // input wire s_axi_aclk
  .s_axi_aresetn(~rst),           // input wire s_axi_aresetn
  .interrupt(),                   // output wire interrupt
  
  .s_axi_awaddr(s_axi_awaddr),    // input wire [3 : 0] s_axi_awaddr
  .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
  
  .s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
  
  .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
  
  .s_axi_araddr(s_axi_araddr),    // input wire [3 : 0] s_axi_araddr
  .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
  
  .s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),    // input wire s_axi_rready
  
  .rx(rx),                        // input wire rx
  .tx(tx)                         // output wire tx
);

// master AXI4-Lite
master_axi #(.deep(deep)) master (.clk(clk), .rst(rst),
.awadr(s_axi_awaddr), .awvld(s_axi_awvalid), .awrdy(s_axi_awready),  // AW channel
.wdata(s_axi_wdata), .wvld(s_axi_wvalid), .wrdy(s_axi_wready),       // W channel
.bresp(s_axi_bresp), .bvld(s_axi_bvalid), .brdy(s_axi_bready),       // B channel
.aradr(s_axi_araddr), .arvld(s_axi_arvalid), .arrdy(s_axi_arready),  // AR channel
.rdata(s_axi_rdata), .rvld(s_axi_rvalid), .rrdy(s_axi_rready),       // R channel
.data_rec(data_rec), .data_tr(data_tr), .mem_addr(addr), .wr(wr), .rd(rd),
.select(select), .en_gen(en_gen), .freq(freq), .ampl(ampl));

// pamięć z próbkami sygnałów
memory #(.bits(bits)) storage (.clk(clkslow), .rst(rst), .select(select), .ampl(ampl), .data(data));

// SPI do DA1
spi #(.bits(bits)) spiToPmod (
    .clk(clk), .rst(rst), .en(en),
    .data2trans(data),
    .ss(SYNC), .sclk(SCLK), .mosi(D0)
);

// wolny zegar
clock_divider #(.div(250)) clkdiv (.clk(clk), .rst(rst), .freq(freq), .clkslow(clkslow));

// wysyłanie sygnału na wszystkie kanały
assign D1 = D0;

// cykliczny sygnał enable   
always @(posedge clk, posedge rst)
    if(rst)
        en <= 1'b0;
    else if (en == 1)
        en <= 1'b0;
    else if (clkslow == 1 && en_gen)
        en <= 1'b1;

endmodule
