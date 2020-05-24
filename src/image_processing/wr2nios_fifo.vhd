-------------------------------------------------------------------------
-------------------------------------------------------------------------
--wr2nios_fifo
--
-- 功能: 写到和Nios2交互的fifo
--
-- 描述: 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity wr2nios_fifo is
port(
	rst_n : in std_logic;

	frame_ready : out std_logic;
	
	--输入信号
	pclk : in std_logic;             --像素时钟
	fsyn : in std_logic;             --帧同步信号
	pixel : in std_logic;
	
	--与fifo交互信号
	fifo_data : out std_logic_vector(7 downto 0);     --写到fifo的数据
	fifo_wreq : out std_logic;       --fifo写请求
	fifo_wclk : out std_logic;       --fifo写时钟
	fifo_wrfull : in std_logic;      --fifo写满
	fifo_aclr : out std_logic        --fifo异步清零
);
end entity wr2nios_fifo;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of wr2nios_fifo is
	signal pixel_count : integer range 0 to 76800 := 0;
begin
	fifo_wclk <= pclk;
	fifo_wreq <= fsyn;
	fifo_aclr <= not rst_n;
	
	process(rst_n, pclk, fsyn)
	begin
		if(rst_n = '0') then
			pixel_count <= 0;
		elsif(pclk'event and pclk = '1') then
			--计数
			if(fsyn = '1') then
				if(pixel_count = 76800) then
					pixel_count <= 0;
				else
					pixel_count <= pixel_count + 1;
				end if;
			else
				pixel_count <= 0;
			end if;
			
			if(pixel_count >= 70000) then
				frame_ready <= '1';
			else
				frame_ready <= '0';
			end if;
		end if;
	end process;
	
	--fifo写入数据生成
	process(rst_n, pixel)
	begin
		if(rst_n = '0') then
			fifo_data <= (others => '0');
		elsif(pixel = '0') then
			fifo_data <= (others => '0');
		else
			fifo_data <= (others => '1');
		end if;
	end process;

end architecture bhv;