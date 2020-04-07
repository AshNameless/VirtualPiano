---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--wm8731 controller
--
-- 功能: 完成wm8731芯片的初始化,相应寄存器的配置,产生wm8731从模式下所需的时钟和数据,完成播放
--
-- 原理: 一个简单的三状态机,初始化成功后就一直保持在传输状态,主要功能由i2c模块和left justified模块承担
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
use work.subpros.all;
-------------------------------------------------------
-------------------------------------------------------
entity WM8731_controller is
port(
	--输入
	clk_50m : in std_logic;
	rst_n : in std_logic;
	note_data : in std_logic_vector(note_out_width - 1 downto 0);
	
	--输出到wm8731
	AUD_MCLK : out std_logic;                    --芯片工作时钟
	AUD_BCLK : out std_logic;                    --比特流时钟
	AUD_DACDAT : out std_logic;                  --串行数据线
	AUD_DACLRCK : out std_logic;                 --左右声道信号
	I2C_SCLK : out std_logic;                    --I2C时钟线
	I2C_SDAT : inout std_logic                   --I2C数据线
);
end entity WM8731_controller;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of WM8731_controller is
	--i2c相关信号定义. 由于i2c在内部例化,需要相关信号对其输入和获取输出
	signal rst_i2c : std_logic := '0';
	signal send : std_logic := '0';
	signal error : std_logic := '0';
	signal done : std_logic := '0';
	signal i2c_data : std_logic_vector(23 downto 0) := (others => '0');
	
	--left相关信号定义. 由于在内部例化,需要相关信号对其输入和获取输出
	signal rst_left : std_logic := '0';
	
	--共配置9个寄存器
	signal reg_count : integer range 0 to audio_codec_reg_num := 0;
	
	--定义状态
	type state is (idle, initilization_0, initilization_1, transmission, err);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--原件例化
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
	
	component Left_justified is 
	port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	note_data : in std_logic_vector(note_out_width - 1 downto 0);
	AUD_MCLK : out std_logic;
	AUD_BCLK : out std_logic;
	AUD_DACDAT : out std_logic;
	AUD_DACLRCK : out std_logic
	);
	end component;

begin
	--原件例化
	i2c_inst : I2C
	port map(
		clk_50m => clk_50m,
		rst_n => rst_i2c,
		send => send,
		data => i2c_data,
		i2c_sda => I2C_SDAT,
		i2c_scl => I2C_SCLK,
		done => done,
		error => error);
	
	left_inst : Left_justified
	port map(
		clk_50m => clk_50m,
		rst_n => rst_left,
		note_data => note_data,
		AUD_MCLK => AUD_MCLK,
		AUD_BCLK => AUD_BCLK,
		AUD_DACDAT => AUD_DACDAT,
		AUD_DACLRCK => AUD_DACLRCK);
	
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
	process(cur_state, reg_count, error, done)
	begin
		next_state <= cur_state;
		case cur_state is
		when idle =>
			next_state <= initilization_0;
		
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
			elsif(reg_count = audio_codec_reg_num) then
				next_state <= transmission;
			else
				next_state <= initilization_0;
			end if;
			
		when transmission =>
			next_state <= transmission;
		
		when err =>
			next_state <= idle;
		
		when others => null;
		end case;
	end process;
	
	--状态机输出控制
	process(cur_state)
	begin
		case cur_state is
		when idle =>
			rst_left <= '0';
			
			rst_i2c <= '0';
			i2c_data <= (others => '0');
			send <= '0';
			reg_count <= 0;
		
		--i2c_rst置位,准备i2c数据
		when initilization_0 =>
			rst_left <= '0';
			
			rst_i2c <= '1';
			send <= '0';
			codec_regcount2data(reg_count, i2c_data);
			
			if(reg_count < audio_codec_reg_num) then
				reg_count <= reg_count + 1;
			else
				reg_count <= 0;
			end if;
		
		when initilization_1 =>
			rst_left <= '0';
			
			rst_i2c <= '1';
			send <= '1';
		
		when transmission =>
			rst_left <= '1';
			
			rst_i2c <= '0';
			send <= '0';
			i2c_data <= (others => '0');
		
		when err =>
			rst_left <= '0';
			
			rst_i2c <= '0';
			i2c_data <= (others => '0');
			send <= '0';
		when others => null;
		end case;
		
	end process;
end architecture bhv;


