# QSPI flash ram
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports QSPI_DQ0]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports QSPI_DQ1]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports QSPI_DQ2]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports QSPI_DQ3]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports QSPI_CCLK]
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports QSPI_CSO_B]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 6 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
