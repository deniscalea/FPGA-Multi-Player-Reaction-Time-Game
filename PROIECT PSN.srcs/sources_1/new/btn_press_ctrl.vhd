library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity btn_press_ctrl is
    Port ( clk : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           short_press : out STD_LOGIC;
           long_press : out STD_LOGIC);
end btn_press_ctrl;

architecture Behavioral of btn_press_ctrl is
   
    signal count : std_logic_vector(26 downto 0) := (others => '0'); 
    signal btn_prev : std_logic := '0';
    signal long_pressed_done : std_logic := '0'; 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            btn_prev <= btn_in;
            short_press <= '0';
            long_press <= '0';

            if btn_in = '1' then
                if count < 100000000 then
                    count <= count + 1;
                elsif count = 100000000 then
                    long_press <= '1';         
                    long_pressed_done <= '1';   
                    count <= count + 1;
                end if;
            else
                
                if btn_prev = '1' and long_pressed_done = '0' and count > 1000000 then
                    short_press <= '1'; 
                end if;
                
                count <= (others => '0');
                long_pressed_done <= '0'; 
            end if;
        end if;
    end process;
end Behavioral;