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
-- Generated on "03/29/2020 18:33:44"
                                                            
-- Vhdl Test Bench template for design  :  ADSR_test
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ADSR_test_vhd_tst IS
END ADSR_test_vhd_tst;
ARCHITECTURE ADSR_test_arch OF ADSR_test_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL clk_en : STD_LOGIC;
SIGNAL note_change : STD_LOGIC;
SIGNAL note_on : STD_LOGIC;
SIGNAL note_out : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL phase_stpe : STD_LOGIC_VECTOR(24 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT ADSR_test
	PORT (
	clk : IN STD_LOGIC;
	clk_en : IN STD_LOGIC;
	note_change : IN STD_LOGIC;
	note_on : IN STD_LOGIC;
	note_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
	phase_stpe : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : ADSR_test
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	clk_en => clk_en,
	note_change => note_change,
	note_on => note_on,
	note_out => note_out,
	phase_stpe => phase_stpe,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
clk_en <= '1';
rst_n <= '0';
note_change <= '0';
note_on <= '1';
phase_stpe <= (14 => '1', others => '0');       
wait for 20 ns;
rst_n <= '1';
wait for 12 ms;
note_on <= '0';                  
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 10 ns;
clk <= '1';
wait for 10 ns;
clk <= '0';                                                    
END PROCESS always;                                          
END ADSR_test_arch;
