library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_ctrl is
    Port ( clk : in STD_LOGIC;
           rst_in : in STD_LOGIC;
           rst_global : out STD_LOGIC;
           rst_user : out STD_LOGIC);
end reset_ctrl;

architecture Behavioral of reset_ctrl is
    signal count : integer range 0 to 200000000 := 0;
    signal btn_prev : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            btn_prev <= rst_in;
            rst_user <= '0';
            rst_global <= '0';

            if rst_in = '1' then
                if count < 200000000 then
                    count <= count + 1;
                else 
                    rst_global <= '1';
                end if;
            else
                if btn_prev = '1' and count < 200000000 and count > 1000000 then
                    rst_user <= '1';
                end if;
                count <= 0;
            end if;
        end if;
    end process;
end Behavioral;