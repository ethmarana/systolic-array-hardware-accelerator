module matrixtb;
logic clk;
logic reset;
logic clear;
logic [7:0] a [0:1];
logic [7:0] b [0:1];
logic [31:0] c [0:1][0:1];
logic c0;
logic c1;
logic c2;
logic c3;

paramatrix #(.data(8), .rows(2), .cols(2)) instance1 (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .a(a),
    .b(b),
    .c(c)
);

initial begin 
    clk = 0; 
    forever #5 clk = ~clk;
end 

initial begin
  	c0 = 0;
  	c1 = 0;
  	c2 = 0;
  	c3 = 0;
    reset = 1'b1;
    @(posedge clk);
    @(negedge clk);
    reset = 1'b0;
    a[0]=1; a[1]=0; b[0]=5; b[1]=0;
    @(posedge clk);
    #5; 
    a[0]=2; a[1]=3; b[0]=7; b[1]=6;
    @(posedge clk);
    #5;
    a[0]=0; a[1]=4; b[0]=0; b[1]=8;
    @(posedge clk);
    #5;
    a[0]=0; a[1]=0; b[0]=0; b[1]=0;
    @(posedge clk);
    #5;

    if (c[0][0] == 19) begin
        $display("cell 0 pass");
        c0 = 1'b1; 
    end else begin
        $display("cell 0 fail, c0 = %0d", c[0][0]);
    end 
    if (c[0][1] == 22) begin
        $display("cell 1 pass");
        c1 = 1'b1;
    end else begin
        $display("cell 1 fail, c1 = %0d", c[0][1]);
    end 
    if (c[1][0] == 43) begin
        $display("cell 2 pass");
        c2 = 1'b1;
    end else begin
        $display("cell 2 fail, c2 = %0d", c[1][0]);
    end 
    if (c[1][1] == 50) begin
        $display("cell 3 pass");
        c3 = 1'b1;
    end else begin
        $display("cell 3 fail, c3 = %0d", c[1][1]);
    end 
    if (c0 && c1 && c2 && c3) begin
        $display("matrix passed");
    end else begin
        $display("matrix FAILED");
    end 
    $finish;
end 


endmodule 