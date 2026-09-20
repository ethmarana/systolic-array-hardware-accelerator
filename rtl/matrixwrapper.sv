module matrixwrapper #(
    parameter int data = 8,
    parameter int rows = 4,
    parameter int cols = 4,
    parameter int k = 4,
    parameter int cwidth = 32
) (
    input logic clk,
    input logic reset,
    input logic start,
    input logic [data-1:0] a [0:rows-1][0:k-1],
    input logic [data-1:0] b [0:k-1][0:cols-1],
    output logic [cwidth-1:0] c [0:rows-1][0:cols-1],
    output logic busy,
    output logic done

);

localparam int totalcycles = k + rows + cols - 2;
logic [data-1:0] a_feed [0:rows-1];
logic [data-1:0] b_feed [0:cols-1];
logic [$clog2(totalcycles)-1:0] cyclecount;
logic clear;

//moore fsm to handle task logic 

typedef enum logic [1:0] {
    sidle,
    sclear,
    srun,
    sdone
} states; 

states nextstate, currentstate;

//store state and counter to keep track of clock cycle

always_ff @(posedge clk) begin
    if (reset) begin
        currentstate <= sidle;
        cyclecount <= '0; 
    end else begin
        currentstate <= nextstate;
        if (currentstate == sclear) begin
            cyclecount <= '0;
        end else if (currentstate == srun) begin
            if (cyclecount < totalcycles-1) begin
                cyclecount <= cyclecount + 1'b1;
            end 
        end 
    end 

end 

always_comb begin
    nextstate = currentstate;
    clear = 1'b0;
    busy = 1'b0;
    done = 1'b0;
    for (int row = 0; row < rows; row++) begin
        a_feed[row] = '0;
    end

    for (int col = 0; col < cols; col++) begin
        b_feed[col] = '0;
    end

// combinational state logic 
    case(currentstate)
        sidle: begin
            if (start) begin
                nextstate = sclear; 
            end 
        end 
        sclear: begin
            clear = 1'b1;
            busy = 1'b1;
            nextstate = srun;
        end 
        srun: begin
            busy = 1'b1;
//feeding logic for each row / column based on cycle count
            for (int row = 0; row < rows; row++) begin
                if (cyclecount >= row) begin
                    if ((cyclecount - row) < k) begin
                        a_feed[row] = a[row][cyclecount - row];
                    end
                end
            end 
            
            for (int col = 0; col < cols; col++) begin
                if (cyclecount >= col) begin
                    if ((cyclecount - col < k)) begin
                        b_feed[col] = b[cyclecount-col][col];
                    end 
                end 
            end 

            if (cyclecount == totalcycles-1) begin
                nextstate = sdone;
            end 
        end 
        sdone: begin
            done = 1'b1;
            nextstate = sidle;
        end 
        default: begin 
            nextstate = sidle; 
        end 
    endcase 

end 

//mapping feeds to module ports

paramatrix #(
    .data(data),
    .rows(rows),
    .cols(cols),
    .cwidth(cwidth)
) instance1 (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .a(a_feed),
    .b(b_feed),
    .c(c)
);

endmodule