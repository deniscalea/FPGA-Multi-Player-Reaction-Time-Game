library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Scazator is
    Port ( t_total : in STD_LOGIC_VECTOR (15 downto 0);
           t_random : in STD_LOGIC_VECTOR (15 downto 0);
           t_reactie : out STD_LOGIC_VECTOR (15 downto 0));
end Scazator;

architecture Behavioral of Scazator is
begin
    process(t_total, t_random)
    begin
        if t_total < t_random then
            t_reactie <= (others => '0'); 
        else
            t_reactie <= t_total - t_random;
        end if;
    end process;
end Behavioral;