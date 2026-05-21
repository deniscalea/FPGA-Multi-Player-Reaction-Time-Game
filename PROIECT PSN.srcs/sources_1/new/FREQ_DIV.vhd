library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all; 

entity freq_div is
    Port ( clk     : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           clk_1ms : out STD_LOGIC);
end freq_div;

architecture Behavioral of freq_div is
begin
process(clk,rst)
variable nr: std_logic_vector(16 downto 0) := (others => '0');
begin
if rst ='1' then
nr := (others => '0');
clk_1ms <= '0';
elsif rising_edge(clk) then
if nr=99999 then
nr:=(others => '0');
clk_1ms <= '1';
else
nr:=nr+1;
clk_1ms <='0';
end if;
end if;  
end process;
end Behavioral;