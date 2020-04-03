--ADSR模块接受从NCO输出的正弦波和Audio_Controller输出的note_on\note_change等信号
--		将正弦波经过ADSR调制后输出。
--		调制过程利用numeric_std定义的乘法 * ,将调制参数和输入正弦波都化为signed相乘即可。signed是有符号补码
--		调制参数从计数器利用除法、加法得到，因此其位宽与加法器位宽相同
--		由于其值必定在0-2047之间，因此直接取其低12位与12位正弦相乘，即得24位输出



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity ADSR is
port(
	--输入
	clk_50m : in std_logic;
	rst_n : in std_logic;
	note_on : in std_logic;
	note_change : in std_logic;
	out_valid : in std_logic;     --暂无用处
	NCO_wave_in : in std_logic_vector(NCO_wave_width - 1 downto 0);
	
	--输出
	note : out std_logic_vector(note_out_width - 1 downto 0)
);
end entity ADSR;

architecture bhv of ADSR is
    --attack,decay,release阶段的计数器及其计数使能信号
    signal counter_A : signed(counter_width - 1 downto 0) := (others => '0');
    signal counter_D : signed(counter_width - 1 downto 0) := (others => '0');
    signal counter_R : signed(counter_width - 1 downto 0) := (others => '0');
	 signal counterA_en : std_logic := '0';
	 signal counterD_en : std_logic := '0';
	 signal counterR_en : std_logic := '0';
    --定义状态
	 type state is (idle, attack, decay, sustain, release);
	 signal cur_state : state := idle;
	 signal next_state : state := idle;
	 --定义幅值调制参数
	 signal amplitude_modulation : signed(counter_width -1 downto 0) := (others => '0');
begin
    --ADR三个计数器进程
	counterA_pro : process(clk_50m, rst_n, counterA_en)
	begin
		if(rst_n = '0' or counterA_en = '0') then
			counter_A <= (others => '0');
		elsif(clk_50m'event and clk_50m = '1') then
			if(counter_A = counterA_threshold) then
				counter_A <= (others => '0');
			else
				counter_A <= counter_A + 1;
			end if;
		end if;
	end process;

	counterD_pro : process(clk_50m, rst_n, counterD_en)
	begin
		if(rst_n = '0' or counterD_en = '0') then
			counter_D <= (others => '0');
		elsif(clk_50m'event and clk_50m = '1') then
			if(counter_D = counterD_threshold) then
				counter_D <= (others => '0');
			else
				counter_D <= counter_D + 1;
				end if;
		end if;
	end process;

	counterR_pro : process(clk_50m, rst_n, counterR_en)
	begin
		if(rst_n = '0' or counterR_en = '0') then
			counter_R <= (others => '0');
		elsif(clk_50m'event and clk_50m = '1') then
			if(counter_R = counterR_threshold) then
				counter_R <= (others => '0');
			else
				counter_R <= counter_R + 1;
			end if;
		end if;
	end process;
	
	--以下为状态机控制部分，逻辑详见ADSR状态图。
	--状态控制进程
	process(clk_50m, rst_n)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_50m'event and clk_50m = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程
	process(cur_state, note_on, note_change, counter_A, counter_D, counter_R)
	begin
		next_state <= cur_state;
		
		case cur_state is
		when idle =>
			if(note_on = '1') then
				next_state <= attack;
			else
				next_state <= idle;
			end if;
			
		when attack =>
			if(note_on = '0') then
				next_state <= release;
			elsif(counter_A = counterA_threshold) then
				next_state <= decay;
			else
				next_state <= attack;
			end if;
			
		when decay =>
			if(note_on ='0') then
				next_state <= release;
			elsif(note_change = '1') then
				next_state <= attack;
			elsif(counter_D = counterD_threshold) then
				next_state <= sustain;
			else
				next_state <= decay;
			end if;
				
		when sustain =>
			if(note_on = '0') then
				next_state <= release;
			elsif(note_change = '1') then
				next_state <= attack;
			else
				next_state <= sustain;
			end if;
		
		when release =>
			if(note_on = '1') then
				next_state <= attack;
			elsif(counter_R = counterR_threshold) then
				next_state <= idle;
			else
				next_state <= release;
			end if;
		
		when others =>
			next_state <= idle;
		end case;
	end process;
	
	--输出控制部分。包括了内部计数器enable信号等
	process(cur_state, counter_A, counter_D, counter_R)
	begin
		counterA_en <= '0';
		counterD_en <= '0';
		counterR_en <= '0';
		amplitude_modulation <= (others => '0');
		
		case cur_state is
		when idle =>
			amplitude_modulation <= (others => '0');
		when attack =>
			counterA_en <= '1';
			amplitude_modulation <= counter_A/counterA_divisor;
		
		when decay =>
			counterD_en <= '1';
			amplitude_modulation <= counterD_start - counter_D/counterD_divisor;
		
		when sustain =>
			amplitude_modulation <= sustain_level;
		
		when release =>
			counterR_en <= '1';
			amplitude_modulation <= sustain_level - counter_R/counterR_divisor;
		
		when others => 
			amplitude_modulation <= (others => '0');
		end case;
	end process;
	
	--输出note信号为amplitude_modulation低12位与NCO_wave_in的乘积，单独赋值在外
	note <= std_logic_vector(amplitude_modulation(NCO_wave_width - 1 downto 0) * signed(NCO_wave_in));
	
	
end architecture bhv;

