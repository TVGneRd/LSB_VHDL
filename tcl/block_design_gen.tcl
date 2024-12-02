update_compile_order -fileset sources_1
create_bd_design "design_1"

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
set_property -dict [list CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]
set_property -dict [list CONFIG.SUPPORTS_NARROW_BURST.VALUE_SRC PROPAGATED] [get_bd_cells axi_bram_ctrl_0]
set_property -dict [list CONFIG.DATA_WIDTH {32} CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
set_property -dict [list \
  CONFIG.Write_Width_A {32} \
  CONFIG.use_bram_block {Stand_Alone} \
] [get_bd_cells blk_mem_gen_0]

# create_bd_port -dir I -from 31 -to 0 -type data simulateTrafic
# create_bd_port -dir I simulateTrafic_valid
create_bd_port -dir I -type clk -freq_hz 250000000 refclk
create_bd_port -dir I -type rst sys_rst_n
connect_bd_net [get_bd_ports sys_rst_n] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_ports refclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]

create_bd_cell -type ip -vlnv SUAI:STUDENT:ip_block_axi:1.0 ip_block_axi

connect_bd_net [get_bd_pins ip_block_axi/m_axi_awaddr] [get_bd_pins axi_bram_ctrl_0/s_axi_awaddr]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_awvalid] [get_bd_pins axi_bram_ctrl_0/s_axi_awvalid]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_awready] [get_bd_pins axi_bram_ctrl_0/s_axi_awready]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_wdata] [get_bd_pins axi_bram_ctrl_0/s_axi_wdata]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_wvalid] [get_bd_pins axi_bram_ctrl_0/s_axi_wvalid]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_wready] [get_bd_pins axi_bram_ctrl_0/s_axi_wready]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_bresp] [get_bd_pins axi_bram_ctrl_0/s_axi_bresp]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_bvalid] [get_bd_pins axi_bram_ctrl_0/s_axi_bvalid]
connect_bd_net [get_bd_pins ip_block_axi/m_axi_bready] [get_bd_pins axi_bram_ctrl_0/s_axi_bready]

connect_bd_net [get_bd_ports refclk] [get_bd_pins ip_block_axi/refclk]
connect_bd_net [get_bd_ports sys_rst_n] [get_bd_pins ip_block_axi/rst]

make_wrapper -files [get_files $CURRENT_DIR/$PROJECT_NAME/$PROJECT_NAME.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $CURRENT_DIR/$PROJECT_NAME/$PROJECT_NAME.gen/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
set_property library work [get_files $CURRENT_DIR/$PROJECT_NAME/$PROJECT_NAME.gen/sources_1/bd/design_1/hdl/design_1_wrapper.vhd]
update_compile_order -fileset sources_1



set_property top design_tb [get_filesets sim_1]