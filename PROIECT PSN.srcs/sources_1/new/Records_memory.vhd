library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity records_memory is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC; -- Resetul global (apasare lunga pe RST)
           save_if_best : in  STD_LOGIC;
           del_user     : in  STD_LOGIC; -- Stergerea (apasare lunga pe BTNL)
           rst_user     : in  STD_LOGIC; -- Resetul utilizatorului curent (apasare scurta pe RST)
           user_id      : in  STD_LOGIC_VECTOR(1 downto 0);
           t_reactie    : in  STD_LOGIC_VECTOR(15 downto 0);
           rec_u1       : out STD_LOGIC_VECTOR(15 downto 0);
           rec_u2       : out STD_LOGIC_VECTOR(15 downto 0);
           rec_u3       : out STD_LOGIC_VECTOR(15 downto 0);
           rec_u4       : out STD_LOGIC_VECTOR(15 downto 0);
           t_best       : out STD_LOGIC_VECTOR(15 downto 0)
    );
end records_memory;

architecture Behavioral of records_memory is
    -- Registre interne pentru salvarea timpilor (initializati cu valoarea maxima FFFF)
    signal reg_u1 : std_logic_vector(15 downto 0) := (others => '1');
    signal reg_u2 : std_logic_vector(15 downto 0) := (others => '1');
    signal reg_u3 : std_logic_vector(15 downto 0) := (others => '1');
    signal reg_u4 : std_logic_vector(15 downto 0) := (others => '1');
begin

    -- Procesul de scriere/modificare a scorurilor din memorie
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset Global: toti utilizatorii revin la valoarea maxima (fara scor)
            reg_u1 <= (others => '1');
            reg_u2 <= (others => '1');
            reg_u3 <= (others => '1');
            reg_u4 <= (others => '1');
        elsif rising_edge(clk) then
            
            -- 1. APASARE SCURTA RST: Reseteaza doar scorul utilizatorului selectat curent
            if rst_user = '1' then
                case user_id is
                    when "00" => reg_u1 <= (others => '1');
                    when "01" => reg_u2 <= (others => '1');
                    when "10" => reg_u3 <= (others => '1');
                    when "11" => reg_u4 <= (others => '1');
                    when others => null;
                end case;

            -- 2. APASARE LUNGA BTNL (del_user): Pune scorul pe maxim (sterge din clasament)
            elsif del_user = '1' then
                case user_id is
                    when "00" => reg_u1 <= (others => '1');
                    when "01" => reg_u2 <= (others => '1');
                    when "10" => reg_u3 <= (others => '1');
                    when "11" => reg_u4 <= (others => '1');
                    when others => null;
                end case;

            -- 3. SALVARE JOC: Daca timpul curent e mai mic (mai bun) decat cel salvat, il suprascrie
            elsif save_if_best = '1' then
                case user_id is
                    when "00" =>
                        if t_reactie < reg_u1 then reg_u1 <= t_reactie; end if;
                    when "01" =>
                        if t_reactie < reg_u2 then reg_u2 <= t_reactie; end if;
                    when "10" =>
                        if t_reactie < reg_u3 then reg_u3 <= t_reactie; end if;
                    when "11" =>
                        if t_reactie < reg_u4 then reg_u4 <= t_reactie; end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- Procesul de citire: Trimite pe iesirea t_best timpul corespunzator userului selectat
    process(user_id, reg_u1, reg_u2, reg_u3, reg_u4)
    begin
        case user_id is
            when "00" => t_best <= reg_u1;
            when "01" => t_best <= reg_u2;
            when "10" => t_best <= reg_u3;
            when "11" => t_best <= reg_u4;
            when others => t_best <= (others => '1');
        end case;
    end process;

    -- Maparea iesirilor catre exterior (pentru a fi folosite de winner_eval)
    rec_u1 <= reg_u1;
    rec_u2 <= reg_u2;
    rec_u3 <= reg_u3;
    rec_u4 <= reg_u4;

end Behavioral;