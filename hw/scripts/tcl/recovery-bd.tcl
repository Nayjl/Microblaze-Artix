set HW_PRJ_PTH "prj_hw/"
set HW_BD_PTH "src/bd"

for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    switch -- $arg {
        "-p" - "--projectpth" {
            incr i
            set HW_PRJ_PTH [lindex $argv $i]
        }
        "-b" - "--blockdesignpth" {
            incr i
            set HW_BD_PTH [lindex $argv $i]
        }
        default {
            puts "Unknown argument: $arg"
            exit 1
        }
    }
}

set name_synth "synth_1"
set name_impl "impl_1"

set xpr_files [glob -nocomplain "$HW_PRJ_PTH/*.xpr"]
if {[llength $xpr_files] == 0} {
    puts "ERROR: XPR файл не найден в директории $HW_PRJ_PTH"
    exit 1
}
set xpr_fullpath [lindex $xpr_files 0]
puts "Найден XPR файл: $xpr_fullpath"
set xpr_filename [file tail $xpr_fullpath]
set name_prj_vivado [file rootname $xpr_filename]
puts "Name project: $name_prj_vivado"
set path_file_sysdef $HW_PRJ_PTH/${name_prj_vivado}.runs/$name_impl

set bd_tcl_files [glob -nocomplain -type f -directory $HW_BD_PTH *.tcl]
if {[llength $bd_tcl_files] == 0} {
    puts "ERROR: Block Design tcl файлы не найдены в директории $HW_BD_PTH"
    exit 1
}

puts "Opening project vivado"
open_project $xpr_fullpath
update_compile_order -fileset sources_1

set bd_names {}
foreach tcl_file $bd_tcl_files {
    lappend bd_names [file rootname [file tail $tcl_file]]
}

foreach bd_name $bd_names {
    set bd_objs [get_files -quiet -filter "NAME =~ */${bd_name}.bd"]
    if {[llength $bd_objs] > 0} {
        remove_files $bd_objs
    }
    set wrap_objs [get_files -quiet -filter "NAME =~ */${bd_name}_wrapper.v"]
    if {[llength $wrap_objs] > 0} {
        remove_files $wrap_objs
    }
}
foreach bd_name $bd_names {
    set old_wrap [glob -nocomplain -directory $HW_PRJ_PTH ${name_prj_vivado}.srcs/sources_1/bd/${bd_name}/hdl/${bd_name}_wrapper.v]
    if {[llength $old_wrap] > 0} { 
        file delete -force $old_wrap 
        puts "INFO: Delete file $old_wrap"
    }
}
update_compile_order -fileset sources_1

foreach bd_name $bd_names {
    set old_bd [glob -nocomplain -directory $HW_PRJ_PTH ${name_prj_vivado}.srcs/sources_1/bd/${bd_name}]
    if {[llength $old_bd] > 0} { 
        file delete -force $old_bd 
        puts "INFO: Delete file $old_bd"
    }
}
update_compile_order -fileset sources_1

foreach tcl_file $bd_tcl_files {
    puts "Sourcing: $tcl_file"
    source $tcl_file
}
update_compile_order -fileset sources_1

foreach bd_name $bd_names {
    set bd_file [glob -nocomplain -directory $HW_PRJ_PTH ${name_prj_vivado}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd]
    if {[llength $bd_file] == 0} {
        puts "WARNING: BD ${bd_name}.bd не найден в проекте после source!"
        continue
    }
    puts "INFO: BD path $bd_file "
    make_wrapper -files [get_files $bd_file] -top
    
    set wrap_file [glob -nocomplain -directory $HW_PRJ_PTH ${name_prj_vivado}.srcs/sources_1/bd/${bd_name}/hdl/${bd_name}_wrapper.v]
    if {[llength $wrap_file] > 0} {
        add_files -norecurse $wrap_file
        puts "INFO: Add file $wrap_file"
    }
}
update_compile_order -fileset sources_1

close_project
exit
