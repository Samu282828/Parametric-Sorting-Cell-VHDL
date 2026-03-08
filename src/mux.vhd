library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic(
        Nbit : positive := 2
    );
    port(
        sel : in std_logic;
        usc : out std_logic_vector(Nbit-1 downto 0);
        a : in std_logic_vector(Nbit-1 downto 0);
        b : in std_logic_vector(Nbit-1 downto 0)
        );
    end entity;
   
   
   architecture comb of mux is
begin
    process(sel, a, b)
    begin
        if sel = '1' then
            usc <= a; 
        else
            usc <= b; 
        end if;
    end process;
end architecture;