module SCLK #(
    parameter div = 4
    )(
    input rst, clk,
    output logic serialClock);
    
    localparam nb = $clog2(div);
    logic [nb-1:0] counter;
    
    always @(posedge clk, posedge rst)
        if(rst)
            counter<= {nb{1'b0}};
        else if (counter == div -1)
            counter <= {nb{1'b0}};
        else
            counter <= counter + 1'b1;
    
    always @(posedge clk, posedge rst)
        if (rst)
            serialClock <= 1'b0;
        else if (counter <= div)
            serialClock <= 1'b1;
        else if (counter <= 2*div)
            serialClock <= 1'b0;
        else 
            serialClock <= 1'b0;
endmodule