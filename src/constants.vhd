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
	
	
	
	-------------------------
	--NCO
	-------------------------
	constant NCO_phase_width : integer := 25;        --输入到 NCO 的相位step参数
	constant NCO_wave_width : integer := 12 ;        --NCO 输出波形的位宽
	--对应的25个NCO phase step
	constant phase_note_0: std_logic_vector(NCO_phase_width - 1 downto 0) := (others => '0');
	constant phase_note_1: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000101010110111010110";
	constant phase_note_2: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000101101011010011110";
	constant phase_note_3: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000110000000111010011";
	constant phase_note_4: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000110010111110011010";
	constant phase_note_5: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000110110000000011010";
	constant phase_note_6: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000111001001101111011";
	constant phase_note_7: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000000111100100111101011";
	constant phase_note_8: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001000000001110010111";
	constant phase_note_9: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001000100000010110010";
	constant phase_note_10: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001001000000101101111";
	constant phase_note_11: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001001100011000000101";
	constant phase_note_12: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001010000111010101111";
	constant phase_note_13: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001010101101110101100";
	constant phase_note_14: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001011010110100111100";
	constant phase_note_15: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001100000001110100110";
	constant phase_note_16: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001100101111100110100";
	constant phase_note_17: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001101100000000110011";
	constant phase_note_18: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001110010011011110110";
	constant phase_note_19: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000001111001001111010110";
	constant phase_note_20: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000010000000011100101111";
	constant phase_note_21: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000010001000000101100100";
	constant phase_note_22: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000010010000001011011110";
	constant phase_note_23: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000010011000110000001011";
	constant phase_note_24: std_logic_vector(NCO_phase_width - 1 downto 0) := "0000010100001110101011111";
	
	
	
	-------------------------
	--ADSR
	-------------------------
	constant ADSR_note_out_width : integer := 24;                      --板载24位音频模块，ASDR输出结果24位

	
	
	
	-------------------------
	--WM8731 Audio Codec
	-------------------------
	--I2C对WM8731进行寄存器配置，8731从器件地址+寄存器地址+寄存器数据构成24位数据，每个寄存器进行一次I2C传输。
	
	-------------wm8731器件地址,最后一位指示读写r/w'------------
	constant wm8731_device_address : std_logic_vector(7 downto 0) := "00110100";
	constant wm8731_reg_dwidth : integer := 24;
	constant wm8731_reg_num : integer := 9;
	--以下为各配置寄存器的地址及数据，拼接为两个字节。由于只需要输出,部分寄存器无需配置保存默认值即可。
	
	-------------------耳机输出---------------------
	constant wm8731_left_headphone_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000010" & "011111001";
	constant wm8731_right_headphone_config : std_logic_vector(wm8731_reg_dwidth - 1 downto 0) := wm8731_device_address & "0000011" & "011111001";
	
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
	
	
	
	
	--若帧率相关有问题就去复制application note的值过来
	-------------------------
	--OV7670
	-------------------------
	--利用i2c对OV7670进行配置, 7670器件7bits地址 + 1bit读写指示
	constant ov7670_device_address : std_logic_vector(7 downto 0) := x"42";  --7670写地址
	--寄存器宽度及需要配置的寄存器个数
	constant ov7670_reg_dwidth : integer := 24;
	constant ov7670_reg_num : integer := 13;
	--ov7670输出Y数据为8位
	constant ov7670_output_width : integer := 8;
	--图像分辨率
	constant ov7670_image_width : integer := 320;
	constant ov7670_image_height : integer := 240;
	
	--以下为i2c写入数据. 器件地址 & 寄存器地址 & 寄存器值
	--------------复位及输出选择寄存器-------------------
	--暂不使用软件复位, 配置为YUV格式输出, VGA
	constant ov7670_reset_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"12" & x"00";
	
	--------------时钟设置寄存器-------------------
	--使用外部时钟
	constant ov7670_clkreg_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"11" & x"80";
	
	--------------PLL设置寄存器-------------------
	--关闭PLL寄存器, 0分频
	constant ov7670_pll_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"6b" & x"00";
	
	--------------PCLK及拉伸-------------------
	--normal PLCK, 不拉伸
	constant ov7670_pclk_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3e" & x"00";
	
	--------------YUV和输出范围设置-------------------
	--设置输出范围00-ff.
	constant ov7670_yuvrange_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"40" & x"c0";
	
	--------------TLSB设置-------------------
	--正常YUV模式, 此寄存器第4位与x"3d"寄存器最低位共通选择YUV输出顺序
	--此外, 地址为3d的寄存器还可以管理gamma校正. 此处打开gamma,并且tlsb[3]=1 3d[0]=0, 输出顺序为UYVY, 低字节为Y值
	constant ov7670_tlsb_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3a" & x"08";
	constant ov7670_3d_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"3d" & x"80";
	
	
	--输出窗口相关设置, START和STOP应该就是帧/场同步信号的起始和结束计数值,这里按照默认设置,经过计算恰好是相差640和480
	--------------HREF设置-------------------
	constant ov7670_href_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"32" & x"80";
	
	--------------VREF设置-------------------
	constant ov7670_vref_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"03" & x"0a";
	
	--------------HSTART设置-------------------
	constant ov7670_hstart_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"17" & x"11";
	
	--------------HSTOP设置-------------------
	constant ov7670_hstop_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"18" & x"61";
	
	--------------VSTART设置-------------------
	constant ov7670_vstart_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"19" & x"03";
	
	--------------VSTOP设置-------------------
	constant ov7670_vstop_config : std_logic_vector(ov7670_reg_dwidth - 1 downto 0) := ov7670_device_address & x"1a" & x"7b";
	
	

	-------------------------
	--OV7725
	-------------------------
	--利用i2c对OV7725进行配置, 7725器件7bits地址 + 1bit读写指示
	constant ov7725_device_address : std_logic_vector(7 downto 0) := x"42";  --7725写地址
	--寄存器宽度及需要配置的寄存器个数
	constant ov7725_reg_dwidth : integer := 24;
	constant ov7725_reg_num : integer := 11;
	--ov7670输出Y数据为8位
	constant ov7725_output_width : integer := 8;
	--图像分辨率
	constant ov7725_image_width : integer := 320;
	constant ov7725_image_height : integer := 240;
	
	--------------复位寄存器-------------------
	--最高位置1fuewi
	constant ov7725_reset_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"12" & x"80";
	--选择qvga,yuv 只不过和复位信号在一个寄存器里. 
	constant ov7725_reset_config_qvga : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"12" & x"40";
	--反转y/uv的顺序, 不论uyvy还是vyuy都是可以的, 只要y是第二个时钟开始输出
	constant ov7725_yuv_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"0c" & x"10";
	
	--qvga图片格式相关设置
	constant ov7725_hstart_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"17" & x"3f";
	constant ov7725_hsize_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"18" & x"50";
	constant ov7725_vstart_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"19" & x"03";
	constant ov7725_vsize_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"1a" & x"78";
	constant ov7725_Houtsize_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"29" & x"50";
	constant ov7725_Voutsize_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"2c" & x"78";
	--内部时钟及pclk
	constant ov7725_pll_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"0d" & x"41";
	constant ov7725_clkrc_config : std_logic_vector(ov7725_reg_dwidth - 1 downto 0) := ov7725_device_address & x"11" & x"01";
	
end package constants;





