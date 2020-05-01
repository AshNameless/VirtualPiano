-------------------------------------------------------------------------
-------------------------------------------------------------------------
--Audio_Controller
--
-- 功能: 接收从识别模块输出的24位音符信息, 根据此产生各种控制信号
--
-- 描述: 只保留24位信息中最高位的1, 只保留一个音符. 再将转换后的单音符信息
--       作为选择器的输入, 选择对应的NCO相位步长, 并将其输出. 同时产生note_on
--       note_change等信号. 通过对比当前音符和上一音符来判断note_change是否该
--       置位, 由当前音符是否变为0来判断是否松键.
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------
-------------------------------------------------------
entity Audio_Controller is
generic(
	input_data_width : integer := notes_data_width;
	output_data_width : integer := NCO_phase_width
);
port(
	--输入
	rst_n : in std_logic;
	clk_50m : in std_logic;
	notes_data_in : in std_logic_vector(input_data_width - 1 downto 0);   --识别模块输出的音符信息
	--输出
	NCO_phase_step : out std_logic_vector(output_data_width - 1 downto 0);  --调节NCO输出信号频率
	NCO_clk_en : out std_logic;                                           --NCO时钟使能
	note_on : out std_logic;                                              --表示音符是否按下，输出到ADSR
	note_change : out std_logic                                           --表示音符是否有变动，输出到ADSR
);
end entity Audio_Controller;
-------------------------------------------------------
-------------------------------------------------------
architecture bhv of Audio_Controller is
	--定义状态
	type state is (idle, pressed, changed); 
	signal cur_state, next_state : state; 
	--定义当前音符和上一个音符
	signal cur_note, last_note : std_logic_vector(input_data_width - 1 downto 0);
	
begin
	--输入信号转换
	cur_note <= rawnote2note(notes_data_in);
	--复位时上一音符置0，否则在上升沿对输入采样
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			last_note <= (others => '0');
		elsif(clk_50m'event and clk_50m = '1') then
			last_note <= cur_note;
		end if;
	end process;
	
	
	--以下为状态机控制，采用三段式
	--状态控制进程
	process(rst_n, clk_50m)
	begin
		if(rst_n = '0') then
			cur_state <= idle;
		elsif(clk_50m'event and clk_50m = '1') then
			cur_state <= next_state;
		end if;
	end process;
	
	--次态控制进程，具体细节参考状态图
	process(cur_state, cur_note, last_note)
	begin
		next_state <= idle;
		
		case cur_state is
		when idle =>
			if(cur_note = note_0) then
				next_state <= idle;
			else
				next_state <= pressed;
			end if;
		
		when pressed =>
			if(cur_note = note_0) then
				next_state <= idle;
			elsif(cur_note = last_note) then
				next_state <= pressed;
			else
				next_state <= changed;
			end if;
		
		when changed =>
			if(cur_note = note_0) then
				next_state <= idle;
			elsif(cur_note = last_note) then
				next_state <= pressed;
			else
				next_state <= changed;
			end if;
			
		when others =>
			next_state <= idle;
		end case;
	end process;
	
	--输出控制进程
	process(cur_state, cur_note)
	begin
		case cur_state is
		when idle =>
			NCO_phase_step <= (others => '0');
			NCO_clk_en <= '0';
			note_on <= '0';
			note_change <= '0';
		
		--procedure详见subpros
		when pressed =>
			note2phase_step(cur_note, NCO_phase_step);
			NCO_clk_en <= '1';
			note_on <= '1';
			note_change <= '0';
			
		when changed =>
			note2phase_step(cur_note, NCO_phase_step);
			NCO_clk_en <= '1';
			note_on <= '1';
			note_change <= '1';
		
		when others =>
			NCO_phase_step <= (others => '0');
			NCO_clk_en <= '0';
			note_on <= '0';
			note_change <= '0';
		end case;
	end process;

end architecture bhv;



