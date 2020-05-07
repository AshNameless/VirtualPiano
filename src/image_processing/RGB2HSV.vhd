---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--RGB2HSV
--
-- 功能: 将RGB565数据转换为HSV格式
--
-- 描述: 由于RGB565转为HSV的公式中, S分量的计算中存在负数. 用枚举RGB大小的方法避免引入
--       有符号数. 
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity RGB2HSV is
generic(
	rgb_dwidth : integer := 16;  --RGB565一个像素由两个字节表示
	h_dwidth : integer := 9; --h范围是0-360
	s_dwidth : integer := 8;
	v_dwidth : integer := 8
);
port(
	--复位信号
	rst_n : in std_logic;
	--rgb565输入数据以及同步信号和时钟
	rgb_data : in std_logic_vector(rgb_dwidth - 1 downto 0);
	pclk_in : in std_logic;
	fsyn_in : in std_logic;
	
	--输出. 直接将输入的时钟和同步信号传递到下一级
	H : out std_logic_vector(h_dwidth - 1 downto 0);
	pclk_out : out std_logic;
	fsyn_out : out std_logic;
	
	--S本身为0-1, 将其展开为0-255用整数表示
	S : out std_logic_vector(s_dwidth - 1 downto 0);
	V : out std_logic_vector(v_dwidth - 1 downto 0)
	
);
end entity RGB2HSV;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of RGB2HSV is
	--内部信号, 将RGB565低位补零换成有符号RGB888
	signal data_in : unsigned(rgb_dwidth - 1 downto 0) := (others => '0');
	signal R : unsigned(7 downto 0) := (others => '0');
	signal G : unsigned(7 downto 0) := (others => '0');
	signal B : unsigned(7 downto 0) := (others => '0');
	
	--相对关系指示信号
	signal order_flag : std_logic_vector(2 downto 0) := (others => '0');
	
	--RGB中的最大值, 最小值, 以及它和最小值之间的差
	signal max : unsigned(7 downto 0) := (others=> '0');
	signal min : unsigned(7 downto 0) := (others=> '0');
	signal delta : unsigned(7 downto 0) := (others=> '0');
	signal delta_255 : unsigned(15 downto 0) := (others => '0');
	
	--计算H分量时的中间变量
	signal numerator : unsigned(7 downto 0) := (others=> '0');  --三个可能分子
	signal numerator_60 : unsigned(13 downto 0) := (others=> '0');  --乘以60以后的分子.
	signal quotient : unsigned(numerator_60'length - 1 downto 0) := (others => '0');  --商
	
	--HSV内部信号
	signal h_inside : unsigned(numerator_60'length -1  downto 0) := (others => '0');
	signal s_inside : unsigned(delta_255'length - 1 downto 0) := (others => '0');
	signal v_inside : unsigned(7 downto 0) := (others => '0');
		
	--常数
	constant bias_120 : unsigned(h_inside'length - 1 downto 0) := to_unsigned(120, h_inside'length);
	constant bias_240 : unsigned(h_inside'length - 1 downto 0) := to_unsigned(240, h_inside'length);
	constant bias_360 : unsigned(h_inside'length - 1 downto 0) := to_unsigned(360, h_inside'length);
	
	
begin
	--输出赋值
	H <= std_logic_vector(h_inside(h_dwidth - 1 downto 0));
	V <= std_logic_vector(v_inside(v_dwidth - 1 downto 0));
	S <= std_logic_vector(s_inside(s_dwidth - 1 downto 0));
	pclk_out <= pclk_in;
	fsyn_out <= fsyn_in;
	
	--RGB跟随输入
	data_in <= unsigned(rgb_data);
	R <= data_in(15 downto 11) & "000";
	G <= data_in(10 downto 5) & "00";
	B <= data_in(4 downto 0 ) & "000";
	
	--相对关系
	order_flag(2) <= '1' when R >= G else '0';
	order_flag(1) <= '1' when R >= B else '0';
	order_flag(0) <= '1' when B >= G else '0';
	
	--中间值生成
	process(order_flag, R, G, B)
	begin
		max <= (others => '0');
		delta <= (others => '0');
		numerator <= (others => '0');
		
		case order_flag is
		when "001" => --R<G<B
			max <= B;
			delta <= B-R;
			numerator <= G-R;
		when "010" => --B<R<G
			max <= G;
			delta <= G-B;
			numerator <= R-B;
		when "011" => --R<B<G
			max <= G;
			delta <= G-R;
			numerator <= B-R;
		when "100" => --G<B<R
			max <= R;
			delta <= R-G;
			numerator <= B-G;
		when "101" => --G<R<B
			max <= B;
			delta <= B-G;
			numerator <= R-G;
		when "110" => --B<G<R
			max <= R;
			delta <= R-B;
			numerator <= G-B;
		when "111" => --R=G=B
			max <= R;
			delta <= (others => '0');
			delta <= (others => '0');
		
		when others => null;
		end case;
	end process;
	
	--H分子乘以60, 将其左移4位减去其左移2位
	numerator_60 <= numerator&"0000" - numerator&"00";
	quotient <= numerator_60/delta;
	delta_255 <= delta&x"00";
	
	--计算输出
	process(rst_n, order_flag, R, G, B, max, quotient, delta_255)
	begin
		if(rst_n = '0') then
			h_inside <= (others => '0');
			s_inside <= (others => '0');
			v_inside <= (others => '0');
		else
			--H
			h_inside <= (others => '0');
			case order_flag is
			when "001" => --R<G<B
				h_inside <= bias_240 - quotient;
			when "010" => --B<R<G
				h_inside <= bias_120 - quotient;
			when "011" => --R<B<G
				h_inside <= bias_120 + quotient;
			when "100" => --G<B<R
				h_inside <= bias_360 + quotient;
			when "101" => --G<R<B
				h_inside <= bias_240 + quotient;
			when "110" => --B<G<R
				h_inside <= quotient;
			when "111" => --R=G=B
				--也就是白色, 为了避免干扰0的值, 将其赋值为255
				h_inside <= (others => '1');
			when others => null;
			end case;
			
			--S
			if(max = 0) then
				s_inside <= (others => '0');
			else
				s_inside <= delta_255/max;
			end if;
		
			--V
			v_inside <= max;
		end if;
	end process;
	
end architecture bhv;
















