-------------------------------------------------------------------------
-------------------------------------------------------------------------
--audio_channel
--
-- 功能: 将Audio_controller, my_nco, my_filter, adsr几个子模块合在一起, 做成
--       一个通道. 
--
-- 描述: 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity audio_channel is 
generic(
	input_data_width : integer := notes_data_width;
	output_data_width : integer := ADSR_note_out_width;
	xth_pkey : integer := 1  --监测第几个被按下的键
);
port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	key_statuses : in std_logic_vector(input_data_width - 1 downto 0);
	
	note : out std_logic_vector(output_data_width - 1 downto 0);
	note_valid : out std_logic
);
end entity audio_channel;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of audio_channel is

	component my_nco
	port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	countnum : in std_logic_vector(16 downto 0);
	nco_waveout : out std_logic_vector(5 downto 0)
	);
	end component;

	component adsr
	port(
	clk_50m : in std_logic;
	rst_n : in std_logic;
	note_on : in std_logic;
	note_change : in std_logic;
	nco_wave_in : in std_logic_vector(17 downto 0);
	out_valid : out std_logic;
	note : out std_logic_vector(23 downto 0)
	);
	end component;

	component audio_controller
	generic(nbxth_of_pkey : integer);
	port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	notes_data_in : in std_logic_vector(23 downto 0);
	note_on : out std_logic;
	note_change : out std_logic;
	filter_num : out std_logic_vector(4 downto 0);
	nco_countnum : out std_logic_vector(16 downto 0)
	);
	end component;

	component my_filter
	port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	filter_num_in : in std_logic_vector(4 downto 0);
	nco_wave_in : in std_logic_vector(5 downto 0);
	filtered_wave : out std_logic_vector(17 downto 0)
	);
	end component;
	
	--内部连线
	signal	wire_nco_countnum :  std_logic_vector(16 downto 0);
	signal	wire_note_on :  std_logic;
	signal	wire_note_change :  std_logic;
	signal	wire_filtered_wave :  std_logic_vector(17 downto 0);
	signal	wire_filter_num :  std_logic_vector(4 downto 0);
	signal	wire_nco_wave :  std_logic_vector(5 downto 0);

begin 

	nco_inst : my_nco
	port map(
	rst_n => rst_n,
	clk_50m => clk_50m,
	countnum => wire_nco_countnum,
	nco_waveout => wire_nco_wave);


	adsr_inst : adsr
	port map(
	clk_50m => clk_50m,
	rst_n => rst_n,
	note_on => wire_note_on,
	note_change => wire_note_change,
	nco_wave_in => wire_filtered_wave,
	out_valid => note_valid,
	note => note);


	audio_controller_inst : audio_controller
	generic map(nbxth_of_pkey => xth_pkey)
	port map(
	rst_n => rst_n,
	clk_50m => clk_50m,
	notes_data_in => key_statuses,
	note_on => wire_note_on,
	note_change => wire_note_change,
	filter_num => wire_filter_num,
	nco_countnum => wire_nco_countnum);


	filter_inst : my_filter
	port map(
	rst_n => rst_n,
	clk_50m => clk_50m,
	filter_num_in => wire_filter_num,
	nco_wave_in => wire_nco_wave,
	filtered_wave => wire_filtered_wave);


end architecture bhv;

