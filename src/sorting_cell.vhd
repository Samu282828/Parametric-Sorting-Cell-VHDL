library ieee;
use ieee.std_logic_1164.all;

entity sorting_cell is 
generic(
    Nbit : positive := 4;
    M : positive := 4
);
port(
    clk : in std_logic;
    write_enable : in std_logic;
    rst : in std_logic;
    Symbol_in : in std_logic_vector(Nbit-1 downto 0);
    Read_symbols : in std_logic;
    Symbol_out : out std_logic_vector(Nbit-1 downto 0)
);
end entity;

architecture rtl of sorting_cell is
    component sipo is
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
    end component;                 

    component sorter is
    generic(
        Nbit : positive := 4;
        M : positive := 4
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        data_in : in std_logic_vector(M*Nbit-1 downto 0);
        data_sorted : out std_logic_vector(M*Nbit-1 downto 0)
    );
    end component; 

    component piso is
        generic(
        Nbit : positive := 4;
        M : positive := 4
    );
    port(
        data : in std_logic_vector(M*Nbit-1 downto 0); 
        serial_out : out std_logic_vector(Nbit-1 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        sel : in std_logic
    );
    end component;

    signal sipo_out : std_logic_vector(M*Nbit-1 downto 0);
    signal sorter_out : std_logic_vector(M*Nbit-1 downto 0);
    signal start2_out : std_logic;

    begin
        i_sipo : sipo
        generic map ( Nbit => Nbit)
        port map(
        si => Symbol_in,
        parallel_out => sipo_out,
        reset => rst,
        start => start2_out,
        w_en  => write_enable,
        clk => clk
        );

    i_sorter : sorter
    generic map ( Nbit => Nbit)
    port map(
        clk => clk,
        rst => rst,
        start => start2_out,
        data_in => sipo_out,
        data_sorted => sorter_out
        );

    i_piso : piso
    generic map ( Nbit => Nbit)
    port map(
        data => sorter_out,
        serial_out => Symbol_out,
        reset => rst,
        clk => clk,
        sel => Read_symbols
    );


    end architecture;
