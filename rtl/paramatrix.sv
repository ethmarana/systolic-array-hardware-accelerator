module paramatrix #(
    parameter int data = 8, 
    parameter int rows = 4,
    parameter int cols = 4,
    parameter int cwidth = 32
) (
    input logic clk,
    input logic reset, 
    input logic clear,
    input logic signed [data-1:0] a [0:rows-1],
    input logic signed [data-1:0] b [0:cols-1],
    output logic signed [cwidth-1:0] c [0:rows-1][0:cols-1]
 
);


logic signed [data-1:0] a_out [0:rows-1][0:cols-1];
logic signed [data-1:0] b_out [0:rows-1][0:cols-1];

genvar row, col;

generate 
    for (row = 0; row < rows; row++) begin : genrow
        for (col = 0; col < cols; col++) begin : gencol
            if (row == 0 && col == 0) begin
                mac #(.data(data), .cwidth(cwidth)) pe00 (
                    .clk(clk), 
                    .reset(reset),
                    .clear(clear),
                    .a(a[0]),
                    .b(b[0]),
                    .a_out(a_out[0][0]),
                    .b_out(b_out[0][0]),
                    .csum(c[0][0])
                );
            end else if (row == 0) begin
                mac #(.data(data), .cwidth(cwidth)) pe01 (
                    .clk(clk), 
                    .reset(reset),
                    .clear(clear),
                    .a(a_out[row][col-1]),
                    .b(b[col]),
                    .a_out(a_out[row][col]),
                    .b_out(b_out[row][col]),
                    .csum(c[row][col])
                );
            end else if (col == 0) begin
                mac #(.data(data), .cwidth(cwidth)) pe10 (
                    .clk(clk), 
                    .reset(reset),
                    .clear(clear),
                    .a(a[row]),
                    .b(b_out[row-1][col]),
                    .a_out(a_out[row][col]),
                    .b_out(b_out[row][col]),
                    .csum(c[row][col])
                );
            end else begin          
                mac #(.data(data), .cwidth(cwidth)) pegeneral (
                    .clk(clk), 
                    .reset(reset),
                    .clear(clear),
                    .a(a_out[row][col-1]),
                    .b(b_out[row-1][col]),
                    .a_out(a_out[row][col]),
                    .b_out(b_out[row][col]),
                    .csum(c[row][col])
                );
            end 
        end 
    end 
    

endgenerate

endmodule 