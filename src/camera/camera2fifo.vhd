---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--camera2fifo
--
-- 功能: 从摄像头接收同步信号和数据, 据此产生fifo写时序，将图像数据暂存到fifo中. 当写入一
--       定数量后, 输出一个触发信号, 示意后续模块可以开始读取.
--
-- 描述: 利用状态机控制, 从摄像头控制模块得到启动信号后开始启动数据传输,写完一帧后
--       等待下一帧, 一直循环. 由于fifo深度问题, 所以写入fifo后以25mhz时钟读取, 计算
--       可得写入约200行后可以读出. 由于131072的fifo能存储131072/640 = 204.8行数据。
--        因为摄像头的同步信号已经够使用, 因此fifo写时钟设为pclk, 写使能设为href
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity camera2fifo is
generic(
	pixel_data_width : integer := ov7670_output_width;
 	image_height : integer := ov7670_image_height
);
port(
	rst_n : in std_logic;
	--可读取指示信号. 当写入一定数量的数据后发出一个脉冲, 长度为一个pclk时钟周期
	frame_ready : out std_logic;
	--从摄像头获取的输入信号
	pclk : in std_logic;             --像素时钟
	vsyn : in std_logic;             --帧同步信号
	href : in std_logic;             --场同步信号
	pixel_data_in : in std_logic_vector(pixel_data_width - 1 downto 0);  --像素数据, 两次传输一个像素
	
	--与fifo交互信号
	fifo_data : out std_logic_vector(pixel_data_width - 1 downto 0);     --写到fifo的数据
	fifo_wreq : out std_logic;       --fifo写请求
	fifo_wclk : out std_logic;       --fifo写时钟
	fifo_wrfull : in std_logic;      --fifo写满
	fifo_aclr : out std_logic        --fifo异步清零
);
end entity camera2fifo;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of camera2fifo is
	--写入数据行数计数器.
	signal line_count : integer range 0 to image_height := 0;
	signal line_count_impulse : std_logic := '0';  --行计数脉冲
	
	--帧可读脉冲触发条件. 写入frame_ready_threshold行后便可以开始连续开始读取240行
	constant frame_ready_threshold : integer := 203;
	
	--定义状态
	type state is (idle, wait_line, prepare_data, send_data, increment);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--帧可读信号
	signal ready : std_logic := '0';
	
	--行同步信号
	signal href_inside : std_logic := '0';
	
begin
	--fifo写入数据一直等于摄像头输出, 只通过对fifo写请求和写时钟来完成控制写入
	fifo_data <= pixel_data_in;
	fifo_wclk <= pclk;
	fifo_aclr <= not rst_n;
	frame_ready <= ready;
	--
	href_inside <= href;
	
	--帧可读信号产生
	process(line_count, fifo_wrfull)
	begin
		if(fifo_wrfull = '1') then
			ready <= '1';
		elsif(line_count < frame_ready_threshold) then
			ready <= '0';
		else
			ready <= '1';
		end if;
	end process;
	
	--状态转移进程
	process(rst_n, pclk)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(pclk'event and pclk = '1')then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, vsyn, href, fifo_wrfull, line_count)
	begin
		next_state <= cur_state;
		
		case cur_state is
		when idle =>
			if(vsyn = '1') then
				next_state <= wait_line;
			else
				next_state <= idle;
			end if;
		
		when wait_line =>
			if(fifo_wrfull = '1' or line_count = image_height) then
				next_state <= idle;
			elsif(href = '1') then
				next_state <= send_data;
			else
				next_state <= wait_line;
			end if;
		
		when send_data =>
			if(fifo_wrfull = '1') then
				next_state <= idle;
			else
				next_state <= prepare_data;
			end if;
		
		when prepare_data =>
			if(fifo_wrfull = '1') then
				next_state <= idle;
			elsif(href = '1') then
				next_state <= send_data;
			else
				next_state <= increment;
			end if;
		
		--该状态产生一个脉冲, 对line_count计数, 然后跳转到wait_line. 若接受完了一帧, 由wait_line状态判断是否回到idle
		when increment =>
			if(fifo_wrfull = '1') then
				next_state <= idle;
			else
				next_state <= wait_line;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机输出及内部信号赋值
	process(cur_state, line_count)
	begin
		case cur_state is
		when idle =>
			line_count_impulse <= '0';
			
		when wait_line =>
			line_count_impulse <= '0';
			
		when send_data =>
			line_count_impulse <= '0';
		
		when prepare_data =>
			line_count_impulse <= '0';
		
		when increment =>
			line_count_impulse <= '1';
			
		when others => null;
		end case;
	end process;
	
	--fifo写使能
	process(rst_n, next_state, href_inside)
	begin
		if(rst_n = '0' or next_state = idle) then
			fifo_wreq <= '0';
		else
			fifo_wreq <= href_inside;
		end if;
	end process;
	
	--line_count计数进程
	process(cur_state, line_count_impulse)
	begin
		if(cur_state = idle) then
			line_count <= 0;
		elsif(line_count_impulse'event and line_count_impulse = '1') then
			if(line_count = image_height) then
				line_count <= 0;
			else
				line_count <= line_count + 1;
			end if;
		end if;
	end process;

end architecture bhv;









