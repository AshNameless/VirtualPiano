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
-- Generated on "03/23/2020 12:26:16"
                                                            
-- Vhdl Test Bench template for design  :  Audio_Controller
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Audio_Controller_vhd_tst IS
END Audio_Controller_vhd_tst;
ARCHITECTURE Audio_Controller_arch OF Audio_Controller_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL NCO_clk_en : STD_LOGIC;
SIGNAL NCO_phase_step : STD_LOGIC_VECTOR(24 DOWNTO 0);
SIGNAL note_change : STD_LOGIC;
SIGNAL note_on : STD_LOGIC;
SIGNAL notes_data_in : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT Audio_Controller
	PORT (
	clk_50m : IN STD_LOGIC;
	NCO_clk_en : OUT STD_LOGIC;
	NCO_phase_step : OUT STD_LOGIC_VECTOR(24 DOWNTO 0);
	note_change : OUT STD_LOGIC;
	note_on : OUT STD_LOGIC;
	notes_data_in : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : Audio_Controller
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	NCO_clk_en => NCO_clk_en,
	NCO_phase_step => NCO_phase_step,
	note_change => note_change,
	note_on => note_on,
	notes_data_in => notes_data_in,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
notes_data_in <= (others => '0');
wait for 50 ns;
rst_n <= '1';
notes_data_in <= "100000001100000000100100";    
wait for 5 ns;
notes_data_in <= "100100000000000000100100";
wait for 40 ns;
notes_data_in <= "100000000000000000000000";
wait for 5 ns;
notes_data_in <= "000000001100000000100100";
wait for 10 ns;
notes_data_in <= "000000001100000000100100";              
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 10 ns;
clk_50m <= '1';
wait for 10 ns;
clk_50m <= '0';                                           
END PROCESS always;                                          
END Audio_Controller_arch;
