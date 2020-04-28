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
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"
-- CREATED		"Fri Apr 24 14:00:05 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY fifo2ram_test IS 
	PORT
	(
		rst_n :  IN  STD_LOGIC;
		clk_50m :  IN  STD_LOGIC;
		rdempty :  IN  STD_LOGIC;
		frame_ready :  IN  STD_LOGIC;
		pixel_data :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		ram_wrclk :  OUT  STD_LOGIC;
		ram_wren :  OUT  STD_LOGIC;
		ram_address :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		ram_data :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END fifo2ram_test;

ARCHITECTURE bdf_type OF fifo2ram_test IS 

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

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN 



b2v_inst : rdfrom_fifo
GENERIC MAP(image_height => 240,
			image_width => 320,
			pixel_data_width => 8
			)
PORT MAP(rst_n => rst_n,
		 clk_50m => clk_50m,
		 rd_empty => rdempty,
		 frame_ready => frame_ready,
		 pixel_data => pixel_data,
		 data_valid => SYNTHESIZED_WIRE_0,
		 output_data => SYNTHESIZED_WIRE_1);


b2v_inst1 : ram_wr_ctler
GENERIC MAP(pixel_data_width => 8,
			ram_awidth => 16,
			ram_dwidth => 16,
			ram_wrdepth => 38400
			)
PORT MAP(rst_n => rst_n,
		 clk_50m => clk_50m,
		 data_valid => SYNTHESIZED_WIRE_0,
		 pixel_data => SYNTHESIZED_WIRE_1,
		 ram_wrclk => ram_wrclk,
		 ram_wren => ram_wren,
		 ram_address => ram_address,
		 ram_data => ram_data);


END bdf_type;