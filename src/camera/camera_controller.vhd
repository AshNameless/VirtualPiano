---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--camera_controller
--
-- 功能: 完成对camera的配置，并将其输出的数据保存到fifo中, 同时给出frame_ready信号触发
--      后续模块.
--
-- 描述: 具体功能由i2c和camera2fifo模块承担
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity camera_controller is
generic(
	pixel_data_width : integer := ov7670_output_width;
	register_num : integer := ov7670_reg_num
);
port(
	--输入
	clk_50m : in std_logic;
	rst_n : in std_logic;
	
	--i2c时钟和数据线
	i2c_sda : inout std_logic;
	i2c_scl : out std_logic;
	
	--帧可读取信号
	frame_ready : out std_logic;
	--与7670交互信号
	pclk : in std_logic;             --像素时钟
	vsyn : in std_logic;             --帧同步信号
	href : in std_logic;             --场同步信号
	pixel_data_in : in std_logic_vector(pixel_data_width - 1 downto 0);  --像素数据, 两次传输一个像素
	xclk_25m : out std_logic;
	
	--与fifo交互信号
	fifo_data : out std_logic_vector(pixel_data_width - 1 downto 0);     --写到fifo的数据
	fifo_wreq : out std_logic;       --fifo写请求
	fifo_wclk : out std_logic;       --fifo写时钟
	fifo_wrfull : in std_logic       --fifo写满
);
end entity camera_controller;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of camera_controller is
	--i2c相关内部信号定义.
	signal rst_i2c : std_logic := '0';
	signal send : std_logic := '0';
	signal error : std_logic := '0';
	signal done : std_logic := '0';
	signal i2c_data : std_logic_vector(23 downto 0) := (others => '0');
	
	--camera2fifo相关内部信号定义.
	signal rst_cam : std_logic := '0';
	
	--共需配置13个寄存器
	signal reg_count : integer range 0 to register_num := 0;
	signal reg_count_impulse : std_logic := '0';    --从initilization_0到initilization_1有一个触发脉冲, 对计数器进行计数
	
	--摄像头通过硬件或者软件复位后需要1ms的setting time, 其他寄存器应该能直接继续写
	constant pause_count_num : integer := 50000;
	signal pause_count_en : std_logic := '0';
	signal pause_count : integer range 0 to pause_count_num := 0;
	
	
	--25mhz时钟
	signal xclk : std_logic := '0';
	
	--定义状态
	type state is (idle, pause, initilization_0, initilization_1, transmission, err);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--元件例化
	component I2C 
	port(
	clk_50m : in std_logic;
	rst_n : in std_logic;
	send : in std_logic;
	data : in std_logic_vector(23 downto 0);
	i2c_sda : inout std_logic;
	i2c_scl : out std_logic;
	done : out std_logic;
	error : out std_logic
	);
	end component;
	
	component camera2fifo
	port(
	rst_n : in std_logic;
	frame_ready : out std_logic;
	pclk : in std_logic;
	vsyn : in std_logic;
	href : in std_logic;
	pixel_data_in : in std_logic_vector(pixel_data_width - 1 downto 0);
	fifo_data : out std_logic_vector(pixel_data_width - 1 downto 0);
	fifo_wreq : out std_logic;
	fifo_wclk : out std_logic;
	fifo_wrfull : in std_logic
	);
	end component;
	
begin
	--例化
	i2c_inst : I2C
	port map(
		clk_50m,
		rst_i2c,
		send,
		i2c_data,
		i2c_sda,
		i2c_scl,
		done,
		error);
	
	camera2fifo_inst : camera2fifo
	port map(
	rst_cam,
	frame_ready,
	pclk,
	vsyn,
	href,
	pixel_data_in,
	fifo_data,
	fifo_wreq,
	fifo_wclk,
	fifo_wrfull
	);
	
	xclk_25m <= xclk;
	--25mhz xclk时钟产生
	process(clk_50m, rst_n)
	begin
		if(rst_n = '0') then
			xclk <= '0';
		elsif(clk_50m'event and clk_50m = '1') then
			xclk <= not xclk;
		end if;
	end process;

	--状态转移进程
	process(rst_n, clk_50m)
	begin
		if(rst_n ='0') then
			cur_state <= idle;
		elsif(clk_50m'event and clk_50m = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, reg_count, error, done, pause_count)
	begin
		next_state <= cur_state;
		case cur_state is
		when idle =>
			if(error = '1') then
				next_state <= idle;
			else
				next_state <= initilization_0;
			end if;
		
		when initilization_0 =>
			if(error = '1') then
				next_state <= err;
			elsif(done = '0') then
				next_state <= initilization_1;
			else
				next_state <= initilization_0;
			end if;
		
		when initilization_1 =>
			if(error = '1') then
				next_state <= err;
			elsif(done = '0') then
				next_state <= initilization_1;
			--在reg_count_impulse下降沿增加一, 当reg_count=7时在initilization_1状态下它已经发送完了
			elsif(reg_count = 0) then
				next_state <= pause;
			elsif(reg_count = register_num - 1) then
				next_state <= transmission;
			else
				next_state <= initilization_0;
			end if;
		
		when pause =>
			if(error = '1') then
				next_state <= err;
			elsif(pause_count >= pause_count_num - 1) then
				next_state <= initilization_0;
			else
				next_state <= pause;
			end if;
		
		when transmission =>
			next_state <= transmission;
		
		--i2c出错后需要发送结束信号, 结束信号完成后有done信号, 因此需要等到done为高时才表示关闭本次传输
		when err =>
			if(done = '1') then
				next_state <= idle;
			else
				next_state <= err;
			end if;
		
		when others => null;
		end case;
	end process;

	--状态机输出控制
	process(cur_state ,reg_count)
	begin
		case cur_state is
		when idle =>
			rst_cam <= '0';
			rst_i2c <= '0';
			
			i2c_data <= (others => '0');
			send <= '0';
			reg_count_impulse <= '0';
			pause_count_en <= '0';
		
		--i2c_rst置位,准备i2c数据
		when initilization_0 =>
			rst_cam <= '0';
			
			rst_i2c <= '1';
			send <= '0';
			--procedure详见subpros
			camera_regcount2data(reg_count, i2c_data);
			reg_count_impulse <= '0';
			pause_count_en <= '0';
		
		when initilization_1 =>
			rst_cam <= '0';
			
			rst_i2c <= '1';
			send <= '1';
			camera_regcount2data(reg_count, i2c_data);
			reg_count_impulse <= '1';
			pause_count_en <= '0';
		
		when pause =>
			rst_cam <= '0';
			
			rst_i2c <= '1';
			send <= '0';
			camera_regcount2data(reg_count, i2c_data);
			reg_count_impulse <= '0';
			pause_count_en <= '1';
		
		when transmission =>
			rst_cam <= '1';
			
			rst_i2c <= '0';
			send <= '0';
			i2c_data <= (others => '0');
			reg_count_impulse <= '0';
			pause_count_en <= '0';
		
		when err =>
			rst_cam <= '0';
			
			rst_i2c <= '1';
			i2c_data <= (others => '0');
			send <= '0';
			reg_count_impulse <= '0';
			pause_count_en <= '0';
			
		when others => null;
		end case;
	end process;
	
	--reg_count计数进程
	process(cur_state, reg_count_impulse) 
	begin
		if(cur_state = idle) then
			reg_count <= 0;
		elsif(reg_count_impulse'event and reg_count_impulse = '0') then
			if(reg_count < register_num) then
				reg_count <= reg_count + 1;
			else
				reg_count <= 0;
			end if;
		end if;
	end process;
	
	--pause计数进程. 计数满后可以继续向寄存器写入
	process(clk_50m, pause_count_en)
	begin
		if(pause_count_en = '0') then
			pause_count <= 0;
		elsif(clk_50m'event and clk_50m = '1') then
			if(pause_count = pause_count_num) then
				pause_count <= 0;
			else
				pause_count <= pause_count + 1;
			end if;
		end if;
	end process;

end architecture bhv;










