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
-- Generated on "05/11/2020 20:14:50"
                                                            
-- Vhdl Test Bench template for design  :  my_filter
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY my_filter_vhd_tst IS
END my_filter_vhd_tst;
ARCHITECTURE my_filter_arch OF my_filter_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL filter_num_in : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL filtered_wave : STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
SIGNAL nco_wave_in : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT my_filter
	PORT (
	clk_50m : IN STD_LOGIC;
	filter_num_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	filtered_wave : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
	nco_wave_in : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : my_filter
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	filter_num_in => filter_num_in,
	filtered_wave => filtered_wave,
	nco_wave_in => nco_wave_in,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';  
filter_num_in <= "11000";
wait for 100 ns;
rst_n <= '1';

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

process
begin
wait for 1 ms;
nco_wave_in <= (5 => '0', others => '1');
wait for 1 ms;
nco_wave_in <= (5 => '1', others => '0');
end process;
END my_filter_arch;
