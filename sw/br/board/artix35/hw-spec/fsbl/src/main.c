//#include <stdio.h>
#include "xil_printf.h"
#include <xil_cache.h>
#include "xspi.h"
#include "image_offset.h"

#define DDR_SIZE (XPAR_SDRAM_AXI_0_HIGHADDR - XPAR_SDRAM_AXI_0_BASEADDR + 0x01)

#undef SPI_DEVICE_ID
#define SPI_DEVICE_ID		XPAR_SPI_0_DEVICE_ID
#define SPI_SELECT  0x01
#define PAGE_SIZE   256
static XSpi Spi;

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

static int mode = READ_WRITE_EXTRA_BYTES;

static u8 WriteBuffer[PAGE_SIZE + 8] = {0};
static u8 ReadBuffer[PAGE_SIZE + 8] = {0};
static u8 FlashID[3];

static int read_page (u8 *addr);

int main() {
	print("First Stage Boot Loader Start\n\r");

	Xil_ICacheEnable();
	Xil_DCacheEnable();

    print("Preparing QSPI core ...\n\r");
    int Status = XSpi_Initialize(&Spi, SPI_DEVICE_ID);
	if(Status != XST_SUCCESS) {
		print("ERROR: XSpi initialize\n\r");
		return XST_FAILURE;
	}
	if (XST_SUCCESS != XSpi_SetOptions(&Spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION)) {
		print("ERROR: XSpi SetOptions\n\r");
		return XST_FAILURE;
	}
	if (XST_SUCCESS != XSpi_SetSlaveSelect(&Spi, SPI_SELECT)) {
		print("ERROR: XSpi SetSlaveSelect\n\r");
		return XST_FAILURE;
	}
	XSpi_Start(&Spi);
	XSpi_IntrGlobalDisable(&Spi);

	Xil_DCacheDisable();
	Xil_ICacheDisable();

    return 0;
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
