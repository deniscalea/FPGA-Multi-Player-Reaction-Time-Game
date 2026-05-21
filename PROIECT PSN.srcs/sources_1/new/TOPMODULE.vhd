library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_GAME is
    Port ( 
        CLK        : in  STD_LOGIC;
        RST        : in  STD_LOGIC;
        START      : in  STD_LOGIC;
        REACT      : in  STD_LOGIC;
        SKIP       : in  STD_LOGIC;
        BTNL       : in  STD_LOGIC;
        LED_SEMNAL : out STD_LOGIC;
        LED_FAULT  : out STD_LOGIC;
        AN         : out STD_LOGIC_VECTOR (7 downto 0);
        SEG        : out STD_LOGIC_VECTOR (6 downto 0)
    );
end TOP_GAME;

architecture Structural of TOP_GAME is
    signal s_start_deb, s_react_deb, s_skip_deb : std_logic;
    signal s_rst_global, s_rst_user             : std_logic; 
    signal s_btnl_short, s_btnl_long            : std_logic; 
    signal s_clk_1ms                            : std_logic;
    
    signal s_t_random, s_t_total, s_t_reactie : std_logic_vector(15 downto 0);
    signal s_t_best, s_t_winner               : std_logic_vector(15 downto 0);
    
    signal s_time_done, s_runda_done, s_game_done : std_logic;
    signal s_en_random, s_en_count, s_rst_count   : std_logic;
    signal s_save_if_best, s_show_winner          : std_logic;
    signal s_inc_round, s_inc_user, s_view_mode   : std_logic;
    signal s_led_semnal, s_led_fault              : std_logic;
    
    signal s_user_id, s_winner_id : std_logic_vector(1 downto 0);
    signal s_round_id             : std_logic_vector(2 downto 0);
    signal s_rec_u1, s_rec_u2, s_rec_u3, s_rec_u4 : std_logic_vector(15 downto 0);

    component reset_ctrl is 
        port(clk, rst_in: in std_logic; rst_user, rst_global: out std_logic); 
    end component;

    component btn_press_ctrl is 
        port(clk, btn_in: in std_logic; short_press, long_press: out std_logic); 
    end component;

    component freq_div is 
        port(clk, rst: in std_logic; clk_1ms: out std_logic); 
    end component;
    
    component debouncer is 
        port(clk, btn_in: in std_logic; btn_out: out std_logic); 
    end component;
    
    component rand_reg is 
        port(clk, en_random: in std_logic; t_random: out std_logic_vector(15 downto 0)); 
    end component;
    
    component MAIN_COUNT is 
        port(clk, rst_cnt, en_cnt, clk_1ms: in std_logic; t_total: out std_logic_vector(15 downto 0)); 
    end component;
    
    component comparator is 
        port(t_total, t_random: in std_logic_vector(15 downto 0); led_semnal: out std_logic); 
    end component;
    
    component Scazator is 
        port(t_total, t_random: in std_logic_vector(15 downto 0); t_reactie: out std_logic_vector(15 downto 0)); 
    end component;
    
    component records_memory is 
        port(clk, rst, save_if_best, del_user, rst_user: in std_logic; user_id: in std_logic_vector(1 downto 0); t_reactie: in std_logic_vector(15 downto 0); rec_u1, rec_u2, rec_u3, rec_u4: out std_logic_vector(15 downto 0); t_best: out std_logic_vector(15 downto 0)); 
    end component;
    
    component game_counters is 
        port(clk, rst, rst_user, inc_round, inc_user, del_user: in std_logic; user_id: out std_logic_vector(1 downto 0); round_id: out std_logic_vector(2 downto 0); runda_done, game_done: out std_logic); 
    end component;
    
    component winner_eval is 
        port(show_winner: in std_logic; rec_u1, rec_u2, rec_u3, rec_u4: in std_logic_vector(15 downto 0); winner_id: out std_logic_vector(1 downto 0); t_winner: out std_logic_vector(15 downto 0)); 
    end component;
    
    component display_ctrl is 
        port(clk, rst, view_mode, time_done, led_fault: in std_logic; t_reactie, t_best, t_winner: in std_logic_vector(15 downto 0); user_id, winner_id: in std_logic_vector(1 downto 0); round_id: in std_logic_vector(2 downto 0); an: out STD_LOGIC_VECTOR (7 downto 0); seg: out STD_LOGIC_VECTOR (6 downto 0)); 
    end component;
    
    component UC is 
        port(clk, rst, rst_user, start, react, skip, del_user, time_done, runda_done, game_done, btnl_short: in std_logic; 
             en_random, en_count, rst_count, save_if_best, inc_round, inc_user, show_winner, view_mode, led_semnal, led_fault: out std_logic); 
    end component;
    
begin
    U0: reset_ctrl     port map(CLK, RST, s_rst_user, s_rst_global); 
    U1: btn_press_ctrl port map(CLK, BTNL, s_btnl_short, s_btnl_long);
    U2: freq_div       port map(CLK, s_rst_global, s_clk_1ms);
    
    U3: debouncer      port map(CLK, START, s_start_deb);
    U4: debouncer      port map(CLK, REACT, s_react_deb);
    U5: debouncer      port map(CLK, SKIP, s_skip_deb);
    
    U6: rand_reg       port map(CLK, s_en_random, s_t_random);
    U7: MAIN_COUNT     port map(CLK, s_rst_count, s_en_count, s_clk_1ms, s_t_total);
    U8: comparator     port map(s_t_total, s_t_random, s_time_done);
    U9: Scazator       port map(s_t_total, s_t_random, s_t_reactie);
    
    U10: records_memory port map(
        clk          => CLK, 
        rst          => s_rst_global, 
        save_if_best => s_save_if_best, 
        del_user     => s_btnl_long, 
        rst_user     => s_rst_user, 
        user_id      => s_user_id, 
        t_reactie    => s_t_reactie, 
        rec_u1       => s_rec_u1, 
        rec_u2       => s_rec_u2, 
        rec_u3       => s_rec_u3, 
        rec_u4       => s_rec_u4, 
        t_best       => s_t_best
    );
    
    U11: game_counters port map(
        clk        => CLK, 
        rst        => s_rst_global, 
        rst_user   => s_rst_user, 
        inc_round  => s_inc_round, 
        inc_user   => s_inc_user, 
        del_user   => s_btnl_long, 
        user_id    => s_user_id, 
        round_id   => s_round_id, 
        runda_done => s_runda_done, 
        game_done  => s_game_done
    );
    
    U12: winner_eval  port map(s_show_winner, s_rec_u1, s_rec_u2, s_rec_u3, s_rec_u4, s_winner_id, s_t_winner);
    
    U13: display_ctrl port map(CLK, s_rst_global, s_view_mode, s_time_done, s_led_fault, s_t_reactie, s_t_best, s_t_winner, s_user_id, s_winner_id, s_round_id, AN, SEG);
    
    U14: UC port map(
        clk          => CLK, 
        rst          => s_rst_global, 
        rst_user     => s_rst_user,
        start        => s_start_deb, 
        react        => s_react_deb, 
        skip         => s_skip_deb, 
        del_user     => s_btnl_long, 
        time_done    => s_time_done, 
        runda_done   => s_runda_done, 
        game_done    => s_game_done, 
        btnl_short   => s_btnl_short, 
        en_random    => s_en_random, 
        en_count     => s_en_count, 
        rst_count    => s_rst_count, 
        save_if_best => s_save_if_best, 
        inc_round    => s_inc_round, 
        inc_user     => s_inc_user, 
        show_winner  => s_show_winner, 
        view_mode    => s_view_mode, 
        led_semnal   => s_led_semnal, 
        led_fault    => s_led_fault
    );

    LED_SEMNAL <= s_led_semnal;
    LED_FAULT  <= s_led_fault;
end Structural;