library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
--library std;
use std.textio.all;


entity tb2_encoder is
end entity tb2_encoder ;


architecture rtl of tb2_encoder is
    component encoder_B is
        port(
            eightbitInp : in std_logic_vector(7 downto 0);
            strt : in std_logic;
            clk : in std_logic;
            stateout : out std_logic_vector(2 downto 0);
            cknoteq : out std_logic;                  
            comp : out std_logic_vector(7 downto 0);  --berubah cuman pas pertama kali 
            tblFreq : out std_logic_vector(15 downto 0)
        );
    end component;

    signal eightInp : STD_LOGIC_VECTOR(7 downto 0);
    signal comp:std_logic_vector(7 downto 0);  --berubah cuman pas awal aja
    signal strt : STD_LOGIC := '1' ;
    signal ceknoteq : std_logic;   --ini gamau muncul juga
    signal clok : STD_LOGIC;
    signal tblFr : STD_LOGIC_VECTOR(15 downto 0);
    signal tmp : std_logic_vector(2 downto 0);
    file text_file : text;
    constant clk_period : time := 80 ps;

begin
    UUT : encoder_B port map(eightInp,strt,clok,tmp,ceknoteq,comp,tblFr);

        tb1 : process

        constant inpA: std_logic_vector(7 downto 0) := "10000001";
        constant inpB: std_logic_vector(7 downto 0) := "10000000";
        constant inpC: std_logic_vector(7 downto 0) := "11000001";
        constant inpD: std_logic_vector(7 downto 0) := "00000111";
        constant inpE: std_logic_vector(7 downto 0) := "00000001";
        constant tunda : time := 80 ps;
    begin
        strt <= '0';
        wait for tunda;
        strt<='1';
        wait for tunda;
        for i in 0 to 11 loop
            eightInp <= inpA;
            clok<='0';
            wait for tunda;
            clok<='1';
            wait for tunda;
        end loop;
        for j in 0 to 3 loop
            eightInp <= inpB;
            clok<='0';
            wait for tunda;
            clok<='1';
            wait for tunda;
        end loop;
        for k in 0 to 15 loop
            eightInp <= inpC;
            clok<='0';
            wait for tunda;
            clok<='1';
            wait for tunda;
        end loop;
        for x in 0 to 9 loop
            eightInp <= inpD;
            clok<='0';
            wait for tunda;
            clok<='1';
            wait for tunda;
        end loop;
    end process;

    

end architecture;