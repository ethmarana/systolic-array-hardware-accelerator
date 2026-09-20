module mac #(
    parameter int data = 8, 
    parameter int cwidth = 32
    ) (
    input logic clk, 
    input logic reset,
    input logic clear, 
    input logic [data-1:0] a,
    input logic [data-1:0] b,
    output logic [data-1:0] a_out,
    output logic [data-1:0] b_out,
    output logic [cwidth-1:0] csum

);


always_ff @(posedge clk) begin
    if (reset || clear) begin
        csum <= 0;
        a_out <= 0;
        b_out <= 0; 
    end else begin 
        a_out <= a;
        b_out <= b;
        csum <= csum + (a * b); 
    end 
end 

endmodule 