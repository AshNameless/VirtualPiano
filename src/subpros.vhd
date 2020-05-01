-------------------------------------------------------------------------
-------------------------------------------------------------------------
--包含子程序的package
-------------------------------------------------------------------------
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package subpros is
	--Audio_Controller
	--将识别模块输出的24位信号进行转化，只保留第一个1，其余位全部置为0
	function rawnote2note(ndata : std_logic_vector(notes_data_width - 1 downto 0)) return std_logic_vector;
	
	--将音符信号转化为对应的NCO phase_step，用以控制NCO输出频率，暂未实现
	procedure note2phase_step(signal ndata : in std_logic_vector(notes_data_width - 1 downto 0);
		                       signal x : out std_logic_vector(NCO_phase_width - 1 downto 0));
	
	--在wm8731初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure codec_regcount2data(signal num : in integer range 0 to wm8731_reg_num; 
								         signal x : out std_logic_vector(wm8731_reg_dwidth - 1 downto 0));
	
	--在ov7670初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure camera_regcount2data(signal num : in integer range 0 to ov7670_reg_num; 
								         signal x : out std_logic_vector(ov7670_reg_dwidth - 1 downto 0));
end package subpros;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package body subpros is
	--Audio_Controller
	--将输入音符信号转换成只其最低音信号。如识别出按下了40、41号键，则转换为只按下了40号键，方便前期系统搭建，后期可能会有所修改
	function rawnote2note(ndata : std_logic_vector(notes_data_width - 1 downto 0))
	return std_logic_vector is
		variable x : std_logic_vector(23 downto 0) := (others => '0');
		begin
			for i in 23 downto 0 loop
				if ndata(i) = '1' then
					x := (i => '1', others => '0');
					exit;
				else
					x(i) := '0';
				end if;
			end loop;
			return x;
	end function rawnote2note;
	
	--从音频信号得到NCO的phase_step用以控制频率
	procedure note2phase_step(signal ndata : in std_logic_vector(notes_data_width - 1 downto 0);
				                 signal x : out std_logic_vector(NCO_phase_width - 1 downto 0)) is
		begin
			case ndata is
			when note_1 => x <= phase_note_1;
			when note_2 => x <= phase_note_2;
			when note_3 => x <= phase_note_3;
			when note_4 => x <= phase_note_4;
			when note_5 => x <= phase_note_5;
			when note_6 => x <= phase_note_6;
			when note_7 => x <= phase_note_7;
			when note_8 => x <= phase_note_8;
			when note_9 => x <= phase_note_9;
			when note_10 => x <= phase_note_10;
			when note_11 => x <= phase_note_11;
			when note_12 => x <= phase_note_12;
			when note_13 => x <= phase_note_13;
			when note_14 => x <= phase_note_14;
			when note_15 => x <= phase_note_15;
			when note_16 => x <= phase_note_16;
			when note_17 => x <= phase_note_17;
			when note_18 => x <= phase_note_18;
			when note_19 => x <= phase_note_19;
			when note_20 => x <= phase_note_20;
			when note_21 => x <= phase_note_21;
			when note_22 => x <= phase_note_22;
			when note_23 => x <= phase_note_23;
			when note_24 => x <= phase_note_24;
			when others => x <= phase_note_0;
			end case;
	end procedure note2phase_step;
	
	--在wm8731初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure codec_regcount2data(signal num : in integer range 0 to wm8731_reg_num; 
								         signal x : out std_logic_vector(wm8731_reg_dwidth - 1 downto 0)) is
	begin
		case num is
		when 0 => x <= wm8731_reset_config;
		when 1 => x <= wm8731_left_headphone_config;
		when 2 => x <= wm8731_right_headphone_config;
		when 3 => x <= wm8731_analogue_path_config;
		when 4 => x <= wm8731_digital_path_config;
		when 5 => x <= wm8731_power_down_config;
		when 6 => x <= wm8731_digital_interface_config;
		when 7 => x <= wm8731_sampling_config;
		when 8 => x <= wm8731_active_config;
		when others => x <= (others => '0');
		end case;
	end procedure codec_regcount2data;

	--在摄像头初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure camera_regcount2data(signal num : in integer range 0 to ov7670_reg_num; 
								         signal x : out std_logic_vector(ov7670_reg_dwidth - 1 downto 0)) is
	begin
		case num is
		when 0 => x <= ov7670_reset_config;
		when 1 => x <= ov7670_reset_config_qvga;
		when 2 =>  x <= ov7670_clkreg_config;
		when 3 =>  x <= ov7670_pll_config;
		when 4 =>  x <= ov7670_pclk_config;
		when 5 =>  x <= ov7670_yuvrange_config;
		when 6 =>  x <= ov7670_tlsb_config;
		when 7 =>  x <= ov7670_3d_config;
		when others => x<= (others => '0');
		end case;
	end procedure camera_regcount2data;
	
end subpros;




