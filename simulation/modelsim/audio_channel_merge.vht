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
-- Generated on "05/15/2020 12:35:12"
                                                            
-- Vhdl Test Bench template for design  :  audio_channel_merge
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY audio_channel_merge_vhd_tst IS
END audio_channel_merge_vhd_tst;
ARCHITECTURE audio_channel_merge_arch OF audio_channel_merge_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL note2codec : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_data1 : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_data2 : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_data3 : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_data4 : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_data5 : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL note_valid1 : STD_LOGIC;
SIGNAL note_valid2 : STD_LOGIC;
SIGNAL note_valid3 : STD_LOGIC;
SIGNAL note_valid4 : STD_LOGIC;
SIGNAL note_valid5 : STD_LOGIC;
SIGNAL rst_n : STD_LOGIC;
COMPONENT audio_channel_merge
	PORT (
	note2codec : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_data1 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_data2 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_data3 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_data4 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_data5 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
	note_valid1 : IN STD_LOGIC;
	note_valid2 : IN STD_LOGIC;
	note_valid3 : IN STD_LOGIC;
	note_valid4 : IN STD_LOGIC;
	note_valid5 : IN STD_LOGIC;
	rst_n : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : audio_channel_merge
	PORT MAP (
-- list connections between master ports and signals
	note2codec => note2codec,
	note_data1 => note_data1,
	note_data2 => note_data2,
	note_data3 => note_data3,
	note_data4 => note_data4,
	note_data5 => note_data5,
	note_valid1 => note_valid1,
	note_valid2 => note_valid2,
	note_valid3 => note_valid3,
	note_valid4 => note_valid4,
	note_valid5 => note_valid5,
	rst_n => rst_n
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN
rst_n <= '0';
wait for 100 ns;
rst_n <= '1';                                                    
note_data1 <= (23 => '0', others => '1');  
note_data2 <= (23 => '0', others => '1');     
note_data3 <= (23 => '0', others => '1');     
note_data4 <= (23 => '0', others => '1');     
note_data5 <= (23 => '0', others => '1');   
note_valid1 <= '1';                 
note_valid2 <= '1';  
note_valid3 <= '0';  
note_valid4 <= '1';  
note_valid5 <= '1';   
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
END audio_channel_merge_arch;
