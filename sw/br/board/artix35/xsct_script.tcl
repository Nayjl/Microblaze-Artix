# set cur_dir [pwd]

proc open_hw_server {args} {
    set ip_address_hw_server 127.0.0.1
    set port_hw_server 3121
    set xlnx_program_flash "/opt/Xilinx/Vitis/2023.2/bin/program_flash"
    set fsbl_file "../../../../output/images/fsbl.elf"
    set image_file "../../../../output/images/QSPI.bin"
    if {[llength $args] % 2 != 0} { error "dow_data: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-ip_addr"   { set ip_address_hw_server $val }
            "-port"      { set port_hw_server $val }
            "-xlnx_sw"   { set xlnx_program_flash $val }
            "-fsbl"      { set fsbl_file $val }
            "-file"      { set image_file $val }
        }
    }
    connect -url tcp:$ip_address_hw_server:$port_hw_server
    exec $xlnx_program_flash -offset 0 \
	-flash_type qspi-x4-single \
	-fsbl $fsbl_file \
	-f $image_file \
	-url tcp:$ip_address_hw_server:$port_hw_server
}

proc dow_data {args} {
    set ip_address_hw_server 127.0.0.1
    set port_hw_server 3121
    set address_image_ram 0x2000000
    set serias_chip "Zynq"
    set download_file_ram "../../../../output/images/BOOT.bin"
    set ps_init_tcl_file "../../../../output/images/ps_init.tcl"
    set uboot_file "../../../../output/images/u-boot.elf"
    set bitstream_file "../../../../output/images/firmware_fpga.bit"
    if {[llength $args] % 2 != 0} { error "dow_data: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-ip_addr"      { set ip_address_hw_server $val }
            "-port"         { set port_hw_server $val }
            "-serias"       { set serias_chip $val }
            "-file"         { set download_file_ram $val }
            "-addr_image"   { set address_image_ram $val }
            "-uboot"        { set uboot_file $val }
            "-ps_init"      { set ps_init_tcl_file $val }
            "-bitstream"    { set bitstream_file $val }
        }
    }
    connect -url tcp:$ip_address_hw_server:$port_hw_server
    source $ps_init_tcl_file
    if {$serias_chip == "Zynq"} {
        targets -set -nocase -filter {name =~"APU*"} -index 0
        rst -system
        puts "INFO: Reset board"
        after 3000
        targets -set -filter {level==0} -index 1
        fpga -file $bitstream_file
        configparams force-mem-access 1
        ps7_init
        puts "INFO: Init ps7_init"
        ps7_post_config
        puts "INFO: Init ps7_post_config"
        targets -set -nocase -filter {name =~ "ARM*#0"} -index 0
        dow -data download_file_ram $address_image_ram
        puts "INFO: download data to ddr address $address_image_ram"
        dow $uboot_file
        puts "INFO: run baremetal application u-boot.elf"
        configparams force-mem-access 0
        targets -set -nocase -filter {name =~ "APU*"} -index 0
        con
        puts "INFO: run board"
        disconnect
        exit
    }
}

proc resolve_path {pth} {
    if {[string index $pth 0] == "~"} {
        return [file normalize $pth]
    }
    return $pth
}

proc fsbl {args} {
	set board 0
    set pth_xsahdf "../../spec_hw"
    set serias_chip "Zynq"
    set repos_xilinx [resolve_path ~/work/repo_xlnx]
	# for {set i 0} {$i < [llength $args]} {incr i} {
	# 	if {[lindex $args $i] == "-board"} {
	# 		set board [string toupper [lindex $args [expr {$i + 1}]]] 
	# 	} elseif {[lindex $args $i] == "-repo"} {
    #         set repos_xilinx [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-serias"} {
    #         set serias_chip [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-hwpth"} {
    #         set pth_xsahdf [lindex $args [expr {$i + 1}]]
    #     }
	# }
    if {[llength $args] % 2 != 0} { error "fsbl: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-board"  { set board [string toupper $val] }
            "-repo"   { set repos_xilinx [resolve_path $val] }
            "-serias" { set serias_chip $val }
            "-hwpth"  { set pth_xsahdf $val }
        }
    }
    set select_core ps7_cortexa9_0
    set select_fsbl zynq_fsbl
    if {$serias_chip == "Zynq"} {
        set select_core ps7_cortexa9_0
        set select_fsbl zynq_fsbl
    } else {
        set select_core psu_cortexa53_0
        set select_fsbl zynqmp_fsbl
    }
	set xsa [glob -nocomplain -directory $pth_xsahdf -type f *.xsa *.hdf]
    if {[llength $xsa] == 0} {
        puts "ERROR: No .xsa or .hdf found in $pth_xsahdf"
        exit 1
    }
    if {[file exists $pth_xsahdf/fsbl]} {
        puts "INFO: Cleaning up existing $pth_xsahdf/fsbl directory..."
        file delete -force $pth_xsahdf/fsbl
    }
	hsi::open_hw_design $xsa
	if {[file isdirectory ${repos_xilinx}]} {
		puts "INFO: Adding ${repos_xilinx} repo"
		hsi::set_repo_path ${repos_xilinx}
	} else {
        puts "ERROR: Not found ${repos_xilinx} repo"
        exit 1
    }
	set fsbl_design [hsi::create_sw_design fsbl_1 -proc $select_core -app $select_fsbl]
	if {$board != 0} {
		common::set_property -name APP_COMPILER_FLAGS -value "-DXPS_BOARD_${board}" -objects $fsbl_design
	}
	hsi::generate_app -dir $pth_xsahdf/fsbl -compile
	hsi::close_hw_design [hsi::current_hw_design]
}

proc pmufw {args} {
    set pth_xsahdf ../../spec_hw
    set serias_chip "ZynqMP"
    set repos_xilinx ~/work/repo_xlnx
    # for {set i 0} {$i < [llength $args]} {incr i} {
	# 	if {[lindex $args $i] == "-repo"} {
    #         set repos_xilinx [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-serias"} {
    #         set serias_chip [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-hwpth"} {
    #         set pth_xsahdf [lindex $args [expr {$i + 1}]]
    #     }
	# }
    if {[llength $args] % 2 != 0} { error "fsbl: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-repo"   { set repos_xilinx [resolve_path $val] }
            "-serias" { set serias_chip $val }
            "-hwpth"  { set pth_xsahdf $val }
        }
    }
    if {$serias_chip == "ZynqMP"} {
        set xsa [glob -nocomplain -directory $pth_xsahdf -type f *.xsa *.hdf]
        if {[llength $xsa] == 0} {
            puts "ERROR: No .xsa or .hdf found in $pth_xsahdf"
            exit 1
        }
        if {[file exists $pth_xsahdf/pmufw]} {
            puts "INFO: Cleaning up existing $pth_xsahdf/pmufw directory..."
            file delete -force $pth_xsahdf/pmufw
        }
        hsi::open_hw_design $xsa
        if {[file isdirectory ${repos_xilinx}]} {
            puts "INFO: Adding ${repos_xilinx} repo"
            hsi::set_repo_path ${repos_xilinx}
        } else {
            puts "ERROR: Not found ${repos_xilinx} repo"
            exit 1
        }
        hsi::generate_app -app zynqmp_pmufw -proc psu_pmu_0 -dir $pth_xsahdf/pmufw -compile
        hsi::close_hw_design [hsi::current_hw_design]
    } else {
        puts "INFO: PMUFW is not supported for $serias_chip. Skipping."
        return
    }
}

proc build_dts {args} {
	set board 0
	set version 2020.2
    set pth_xsahdf ../../spec_hw
    set serias_chip "Zynq"
    set repos_xilinx ~/work/repo_xlnx
	# for {set i 0} {$i < [llength $args]} {incr i} {
	# 	if {[lindex $args $i] == "-board"} {
	# 		set board [string tolower [lindex $args [expr {$i + 1}]]] 
	# 	}
	# 	if {[lindex $args $i] == "-version"} {
	# 		set version [string toupper [lindex $args [expr {$i + 1}]]] 
	# 	}
    #     if {[lindex $args $i] == "-repo"} {
    #         set repos_xilinx [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-serias"} {
    #         set serias_chip [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-hwpth"} {
    #         set pth_xsahdf [lindex $args [expr {$i + 1}]]
    #     }
	# }
    if {[llength $args] % 2 != 0} { error "fsbl: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-board"   { set board [string tolower $val] }
            "-version" { set version [string toupper $val] }
            "-repo"    { set repos_xilinx [resolve_path $val] }
            "-serias"  { set serias_chip $val }
            "-hwpth"   { set pth_xsahdf $val }
        }
    }
    set xsa [glob -nocomplain -directory $pth_xsahdf -type f *.xsa *.hdf]
    if {[llength $xsa] == 0} {
        puts "ERROR: No .xsa or .hdf found in $pth_xsahdf"
        exit 1
    }
    if {[file exists $pth_xsahdf/device-tree]} {
        puts "INFO: Cleaning up existing $pth_xsahdf/device-tree directory..."
        file delete -force $pth_xsahdf/device-tree
    }
    hsi::open_hw_design $xsa
    if {[file isdirectory ${repos_xilinx}]} {
        puts "INFO: Adding ${repos_xilinx} repo"
        hsi::set_repo_path ${repos_xilinx}
    } else {
        puts "ERROR: Not found ${repos_xilinx} repo"
        exit 1
    }
    if {$serias_chip == "Zynq"} {
        set select_core ps7_cortexa9_0
    } else {
        set select_core psu_cortexa53_0
    }
    hsi::create_sw_design device-tree -os device_tree -proc $select_core
    hsi::generate_target -dir $pth_xsahdf/device-tree
    hsi::close_hw_design [hsi::current_hw_design]
    if {$board != 0} {
        foreach lib [glob -nocomplain -directory ${repos_xilinx}/device_tree/data/kernel_dtsi/${version}/include/dt-bindings -type d *] {
            if {![file exists device-tree/include/dt-bindings/[file tail $lib]]} {
                file copy -force $lib device-tree/include/dt-bindings
            }
        }
        set dtsi_files [glob -nocomplain -directory ${repos_xilinx}/device_tree/data/kernel_dtsi/${version}/BOARD -type f *${board}*]
        if {[llength $dtsi_files] != 0} {
            file copy -force [lindex $dtsi_files end] device-tree
            set fileId [open device-tree/system-user.dtsi "w"]
            puts $fileId "/include/ \"[file tail [lindex $dtsi_files end]]\""
            puts $fileId "/ {"
            puts $fileId "};"
            close $fileId
        } else {
            puts "Info: Board file: $board is not found and will not be added to the system-top.dts"
        }
    }
}

proc build_all {args} {
    set board 0
	set version 2020.2
    set pth_xsahdf ../../spec_hw
    set serias_chip "Zynq"
    set repos_embsw_xilinx ~/work/repo_xlnx/embeddedsw
    set repos_dt_xilinx ~/work/repo_xlnx/device-tree-xlnx
    # for {set i 0} {$i < [llength $args]} {incr i} {
    #     if {[lindex $args $i] == "-board"} {
	# 		set board [string toupper [lindex $args [expr {$i + 1}]]] 
	# 	} elseif {[lindex $args $i] == "-repo"} {
    #         set repos_xilinx [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-serias"} {
    #         set serias_chip [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-hwpth"} {
    #         set pth_xsahdf [lindex $args [expr {$i + 1}]]
    #     } elseif {[lindex $args $i] == "-version"} {
	# 		set version [string toupper [lindex $args [expr {$i + 1}]]] 
	# 	}
    # }
    if {[llength $args] % 2 != 0} { error "fsbl: expected key-value pairs" }
    foreach {key val} $args {
        switch -exact -- $key {
            "-board"    { set board [string tolower $val] }
            "-version"  { set version [string toupper $val] }
            "-repo_embsw"  { set repos_embsw_xilinx [resolve_path $val] }
            "-repo_dtx" { set repos_dt_xilinx [resolve_path $val] }
            "-serias"   { set serias_chip $val }
            "-hwpth"    { set pth_xsahdf $val }
        }
    }
    puts "\n=== 1. Building FSBL ==="
    fsbl -repo $repos_embsw_xilinx -serias $serias_chip -hwpth $pth_xsahdf
    puts "\n=== 2. Building PMUFW ==="
    pmufw -repo $repos_embsw_xilinx -serias $serias_chip -hwpth $pth_xsahdf
    puts "\n=== 3. Building Device Tree ==="
    build_dts -version $version -repo $repos_dt_xilinx -serias $serias_chip -hwpth $pth_xsahdf
    puts "\n All Xilinx steps completed successfully.\n"
}