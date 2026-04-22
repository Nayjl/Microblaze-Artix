module topmodule (
    input  wire SYS_CLK,
    input  wire RST_KEY,

    //SDRAM
    inout  wire D0 ,
    inout  wire D1 ,
    inout  wire D2 ,
    inout  wire D3 ,
    inout  wire D4 ,
    inout  wire D5 ,
    inout  wire D6 ,
    inout  wire D7 ,
    inout  wire D8 ,
    inout  wire D9 ,
    inout  wire D10,
    inout  wire D11,
    inout  wire D12,
    inout  wire D13,
    inout  wire D14,
    inout  wire D15,
    output wire A0 ,
    output wire A1 ,
    output wire A2 ,
    output wire A3 ,
    output wire A4 ,
    output wire A5 ,
    output wire A6 ,
    output wire A7 ,
    output wire A8 ,
    output wire A9 ,
    output wire A10,
    output wire A11,
    output wire A12,
    output wire A13,
    output wire A14,
    output wire SDCKE0 ,
    output wire SDCLK0 ,
    output wire DQML   ,
    output wire DQMH   ,
    output wire CAS    ,
    output wire RAS    ,
    output wire SDWE   ,
    output wire SD_NCS0,

    // QSPI Flash
    inout  wire QSPI_CCLK,
    inout  wire QSPI_CSO_B,
    inout  wire QSPI_DQ0,
    inout  wire QSPI_DQ1,
    inout  wire QSPI_DQ2,
    inout  wire QSPI_DQ3,

    // UART
    input  wire UART_RX_M16_7,
    output wire UART_TX_N13_8,

    inout wire USER_LED
);

wire [15 : 0] sdram_0_data;
wire [12 : 0] sdram_0_addr;
wire [1 : 0] sdram_0_ba = {A14, A13};
wire [1 : 0] sdram_0_dqm = {DQMH, DQML};

topdesign_wrapper topdesign_wrapper(
    .QSPI_0_0_io0_io(QSPI_DQ0),
    .QSPI_0_0_io1_io(QSPI_DQ1),
    .QSPI_0_0_io2_io(QSPI_DQ2),
    .QSPI_0_0_io3_io(QSPI_DQ3),
    .QSPI_0_0_sck_io(QSPI_CCLK),
    .QSPI_0_0_ss_io(QSPI_CSO_B),
    .UART_0_rxd(UART_RX_M16_7),
    .UART_0_txd(UART_TX_N13_8),
    .clk_in1_0(SYS_CLK),
    .ext_reset_in_0(RST_KEY),
    .sdram_0_addr(sdram_0_addr),
    .sdram_0_ba(sdram_0_ba),
    .sdram_0_cas(CAS),
    .sdram_0_cke(SDCKE0),
    .sdram_0_clk(SDCLK0),
    .sdram_0_cs(SD_NCS0),
    .sdram_0_data(sdram_0_data),
    .sdram_0_dqm(sdram_0_dqm),
    .sdram_0_ras(RAS),
    .sdram_0_we(SDWE),
    .GPIO_0_tri_io(USER_LED)
);


assign sdram_0_addr[0] = A0 ;
assign sdram_0_addr[1] = A1 ;
assign sdram_0_addr[2] = A2 ;
assign sdram_0_addr[3] = A3 ;
assign sdram_0_addr[4] = A4 ;
assign sdram_0_addr[5] = A5 ;
assign sdram_0_addr[6] = A6 ;
assign sdram_0_addr[7] = A7 ;
assign sdram_0_addr[8] = A8 ;
assign sdram_0_addr[9] = A9 ;
assign sdram_0_addr[10] = A10;
assign sdram_0_addr[11] = A11;
assign sdram_0_addr[12] = A12;

assign sdram_0_data[0] = D0 ;
assign sdram_0_data[1] = D1 ;
assign sdram_0_data[2] = D2 ;
assign sdram_0_data[3] = D3 ;
assign sdram_0_data[4] = D4 ;
assign sdram_0_data[5] = D5 ;
assign sdram_0_data[6] = D6 ;
assign sdram_0_data[7] = D7 ;
assign sdram_0_data[8] = D8 ;
assign sdram_0_data[9] = D9 ;
assign sdram_0_data[10] = D10;
assign sdram_0_data[11] = D11;
assign sdram_0_data[12] = D12;
assign sdram_0_data[13] = D13;
assign sdram_0_data[14] = D14;
assign sdram_0_data[15] = D15;




endmodule