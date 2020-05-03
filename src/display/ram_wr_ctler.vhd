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
	--fifo像素数据信息
	pixel_data_width : integer := ov7670_output_width;

	--ram相关参数
	ram_dwidth : integer := 16;
	ram_awidth : integer := 16;
	ram_wrdepth : integer := 38400
);
port(
	--输入
	rst_n : in std_logic;
	clk_50m : in std_logic;
	pixel_data : in std_logic_vector(pixel_data_width - 1 downto 0);

	--rdfrom_fifo输入的帧可读取信号
	data_valid : in std_logic;        --帧可读取信号
	
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
	type state is (idle, MS_prepare, LS_prepare);
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
	process(rst_n, cur_state, clk_50m)
	begin
		if(rst_n = '0') then
			ramclk <= '0';
		--注意是下降沿
		elsif(clk_50m'event and clk_50m = '0') then
			if(cur_state = LS_prepare) then
				ramclk <= '0';
			elsif(cur_state = MS_prepare) then
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
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_50m'event and clk_50m = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	--data_valid恰好包含像素个数那么多个时钟, 所以就以它为跳转信号作为同步
	process(cur_state, data_valid)
	begin
		next_state <= idle;
		
		case cur_state is
		when idle =>
			if(data_valid = '1') then
				next_state <= LS_prepare;
			else
				next_state <= idle;
			end if;
			
		when LS_prepare =>
			if(data_valid = '0') then
				next_state <= idle;
			else
				next_state <= MS_prepare;
			end if;
		
		when MS_prepare =>
			if(data_valid = '0') then
				next_state <= idle;
			else
				next_state <= LS_prepare;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机输出控制
	process(cur_state, data)
	begin
		case cur_state is
		when idle =>
			ram_wren <= '0';
			ramaddress_impulse <= '0';
			data2ram_low <= (others => '0');
			data2ram_high <= (others => '0');
		
		when LS_prepare =>
			ramaddress_impulse <= '0';
			ram_wren <= '1';
			--赋值低字节
			data2ram_low <= data;
			data2ram_high <= data2ram_high;

		
		when MS_prepare =>
			ramaddress_impulse <= '1';
			ram_wren <= '1';
			--赋值高字节
			data2ram_low <= data2ram_low;
			data2ram_high <= data;

		when others => null;
		end case;
	end process;
end architecture bhv;











