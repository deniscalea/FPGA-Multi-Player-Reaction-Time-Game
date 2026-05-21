library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity rand_reg is
    Port ( clk       : in  STD_LOGIC;
           en_random : in  STD_LOGIC;
           t_random  : out STD_LOGIC_VECTOR(15 downto 0));
end rand_reg;

architecture Behavioral of rand_reg is
    signal registru_rnd : std_logic_vector(15 downto 0) := x"ACE1"; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            registru_rnd <= registru_rnd(14 downto 0) & (registru_rnd(15) xor registru_rnd(13) xor registru_rnd(12) xor registru_rnd(10));
            if en_random = '1' then
                case registru_rnd(2 downto 0) is
                    when "000" | "101" => t_random <= x"03E8";
                    when "001" | "110" => t_random <= x"07D0";
                    when "010" | "111" => t_random <= x"0BB8";
                    when "011"         => t_random <= x"0FA0";
                    when others        => t_random <= x"1388";
                end case;
            end if;
        end if;
    end process;
end Behavioral;