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
-- Generated on "03/26/2020 18:08:18"
                                                            
-- Vhdl Test Bench template for design  :  nco_test
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY nco_test_vhd_tst IS
END nco_test_vhd_tst;
ARCHITECTURE nco_test_arch OF nco_test_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m_in : STD_LOGIC := '0';
SIGNAL clk_en : STD_LOGIC;
SIGNAL cosine : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL nco_phase : STD_LOGIC_VECTOR(24 DOWNTO 0);
SIGNAL out_valid : STD_LOGIC;
SIGNAL rst : STD_LOGIC;
SIGNAL sine : STD_LOGIC_VECTOR(11 DOWNTO 0);
COMPONENT nco_test
	PORT (
	clk_50m_in : IN STD_LOGIC;
	clk_en : IN STD_LOGIC;
	cosine : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	nco_phase : IN STD_LOGIC_VECTOR(24 DOWNTO 0);
	out_valid : OUT STD_LOGIC;
	rst : IN STD_LOGIC;
	sine : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : nco_test
	PORT MAP (
-- list connections between master ports and signals
	clk_50m_in => clk_50m_in,
	clk_en => clk_en,
	cosine => cosine,
	nco_phase => nco_phase,
	out_valid => out_valid,
	rst => rst,
	sine => sine
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst <= '0';
clk_en <= '0';
nco_phase <= "00000" & x"4816f";
wait for 50 ns;
rst <= '1';
clk_en <= '1';                   
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 10 ns;
clk_50m_in <= '1';
wait for 10 ns;
clk_50m_in <= '0';                                                   
END PROCESS always;                                          
END nco_test_arch;
