-------------------------------------------------------------------------
-------------------------------------------------------------------------
--vga_interface
--
-- 功能: 将ram中的图像通过VGA进行显示, 采用640x480@60hz
--
-- 描述: 产生vga模块需要的同步信号以及相应的RGB数据. 暂时采用灰度图输出, 所以RGB像素相同
--       当上游模块在写入ram时, 因为这个主要是为了调试, 实际钢琴系统不需要把图像显示出来
--       像显示出来, 所以无需部署算法使图像流畅.由于将ram读取功能也包含在内, 因此需要使
--       用状态机进行控制, 但是也比较简单.
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity vga_interface is
generic(
	--vga相关参数
	red_width : integer := 8;
	green_width : integer := 8;
	blue_width : integer := 8;
	
	--ram相关参数
	ram_awidth : integer := 17;
	ram_dwidth : integer := 8;
	ram_rddepth : integer := 76800;
	
	--图像信息
	image_height : integer := ov7670_image_height;
	image_width : integer := ov7670_image_width
);
port(
	--输入
	clk_50m : in std_logic;
	rst_n : in std_logic;
	
	--与vga器件交互
	r_data : out std_logic_vector(red_width - 1 downto 0);    --R5
	g_data : out std_logic_vector(green_width - 1 downto 0);  --G6
	b_data : out std_logic_vector(blue_width - 1 downto 0);   --B5
	vga_h : out std_logic;    --行同步信号
	vga_v : out std_logic;    --场同步信号
	vga_clk : out std_logic;  --vga时钟
	sync_n : out std_logic;   --灰电平控制 简单置0
	blank_n : out std_logic;  --消隐信号 简单置1
	
	--与ram交互
	ram_rden : out std_logic;   --ram读使能
	ram_rdaddress : out std_logic_vector(ram_awidth - 1 downto 0);   --ram读地址
	ram_rdclk : out std_logic;  --ram读时钟
	ram_pixel_data : in std_logic_vector(ram_dwidth - 1 downto 0)    --ram读出数据
);
end entity vga_interface;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of vga_interface is
	--场时序常数
	constant v_frame_period : integer := 525;
	constant v_sync_pulse : integer := 2;
	constant v_back_porch : integer := 33;
	constant v_active_time : integer := 480;
	constant v_front_porch : integer := 10;
	
	--行时序常数
	constant h_line_period : integer := 800;
	constant h_sync_pulse : integer := 96;
	constant h_back_porch : integer := 48;
	constant h_active_time : integer := 640;
	constant h_front_porch : integer := 16;
	
	--行列显示起始像素位置. 由于采集图像为320*240, 因此可以在屏幕中做一些移动
	constant original_x : integer := 160;
	constant original_y : integer := 120;
	
	--像素时钟为25mhz, 由输入时钟进行分频得到
	signal clk_25m : std_logic := '0';
	
	--行, 场计数器
	signal h_count : integer range 0 to h_line_period := 0;
	signal v_count : integer range 0 to v_frame_period := 0;
	
	--状态定义
	type state is (idle, set_rden, read_data, prepare_address, line_wait);
	signal cur_state : state := idle;
	signal next_state : state := idle;
	
	--内部信号
	signal ramclk : std_logic := '0';
	signal ramaddress : integer range 0 to ram_rddepth - 1 := ram_rddepth - 1;
	--signal ramaddress_impulse : std_logic := '0';  --ram读地址计数脉冲
	signal ramaddress_count_en : std_logic := '0';   --ram读地址计数使能
	
	signal R :  std_logic_vector(red_width - 1 downto 0) := (others => '0');    --R5
	signal G :  std_logic_vector(green_width - 1 downto 0) := (others => '0');  --G6
	signal B :  std_logic_vector(blue_width - 1 downto 0) := (others => '0');   --B5
begin
	--RAM输出数据赋值
	ram_rdaddress <= std_logic_vector(to_unsigned(ramaddress, ram_awidth));
	ram_rdclk <= clk_25m;
	
	--VGA输出
	r_data <= R;
	g_data <= G;
	b_data <= B;
	vga_clk <= clk_25m;
	blank_n <= '1';
	sync_n <= '0';
	

	--产生25mhz像素时钟
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			clk_25m <= '0';
		elsif(clk_50m'event and clk_50m = '1') then
			clk_25m <= not clk_25m;
		end if;
	end process;
	
	--行计数进程
	h_counter : process(rst_n, clk_25m)
	begin
		if(rst_n = '0') then
			h_count <= 0;
		elsif(clk_25m'event and clk_25m = '1')then
			if(h_count = h_line_period - 1) then
				h_count <= 0;
			else
				h_count <= h_count + 1;
			end if;
		end if;
	end process;
	--行同步信号产生, 当h_cout小于2时为低, 否则为高
	process(h_count)
	begin
		if(h_count < h_sync_pulse) then
			vga_h <= '0';
		else
			vga_h <= '1';
		end if;
	end process;
	
	--场计数进程
	v_counter : process(rst_n, clk_25m)
	begin
		if(rst_n = '0') then
			v_count <= 0;
		elsif(clk_25m'event and clk_25m = '1')then
			if(h_count = h_line_period - 1) then
				if(v_count = v_frame_period - 1) then
					v_count <= 0;
				else
					v_count <= v_count + 1;
				end if;
			else
				v_count <= v_count;
			end if;
		end if;
	end process;
	--场同步信号产生
	process(v_count)
	begin
		if(v_count < v_sync_pulse) then
			vga_v <= '0';
		else
			vga_v <= '1';
		end if;
	end process;
	
--	--在vga像素时钟上升沿时三个输出数据应该稳定
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_50m'event and clk_50m = '1') then
			cur_state <= next_state;		
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, h_count, v_count)
	begin
		next_state <= cur_state;
		case cur_state is
		--当行, 帧计数器到达active+原点坐标时开始读取ram数据
		when idle =>
			if(h_count = original_x + h_sync_pulse + h_back_porch - 1 - 1 and
				v_count = original_y + v_sync_pulse + v_back_porch) then   --由于状态机用50mhz时钟控制, 较之场计数信号变化快得多, 因此此处不减一
				next_state <= set_rden;
			else
				next_state <= idle;
			end if;
			
		when set_rden =>
			next_state <= read_data;
		
		when read_data =>
			next_state <= prepare_address;
		
		when prepare_address =>
			if(h_count = original_x + h_sync_pulse + h_back_porch + image_width - 1 - 1) then
				next_state <= line_wait;
			else
				next_state <= read_data;
			end if;
		--读完一行但是没读完一帧, 在此状态逗留, 直到下一行开始
		when line_wait =>
			if(v_count = original_y + v_sync_pulse + v_back_porch + image_height) then  --v_count代表第几行(0开始), 当前行数据要显示完, 因此此处加一
				next_state <= idle;
			elsif(h_count = original_x + h_sync_pulse + h_back_porch - 1 - 1) then
				next_state <= set_rden;
			else
				next_state <= line_wait;
			end if;
			
		when others => null;
		end case;
	end process;
	
	--状态机输出控制
	process(cur_state)
	begin
		
		case cur_state is
		when idle =>
			ram_rden <= '0';
			ramaddress_count_en <= '0';
		
		when set_rden =>
			ram_rden <= '1';
			ramaddress_count_en <= '0';
		
		when read_data =>
			ram_rden <= '1';
			ramaddress_count_en <= '1';
		
		when prepare_address =>
			ram_rden <= '1';
			ramaddress_count_en <= '1';
		
		when line_wait =>
			ram_rden <= '0';
			ramaddress_count_en <= '0';
		
		when others => null;
		end case;
	end process;
	
	--ram读地址生成
	process(cur_state, clk_25m, ramaddress_count_en)
	begin
		if(cur_state = idle) then
			ramaddress <= 0;
		elsif(clk_25m'event and clk_25m = '0') then
			if(ramaddress_count_en = '1') then
				if(ramaddress = ram_rddepth - 1) then
					ramaddress <= 0;
				else
					ramaddress <= ramaddress + 1;
				end if;
			else
				ramaddress <= ramaddress;
			end if;
		end if;
	
	end process;
	
	--颜色数据生成
	process(rst_n, ram_pixel_data)
	begin
		if(rst_n = '0') then
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
			
		--当行,场计数器在像素点为(0-320,0-240)范围内, rgb输出为ram上的数据
		elsif(h_count >= original_x + h_sync_pulse + h_back_porch and 
				h_count <= original_x + h_sync_pulse + h_back_porch + image_width - 1 and
				v_count >= original_y + v_sync_pulse + v_back_porch  and
				v_count <= original_y + v_sync_pulse + v_back_porch + image_height - 1) then
			R <= ram_pixel_data;
			G <= ram_pixel_data;
			B <= ram_pixel_data;
--			R <= "10000000";
--			G <= "00000000";
--			B <= "00000000";
			
		else
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
	end process;
end architecture bhv;


