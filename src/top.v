// Módulo top (wrapper): conecta los pines de la Zybo Z7 con el registro B_reg y el test funcional
module top (
    input  wire       clk,      // Reloj de 125 MHz (K17)
    input  wire [3:0] sw,       // Switches -> Operando A
    input  wire [5:0] btn,      // [3:0] = Operando B | [4] = Resta | [5] = Guardar B
    output wire [3:0] led,      // LEDs verdes -> Resultado aritmético
    output wire [2:0] rgb_led   // LED RGB 6: [2]=Rojo (AND), [1]=Verde (OR), [0]=Azul (XOR)
);

    // Operando A: lectura directa de los switches
    wire [3:0] A = sw[3:0];

    // Registro del operando B (lógica secuencial, fuera del módulo combinacional)
    reg [3:0] B_reg = 4'b0000;  // Inicia en 0 al programar la FPGA

    // Guarda btn[3:0] en B_reg en cada flanco de reloj mientras btn[5] esté presionado
    always @(posedge clk) begin
        if (btn[5]) begin
            B_reg <= btn[3:0];
        end
    end

    wire modo_resta = btn[4];   // 1 = Resta, 0 = Suma

    // Instancia del módulo combinacional y conexión a las salidas físicas
    test_funcional u_test (
        .A      (A),
        .B      (B_reg),
        .resta  (modo_resta),
        .result (led),          // LEDs verdes
        .f_and  (rgb_led[2]),   // Rojo
        .f_or   (rgb_led[1]),   // Verde
        .f_xor  (rgb_led[0])    // Azul
    );

endmodule
