---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--merge_rgb565
--
-- 功能: 监测到rdfrom_fifo输出的data_valid信号后, 接受一个像素的两个字节数据, 组合成16位
--       再输出. 同时模仿摄像头, 输出一个frame_syn(帧同步) 和 pclk信号.
--
-- 描述: 由简单状态机控制. idle态监测到in_data_valid信号后, 先拉高rd_req电平, 同时存储
--       高字节, 然后再获取低字节并输出, 且保持一个周期.
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity merge_rgb565 is
generic(
	input_pixel_data_width : integer := ov7670_output_width;
	output_pixel_data_width : integer := 2 * ov7670_output_width;
	image_width : integer := ov7670_image_width;
	image_height : integer := ov7670_image_height
);
port(
	--输入
	rst_n : in std_logic;
	clk_pixel : in std_logic;  --与pixel同步的时钟信号.
	
	--输出frame_syn信号, 输出像素有多少该信号就置位多少个时钟周期
	frame_syn: out std_logic;
	pclk : out std_logic;
	
	--输出像素数据, 将一个像素的两个字节信息连起来
	output_data : out std_logic_vector(output_pixel_data_width - 1 downto 0);
	
	--接受rdfrom_fifo的数据和同步信号
	pixel_data : in std_logic_vector(input_pixel_data_width - 1 downto 0);   --rdfrom_fifo输出数据
	in_data_valid : in std_logic

);
end entity merge_rgb565;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of merge_rgb565 is
	--像素点总数及读取计数信号. 因为一个像素点的两个字节数据是合并后输出的, 因此这里就等于总像素点个数
	constant pixel_num : integer := image_width * image_height;
	signal pixel_count : integer range 0 to pixel_num := 0;
	signal pixel_count_en : std_logic := '0';
	
	--暂存两个字节数据
	signal high_byte : std_logic_vector(input_pixel_data_width - 1 downto 0) := (others => '0');
	signal low_byte : std_logic_vector(input_pixel_data_width - 1 downto 0) := (others => '0');
	--数据内部值
	signal data_merged : std_logic_vector(output_pixel_data_width - 1 downto 0) := (others => '0');
	signal in_pixel_data : std_logic_vector(input_pixel_data_width - 1 downto 0) := (others => '0');
	
	--定义状态
	type state is (idle, preserve, store_highB, send_data_merged);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--内部像素时钟
	signal pclk_inside : std_logic := '0';
	
begin
	--输入
	in_pixel_data <= pixel_data;
	--输出数据赋值
	output_data <= data_merged;
	pclk <= pclk_inside;
	
	--输出同步pclk信号
	process(rst_n, clk_pixel)
	begin
		if(rst_n = '0') then
			pclk_inside <= '0';
		elsif(clk_pixel'event and clk_pixel = '0') then
			if(cur_state = store_highB) then
				pclk_inside <= '1';
			elsif(cur_state = send_data_merged) then
				pclk_inside <= '0';
			else
				pclk_inside <= not pclk_inside;
			end if;
		end if;
	end process;
	
	--像素计数进程, 及相关数据输出
	process(rst_n, pclk_inside)
	begin
		if(rst_n = '0') then
			pixel_count <= 0;
			data_merged <= (others => '0');
			frame_syn <= '0';
		elsif(pclk_inside'event and pclk_inside = '0') then
			--像素计数
			if(pixel_count_en = '0' or pixel_count = pixel_num) then
				pixel_count <= 0;
			else
				pixel_count <= pixel_count + 1;
			end if;
			
			--输出数据赋值
			data_merged <= high_byte & low_byte;
			
			--帧同步信号产生
			if(pixel_count_en = '1') then
				frame_syn <= '1';
			else
				frame_syn <= '0';
			end if;
		end if;
	end process;

	--状态转移进程
	process(rst_n, clk_pixel)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_pixel'event and clk_pixel = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, in_data_valid, pixel_count)
	begin
		next_state <= cur_state;
		
		case cur_state is
		when idle =>
			if(in_data_valid = '1') then
				next_state <= store_highB;
			else
				next_state <= idle;
			end if;
		
		when store_highB =>
			if(in_data_valid = '0') then
				next_state <= idle;
			else
				next_state <= send_data_merged;
			end if;
		
		when send_data_merged =>
			if(in_data_valid = '0') then
				next_state <= idle;
			elsif(pixel_count = pixel_num) then
				next_state <= idle;
			else
				next_state <= store_highB;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机控制高低字节
	process(cur_state, in_pixel_data)
	begin
		case cur_state is
		when idle =>
			high_byte <= (others => '0');
			low_byte <= (others => '0');
			pixel_count_en <= '0';
		
		when store_highB =>
			high_byte <= in_pixel_data;
			low_byte <= low_byte;
			pixel_count_en <= '1';
		
		when send_data_merged =>
			high_byte <= high_byte;
			low_byte <= in_pixel_data;
			pixel_count_en <= '1';
		
		when others => null;
		end case;
	end process;

end architecture bhv;









	
	