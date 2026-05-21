library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    Port ( t_total    : in  STD_LOGIC_VECTOR (15 downto 0);
           t_random   : in  STD_LOGIC_VECTOR (15 downto 0);
           led_semnal : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is
begin 

    process(t_total, t_random)
    begin
        if t_total >= t_random then
            led_semnal <= '1';
        else
            led_semnal <= '0';
        end if;
    end process;

end Behavioral;