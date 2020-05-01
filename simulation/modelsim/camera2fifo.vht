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
-- Generated on "04/11/2020 19:55:26"
                                                            
-- Vhdl Test Bench template for design  :  camera2fifo
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY camera2fifo_vhd_tst IS
END camera2fifo_vhd_tst;
ARCHITECTURE camera2fifo_arch OF camera2fifo_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL fifo_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fifo_wclk : STD_LOGIC;
SIGNAL fifo_wreq : STD_LOGIC;
SIGNAL fifo_wrfull : STD_LOGIC;
SIGNAL frame_ready : STD_LOGIC;
SIGNAL href : STD_LOGIC;
SIGNAL pclk : STD_LOGIC := '0';
SIGNAL pixel_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rst_n : STD_LOGIC;
SIGNAL vsyn : STD_LOGIC;
COMPONENT camera2fifo
	PORT (
	fifo_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	fifo_wclk : OUT STD_LOGIC;
	fifo_wreq : OUT STD_LOGIC;
	fifo_wrfull : IN STD_LOGIC;
	frame_ready : OUT STD_LOGIC;
	href : IN STD_LOGIC;
	pclk : IN STD_LOGIC;
	pixel_data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	rst_n : IN STD_LOGIC;
	vsyn : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : camera2fifo
	PORT MAP (
-- list connections between master ports and signals
	fifo_data => fifo_data,
	fifo_wclk => fifo_wclk,
	fifo_wreq => fifo_wreq,
	fifo_wrfull => fifo_wrfull,
	frame_ready => frame_ready,
	href => href,
	pclk => pclk,
	pixel_data_in => pixel_data_in,
	rst_n => rst_n,
	vsyn => vsyn
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
fifo_wrfull <= '0';
pixel_data_in <= x"00";
vsyn <= '0';
href <= '0';
wait for 40 ns;
rst_n <= '1';
vsyn <= '1';
wait for 3*784*2*40 ns;
vsyn <= '0';
wait for 17*784*2*40 ns;
href <= '1';
wait for 640*2*40 ns;
href <= '0';



WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
wait for 20 ns;
pclk <= '1';
wait for 20 ns;
pclk <= '0';                                                  
END PROCESS always;                                          
END camera2fifo_arch;
