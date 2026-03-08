library ieee;
use ieee.std_logic_1164.all;


entity sipo is 
generic(
    Nbit : positive := 4;
    M : positive := 4
);
port(
    si : in std_logic_vector(Nbit-1 downto 0);
    parallel_out : out std_logic_vector(M*Nbit-1 downto 0);
    start : out std_logic;
    reset : in std_logic;
    w_en : std_logic;
    clk : in std_logic
);
end entity;

architecture rtl of sipo is
    component dffN is 
    generic(
        Nbit : positive := 4
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        di : in std_logic_vector(Nbit-1 downto 0);
        do : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    type memory_array_t is array(0 to (M-1)) of std_logic_vector(Nbit-1 downto 0);
    signal fifo_mem : memory_array_t;
    signal en_int : std_logic;
    signal count : integer range 0 to M+2;
    signal genera : std_logic;      --indica se ho finito di scrivere i dati

    begin

        p_sipo : process(clk, reset)
        begin

            if reset = '1' then 
                count <= 0;
                start <='0';
                genera <= '0';
            elsif rising_edge(clk) then
                if genera = '1' then        --ottengo così un impulso di start di un ciclo di clock
                    start <= '0';
                elsif (w_en = '0' and genera = '0') then
                    en_int <= '0';           
                    if (count > 0)  then   
                        start <= '1';                 
                        genera <= '1';
                    end if;
                elsif (w_en = '1' and genera = '0') then 
                    en_int <= '1';      
                    count <= count + 1;
                    if (count >= M) then  
                        start <= '1';
                        genera <= '1';
                    end if;
                end if;
            end if;

        end process;

            g_dffN : for i in 0 to (M-1) generate
            g_first : if i=0 generate
            i_dffN : dffN 
            generic map ( Nbit => Nbit)
            port map(
               clk => clk,
               reset => reset,
               en => en_int,
               di => si,
               do => fifo_mem(i)
            );
            end generate;
            g_internal : if i > 0 and i <= (M-1) generate
            i_dffN : dffN 
            generic map ( Nbit => Nbit)
            port map(
                clk => clk,
                reset => reset,
                en => en_int,
                di => fifo_mem(i-1),
                do => fifo_mem(i)
            );
            end generate;
        end generate;

        gen_parallel_out : for i in 0 to (M-1) generate
        parallel_out ((M-i)*Nbit -1 downto (M-i-1)*Nbit) <= fifo_mem(i);
        end generate;
    end architecture;