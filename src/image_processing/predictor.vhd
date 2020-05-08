---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--predictor
--
-- 功能: 从二值化模块获取输入像素信息, 产生24位按键信号.
--
-- 描述: 第一个版本进行简单的监测, 检测到两个连续的1之后便计算当前像素的坐标, 并将对应的
--       按键位置位.
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity predictor is 
generic(
	key_num : integer := 24;
	pixel_num : integer := ov7670_image_width * ov7670_image_height
);
port(
	rst_n : in std_logic;
	
	--输入像素信息. 由于经过二值化处理, 只有一位
	pixel : in std_logic;
	fsyn : in std_logic;  --帧同步
	pclk : in std_logic;  --像素时钟
	
	--输出按键信息
	key_statuses : out std_logic_vector(key_num - 1 downto 0)
	
	
);
end entity predictor;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of predictor is
	--内部按键信号
	signal keys_inside : std_logic_vector(key_num - 1 downto 0) := (others => '0');
	signal keys2out : std_logic_vector(key_num - 1 downto 0) := (others => '0');
	
	--像素计数信号
	signal pixel_count : integer range 1 to pixel_num := 1;

begin
	key_statuses <= keys2out;
	--输出值只在fsyn下降沿改变, 此时其代表完成一帧
	process(rst_n, fsyn)
	begin
		if(rst_n = '0') then
			keys2out <= (others => '0');
		elsif(fsyn'event and fsyn = '0') then
			keys2out <= keys_inside;
		end if;
	end process;
	
	--
	
	--像素计数
	process(rst_n, fsyn, pclk)
	begin
		if(rst_n = '0' or fsyn = '0') then
			pixel_count <= 1;
		elsif(pclk'event and pclk = '0') then
			if(pixel_count = pixel_num) then
				pixel_count <= 1;
			else
				pixel_count <= pixel_count + 1;
			end if;
		end if;
	end process;
	
	--检测到高电平后将对应的按键置位
--	process(rst_n, pclk)
--	begin
--		if(rst_n = '0') then
--		
--		elsif(pclk'event and pclk = ''1) then
--			if(pixel = '1') then
--			
--			else
--			
--			end if;
--		end if;
--	end process;
	

end architecture;



