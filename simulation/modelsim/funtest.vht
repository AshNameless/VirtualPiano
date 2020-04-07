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
-- Generated on "03/29/2020 13:24:55"
                                                            
-- Vhdl Test Bench template for design  :  funtest
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY funtest_vhd_tst IS
END funtest_vhd_tst;
ARCHITECTURE funtest_arch OF funtest_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL a : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL b : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL c : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL clk : STD_LOGIC := '0';
SIGNAL rst : STD_LOGIC;
COMPONENT funtest
	PORT (
	a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	b : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	c : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : funtest
	PORT MAP (
-- list connections between master ports and signals
	a => a,
	b => b,
	c => c,
	clk => clk,
	rst => rst
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst <= '0';
wait for 10 ns;
rst <= '1';                     
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
                    
BEGIN                                                         
wait for 10 ns;
clk <= '1';
wait for 10 ns;
clk <= '0';                                                  
END PROCESS always;                                          
END funtest_arch;
