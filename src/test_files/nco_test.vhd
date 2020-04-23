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
-- CREATED		"Thu Mar 26 18:05:25 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY nco_test IS 
	PORT
	(
		clk_50m_in :  IN  STD_LOGIC;
		rst :  IN  STD_LOGIC;
		clk_en :  IN  STD_LOGIC;
		nco_phase :  IN  STD_LOGIC_VECTOR(24 DOWNTO 0);
		out_valid :  OUT  STD_LOGIC;
		cosine :  OUT  STD_LOGIC_VECTOR(11 DOWNTO 0);
		sine :  OUT  STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END nco_test;

ARCHITECTURE bdf_type OF nco_test IS 

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



BEGIN 



b2v_inst : nco
PORT MAP(clk => clk_50m_in,
		 reset_n => rst,
		 clken => clk_en,
		 phi_inc_i => nco_phase,
		 out_valid => out_valid,
		 fcos_o => cosine,
		 fsin_o => sine);


END bdf_type;