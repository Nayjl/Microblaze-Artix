
set pth_hw_prj $env(PATH_HW_PRJ)
set name_prj_vivado $env(NAME_HW_PRJ)
set name_bd $env(NAME_BD)
set name_synth "synth_1"
set name_impl "impl_1"
set pth_export_hdf $env(PATH_EXPORT_HDF)

set pth_hw_prj $pth_hw_prj/$name_prj_vivado
set pth_bd $pth_hw_prj/$name_bd
set path_file_sysdef $pth_hw_prj/${name_prj_vivado}.runs/$name_impl


set xpr_files [glob -nocomplain "$pth_hw_prj/*.xpr"]
if {[llength $xpr_files] == 0} {
    puts "ERROR: XPR файл не найден в директории $pth_hw_prj"
    exit 1
}
set xpr_filename [lindex $xpr_files 0]
puts "Найден XPR файл: $xpr_filename"


puts "Opening project vivado"
open_project $xpr_filename
update_compile_order -fileset sources_1

set pth_bd_wrapper $pth_hw_prj/${name_prj_vivado}.srcs/sources_1/bd/$name_bd/hdl/${name_bd}_wrapper.v
set pth_bd_source $pth_hw_prj/${name_prj_vivado}.srcs/sources_1/bd/$name_bd/${name_bd}.bd

export_ip_user_files -of_objects  [get_files $pth_bd_wrapper] -no_script -reset -force -quiet
export_ip_user_files -of_objects  [get_files $pth_bd_source] -no_script -reset -force -quiet
remove_files $pth_bd_wrapper
remove_files $pth_bd_source
update_compile_order -fileset sources_1

source ${pth_bd}.tcl
update_compile_order -fileset sources_1

make_wrapper -files [get_files $pth_bd_source] -top
add_files -norecurse $pth_bd_wrapper
update_compile_order -fileset sources_1

set num_cores [exec nproc]
if {[catch {exec nproc} num_cores]} {
    set num_cores 4
}
launch_runs $name_impl -to_step write_bitstream -jobs $num_cores
update_compile_order -fileset sources_1
wait_on_run $name_impl

set sysgef_files [glob -nocomplain "$path_file_sysdef/*.sysdef"]
if {[llength $sysgef_files] == 0} {
    puts "ERROR: SYSDEF файл не найден в директории $path_file_sysdef"
    exit 1
}
set sysdef_filename [lindex $sysgef_files 0]
puts "Найден XPR файл: $sysdef_filename"

file copy -force $sysdef_filename $pth_export_hdf/topmodule.hdf
update_compile_order -fileset sources_1

close_project
exit