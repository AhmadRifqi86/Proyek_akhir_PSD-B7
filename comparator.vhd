library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity comparator is
    port (
        inpA : in std_logic_vector(7 downto 0);
        inpB : in std_logic_vector(7 downto 0);
        result : out std_logic
    );
end entity;


architecture rtl of comparator is
    signal tmp : std_logic_vector(7 downto 0);
begin
    tmp(0) <= inpA(0) xor inpB(0); --bit input not equal  --> res = 1
    tmp(1) <= inpA(1) xor inpB(1);
    tmp(2) <= inpA(2) xor inpB(2);
    tmp(3) <= inpA(3) xor inpB(3);
    tmp(4) <= inpA(4) xor inpB(4);
    tmp(5) <= inpA(5) xor inpB(5);
    tmp(6) <= inpA(6) xor inpB(6);
    tmp(7) <= inpA(7) xor inpB(7);

    result <= tmp(0) or tmp(1) or tmp(2) or tmp(3) or tmp(4) or tmp(5) or tmp(6) or tmp(7);

end architecture;