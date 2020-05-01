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
-- Generated on "04/24/2020 14:01:07"
                                                            
-- Vhdl Test Bench template for design  :  fifo2ram_test
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY fifo2ram_test_vhd_tst IS
END fifo2ram_test_vhd_tst;
ARCHITECTURE fifo2ram_test_arch OF fifo2ram_test_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL frame_ready : STD_LOGIC;
SIGNAL pixel_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ram_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ram_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ram_wrclk : STD_LOGIC;
SIGNAL ram_wren : STD_LOGIC;
SIGNAL rdempty : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
COMPONENT fifo2ram_test
	PORT (
	clk_50m : IN STD_LOGIC;
	frame_ready : IN STD_LOGIC;
	pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	ram_address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	ram_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	ram_wrclk : OUT STD_LOGIC;
	ram_wren : OUT STD_LOGIC;
	rdempty : IN STD_LOGIC;
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : fifo2ram_test
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	frame_ready => frame_ready,
	pixel_data => pixel_data,
	ram_address => ram_address,
	ram_data => ram_data,
	ram_wrclk => ram_wrclk,
	ram_wren => ram_wren,
	rdempty => rdempty,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
frame_ready <= '0';              
pixel_data <= (others => '1');
rdempty <= '0';
wait for 25 ns;
rst_n <= '1';
frame_ready <= '1';                    
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
END fifo2ram_test_arch;
