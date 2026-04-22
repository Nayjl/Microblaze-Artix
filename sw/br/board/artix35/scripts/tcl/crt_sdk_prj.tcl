set cur_dir [pwd]

set argc [llength $argv]
puts "Количество аргументов: $argc"

set path_sdk_dir [lindex $argv 0]

set name_hw_platform $env(NM_HW_PLATFORM)
set name_prj_fsbl $env(NM_PRJ_FSBL)
set name_prj_fsbl_bsp $env(NM_PRJ_FSBL_BSP)
set name_prj_devicetree $env(NM_PRJ_DEVICE_TREE)

puts $name_hw_platform
puts $name_prj_fsbl
puts $name_prj_fsbl_bsp
puts $name_prj_devicetree

set hdf_files [glob -nocomplain "$path_sdk_dir/*.hdf"]
if {[llength $hdf_files] == 0} {
    puts "ERROR: HDF файл не найден в директории $path_sdk_dir"
    exit 1
}
set hdf_filename [lindex $hdf_files 0]
puts "Найден HDF файл: $hdf_filename"


if {[file exists $path_sdk_dir]} {
    setws $path_sdk_dir
    puts "Рабочая область установлена: $path_sdk_dir"
} else {
    puts "ERROR: Директория $path_sdk_dir не существует"
    exit 1
}


puts "Очистка существующих проектов..."
catch {sdk deleteprojects -name $name_hw_platform}
catch {sdk deleteprojects -name $name_prj_fsbl_bsp}
catch {sdk deleteprojects -name $name_prj_fsbl}
catch {sdk deleteprojects -name $name_prj_devicetree}

createhw -name $name_hw_platform -hwspec $hdf_filename
puts "Hardware Platform создана: $name_hw_platform"


createapp -name $name_prj_fsbl -hwproject $name_hw_platform -proc microblaze_0 -os standalone -lang C -app "SREC SPI Bootloader"
puts "Проект FSBL создан: $name_prj_fsbl"
projects -build -type bsp -name $name_prj_fsbl_bsp
projects -build -type app -name $name_prj_fsbl



createbsp -name $name_prj_devicetree -hwproject $name_hw_platform -proc microblaze_0 -os device_tree
puts "BSP создан: $name_prj_devicetree"



exit