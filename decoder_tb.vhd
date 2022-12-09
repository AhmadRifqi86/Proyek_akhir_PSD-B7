library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
--library std;
use std.textio.all;

entity decoder_tb is
end entity decoder_tb;

architecture rtl of decoder_tb is
    component decoder_B is
        port (
            clk   : in std_logic;
            strt : in std_logic;
           twobyteInput : in std_logic_vector(15 downto 0);
           abyteOut : out std_logic_vector(7 downto 0)    
        );
        end component;
    signal strt : std_logic;
    signal twobyteInput : std_logic_vector(15 downto 0); 
    signal abyteOut : std_logic_vector(7 downto 0);
    signal clk : std_logic;
    signal clockCycle : integer := 0;
    constant period : time := 50 ps;
begin
    UUT : decoder_B port map(clk, strt, twobyteInput, abyteOut);
    tb1 : process
        file text_file : text open read_mode is "stimulus_decoder.txt";
        variable fileinp : STD_LOGIC_VECTOR(15 downto 0);
        variable text_line : line;
        variable ok : boolean; 
        variable clockInp : integer;
        constant delay : time := 50 ps;
    begin 

        while not endfile(text_file) loop 
            strt <= '0';
            wait for delay;
            readline(text_file, text_line);
            if text_line.all'length = 0 or text_line.all(1) = '#' then --skip line kosong & comment
                next;
            end if;
            read(text_line, fileinp, ok);
            assert ok
                report "Read 'fileinp' failed for line: " & text_line.all
                severity failure;
            twobyteInput <= fileinp;
            read(text_line, clockInp, ok);
            assert ok 
                report "Read 'clockInp' failed for line: " &text_line.all
                severity failure;
            clockCycle <= ClockInp;
            strt<='1';
            wait for delay;
            for i in 0 to clockCycle loop
                clk<='0';
                wait for delay;
                clk<='1';
                wait for delay;
                if i = clockCycle - 1 then
                    wait for 1000 ps;
                end if;
            end loop;
        end loop;
    end process;
end architecture rtl; 