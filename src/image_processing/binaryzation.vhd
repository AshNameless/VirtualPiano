---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--binaryzation
--
-- 功能: 通过对H, S, V三个参数设定选择范围, 来对像素进行选择. 
--
-- 描述: 
--       
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity binaryzation is
generic(
	h_dwidth : integer := 9; --h范围是0-360
	s_dwidth : integer := 8;
	v_dwidth : integer := 8;
	--相关数据范围
	h_min : integer := 0;
	h_max : integer := 20;
	s_min : integer := 0;
	s_max : integer := 255;
	v_min : integer := 100;
	v_max : integer := 255
);
port(
	rst_n : in std_logic;
	--输入数据
	hin : in std_logic_vector(h_dwidth - 1 downto 0);
	sin : in std_logic_vector(s_dwidth - 1 downto 0);
	vin : in std_logic_vector(v_dwidth - 1 downto 0);
	pclk_in : in std_logic;
	fsyn_in : in std_logic;
	
	--输出数据
	is_wanted : out std_logic;  --是否是想要的像素点
	pclk_out : out std_logic;
	fsyn_out : out std_logic
);
end entity binaryzation;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of binaryzation is
	--输入数据转换
	signal h : integer := 0;
	signal s : integer := 0;
	signal v : integer := 0;
begin
	--像素时钟和同步信号直接传递
	pclk_out <= pclk_in;
	fsyn_out <= fsyn_in;
	
	h <= to_integer(unsigned(hin));
	s <= to_integer(unsigned(sin));
	v <= to_integer(unsigned(vin));
	--满足要求就输出高电平
	process(rst_n, h, s, v)
	begin
		if(rst_n = '0') then
			is_wanted <= '0';
		elsif(h >= h_min and h <= h_max and
				s >= s_min and s <= s_max and
				v >= v_min and v <= v_max
		) then
			is_wanted <= '1';
		else
			is_wanted <= '0';
		end if;
	end process;

end architecture bhv;



