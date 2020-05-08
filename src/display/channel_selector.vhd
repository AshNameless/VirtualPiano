---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--channel_selector
--
-- 功能: 从原图像RGB565和二值化之后的图像中进行一个选择, 当做开关, 方便调试的时候显示
--
-- 描述: 
--       
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity channel_selector is
generic(
	raw_rgb565_dwidth : integer := 2 * ov7670_output_width;
	output_dwidth : integer := 2 * ov7670_output_width
);
port(
	rst_n : in std_logic;
	
	--原图像数据
	rgb565_rawdata : in std_logic_vector(raw_rgb565_dwidth - 1 downto 0);
	pclk1 : in std_logic;
	fsyn1 : in std_logic;
	
	--二值化模块输出指示信号
	is_wanted : in std_logic;
	pclk2 : in std_logic;
	fsyn2 : in std_logic;
	
	--输出数据
	data2ram : out std_logic_vector(output_dwidth - 1 downto 0);
	pclk_out : out std_logic;
	fsyn_out : out std_logic;
	
	--控制开关
	sw_key : in std_logic
);

end entity channel_selector;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of channel_selector is

begin
	--输出
	process(rst_n, sw_key, rgb565_rawdata, is_wanted, pclk1, fsyn1, pclk2, fsyn2)
	begin
		if(rst_n = '0') then
			data2ram <= (others => '0');
			pclk_out <= '0';
			fsyn_out <= '0';
		--按键为0选择原图像
		elsif(sw_key = '0') then
			data2ram <= rgb565_rawdata;
			pclk_out <= pclk1;
			fsyn_out <= fsyn1;
		--按键为1选择二值化结果
		else
			if(is_wanted = '1') then
				data2ram <= (others => '1');
			else
				data2ram <= (others => '0');
			end if;
			pclk_out <= pclk2;
			fsyn_out <= fsyn2;
		end if;
	end process;

end architecture bhv;








