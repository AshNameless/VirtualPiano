--Audio_Controller，接收从识别模块输出的24位音符信息，根据此产生各种控制信号
--		NCO_phase_step对NCO频率进行调制
--		NCO_clk_en使能NCO输入时钟
--		note_on为ADSR提供音符依然按下的信号
--由状态机控制，状态机共有三个状态


library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity Audio_Controller is
port(
	--输入
	rst_n : in std_logic;
	clk_50m : in std_logic;
	notes_data_in : in std_logic_vector(notes_data_width - 1 downto 0);   --识别模块输出的音符信息
	--输出
	NCO_phase_step : out std_logic_vector(NCO_phase_width - 1 downto 0);  --调节NCO输出信号频率
	NCO_clk_en : out std_logic;                                           --NCO时钟使能
	note_on : out std_logic;                                              --表示音符是否按下，输出到ADSR
	note_change : out std_logic                                           --表示音符是否有变动，输出到ADSR
);
end entity Audio_Controller;

architecture bhv of Audio_Controller is
	type states is (idle, pressed, changed);
	signal cur_state, next_state : states;
	signal cur_note, past_note : std_logic_vector(notes_data_width - 1 downto 0);
begin
	

end architecture bhv;



