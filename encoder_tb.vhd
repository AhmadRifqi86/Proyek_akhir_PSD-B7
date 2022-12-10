library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
--library std;
use std.textio.all;


entity encoder_tb is
end entity encoder_tb ;


architecture rtl of encoder_tb is
    component encoder_B is
        port(
            eightbitInp : in std_logic_vector(7 downto 0); --input 8-bit
            strt : in std_logic; --start encoding
            clk : in std_logic; --input clock
            stateout : out std_logic_vector(2 downto 0); --state condition
            cknoteq : out std_logic;                  
            comp : out std_logic_vector(7 downto 0);  --berubah cuman pas pertama kali 
            tblFreq : out std_logic_vector(15 downto 0) --output 16-bit
        );
    end component;

    signal eightInp : STD_LOGIC_VECTOR(7 downto 0); --signal input 8-bit
    signal comp:std_logic_vector(7 downto 0);   --signal comparator
    signal strt : STD_LOGIC := '1' ; --signal toggle start
    signal ceknoteq : std_logic;   
    signal clok : STD_LOGIC;
    signal tblFr : STD_LOGIC_VECTOR(15 downto 0);
    signal tmp : std_logic_vector(2 downto 0);
    signal clockCycle : integer := 0; --signal jumlah clock cycle

begin
    UUT : encoder_B port map(eightInp,strt,clok,tmp,ceknoteq,comp,tblFr); --port mapping ke component

        tb1 : process
        file text_file : text open read_mode is "stimulus_encoder.txt"; --filepath file yang akan dibaca
        variable fileinp : STD_LOGIC_VECTOR(7 downto 0); --variabel untuk menyimpan input dari file
        variable text_line : line; --iterator line pada file
        variable ok : boolean; --memastikan file berhasil dibaca
        variable clockInp : integer; --membaca clock cycle dari file
        constant tunda : time := 80 ps; --interval delay
    begin
        while not endfile(text_file) loop 
            strt <= '0';
            readline(text_file, text_line);
            if text_line.all'length = 0 or text_line.all(1) = '#' then --skip line kosong & comment
                next;
            end if;
            read(text_line, fileinp, ok); --membaca 8-bit input dari file
            assert ok
                report "Read 'fileinp' failed for line: " & text_line.all --report jika line pada file gagal dibaca
                severity failure; --tingkat severity
            eightInp <= fileinp; --assignment input dari file ke port eightInp
            read(text_line, clockInp, ok); --membaca jumlah clock cycle dari file
            assert ok 
                report "Read 'fileinp' failed for line: " &text_line.all --report jika line pada file gagal dibaca
                severity failure; --tingkat severity
            clockCycle <= clockInp; --assignment input clock cycle
            strt<='1';
            wait for tunda;
            for i in 0 to clockCycle loop --proses looping encoding
                clok<='0';
                wait for tunda;
                if(i = 2) then
                    wait for 500 ps; --interval delay lebih lama agar output dapat lebih terlihat jelas
                end if;
                clok<='1';
                wait for tunda;
                
            end loop;
        end loop;
    end process;
end architecture;