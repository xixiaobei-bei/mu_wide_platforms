/*
 * TLMM (top-level mode multiplexer / GPIO controller) for the Windows VM.
 *
 * Without this node the ACPI namespace has no description of 0x0F000000 at
 * all: \_SB only contains UFS0 and URS0, so Windows never reserves the block
 * and a driver that MmMapIoSpaceEx()s it and reads a register takes an SError
 * that resets the whole machine (no bugcheck, no dump, no log).
 *
 * QCOM0F0C is what qcgpio8480.inf (Qualcomm System Manager GPIO class
 * extension, qcgpio.sys) binds to, so installing that driver gives the block
 * a real owner and keeps it clocked.
 */
Device (TLMM)
{
    Name (_HID, "QCOM0F0C")
    Name (_UID, Zero)
    Name (_CCA, One)

    Method (_STA, 0, NotSerialized)
    {
        Return (0x0F)
    }

    Method (_CRS, 0, NotSerialized)
    {
        Name (RBUF, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                0x0F000000,         // Address Base
                0x00200000,         // Address Length
                )
        })
        Return (RBUF)
    }
}
