library ieee;
use ieee.std_logic_1164.all;

entity piso is 
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
end entity;

architecture rtl of piso is
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

    component mux is
        generic(
        Nbit : positive := 4
    );
    port(
        sel : in std_logic;
        usc : out std_logic_vector(Nbit-1 downto 0);
        a : in std_logic_vector(Nbit-1 downto 0);
        b : in std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    signal ff_out : std_logic_vector(M*Nbit-1 downto 0); -- Collegamenti tra i flip-flop
    signal mux_out : std_logic_vector(M*Nbit-1 downto 0); -- Uscite dei mux
    constant dummy_b1 : std_logic_vector(Nbit-1 downto 0) := (others => '0');

    begin
        g : for i in 0 to M-1 generate
        g_first : if i = 0 generate
        i_mux : mux
        generic map ( Nbit => Nbit)
        port map(
            sel => sel,
            usc => mux_out((i+1)*Nbit-1 downto i*Nbit),
            a => data((i+1)*Nbit-1 downto i*Nbit),
            b => dummy_b1 
        );
        i_dffN : dffN 
        generic map ( Nbit => Nbit)
        port map(
            clk => clk,
            reset => reset,
            en => '1',
            di => mux_out((i+1)*Nbit-1 downto i*Nbit),
            do => ff_out((i+1)*Nbit-1 downto i*Nbit)
        );
        end generate;

        g_internal : if i > 0 and i < M-1 generate
        i_mux : mux
        generic map ( Nbit => Nbit)
        port map(
            sel => sel,
            a => data((i+1)*Nbit-1 downto i*Nbit),
            b => ff_out(i*Nbit-1 downto (i-1)*Nbit),
            usc => mux_out((i+1)*Nbit-1 downto i*Nbit)
        );
        i_dffN : dffN 
        generic map ( Nbit => Nbit)
        port map(
            clk => clk,
            reset => reset,
            en => '1',
            di => mux_out((i+1)*Nbit-1 downto i*Nbit),
            do => ff_out((i+1)*Nbit-1 downto i*Nbit)
        );
        end generate;

        g_last : if i = M-1 generate
        i_mux : mux 
        generic map ( Nbit => Nbit)
        port map(
            sel => sel,
            a => data((i+1)*Nbit-1 downto i*Nbit),
            b => ff_out(i*Nbit-1 downto (i-1)*Nbit),
            usc => mux_out((i+1)*Nbit-1 downto i*Nbit)
        );
        i_dffN : dffN
        generic map ( Nbit => Nbit)
        port map(
            clk => clk,
            reset => reset,
            en => '1',
            di => mux_out((i+1)*Nbit-1 downto i*Nbit),
            do => ff_out((i+1)*Nbit-1 downto i*Nbit)
        );
        serial_out <= ff_out((i+1)*Nbit-1 downto i*Nbit);
        end generate;
        end generate;
        end architecture;
    
