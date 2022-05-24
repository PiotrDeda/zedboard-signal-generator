`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 07:16:50 PM
// Design Name: 
// Module Name: master_axi
//////////////////////////////////////////////////////////////////////////////////

module master_axi #(parameter deep = 16, nb = $clog2(deep)) (input clk, rst,
    output logic [3:0] awadr, output logic awvld, input awrdy,  //AW channel
    output [31:0] wdata, output logic wvld, input wrdy,   //W channel
    input [1:0] bresp, input bvld, output logic brdy,
    output logic [3:0] aradr, output logic arvld, input arrdy,  //AR channel
    input [31:0] rdata, input rvld, output logic rrdy,
    output logic [7:0] data_rec, input [7:0] data_tr, output [nb-1:0] mem_addr,
    output logic wr, rd
    );

//deklaracja stanów     
typedef enum {readstatus, waitstatus, read, waitread, command, write, waitwrite, waitresp} states_e;
states_e st, nst;
//znacznik kierunku transmisji "1" - odbiór, "0" - nadawanie
logic rec_trn;
//znacznik komendy "1" - komenda, "0" - dane
logic cmdm;
//liczba danych do przyj?cia/wys?ania; z komend StartFrameIn, StartFrameOut
logic [5:0] maxd;
//licznik adresu pami?ci
logic [nb-1:0] maddr;

//znacznik obeno?ci danych w kolejce wej?ciowej
wire rfifo_valid = ((st == waitstatus) & rvld) ? rdata[0] : 1'b0;
//znacznik zape?nienia kolejki wyj?ciowej
wire tfifo_full = ((st == waitstatus) & rvld) ? rdata[3] : 1'b0;

//rejestr stanów
always @(posedge clk, posedge rst)
    if(rst)
        st <= readstatus;
    else
        st <= nst;

//logika stanu nast?pnego        
always @* begin
    nst = readstatus;
    case(st)
        readstatus: nst = waitstatus;
        waitstatus: if(rec_trn)
                nst = rfifo_valid ? (rvld ?  read : waitstatus) : readstatus;
            else
                nst = tfifo_full ? readstatus : (rvld ? write : waitstatus);
        read: nst = waitread;
        waitread: nst = rvld ? (rdata[7] ? command : readstatus) : waitread;
        command: nst = readstatus;
        write: nst = waitwrite;
        waitwrite: nst = awrdy ? waitresp : waitwrite;
        waitresp: nst = bvld ? readstatus : waitresp;
    endcase 
end

//command decoder
always @(posedge clk)   //, posedge rst)
    if(rst) begin
        {rec_trn, cmdm} <= 2'b11;
        maxd <= 6'b0;
    end 
    else if(st == command) begin
        {rec_trn, cmdm} <= 2'b11;
        maxd <= rdata[5:0];
        case(rdata[7:6])
            2'b10: cmdm <= (rdata[5:0] == 6'b0) ? 1'b1 : 1'b0;
            2'b11: rec_trn <= 1'b0;
        endcase
    end else
        if (st == waitresp & maddr == maxd)
            {rec_trn, cmdm} <= 2'b11;
        
//memry address
//warunek ikrementacji adrresu w czasie odbioru
wire incar = ((st == waitread) & ~cmdm & rvld & rec_trn & (maddr < maxd));
//warunek ikrementacji adrresu w czasie wysy?ania 
wire incat = ((st == waitwrite) & cmdm & wrdy & ~rec_trn & (maddr < maxd));
//w czasie nadawania adres musi byc o 1 wi?kszy
assign mem_addr = rec_trn ? maddr : (maddr + 1);
always @(posedge clk)   //, posedge rst)
    if(rst)
        maddr <= {nb{1'b0}};
    else if (incar | incat)
        maddr <= maddr + 1'b1;
    else if((st == waitresp & maddr == maxd) | st == command)
        maddr <= {nb{1'b0}}; 

//read channels  
always @(posedge clk, posedge rst)
    if(rst)
        aradr <= 4'b0;
    else if (st == readstatus)
        aradr <= 4'h8;
    else if (st == read)
        aradr <= 4'h0;
always @(posedge clk, posedge rst)
    if(rst)
        arvld <= 1'b0;
    else if (st == readstatus | st == read)
        arvld <= 1'b1;
    else if(arrdy)
        arvld <= 1'b0;

always @(posedge clk, posedge rst)
    if(rst)
        rrdy <= 1'b0;
    else if ( (st == waitstatus | st == waitread) & rvld)
        rrdy <= 1'b1;   
    else
        rrdy <= 1'b0;           
        
always @(posedge clk, posedge rst)
    if(rst)
        data_rec <= 8'b0;
    else if(incar)
        data_rec <= rdata[7:0];
        
//memory write
always @(posedge clk)   //, posedge rst)
    if(rst)
        wr <= 1'b0;   
    else
        wr <= incar;

//write channels
always @(posedge clk, posedge rst)
    if(rst)
        awadr <= 4'b0;
    else if (st == write | st == waitwrite)
        awadr <= 4'h4;
    else 
        awadr <= 4'h0;
always @(posedge clk, posedge rst)
    if(rst)
        awvld <= 1'b0;
    else begin
        if (st == waitwrite)
            awvld <= 1'b1;
        if(awrdy)
            awvld <= 1'b0;     
    end

always @(posedge clk, posedge rst)
    if(rst)
        wvld <= 1'b0;
    else begin
        if(st == waitwrite)
            wvld <= 1'b1;
        if(awrdy)
            wvld <= 1'b0; 
    end
assign wdata = (st == waitwrite) ? {24'b0, data_tr} :  32'b0;     

always @(posedge clk, posedge rst)
    if(rst)
        brdy <= 1'b0;
     else begin
        if (st == write)
            brdy <= 1'b1;    
        if (bvld)
            brdy <= 1'b0;
     end
     
//memory read
always @(posedge clk)   //, posedge rst)
	if(rst)  
	   rd <= 1'b0;
	else
	   rd <= (st == write);
	         
endmodule
