set ip_address_hw_server [lindex $argv 0]
set port_hw_server [lindex $argv 1]
set address_image_ram [lindex $argv 2]

connect -url tcp:$ip_address_hw_server:$port_hw_server
targets
targets -set -nocase -filter {name =~"APU*"} -index 0
rst -system
puts "reset device"
after 3000


targets -set -filter {level==0} -index 1
fpga -file output/images/firmware_fpga.bit


configparams force-mem-access 1


targets -set -nocase -filter {name =~"APU*"} -index 0
source output/images/ps7_init.tcl
ps7_init
puts "init ps"
ps7_post_config
puts "post config ps"


targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
puts "chouce device"
dow -data output/images/image.ub $address_image_ram
puts "download to ddr image.ub to address $address_image_ram"


dow output/images/u-boot.elf
puts "run baremetal application u-boot.elf"

configparams force-mem-access 0
targets -set -nocase -filter {name =~"APU*"} -index 0
con
puts "contune device"

disconnect
exit
