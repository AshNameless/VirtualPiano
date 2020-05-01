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
-- CREATED		"Thu Apr 30 12:26:20 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY VirtualPiano IS 
	PORT
	(
		pclk :  IN  STD_LOGIC;
		vsyn :  IN  STD_LOGIC;
		href :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		clk_50m :  IN  STD_LOGIC;
		pin_name1 :  IN  STD_LOGIC;
		pixel_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		xclk_25m :  OUT  STD_LOGIC;
		i2c_sda :  OUT  STD_LOGIC;
		i2c_scl :  OUT  STD_LOGIC
	);
END VirtualPiano;

ARCHITECTURE bdf_type OF VirtualPiano IS 

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



BEGIN 



b2v_inst5 : camera_controller
GENERIC MAP(pixel_data_width => 8,
			register_num => 8
			)
PORT MAP(clk_50m => clk_50m,
		 rst_n => rst_n,
		 pclk => pclk,
		 vsyn => vsyn,
		 href => href,
		 fifo_wrfull => pin_name1,
		 i2c_sda => i2c_sda,
		 pixel_data_in => pixel_data,
		 i2c_scl => i2c_scl,
		 xclk_25m => xclk_25m);


END bdf_type;