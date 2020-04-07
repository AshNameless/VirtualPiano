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
-- Generated on "04/07/2020 17:20:31"
                                                            
-- Vhdl Test Bench template for design  :  WM8731_controller
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY WM8731_controller_vhd_tst IS
END WM8731_controller_vhd_tst;
ARCHITECTURE WM8731_controller_arch OF WM8731_controller_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL AUD_BCLK : STD_LOGIC;
SIGNAL AUD_DACDAT : STD_LOGIC;
SIGNAL AUD_DACLRCK : STD_LOGIC;
SIGNAL AUD_MCLK : STD_LOGIC;
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL I2C_SCLK : STD_LOGIC;
SIGNAL I2C_SDAT : STD_LOGIC;
SIGNAL note_data : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
COMPONENT WM8731_controller
	PORT (
	AUD_BCLK : OUT STD_LOGIC;
	AUD_DACDAT : OUT STD_LOGIC;
	AUD_DACLRCK : OUT STD_LOGIC;
	AUD_MCLK : OUT STD_LOGIC;
	clk_50m : IN STD_LOGIC;
	I2C_SCLK : OUT STD_LOGIC;
	I2C_SDAT : INOUT STD_LOGIC;
	note_data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : WM8731_controller
	PORT MAP (
-- list connections between master ports and signals
	AUD_BCLK => AUD_BCLK,
	AUD_DACDAT => AUD_DACDAT,
	AUD_DACLRCK => AUD_DACLRCK,
	AUD_MCLK => AUD_MCLK,
	clk_50m => clk_50m,
	I2C_SCLK => I2C_SCLK,
	I2C_SDAT => I2C_SDAT,
	note_data => note_data,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
note_data <= "100110011001100110011001";       
wait for 50 ns;
rst_n <= '1';             
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
END WM8731_controller_arch;
