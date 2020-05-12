-------------------------------------------------------------------------
-------------------------------------------------------------------------
--my_filter
--
-- 功能: filter_order(偶数)阶低通滤波器, 接受audio_clter给出的滤波器标号, 自动调节参数并完成滤波功能
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
	--系数个数
	constant coeff_num : integer := filter_order/2;
	
	--滤波器标号
	signal filter_num_unsigned : unsigned(filter_num_width - 1 downto 0) := (others => '0');
	signal filter_num : integer range 0 to 24 := 0;
	
	--乘法系数. filter_coeff_type类型在filter_paras中定义
	signal coeff : filter_coeff_type(0 to coeff_num) := (others => (others => '0'));
	--乘积
	signal product : product_type(0 to filter_order) := (others => (others => '0'));
	
	--定义输入数据流水线
	type pipeline_type is array(natural range<>) of signed(input_wave_width - 1 downto 0);
	signal pipeline_in : pipeline_type(0 to filter_order) := (others => (others => '0'));
	
	--和
	signal sum : signed(output_data_width - 1 downto 0) := (others => '0');
	
	--采样时钟
	signal clk_sample : std_logic := '0';
	signal sampleclk_count : integer range 0 to count_threshold := 0;
	
begin
	filter_num_unsigned <= unsigned(filter_num_in);
	--输出
	filtered_wave <= std_logic_vector(sum);
	
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
	
	--乘法系数跟随滤波器标号改变
	process(rst_n, filter_num)
	begin
		if(rst_n = '0') then
			coeff <= (others => (others => '0'));
		else
			filnum2paras(filter_num, coeff);
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
	
	--乘法操作
	process(rst_n, coeff, pipeline_in)
	begin
		if(rst_n = '0') then
			product <= (others => (others => '0'));
		else
			for i in 0 to filter_order loop
				if(i <= coeff_num) then
					product(i) <= coeff(i)*pipeline_in(i);
				else
					product(i) <= coeff(filter_order-i)*pipeline_in(i);
				end if;
			end loop;
		end if;
	end process;
	
	--求和
	process(rst_n, product)
	begin
		if(rst_n = '0') then
			sum <= (others => '0');
		else
			sum_of_product(product, sum);
		end if;
	end process;
	
end architecture bhv;


