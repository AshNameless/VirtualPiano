-------------------------------------------------------------------------
-------------------------------------------------------------------------
--i2c传输接口 
--
-- 功能: 完成i2c协议主模式功能,产生SCLK信号及SDAT数据.
-- 
-- 描述: 按照i2c协议传输的时序设计好状态机,详见状态图. 对50mhz分频得到200khz,由200khz驱动状态机
--       能够得到100khz频率的SCLK. 主要状态为transmit_0和transmit_1. 前者拉低SCLK同时使SDA值为
--       输入数据的对应位; 后者拉高SCLK同时保持SDA, 完成一位传输.
--
-- 用法: 设置好24位数据后send端给高电平,启动传输,传输完成之前send一直保持高电平. 传输完毕返回done
--       信号, 模块回到idle状态. 若要再次传输重复上述过程即可.
--       如果从从设备获取ack失败则返回错误信号, 交由调用模块决定是否重新传输或者进行其他操作。
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------
-------------------------------------------------------
entity I2C is 
port(
	--输入
	clk_50m : in std_logic;
	rst_n : in std_logic;
	send : in std_logic;
	data : in std_logic_vector(23 downto 0);
	
	--i2c时钟和数据线
	i2c_sda : inout std_logic;
	i2c_scl : out std_logic;
	
	--输出状态信息
	done : out std_logic;               --传输完成时发一次脉冲
	error : out std_logic
);
end entity I2C;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of I2C is
	--i2c输出scl设定为100khz,该信号由状态机控制，所以其周期是状态机两倍，故状态机驱动时钟应为200khz
	--用输入50mhz分频到200khz,则需要计数250个时钟, 则每125个时钟翻转一次
	signal clk_200khz : std_logic := '0';
	signal clk_200khz_threshold : integer := 124;
	signal clk_count : integer range 0 to clk_200khz_threshold := 0;
	
	--定义状态
	type state is (idle, start, transmit_0, transmit_1, ack_0, ack_1, err, stop_0, stop_1, stop_2);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--传输24位,设置一个计数器以确定传输的数据位并确定是否完成传输或是否需要ack
	signal bit_count : integer range 0 to 23 := 23;
	
begin
	--产生200khz的时钟
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			clk_200khz <= '0';
			clk_count <= 0;
		elsif(clk_50m'event and clk_50m = '1') then
			if(clk_count = clk_200khz_threshold) then
				clk_count <= 0;
				clk_200khz <= not clk_200khz;
			else
				clk_count <= clk_count + 1;
			end if;
		end if;
	end process;
	
	--i2c传输控制状态机
	--状态转移控制进程
	process(rst_n, clk_200khz)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_200khz'event and clk_200khz = '1') then
			cur_state <= next_state;
		end if;
	end process; 
	
	--次态控制进程
	process(cur_state, send, i2c_sda)
	begin
		next_state <= cur_state;
		
		case cur_state is
		when idle =>
			if(send = '1') then
				next_state <= start;
			else
				next_state <= idle;
			end if;
		
		when start =>
			if(send = '0') then
				next_state <= err;
			else
				next_state <= transmit_0;
			end if;
		
		when transmit_0 => 
			if(send = '0') then
				next_state <= err;
			else
				next_state <= transmit_1;
			end if;
		
		when transmit_1 =>
			if(send = '0') then
				next_state <= err;
			elsif(bit_count = 0 or bit_count = 8 or bit_count = 16) then
				next_state <= ack_0;
			else
				next_state <= transmit_0;
			end if;
		
		when ack_0 =>
			if(send = '0') then
				next_state <= err;
			else
				next_state <= ack_1;
			end if;
		
		when ack_1 =>
		--sda=0时说明从机发送了ack信号, 传输正常
			if(send = '0' or i2c_sda = '1') then
				next_state <= err;
			elsif(bit_count = 0) then
				next_state <= stop_0;
			else
				next_state <= transmit_0;
			end if;
		
		when stop_0 =>
			if(send = '0') then
				next_state <= err;
			else
				next_state <= stop_1;
			end if;
			
		when stop_1 =>
			if(send = '0') then
				next_state <= err;
			else
				next_state <= stop_2;
			end if;
			
		when stop_2 =>
			next_state <= idle;
		
		when err =>
			next_state <= idle;
			
		when others => null;
		end case;
	end process;
	
	--输出和内部信号控制
	process(cur_state, data)
	begin		
		case cur_state is 
		when idle =>
			i2c_scl <= '1';
			i2c_sda <= 'Z';
			done <= '0';
			error <= '0';
			bit_count <= 23;
		
		when start =>
			i2c_scl <= '1';
			i2c_sda <= '0';
			done <= '0';
			error <= '0';
			bit_count <= 23;
		
		when transmit_0 => 
			i2c_scl <= '0';
			i2c_sda <= data(bit_count);
			done <= '0';
			error <= '0';
		
		when transmit_1 =>
			i2c_scl <= '1';
			i2c_sda <= data(bit_count);
			done <= '0';
			error <= '0';
			if(bit_count >= 1) then
				bit_count <= bit_count - 1;
			else
				bit_count <= 0;
			end if;
			
		when ack_0 =>
			i2c_scl <= '0';
			i2c_sda <= 'Z';
			done <= '0';
			error <= '0';

		when ack_1 =>
			i2c_scl <= '1';
			i2c_sda <= 'Z';
			done <= '0';
			error <= '0';

		when stop_0 =>
			i2c_scl <= '0';
			i2c_sda <= '0';
			done <= '0';
			error <= '0';
			
		when stop_1 =>
			i2c_scl <= '1';
			i2c_sda <= '0';
			done <= '0';
			error <= '0';
			
		when stop_2 =>
			i2c_sda <= 'Z';
			i2c_scl <= '1';
			done <= '1';
			error <= '0';
			
		when err =>
			i2c_scl <= '1';
			i2c_sda <= 'Z';
			done <= '0';
			error <= '1';

		when others => null;
		end case;
	end process;
end architecture bhv;
