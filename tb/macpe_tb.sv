module mactb;

logic clk;
logic reset;
logic [7:0] a;
logic [7:0] b;
logic [7:0] a_out;
logic [7:0] b_out; 
logic [16:0] csum;

mac #(8, 2) instance1 (
    .clk(clk),
    .reset(reset),
    .a(a),
    .b(b),
    .a_out(a_out),
    .b_out(b_out),
    .csum(csum)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end 

initial begin
    reset = 1'b1; 
    @(posedge clk); 
    @(negedge clk);
    reset = 1'b0;
    a = 2;
    b = 3;
    @(posedge clk);
    #5;
    if (csum == 6) begin
        $display("mac1 passed");
    end else begin
        $display("mac1 FAILED, csum = %0d", csum);
    end 
    a = 4;
    b = 5;
    @(posedge clk);
    #5;
    if (csum == 26) begin
        $display("mac2 passed");
    end else begin
        $display("mac2 FAILED, csum = %0d", csum);
    end 
end 


endmodule 