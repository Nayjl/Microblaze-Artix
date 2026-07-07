# set cur_dir [pwd]


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
	set fsbl_design [hsi::create_sw_design fsbl_1 -proc $select_core -app $select_fsbl]
	if {$board != 0} {
		common::set_property -name APP_COMPILER_FLAGS -value "-DXPS_BOARD_${board}" -objects $fsbl_design
	}
	hsi::generate_app -dir $pth_xsahdf/fsbl -compile
	hsi::close_hw_design [hsi::current_hw_design]
}

proc pmufw {args} {
    set pth_xsahdf ../../spec_hw
    set serias_chip "Zynqmp"
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
    if {$serias_chip == "Zynqmp"} {
        set xsa [glob -nocomplain -directory $pth_xsahdf -type f *.xsa *.hdf]
        if {[llength $xsa] == 0} {
            puts "ERROR: No .xsa or .hdf found in $pth_xsahdf"
            exit 1
        }
        if {[file exists $pth_xsahdf/pmufw]} {
            puts "INFO: Cleaning up existing $pth_xsahdf/pmufw directory..."
            file delete -force $pth_xsahdf/pmufw
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
        hsi::generate_app -app zynqmp_pmufw -proc psu_pmu_0 -dir $pth_xsahdf/pmufw -compile
        hsi::close_hw_design [hsi::current_hw_design]
    } else {
        puts "INFO: PMUFW is not supported for $serias_chip. Skipping."
        return
    }
}

proc build_all {args} {
    set board 0
	set version 2020.2
    set pth_xsahdf ../../spec_hw
    set serias_chip "Zynq"
    set repos_embsw_xilinx ~/work/repo_xlnx/embeddedsw
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
            "-repo"     { set repos_embsw_xilinx [resolve_path $val] }
            "-serias"   { set serias_chip $val }
            "-hwpth"    { set pth_xsahdf $val }
        }
    }
    puts "\n=== 1. Building FSBL ==="
    fsbl -repo $repos_embsw_xilinx -serias $serias_chip -hwpth $pth_xsahdf
    puts "\n=== 2. Building PMUFW ==="
    pmufw -repo $repos_embsw_xilinx -serias $serias_chip -hwpth $pth_xsahdf
    puts "\n All Xilinx steps completed successfully.\n"
}