library ieee;
use ieee.std_logic_1164.all;

entity VirtualPiano is
port(
	a, b: in std_logic;
	c : out std_logic
);
end entity VirtualPiano;

architecture bhv of VirtualPiano is
	constant w : integer := 5;
	signal s : std_logic_vector(w-1 downto 0);
begin
	c <= '0';
end architecture bhv;