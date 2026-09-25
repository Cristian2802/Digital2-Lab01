`timescale 1ns / 1ps

module tb_simulacion();

// Declaración de señales
reg clk;
reg [3:0] sw;
reg [5:0] btn;
wire [3:0] led;
wire [2:0] rgb_led;

// Instancia del módulo Top
top_alu DUT (
    .clk(clk),
    .sw(sw),
    .btn(btn),
    .led(led),
    .rgb_led(rgb_led)
);

// Generación del reloj (125 MHz)
always #4 clk = ~clk;

// Tarea para simular la pulsación del botón de guardado
task guardar_b;
    begin
        #10;
        btn[5] = 1;
        #10;
        btn[5] = 0;
        #20;
    end
endtask

initial begin
    $dumpfile("simulacion_alu.vcd"); 
    $dumpvars(0, tb_simulacion);

    // Estado inicial
    clk = 0;
    sw = 4'b0000;
    btn = 6'b000000;
    #20;

    // ==========================================
    // PRUEBAS ARITMÉTICAS
    // ==========================================
    
    // 1. Suma base: 2 + 1
    sw = 4'd2;           // A = 2
    btn[3:0] = 4'd1;     // B = 1
    btn[4] = 0;          // Modo: Suma
    guardar_b();
    #20;

    // 2. Resta base: 2 - 1
    sw = 4'd2;           // A = 2
    btn[3:0] = 4'd1;     // B = 1
    btn[4] = 1;          // Modo: Resta
    guardar_b();
    #20;

    // 3. Suma grande: 10 + 5
    sw = 4'd10;          // A = 10
    btn[3:0] = 4'd5;     // B = 5
    btn[4] = 0;          // Modo: Suma
    guardar_b();
    #20;

    // 4. Resta grande: 12 - 4
    sw = 4'd12;          // A = 12
    btn[3:0] = 4'd4;     // B = 4
    btn[4] = 1;          // Modo: Resta
    guardar_b();
    #20;

    // ==========================================
    // PRUEBAS DE ESTADOS LÓGICOS (LED RGB)
    // ==========================================
    btn[4] = 0; // Regresamos a modo suma para no afectar visualmente
    
    // 5. Caso RGB 000 (Apagado)
    sw = 4'd0; btn[3:0] = 4'd0; guardar_b(); #20;

    // 6. Caso RGB 011 (Verde + Azul) -> A=1, B=2
    sw = 4'd1; btn[3:0] = 4'd2; guardar_b(); #20;

    // 7. Caso RGB 110 (Rojo + Verde) -> A=15, B=15
    sw = 4'd15; btn[3:0] = 4'd15; guardar_b(); #20;

    // 8. Caso RGB 111 (Todos encendidos) -> A=3, B=1
    sw = 4'd3; btn[3:0] = 4'd1; guardar_b(); #40;

    $finish;
end


endmodule
