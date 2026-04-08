module matmul4x4_top (
    input  wire clk,
    input  wire rst,
    input  wire valid_in,

    // Matrix A (row-major)
    input  wire signed [7:0] A [0:3][0:3],

    // Matrix B (row-major)
    input  wire signed [7:0] B [0:3][0:3],

    // Output Matrix C
    output wire signed [17:0] C [0:3][0:3],
    output wire valid_out
);

    // =====================================
    // Internal valid signals per MAC
    // =====================================
    wire valid_mac [0:3][0:3];

    // =====================================
    // Generate 16 MAC units
    // =====================================
    genvar i, j;

    generate
        for (i = 0; i < 4; i = i + 1) begin : ROW
            for (j = 0; j < 4; j = j + 1) begin : COL

                mac4_element mac_inst (
                    .clk(clk),
                    .rst(rst),
                    .valid_in(valid_in),

                    // Row i of A
                    .a0(A[i][0]),
                    .a1(A[i][1]),
                    .a2(A[i][2]),
                    .a3(A[i][3]),

                    // Column j of B
                    .b0(B[0][j]),
                    .b1(B[1][j]),
                    .b2(B[2][j]),
                    .b3(B[3][j]),

                    // Output
                    .c_out(C[i][j]),
                    .valid_out(valid_mac[i][j])
                );

            end
        end
    endgenerate

    // =====================================
    // Global valid_out
    // (All MACs are aligned → take one)
    // =====================================
    assign valid_out = valid_mac[0][0];

endmodule
