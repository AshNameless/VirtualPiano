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
-- Generated on "04/05/2020 12:03:44"
                                                            
-- Vhdl Test Bench template for design  :  I2C
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY I2C_vhd_tst IS
END I2C_vhd_tst;
ARCHITECTURE I2C_arch OF I2C_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC;
SIGNAL data : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL done : STD_LOGIC;
SIGNAL error : STD_LOGIC;
SIGNAL i2c_scl : STD_LOGIC;
SIGNAL i2c_sda : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
SIGNAL send : STD_LOGIC;
COMPONENT I2C
	PORT (
	clk_50m : IN STD_LOGIC := '0';
	data : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	done : OUT STD_LOGIC;
	error : OUT STD_LOGIC;
	i2c_scl : OUT STD_LOGIC;
	i2c_sda : INOUT STD_LOGIC;
	rst_n : IN STD_LOGIC;
	send : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : I2C
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	data => data,
	done => done,
	error => error,
	i2c_scl => i2c_scl,
	i2c_sda => i2c_sda,
	rst_n => rst_n,
	send => send
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                            
--data <= "101010101010101010101010";                          
data <= "101010101010101010101010"; 
rst_n <= '0';
send <= '1';
i2c_sda <= 'Z';
wait for 50 ns;
rst_n <= '1';

wait for 89950 ns;
i2c_sda <= '0';
wait for 6000 ns;
i2c_sda <= 'Z';

wait for 84000 ns;
i2c_sda <= '0';
wait for 6000 ns;
i2c_sda <= 'Z';           

wait for 84000 ns;
i2c_sda <= '0';
wait for 6000 ns;
i2c_sda <= 'Z'; 

WAIT;                                      
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 10 ns;
clk_50m <= '0';
wait for 10 ns;
clk_50m <= '1';
END PROCESS always;                                          
END I2C_arch;
