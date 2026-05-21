library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_ctrl is
    Port ( clk, rst, view_mode, time_done, led_fault : in STD_LOGIC;
           t_reactie, t_best, t_winner : in STD_LOGIC_VECTOR(15 downto 0);
           user_id, winner_id : in STD_LOGIC_VECTOR(1 downto 0);
           round_id : in STD_LOGIC_VECTOR(2 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0));
end display_ctrl;

architecture Behavioral of display_ctrl is
    signal div_clk : std_logic_vector(15 downto 0) := (others => '0');
    signal hex_digit : std_logic_vector(3 downto 0);
    signal display_user : std_logic_vector(3 downto 0);
    signal display_time : std_logic_vector(15 downto 0);
    signal bcd0, bcd1, bcd2, bcd3 : std_logic_vector(3 downto 0);
    signal held_score : std_logic_vector(15 downto 0) := (others => '0');
    signal display_id : std_logic_vector(1 downto 0);
begin
    -- 1. Divizor de ceas si salvare scor curent
    process(clk, rst) 
    begin 
        if rst = '1' then 
            div_clk <= (others => '0'); 
            held_score <= (others => '0');
        elsif rising_edge(clk) then 
            div_clk <= div_clk + 1; 
            if time_done = '1' then 
                held_score <= t_reactie; 
            elsif led_fault = '1' then 
                held_score <= (others => '0'); 
            end if; 
        end if; 
    end process;

    -- 2. Selectarea datelor de afisat (MOPDIFICAT PENTRU PRIORITATE CURATĂ)
    process(view_mode, t_best, user_id, t_winner, winner_id, time_done, t_reactie, held_score)
    begin
        if view_mode = '1' then  -- Prioritate maximă: dacă vrem să vedem statisticile, asta arătăm!
            if t_best = x"FFFF" then 
                display_time <= (others => '0'); 
            else 
                display_time <= t_best; 
            end if;
            display_id <= user_id;
            
        elsif t_winner /= x"0000" then -- Dacă jocul e gata și avem un câștigător calculat
            if t_winner = x"FFFF" then 
                display_time <= (others => '0'); 
            else 
                display_time <= t_winner; 
            end if;
            display_id <= winner_id;
            
        else -- În timpul jocului normal
            display_id <= user_id;
            if time_done = '1' then 
                display_time <= t_reactie; 
            else 
                display_time <= held_score; 
            end if; 
        end if;
    end process;

    -- Logica de decodificare ID utilizator în cifră pe ecran
    process(display_id)
    begin
        case display_id is 
            when "00" => display_user <= "0001"; -- U1
            when "01" => display_user <= "0010"; -- U2
            when "10" => display_user <= "0011"; -- U3
            when others => display_user <= "0100"; -- U4
        end case;
    end process;

    -- 3. Convertor BCD (Double Dabble)
    process(display_time)
        variable temp : std_logic_vector(13 downto 0); 
        variable bcd : std_logic_vector(15 downto 0);
    begin
        temp := display_time(13 downto 0); 
        bcd := (others => '0');
        for i in 0 to 13 loop
            if bcd(3 downto 0) > 4 then bcd(3 downto 0) := bcd(3 downto 0) + 3; end if;
            if bcd(7 downto 4) > 4 then bcd(7 downto 4) := bcd(7 downto 4) + 3; end if;
            if bcd(11 downto 8) > 4 then bcd(11 downto 8) := bcd(11 downto 8) + 3; end if;
            if bcd(15 downto 12) > 4 then bcd(15 downto 12) := bcd(15 downto 12) + 3; end if;
            bcd := bcd(14 downto 0) & temp(13); 
            temp := temp(12 downto 0) & '0';
        end loop;
        bcd0 <= bcd(3 downto 0); 
        bcd1 <= bcd(7 downto 4); 
        bcd2 <= bcd(11 downto 8); 
        bcd3 <= bcd(15 downto 12);
    end process;

    -- 4. Multiplexare Anozi (Scanare ecran)
    process(div_clk(15 downto 13), bcd0, bcd1, bcd2, bcd3, display_user, round_id) 
    begin
        case div_clk(15 downto 13) is
            when "000" => an <= "11111110"; hex_digit <= bcd0;
            when "001" => an <= "11111101"; hex_digit <= bcd1;
            when "010" => an <= "11111011"; hex_digit <= bcd2;
            when "011" => an <= "11110111"; hex_digit <= bcd3;
            when "100" => an <= "11101111"; hex_digit <= "0" & round_id;
            when "101" => an <= "11011111"; hex_digit <= "1101"; -- Caracterul 'r' (Rundă)
            when "110" => an <= "10111111"; hex_digit <= display_user; 
            when "111" => an <= "01111111"; hex_digit <= "1011"; -- Caracterul 'U' (User)
            when others => an <= "11111111"; hex_digit <= "1111";
        end case;
    end process;

    -- 5. Decodor 7 Segmente (Catozi)
    process(hex_digit) 
    begin
        case hex_digit is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1011" => seg <= "1000001"; -- 'U'
            when "1101" => seg <= "0101111"; -- 'r'
            when others => seg <= "1111111"; -- Stins
        end case;
    end process;
end Behavioral;