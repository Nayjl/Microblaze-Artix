#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "blconfig.h"
#include "portab.h"
#include "errors.h"
#include "xparameters.h"
#include "xspi.h"
#include "xgpio.h"
#include <xil_cache.h>
#include "xwdttb.h"

//Set the offset and size of image in SPI flash
#define FLASH_IMAGE_OFFSET 0x1800000
#define FLASH_IMAGE_SIZE 0x2700000

//Set the address where image will be loaded. This will usually point to
//DDR or SRAM depending on the board architecture. Remember to build
//your application/Linux kernel with this address as base address
#define IMAGE_LOAD_ADDRESS 0x40000000ul
#define DDR_SIZE (1024 * 1024 * 1024)

/*
 * The following constant defines the slave select signal that is used to
 * to select the Flash device on the SPI bus, this signal is typically
 * connected to the chip select of the device.
 */
#define SPI_SELECT  0x01

/* Number of bytes per page in the flash device. */
#define PAGE_SIZE   256

#define BYTE1   0 /* Byte 1 position */
#define BYTE2   1 /* Byte 2 position */
#define BYTE3   2 /* Byte 3 position */
#define BYTE4   3 /* Byte 4 position */
#define BYTE5   4 /* Byte 5 position */

#define READ_WRITE_EXTRA_BYTES              4 /* Read/Write extra bytes */
#define READ_WRITE_EXTRA_BYTES_4BYTE_MODE   5 /**< Command extra bytes */

#define RD_ID_SIZE  4

#define ISSI_ID_BYTE0       0x9D
#define MICRON_ID_BYTE0     0x20
#define CYPRESS_ID_BYTE0    0x01

#define ENTER_4B_ADDR_MODE      0xb7 /* Enter 4Byte Mode command */
#define EXIT_4B_ADDR_MODE       0xe9 /* Exit 4Byte Mode command */
#define EXIT_4B_ADDR_MODE_ISSI  0x29
#define WRITE_ENABLE            0x06 /* Write Enable command */

#define ENTER_4B    1
#define EXIT_4B     0

#define FLASH_16_MB 0x18
#define FLASH_MAKE  0
#define FLASH_SIZE  2

#define READ_CMD    0x03

//Define ID of the SPI peripheral that is connected to the SPI flash
#undef  SPI_DEVICE_ID
#define SPI_DEVICE_ID   XPAR_SPI_0_DEVICE_ID

static XWdtTb wdt;
static XWdtTb_Config *wdt_cfg;

static XSpi Spi;

static u8 WriteBuffer[PAGE_SIZE + 8] = {0};
static u8 ReadBuffer[PAGE_SIZE + 8] = {0};
static u8 FlashID[3];

static int mode = READ_WRITE_EXTRA_BYTES;

void (*imageEntry)();

static u32
bin2hex (u32 b)
{
    u32 w = b & 0xf;

    if (w  > 9) return ( w + ('A' - 10) );

    return (w + '0');
}

static void
byte2hex (u8 b, u8 *p)
{
    if (!p) return;

    p[0] = bin2hex(b >> 4);
    p[1] = bin2hex(b);
}

static void
word2hex (u32 w, u8 *p)
{
    if (!p) return;

    p[7] = bin2hex(w);
    p[6] = bin2hex(w >> 4);
    p[5] = bin2hex(w >> 8);
    p[4] = bin2hex(w >> 12);
    p[3] = bin2hex(w >> 16);
    p[2] = bin2hex(w >> 20);
    p[1] = bin2hex(w >> 24);
    p[0] = bin2hex(w >> 28);
}

static int FlashWriteEnable (void)
{
    WriteBuffer[BYTE1] = WRITE_ENABLE;
    return XSpi_Transfer(&Spi, WriteBuffer, NULL, 1);
}

static int switch_addr_mode (unsigned int action)
{
    u8 id = FlashID[FLASH_MAKE];

    if (CYPRESS_ID_BYTE0 == id) return XST_SUCCESS;

    if (MICRON_ID_BYTE0 != id && ISSI_ID_BYTE0 != id) return XST_FAILURE;

    if ( XST_SUCCESS != FlashWriteEnable()) return XST_FAILURE;

    if (ENTER_4B == action) {
        WriteBuffer[BYTE1] = ENTER_4B_ADDR_MODE;
        print("Entering 4bit mode ...\n\r");
    } else {
        if (ISSI_ID_BYTE0 == id)    WriteBuffer[BYTE1] = EXIT_4B_ADDR_MODE_ISSI;
        else                        WriteBuffer[BYTE1] = EXIT_4B_ADDR_MODE;
        print("Exiting 4bit mode ...\n\r");
    }

    return XSpi_Transfer(&Spi, WriteBuffer, NULL, 1);
}

static int read_page (u8 *addr)
{
    u32 a = (u32) addr;

    if (READ_WRITE_EXTRA_BYTES == mode) {
        WriteBuffer[BYTE1] = READ_CMD;
        WriteBuffer[BYTE2] = (u8) ((a >> 16) & 0xff);
        WriteBuffer[BYTE3] = (u8) ((a >> 8) & 0xff);
        WriteBuffer[BYTE4] = (u8) (a & 0xff);
    } else {
        if (CYPRESS_ID_BYTE0 == FlashID[FLASH_MAKE])
            WriteBuffer[BYTE1] = 0x13;
        else
            WriteBuffer[BYTE1] = READ_CMD;
        WriteBuffer[BYTE2] = (u8) ((a >> 24) & 0xff);
        WriteBuffer[BYTE3] = (u8) ((a >> 16) & 0xff);
        WriteBuffer[BYTE4] = (u8) ((a >> 8) & 0xff);
        WriteBuffer[BYTE5] = (u8) (a & 0xff);
    }

    return XSpi_Transfer(&Spi, WriteBuffer, &ReadBuffer[8 - mode], PAGE_SIZE + mode);
}

#define DECIMATOR (0x40000 / PAGE_SIZE)

int load_linux ( void )
{
    u32 *p, w, counter = FLASH_IMAGE_SIZE, decim = 0,
        *ddrPtr = (u32 *) IMAGE_LOAD_ADDRESS;
    u8 *flashPtr = (u8 *) FLASH_IMAGE_OFFSET;

    u8 address_buf[] = "00000000 00000000\n\r";

    print("Testing DRAM ...\n\r");

#if 1
    ddrPtr[0] = 0x01234567;
    ddrPtr[1] = 0xDEADBEEF;
    ddrPtr[2] = 0x5A5AA5A5;
    ddrPtr[3] = 0xA5A55A5A;

    if ( ddrPtr[0] != 0x01234567 ||
         ddrPtr[1] != 0xDEADBEEF ||
         ddrPtr[2] != 0x5A5AA5A5 ||
         ddrPtr[3] != 0xA5A55A5A )
    {
        return -1;
    }
#else
    counter = DDR_SIZE >> 2;
    do {
        *ddrPtr++ = --counter;
    } while (counter);
    counter = DDR_SIZE >> 2;
    ddrPtr = (u32 *) IMAGE_LOAD_ADDRESS;
    do {
        if (*ddrPtr++ != --counter) {
            ddrPtr--;
            print("failed at address ");
            word2hex((u32) ddrPtr, &address_buf[9]);
            print((const char *) &address_buf[9]);
            word2hex((u32) *ddrPtr, address_buf);
            word2hex((u32) counter, &address_buf[9]);
            print((const char *) address_buf);
            return -1;
        }
        if ((counter & 0xffff) == 0 && XWdtTb_IsWdtExpired(&wdt)) XWdtTb_RestartWdt(&wdt);
    } while (counter);
    ddrPtr = (u32 *) IMAGE_LOAD_ADDRESS;
    counter = FLASH_IMAGE_SIZE,
#endif
    print("PASSED\n\r");

    if (FlashID[FLASH_SIZE] >= FLASH_16_MB) {
        if ( switch_addr_mode(ENTER_4B) )
            return -1;
        mode = READ_WRITE_EXTRA_BYTES_4BYTE_MODE;
    }

    print("Loading Linux image ...\n\r");

    do {
        if (XWdtTb_IsWdtExpired(&wdt)) XWdtTb_RestartWdt(&wdt);

        if ( XST_SUCCESS != read_page(flashPtr) ) {
            print("Failed to read page at address ");
            word2hex((u32) flashPtr, &address_buf[9]);
            print((const char *) &address_buf[9]);
            return -1;
        }

        flashPtr += PAGE_SIZE;

        memcpy((void *) ddrPtr, (void *) (ReadBuffer + 8), PAGE_SIZE);

        if ( !decim ) {
            p = (u32 *) (ddrPtr);
            word2hex ((u32) p, address_buf);
            word2hex (*p, &address_buf[9]);
            print((const char *) address_buf);
        }
        if ( ++decim > DECIMATOR - 1 ) decim = 0;

        ddrPtr += (PAGE_SIZE >> 2);
        counter -= PAGE_SIZE;
    } while ( counter );

    word2hex ((u32) ddrPtr, address_buf);
    address_buf[8] = '\n';
    address_buf[9] = '\r';
    address_buf[10] = 0;
    print((const char *) address_buf);

#if 1

    print("Verifying ...\n\r");
    ddrPtr = (u32 *) IMAGE_LOAD_ADDRESS;
    flashPtr = (u8 *) FLASH_IMAGE_OFFSET;
    counter = FLASH_IMAGE_SIZE;
    address_buf[8] = ' ';

    do {

        if (XWdtTb_IsWdtExpired(&wdt)) XWdtTb_RestartWdt(&wdt);

        if ( XST_SUCCESS != read_page(flashPtr) ) {
            print("Failed to read page at address ");
            word2hex((u32) flashPtr, &address_buf[9]);
            print((const char *) &address_buf[9]);
            return -1;
        }

        if (memcmp((void *) ddrPtr, (void *) (ReadBuffer + 8), PAGE_SIZE)) {
            p = (u32 *) (ReadBuffer + 8);
            counter = PAGE_SIZE >> 4;
            do { 
                if (*p++ != *ddrPtr++) break;
            } while (--counter);
            p--; ddrPtr--;
            print("Verification failed at address ");
            word2hex((u32) ddrPtr, &address_buf[9]);
            print((const char *) &address_buf[9]);
            word2hex((u32) *ddrPtr, address_buf);
            word2hex((u32) *p, &address_buf[9]);
            print((const char *) address_buf);
            return -1;
        }

        flashPtr += PAGE_SIZE;

        if ( !decim ) {
            p = (u32 *) (ddrPtr);
            word2hex ((u32) p, address_buf);
            word2hex (*p, &address_buf[9]);
            print((const char *) address_buf);
        }
        if ( ++decim > DECIMATOR - 1 ) decim = 0;

        ddrPtr += (PAGE_SIZE >> 2);
        counter -= PAGE_SIZE;
    } while ( counter );

    word2hex ((u32) ddrPtr, address_buf);
    address_buf[8] = '\n';
    address_buf[9] = '\r';
    address_buf[10] = 0;
    print((const char *) address_buf);

#endif

    if ( READ_WRITE_EXTRA_BYTES_4BYTE_MODE == mode )
        switch_addr_mode(EXIT_4B);

    print("\n\rStarting Linux ...\n\r");

    //Invalidate instruction cache to clean up all existing entries
    Xil_ICacheInvalidate();

    XWdtTb_Stop(&wdt);
    XWdtTb_CfgInitialize(&wdt, wdt_cfg, wdt_cfg->BaseAddr);
    XWdtTb_Start(&wdt);

    //Execute the loaded image
    imageEntry = (void (*)())IMAGE_LOAD_ADDRESS;
    (*imageEntry)();

    //We shouldn't be here
    return -1;
}

/* We don't use interrupts/exceptions. 
   Dummy definitions to reduce code size on MicroBlaze */
void _interrupt_handler () {}
void _exception_handler () {}
void _hw_exception_handler () {}

static void error_halt (const char8 *ptr) { print(ptr); for(;;); }

static int FlashReadID (void)
{
    /* Read ID in Auto mode.*/
    WriteBuffer[BYTE1] = 0x9f;
    WriteBuffer[BYTE2] = 0xff;  /* 4 dummy bytes */
    WriteBuffer[BYTE3] = 0xff;
    WriteBuffer[BYTE4] = 0xff;
    WriteBuffer[BYTE5] = 0xff;

    if (XST_SUCCESS != XSpi_Transfer(&Spi, WriteBuffer, ReadBuffer, 5))
        return XST_FAILURE;

    FlashID[0] = ReadBuffer[1];
    FlashID[1] = ReadBuffer[2];
    FlashID[2] = ReadBuffer[3];

    return XST_SUCCESS;
}

static volatile u32 loops;
static void
delay (u32 l)
{
    loops = l;
    do
        loops--;
    while (loops);
}

static u8 flash_id[] = "Flash ID: 00 00 00\n\r";

void main()
{
    XGpio gpio;

    print("@\n\r");

#ifndef SDT
    wdt_cfg = XWdtTb_LookupConfig(XPAR_WDTTB_0_DEVICE_ID);
#else
    wdt_cfg = XWdtTb_LookupConfig(XPAR_XWDTTB_0_BASEADDR);
#endif

    if (wdt_cfg &&
        XST_SUCCESS == XWdtTb_CfgInitialize(&wdt, wdt_cfg, wdt_cfg->BaseAddr) &&
        XST_SUCCESS == XWdtTb_SelfTest(&wdt))
    {
        XWdtTb_Start(&wdt);
    }

    Xil_DCacheInvalidate();
    Xil_DCacheDisable();

    //delay(500000000);

    print("KSAR bootloader v1.1.0\n\r");

#ifndef SDT
    XGpio_Initialize(&gpio, XPAR_AXI_GPIO_0_DEVICE_ID);
#else
    XGpio_Initialize(&gpio, XPAR_AXI_GPIO_0_BASEADDR);
#endif

    print("Preparing QSPI core ...\n\r");

    if ( XST_SUCCESS != XSpi_Initialize(&Spi, SPI_DEVICE_ID) ) error_halt("Failed to initialize SPI\n\r");

    /*
     * Set the SPI device as a master and in manual slave select mode such
     * that the slave select signal does not toggle for every byte of a
     * transfer, this must be done before the slave select is set.
     */
    if (XST_SUCCESS != XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION))
        error_halt("Failed to set SPI port as master\n\r");

    /*
     * Select the flash device on the SPI bus, so that it can be
     * read and written using the SPI bus.
     */
    if (XST_SUCCESS != XSpi_SetSlaveSelect(&Spi, SPI_SELECT)) error_halt("Failed to select Flash device\n\r");

    XSpi_Start(&Spi);
    XSpi_IntrGlobalDisable(&Spi);

    if (XST_SUCCESS != FlashReadID()) error_halt("Failed to read Flash ID\n\r");
    byte2hex(FlashID[0], &flash_id[10]);
    byte2hex(FlashID[1], &flash_id[13]);
    byte2hex(FlashID[2], &flash_id[16]);
    print(flash_id);

    if ( load_linux() ) print("FAILED\n\r");

    for (;;);
}
