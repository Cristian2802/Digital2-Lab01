`timescale 1ns / 1ps

module tb_simulacion();

    // Señales internas para conectar con las entradas del Top
    reg clk;
    reg [3:0] sw;
    reg [5:0] btn;

    // Señales para capturar las salidas del Top
    wire [3:0] led;
    wire [2:0] rgb_led;

    // 1. Instanciar el módulo Top
    top_alu DUT (
        .clk(clk),
        .sw(sw),
        .btn(btn),
        .led(led),
        .rgb_led(rgb_led)
    );

    // 2. Generación del Reloj a 125 MHz
    // 125 MHz -> Periodo de 8 ns. Por lo tanto, invierte su estado cada 4 ns.
    always #4 clk = ~clk;

    // 3. Bloque inicial de estímulos (lo que "haría" el usuario)
    initial begin
        // Instrucciones obligatorias para generar el archivo para GTKWave
        $dumpfile("top_alu_gtkwave.vcd"); 
        $dumpvars(0, tb_simulacion);

        // Estado inicial
        clk = 0;
        sw = 4'b0000;
        btn = 6'b000000;
        #20; // Esperar 20 nanosegundos

        // ----------------------------------------------------
        // PRUEBA 1: Sumar 5 + 3
        // ----------------------------------------------------
        sw = 4'b0101;         // Operando A = 5
        btn[3:0] = 4'b0011;   // Ponemos 3 en los botones
        #10;
        
        btn[5] = 1;           // Presionamos Guardar B
        #10;
        btn[5] = 0;           // Soltamos el botón
        #20;

        // ----------------------------------------------------
        // PRUEBA 2: Restar 5 - 3
        // ----------------------------------------------------
        btn[4] = 1;           // Activamos modo Resta
        #30;

        // ----------------------------------------------------
        // PRUEBA 3: Ver comportamiento de compuertas lógicas
        // A = 15 (1111) y B = 0 (0000)
        // ----------------------------------------------------
        btn[4] = 0;           // Apagamos resta (volvemos a suma)
        sw = 4'b1111;         // A = 15
        btn[3:0] = 4'b0000;   // B = 0
        #10;
        btn[5] = 1;           // Guardar B
        #10;
        btn[5] = 0;
        #30;

        // Finalizar la simulación
        $finish;
    end

endmodule
