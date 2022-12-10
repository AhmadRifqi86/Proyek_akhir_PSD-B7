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
    component decoder_B is --component decoder
        port (
            clk   : in std_logic; --clock input
            strt : in std_logic; --start decoding
           twobyteInput : in std_logic_vector(15 downto 0); --input 16 bit
           abyteOut : out std_logic_vector(7 downto 0)    --input 8 bit
        );
        end component;
    signal strt : std_logic; --start decoding
    signal twobyteInput : std_logic_vector(15 downto 0); 
    signal abyteOut : std_logic_vector(7 downto 0);
    signal clk : std_logic := '0';
    signal count : integer;
begin
    UUT : decoder_B port map(clk, strt, twobyteInput, abyteOut);
    tb1 : process
        file text_file : text open read_mode is "stimulus_decoder2.txt"; --reading path file dan mode read
        variable fileinp : STD_LOGIC_VECTOR(15 downto 0); --membaca input 15 bit dari file txt
        variable text_line : line; --iterator text line
        variable ok : boolean; --memastikan file dapat dibaca
        constant delay : time := 10 ns; --interval waktu delay
    begin 
        while not endfile(text_file) loop
            strt <= '0';
            wait for 100 ns;  
            wait for delay;
            readline(text_file, text_line);
            if text_line.all'length = 0 or text_line.all(1) = '#' then --skip line kosong & comment
                next;
            end if;
            read(text_line, fileinp, ok); --membaca input dari file
            assert ok
                report "Read 'fileinp' failed for line: " & text_line.all --report jika gagal membaca input dari file
                severity failure;
            strt<='1';
            twobyteInput <= fileinp; --memasukan input dari file ke port twobyteInput
            report "file input: " &integer'image(to_integer(unsigned(fileinp(6 downto 0)))); 
            strt<='0';
            wait for delay;
            strt<='1'; 
            wait for 100 ns; --delay lebih lama agar output dapat terlihat lebih jelas
            count <= to_integer((unsigned((fileinp(6 downto 0))))/2); --clock cycle = ((6 LSB dari 15-bit input)/2) - 1
            wait for delay;
            strt<='0';
            wait for delay;
            wait for delay;
            strt <='1';
            for i in 0 to count loop --proses looping decoding
                wait for delay;
                clk<='0';
                wait for delay;
                clk<='1';
                wait for delay;
            end loop;
            wait for delay;
        end loop;
    end process;
end architecture rtl; 