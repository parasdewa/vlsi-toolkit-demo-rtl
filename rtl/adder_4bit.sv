// 4-Bit Ripple Carry Adder Top Module
module ripple_carry_adder_4bit (
    input [3:0] A,    // 4-bit input vector A
    input [3:0] B,    // 4-bit input vector B
    input Cin,        // Initial carry-in
    output [3:0] Sum, // 4-bit output sum vector
    output Cout       // Final carry-out bit
);

    // Internal wires to carry propagation between stages
    wire c1, c2, c3;

    // Instantiate 4 Full Adders (Structural connection)
    // format: module_name instance_name (.port_name(signal_name))
    full_adder FA0 (.a(A[0]), .b(B[0]), .cin(Cin), .sum(Sum[0]), .cout(c1));
    full_adder FA1 (.a(A[1]), .b(B[1]), .cin(c1),  .sum(Sum[1]), .cout(c2));
    full_adder FA2 (.a(A[2]), .b(B[2]), .cin(c2),  .sum(Sum[2]), .cout(c3));
    full_adder FA3 (.a(A[3]), .b(B[3]), .cin(c3),  .sum(Sum[3]), .cout(Cout));

endmodule
