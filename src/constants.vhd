---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--用来保存各种常数的package
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
package constants is
	-------------------------
	--Audio_Controller
	-------------------------
	constant notes_data_width : integer := 24;    --识别后输出到Audio_Controller的音符数据宽度，24个音符，每个分配一位
	--25种可能的音符（未按下+24个键)，便于调用时比较
	constant note_0 : std_logic_vector(notes_data_width - 1 downto 0) := (others => '0');
	constant note_1 : std_logic_vector(notes_data_width - 1 downto 0) := (23 => '1', others => '0');
	constant note_2 : std_logic_vector(notes_data_width - 1 downto 0) := (22 => '1', others => '0');
	constant note_3 : std_logic_vector(notes_data_width - 1 downto 0) := (21 => '1', others => '0');
	constant note_4 : std_logic_vector(notes_data_width - 1 downto 0) := (20 => '1', others => '0');
	constant note_5 : std_logic_vector(notes_data_width - 1 downto 0) := (19 => '1', others => '0');
	constant note_6 : std_logic_vector(notes_data_width - 1 downto 0) := (18 => '1', others => '0');
	constant note_7 : std_logic_vector(notes_data_width - 1 downto 0) := (17 => '1', others => '0');
	constant note_8 : std_logic_vector(notes_data_width - 1 downto 0) := (16 => '1', others => '0');
	constant note_9 : std_logic_vector(notes_data_width - 1 downto 0) := (15 => '1', others => '0');
	constant note_10 : std_logic_vector(notes_data_width - 1 downto 0) := (14 => '1', others => '0');
	constant note_11 : std_logic_vector(notes_data_width - 1 downto 0) := (13 => '1', others => '0');
	constant note_12 : std_logic_vector(notes_data_width - 1 downto 0) := (12 => '1', others => '0');
	constant note_13 : std_logic_vector(notes_data_width - 1 downto 0) := (11 => '1', others => '0');
	constant note_14 : std_logic_vector(notes_data_width - 1 downto 0) := (10 => '1', others => '0');
	constant note_15 : std_logic_vector(notes_data_width - 1 downto 0) := (9 => '1', others => '0');
	constant note_16 : std_logic_vector(notes_data_width - 1 downto 0) := (8 => '1', others => '0');
	constant note_17 : std_logic_vector(notes_data_width - 1 downto 0) := (7 => '1', others => '0');
	constant note_18 : std_logic_vector(notes_data_width - 1 downto 0) := (6 => '1', others => '0');
	constant note_19 : std_logic_vector(notes_data_width - 1 downto 0) := (5 => '1', others => '0');
	constant note_20 : std_logic_vector(notes_data_width - 1 downto 0) := (4 => '1', others => '0');
	constant note_21 : std_logic_vector(notes_data_width - 1 downto 0) := (3 => '1', others => '0');
	constant note_22 : std_logic_vector(notes_data_width - 1 downto 0) := (2 => '1', others => '0');
	constant note_23 : std_logic_vector(notes_data_width - 1 downto 0) := (1 => '1', others => '0');
	constant note_24 : std_logic_vector(notes_data_width - 1 downto 0) := (0 => '1', others => '0');
	
	--将输入音符信号转换成特定的第几个被按下的音符. 例如num_of_pkey为4, 则监测第四个被按下的音符
	function rawnote2note(ndata : std_logic_vector(notes_data_width - 1 downto 0);
								 num_of_pkey : integer) return std_logic_vector;

	
	
	
	
	
	
	
	
	-------------------------
	--filter
	-------------------------
	--滤波器的详尽系数以及转换子程序在滤波器package中
	constant filter_number_width : integer := 5;  --24个滤波器, 5位表示即可
	
	
	
	
	
	
	-------------------------
	--my_nco
	-------------------------
	constant NCO_countnum_width : integer := 17;        --输入到的计数值
	constant NCO_wave_width : integer := 6;        --NCO 输出波形的位宽
	constant NCO_countnum_max : integer := 95556;  --计数的最大值, 在my_nco中对计数器做一个范围限制, 综合可以小一些位宽
	--对应的25个NCO计数器翻转值.
	constant NCO_countnum_note_0: std_logic_vector(NCO_countnum_width - 1 downto 0) := (others => '0');
	constant NCO_countnum_note_1: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10111010101000100";
	constant NCO_countnum_note_2: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10110000001010001";
	constant NCO_countnum_note_3: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10100110010001011";
	constant NCO_countnum_note_4: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10011100111100001";
	constant NCO_countnum_note_5: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10010100001000011";
	constant NCO_countnum_note_6: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10001011110100010";
	constant NCO_countnum_note_7: std_logic_vector(NCO_countnum_width - 1 downto 0) := "10000011111110001";
	constant NCO_countnum_note_8: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01111100100100000";
	constant NCO_countnum_note_9: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01110101100100101";
	constant NCO_countnum_note_10: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01101110111110010";
	constant NCO_countnum_note_11: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01101000101111101";
	constant NCO_countnum_note_12: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01100010110111011";
	constant NCO_countnum_note_13: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01011101010100010";
	constant NCO_countnum_note_14: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01011000000101001";
	constant NCO_countnum_note_15: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01010011001000110";
	constant NCO_countnum_note_16: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01001110011110001";
	constant NCO_countnum_note_17: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01001010000100010";
	constant NCO_countnum_note_18: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01000101111010001";
	constant NCO_countnum_note_19: std_logic_vector(NCO_countnum_width - 1 downto 0) := "01000001111111000";
	constant NCO_countnum_note_20: std_logic_vector(NCO_countnum_width - 1 downto 0) := "00111110010010000";
	constant NCO_countnum_note_21: std_logic_vector(NCO_countnum_width - 1 downto 0) := "00111010110010010";
	constant NCO_countnum_note_22: std_logic_vector(NCO_countnum_width - 1 downto 0) := "00110111011111001";
	constant NCO_countnum_note_23: std_logic_vector(NCO_countnum_width - 1 downto 0) := "00110100010111111";
	constant NCO_countnum_note_24: std_logic_vector(NCO_countnum_width - 1 downto 0) := "00110001011011110";
	
	--将音符信号转化为对应的NCO phase_step，用以控制NCO输出频率，同时产生滤波器的标号值. 由于滤波器是后面添加, 
	--此处直接将功能集成在这里了.
	procedure note2NCOcountnum(signal ndata : in std_logic_vector(notes_data_width - 1 downto 0);
		                       signal x : out std_logic_vector(NCO_countnum_width - 1 downto 0);
									  signal num : out std_logic_vector(filter_number_width - 1 downto 0));

	
	
	
	
	
	
	
	
								  
	-------------------------
	--ADSR
	-------------------------
	constant ADSR_note_out_width : integer := 24;                      --板载24位音频模块，ASDR输出结果24位

	
	
	
	
	
	
	
	
	
	-------------------------
	--WM8731 Audio Codec
	-------------------------
	--I2C对WM8731进行寄存器配置，8731从器件地址+寄存器地址+寄存器数据构成24位数据，每个寄存器进行一次I2C传输。
	
	-------------wm8731器件地址,最后一位指示读写r/w'------------
	constant wm8731_device_address : std_logic_vector(7 downto 0) := x"34";
	constant wm8731_reg_dwidth : integer := 24;
	constant wm8731_reg_num : integer := 9;
	--以下为各配置寄存器的地址及数据，拼接为两个字节. 由于只需要输出,部分寄存器无需配置保存默认值即可。
	
	-------------------耳机输出---------------------
	constant wm8731_left_headphone_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000010" & "011110111";
	constant wm8731_right_headphone_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000011" & "011101111";
	
	--------------模拟音频路径控制寄存器------------------
	constant wm8731_analogue_path_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000100" & "000010000"; 
	
	--------------数字音频路径控制寄存器------------------
	constant wm8731_digital_path_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000101" & "000000000"; 
	
	--------------power down控制寄存器-------------------
	constant wm8731_power_down_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000110" & "001100111"; 
	
	--------------数字音频接口格式控制寄存器-------------------
	--采用left justified进行传输
	constant wm8731_digital_interface_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000111" & "000001001"; 
	
	--------------采样控制寄存器-------------------
	--dac采样率96khz, mclk需要12.288mhz
	constant wm8731_sampling_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0001000" & "000011100";
	
	--------------激活控制寄存器-------------------
	--写入该寄存器则芯片开始工作,因此该寄存器最后写入
	constant wm8731_active_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0001001" & "000000001";
	
	--------------复位控制寄存器-------------------
	constant wm8731_reset_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0001111" & "000000000";
	
	--在wm8731初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure codec_regcount2data(signal num : in integer range 0 to wm8731_reg_num; 
								         signal x : out std_logic_vector(wm8731_reg_dwidth - 1 downto 0));

	
	
	
	
	
	
	
	
	
	--若帧率相关有问题就去复制application note的值过来
	-------------------------
	--OV7670
	-------------------------
	--利用i2c对OV7670进行配置, 7670器件7bits地址 + 1bit读写指示
	constant ov7670_device_address : std_logic_vector(7 downto 0) := x"42";  --7670写地址x42
	--寄存器宽度及需要配置的寄存器个数
	constant ov7670_reg_dwidth : integer := 24;
	constant ov7670_reg_num : integer := 19 + 35;
	--ov7670输出Y数据为8位
	constant ov7670_output_width : integer := 8;
	--图像分辨率
	constant ov7670_image_width : integer := 320;
	constant ov7670_image_height : integer := 240;
	
	--以下为i2c写入数据. 器件地址 & 寄存器地址 & 寄存器值
	--------------复位及输出选择寄存器-------------------
	--暂不使用软件复位, 配置为RGB格式输出, QVGA. rgb+qvga为x"14", yuv+qvag为x"10"
	constant ov7670_reset_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"12" & x"80";
	constant ov7670_reset_config_qvga : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"12" & x"14";
	--------------时钟设置寄存器-------------------
	--输入时钟经过pll后的分频控制
	constant ov7670_clkreg_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"11" & x"01";
	
	--------------PLL设置寄存器-------------------
	--pll设置. 此处将输出时钟乘4, 得到100mhz. 再经过上面的分频除以4, 得到25mhz, 作为摄像头内部工作时钟
	constant ov7670_pll_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"6b" & x"4a";
	
	--------------PCLK及拉伸-------------------
	--normal PLCK, 不拉伸
	constant ov7670_pclk_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3e" & x"00";
	
	--------------输出范围设置-------------------
	--设置输出范围. 同时可以设置RGB输出格式. 此处设为rgb565, 输出范围00-ff
	constant ov7670_range_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"40" & x"d0";
	
	--------------TLSB设置-------------------
	--正常YUV模式, 此寄存器第4位与x"3d"寄存器最低位共通选择YUV输出顺序
	--此外, 地址为3d的寄存器还可以管理gamma校正. 此处打开gamma,并且tlsb[3]=1 3d[0]=0, 输出顺序为UYVY, 低字节为Y值
	constant ov7670_tlsb_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3a" & x"00";
	constant ov7670_3d_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3d" & x"c0";
	
	--输出窗口相关设置, START和STOP应该就是帧/场同步信号的起始和结束计数值,设置320*640窗口
	--------------HREF设置-------------------
	constant ov7670_href_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"32" & x"80";--80
	
	--------------VREF设置-------------------
	constant ov7670_vref_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"03" & x"0a";--0a
	
	--------------HSTART设置-------------------
	constant ov7670_hstart_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"17" & x"16";--16
	
	--------------HSTOP设置-------------------
	constant ov7670_hstop_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"18" & x"04";--04
	
	--------------VSTART设置-------------------
	constant ov7670_vstart_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"19" & x"02";--02
	
	--------------VSTOP设置-------------------
	constant ov7670_vstop_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"1a" & x"7a";--7a
	
	--条纹滤波器配置
	--enable滤波器, 启自动增益补偿AGC, 自动白平衡AWB
	constant ov7670_filteren_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"13" & x"e0";
	--50hz 设置
	constant ov7670_50hz1_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"9d" & x"4c";
	constant ov7670_50hz2_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"a5" & x"05";
	--选择50hz 的滤波器
	constant ov7670_filtersel_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3b" & x"0a";
	
	--白平衡增益使能, 同时管理自动de-noise功能
	constant ov7670_awbgain_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"41" & x"08";
	
	--在ov7670初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure camera_regcount2data(signal num : in integer range 0 to ov7670_reg_num; 
								         signal x : out std_logic_vector(ov7670_reg_dwidth - 1 downto 0));

	
	
	
	
	
	
	
	
	
	-------------------------
	--predictor 琴键相关数据
	-------------------------
	--白键通过起始地址加上宽度来表示, 黑键则通过其中心位置和半宽度表示.
	
	--琴谱起始横纵坐标. 注意于摄像头所拍摄图像相反, 需要调整
	constant key_original_x : integer := 0;
	constant key_original_y : integer := 0;
	
	--琴键宽度信息
	constant key_white_width : integer := 22; --白键宽度像素数
	constant key_black_halfwidth : integer := 10; --黑键宽度像素数的一半
	constant key_black_length : integer := 80;
	
	--黑白琴键分割行. 为琴键原点行数加上黑键长度
	constant dividing_line : integer := key_original_x + key_black_length;
	
	--白键相关数据
	constant key_white1_start : integer := key_original_y;
	constant key_white2_start : integer := key_original_y + key_white_width;
	constant key_white3_start : integer := key_original_y + 2 * key_white_width;
	constant key_white4_start : integer := key_original_y + 3 * key_white_width;
	constant key_white5_start : integer := key_original_y + 4 * key_white_width;
	constant key_white6_start : integer := key_original_y + 5 * key_white_width;
	constant key_white7_start : integer := key_original_y + 6 * key_white_width;
	constant key_white8_start : integer := key_original_y + 7 * key_white_width;
	constant key_white9_start : integer := key_original_y + 8 * key_white_width;
	constant key_white10_start : integer := key_original_y + 9 * key_white_width;
	constant key_white11_start : integer := key_original_y + 10 * key_white_width;
	constant key_white12_start : integer := key_original_y + 11 * key_white_width;
	constant key_white13_start : integer := key_original_y + 12 * key_white_width;
	constant key_white14_start : integer := key_original_y + 13 * key_white_width;
	
	--黑键相关数据. 黑键记录其中心坐标, 黑键中心恰好是白键相交处
	constant key_black1_center : integer := key_white2_start;
	constant key_black2_center : integer := key_white3_start;
	constant key_black3_center : integer := key_white5_start;
	constant key_black4_center : integer := key_white6_start;
	constant key_black5_center : integer := key_white7_start;
	constant key_black6_center : integer := key_white9_start;
	constant key_black7_center : integer := key_white10_start;
	constant key_black8_center : integer := key_white12_start;
	constant key_black9_center : integer := key_white13_start;
	constant key_black10_center : integer := key_white14_start;
	
	--输入像素点横纵坐标, 然后将对应的按键位置位
	procedure coordinates2keys(signal row : in integer range 0 to ov7670_image_height; 
										signal column : in integer range 0 to ov7670_image_width;
								      signal key : out std_logic_vector(notes_data_width - 1 downto 0));
end package constants;


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------


package body constants is
	--Audio_Controller
	--将输入音符信号转换成特定的第几个被按下的音符. 例如num_of_pkey为4, 则监测第四个被按下的音符
	function rawnote2note(ndata : std_logic_vector(notes_data_width - 1 downto 0);
								 num_of_pkey : integer) return std_logic_vector is
		variable j : integer range 1 to 24 := 1;
		variable x : std_logic_vector(23 downto 0) := (others => '0');
		begin
			for i in 23 downto 0 loop
				if(ndata(i) = '1') then
					if(j = num_of_pkey) then
						x := (i => '1', others => '0');
						exit;
					else
						j := j + 1;
					end if;
				else
					x(i) := '0';
				end if;
			end loop;
			return x;
	end function rawnote2note;
----------------------------------------------------------
----------------------------------------------------------
	--从音频信号得到NCO的计数值用以控制频率. 同时产生滤波器的标号值
	procedure note2NCOcountnum(signal ndata : in std_logic_vector(notes_data_width - 1 downto 0);
		                       signal x : out std_logic_vector(NCO_countnum_width - 1 downto 0);
									  signal num : out std_logic_vector(filter_number_width - 1 downto 0)) is
		begin
			case ndata is
			when note_1 =>	x <= NCO_countnum_note_1; num <= "00001";
			when note_2 =>	x <= NCO_countnum_note_2; num <= "00010";
			when note_3 =>	x <= NCO_countnum_note_3; num <= "00011";
			when note_4 =>	x <= NCO_countnum_note_4; num <= "00100";
			when note_5 =>	x <= NCO_countnum_note_5; num <= "00101";
			when note_6 =>	x <= NCO_countnum_note_6; num <= "00110";
			when note_7 =>	x <= NCO_countnum_note_7; num <= "00111";
			when note_8 =>	x <= NCO_countnum_note_8; num <= "01000";
			when note_9 =>	x <= NCO_countnum_note_9; num <= "01001";
			when note_10 => x <= NCO_countnum_note_10; num <= "01010";
			when note_11 => x <= NCO_countnum_note_11; num <= "01011";
			when note_12 => x <= NCO_countnum_note_12; num <= "01100";
			when note_13 => x <= NCO_countnum_note_13; num <= "01101";
			when note_14 => x <= NCO_countnum_note_14; num <= "01110";
			when note_15 => x <= NCO_countnum_note_15; num <= "01111";
			when note_16 => x <= NCO_countnum_note_16; num <= "10000";
			when note_17 => x <= NCO_countnum_note_17; num <= "10001";
			when note_18 => x <= NCO_countnum_note_18; num <= "10010";
			when note_19 => x <= NCO_countnum_note_19; num <= "10011";
			when note_20 => x <= NCO_countnum_note_20; num <= "10100";
			when note_21 => x <= NCO_countnum_note_21; num <= "10101";
			when note_22 => x <= NCO_countnum_note_22; num <= "10110";
			when note_23 => x <= NCO_countnum_note_23; num <= "10111";
			when note_24 => x <= NCO_countnum_note_24; num <= "11000";
			when others => x <= (others => '0'); num <= (others => '0');
			end case;
	end procedure note2NCOcountnum;
----------------------------------------------------------
----------------------------------------------------------
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
		when others => x <= (others => '1');
		end case;
	end procedure codec_regcount2data;
----------------------------------------------------------
----------------------------------------------------------
	--在摄像头初始化时, 将寄存器计数值转化为对应的寄存器数据
	procedure camera_regcount2data(signal num : in integer range 0 to ov7670_reg_num; 
								         signal x : out std_logic_vector(ov7670_reg_dwidth - 1 downto 0)) is
	begin
		case num is
		when 0 => x <= ov7670_reset_config;
		when 1 => x <= ov7670_reset_config_qvga;
		when 2 => x <= ov7670_clkreg_config; 
		when 3 => x <= ov7670_pll_config;
		when 4 => x <= ov7670_pclk_config;
		when 5 => x <= ov7670_range_config;
		when 6 => x <= ov7670_tlsb_config;
		when 7 => x <= ov7670_3d_config;
		when 8 => x <= ov7670_href_config;
		when 9 => x <= ov7670_vref_config;
		when 10 => x <= ov7670_hstart_config;
		when 11 => x <= ov7670_hstop_config;
		when 12 => x <= ov7670_vstart_config;
		when 13 => x <= ov7670_vstop_config;
		when 14 => x <= ov7670_filtersel_config;
		when 15 => x <= ov7670_50hz1_config;
		when 16 => x <= ov7670_50hz2_config;
		when 17 => x <= ov7670_filteren_config;
		when 18 => x <= ov7670_awbgain_config;
		--自动黑电平校正相关配置
		when 19 => x <= ov7670_device_address & x"b084";
		when 20 => x <= ov7670_device_address & x"b100";
		when 21 => x <= ov7670_device_address & x"b20e";
		when 22 => x <= ov7670_device_address & x"b382";
		when 23 => x <= ov7670_device_address & x"b80a";
		--色彩矩阵
		when 24 => x <= ov7670_device_address & x"4f80";
		when 25 => x <= ov7670_device_address & x"5080";
		when 26 => x <= ov7670_device_address & x"5100";
		when 27 => x <= ov7670_device_address & x"5222";
		when 28 => x <= ov7670_device_address & x"535e";
		when 29 => x <= ov7670_device_address & x"5480";
		when 30 => x <= ov7670_device_address & x"589e";
		--gamma参数
		when 31 => x <= ov7670_device_address & x"7a20";
		when 32 => x <= ov7670_device_address & x"7b1c";
		when 33 => x <= ov7670_device_address & x"7c28";
		when 34 => x <= ov7670_device_address & x"7d3c";
		when 35 => x <= ov7670_device_address & x"7e55";
		when 36 => x <= ov7670_device_address & x"7f68";
		when 37 => x <= ov7670_device_address & x"8076";
		when 38 => x <= ov7670_device_address & x"8180";
		when 39 => x <= ov7670_device_address & x"8288";
		when 40 => x <= ov7670_device_address & x"838f";
		when 41 => x <= ov7670_device_address & x"8496";
		when 42 => x <= ov7670_device_address & x"85a3";
		when 43 => x <= ov7670_device_address & x"86af";
		when 44 => x <= ov7670_device_address & x"87c4";
		when 45 => x <= ov7670_device_address & x"88d7";
		when 46 => x <= ov7670_device_address & x"89e8";
		--设置蓝色, 红色增益, 绿色增益
		when 47 => x <= ov7670_device_address & x"0144";
		when 48 => x <= ov7670_device_address & x"0240";
		when 49 => x <= ov7670_device_address & x"6a40";
		--噪声抑制等级
		when 50 => x <= ov7670_device_address & x"4cff";
		--曝光时间控制. 设置较低效果较好AEC[15 to 0] = x"07"[5 to 0] & x"10"[7 to 0] & x"04"[1 to 0]
		when 51 => x <= ov7670_device_address & x"0700";
		when 52 => x <= ov7670_device_address & x"1040";
		when 53 => x <= ov7670_device_address & x"0400";
		when others => x<= (others => '1');
		end case;
	end procedure camera_regcount2data;
----------------------------------------------------------
----------------------------------------------------------
	--输入像素点横纵坐标, 然后将对应的按键位置位
	procedure coordinates2keys(signal row : in integer range 0 to ov7670_image_height; 
										signal column : in integer range 0 to ov7670_image_width;
								      signal key : out std_logic_vector(notes_data_width - 1 downto 0)) is
	begin
		--在分割线之下, 是白键
		if(row >= dividing_line) then
			if(column >= key_white1_start and column <= key_white1_start + key_white_width) then key(notes_data_width - 1) <= '1';
			elsif(column >= key_white2_start and column <= key_white2_start + key_white_width) then key(notes_data_width - 3) <= '1';
			elsif(column >= key_white3_start and column <= key_white3_start + key_white_width) then key(notes_data_width - 5) <= '1';
			elsif(column >= key_white4_start and column <= key_white4_start + key_white_width) then key(notes_data_width - 6) <= '1';
			elsif(column >= key_white5_start and column <= key_white5_start + key_white_width) then key(notes_data_width - 8) <= '1';
			elsif(column >= key_white6_start and column <= key_white6_start + key_white_width) then key(notes_data_width - 10) <= '1';
			elsif(column >= key_white7_start and column <= key_white7_start + key_white_width) then key(notes_data_width - 12) <= '1';
			elsif(column >= key_white8_start and column <= key_white8_start + key_white_width) then key(notes_data_width - 13) <= '1';
			elsif(column >= key_white9_start and column <= key_white9_start + key_white_width) then key(notes_data_width - 15) <= '1';
			elsif(column >= key_white10_start and column <= key_white10_start + key_white_width) then key(notes_data_width - 17) <= '1';
			elsif(column >= key_white11_start and column <= key_white11_start + key_white_width) then key(notes_data_width - 18) <= '1';
			elsif(column >= key_white12_start and column <= key_white12_start + key_white_width) then key(notes_data_width - 20) <= '1';
			elsif(column >= key_white13_start and column <= key_white13_start + key_white_width) then key(notes_data_width - 22) <= '1';
			elsif(column >= key_white14_start and column <= key_white14_start + key_white_width) then key(notes_data_width - 24) <= '1';
			else null;
			end if;
			
		--分割线之上, 是黑键
		else
			if(column >= key_black1_center - key_black_halfwidth and column <= key_black1_center + key_black_halfwidth) then 
				key(notes_data_width - 2) <= '1';
			elsif(column >= key_black2_center - key_black_halfwidth and column <= key_black2_center + key_black_halfwidth) then 
				key(notes_data_width - 4) <= '1';
			elsif(column >= key_black3_center - key_black_halfwidth and column <= key_black3_center + key_black_halfwidth) then 
				key(notes_data_width - 7) <= '1';
			elsif(column >= key_black4_center - key_black_halfwidth and column <= key_black4_center + key_black_halfwidth) then 
				key(notes_data_width - 9) <= '1';
			elsif(column >= key_black5_center - key_black_halfwidth and column <= key_black5_center + key_black_halfwidth) then 
				key(notes_data_width - 11) <= '1';
			elsif(column >= key_black6_center - key_black_halfwidth and column <= key_black6_center + key_black_halfwidth) then 
				key(notes_data_width - 14) <= '1';
			elsif(column >= key_black7_center - key_black_halfwidth and column <= key_black7_center + key_black_halfwidth) then 
				key(notes_data_width - 16) <= '1';
			elsif(column >= key_black8_center - key_black_halfwidth and column <= key_black8_center + key_black_halfwidth) then 
				key(notes_data_width - 19) <= '1';
			elsif(column >= key_black9_center - key_black_halfwidth and column <= key_black9_center + key_black_halfwidth) then 
				key(notes_data_width - 21) <= '1';
			elsif(column >= key_black10_center - key_black_halfwidth and column <= key_black10_center + key_black_halfwidth) then 
				key(notes_data_width - 23) <= '1';
			else null;
			end if;
		end if;
	end procedure coordinates2keys;


end constants;




