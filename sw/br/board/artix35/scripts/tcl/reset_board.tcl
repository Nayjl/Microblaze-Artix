set ip_address_hw_server [lindex $argv 0]
set port_hw_server [lindex $argv 1]

connect -url tcp:$ip_address_hw_server:$port_hw_server
targets
targets -set -nocase -filter {name =~"APU*"} -index 0
rst -system
puts "reset device"
after 3000

con

disconnect
exit