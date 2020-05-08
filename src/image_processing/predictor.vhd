---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--predictor
--
-- 功能: 从二值化模块获取输入像素信息, 产生24位按键信号.
--
-- 描述: 第一个版本进行简单的监测, 检测到高电平之后便计算当前像素的坐标, 并将对应的
--       按键位置位. 设置一个计数到320就溢出的计数器, 那么该计数器的值就可以代表当前像素
--       点的纵坐标, 同理设置横坐标. 
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
	--按键个数
	key_num : integer := 24;
	--图像信息
	image_height : integer := ov7670_image_height;
	image_width : integer := ov7670_image_width;
	--
	
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
	
	--横/纵坐标计数器. 由于摄像头拍摄的图像与实际琴键位置是相反的, 因此计数器用减法.
	signal row_count : integer range image_height downto 0 := image_height - 1;
	signal column_count : integer range image_width downto 0 := image_width;

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
	
	--获取列值
	process(rst_n, fsyn, pclk)
	begin
		if(rst_n = '0') then
			column_count <= image_width;
		elsif(pclk'event and pclk = '0') then
			if(fsyn = '1') then 
				if(column_count = 0) then
					column_count <= image_width - 1;
				else
					column_count <= column_count - 1;
				end if;
			else
				column_count <= image_width;
			end if;
		end if;
	end process;
	
	--获取行值
	process(rst_n, pclk)
	begin
		if(rst_n = '0') then
			row_count <= image_height - 1;
		elsif(pclk'event and pclk = '0') then
			if(column_count = 0) then
				if(row_count = 0) then
					row_count <= image_height - 1;
				else
					row_count <= row_count - 1;
				end if;
			else
				row_count <= row_count;
			end if;
		end if;
	end process;
	
	--检测到高电平后将对应的按键置位
	process(rst_n, pclk)
	begin
		if(rst_n = '0' or fsyn = '0') then
			keys_inside <= (others => '0');
		elsif(pclk'event and pclk = '1') then
			if(pixel = '1') then
				coordinates2keys(row_count, column_count, keys_inside);
			else
				keys_inside <= keys_inside;
			end if;
		end if;
	end process;

end architecture bhv;






