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
-- CREATED		"Sun Mar 29 18:33:08 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ADSR_test IS 
	PORT
	(
		clk_en :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		rst_n :  IN  STD_LOGIC;
		note_change :  IN  STD_LOGIC;
		note_on :  IN  STD_LOGIC;
		phase_stpe :  IN  STD_LOGIC_VECTOR(24 DOWNTO 0);
		note_out :  OUT  STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END ADSR_test;

ARCHITECTURE bdf_type OF ADSR_test IS 

COMPONENT nco
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 clken : IN STD_LOGIC;
		 phi_inc_i : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
		 out_valid : OUT STD_LOGIC;
		 fcos_o : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 fsin_o : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END COMPONENT;

COMPONENT adsr
	PORT(clk_50m : IN STD_LOGIC;
		 rst_n : IN STD_LOGIC;
		 note_on : IN STD_LOGIC;
		 note_change : IN STD_LOGIC;
		 out_valid : IN STD_LOGIC;
		 NCO_wave_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 note : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(11 DOWNTO 0);


BEGIN 



b2v_inst : nco
PORT MAP(clk => clk,
		 reset_n => rst_n,
		 clken => clk_en,
		 phi_inc_i => phase_stpe,
		 out_valid => SYNTHESIZED_WIRE_0,
		 fsin_o => SYNTHESIZED_WIRE_1);


b2v_inst1 : adsr
PORT MAP(clk_50m => clk,
		 rst_n => rst_n,
		 note_on => note_on,
		 note_change => note_change,
		 out_valid => SYNTHESIZED_WIRE_0,
		 NCO_wave_in => SYNTHESIZED_WIRE_1,
		 note => note_out);


END bdf_type;