/*
 * TLMM (top-level mode multiplexer / GPIO controller) for the Windows VM.
 *
 * Without this node the ACPI namespace has no description of 0x0F000000 at
 * all: \_SB only contains UFS0 and URS0, so Windows never reserves the block
 * and a driver that MmMapIoSpaceEx()s it and reads a register takes an SError
 * that resets the whole machine (no bugcheck, no dump, no log).
 *
 * QCOMFFEB is the HID that this Windows build's own inbox driver
 * (Windows\INF\qcgpio_i.inf, "%GPIO.DeviceDesc%=GPIO_Inst,,ACPI\QCOMFFEB")
 * binds to. Using it means no external driver has to be injected: PnP
 * installs qcgpio_i.sys on first boot, it loads as a BOOT_START driver on the
 * next one and becomes the legal owner of the block (clock/power included).
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
                0x00200000,         // Address Length
                )
        })
        Return (RBUF)
    }
}
