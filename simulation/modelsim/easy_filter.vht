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
-- Generated on "05/07/2020 22:02:39"
                                                            
-- Vhdl Test Bench template for design  :  easy_filter
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY easy_filter_vhd_tst IS
END easy_filter_vhd_tst;
ARCHITECTURE easy_filter_arch OF easy_filter_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL fsyn_in : STD_LOGIC;
SIGNAL fsyn_out : STD_LOGIC;
SIGNAL pclk_in : STD_LOGIC := '0';
SIGNAL pclk_out : STD_LOGIC;
SIGNAL pixel_in : STD_LOGIC := '0';
SIGNAL pixel_out : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
COMPONENT easy_filter
	PORT (
	fsyn_in : IN STD_LOGIC;
	fsyn_out : OUT STD_LOGIC;
	pclk_in : IN STD_LOGIC;
	pclk_out : OUT STD_LOGIC;
	pixel_in : IN STD_LOGIC;
	pixel_out : OUT STD_LOGIC;
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : easy_filter
	PORT MAP (
-- list connections between master ports and signals
	fsyn_in => fsyn_in,
	fsyn_out => fsyn_out,
	pclk_in => pclk_in,
	pclk_out => pclk_out,
	pixel_in => pixel_in,
	pixel_out => pixel_out,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
fsyn_in <= '0';
pixel_in <= '0';
wait for 10 ns;
rst_n <= '1';
wait for 150 ns;
fsyn_in <= '1';
pixel_in <= '1';
wait for 160*5  ns;
pixel_in <= '0';
                   
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 80 ns;
pclk_in <= not pclk_in;                                                     
END PROCESS always;                                          
END easy_filter_arch;
