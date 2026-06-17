`default_nettype none

module tt_um_AlvaroRub_ringcounter (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 1=output, 0=input)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Registro interno de 16 bits para el contador  
    reg [15:0] out;

    // En Tiny Tapeout, el reset (rst_n) es activo en bajo (0 = reset).
    // Lo invertimos internamente para que nuestra lógica sea más intuitiva.
    wire rst = ~rst_n;

    // Lógica del contador en anillo
    always @(posedge clk) begin
        if (rst) begin
            // Inicializa activando solo el primer bit (salida 0)
            out <= 16'b0000_0000_0000_0001;
        end else begin
            // Desplaza los bits a la izquierda y reintroduce el bit más significativo al principio
            out <= {out[14:0], out[15]};
        end
    end

    // Asignación de las salidas a los pines físicos de Tiny Tapeout
    assign uo_out  = out[7:0];   // Los primeros 8 bits van a los pines de salida dedicados
    assign uio_out = out[15:8];  // Los siguientes 8 bits van a los pines bidireccionales

    // Configuración de los pines bidireccionales
    assign uio_oe  = 8'b11111111; // Ponemos todos a 1 para que actúen como salidas

    // Esta línea evita advertencias (warnings) del compilador por señales que no usamos
    wire _unused_ok = &{1'b0, ui_in, uio_in, ena, 1'b0};

endmodule
