----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:36:36 05/27/2021 
-- Design Name: 
-- Module Name:    FIR_filter - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIR_filter is
	Generic (input_width : integer     :=8;-- set input width by user  
           output_width : integer     :=16;-- set output width by user  
           coef_width   : integer     :=8;-- set coefficient width by user  
           tap          : integer     :=11;-- set filter order  
           guard        : integer     :=0); --log2(tap)+1
    Port (Din      : in      std_logic_vector(input_width-1 downto 0)     ;-- input data  
			 Clk      : in      std_logic                                             ;-- input clk  
			 reset    : in      std_logic                                             ;-- input reset  
			 Dout     : out      std_logic_vector(output_width-1 downto 0))     ;-- output data  end FIR_filter;
end FIR_filter;


architecture Behavioral of FIR_filter is

component N_bit_Reg   
 generic (  
           input_width: integer     :=8  
          );  
   port(  
    Q : out std_logic_vector(input_width-1 downto 0);     
    Clk :in std_logic;    
    reset :in std_logic;   
    D :in std_logic_vector(input_width-1 downto 0)    
   );  
 end component;
 

 type Coeficient_type is array (1 to tap) of std_logic_vector(coef_width-1 downto 0);  
 -----------------------------------FIR filter coefficients----------------------------------------------------------------  
 constant coeficient: coeficient_type :=   
                               (     X"F1",  
                                    X"F3",  
                                    X"07",  
                                    X"26",  
                                    X"42",  
                                    X"4E",  
                                    X"42",  
                                    X"26",  
                                    X"07",  
                                    X"F3",  
                                    X"F1"                                     
                                    );                                         
 ----------------------------------------------------------------------------------------------                                     
 type shift_reg_type is array (0 to tap-1) of std_logic_vector(input_width-1 downto 0);  
 signal shift_reg : shift_reg_type;  
 type mult_type is array (0 to tap-1) of std_logic_vector(input_width+coef_width-1 downto 0);  
 signal mult : mult_type;  
 type ADD_type is array (0 to tap-1) of std_logic_vector(input_width+coef_width-1 downto 0);  
 signal ADD: ADD_type;  
 begin  
 
 
    
			  shift_reg(0)     <= Din;  
           mult(0)<= Din*coeficient(1);  
           ADD(0)<= Din*coeficient(1);  
           GEN_FIR:  
           for i in 0 to tap-2 
			  generate  
           begin  
                 -- N-bit reg unit  
                 N_bit_Reg_unit : N_bit_Reg 
					  generic map (input_width => 8)   
                 port map ( Clk => Clk,   
                                    reset => reset,  
                                    D => shift_reg(i),  
                                    Q => shift_reg(i+1)  
                                    );       
                -- filter multiplication  
                mult(i+1)<= shift_reg(i+1)*coeficient(i+2);  
                -- filter conbinational addition  
                ADD(i+1)<=ADD(i)+mult(i+1);  
           end generate GEN_FIR;  
           Dout <= ADD(tap-1);  
 end Architecture;  


