-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Full Version"
-- CREATED		"Thu Apr 30 12:20:42 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY display_test IS 
	PORT
	(
		pclk :  IN  STD_LOGIC;
		vsyn :  IN  STD_LOGIC;
		href :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		clk_50m :  IN  STD_LOGIC;
		pixel_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		xclk_25m :  OUT  STD_LOGIC;
		i2c_sda :  OUT  STD_LOGIC;
		i2c_scl :  OUT  STD_LOGIC;
		VGA_CLK :  OUT  STD_LOGIC;
		VGA_SYNC_N :  OUT  STD_LOGIC;
		VGA_BLANK_N :  OUT  STD_LOGIC;
		VGA_VS :  OUT  STD_LOGIC;
		VGA_HS :  OUT  STD_LOGIC;
		VGA_B :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_G :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_R :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END display_test;

ARCHITECTURE bdf_type OF display_test IS 

COMPONENT fifo
	PORT(wrreq : IN STD_LOGIC;
		 wrclk : IN STD_LOGIC;
		 rdreq : IN STD_LOGIC;
		 rdclk : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 wrfull : OUT STD_LOGIC;
		 rdempty : OUT STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram
	PORT(wren : IN STD_LOGIC;
		 rden : IN STD_LOGIC;
		 wrclock : IN STD_LOGIC;
		 rdclock : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT camera_controller
GENERIC (pixel_data_width : INTEGER;
			register_num : INTEGER
			);
	PORT(clk_50m : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 pclk : IN STD_LOGIC;
		 vsyn : IN STD_LOGIC;
		 href : IN STD_LOGIC;
		 fifo_wrfull : IN STD_LOGIC;
		 i2c_sda : INOUT STD_LOGIC;
		 pixel_data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 i2c_scl : OUT STD_LOGIC;
		 frame_ready : OUT STD_LOGIC;
		 xclk_25m : OUT STD_LOGIC;
		 fifo_wreq : OUT STD_LOGIC;
		 fifo_wclk : OUT STD_LOGIC;
		 fifo_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rdfrom_fifo
GENERIC (image_height : INTEGER;
			image_width : INTEGER;
			pixel_data_width : INTEGER
			);
	PORT(rst_n : IN STD_LOGIC;
		 clk_50m : IN STD_LOGIC;
		 rd_empty : IN STD_LOGIC;
		 frame_ready : IN STD_LOGIC;
		 pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_valid : OUT STD_LOGIC;
		 rd_clk : OUT STD_LOGIC;
		 rd_req : OUT STD_LOGIC;
		 output_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram_wr_ctler
GENERIC (pixel_data_width : INTEGER;
			ram_awidth : INTEGER;
			ram_dwidth : INTEGER;
			ram_wrdepth : INTEGER
			);
	PORT(rst_n : IN STD_LOGIC;
		 clk_50m : IN STD_LOGIC;
		 data_valid : IN STD_LOGIC;
		 pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ram_wrclk : OUT STD_LOGIC;
		 ram_wren : OUT STD_LOGIC;
		 ram_address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ram_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT vga_interface
GENERIC (blue_width : INTEGER;
			green_width : INTEGER;
			image_height : INTEGER;
			image_width : INTEGER;
			ram_awidth : INTEGER;
			ram_dwidth : INTEGER;
			ram_rddepth : INTEGER;
			red_width : INTEGER
			);
	PORT(clk_50m : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 ram_pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 vga_h : OUT STD_LOGIC;
		 vga_v : OUT STD_LOGIC;
		 vga_clk : OUT STD_LOGIC;
		 sync_n : OUT STD_LOGIC;
		 blank_n : OUT STD_LOGIC;
		 ram_rden : OUT STD_LOGIC;
		 ram_rdclk : OUT STD_LOGIC;
		 b_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 g_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 r_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ram_rdaddress : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 



b2v_inst : fifo
PORT MAP(wrreq => SYNTHESIZED_WIRE_0,
		 wrclk => SYNTHESIZED_WIRE_1,
		 rdreq => SYNTHESIZED_WIRE_2,
		 rdclk => SYNTHESIZED_WIRE_3,
		 data => SYNTHESIZED_WIRE_4,
		 wrfull => SYNTHESIZED_WIRE_12,
		 rdempty => SYNTHESIZED_WIRE_13,
		 q => SYNTHESIZED_WIRE_15);


b2v_inst1 : ram
PORT MAP(wren => SYNTHESIZED_WIRE_5,
		 rden => SYNTHESIZED_WIRE_6,
		 wrclock => SYNTHESIZED_WIRE_7,
		 rdclock => SYNTHESIZED_WIRE_8,
		 data => SYNTHESIZED_WIRE_9,
		 rdaddress => SYNTHESIZED_WIRE_10,
		 wraddress => SYNTHESIZED_WIRE_11,
		 q => SYNTHESIZED_WIRE_18);


b2v_inst5 : camera_controller
GENERIC MAP(pixel_data_width => 8,
			register_num => 8
			)
PORT MAP(clk_50m => clk_50m,
		 rst_n => rst_n,
		 pclk => pclk,
		 vsyn => vsyn,
		 href => href,
		 fifo_wrfull => SYNTHESIZED_WIRE_12,
		 i2c_sda => i2c_sda,
		 pixel_data_in => pixel_data,
		 i2c_scl => i2c_scl,
		 frame_ready => SYNTHESIZED_WIRE_14,
		 xclk_25m => xclk_25m,
		 fifo_wreq => SYNTHESIZED_WIRE_0,
		 fifo_wclk => SYNTHESIZED_WIRE_1,
		 fifo_data => SYNTHESIZED_WIRE_4);


b2v_inst6 : rdfrom_fifo
GENERIC MAP(image_height => 240,
			image_width => 320,
			pixel_data_width => 8
			)
PORT MAP(rst_n => rst_n,
		 clk_50m => clk_50m,
		 rd_empty => SYNTHESIZED_WIRE_13,
		 frame_ready => SYNTHESIZED_WIRE_14,
		 pixel_data => SYNTHESIZED_WIRE_15,
		 data_valid => SYNTHESIZED_WIRE_16,
		 rd_clk => SYNTHESIZED_WIRE_3,
		 rd_req => SYNTHESIZED_WIRE_2,
		 output_data => SYNTHESIZED_WIRE_17);


b2v_inst7 : ram_wr_ctler
GENERIC MAP(pixel_data_width => 8,
			ram_awidth => 16,
			ram_dwidth => 16,
			ram_wrdepth => 38400
			)
PORT MAP(rst_n => rst_n,
		 clk_50m => clk_50m,
		 data_valid => SYNTHESIZED_WIRE_16,
		 pixel_data => SYNTHESIZED_WIRE_17,
		 ram_wrclk => SYNTHESIZED_WIRE_7,
		 ram_wren => SYNTHESIZED_WIRE_5,
		 ram_address => SYNTHESIZED_WIRE_11,
		 ram_data => SYNTHESIZED_WIRE_9);


b2v_inst8 : vga_interface
GENERIC MAP(blue_width => 8,
			green_width => 8,
			image_height => 240,
			image_width => 320,
			ram_awidth => 17,
			ram_dwidth => 8,
			ram_rddepth => 76800,
			red_width => 8
			)
PORT MAP(clk_50m => clk_50m,
		 rst_n => rst_n,
		 ram_pixel_data => SYNTHESIZED_WIRE_18,
		 vga_h => VGA_HS,
		 vga_v => VGA_VS,
		 vga_clk => VGA_CLK,
		 sync_n => VGA_SYNC_N,
		 blank_n => VGA_BLANK_N,
		 ram_rden => SYNTHESIZED_WIRE_6,
		 ram_rdclk => SYNTHESIZED_WIRE_8,
		 b_data => VGA_B,
		 g_data => VGA_G,
		 r_data => VGA_R,
		 ram_rdaddress => SYNTHESIZED_WIRE_10);


END bdf_type;