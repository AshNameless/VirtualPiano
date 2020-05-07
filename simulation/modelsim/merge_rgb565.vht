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
-- Generated on "05/04/2020 19:19:53"
                                                            
-- Vhdl Test Bench template for design  :  merge_rgb565
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;        
use ieee.std_logic_unsigned.all;                        

ENTITY merge_rgb565_vhd_tst IS
END merge_rgb565_vhd_tst;
ARCHITECTURE merge_rgb565_arch OF merge_rgb565_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_pixel : STD_LOGIC := '0';
SIGNAL frame_syn : STD_LOGIC;
SIGNAL in_data_valid : STD_LOGIC;
SIGNAL output_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL pclk : STD_LOGIC;
SIGNAL pixel_data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
SIGNAL rst_n : STD_LOGIC;
COMPONENT merge_rgb565
	PORT (
	clk_pixel : IN STD_LOGIC;
	frame_syn : OUT STD_LOGIC;
	in_data_valid : IN STD_LOGIC;
	output_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	pclk : OUT STD_LOGIC;
	pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : merge_rgb565
	PORT MAP (
-- list connections between master ports and signals
	clk_pixel => clk_pixel,
	frame_syn => frame_syn,
	in_data_valid => in_data_valid,
	output_data => output_data,
	pclk => pclk,
	pixel_data => pixel_data,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
in_data_valid <= '0';
wait for 50 ns;
rst_n <= '1';
in_data_valid <= '1';                 
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 20 ns;
clk_pixel <= not clk_pixel;
pixel_data <= pixel_data + 1;                                                      
END PROCESS always;                                          
END merge_rgb565_arch;
