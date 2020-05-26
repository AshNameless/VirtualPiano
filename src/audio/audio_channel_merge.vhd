-------------------------------------------------------------------------
-------------------------------------------------------------------------
--audio_channel_merge
--
-- 功能: 将audio_channel输出的经过ADSR调制的信号进行合并, 以实现多按键功能.
--
-- 描述: 暂时实现5个按键无冲. 也比较容易扩展, 但是一个通道占得资源感觉不少, 就
--       少做几个通道.
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity audio_channel_merge is
generic(
	input_dwidth : integer := ADSR_note_out_width;
	output_dwidth : integer := ADSR_note_out_width;
	channel_num : integer := 5
);
port(
	rst_n : in std_logic;
	
	--输入音符数据
	note_data1 : in std_logic_vector(input_dwidth - 1 downto 0);
	note_data2 : in std_logic_vector(input_dwidth - 1 downto 0);
	note_data3 : in std_logic_vector(input_dwidth - 1 downto 0);
	note_data4 : in std_logic_vector(input_dwidth - 1 downto 0);
	note_data5 : in std_logic_vector(input_dwidth - 1 downto 0);
	--该通道音符是否有效
	note_valid1 : in std_logic;
	note_valid2 : in std_logic;
	note_valid3 : in std_logic;
	note_valid4 : in std_logic;
	note_valid5 : in std_logic;
	--输出
	note2codec : out std_logic_vector(input_dwidth - 1 downto 0)
);
end entity audio_channel_merge;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of audio_channel_merge is
	--内部信号定义
	type note_type is array(natural range<>) of signed(input_dwidth - 1 downto 0);
	signal note : note_type(0 to channel_num - 1) := (others => (others => '0'));
	signal note_out : note_type(0 to channel_num - 1) := (others => (others => '0'));
	--将多个通道的valid信号合并在一起
	signal note_valid : std_logic_vector(channel_num - 1 downto 0) := (others => '0');
	--对note_valid中1的个数进行计数
	signal valid_count : integer range 0 to channel_num := 0;
	constant divisor_width : integer := 4;--最多10按键, 4位就够
	signal note_divisor : signed(divisor_width - 1 downto 0) := (others => '0');
	
begin
	--输入赋值到信号
	note_valid <= note_valid5 & note_valid4 & note_valid3 & note_valid2 & note_valid1;
	note(0) <= signed(note_data1);
	note(1) <= signed(note_data2);
	note(2) <= signed(note_data3);
	note(3) <= signed(note_data4);
	note(4) <= signed(note_data5);
	--输出. 为增加扩展性可以写成for循环, 类比滤波器求和. 
	note2codec <= std_logic_vector(note(0) + note(1) + note(2) + note(3) + note(4));
	
	--监测1的个数
	process(rst_n, note_valid)
		variable x : integer range 0 to channel_num := 0;
	begin
		if(rst_n = '0') then
			valid_count <= 0;
		else
			x := 0;
			for i in 0 to channel_num - 1 loop
				if(note_valid(i) = '1') then
					x := x + 1;
				else
					x := x;
				end if;
			end loop;
			valid_count <= x;
		end if;
	end process;
	
	note_divisor <= to_signed(valid_count, divisor_width);--1的个数转变为signed类型
	
	--对输入数据进行幅度调整. 有多少个通道那么每个通道就减小多少倍
--	process(rst_n, note, note_divisor)
--		
--	begin
--		if(rst_n = '0') then
--			note_out <= (others => (others => '0'));
--		else
--			for i in 0 to channel_num - 1 loop
--				if(note_valid(i) = '1') then
--					note_out(i) <= note(i)/note_divisor;
--				else
--					note_out(i) <= (others => '0');
--				end if;
--			end loop;
--		end if;
--	end process;
	
end architecture bhv;





