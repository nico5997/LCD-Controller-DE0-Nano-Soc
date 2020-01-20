library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LT24 is 
	port(
	
		clk              : in  std_logic;
		Reset            : in  std_logic := '1';
		
		AS_CS            : in  std_logic;
		AS_wr            : in  std_logic;
		AS_WData         : in  std_logic_vector(31 downto 0);
		AS_WaitRq        : out std_logic;
		
		rdreq		        : out  std_logic;
		q		           : in std_logic_vector(15 DOWNTO 0);
		rdusedw		     : in STD_LOGIC_VECTOR(9 DOWNTO 0);
		

		CSX		        : out std_logic;
		DCX		        : out std_logic;
		WRX		        : out std_logic;
		D	              : out std_logic_vector(15 downto 0);
		
		LCD_Config		  : out std_logic_vector(1 downto 0);
		state1                  :out string(1 to 13);
		bit1_value		:out std_logic_vector(7 downto 0)
		
		);
end entity LT24;

architecture Arch2 of LT24 is

	constant Write_Address 	  : std_logic_vector(7 downto 0) := "00101100";
	constant TOTAL_PIXEL	     : integer := 2;
	signal   cnt		        : unsigned(16 downto 0);
	type     state_machine is (IDLE, FIRST_CYLCLE, SECOND_CYCLE, THIRD_CYCLE, WAIT_FIFO, WRITE_IN,UPDATE1, UPDATE2, TEST);
	signal   state            : state_machine;
	signal   bit1             : std_logic;
	signal   LCD_Reg          : std_logic_vector(1 downto 0);
	signal   DCX_Reg          : std_logic;
	signal   CSX_Reg          : std_logic;
	signal   Bit2             : std_logic;
	signal   burst 		: std_logic_vector(7 downto 0);
	
	begin
		
		LCD_Reg <= AS_WData(18 downto 17);
		bit1 <= AS_WData(19);
		DCX_Reg <= AS_WData(20);
		bit2 <= AS_WData(21);
		CSX_Reg <= not AS_WData(22) ;
		burst <= AS_WDAta(30 downto 23);
		bit1_value<=burst;
	LT24: process(clk, Reset) is
	begin
	
		if Reset = '0' then
			
			
			state            <= IDLE;	
			state1<="         IDLE";
			LCD_Config 		     <= "11";
		   
		      D 		           <= (others=>'0');
		elsif rising_edge(clk) then
			AS_WaitRq <= AS_wr;
			rdreq <= '0';
			case state is
				when IDLE =>
					state1<="         IDLE";
					cnt <= (others => '0');
					CSX <= CSX_Reg ;
					DCX <= '1';
					WRX <= '1';
					
					if (AS_Wr = '1') then
						if (bit1 = '1') then
							LCD_Config <= LCD_Reg;
							AS_WaitRq <= '0';
							--state <= IDLE;
						else
							CSX <= '0';
							DCX <= DCX_Reg;
							WRX <= '0';
							D <= AS_WData(15 downto 0);
							state <= FIRST_CYLCLE;
						end if;
					else 
						AS_WaitRq <= '0';
						--state <= IDLE;
					end if;
				when FIRST_CYLCLE =>
					state1<="  FIRST_CYCLE";
					state <= SECOND_CYCLE;
				when SECOND_CYCLE =>
					state1<=" SECOND_CYCLE";
					WRX <= '1';
					state <= THIRD_CYCLE;
				when THIRD_CYCLE =>
				     state1<="  THIRD_CYCLE";
				      AS_WaitRq <= '0';
						if (AS_WData(7 downto 0) = Write_Address) and (DCX_reg = '0') then
							state <= WAIT_FIFO;
						else
							state <= IDLE;
						end if;
				when WAIT_FIFO =>
					state1<="    WAIT_FIFO";
					CSX <= '1';
					if (AS_Wr = '1') then 
						state <= IDLE;
					elsif (to_integer(unsigned(rdusedw))  >= to_integer(unsigned(burst))) then
					rdreq 			  <= '1';
					state <= WRITE_IN;
					end if;
				when WRITE_IN =>
					state1<="     WRITE_IN";
					if (AS_Wr = '1') then 
						state <= IDLE;
					end if;
					CSX <= '0';
					DCX <= '1';
					WRX <= '0';
					D <= q;
					state <= UPDATE1;
				when UPDATE1 =>
					state1<="      UPDATE1";
					if (AS_Wr = '1') then 
						state <= IDLE;
					end if;
					state <= UPDATE2;
				when UPDATE2 =>
					state1<="      UPDATE2";
					if (AS_Wr = '1') then 
						state <= IDLE;
					end if;
					WRX <= '1';
					state <= TEST;
				when TEST =>
					state1<="         TEST";
					if (AS_Wr = '1') then 
						state <= IDLE;
					elsif cnt = to_unsigned(TOTAL_PIXEL - 1, cnt'length) then
						cnt <= (others=>'0');
						state <= WAIT_FIFO;
					else
						cnt <= cnt + 1;
						rdreq <= '1';
						state <= WRITE_IN;
					end if;
				when others =>
					null;
			end case;
	end if ;
	end process LT24;

end Arch2;