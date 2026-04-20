set ip_address_hw_server [lindex $argv 0]
set port_hw_server [lindex $argv 1]

connect -url tcp:$ip_address_hw_server:$port_hw_server
