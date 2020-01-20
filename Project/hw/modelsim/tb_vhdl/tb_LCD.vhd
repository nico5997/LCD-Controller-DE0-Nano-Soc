library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LCD is
end tb_LCD;


architecture test4 of tb_LCD is
			constant TIME_DELTA     : time := 20 ns;
		   signal clk              :  std_logic;
			signal Reset            :  std_logic;
			
			signal AS_Add           :  std_logic_vector(2 downto 0);
		   signal AS_CS            :  std_logic;
		   signal AS_wr            :  std_logic;
		   signal AS_WData         :  std_logic_vector(31 downto 0);
		   signal AS_Rd            :  std_logic;
		   signal AS_RData         :  std_logic_vector(31 downto 0);
		   signal AS_WaitRq        :  std_logic;
			
			signal AM_Add           :  std_logic_vector(31 downto 0);
			signal AM_BE            :  std_logic_vector(3 downto 0);
			signal AM_Rd            :  std_logic;
			signal AM_RData         : std_logic_vector(31 downto 0);
			signal AM_WaitRq        : std_logic;
			signal AM_Burstcnt      :  std_logic_vector(7 downto 0);
			signal AM_Readdatavalid :  std_logic;
			
			signal CSX		        :  std_logic;
			signal DCX		        :  std_logic;
			signal WRX		        :  std_logic;
			signal D	              :  std_logic_vector(15 downto 0);
			
			signal LCD_Config		  :  std_logic_vector(1 downto 0);
			signal state1                  :string(1 to 13);
		        signal bit1_value		: std_logic_vector(7 downto 0);
			signal burst_cnt_test     : unsigned(7 downto 0);
			signal length_cnt_test    : unsigned(31 downto 0);
			signal bit3		:string(1 to 9);
			signal fifo_out   : std_logic_vector(15 DOWNTO 0);
			signal fifo_in   : std_logic_vector(31 DOWNTO 0);
begin

dut3 : entity work.LCD_controller
port map(
		   clk              => clk,
			Reset            => Reset,
			
			AS_Add           => AS_Add,
		   AS_CS            =>	AS_CS,
		   AS_wr            => AS_wr,
		   AS_WData         => AS_WData,
		   AS_Rd            => AS_Rd,
		   AS_RData         => AS_RData,
		   AS_WaitRq        => AS_WaitRq,
			
			AM_Add           => AM_Add,
			AM_BE            => AM_BE,
			AM_Rd            => AM_Rd,
			AM_RData         =>AM_RData,
			AM_WaitRq        => AM_WaitRq ,
			AM_Burstcnt      => AM_Burstcnt,
			AM_Readdatavalid => AM_Readdatavalid,
			
			CSX		        => CSX,
			DCX		        => DCX,
			WRX		        => WRX,
			D	              => D,
			
			LCD_Config		  => LCD_Config,
			state1      =>            state1,
		bit1_value	=>	bit1_value,
		burst_cnt_test     =>burst_cnt_test ,
			length_cnt_test    =>length_cnt_test,
			bit3		=>bit3,
			fifo_out => fifo_out,
			fifo_in => fifo_in
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
AS_CS <= '1';
Reset <= '1';
AS_wr <= '1';

AM_RData <= X"00020001";
AM_WaitRq <= '0';
AM_Readdatavalid <= '0';
wait for TIME_DELTA;
AS_Add <= "000";
AS_WData <= X"00000001" ;--1
wait for TIME_DELTA;
AS_Add <= "010";
AS_WData <= X"00000002";
wait for TIME_DELTA;
AM_WaitRq <= '1';
AS_Add <= "001";
AS_WData <= X"00000002";
wait for TIME_DELTA;
AM_WaitRq <= '0';
AS_Add <= "011";
AS_WData <= X"00000001";
wait for TIME_DELTA;
AS_Add <= "100";
AS_WData <= X"00000000";
AM_Readdatavalid <= '1';
wait for TIME_DELTA;
AM_Readdatavalid <= '0';
AS_Add <= "100";
AS_WData <= X"0100002C";
AS_wr <= '1';
wait for 1*TIME_DELTA;
AM_Readdatavalid <= '1';
wait for TIME_DELTA;
AM_Readdatavalid <= '0';
AS_wr <= '0';
wait for 2*TIME_DELTA;

AM_Readdatavalid <= '0';

AM_Readdatavalid <= '1';
wait for 20*TIME_DELTA;

end process simulation;

end architecture test4;