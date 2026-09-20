module wraptb;
logic clk;
logic reset;
logic start;
logic [7:0] a [0:3][0:3];
logic [7:0] b [0:3][0:3];
logic [31:0] c [0:3][0:3];
logic busy;
logic done;


matrixwrapper #(
    .data(8), 
    .rows(4), 
    .cols(4), 
    .k(4),
    .cwidth(32)
    ) instance1(
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .c(c),
        .busy(busy),
        .done(done)
);  

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end 

initial begin
start = 1'b0;
reset = 1'b1;
// Matrix A
    a[0][0] = 1;  a[0][1] = 2;  a[0][2] = 3;  a[0][3] = 4;
    a[1][0] = 5;  a[1][1] = 6;  a[1][2] = 7;  a[1][3] = 8;
    a[2][0] = 9;  a[2][1] = 10; a[2][2] = 11; a[2][3] = 12;
    a[3][0] = 13; a[3][1] = 14; a[3][2] = 15; a[3][3] = 16;

// Matrix B
    b[0][0] = 1;  b[0][1] = 2;  b[0][2] = 3;  b[0][3] = 4;
    b[1][0] = 5;  b[1][1] = 6;  b[1][2] = 7;  b[1][3] = 8;
    b[2][0] = 9;  b[2][1] = 10; b[2][2] = 11; b[2][3] = 12;
    b[3][0] = 13; b[3][1] = 14; b[3][2] = 15; b[3][3] = 16;
repeat (2) @(posedge clk);
@(negedge clk)
reset = 1'b0;
@(negedge clk)
start = 1'b1;
@(negedge clk);;
start = 1'b0;
@(posedge done);

if (c[0][0] !== 90)  $error("c[0][0] wrong: %0d", c[0][0]);
if (c[0][1] !== 100) $error("c[0][1] wrong: %0d", c[0][1]);
if (c[0][2] !== 110) $error("c[0][2] wrong: %0d", c[0][2]);
if (c[0][3] !== 120) $error("c[0][3] wrong: %0d", c[0][3]);

if (c[1][0] !== 202) $error("c[1][0] wrong: %0d", c[1][0]);
if (c[1][1] !== 228) $error("c[1][1] wrong: %0d", c[1][1]);
if (c[1][2] !== 254) $error("c[1][2] wrong: %0d", c[1][2]);
if (c[1][3] !== 280) $error("c[1][3] wrong: %0d", c[1][3]);

if (c[2][0] !== 314) $error("c[2][0] wrong: %0d", c[2][0]);
if (c[2][1] !== 356) $error("c[2][1] wrong: %0d", c[2][1]);
if (c[2][2] !== 398) $error("c[2][2] wrong: %0d", c[2][2]);
if (c[2][3] !== 440) $error("c[2][3] wrong: %0d", c[2][3]);

if (c[3][0] !== 426) $error("c[3][0] wrong: %0d", c[3][0]);
if (c[3][1] !== 484) $error("c[3][1] wrong: %0d", c[3][1]);
if (c[3][2] !== 542) $error("c[3][2] wrong: %0d", c[3][2]);
if (c[3][3] !== 600) $error("c[3][3] wrong: %0d", c[3][3]);

$display("Matrix multiplication test finished.");

$finish; 
end 

endmodule 