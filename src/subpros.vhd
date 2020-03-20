--包含子程序的package

library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

package subpros is
	--Audio_Controller
	--将识别模块输出的24位信号进行转化，只保留第一个1，其余位全部置为0
	function rawnote2note(ndata : std_logic_vector(notes_data_width - 1 downto 0)) return std_logic_vector;
end package subpros;

package body subpros is
	--Audio_Controller
	
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
	
end subpros;




