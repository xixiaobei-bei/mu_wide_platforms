/*
 * TLMM (top-level mode multiplexer / GPIO controller), parameters taken from
 * vendor/piano/dtb/piano.dtb:
 *
 *   /soc/pinctrl@f000000
 *     compatible = "qcom,sun-tlmm"
 *     reg        = <0xf000000 0x202000>
 *     interrupts = <0 0xd0 4>      (SPI 208, level-high -> GIC INTID 240)
 *     gpio-controller / interrupt-controller
 *
 * _HID QCOMFFEB is what this Windows build's inbox driver binds to
 * (Windows\INF\qcgpio_i.inf), so no external driver injection is needed.
 * The interrupt is new: qcgpio registers the summary IRQ, and without it the
 * GPIO controller cannot finish initialising.
 */
Device (TLMM)
{
    Name (_HID, "QCOMFFEB")
    Name (_UID, Zero)
    Name (_CCA, One)

    Method (_STA, 0, NotSerialized)
    {
        Return (0x0F)
    }

    Method (_CRS, 0, Serialized)
    {
        Name (RBUF, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                0x0F000000,         // Address Base
                0x00202000,         // Address Length (DTB reg size)
                )
            Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
            {
                0x000000F0,         // GIC SPI 208 -> INTID 240
            }
        })
        Return (RBUF)
    }
}
