library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity game_counters is
    Port ( clk        : in  STD_LOGIC;
           rst        : in  STD_LOGIC; 
           rst_user   : in  STD_LOGIC; 
           skip       : in  STD_LOGIC;
           inc_round  : in  STD_LOGIC; 
           inc_user   : in  STD_LOGIC; 
           del_user   : in  STD_LOGIC;
           user_id    : out STD_LOGIC_VECTOR (1 downto 0);
           round_id   : out STD_LOGIC_VECTOR (2 downto 0);
           runda_done : out STD_LOGIC;
           game_done  : out STD_LOGIC);
end game_counters;

architecture Behavioral of game_counters is
    signal u_reg : std_logic_vector(1 downto 0) := "00";
    signal r_reg : std_logic_vector(2 downto 0) := "001";
    signal active_users : std_logic_vector(3 downto 0) := "1111"; 
    signal skip_prev : std_logic := '0';
begin
    process(clk, rst)
        variable next_u : std_logic_vector(1 downto 0);
        variable v_active_users : std_logic_vector(3 downto 0);
    begin
        if rst = '1' then
            u_reg <= "00";
            r_reg <= "001";
            active_users <= "1111";
            skip_prev <= '0';
        elsif rising_edge(clk) then
            skip_prev <= skip;
            v_active_users := active_users;

            if rst_user = '1' then
                r_reg <= "001";
            
            elsif skip = '1' and skip_prev = '0' then
                r_reg <= "001";
                if v_active_users /= "0000" then
                    next_u := u_reg + 1;
                    if (next_u = "00" and v_active_users(0) = '0') or
                       (next_u = "01" and v_active_users(1) = '0') or
                       (next_u = "10" and v_active_users(2) = '0') or
                       (next_u = "11" and v_active_users(3) = '0') then
                        
                        next_u := next_u + 1;
                        if (next_u = "00" and v_active_users(0) = '0') or
                           (next_u = "01" and v_active_users(1) = '0') or
                           (next_u = "10" and v_active_users(2) = '0') or
                           (next_u = "11" and v_active_users(3) = '0') then
                            
                            next_u := next_u + 1;
                            if (next_u = "00" and v_active_users(0) = '0') or
                               (next_u = "01" and v_active_users(1) = '0') or
                               (next_u = "10" and v_active_users(2) = '0') or
                               (next_u = "11" and v_active_users(3) = '0') then
                                next_u := next_u + 1;
                            end if;
                        end if;
                    end if;
                    u_reg <= next_u;
                end if;

            elsif del_user = '1' then
                case u_reg is
                    when "00" => v_active_users(0) := '0';
                    when "01" => v_active_users(1) := '0';
                    when "10" => v_active_users(2) := '0';
                    when "11" => v_active_users(3) := '0';
                    when others => null;
                end case;
                active_users <= v_active_users;
            end if;

            if rst_user = '0' and skip = '0' and inc_round = '1' then
                if r_reg = "101" then 
                    r_reg <= "001"; 
                else 
                    r_reg <= r_reg + 1; 
                end if;
            end if;
            
            if inc_user = '1' and v_active_users /= "0000" then
                next_u := u_reg + 1;
                if (next_u = "00" and v_active_users(0) = '0') or
                   (next_u = "01" and v_active_users(1) = '0') or
                   (next_u = "10" and v_active_users(2) = '0') or
                   (next_u = "11" and v_active_users(3) = '0') then
                    
                    next_u := next_u + 1;
                    if (next_u = "00" and v_active_users(0) = '0') or
                       (next_u = "01" and v_active_users(1) = '0') or
                       (next_u = "10" and v_active_users(2) = '0') or
                       (next_u = "11" and v_active_users(3) = '0') then
                        
                        next_u := next_u + 1;
                        if (next_u = "00" and v_active_users(0) = '0') or
                           (next_u = "01" and v_active_users(1) = '0') or
                           (next_u = "10" and v_active_users(2) = '0') or
                           (next_u = "11" and v_active_users(3) = '0') then
                            next_u := next_u + 1;
                        end if;
                    end if;
                end if;
                u_reg <= next_u;
            end if;
        end if;
    end process;

    user_id <= u_reg;
    round_id <= r_reg;
    runda_done <= '1' when r_reg = "101" else '0';
    
    game_done <= '1' when (r_reg = "101" and (
                    (u_reg = "11") or 
                    (u_reg = "10" and active_users(3) = '0') or
                    (u_reg = "01" and active_users(3 downto 2) = "00") or
                    (u_reg = "00" and active_users(3 downto 1) = "000")
                 )) else '0';
end Behavioral;