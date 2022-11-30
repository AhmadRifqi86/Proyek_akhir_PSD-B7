library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity encoder_B is
    port (
        eightbitInp : in std_logic_vector(7 downto 0);
        strt : in std_logic;
        clk: in std_logic;
        stateout: out std_logic_vector(2 downto 0);  --ini nanti hapus
        cknoteq : out std_logic;                     --ini nanti hapus
        comp : out std_logic_vector(7 downto 0);     --ini nanti hapus
        tblFreq : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of encoder_B is
    
    -- signal long : integer := 1;
    -- signal idx : integer := 0;
    -- signal prtctr : integer :=0;

    component comparator is
        port (
            inpA : in std_logic_vector(7 downto 0);
            inpB : in std_logic_vector(7 downto 0);
            result : out std_logic
        );
    end component;

    signal bufferinp : std_logic_vector(7 downto 0);
    signal cmpring : std_logic_vector(7 downto 0);
    signal bufferfreq : std_logic_vector(6 downto 0);  --7 bit
    signal noteq : std_logic;
    signal tag :std_logic;
    signal count : integer := 1;

    type stateType is (INIT,CMP,FIN,MRK);
    signal statenow,nxtstate : stateType;

    -- type tblout is array (0 to long-1) of std_logic_vector(13 downto 0);  --14
    -- signal outarr : tblout;
begin
        cmpcomb : comparator port map(cmpring,bufferinp,noteq);

       

        process(statenow,cmpring,noteq,clk)
        begin
            case statenow is
                when INIT => --INIT adalah fase awal untuk me-reset counter, bufferFreq dan bufferInp
                    count <= 1;
                    bufferinp <= eightbitInp;
                    bufferfreq <= "0000000";
                    stateout <= "000";
                    if (strt = '1') then 
                        nxtstate<=CMP;
                    else nxtstate <= INIT;
                    end if;
                    if(falling_edge(clk)) then statenow<=nxtstate;
                    end if;
                when CMP => --CMP adalah fase membandingkan input yang baru masuk dengan buffer
                --bufferinp<=eightbitInp;
                --cmpring adalah input buffer yang berasal dari luar
                --bufferInp adalah input buffer yang tetap selama tidak ada perubahan dari luar
                --compare equality here
                    cmpring <= eightbitInp;
                    cknoteq<=noteq;
                    comp<=cmpring;
                    stateout <= "001";
                    if(noteq = '1') then
                        nxtstate <= MRK;
                        --hlt <='1';
                    elsif (noteq = '0') then
                        count <= count+1;
                        nxtstate<=CMP;
                        --nxtstate <= CNT;
                    end if;
                    if(falling_edge(clk) ) then statenow<=nxtstate;
                    end if;
                when MRK=> --MRK masang tag untuk menandai apakah suatu nilai byte hanya berjumlah 1
                    stateout <= "011";
                    cknoteq<=noteq;
                    comp<=cmpring;
                    if (count = 1) then
                        tag <= '0';
                    else tag <= '1'; 
                    end if;
                    bufferfreq <= std_logic_vector(to_unsigned(count-1,bufferfreq'length));
                    nxtstate<=FIN;
                    if(falling_edge(clk) ) then statenow<=nxtstate;
                    end if;
                when FIN => 
                    stateout <= "100";
                    cknoteq<=noteq;
                    comp<=cmpring;
                    tblFreq <= tag & bufferinp & bufferfreq;    
                    nxtstate <= INIT; 
                    if(falling_edge(clk) ) then statenow<=nxtstate;
                    end if;  
            end case;
        end process;

    -- process(clk)
    -- begin
    --     if(falling_edge(clk) and clk'event) then statenow<=nxtstate;
    -- end if;
    -- end process;
    


end architecture;