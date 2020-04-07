---------------------------------------------------------------------
---------------------------------------------------------------------
--Left_justified
--
-- 功能: 完成音频数据到wm8731的输出,为芯片产生工作时钟MCLK,比特流时钟BCLK
--       DAC输入DACDAT以及左右声道转换信号DACLRCK.
--
-- 原理: 输入50mhz分频得到BCLK,MCLK. 对BCLK再计数分频得到DACLRCK,同时依照
--       wm8731 left justified传输方式, 从DACLRCK的分频计数器直接得到传输
--       数据的位数, 将其赋值给DACDAT即可
---------------------------------------------------------------------
---------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity Left_justified is 
port(
	--输入
	rst_n : in std_logic;
	clk_50m : in std_logic;
	note_data : in std_logic_vector(note_out_width - 1 downto 0);
	
	--与wm8731的接口
	AUD_MCLK : out std_logic;                    --芯片工作时钟
	AUD_BCLK : out std_logic;                    --比特流时钟
	AUD_DACDAT : out std_logic;                  --串行数据线
	AUD_DACLRCK : out std_logic                  --左右声道信号
);
end entity Left_justified;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of Left_justified is
	--内部信号定义
	signal mclk : std_logic := '0';
	signal bclk : std_logic := '0';
	signal lrclk : std_logic := '0';
	signal data : std_logic_vector(note_out_width + 2 downto 0) := (others => '0');
	
	--输入50mhz,MCLK期望为12.288mhz,计数2翻转一次(半个周期),实际得到的MCLK为12.5mhz
	constant mclk_threshold : integer := 1;
	signal mclk_count : integer range 0 to mclk_threshold := 0;
	
	--采用left justified方式,数据24位,一个声道需要27个BCLK,一个采样周期就要54个BCLK.
	--采样率设置为96khz,则BCLK频率应为54*96khz=5.184mhz. 计数5翻转一次, 实际得到BCLK为5mhz
	constant bclk_threshold : integer := 4;
	signal bclk_count : integer range 0 to bclk_threshold := 0;
	
	--LRCLK计数27个BCLK时钟翻转一次
	constant lrclk_threshold : integer := 26;
	signal lrclk_count : integer range 0 to lrclk_threshold := 26;
	
begin
	--输出赋值
	AUD_MCLK <= mclk;
	AUD_BCLK <= bclk;
	AUD_DACLRCK <= lrclk;
	--lrclk计数器从26减至0,data(26 downto 3)为24位数据,余下3位为0. 将data的第lrclk_count位作为串行输出
	AUD_DACDAT <= data(lrclk_count);
	
	--产生MCLK时钟
	mclk_pro : process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			mclk <= '0';
			mclk_count <= 0;
		elsif(clk_50m'event and clk_50m = '1') then
			if(mclk_count = 1) then
				mclk_count <= 0;
				mclk <= not mclk;
			else
				mclk_count <= mclk_count + 1;
			end if;
		end if;
	end process;
	
	--产生BCLK时钟
	bclk_pro : process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			bclk <= '0';
			bclk_count <= 0;
		elsif(clk_50m'event and clk_50m = '1') then
			if(bclk_count = 4) then
				bclk_count <= 0;
				bclk <= not bclk;
			else
				bclk_count <= bclk_count + 1;
			end if;
		end if;
	end process;
	
	--产生LRCLK信号
	lrclk_pro : process(rst_n, bclk)
	begin
		if(rst_n = '0') then
			lrclk <= '0';
			lrclk_count <= lrclk_threshold;
		--bclk下降沿
		elsif(bclk'event and bclk = '0') then
			if(lrclk_count = 0) then
				lrclk_count <= lrclk_threshold;
				lrclk <= not lrclk;
				data <= note_data & "000";
			else
				lrclk_count <= lrclk_count - 1;
			end if;
		end if;
	end process;

end architecture bhv;


