import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Iniciar el reloj a 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reiniciar el sistema (Reset activo en bajo)
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Tras el reset, el contador debe arrancar con el primer bit en 1
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 1

    # En el siguiente ciclo de reloj, el 1 se desplaza a la segunda posición (2 en decimal)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 2
    
    # En el siguiente ciclo, se desplaza a la tercera posición (4 en decimal)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 4
