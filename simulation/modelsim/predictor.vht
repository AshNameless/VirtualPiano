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
-- Generated on "05/08/2020 20:31:54"
                                                            
-- Vhdl Test Bench template for design  :  predictor
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY predictor_vhd_tst IS
END predictor_vhd_tst;
ARCHITECTURE predictor_arch OF predictor_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL fsyn : STD_LOGIC;
SIGNAL key_statuses : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL pclk : STD_LOGIC := '0';
SIGNAL pixel : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
COMPONENT predictor
	PORT (
	fsyn : IN STD_LOGIC;
	key_statuses : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
	pclk : IN STD_LOGIC;
	pixel : IN STD_LOGIC;
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : predictor
	PORT MAP (
-- list connections between master ports and signals
	fsyn => fsyn,
	key_statuses => key_statuses,
	pclk => pclk,
	pixel => pixel,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
pixel <= '0';
fsyn <= '0';
wait for 10 ns;
rst_n <= '1';
wait for 150 ns;
fsyn <= '1';
pixel <= '1';
wait for 76800 * 160 ns;
fsyn <= '0';
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 80 ns;
pclk <= not pclk;                                           
END PROCESS always;                                          
END predictor_arch;
