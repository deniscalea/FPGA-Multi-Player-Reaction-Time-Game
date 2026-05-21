
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MAIN_COUNT is
    Port ( clk : in STD_LOGIC;
           rst_cnt : in STD_LOGIC;
           en_cnt : in STD_LOGIC;
           clk_1ms : in STD_LOGIC;
           t_total : out STD_LOGIC_VECTOR (15 downto 0));
end MAIN_COUNT;

architecture Behavioral of MAIN_COUNT is
signal numaratoare: std_logic_vector (15 downto 0) := (others => '0');
begin
process(clk,rst_cnt)
begin
if rst_cnt ='1' then
numaratoare <= (others => '0');
elsif rising_edge(clk) then
if en_cnt='1' and clk_1ms='1' then
numaratoare<=numaratoare+1;
end if;
end if;
end process;
t_total <=numaratoare;


end Behavioral;
