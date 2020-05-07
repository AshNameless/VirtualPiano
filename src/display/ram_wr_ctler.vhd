-------------------------------------------------------------------------
-------------------------------------------------------------------------
--ram_wr_ctler
--
-- 功能: 将fifo数据保存到ram中
--
-- 描述: 完成fifo与ram之间的交互. fifo数据两个字节并在一起, 作为16bits数据输入
--       到ram中, ram为16bits输入8bits输出. 接受rdfrom_fifo的data_valid信号,
--       data_valid为高时, 标志数据流开始, 接下来将会包含一帧数据, 1个像素1周期.
--       由于data_valid在前一模块是确定好计数值才降低的, 因此其可以完全用来同步
--       一帧数据, 不需要再在此模块内计数.
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity ram_wr_ctler is
generic(
	--输入数据宽度
	pixel_data_width : integer := ov7670_output_width * 2;

	--ram相关参数
	ram_dwidth : integer := 32;
	ram_awidth : integer := 16;
	ram_wrdepth : integer := 38400
);
port(
	--输入
	rst_n : in std_logic;
	pclk : in std_logic;
	pixel_data : in std_logic_vector(pixel_data_width - 1 downto 0);

	--帧同步信号
	fsyn : in std_logic;        --帧可读取信号
	
	--与ram端交互数据
	ram_wrclk : out std_logic;        --ram写时钟
	ram_address : out std_logic_vector(ram_awidth - 1 downto 0);  --ram写地址
	ram_data : out std_logic_vector(ram_dwidth - 1 downto 0);     --写入到ram的数据
	ram_wren : out std_logic          --ram写使能
	
);
end entity ram_wr_ctler;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of ram_wr_ctler is
	--内部信号定义
	signal ramaddress : integer range 0 to ram_wrdepth - 1 := ram_wrdepth - 1;  --ram写地址
	signal ramclk : std_logic := '0';  --ram写时钟
	
	--像素数据
	signal data : std_logic_vector(pixel_data_width - 1 downto 0) := (others => '0');
	
	--暂存数据
	signal data2ram_high : std_logic_vector(pixel_data_width - 1 downto 0) := (others => '0');
	signal data2ram_low : std_logic_vector(pixel_data_width - 1 downto 0) := (others => '0');
	signal ramaddress_impulse : std_logic := '0';  --地址计数脉冲
	
	--状态定义, 两个准备状态, 分别用来准备高字节和低字节
	type state is (idle, store_lowdata, send_data);
	signal cur_state : state := idle;
	signal next_state : state := idle;

begin
	--data始终跟随pixel_data
	data <= pixel_data;
	--输出赋值
	ram_address <= std_logic_vector(to_unsigned(ramaddress, ram_awidth));
	ram_data <= data2ram_high & data2ram_low;
	ram_wrclk <= ramclk;
	
	--ram写时钟
	process(rst_n, cur_state, pclk)
	begin
		if(rst_n = '0') then
			ramclk <= '0';
		--注意是下降沿
		elsif(pclk'event and pclk = '0') then
			if(cur_state = store_lowdata) then
				ramclk <= '0';
			elsif(cur_state = send_data) then
				ramclk <= '1';
			else
				ramclk <= not ramclk;
			end if;
		end if;
	end process;
	
	--ram写地址生成
	process(cur_state, ramaddress_impulse)
	begin
		if(cur_state = idle) then
			ramaddress <= ram_wrdepth - 1;
		elsif(ramaddress_impulse'event and ramaddress_impulse = '1') then
			if(ramaddress = ram_wrdepth - 1) then
				ramaddress <= 0;
			else
				ramaddress <= ramaddress + 1;
			end if;
		end if;
	end process;
	
	
	--状态转移进程
	process(rst_n, pclk)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(pclk'event and pclk = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, fsyn, ramaddress)
	begin
		next_state <= idle;
		
		case cur_state is
		when idle =>
			if(fsyn = '1') then
				next_state <= store_lowdata;
			else
				next_state <= idle;
			end if;
			
		when store_lowdata =>
			if(fsyn = '0') then
				next_state <= idle;
			else
				next_state <= send_data;
			end if;
		
		when send_data =>
			if(fsyn = '0' or ramaddress = ram_wrdepth - 1) then
				next_state <= idle;
			else
				next_state <= store_lowdata;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机输出控制
	process(cur_state)
	begin
		case cur_state is
		when idle =>
			ram_wren <= '0';
			ramaddress_impulse <= '0';
		
		when store_lowdata =>
			ramaddress_impulse <= '0';
			ram_wren <= '1';
		
		when send_data =>
			ramaddress_impulse <= '1';
			ram_wren <= '1';

		when others => null;
		end case;
	end process;
	
	--高低字节采集
	process(pclk, rst_n, next_state)
	begin
		if(rst_n = '0') then
			data2ram_high <= (others => '0');
			data2ram_low <= (others => '0');
		elsif(pclk'event and pclk = '1') then
			if(next_state = store_lowdata) then
				data2ram_low <= data;
				data2ram_high <= data2ram_high;
			elsif(next_state = send_data) then
				data2ram_high <= data;
				data2ram_low <= data2ram_low;
			else
				data2ram_high <= (others => '0');
				data2ram_low <= (others => '0');
			end if;
		end if;
	end process;
	
end architecture bhv;











