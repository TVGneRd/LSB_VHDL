ipx::package_project -root_dir ../../ip/$PROJECT_NAME -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current false
ipx::unload_core ../../ip/$PROJECT_NAME/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory ../../ip/$PROJECT_NAME ../../ip/$PROJECT_NAME/component.xml
set_property vendor SUIA [ipx::current_core]
set_property library STUDENT [ipx::current_core]
set_property name $PROJECT_NAME [ipx::current_core]
set_property display_name $PROJECT_NAME [ipx::current_core]
set_property vendor SUAI [ipx::current_core]
set_property description {custom axi handler} [ipx::current_core]
set_property vendor_display_name SUAI [ipx::current_core]

ipx::merge_project_changes hdl_parameters [ipx::current_core]
set_property display_name axi [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::add_bus_interface refclk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:clock:1.0 [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]
set_property value 250000000 [ipx::get_bus_parameters FREQ_HZ -of_objects [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]]
set_property physical_name refclk [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces rst -of_objects [ipx::current_core]]]
set_property physical_name rst [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces rst -of_objects [ipx::current_core]]]
ipx::add_port_map CLK [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]
set_property physical_name refclk [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces refclk -of_objects [ipx::current_core]]]
set_property core_revision 2 [ipx::current_core]
ipx::add_bus_parameter PROTOCOL [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property value AXI4 [ipx::get_bus_parameters PROTOCOL -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
set_property name M_AXI [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]


update_compile_order -fileset sources_1
set_property core_revision 1 [ipx::current_core]
ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project
set_property  ip_repo_paths  {../../ip/$PROJECT_NAME } [current_project]
update_ip_catalog