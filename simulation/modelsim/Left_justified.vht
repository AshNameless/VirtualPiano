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

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "04/07/2020 11:10:19"
                                                            
-- Vhdl Test Bench template for design  :  Left_justified
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Left_justified_vhd_tst IS
END Left_justified_vhd_tst;
ARCHITECTURE Left_justified_arch OF Left_justified_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL AUD_BCLK : STD_LOGIC;
SIGNAL AUD_DACDAT : STD_LOGIC;
SIGNAL AUD_DACLRCK : STD_LOGIC;
SIGNAL AUD_MCLK : STD_LOGIC;
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL note_data : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT Left_justified
	PORT (
	AUD_BCLK : OUT STD_LOGIC;
	AUD_DACDAT : OUT STD_LOGIC;
	AUD_DACLRCK : OUT STD_LOGIC;
	AUD_MCLK : OUT STD_LOGIC;
	clk_50m : IN STD_LOGIC;
	note_data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : Left_justified
	PORT MAP (
-- list connections between master ports and signals
	AUD_BCLK => AUD_BCLK,
	AUD_DACDAT => AUD_DACDAT,
	AUD_DACLRCK => AUD_DACLRCK,
	AUD_MCLK => AUD_MCLK,
	clk_50m => clk_50m,
	note_data => note_data,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
note_data <= "000100010001000100010001";       
wait for 50 ns;
rst_n <= '1';                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
                     
BEGIN                                                         
wait for 10 ns;
clk_50m <= '1';
wait for 10 ns;
clk_50m <= '0';                                                  
END PROCESS always;                                          
END Left_justified_arch;
