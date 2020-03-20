--用来保存各种常数的package，当后续需要调整位宽之类的时候只需修改本文件中的常数，方便调试

library ieee;
use ieee.std_logic_1164.all;

package constants is
	--Audio_Controller
	constant notes_data_width : integer := 24;    --识别后输出到Audio_Controller的音符数据宽度，24个音符，每个分配一位
	
	--NCO
	constant NCO_phase_width : integer := 25;        --输入到 NCO 的相位step参数
	constant NCO_waveout_width : integer := 24 ;     --NCO 输出波形的位宽
	
end package constants;