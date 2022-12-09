library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity decoder_B is
    port (
        clk   : in std_logic;
        strt : in std_logic;
       twobyteInput : in std_logic_vector(15 downto 0);
       abyteOut : out std_logic_vector(7 downto 0)
        
    );
end entity;

architecture rtl of decoder_B is

    signal bytefreq : std_logic_vector(6 downto 0);
    signal decodedOutput : std_logic_vector(7 downto 0);
    signal count : integer;
    signal tag : std_logic;

    --type stateType is (INIT,CNT,FIN,MRK);
    type stateType is (INIT,CNT,FIN,RST);
    signal statenow,nxtstate : stateType;


begin
    process(statenow,clk,strt)
begin
    case statenow is
        when INIT =>
            tag <= twobyteInput(15);
            decodedOutput <= twobyteInput(14 downto 7);
            count <= to_integer(unsigned(twobyteInput(6 downto 0)))+1;
            if(strt = '1') then
                nxtstate <= CNT;
            else nxtstate <= INIT;
            end if;
            if(clk='1') then
                statenow <= nxtstate;
            end if;
        when CNT => 
            if(tag <= '0' or count = 0) then
                -- abyteOut <= decodedOutput;
                count <= 0;
                nxtstate <= FIN;            
            else 
                count <= count-1;
                nxtstate <= CNT;
            end if;
            if(clk='1') then
                statenow <= nxtstate;
            end if;
        when FIN =>
            abyteOut<= decodedOutput;
            nxtstate <= RST;
            if(clk='1') then
                statenow <= nxtstate;
            end if;
        when RST =>
            abyteOut<= "00000000";
            nxtstate<=INIT;
            if(clk='1') then
                statenow <= nxtstate;
            end if;
    end case;
end process;

    

end architecture;