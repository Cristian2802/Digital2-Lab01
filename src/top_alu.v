module top_alu (
    input  wire       clk,      // Reloj de 125 MHz (K17)
    input  wire [3:0] sw,       // Switches [3:0] -> Operando A
    input  wire [5:0] btn,      // BTN[3:0] = Operando B | BTN[4] = Resta | BTN[5] = Guardar B
    output wire [3:0] led,      // LEDs verdes [3:0] -> Resultado Aritmético
    output wire [2:0] rgb_led   // RGB LED 6: [2]=Rojo (AND), [1]=Verde (OR), [0]=Azul (XOR)
);

    // 1. Operando A (lectura directa de switches)
    wire [3:0] A = sw[3:0];

    // 2. Registro para el Operando B
    reg [3:0] B_reg = 4'b0000;

    // Guardar btn[3:0] en B_reg al presionar btn[5]
    always @(posedge clk) begin
        if (btn[5]) begin
            B_reg <= btn[3:0];
        end
    end

    // 3. Control de operación aritmética
    wire modo_resta = btn[4]; // 1 = Resta, 0 = Suma

    // 4. Operaciones en paralelo
    wire [3:0] AND_result = A & B_reg;
    wire [3:0] OR_result  = A | B_reg;
    wire [3:0] XOR_result = A ^ B_reg;
    wire [3:0] SUM_result = modo_resta ? (A - B_reg) : (A + B_reg);

    // 5. Asignación de salidas físicas
    assign led        = SUM_result;
    assign rgb_led[2] = |AND_result; // Rojo (Canal R)
    assign rgb_led[1] = |OR_result;  // Verde (Canal G)
    assign rgb_led[0] = |XOR_result; // Azul (Canal B)

endmodule