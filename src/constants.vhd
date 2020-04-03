--用来保存各种常数的package，当后续需要调整位宽之类的时候只需修改本文件中的常数，方便调试

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants is
	--Audio_Controller
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
	
	--NCO
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
	
	--ADSR
	constant note_out_width : integer := 24;                      --板载24位音频模块，ASDR输出结果24位
	--attack,decay,release阶段计数器阈值
	constant counter_width : integer := 23;                       --22位才能表示到300000,符号位再加1位
	constant counterA_threshold : signed := to_signed(100000, counter_width);   --50mhz，一个时钟周期20ns, 2ms供100000个周期
	constant counterD_threshold : signed := to_signed(300000, counter_width);   --6ms
	constant counterR_threshold : signed := to_signed(300000, counter_width);   --6ms
	--ADSR的参数.由于无浮点，实数又不可综合，因此用mod运算来控制幅值调制参数
	constant counterA_divisor : integer := 49;                                  --100000/2047取整为49
	constant counterD_start : signed := to_signed(2047, counter_width);        --decay从最大值2047开始降低
	constant counterD_divisor : integer := 293;                                 --300000/1024取整为293
	constant sustain_level : signed := to_signed(1023, counter_width);         --sustain阶段保持的幅值调制系数，也是release下降的起点
	constant counterR_divisor : integer := 293;                                 --300000/1024取整为293
	
end package constants;
