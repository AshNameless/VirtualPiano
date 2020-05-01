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
-- Generated on "04/11/2020 21:08:00"
                                                            
-- Vhdl Test Bench template for design  :  OV7670_controller
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY OV7670_controller_vhd_tst IS
END OV7670_controller_vhd_tst;
ARCHITECTURE OV7670_controller_arch OF OV7670_controller_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL fifo_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fifo_wclk : STD_LOGIC;
SIGNAL fifo_wreq : STD_LOGIC;
SIGNAL fifo_wrfull : STD_LOGIC;
SIGNAL frame_ready : STD_LOGIC;
SIGNAL href : STD_LOGIC;
SIGNAL i2c_scl : STD_LOGIC;
SIGNAL i2c_sda : STD_LOGIC;
SIGNAL pclk : STD_LOGIC := '0';
SIGNAL pixel_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
SIGNAL vsyn : STD_LOGIC;
SIGNAL xclk_25m : STD_LOGIC;
COMPONENT OV7670_controller
	PORT (
	clk_50m : IN STD_LOGIC;
	fifo_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	fifo_wclk : OUT STD_LOGIC;
	fifo_wreq : OUT STD_LOGIC;
	fifo_wrfull : IN STD_LOGIC;
	frame_ready : OUT STD_LOGIC;
	href : IN STD_LOGIC;
	i2c_scl : OUT STD_LOGIC;
	i2c_sda : INOUT STD_LOGIC;
	pclk : IN STD_LOGIC;
	pixel_data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	rst_n : IN STD_LOGIC;
	vsyn : IN STD_LOGIC;
	xclk_25m : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : OV7670_controller
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	fifo_data => fifo_data,
	fifo_wclk => fifo_wclk,
	fifo_wreq => fifo_wreq,
	fifo_wrfull => fifo_wrfull,
	frame_ready => frame_ready,
	href => href,
	i2c_scl => i2c_scl,
	i2c_sda => i2c_sda,
	pclk => pclk,
	pixel_data_in => pixel_data_in,
	rst_n => rst_n,
	vsyn => vsyn,
	xclk_25m => xclk_25m
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                
fifo_wrfull <= '0';
href <= '0';
pixel_data_in <= x"00";
vsyn <= '0';                                        
rst_n <= '0';
wait for 20 ns;
rst_n <= '1';
wait;
                                                       
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
pclk <= not pclk;                               
END PROCESS always;                                          
END OV7670_controller_arch;
