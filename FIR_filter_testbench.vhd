--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:56:06 05/27/2021
-- Design Name:   
-- Module Name:   E:/DATA/learn_fpga/FIR_filter/FIR_filter_testbench.vhd
-- Project Name:  FIR_filter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FIR_filter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE STD.TEXTIO.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FIR_filter_testbench IS
END FIR_filter_testbench;
 
ARCHITECTURE behavior OF FIR_filter_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FIR_filter
	 generic (  
           input_width          : integer     :=8               ; -- set input width by user  
           output_width     : integer     :=16               ; -- set output width by user  
           coef_width          : integer     :=8               ; -- set coefficient width by user  
           tap                    : integer     :=11               ; -- set filter order  
           guard               : integer     :=4)                    ; -- log2(tap)+1  
    PORT(
         Din : IN  std_logic_vector(7 downto 0);
         Clk : IN  std_logic;
         reset : IN  std_logic;
         Dout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(7 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal output_ready     : std_logic:='0';                                

	signal input: std_logic_vector(7 downto 0);  
	file my_input : TEXT open READ_MODE is "input101.txt";  
	file my_output : TEXT open WRITE_MODE is "output101_functional_sim.txt";
 	--Outputs
   signal Dout : std_logic_vector(15 downto 0);

   -- Clock period definitions

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FIR_filter 
	generic map(  
                          input_width          =>     8,  
           output_width     =>     16,  
           coef_width          =>     8,  
           tap                 =>     11,  
           guard               =>     0) 
	PORT MAP (
          Din => Din,
          Clk => Clk,
          reset => reset,
          Dout => Dout
        );

   -- Clock process definitions
   Clk_process :process(clk)
   begin
		Clk          <= not Clk after 10 ns; 
   end process;
	reset     <= '1', '1' after 100 ns, '0' after 503 ns;

   -- Stimulus process
   process(clk)  
           variable my_input_line : LINE;  
           variable input1: integer;  
           begin  
                if reset ='1' then  
                     Din <= (others=> '0');  
                     input <= (others=> '0');  
                     output_ready <= '1';  
                elsif rising_edge(clk) then                      
                     readline(my_input, my_input_line);  
                     read(my_input_line,input1);  
                     Din <= std_logic_vector(to_signed(input1, 8));  
                     --Din<=input(7 downto 0);  
                     output_ready <= '1';  
                end if;  
           end process;                      
           process(clk)  
           variable my_output_line : LINE;  
           variable input1: integer;  
           begin  
                if falling_edge(clk) then  
                     if output_ready ='1' then  
                          write(my_output_line, to_integer(signed(Dout)));  
                          writeline(my_output,my_output_line);  
                     end if;  
                end if;  
           end process;   

END;
