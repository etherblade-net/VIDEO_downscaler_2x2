import cocotb
from cocotb.triggers import RisingEdge, ReadOnly, Timer
from driver_monitor_class import driver_monitor

@cocotb.test()
async def my_first_test(hdl):

    drvmon = driver_monitor(hdl)

    run_loop = True

    while (run_loop):
        await RisingEdge(hdl.clk)
        await ReadOnly()
        await Timer(1, units='step')
        drvmon.setinterfacesignals()
        await ReadOnly()
        drvmon.checkpush()
        drvmon.checkpop()
        run_loop = drvmon.keepsim

    drvmon.produceimg()