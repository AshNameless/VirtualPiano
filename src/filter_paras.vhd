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
	
	constant order_of_filter : integer := 20;  --滤波器阶数
	--滤波器系数的位数. 需要注意的是本身滤波器系数只需要11位即可表示, 但在编写滤波器时signed类型的和貌似
	--要和两个加数保持一致, 不然编译报错. 因为滤波器乘积和需要大一位, 这里就直接将其设置为12位
	constant filter_coeff_width : integer := 12;
	
	--11+6是乘积. 最后加一是因为做加法, 且系数和最大值不超过2048, 因此只加1位
	constant filter_output_width : integer := 11 + 6 + 1;
	--滤波器采样率10khz, 50mhz计数分频计数翻转值
	constant filter_count_threshold : integer := 2499;
	--乘法系数和乘积类型, 用数组表示方便扩展
	type filter_coeff_type is array(natural range<>) of signed(filter_coeff_width - 1 downto 0);
	type product_type is array(natural range<>) of signed(filter_coeff_width + 6 - 1 downto 0);
	
	----------filter1coeffcients----------
	constant filter1_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter1_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-7,filter_coeff_width);
	constant filter1_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter1_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(12,filter_coeff_width);
	constant filter1_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(50,filter_coeff_width);
	constant filter1_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(115,filter_coeff_width);
	constant filter1_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(205,filter_coeff_width);
	constant filter1_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(307,filter_coeff_width);
	constant filter1_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(403,filter_coeff_width);
	constant filter1_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(471,filter_coeff_width);
	constant filter1_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(495,filter_coeff_width);
	----------filter2coeffcients----------
	constant filter2_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter2_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter2_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter2_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(4,filter_coeff_width);
	constant filter2_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(40,filter_coeff_width);
	constant filter2_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(105,filter_coeff_width);
	constant filter2_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(199,filter_coeff_width);
	constant filter2_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(309,filter_coeff_width);
	constant filter2_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(414,filter_coeff_width);
	constant filter2_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(489,filter_coeff_width);
	constant filter2_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(516,filter_coeff_width);
	----------filter3coeffcients----------
	constant filter3_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter3_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-11,filter_coeff_width);
	constant filter3_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter3_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter3_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(28,filter_coeff_width);
	constant filter3_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(94,filter_coeff_width);
	constant filter3_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(192,filter_coeff_width);
	constant filter3_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(311,filter_coeff_width);
	constant filter3_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(425,filter_coeff_width);
	constant filter3_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(509,filter_coeff_width);
	constant filter3_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(540,filter_coeff_width);
	----------filter4coeffcients----------
	constant filter4_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter4_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter4_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-17,filter_coeff_width);
	constant filter4_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-12,filter_coeff_width);
	constant filter4_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(16,filter_coeff_width);
	constant filter4_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(80,filter_coeff_width);
	constant filter4_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(183,filter_coeff_width);
	constant filter4_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(311,filter_coeff_width);
	constant filter4_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(438,filter_coeff_width);
	constant filter4_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(532,filter_coeff_width);
	constant filter4_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(566,filter_coeff_width);
	----------filter5coeffcients----------
	constant filter5_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter5_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter5_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-20,filter_coeff_width);
	constant filter5_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-21,filter_coeff_width);
	constant filter5_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(3,filter_coeff_width);
	constant filter5_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(65,filter_coeff_width);
	constant filter5_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(172,filter_coeff_width);
	constant filter5_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(310,filter_coeff_width);
	constant filter5_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(451,filter_coeff_width);
	constant filter5_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(556,filter_coeff_width);
	constant filter5_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(595,filter_coeff_width);
	----------filter6coeffcients----------
	constant filter6_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-7,filter_coeff_width);
	constant filter6_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter6_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-23,filter_coeff_width);
	constant filter6_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-28,filter_coeff_width);
	constant filter6_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-11,filter_coeff_width);
	constant filter6_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(48,filter_coeff_width);
	constant filter6_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(158,filter_coeff_width);
	constant filter6_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(308,filter_coeff_width);
	constant filter6_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(464,filter_coeff_width);
	constant filter6_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(582,filter_coeff_width);
	constant filter6_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(627,filter_coeff_width);
	----------filter7coeffcients----------
	constant filter7_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter7_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-11,filter_coeff_width);
	constant filter7_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-24,filter_coeff_width);
	constant filter7_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-35,filter_coeff_width);
	constant filter7_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-26,filter_coeff_width);
	constant filter7_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(29,filter_coeff_width);
	constant filter7_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(142,filter_coeff_width);
	constant filter7_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(303,filter_coeff_width);
	constant filter7_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(477,filter_coeff_width);
	constant filter7_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(611,filter_coeff_width);
	constant filter7_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(662,filter_coeff_width);
	----------filter8coeffcients----------
	constant filter8_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-1,filter_coeff_width);
	constant filter8_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter8_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-23,filter_coeff_width);
	constant filter8_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-40,filter_coeff_width);
	constant filter8_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-40,filter_coeff_width);
	constant filter8_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter8_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(122,filter_coeff_width);
	constant filter8_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(295,filter_coeff_width);
	constant filter8_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(489,filter_coeff_width);
	constant filter8_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(642,filter_coeff_width);
	constant filter8_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(700,filter_coeff_width);
	----------filter9coeffcients----------
	constant filter9_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(2,filter_coeff_width);
	constant filter9_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter9_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-21,filter_coeff_width);
	constant filter9_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-43,filter_coeff_width);
	constant filter9_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-53,filter_coeff_width);
	constant filter9_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-15,filter_coeff_width);
	constant filter9_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(98,filter_coeff_width);
	constant filter9_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(284,filter_coeff_width);
	constant filter9_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(500,filter_coeff_width);
	constant filter9_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(674,filter_coeff_width);
	constant filter9_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(741,filter_coeff_width);
	----------filter10coeffcients----------
	constant filter10_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(5,filter_coeff_width);
	constant filter10_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-1,filter_coeff_width);
	constant filter10_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-16,filter_coeff_width);
	constant filter10_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-43,filter_coeff_width);
	constant filter10_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-64,filter_coeff_width);
	constant filter10_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-38,filter_coeff_width);
	constant filter10_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(71,filter_coeff_width);
	constant filter10_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(269,filter_coeff_width);
	constant filter10_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(509,filter_coeff_width);
	constant filter10_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(707,filter_coeff_width);
	constant filter10_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(785,filter_coeff_width);
	----------filter11coeffcients----------
	constant filter11_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter11_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(4,filter_coeff_width);
	constant filter11_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-10,filter_coeff_width);
	constant filter11_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-40,filter_coeff_width);
	constant filter11_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-72,filter_coeff_width);
	constant filter11_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-61,filter_coeff_width);
	constant filter11_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(41,filter_coeff_width);
	constant filter11_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(249,filter_coeff_width);
	constant filter11_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(515,filter_coeff_width);
	constant filter11_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(742,filter_coeff_width);
	constant filter11_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(832,filter_coeff_width);
	----------filter12coeffcients----------
	constant filter12_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(9,filter_coeff_width);
	constant filter12_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter12_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter12_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-33,filter_coeff_width);
	constant filter12_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-75,filter_coeff_width);
	constant filter12_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-83,filter_coeff_width);
	constant filter12_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(7,filter_coeff_width);
	constant filter12_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(223,filter_coeff_width);
	constant filter12_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(518,filter_coeff_width);
	constant filter12_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(778,filter_coeff_width);
	constant filter12_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(882,filter_coeff_width);
	----------filter13coeffcients----------
	constant filter13_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter13_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(12,filter_coeff_width);
	constant filter13_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(7,filter_coeff_width);
	constant filter13_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-22,filter_coeff_width);
	constant filter13_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-74,filter_coeff_width);
	constant filter13_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-101,filter_coeff_width);
	constant filter13_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-28,filter_coeff_width);
	constant filter13_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(192,filter_coeff_width);
	constant filter13_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(517,filter_coeff_width);
	constant filter13_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(814,filter_coeff_width);
	constant filter13_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(934,filter_coeff_width);
	----------filter14coeffcients----------
	constant filter14_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(6,filter_coeff_width);
	constant filter14_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(13,filter_coeff_width);
	constant filter14_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(15,filter_coeff_width);
	constant filter14_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-8,filter_coeff_width);
	constant filter14_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-66,filter_coeff_width);
	constant filter14_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-115,filter_coeff_width);
	constant filter14_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-65,filter_coeff_width);
	constant filter14_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(155,filter_coeff_width);
	constant filter14_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(511,filter_coeff_width);
	constant filter14_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(850,filter_coeff_width);
	constant filter14_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(991,filter_coeff_width);
	----------filter15coeffcients----------
	constant filter15_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(2,filter_coeff_width);
	constant filter15_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(12,filter_coeff_width);
	constant filter15_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(21,filter_coeff_width);
	constant filter15_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter15_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-51,filter_coeff_width);
	constant filter15_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-122,filter_coeff_width);
	constant filter15_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-101,filter_coeff_width);
	constant filter15_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(113,filter_coeff_width);
	constant filter15_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(500,filter_coeff_width);
	constant filter15_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(887,filter_coeff_width);
	constant filter15_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1050,filter_coeff_width);
	----------filter16coeffcients----------
	constant filter16_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-3,filter_coeff_width);
	constant filter16_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter16_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(24,filter_coeff_width);
	constant filter16_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(23,filter_coeff_width);
	constant filter16_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-31,filter_coeff_width);
	constant filter16_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-121,filter_coeff_width);
	constant filter16_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-135,filter_coeff_width);
	constant filter16_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(64,filter_coeff_width);
	constant filter16_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(482,filter_coeff_width);
	constant filter16_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(924,filter_coeff_width);
	constant filter16_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1115,filter_coeff_width);
	----------filter17coeffcients----------
	constant filter17_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-7,filter_coeff_width);
	constant filter17_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(1,filter_coeff_width);
	constant filter17_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(22,filter_coeff_width);
	constant filter17_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(36,filter_coeff_width);
	constant filter17_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(-5,filter_coeff_width);
	constant filter17_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-110,filter_coeff_width);
	constant filter17_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-164,filter_coeff_width);
	constant filter17_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(11,filter_coeff_width);
	constant filter17_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(457,filter_coeff_width);
	constant filter17_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(960,filter_coeff_width);
	constant filter17_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1183,filter_coeff_width);
	----------filter18coeffcients----------
	constant filter18_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-9,filter_coeff_width);
	constant filter18_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-6,filter_coeff_width);
	constant filter18_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(14,filter_coeff_width);
	constant filter18_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(43,filter_coeff_width);
	constant filter18_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(22,filter_coeff_width);
	constant filter18_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-88,filter_coeff_width);
	constant filter18_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-185,filter_coeff_width);
	constant filter18_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-46,filter_coeff_width);
	constant filter18_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(424,filter_coeff_width);
	constant filter18_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(995,filter_coeff_width);
	constant filter18_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1255,filter_coeff_width);
	----------filter19coeffcients----------
	constant filter19_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-7,filter_coeff_width);
	constant filter19_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-11,filter_coeff_width);
	constant filter19_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(3,filter_coeff_width);
	constant filter19_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(42,filter_coeff_width);
	constant filter19_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(48,filter_coeff_width);
	constant filter19_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-56,filter_coeff_width);
	constant filter19_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-195,filter_coeff_width);
	constant filter19_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-105,filter_coeff_width);
	constant filter19_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(381,filter_coeff_width);
	constant filter19_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1027,filter_coeff_width);
	constant filter19_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1330,filter_coeff_width);
	----------filter20coeffcients----------
	constant filter20_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter20_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-13,filter_coeff_width);
	constant filter20_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-10,filter_coeff_width);
	constant filter20_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(32,filter_coeff_width);
	constant filter20_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(68,filter_coeff_width);
	constant filter20_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(-15,filter_coeff_width);
	constant filter20_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-191,filter_coeff_width);
	constant filter20_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-162,filter_coeff_width);
	constant filter20_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(327,filter_coeff_width);
	constant filter20_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1054,filter_coeff_width);
	constant filter20_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1409,filter_coeff_width);
	----------filter21coeffcients----------
	constant filter21_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(4,filter_coeff_width);
	constant filter21_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-10,filter_coeff_width);
	constant filter21_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-20,filter_coeff_width);
	constant filter21_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(13,filter_coeff_width);
	constant filter21_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(76,filter_coeff_width);
	constant filter21_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(29,filter_coeff_width);
	constant filter21_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-170,filter_coeff_width);
	constant filter21_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-215,filter_coeff_width);
	constant filter21_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(264,filter_coeff_width);
	constant filter21_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1077,filter_coeff_width);
	constant filter21_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1489,filter_coeff_width);
	----------filter22coeffcients----------
	constant filter22_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(9,filter_coeff_width);
	constant filter22_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(-2,filter_coeff_width);
	constant filter22_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-24,filter_coeff_width);
	constant filter22_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-11,filter_coeff_width);
	constant filter22_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(68,filter_coeff_width);
	constant filter22_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(72,filter_coeff_width);
	constant filter22_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-133,filter_coeff_width);
	constant filter22_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-260,filter_coeff_width);
	constant filter22_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(191,filter_coeff_width);
	constant filter22_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1093,filter_coeff_width);
	constant filter22_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1574,filter_coeff_width);
	----------filter23coeffcients----------
	constant filter23_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(8,filter_coeff_width);
	constant filter23_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(7,filter_coeff_width);
	constant filter23_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-18,filter_coeff_width);
	constant filter23_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-32,filter_coeff_width);
	constant filter23_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(45,filter_coeff_width);
	constant filter23_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(106,filter_coeff_width);
	constant filter23_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-80,filter_coeff_width);
	constant filter23_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-292,filter_coeff_width);
	constant filter23_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(109,filter_coeff_width);
	constant filter23_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1105,filter_coeff_width);
	constant filter23_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1666,filter_coeff_width);
	----------filter24coeffcients----------
	constant filter24_coeff1 : signed(filter_coeff_width - 1 downto 0) := to_signed(2,filter_coeff_width);
	constant filter24_coeff2 : signed(filter_coeff_width - 1 downto 0) := to_signed(13,filter_coeff_width);
	constant filter24_coeff3 : signed(filter_coeff_width - 1 downto 0) := to_signed(-4,filter_coeff_width);
	constant filter24_coeff4 : signed(filter_coeff_width - 1 downto 0) := to_signed(-43,filter_coeff_width);
	constant filter24_coeff5 : signed(filter_coeff_width - 1 downto 0) := to_signed(9,filter_coeff_width);
	constant filter24_coeff6 : signed(filter_coeff_width - 1 downto 0) := to_signed(122,filter_coeff_width);
	constant filter24_coeff7 : signed(filter_coeff_width - 1 downto 0) := to_signed(-15,filter_coeff_width);
	constant filter24_coeff8 : signed(filter_coeff_width - 1 downto 0) := to_signed(-307,filter_coeff_width);
	constant filter24_coeff9 : signed(filter_coeff_width - 1 downto 0) := to_signed(20,filter_coeff_width);
	constant filter24_coeff10 : signed(filter_coeff_width - 1 downto 0) := to_signed(1112,filter_coeff_width);
	constant filter24_coeff11 : signed(filter_coeff_width - 1 downto 0) := to_signed(1766,filter_coeff_width);
	
	--中间积求和子程序
	procedure sum_of_product(signal product : in product_type;
									 signal sum : out signed(filter_output_width - 1 downto 0));
	--滤波器参数选择子程序. 根据输入的整数, 设置相应的参数
	procedure filnum2paras(signal num : in integer range 0 to 24;
								  signal coeff : out filter_coeff_type);
end package filter_paras;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package body filter_paras is
	--中间积求和子程序
	procedure sum_of_product(signal product : in product_type;
									 signal sum : out signed(filter_output_width - 1 downto 0)) is
	variable x : signed(filter_output_width - 1 downto 0) := (others => '0');
	begin
		for i in 0 to order_of_filter loop
			x := x + product(i);
		end loop;
		sum <= x;
	end procedure;
	--滤波器参数选择子程序
	procedure filnum2paras(signal num : in integer range 0 to 24;
								  signal coeff : out filter_coeff_type) is
	begin
		case num is
		when 1 => 
			coeff(0) <= filter1_coeff1;
			coeff(1) <= filter1_coeff2;
			coeff(2) <= filter1_coeff3;
			coeff(3) <= filter1_coeff4;
			coeff(4) <= filter1_coeff5;
			coeff(5) <= filter1_coeff6;
			coeff(6) <= filter1_coeff7;
			coeff(7) <= filter1_coeff8;
			coeff(8) <= filter1_coeff9;
			coeff(9) <= filter1_coeff10;
			coeff(10) <= filter1_coeff11;
		when 2 => 
			coeff(0) <= filter2_coeff1;
			coeff(1) <= filter2_coeff2;
			coeff(2) <= filter2_coeff3;
			coeff(3) <= filter2_coeff4;
			coeff(4) <= filter2_coeff5;
			coeff(5) <= filter2_coeff6;
			coeff(6) <= filter2_coeff7;
			coeff(7) <= filter2_coeff8;
			coeff(8) <= filter2_coeff9;
			coeff(9) <= filter2_coeff10;
			coeff(10) <= filter2_coeff11;
		when 3 => 
			coeff(0) <= filter3_coeff1;
			coeff(1) <= filter3_coeff2;
			coeff(2) <= filter3_coeff3;
			coeff(3) <= filter3_coeff4;
			coeff(4) <= filter3_coeff5;
			coeff(5) <= filter3_coeff6;
			coeff(6) <= filter3_coeff7;
			coeff(7) <= filter3_coeff8;
			coeff(8) <= filter3_coeff9;
			coeff(9) <= filter3_coeff10;
			coeff(10) <= filter3_coeff11;
		when 4 => 
			coeff(0) <= filter4_coeff1;
			coeff(1) <= filter4_coeff2;
			coeff(2) <= filter4_coeff3;
			coeff(3) <= filter4_coeff4;
			coeff(4) <= filter4_coeff5;
			coeff(5) <= filter4_coeff6;
			coeff(6) <= filter4_coeff7;
			coeff(7) <= filter4_coeff8;
			coeff(8) <= filter4_coeff9;
			coeff(9) <= filter4_coeff10;
			coeff(10) <= filter4_coeff11;
		when 5 => 
			coeff(0) <= filter5_coeff1;
			coeff(1) <= filter5_coeff2;
			coeff(2) <= filter5_coeff3;
			coeff(3) <= filter5_coeff4;
			coeff(4) <= filter5_coeff5;
			coeff(5) <= filter5_coeff6;
			coeff(6) <= filter5_coeff7;
			coeff(7) <= filter5_coeff8;
			coeff(8) <= filter5_coeff9;
			coeff(9) <= filter5_coeff10;
			coeff(10) <= filter5_coeff11;
		when 6 => 
			coeff(0) <= filter6_coeff1;
			coeff(1) <= filter6_coeff2;
			coeff(2) <= filter6_coeff3;
			coeff(3) <= filter6_coeff4;
			coeff(4) <= filter6_coeff5;
			coeff(5) <= filter6_coeff6;
			coeff(6) <= filter6_coeff7;
			coeff(7) <= filter6_coeff8;
			coeff(8) <= filter6_coeff9;
			coeff(9) <= filter6_coeff10;
			coeff(10) <= filter6_coeff11;
		when 7 => 
			coeff(0) <= filter7_coeff1;
			coeff(1) <= filter7_coeff2;
			coeff(2) <= filter7_coeff3;
			coeff(3) <= filter7_coeff4;
			coeff(4) <= filter7_coeff5;
			coeff(5) <= filter7_coeff6;
			coeff(6) <= filter7_coeff7;
			coeff(7) <= filter7_coeff8;
			coeff(8) <= filter7_coeff9;
			coeff(9) <= filter7_coeff10;
			coeff(10) <= filter7_coeff11;
		when 8 => 
			coeff(0) <= filter8_coeff1;
			coeff(1) <= filter8_coeff2;
			coeff(2) <= filter8_coeff3;
			coeff(3) <= filter8_coeff4;
			coeff(4) <= filter8_coeff5;
			coeff(5) <= filter8_coeff6;
			coeff(6) <= filter8_coeff7;
			coeff(7) <= filter8_coeff8;
			coeff(8) <= filter8_coeff9;
			coeff(9) <= filter8_coeff10;
			coeff(10) <= filter8_coeff11;
		when 9 => 
			coeff(0) <= filter9_coeff1;
			coeff(1) <= filter9_coeff2;
			coeff(2) <= filter9_coeff3;
			coeff(3) <= filter9_coeff4;
			coeff(4) <= filter9_coeff5;
			coeff(5) <= filter9_coeff6;
			coeff(6) <= filter9_coeff7;
			coeff(7) <= filter9_coeff8;
			coeff(8) <= filter9_coeff9;
			coeff(9) <= filter9_coeff10;
			coeff(10) <= filter9_coeff11;
		when 10 => 
			coeff(0) <= filter10_coeff1;
			coeff(1) <= filter10_coeff2;
			coeff(2) <= filter10_coeff3;
			coeff(3) <= filter10_coeff4;
			coeff(4) <= filter10_coeff5;
			coeff(5) <= filter10_coeff6;
			coeff(6) <= filter10_coeff7;
			coeff(7) <= filter10_coeff8;
			coeff(8) <= filter10_coeff9;
			coeff(9) <= filter10_coeff10;
			coeff(10) <= filter10_coeff11;
		when 11 => 
			coeff(0) <= filter11_coeff1;
			coeff(1) <= filter11_coeff2;
			coeff(2) <= filter11_coeff3;
			coeff(3) <= filter11_coeff4;
			coeff(4) <= filter11_coeff5;
			coeff(5) <= filter11_coeff6;
			coeff(6) <= filter11_coeff7;
			coeff(7) <= filter11_coeff8;
			coeff(8) <= filter11_coeff9;
			coeff(9) <= filter11_coeff10;
			coeff(10) <= filter11_coeff11;
		when 12 => 
			coeff(0) <= filter12_coeff1;
			coeff(1) <= filter12_coeff2;
			coeff(2) <= filter12_coeff3;
			coeff(3) <= filter12_coeff4;
			coeff(4) <= filter12_coeff5;
			coeff(5) <= filter12_coeff6;
			coeff(6) <= filter12_coeff7;
			coeff(7) <= filter12_coeff8;
			coeff(8) <= filter12_coeff9;
			coeff(9) <= filter12_coeff10;
			coeff(10) <= filter12_coeff11;
		when 13 => 
			coeff(0) <= filter13_coeff1;
			coeff(1) <= filter13_coeff2;
			coeff(2) <= filter13_coeff3;
			coeff(3) <= filter13_coeff4;
			coeff(4) <= filter13_coeff5;
			coeff(5) <= filter13_coeff6;
			coeff(6) <= filter13_coeff7;
			coeff(7) <= filter13_coeff8;
			coeff(8) <= filter13_coeff9;
			coeff(9) <= filter13_coeff10;
			coeff(10) <= filter13_coeff11;
		when 14 => 
			coeff(0) <= filter14_coeff1;
			coeff(1) <= filter14_coeff2;
			coeff(2) <= filter14_coeff3;
			coeff(3) <= filter14_coeff4;
			coeff(4) <= filter14_coeff5;
			coeff(5) <= filter14_coeff6;
			coeff(6) <= filter14_coeff7;
			coeff(7) <= filter14_coeff8;
			coeff(8) <= filter14_coeff9;
			coeff(9) <= filter14_coeff10;
			coeff(10) <= filter14_coeff11;
		when 15 => 
			coeff(0) <= filter15_coeff1;
			coeff(1) <= filter15_coeff2;
			coeff(2) <= filter15_coeff3;
			coeff(3) <= filter15_coeff4;
			coeff(4) <= filter15_coeff5;
			coeff(5) <= filter15_coeff6;
			coeff(6) <= filter15_coeff7;
			coeff(7) <= filter15_coeff8;
			coeff(8) <= filter15_coeff9;
			coeff(9) <= filter15_coeff10;
			coeff(10) <= filter15_coeff11;
		when 16 => 
			coeff(0) <= filter16_coeff1;
			coeff(1) <= filter16_coeff2;
			coeff(2) <= filter16_coeff3;
			coeff(3) <= filter16_coeff4;
			coeff(4) <= filter16_coeff5;
			coeff(5) <= filter16_coeff6;
			coeff(6) <= filter16_coeff7;
			coeff(7) <= filter16_coeff8;
			coeff(8) <= filter16_coeff9;
			coeff(9) <= filter16_coeff10;
			coeff(10) <= filter16_coeff11;
		when 17 => 
			coeff(0) <= filter17_coeff1;
			coeff(1) <= filter17_coeff2;
			coeff(2) <= filter17_coeff3;
			coeff(3) <= filter17_coeff4;
			coeff(4) <= filter17_coeff5;
			coeff(5) <= filter17_coeff6;
			coeff(6) <= filter17_coeff7;
			coeff(7) <= filter17_coeff8;
			coeff(8) <= filter17_coeff9;
			coeff(9) <= filter17_coeff10;
			coeff(10) <= filter17_coeff11;
		when 18 => 
			coeff(0) <= filter18_coeff1;
			coeff(1) <= filter18_coeff2;
			coeff(2) <= filter18_coeff3;
			coeff(3) <= filter18_coeff4;
			coeff(4) <= filter18_coeff5;
			coeff(5) <= filter18_coeff6;
			coeff(6) <= filter18_coeff7;
			coeff(7) <= filter18_coeff8;
			coeff(8) <= filter18_coeff9;
			coeff(9) <= filter18_coeff10;
			coeff(10) <= filter18_coeff11;
		when 19 => 
			coeff(0) <= filter19_coeff1;
			coeff(1) <= filter19_coeff2;
			coeff(2) <= filter19_coeff3;
			coeff(3) <= filter19_coeff4;
			coeff(4) <= filter19_coeff5;
			coeff(5) <= filter19_coeff6;
			coeff(6) <= filter19_coeff7;
			coeff(7) <= filter19_coeff8;
			coeff(8) <= filter19_coeff9;
			coeff(9) <= filter19_coeff10;
			coeff(10) <= filter19_coeff11;
		when 20 => 
			coeff(0) <= filter20_coeff1;
			coeff(1) <= filter20_coeff2;
			coeff(2) <= filter20_coeff3;
			coeff(3) <= filter20_coeff4;
			coeff(4) <= filter20_coeff5;
			coeff(5) <= filter20_coeff6;
			coeff(6) <= filter20_coeff7;
			coeff(7) <= filter20_coeff8;
			coeff(8) <= filter20_coeff9;
			coeff(9) <= filter20_coeff10;
			coeff(10) <= filter20_coeff11;
		when 21 => 
			coeff(0) <= filter21_coeff1;
			coeff(1) <= filter21_coeff2;
			coeff(2) <= filter21_coeff3;
			coeff(3) <= filter21_coeff4;
			coeff(4) <= filter21_coeff5;
			coeff(5) <= filter21_coeff6;
			coeff(6) <= filter21_coeff7;
			coeff(7) <= filter21_coeff8;
			coeff(8) <= filter21_coeff9;
			coeff(9) <= filter21_coeff10;
			coeff(10) <= filter21_coeff11;
		when 22 => 
			coeff(0) <= filter22_coeff1;
			coeff(1) <= filter22_coeff2;
			coeff(2) <= filter22_coeff3;
			coeff(3) <= filter22_coeff4;
			coeff(4) <= filter22_coeff5;
			coeff(5) <= filter22_coeff6;
			coeff(6) <= filter22_coeff7;
			coeff(7) <= filter22_coeff8;
			coeff(8) <= filter22_coeff9;
			coeff(9) <= filter22_coeff10;
			coeff(10) <= filter22_coeff11;
		when 23 => 
			coeff(0) <= filter23_coeff1;
			coeff(1) <= filter23_coeff2;
			coeff(2) <= filter23_coeff3;
			coeff(3) <= filter23_coeff4;
			coeff(4) <= filter23_coeff5;
			coeff(5) <= filter23_coeff6;
			coeff(6) <= filter23_coeff7;
			coeff(7) <= filter23_coeff8;
			coeff(8) <= filter23_coeff9;
			coeff(9) <= filter23_coeff10;
			coeff(10) <= filter23_coeff11;
		when 24 => 
			coeff(0) <= filter24_coeff1;
			coeff(1) <= filter24_coeff2;
			coeff(2) <= filter24_coeff3;
			coeff(3) <= filter24_coeff4;
			coeff(4) <= filter24_coeff5;
			coeff(5) <= filter24_coeff6;
			coeff(6) <= filter24_coeff7;
			coeff(7) <= filter24_coeff8;
			coeff(8) <= filter24_coeff9;
			coeff(9) <= filter24_coeff10;
			coeff(10) <= filter24_coeff11;
		when others =>
			coeff(0) <= (others => '0');
			coeff(1) <= (others => '0');
			coeff(2) <= (others => '0');
			coeff(3) <= (others => '0');
			coeff(4) <= (others => '0');
			coeff(5) <= (others => '0');
			coeff(6) <= (others => '0');
			coeff(7) <= (others => '0');
			coeff(8) <= (others => '0');
			coeff(9) <= (others => '0');
			coeff(10) <= (others => '0');
		end case;
	end procedure;

end filter_paras;

