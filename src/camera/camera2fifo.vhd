---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--camera2fifo
--
-- 功能: 从摄像头接收同步信号和数据, 据此产生fifo写时序，将图像数据暂存到fifo中. 当写入一
--       定数量后, 输出一个触发信号, 示意后续模块可以开始读取.
--
-- 描述: 利用状态机控制, 从摄像头控制模块得到启动信号后开始启动数据传输,
--       由于YUV输出为UYVY顺序, 故fifo写时钟应当是PCLk的二分频. 输入到fifo数据就一直跟
--       随摄像头输出的数据, 这样比较简单, 只通过写时钟提取出Y数据即可. 写完一帧后等待 
--       下一帧, 一直循环.
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity camera2fifo is
generic(
	pixel_data_width : integer := ov7725_output_width;
 	image_height : integer := ov7725_image_height
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
	fifo_wrfull : in std_logic       --fifo写满
);
end entity camera2fifo;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of camera2fifo is
	--写入数据行数计数器.
	signal line_count : integer range 0 to image_height := 0;
	--帧可读脉冲触发条件. 写入200行后便可以开始连续开始读取240行
	constant frame_ready_threshold : integer := 200;
	
	--定义状态
	type state is (idle, wait_line, prepare_y, send_y, increment);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	
begin
	--fifo写入数据一直等于摄像头输出, 只通过对fifo写请求和写时钟来完成控制写入
	fifo_data <= pixel_data_in;
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
	process(cur_state, vsyn, href, fifo_wrfull)
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
				next_state <= prepare_y;
			else
				next_state <= wait_line;
			end if;
		
		when prepare_y =>
			if(fifo_wrfull = '1') then
				next_state <= idle;
			else
				next_state <= send_y;
			end if;
			
		when send_y =>
			if(fifo_wrfull = '1') then
				next_state <= idle;
			elsif(href = '1') then
				next_state <= prepare_y;
			else
				next_state <= increment;
			end if;
		
		--该状态只进行一次行计数器加法, 然后跳转到wait_line. 若接受完了一帧, 由wait_line状态判断是否回到idle
		when increment =>
			if(fifo_wrfull = '0' and href = '0') then
				next_state <= wait_line;
			else
				next_state <= idle;
			end if;
		
		when others => null;
		end case;
	end process;
	
	--状态机输出及内部信号赋值
	process(cur_state)
	begin
		case cur_state is
		when idle =>
			fifo_wreq <= '0';
			fifo_wclk <= '0';
			line_count <= 0;
			frame_ready <= '0';
			
		when wait_line =>
			fifo_wreq <= '1';
			fifo_wclk <= '0';
			if(line_count = frame_ready_threshold) then
				frame_ready <= '1';
			else
				frame_ready <= '0';
			end if;
		
		when prepare_y =>
			fifo_wreq <= '1';
			fifo_wclk <= '0';
			frame_ready <= '0';
		
		when send_y =>
			fifo_wreq <= '1';
			fifo_wclk <= '1';
			frame_ready <= '0';
		
		when increment =>
			fifo_wreq <= '0';
			fifo_wclk <= '0';
			frame_ready <= '0';
			line_count <= line_count + 1;
		
		when others => null;
		end case;
	end process;

end architecture bhv;









