# set cur_dir [pwd]

proc resolve_path {pth} {
    if {[string index $pth 0] == "~"} {
        return [file normalize $pth]
    }
    return $pth
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
        file delete -force $pth_xsahdf/ps*init*
        file delete -force $pth_xsahdf/*.bit
    }
    hsi::open_hw_design $xsa
    if {[file isdirectory ${repos_xilinx}]} {
        puts "INFO: Adding ${repos_xilinx} repo"
        hsi::set_repo_path ${repos_xilinx}
    } else {
        puts "ERROR: Not found ${repos_xilinx} repo"
        exit 1
    }
    if {$serias_chip == "Microblaze"} {
        set select_core microblaze_0
    } elseif {$serias_chip == "Zynq"} {
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
