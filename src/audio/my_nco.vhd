-------------------------------------------------------------------------
-------------------------------------------------------------------------
--my_nco
--
-- 功能: 接收从识别模块输出的计数器翻转值, 然后产生相应的波形
--
-- 描述: 由于方波不含偶次谐波, 因此生成的波形应当包含其倍频方波. 参考钢琴音色系统
--       论文中中频钢琴一次谐波与二次谐波之比约为1:0.279, 也即一次谐波占约0.782.
--       此处将其简化为0.75 + 0.25, 0.75 = 0.5 + 0.25, 可以化成移位操作. 又可以
--       从三次谐波与二次谐波的角度考虑, 简化为0.875 + 0.125. 此处采用后者
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.filter_paras.all;
-------------------------------------------------------
-------------------------------------------------------
entity my_nco is
generic(
	input_data_width : integer := NCO_countnum_width;
	output_data_width : integer := NCO_wave_width;
	countnum_max : integer := NCO_countnum_max
);
port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	--输入计数器翻转值
	countnum : in std_logic_vector(input_data_width - 1 downto 0);
	--输出
	nco_waveout : out std_logic_vector(output_data_width - 1 downto 0)
);
end entity my_nco;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of my_nco is
	--内部计数器反转值. 转换成整数
	signal count_threshold : integer range 0 to countnum_max := 0;
	signal wave_count : integer range 0 to countnum_max := 0;
	signal wave_flag : std_logic := '0';
	
	--由于检测到无按键的时候, ASDR还有release阶段. 如果直接把计数翻转值置0的话, 将不再有
	--波形输出. 因此内置一个计数器值, 在有按下时等于countnum, 没按下时保持之前的值.因为
	--ADSR在idle态增益为0, 因此即便有波形也不会产生声音
	signal countnum_inside : unsigned(input_data_width - 1 downto 0) := (others => '0');
	
	--倍频计数器. 
	signal double_threshold : integer range 0 to countnum_max := 0;
	signal double_count : integer range 0 to countnum_max := 0;
	signal double_flag : std_logic := '0';
	
	--两个方波
	signal origin_wave : signed(output_data_width - 1 downto 0) := (others => '0');
	signal double_wave : signed(output_data_width - 1 downto 0) := (others => '0');
	
begin
	countnum_inside <= unsigned(countnum);
	double_threshold <= count_threshold/2;
	--设置输出
	nco_waveout <= std_logic_vector(origin_wave + double_wave);
	
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			count_threshold <= 0;
		elsif(clk_50m'event and clk_50m = '1') then
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
			double_count <= 0;
			double_flag <= '0';
		elsif(clk_50m'event and clk_50m = '1') then
			--原频率计数
			if(wave_count >= count_threshold) then
				wave_count <= 0;
				wave_flag <= not wave_flag;
			else
				wave_count <= wave_count + 1;
				wave_flag <= wave_flag;
			end if;
			--倍频计数
			if(double_count >= double_threshold) then
				double_count <= 0;
				double_flag <= not double_flag;
			else
				double_count <= double_count + 1;
				double_flag <= double_flag;
			end if;
		end if;
	end process;
	
	
	--方波生成
	process(rst_n, wave_flag, double_flag)
	begin
		if(rst_n = '0') then
			origin_wave <= (others => '0');
			double_wave <= (others => '0');
		else
			--原频率波形
			if(wave_flag = '0') then
				origin_wave <= to_signed(-28, output_data_width);
			else
				origin_wave <= to_signed(28, output_data_width);
			end if;
			--倍频波形只生成-4~3
			if(double_flag = '0') then
				double_wave <= to_signed(-4, output_data_width);
			else
				double_wave <= to_signed(3, output_data_width);
			end if;
		end if;
	end process;
	
end architecture bhv;






