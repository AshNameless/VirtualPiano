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
-- Generated on "05/09/2020 20:23:26"
                                                            
-- Vhdl Test Bench template for design  :  my_nco
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY my_nco_vhd_tst IS
END my_nco_vhd_tst;
ARCHITECTURE my_nco_arch OF my_nco_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL countnum : STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL nco_waveout : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT my_nco
	PORT (
	clk_50m : IN STD_LOGIC;
	countnum : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
	nco_waveout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : my_nco
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	countnum => countnum,
	nco_waveout => nco_waveout,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
countnum <= (others => '0');
wait for 100 ns;
rst_n <= '1';
countnum <= "00000" & x"015";
wait for 100 ns;
countnum <= (others => '0');
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 10 ns;
clk_50m <= not clk_50m;                                                     
END PROCESS always;                                          
END my_nco_arch;
