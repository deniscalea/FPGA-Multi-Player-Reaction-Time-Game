library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity debouncer is
    Port ( clk : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal count: std_logic_vector (19 downto 0) := (others =>'0');
    signal btn_state: std_logic:='0';
    signal btn_prev: std_logic:='0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            btn_prev <= btn_state; 
            
            if btn_in /= btn_state then
                count <= count + 1;
                if count = x"F4240" then
                    btn_state <= btn_in;
                    count <= (others => '0');
                end if;
            else
                count <= (others => '0');
            end if;
        end if;
    end process;
    
    
    btn_out <= '1' when (btn_state = '1' and btn_prev = '0') else '0';
    
end Behavioral;