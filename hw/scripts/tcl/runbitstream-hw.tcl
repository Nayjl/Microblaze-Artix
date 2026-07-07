set HW_PRJ_PTH "prj_hw/"
# set HW_SPEC_PTH ""

for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    switch -- $arg {
        "-p" - "--projectpth" {
            incr i
            set HW_PRJ_PTH [lindex $argv $i]
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

puts "Opening project vivado"
open_project $xpr_fullpath
update_compile_order -fileset sources_1

set num_cores [exec nproc]
if {[catch {exec nproc} num_cores]} {
    set num_cores 4
}
reset_run $name_impl -prev_step
launch_runs $name_impl -to_step write_bitstream -jobs $num_cores
update_compile_order -fileset sources_1
wait_on_run $name_impl
update_compile_order -fileset sources_1

# set sysgef_files [glob -nocomplain "$path_file_sysdef/*.sysdef"]
# if {[llength $sysgef_files] == 0} {
#     puts "ERROR: SYSDEF файл не найден в директории $path_file_sysdef"
#     exit 1
# }
# set sysdef_filename [lindex $sysgef_files 0]
# puts "Найден XPR файл: $sysdef_filename"

# file copy -force $sysdef_filename $HW_SPEC_PTH/hardware-specified.hdf
# update_compile_order -fileset sources_1

close_project
exit
