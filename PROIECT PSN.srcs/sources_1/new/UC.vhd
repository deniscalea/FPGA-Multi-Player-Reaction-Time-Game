library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is 
    Port ( clk, rst, rst_user, start, react, skip, del_user, time_done, runda_done, game_done, btnl_short : in STD_LOGIC;
           en_random, en_count, rst_count, save_if_best, inc_round, inc_user, show_winner, view_mode, led_semnal, led_fault : out STD_LOGIC);
end UC;

architecture Behavioral of UC is
    type state_type is (IDLE, AUTO_START, WAIT_RANDOM, PLAY, FAULT, EVAL, RESTART_ROUND, WINNER, VIEW_RECORDS, WAIT_RELEASE, FORCE_JUMP);
    signal state_reg, state_next : state_type;
    signal delay_cnt : integer range 0 to 50000000 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then 
            state_reg <= IDLE; 
            delay_cnt <= 0;
        elsif rising_edge(clk) then
            if rst_user = '1' and state_reg /= WINNER and state_reg /= VIEW_RECORDS and state_reg /= WAIT_RELEASE and state_reg /= FORCE_JUMP then  
                state_reg <= AUTO_START; 
                delay_cnt <= 0;
            elsif state_reg = FAULT or state_reg = EVAL or state_reg = WINNER then
                if state_reg = WINNER then
                    delay_cnt <= 0;
                    state_reg <= state_next;
                else
                    delay_cnt <= delay_cnt + 1;
                    if delay_cnt = 50000000 then 
                        state_reg <= state_next; 
                        delay_cnt <= 0; 
                    end if;
                end if;
            else 
                state_reg <= state_next; 
                delay_cnt <= 0; 
            end if;
        end if;
    end process;

    process(state_reg, start, react, skip, del_user, time_done, runda_done, game_done, btnl_short)
    begin
        en_random <= '0'; en_count <= '0'; rst_count <= '1'; 
        save_if_best <= '0'; inc_round <= '0'; inc_user <= '0';
        show_winner <= '0'; view_mode <= '0'; led_semnal <= '0'; led_fault <= '0';
        state_next <= state_reg;
        
        case state_reg is
            when IDLE => 
                rst_count <= '1'; en_random <= '1'; 
                if start = '1' then state_next <= WAIT_RANDOM; 
                elsif btnl_short = '1' then state_next <= VIEW_RECORDS;
                end if;

            when AUTO_START =>
                rst_count <= '1'; en_random <= '1';
                state_next <= WAIT_RANDOM;
                
            when WAIT_RANDOM => 
                rst_count <= '0'; en_count <= '1'; 
                if del_user = '1' then state_next <= IDLE;
                elsif react = '1' then state_next <= FAULT; 
                elsif skip = '1' then state_next <= RESTART_ROUND; 
                elsif time_done = '1' then state_next <= PLAY; 
                end if;
                
            when PLAY => 
                rst_count <= '0'; led_semnal <= '1'; en_count <= '1'; 
                if del_user = '1' then state_next <= IDLE;
                elsif react = '1' then save_if_best <= '1'; state_next <= EVAL; 
                elsif skip = '1' then state_next <= RESTART_ROUND; 
                end if;
                
            when FAULT => led_fault <= '1'; state_next <= EVAL;
            when EVAL => state_next <= RESTART_ROUND;
                
            when RESTART_ROUND => 
                if game_done = '1' then state_next <= WINNER; 
                else 
                    inc_round <= '1'; en_random <= '1';
                    if runda_done = '1' then inc_user <= '1'; end if; 
                    state_next <= WAIT_RANDOM; 
                end if;
                
            when WINNER => 
                show_winner <= '1'; 
                if btnl_short = '1' then 
                    inc_user <= '1'; -- <--- REZOLVAREA AICI! Forteaza saltul la U1.
                    state_next <= VIEW_RECORDS; 
                elsif start = '1' then 
                    state_next <= IDLE; 
                end if;
                
            when VIEW_RECORDS => 
                view_mode <= '1'; 
                if start = '1' then 
                    state_next <= IDLE; 
                elsif del_user = '1' then
                    inc_user <= '1';
                    state_next <= FORCE_JUMP;
                elsif btnl_short = '1' then 
                    inc_user <= '1'; 
                    state_next <= WAIT_RELEASE; 
                end if;

            when FORCE_JUMP =>
                view_mode <= '1';
                if del_user = '0' and btnl_short = '0' then
                    state_next <= VIEW_RECORDS;
                end if;

            when WAIT_RELEASE =>
                view_mode <= '1';
                if btnl_short = '0' then 
                    state_next <= VIEW_RECORDS; 
                elsif start = '1' then 
                    state_next <= IDLE;
                end if;
        end case;
    end process;
end Behavioral;