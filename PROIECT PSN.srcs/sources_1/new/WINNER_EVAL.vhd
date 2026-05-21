library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity winner_eval is
    Port ( show_winner : in  STD_LOGIC;
           rec_u1      : in  STD_LOGIC_VECTOR (15 downto 0); -- va trebui sa le legi in TOP
           rec_u2      : in  STD_LOGIC_VECTOR (15 downto 0);
           rec_u3      : in  STD_LOGIC_VECTOR (15 downto 0);
           rec_u4      : in  STD_LOGIC_VECTOR (15 downto 0);
           winner_id   : out STD_LOGIC_VECTOR (1 downto 0);
           t_winner    : out STD_LOGIC_VECTOR (15 downto 0));
end winner_eval;

architecture Behavioral of winner_eval is
begin
    process(show_winner, rec_u1, rec_u2, rec_u3, rec_u4)
        variable best_t : std_logic_vector(15 downto 0);
        variable best_id : std_logic_vector(1 downto 0);
    begin
        if show_winner = '1' then
           
            best_t := rec_u1; best_id := "00";
            if rec_u2 < best_t then best_t := rec_u2; best_id := "01"; end if;
            if rec_u3 < best_t then best_t := rec_u3; best_id := "10"; end if;
            if rec_u4 < best_t then best_t := rec_u4; best_id := "11"; end if;
            
            t_winner <= best_t;
            winner_id <= best_id;
        else
            t_winner <= (others => '0');
            winner_id <= "00";
        end if;
    end process;
end Behavioral;