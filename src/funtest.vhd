library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;


entity funtest is 
port(
	rst : in std_logic;
	clk : in std_logic;
   a : in std_logic_vector(NCO_wave_width - 1 downto 0);
   b : in std_logic_vector(NCO_wave_width - 1 downto 0);
   c : out std_logic_vector(NCO_wave_width - 1 downto 0)
);
end entity funtest;

architecture bhv of funtest is
	constant counter_width : integer := 23;   
	constant counterA_threshold : signed := to_signed(100000, counter_width);
	constant counterA_divisor : integer := 49;
	signal counter : signed(counter_width - 1 downto 0) := (others => '0'); 
	signal r : signed(counter_width - 1 downto 0) := (others => '0'); 
	signal k : signed(NCO_wave_width - 1 downto 0);
begin
	process(rst, clk)
	begin
		if(rst = '0') then
			counter <= (others => '0');
		elsif(clk'event and clk = '1') then
			if(counter = counterA_threshold) then
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	r <= counter/counterA_divisor;
	c <= std_logic_vector(r(NCO_wave_width - 1 downto 0));

end architecture bhv;


--library ieee;
--use ieee.std_logic_1164.all;
--
--entity test is
--	port(
--		rst, clk, x : in std_logic;
--		q : out std_logic
--	);
--end entity;
--
--architecture bhv of test is
--	type states is (s0, s1, s2, s3);
--	signal cur_state : states;
--	signal next_state : states;
--
--begin
--	process(rst, clk)
--	begin
--		if(rst = '0') then
--			cur_state <= s0;
--		elsif(clk'event and clk = '1') then
--			cur_state <= next_state;
--		end if;
--	end process;
--	
--	process(cur_state, x)
--	begin
--		next_state <= cur_state;
--		
--		case cur_state is
--		when s0 =>
--			if(x = '0') then
--				next_state <= s0;
--			else
--				next_state <= s2;
--			end if;
--		when s1 =>
--			if(x = '0') then
--				next_state <= s0;
--			else
--				next_state <= s2;
--			end if;
--		when s2 =>
--			if(x = '0') then
--				next_state <= s2;
--			else
--				next_state <= s3;
--			end if;
--		when s3 =>
--			if(x = '0') then
--				next_state <= s3;
--			else
--				next_state <= s1;
--			end if;
--		end case;
--	end process;
--	
--	process(cur_state, x)
--	begin
--		case cur_state is
--			when s0 =>
--				if(x = '0') then
--					q <= '0';
--				else
--					q <= '1';
--				end if;
--			when s1 =>
--				q <= '0';
--			when s2 =>
--				if(x = '0') then
--					q <= '1';
--				else
--					q <= '0';
--				end if;
--			when s3 =>
--				if(x = '0') then
--					q <= '0';
--				else
--					q <= '1';
--				end if;
--		end case;
--	end process;
--	
--
--end architecture;
