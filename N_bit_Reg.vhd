----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:22 05/27/2021 
-- Design Name: 
-- Module Name:    N_bit_Reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity N_bit_Reg is
generic (  
           input_width          : integer     :=8  
           );  
port(  
    Q : out std_logic_vector(input_width-1 downto 0);    
    Clk :in std_logic;    
    reset :in std_logic;  
    D :in std_logic_vector(input_width-1 downto 0)    
   );  
end N_bit_Reg;

architecture Behavioral of N_bit_Reg is

begin
process(Clk,reset)  
      begin   
           if (reset = '1') then  
                Q <= (others => '0');  
        elsif ( rising_edge(Clk) ) then  
                Q <= D;   
       end if;      
      end process;   

end Behavioral;

