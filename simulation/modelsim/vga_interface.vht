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
-- Generated on "04/28/2020 18:52:37"
                                                            
-- Vhdl Test Bench template for design  :  vga_interface
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY vga_interface_vhd_tst IS
END vga_interface_vhd_tst;
ARCHITECTURE vga_interface_arch OF vga_interface_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL b_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL blank_n : STD_LOGIC;
SIGNAL clk_50m : STD_LOGIC;
SIGNAL g_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL r_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ram_pixel_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ram_rdaddress : STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL ram_rdclk : STD_LOGIC;
SIGNAL ram_rden : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
SIGNAL sync_n : STD_LOGIC;
SIGNAL vga_clk : STD_LOGIC;
SIGNAL vga_h : STD_LOGIC;
SIGNAL vga_v : STD_LOGIC;
COMPONENT vga_interface
	PORT (
	b_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	blank_n : OUT STD_LOGIC;
	clk_50m : IN STD_LOGIC;
	g_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	r_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	ram_pixel_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	ram_rdaddress : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
	ram_rdclk : OUT STD_LOGIC;
	ram_rden : OUT STD_LOGIC;
	rst_n : IN STD_LOGIC;
	sync_n : OUT STD_LOGIC;
	vga_clk : OUT STD_LOGIC;
	vga_h : OUT STD_LOGIC;
	vga_v : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : vga_interface
	PORT MAP (
-- list connections between master ports and signals
	b_data => b_data,
	blank_n => blank_n,
	clk_50m => clk_50m,
	g_data => g_data,
	r_data => r_data,
	ram_pixel_data => ram_pixel_data,
	ram_rdaddress => ram_rdaddress,
	ram_rdclk => ram_rdclk,
	ram_rden => ram_rden,
	rst_n => rst_n,
	sync_n => sync_n,
	vga_clk => vga_clk,
	vga_h => vga_h,
	vga_v => vga_v
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END vga_interface_arch;
