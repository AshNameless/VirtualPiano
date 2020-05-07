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
-- Generated on "05/04/2020 17:57:51"
                                                            
-- Vhdl Test Bench template for design  :  rdfrom_fifo
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY rdfrom_fifo_vhd_tst IS
END rdfrom_fifo_vhd_tst;
ARCHITECTURE rdfrom_fifo_arch OF rdfrom_fifo_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk_50m : STD_LOGIC := '0';
SIGNAL clk_pixel : STD_LOGIC;
SIGNAL data_valid : STD_LOGIC;
SIGNAL frame_ready : STD_LOGIC;
SIGNAL output_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL pixel_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL rd_clk : STD_LOGIC;
SIGNAL rd_empty : STD_LOGIC;
SIGNAL rd_req : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
COMPONENT rdfrom_fifo
	PORT (
	clk_50m : IN STD_LOGIC;
	clk_pixel : OUT STD_LOGIC;
	data_valid : OUT STD_LOGIC;
	frame_ready : IN STD_LOGIC;
	output_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	rd_clk : OUT STD_LOGIC;
	rd_empty : IN STD_LOGIC;
	rd_req : OUT STD_LOGIC;
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : rdfrom_fifo
	PORT MAP (
-- list connections between master ports and signals
	clk_50m => clk_50m,
	clk_pixel => clk_pixel,
	data_valid => data_valid,
	frame_ready => frame_ready,
	output_data => output_data,
	pixel_data => pixel_data,
	rd_clk => rd_clk,
	rd_empty => rd_empty,
	rd_req => rd_req,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
rst_n <= '0';
frame_ready <= '0';              
pixel_data <= (others => '1');
rd_empty <= '0';
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
END rdfrom_fifo_arch;
