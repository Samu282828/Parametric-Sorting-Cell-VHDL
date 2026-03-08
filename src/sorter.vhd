library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sorter is
    generic(
        Nbit : positive := 2;
        M : positive := 4
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        data_in : in std_logic_vector(M*Nbit-1 downto 0);
        data_sorted : out std_logic_vector(M*Nbit-1 downto 0)
    );
end entity;

architecture rtl of sorter is
    signal data_array : std_logic_vector(M*Nbit-1 downto 0) ;
    signal temp_array : std_logic_vector(M*Nbit-1 downto 0) ;
    signal phase : std_logic; -- 0 = odd, 1 = even
    signal step : integer range 0 to (M+2);
    signal sorting : std_logic;
    begin
    process(clk, rst)
        variable tmp : std_logic_vector(Nbit-1 downto 0);
    begin
        if rst = '1' then
            phase <= '0';
            step <= 0;
            sorting <= '0';
            temp_array <= (others => '0');
            data_array <= (others => '0');
        elsif rising_edge(clk) then
            if start = '1' and sorting = '0' then
                sorting <= '1';
                temp_array <= data_in; -- Inizializza temp_array con i dati in ingresso
                step <= 0;
                phase <= '0';
            end if;

            if sorting = '1' then
                if phase = '0' then -- Even phase
                    for i in 0 to M-2 loop
                        if i mod 2 = 0 then
                            if unsigned(temp_array((i+1)*Nbit-1 downto i*Nbit)) > unsigned(temp_array((i+2)*Nbit-1 downto (i+1)*Nbit)) then
                                -- Swap
                                tmp := temp_array((i+1)*Nbit-1 downto i*Nbit);
                                temp_array((i+1)*Nbit-1 downto i*Nbit) <= temp_array((i+2)*Nbit-1 downto (i+1)*Nbit);
                                temp_array((i+2)*Nbit-1 downto (i+1)*Nbit) <= tmp;
                            end if;
                        end if;
                    end loop;
                    phase <= '1';
                else -- Odd phase
                    for i in 1 to M-2 loop
                        if i mod 2 = 1 then
                            if unsigned(temp_array((i+1)*Nbit-1 downto i*Nbit)) > unsigned(temp_array((i+2)*Nbit-1 downto (i+1)*Nbit)) then
                                -- Swap
                                tmp := temp_array((i+1)*Nbit-1 downto i*Nbit);
                                temp_array((i+1)*Nbit-1 downto i*Nbit) <= temp_array((i+2)*Nbit-1 downto (i+1)*Nbit);
                                temp_array((i+2)*Nbit-1 downto (i+1)*Nbit) <= tmp;
                            end if;
                        end if;
                    end loop;
                    phase <= '0';
                end if;

                step <= step + 1;
                if step >= M then
                    sorting <= '0';
                    data_array <= temp_array;     -- Copia i dati ordinati in data_array
                end if;
            end if;
        end if;
    end process;

    gen_reverse : for i in 0 to M-1 generate
    data_sorted((i+1)*Nbit-1 downto i*Nbit) <= data_array((M-1-i+1)*Nbit-1 downto (M-1-i)*Nbit);
    end generate;
end architecture;