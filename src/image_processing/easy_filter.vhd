---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--easy_filter
--
-- 功能: 将输入的二值化图像数据进行简单的滤波.
--
-- 描述: 原理很简单, 若监测到连续的1便输出1, 否则输出0. 初始状态监测到1就进入lack1s状态,
--       检测到足够的1后就进入到enough1s状态并指示输出信号为高. 输出的同步信号在下降沿时
--       变化, 输出像素数据也在下降沿时才改变. 在跳变时输入数据应该稳定, 因此状态机用上升
--       沿控制, 输出数据不在状态机中赋值. 状态机给出指示信号, 在下降沿时指示输出数据变化.
--       
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity easy_filter is
generic(
	how_many_1s : integer := 2;
	pixel_num : integer := ov7670_image_width * ov7670_image_height
);
port(
	rst_n : in std_logic;
	
	--输入像素数据及同步时钟
	pixel_in : in std_logic;
	pclk_in : in std_logic;
	fsyn_in : in std_logic;
	
	--输出数据及同步信号
	pixel_out : out std_logic;
	pclk_out : out std_logic;
	fsyn_out : out std_logic
);
end entity easy_filter;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of easy_filter is
	--像素计数器及其使能信号. 因为要计算1的个数, 范围需要增加
	signal pixel_count : integer range 0 to pixel_num+how_many_1s := 0;
	signal pixel_count_en : std_logic := '0';
	
	--连续1的个数计数器
	signal count1s : integer range 0 to how_many_1s;
	signal count1s_en : std_logic := '0';
	
	
	--定义状态
	type state is (idle, lack1s, enough1s);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
begin
	--计数进程
	process(rst_n, pclk_in)
	begin
		if(rst_n = '0') then
			pixel_count <= 0;
			count1s <= 0;
		elsif(pclk_in'event and pclk_in = '1') then
			--像素计数
			if(fsyn_in = '1') then
				pixel_count <= pixel_count + 1;
			elsif(pixel_count = 0 or pixel_count = pixel_num + how_many_1s) then
				pixel_count <= 0;
			else
				pixel_count <= pixel_count + 1;
			end if;
			
			--1个数计数
			if(count1s_en = '1') then
				if(count1s = how_many_1s) then
					count1s <= how_many_1s;
				else
					count1s <= count1s + 1;
				end if;
			else
				count1s <= 0;
			end if;
		end if;
	end process;
	
	--输出赋值
	pclk_out <= pclk_in;
	process(rst_n, pclk_in, pixel_count, cur_state)
	begin
		if(rst_n = '0') then
			pixel_out <= '0';
			fsyn_out <= '0';
		elsif(pclk_in'event and pclk_in = '0') then
			--fsyn_out赋值
			if(pixel_count >= how_many_1s) then
				fsyn_out <= '1';
			elsif(pixel_count = pixel_num + how_many_1s) then
				fsyn_out <= '0';
			else
				fsyn_out <= '0';
			end if;
			
			--像素数据赋值
			if(cur_state = idle) then
				pixel_out <= '0';
			elsif(count1s >= how_many_1s - 1) then
				pixel_out <= '1';
			else
				pixel_out <= '0';
			end if;
		end if;
	end process;
	
	
	--状态转移进程
	process(rst_n, pclk_in)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(pclk_in'event and pclk_in = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, pixel_in, fsyn_in, count1s)
	begin
		next_state <= cur_state;
		
		case cur_state is
		when idle =>
			if(pixel_in = '1') then
				next_state <= lack1s;
			else
				next_state <= idle;
			end if;
		
		when lack1s =>
			if(pixel_in = '0') then
				next_state <= idle;
			elsif(count1s = how_many_1s - 1) then
				next_state <= enough1s;
			else
				next_state <= lack1s;
			 end if;
		
		when enough1s =>
			if(pixel_in = '0') then
				next_state <= idle;
			else
				next_state <= enough1s;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机相关信号控制
	process(cur_state)
	begin
		case cur_state is
		when idle =>
			count1s_en <= '0';
		when  lack1s =>
			count1s_en <= '1';
		when enough1s =>
			count1s_en <= '1';
		
		when others => null;
		end case;
	end process;


end architecture bhv;







