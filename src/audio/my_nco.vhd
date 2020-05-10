-------------------------------------------------------------------------
-------------------------------------------------------------------------
--my_nco
--
-- 功能: 接收从识别模块输出的计数器翻转值, 然后产生相应的波形
--
-- 描述: 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity my_nco is
generic(
	input_data_width : integer := NCO_countnum_width;
	output_data_width : integer := NCO_wave_width
);
port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	--输入计数器翻转值
	countnum : in std_logic_vector(NCO_countnum_width - 1 downto 0);
	--输出
	nco_waveout : out std_logic_vector(NCO_wave_width - 1 downto 0)
);
end entity my_nco;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of my_nco is
	--内部计数器反转值. 转换成整数
	signal count_threshold : integer := 0;
	signal wave_count : integer := 0;
	signal wave_flag : std_logic := '0';
	
	--由于检测到无按键的时候, ASDR还有release阶段. 如果直接把计数翻转值置0的话, 将不再有
	--波形输出. 因此内置一个计数器值, 在有按下时等于countnum, 没按下时保持之前的值.因为
	--ADSR在idle态增益为0, 因此即便有波形也不会产生声音
	signal countnum_inside : unsigned(NCO_countnum_width - 1 downto 0) := (others => '0');

begin
	countnum_inside <= unsigned(countnum);
	
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			count_threshold <= 0;
		elsif(clk_50m'event and clk_50m = '0') then
			if(countnum_inside = 0) then
				count_threshold <= count_threshold;
			else
				count_threshold <= to_integer(countnum_inside);
			end if;
		end if;
	end process;
	
	--计数进程
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			wave_count <= 0;
			wave_flag <= '0';
		elsif(clk_50m'event and clk_50m = '1') then
			if(wave_count >= count_threshold) then
				wave_count <= 0;
				wave_flag <= not wave_flag;
			else
				wave_count <= wave_count + 1;
				wave_flag <= wave_flag;
			end if;
		end if;
	end process;
	
	--输出
	process(rst_n, wave_flag)
	begin
		if(rst_n = '0') then
			nco_waveout <= (others => '0');
		elsif(wave_flag = '0') then
			nco_waveout <= (NCO_wave_width - 1 => '1', others => '0');
		else
			nco_waveout <= (NCO_wave_width - 1 => '0', others => '1');
		end if;
	end process;
	
end architecture bhv;






