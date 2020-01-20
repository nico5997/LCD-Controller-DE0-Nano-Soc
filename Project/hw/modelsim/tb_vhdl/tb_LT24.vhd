library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LT24 is
end tb_LT24;

architecture test_LT of tb_LT24 is
 		constant TIME_DELTA     : time := 20 ns;
		signal clk              : std_logic;
		signal Reset            : std_logic := '1';
		
		signal AS_CS            : std_logic;
		signal AS_wr            : std_logic;
		signal AS_WData         : std_logic_vector(31 downto 0);
		signal AS_WaitRq        : std_logic;
		
		signal rdreq	 	 : std_logic;
		signal q		 :  std_logic_vector(15 DOWNTO 0);
		signal rdusedw		   :  STD_LOGIC_VECTOR(9 DOWNTO 0);
		

		signal CSX		  :  std_logic;
		signal DCX		        :  std_logic;
		signal WRX		        :  std_logic;
		signal D	              :  std_logic_vector(15 downto 0);
		
		signal LCD_Config		  :  std_logic_vector(1 downto 0);
		signal state1                  : string(1 to 13);
		signal bit1_value		:std_logic_vector(7 downto 0);

begin

dut2 : entity work.LT24 
port map (
 	clk => clk,
	Reset => Reset,           
	AS_CS  =>  AS_CS  ,     
	AS_wr  =>   AS_wr,      
	AS_WData  =>  AS_WData ,   
	AS_WaitRq =>  AS_WaitRq,    
		
	rdreq	=> 	rdreq,
	q	=>	q, 
	rdusedw	=>	rdusedw,  
		
        CSX	=>	CSX, 
	DCX	=>	 DCX,      
	WRX	=>	 WRX,      
	D	=>       D ,     
		
	LCD_Config	=> LCD_Config,
	state1 =>state1,
	bit1_value => bit1_value
);
clk_generation: process
begin
clk <= '1';
wait for TIME_DELTA/2;
clk <= '0';
wait for TIME_DELTA/2;
end process clk_generation;
simulation: process
begin
Reset <= '0';
wait for TIME_DELTA;
Reset <= '1';
AS_CS <= '1';
AS_wr <= '0';
wait for TIME_DELTA;
AS_WData <= X"00000000";
wait for 2*TIME_DELTA;
AS_WData <= X"0000002C";
AS_wr <= '1';


q <="0010101011001010";
rdusedw	<= "0000000010";
wait for TIME_DELTA;


wait for TIME_DELTA;

wait for 2*TIME_DELTA;
AS_wr <= '0';
--AS_WData <= X"00100035";
wait for TIME_DELTA;




wait for 4*TIME_DELTA;
AS_wr <= '0';
wait for 4*TIME_DELTA;
end process simulation;

end architecture test_LT;

