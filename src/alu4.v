module test_funcional (
    input  wire [3:0] A,        // Operando A (switches)
    input  wire [3:0] B,        // Operando B (registro B_reg)
    input  wire       resta,    // Selector: 0 = Suma, 1 = Resta
    output wire [3:0] result,   // Resultado aritmético (truncado a 4 bits)
    output wire       f_and,    // Indicador AND -> canal Rojo
    output wire       f_or,     // Indicador OR  -> canal Verde
    output wire       f_xor     // Indicador XOR -> canal Azul
);

    // Operaciones en paralelo (todas se calculan al mismo tiempo)
    wire [3:0] AND_result = A & B;                      // 1 donde ambos bits son 1
    wire [3:0] OR_result  = A | B;                      // 1 donde al menos un bit es 1
    wire [3:0] XOR_result = A ^ B;                      // 1 donde los bits son diferentes
    wire [3:0] SUM_result = resta ? (A - B) : (A + B);  // Multiplexor suma/resta

    assign result = SUM_result;

    // Reducción OR: cada indicador vale 1 si su resultado tiene algún bit en 1
    assign f_and  = |AND_result;
    assign f_or   = |OR_result;
    assign f_xor  = |XOR_result;

endmodule
