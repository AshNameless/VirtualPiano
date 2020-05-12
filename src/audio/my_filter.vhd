-------------------------------------------------------------------------
-------------------------------------------------------------------------
--my_filter
--
-- 功能: 10阶低通滤波器, 接受audio_clter给出的滤波器标号, 自动调节参数并完成滤波功能
--
-- 描述: 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.filter_paras.all;
-------------------------------------------------------
-------------------------------------------------------
entity my_filter is
generic(
	filter_num_width : integer := filter_number_width;
	input_wave_width : integer := NCO_wave_width;
	--滤波器相关参数
	output_data_width : integer := filter_output_width;
	coeff_width : integer := filter_coeff_width;
	filter_order : integer := order_of_filter;
	count_threshold : integer := filter_count_threshold
);
port(
	rst_n : in std_logic;
	clk_50m : in std_logic;
	
	--输入
	nco_wave_in : in std_logic_vector(input_wave_width - 1 downto 0);--nco输入的波形
	filter_num_in : in std_logic_vector(filter_num_width - 1 downto 0);
	
	--输出
	filtered_wave : out std_logic_vector(output_data_width - 1 downto 0)
);
end entity my_filter;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of my_filter is
	--中间积的宽度
	constant product_width : integer := coeff_width + input_wave_width;
	--滤波器标号
	signal filter_num_unsigned : unsigned(filter_num_width - 1 downto 0) := (others => '0');
	signal filter_num : integer range 0 to 24 := 0;
	--乘法系数
	signal coeff1 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	signal coeff2 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	signal coeff3 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	signal coeff4 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	signal coeff5 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	signal coeff6 : signed(coeff_width - 1 downto 0 ) := (others => '0');
	
	--11个乘法积
	signal product1 : signed(product_width - 1 downto 0) := (others => '0');
	signal product2 : signed(product_width - 1 downto 0) := (others => '0');
	signal product3 : signed(product_width - 1 downto 0) := (others => '0');
	signal product4 : signed(product_width - 1 downto 0) := (others => '0');
	signal product5 : signed(product_width - 1 downto 0) := (others => '0');
	signal product6 : signed(product_width - 1 downto 0) := (others => '0');
	signal product7 : signed(product_width - 1 downto 0) := (others => '0');
	signal product8 : signed(product_width - 1 downto 0) := (others => '0');
	signal product9 : signed(product_width - 1 downto 0) := (others => '0');
	signal product10 : signed(product_width - 1 downto 0) := (others => '0');
	signal product11 : signed(product_width - 1 downto 0) := (others => '0');
	
	--第一层和
	signal sum1_1 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum1_2 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum1_3 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum1_4 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum1_5 : signed(output_data_width - 1 downto 0) := (others => '0');
	--第二层和
	signal sum2_1 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum2_2 : signed(output_data_width - 1 downto 0) := (others => '0');
	signal sum2_3 : signed(output_data_width - 1 downto 0) := (others => '0');
	
	--定义输入数据流水线
	type pipeline_type is array(natural range<>) of signed(input_wave_width - 1 downto 0);
	signal pipeline_in : pipeline_type(0 to filter_order) := (others => (others => '0'));
	
	--乘法积type
	type product_type is array(natural range<>) of signed(product_width - 1 downto 0);
	signal product : product_type(0 to filter_order) := (others => (others => '0'));
	
	--采样时钟
	signal clk_sample : std_logic := '0';
	signal sampleclk_count : integer range 0 to count_threshold := 0;
	
begin
	filter_num_unsigned <= unsigned(filter_num_in);
	--输出
	filtered_wave <= std_logic_vector(sum2_1 + sum2_2 + sum2_3);
	
	--采样时钟生成
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			clk_sample <= '0';
		elsif(clk_50m'event and clk_50m = '1') then
			if(sampleclk_count >= count_threshold) then
				sampleclk_count <= 0;
				clk_sample <= not clk_sample;
			else
				sampleclk_count <= sampleclk_count + 1;
				clk_sample <= clk_sample;
			end if;
		end if;
	end process;
	
	--获取滤波器标号
	process(rst_n, clk_sample)
	begin
		if(rst_n = '0') then
			filter_num <= 0;
		elsif(clk_sample'event and clk_sample = '0') then
			if(filter_num_unsigned = 0) then
				filter_num <= filter_num;
			else
				filter_num <= to_integer(filter_num_unsigned);
			end if;
		end if;
	end process;
	
	--乘法器系数跟随滤波器标号改变
	process(rst_n, filter_num)
	begin
		if(rst_n = '0') then
			coeff1 <= (others => '0');
			coeff2 <= (others => '0');
			coeff3 <= (others => '0');
			coeff4 <= (others => '0');
			coeff5 <= (others => '0');
			coeff6 <= (others => '0');
		else
			filnum2paras(filter_num, coeff1, coeff2, coeff3, coeff4, coeff5, coeff6);
		end if;
	end process;
	
	--输入流水线
	process(rst_n, clk_sample)
	begin
		if(rst_n = '0') then
			pipeline_in <= (others => (others => '0'));
		elsif(clk_sample'event and clk_sample = '1') then
			--移位操作
			pipeline_in(0) <= signed(nco_wave_in);
			pipeline_in(1 to filter_order) <= pipeline_in(0 to filter_order - 1);
		end if;
	end process;
	
	--乘积
	product1 <= pipeline_in(0) * coeff1;
	product2 <= pipeline_in(1) * coeff2;
	product3 <= pipeline_in(2) * coeff3;
	product4 <= pipeline_in(3) * coeff4;
	product5 <= pipeline_in(4) * coeff5;
	product6 <= pipeline_in(5) * coeff6;
	product7 <= pipeline_in(6) * coeff5;
	product8 <= pipeline_in(7) * coeff4;
	product9 <= pipeline_in(8) * coeff3;
	product10 <= pipeline_in(9) * coeff2;
	product11 <= pipeline_in(10) * coeff1;
	
	--求和
	sum1_1 <= product1 + product2;
	sum1_2 <= product3 + product4;
	sum1_3 <= product5 + product6;
	sum1_4 <= product7 + product8;
	sum1_5 <= product9 + product10;
	sum2_1 <= sum1_1 + sum1_2;
	sum2_2 <= sum1_3 + sum1_4;
	sum2_3 <= sum1_5 + product11;
	


end architecture bhv;


