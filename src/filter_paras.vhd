---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--用来保存滤波器相关参数的package
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package filter_paras is
	-------------------------
	--filter
	-------------------------
	--滤波器相关参数
	
	constant order_of_filter : integer := 10;  --滤波器阶数
	--滤波器系数的位数. 需要注意的是本身滤波器系数只需要11位即可表示, 但在编写滤波器时signed类型的和貌似
	--要和两个加数保持一致, 不然编译报错. 因为滤波器乘积和需要大一位, 这里就直接将其设置为12位
	constant filter_coeff_width : integer := 12;
	
	--11+6是乘积. 最后加一是因为做加法, 且系数和最大值不超过2048, 因此只加1位
	constant filter_output_width : integer := 11 + 6 + 1;
	--滤波器采样率位20khz, 50mhz计数分频计数翻转值
	constant filter_count_threshold : integer := 259;
	
	--滤波器的乘法系数
	----------filter1coeffcients----------
	constant filter1_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(14,filter_coeff_width);
	constant filter1_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(30,filter_coeff_width);
	constant filter1_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(73,filter_coeff_width);
	constant filter1_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(127,filter_coeff_width);
	constant filter1_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(171,filter_coeff_width);
	constant filter1_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(188,filter_coeff_width);
	----------filter2coeffcients----------
	constant filter2_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter2_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter2_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(42,filter_coeff_width);
	constant filter2_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(123,filter_coeff_width);
	constant filter2_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(215,filter_coeff_width);
	constant filter2_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(256,filter_coeff_width);
	----------filter3coeffcients----------
	constant filter3_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-3,filter_coeff_width);
	constant filter3_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(3,filter_coeff_width);
	constant filter3_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(38,filter_coeff_width);
	constant filter3_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(122,filter_coeff_width);
	constant filter3_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(220,filter_coeff_width);
	constant filter3_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(265,filter_coeff_width);
	----------filter4coeffcients----------
	constant filter4_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter4_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(0,filter_coeff_width);
	constant filter4_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(33,filter_coeff_width);
	constant filter4_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(120,filter_coeff_width);
	constant filter4_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(226,filter_coeff_width);
	constant filter4_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(274,filter_coeff_width);
	----------filter5coeffcients----------
	constant filter5_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter5_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter5_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(28,filter_coeff_width);
	constant filter5_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(117,filter_coeff_width);
	constant filter5_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(231,filter_coeff_width);
	constant filter5_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(285,filter_coeff_width);
	----------filter6coeffcients----------
	constant filter6_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter6_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter6_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(22,filter_coeff_width);
	constant filter6_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(114,filter_coeff_width);
	constant filter6_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(238,filter_coeff_width);
	constant filter6_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(297,filter_coeff_width);
	----------filter7coeffcients----------
	constant filter7_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter7_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter7_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(15,filter_coeff_width);
	constant filter7_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(109,filter_coeff_width);
	constant filter7_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(245,filter_coeff_width);
	constant filter7_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(311,filter_coeff_width);
	----------filter8coeffcients----------
	constant filter8_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter8_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-10,filter_coeff_width);
	constant filter8_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter8_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(104,filter_coeff_width);
	constant filter8_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(252,filter_coeff_width);
	constant filter8_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(326,filter_coeff_width);
	----------filter9coeffcients----------
	constant filter9_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter9_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-12,filter_coeff_width);
	constant filter9_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(0,filter_coeff_width);
	constant filter9_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(97,filter_coeff_width);
	constant filter9_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(259,filter_coeff_width);
	constant filter9_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(343,filter_coeff_width);
	----------filter10coeffcients----------
	constant filter10_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter10_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter10_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter10_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(89,filter_coeff_width);
	constant filter10_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(266,filter_coeff_width);
	constant filter10_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(361,filter_coeff_width);
	----------filter11coeffcients----------
	constant filter11_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter11_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-14,filter_coeff_width);
	constant filter11_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-16,filter_coeff_width);
	constant filter11_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(79,filter_coeff_width);
	constant filter11_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(273,filter_coeff_width);
	constant filter11_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(381,filter_coeff_width);
	----------filter12coeffcients----------
	constant filter12_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(0,filter_coeff_width);
	constant filter12_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter12_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-24,filter_coeff_width);
	constant filter12_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(68,filter_coeff_width);
	constant filter12_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(280,filter_coeff_width);
	constant filter12_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(403,filter_coeff_width);
	----------filter13coeffcients----------
	constant filter13_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(1,filter_coeff_width);
	constant filter13_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-12,filter_coeff_width);
	constant filter13_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-31,filter_coeff_width);
	constant filter13_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(54,filter_coeff_width);
	constant filter13_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(286,filter_coeff_width);
	constant filter13_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(426,filter_coeff_width);
	----------filter14coeffcients----------
	constant filter14_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(3,filter_coeff_width);
	constant filter14_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter14_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-37,filter_coeff_width);
	constant filter14_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(38,filter_coeff_width);
	constant filter14_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(291,filter_coeff_width);
	constant filter14_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(451,filter_coeff_width);
	----------filter15coeffcients----------
	constant filter15_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter15_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter15_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-41,filter_coeff_width);
	constant filter15_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(21,filter_coeff_width);
	constant filter15_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(294,filter_coeff_width);
	constant filter15_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(478,filter_coeff_width);
	----------filter16coeffcients----------
	constant filter16_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter16_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(0,filter_coeff_width);
	constant filter16_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-43,filter_coeff_width);
	constant filter16_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(2,filter_coeff_width);
	constant filter16_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(295,filter_coeff_width);
	constant filter16_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(506,filter_coeff_width);
	----------filter17coeffcients----------
	constant filter17_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter17_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter17_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-42,filter_coeff_width);
	constant filter17_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-19,filter_coeff_width);
	constant filter17_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(295,filter_coeff_width);
	constant filter17_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(537,filter_coeff_width);
	----------filter18coeffcients----------
	constant filter18_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(3,filter_coeff_width);
	constant filter18_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(9,filter_coeff_width);
	constant filter18_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-37,filter_coeff_width);
	constant filter18_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-40,filter_coeff_width);
	constant filter18_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(291,filter_coeff_width);
	constant filter18_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(570,filter_coeff_width);
	----------filter19coeffcients----------
	constant filter19_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(1,filter_coeff_width);
	constant filter19_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(13,filter_coeff_width);
	constant filter19_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-28,filter_coeff_width);
	constant filter19_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-61,filter_coeff_width);
	constant filter19_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(285,filter_coeff_width);
	constant filter19_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(606,filter_coeff_width);
	----------filter20coeffcients----------
	constant filter20_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter20_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(14,filter_coeff_width);
	constant filter20_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-16,filter_coeff_width);
	constant filter20_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-80,filter_coeff_width);
	constant filter20_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(274,filter_coeff_width);
	constant filter20_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(643,filter_coeff_width);
	----------filter21coeffcients----------
	constant filter21_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter21_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(12,filter_coeff_width);
	constant filter21_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-1,filter_coeff_width);
	constant filter21_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-96,filter_coeff_width);
	constant filter21_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(260,filter_coeff_width);
	constant filter21_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(683,filter_coeff_width);
	----------filter22coeffcients----------
	constant filter22_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter22_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter22_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(15,filter_coeff_width);
	constant filter22_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-107,filter_coeff_width);
	constant filter22_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(240,filter_coeff_width);
	constant filter22_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(725,filter_coeff_width);
	----------filter23coeffcients----------
	constant filter23_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter23_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(1,filter_coeff_width);
	constant filter23_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(29,filter_coeff_width);
	constant filter23_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-112,filter_coeff_width);
	constant filter23_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(214,filter_coeff_width);
	constant filter23_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(767,filter_coeff_width);
	----------filter24coeffcients----------
	constant filter24_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter24_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-1,filter_coeff_width);
	constant filter24_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-42,filter_coeff_width);
	constant filter24_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter24_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(295,filter_coeff_width);
	constant filter24_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(501,filter_coeff_width);
	
	--滤波器参数选择子程序. 根据输入的整数, 设置相应的参数
	procedure filnum2paras(signal num : in integer range 0 to 24;
								  signal coeff1 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff2 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff3 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff4 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff5 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff6 : out signed(filter_coeff_width - 1 downto 0));
end package filter_paras;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package body filter_paras is
	procedure filnum2paras(signal num : in integer range 0 to 24;
								  signal coeff1 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff2 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff3 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff4 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff5 : out signed(filter_coeff_width - 1 downto 0);
								  signal coeff6 : out signed(filter_coeff_width - 1 downto 0)) is
	begin
		case num is
		when 1 => 
			coeff1 <= filter1_coeff1;
			coeff2 <= filter1_coeff2;
			coeff3 <= filter1_coeff3;
			coeff4 <= filter1_coeff4;
			coeff5 <= filter1_coeff5;
			coeff6 <= filter1_coeff6;
		when 2 => 
			coeff1 <= filter2_coeff1;
			coeff2 <= filter2_coeff2;
			coeff3 <= filter2_coeff3;
			coeff4 <= filter2_coeff4;
			coeff5 <= filter2_coeff5;
			coeff6 <= filter2_coeff6;
		when 3 => 
			coeff1 <= filter3_coeff1;
			coeff2 <= filter3_coeff2;
			coeff3 <= filter3_coeff3;
			coeff4 <= filter3_coeff4;
			coeff5 <= filter3_coeff5;
			coeff6 <= filter3_coeff6;
		when 4 => 
			coeff1 <= filter4_coeff1;
			coeff2 <= filter4_coeff2;
			coeff3 <= filter4_coeff3;
			coeff4 <= filter4_coeff4;
			coeff5 <= filter4_coeff5;
			coeff6 <= filter4_coeff6;
		when 5 => 
			coeff1 <= filter5_coeff1;
			coeff2 <= filter5_coeff2;
			coeff3 <= filter5_coeff3;
			coeff4 <= filter5_coeff4;
			coeff5 <= filter5_coeff5;
			coeff6 <= filter5_coeff6;
		when 6 => 
			coeff1 <= filter6_coeff1;
			coeff2 <= filter6_coeff2;
			coeff3 <= filter6_coeff3;
			coeff4 <= filter6_coeff4;
			coeff5 <= filter6_coeff5;
			coeff6 <= filter6_coeff6;
		when 7 => 
			coeff1 <= filter7_coeff1;
			coeff2 <= filter7_coeff2;
			coeff3 <= filter7_coeff3;
			coeff4 <= filter7_coeff4;
			coeff5 <= filter7_coeff5;
			coeff6 <= filter7_coeff6;
		when 8 => 
			coeff1 <= filter8_coeff1;
			coeff2 <= filter8_coeff2;
			coeff3 <= filter8_coeff3;
			coeff4 <= filter8_coeff4;
			coeff5 <= filter8_coeff5;
			coeff6 <= filter8_coeff6;
		when 9 => 
			coeff1 <= filter9_coeff1;
			coeff2 <= filter9_coeff2;
			coeff3 <= filter9_coeff3;
			coeff4 <= filter9_coeff4;
			coeff5 <= filter9_coeff5;
			coeff6 <= filter9_coeff6;
		when 10 => 
			coeff1 <= filter10_coeff1;
			coeff2 <= filter10_coeff2;
			coeff3 <= filter10_coeff3;
			coeff4 <= filter10_coeff4;
			coeff5 <= filter10_coeff5;
			coeff6 <= filter10_coeff6;
		when 11 => 
			coeff1 <= filter11_coeff1;
			coeff2 <= filter11_coeff2;
			coeff3 <= filter11_coeff3;
			coeff4 <= filter11_coeff4;
			coeff5 <= filter11_coeff5;
			coeff6 <= filter11_coeff6;
		when 12 => 
			coeff1 <= filter12_coeff1;
			coeff2 <= filter12_coeff2;
			coeff3 <= filter12_coeff3;
			coeff4 <= filter12_coeff4;
			coeff5 <= filter12_coeff5;
			coeff6 <= filter12_coeff6;
		when 13 => 
			coeff1 <= filter13_coeff1;
			coeff2 <= filter13_coeff2;
			coeff3 <= filter13_coeff3;
			coeff4 <= filter13_coeff4;
			coeff5 <= filter13_coeff5;
			coeff6 <= filter13_coeff6;
		when 14 => 
			coeff1 <= filter14_coeff1;
			coeff2 <= filter14_coeff2;
			coeff3 <= filter14_coeff3;
			coeff4 <= filter14_coeff4;
			coeff5 <= filter14_coeff5;
			coeff6 <= filter14_coeff6;
		when 15 => 
			coeff1 <= filter15_coeff1;
			coeff2 <= filter15_coeff2;
			coeff3 <= filter15_coeff3;
			coeff4 <= filter15_coeff4;
			coeff5 <= filter15_coeff5;
			coeff6 <= filter15_coeff6;
		when 16 => 
			coeff1 <= filter16_coeff1;
			coeff2 <= filter16_coeff2;
			coeff3 <= filter16_coeff3;
			coeff4 <= filter16_coeff4;
			coeff5 <= filter16_coeff5;
			coeff6 <= filter16_coeff6;
		when 17 => 
			coeff1 <= filter17_coeff1;
			coeff2 <= filter17_coeff2;
			coeff3 <= filter17_coeff3;
			coeff4 <= filter17_coeff4;
			coeff5 <= filter17_coeff5;
			coeff6 <= filter17_coeff6;
		when 18 => 
			coeff1 <= filter18_coeff1;
			coeff2 <= filter18_coeff2;
			coeff3 <= filter18_coeff3;
			coeff4 <= filter18_coeff4;
			coeff5 <= filter18_coeff5;
			coeff6 <= filter18_coeff6;
		when 19 => 
			coeff1 <= filter19_coeff1;
			coeff2 <= filter19_coeff2;
			coeff3 <= filter19_coeff3;
			coeff4 <= filter19_coeff4;
			coeff5 <= filter19_coeff5;
			coeff6 <= filter19_coeff6;
		when 20 => 
			coeff1 <= filter20_coeff1;
			coeff2 <= filter20_coeff2;
			coeff3 <= filter20_coeff3;
			coeff4 <= filter20_coeff4;
			coeff5 <= filter20_coeff5;
			coeff6 <= filter20_coeff6;
		when 21 => 
			coeff1 <= filter21_coeff1;
			coeff2 <= filter21_coeff2;
			coeff3 <= filter21_coeff3;
			coeff4 <= filter21_coeff4;
			coeff5 <= filter21_coeff5;
			coeff6 <= filter21_coeff6;
		when 22 => 
			coeff1 <= filter22_coeff1;
			coeff2 <= filter22_coeff2;
			coeff3 <= filter22_coeff3;
			coeff4 <= filter22_coeff4;
			coeff5 <= filter22_coeff5;
			coeff6 <= filter22_coeff6;
		when 23 => 
			coeff1 <= filter23_coeff1;
			coeff2 <= filter23_coeff2;
			coeff3 <= filter23_coeff3;
			coeff4 <= filter23_coeff4;
			coeff5 <= filter23_coeff5;
			coeff6 <= filter23_coeff6;
		when 24 => 
			coeff1 <= filter24_coeff1;
			coeff2 <= filter24_coeff2;
			coeff3 <= filter24_coeff3;
			coeff4 <= filter24_coeff4;
			coeff5 <= filter24_coeff5;
			coeff6 <= filter24_coeff6;
		when others =>
			coeff1 <= (others => '0');
			coeff2 <= (others => '0');
			coeff3 <= (others => '0');
			coeff4 <= (others => '0');
			coeff5 <= (others => '0');
			coeff6 <= (others => '0');
		end case;
	end procedure;

end filter_paras;

