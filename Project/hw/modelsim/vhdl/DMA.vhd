library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DMA is
	port(
	
		clk              : in std_logic;
		Reset            : in std_logic;
		
		AS_Add           : in std_logic_vector(2 downto 0);
		AS_CS            : in std_logic;
		AS_wr            : in std_logic;
		AS_WData         : in std_logic_vector(31 downto 0);
		AS_Rd            : in std_logic;
		AS_RData         : out std_logic_vector(31 downto 0);
		AS_WaitRq        : out std_logic;
		
		AM_Add           : out std_logic_vector(31 downto 0);
		AM_BE            : out std_logic_vector(3 downto 0);
		AM_Rd            : out std_logic;
		AM_RData         : in std_logic_vector(31 downto 0);
		AM_WaitRq        : in std_logic;
		AM_Burstcnt      : out std_logic_vector(7 downto 0);
		AM_Readdatavalid : in std_logic;
		
		aclr	           : out std_logic;
		data	           : out std_logic_vector(31 DOWNTO 0);
		wrreq	           : out std_logic;
		wrusedw	           : in std_logic_vector(8 DOWNTO 0);
		burst_test         :out unsigned(7 downto 0);
                length_test         :out unsigned(31 downto 0);
		Newadd_test         :out unsigned(31 downto 0);
		burst_cnt_test     :out unsigned(7 downto 0);
		length_cnt_test    :out unsigned(31 downto 0);
		bit3		:out string(1 to 9);
		start1		:out std_logic
		
	);
end entity DMA;

architecture Arch1 of DMA is

	signal Image_adress  : std_logic_vector(31 downto 0);
	signal start_check   : std_logic;
	constant C 	     : std_logic_vector(31 downto 0) := X"00101100";
	signal Lengthh       : unsigned(31 downto 0);
	signal Length_cnt    : unsigned(31 downto 0);
	signal start	     : std_logic;
	signal restart       : std_logic;
	signal burst	     : unsigned(7 downto 0);
	signal burst_cnt     : unsigned(7 downto 0);
	signal New_Add	     : unsigned(31 downto 0);
	constant TOTAL_WORDS : integer := 512;
	signal reading       : std_logic; -- flag for waitrequest control
	type   state_machine is (INIT, IDLE, READ_RQST, WAIT_DATA, TRANSFER);
	signal state         :	state_machine;
	signal bit31         :string(1 to 9);
	
	begin

	data(31 downto 0)	   <=	AM_RData(31 downto 0);
	AS_WaitRq <= '0' when reading = '1' else AS_Rd;

	AS_WaitRq <= '0' when reading = '1' else AS_Rd;
        burst_test <=  burst;
	length_test <= Lengthh;
	Newadd_test <= unsigned(New_Add);
	burst_cnt_test <= burst_cnt;
	length_cnt_test <= Length_cnt;
	bit3 <= bit31;
	start1 <= start;
	AS_Write: process(clk, Reset) is
	begin
		if Reset = '0' then
					Image_adress <= (others => '0');
					Lengthh <= (others => '0');
					burst <= (others => '0');
					start <= '0';
		elsif rising_edge(clk) then
			if  start_check = '1' then
				start <= '0';
			end if;
			if (AS_CS = '1') and (AS_wr = '1') then
				case AS_Add is
					when "000" =>
						Image_adress <= AS_WData;
						start <= '1';
					when "001" =>
						Lengthh	<= unsigned(AS_WData);
					when "010" =>	
						burst <= unsigned(AS_WData(7 downto 0));
					when "011" =>
						start <= AS_WData(0);
						restart <= AS_WData(1);
					when others =>
						null;
		
				end case;
			end if;
	   end if;
	end process AS_Write;
	
	AS_Read: process(clk, Reset) is
	begin
		if Reset = '0' then
					AS_RData <= (others => '0');
		elsif rising_edge(clk) then
				AS_RData <= (others => '0');
				reading <= '0';
				if (AS_CS = '1') and (AS_Rd = '1') then
					reading <= '1';
					case AS_add is
						when "000" =>
									AS_RData <= Image_adress;
						when "001" =>
									AS_RData <= std_logic_vector(Lengthh);
						when "010" =>
									AS_RData(7 downto 0) <= std_logic_vector(burst);
						when "011" =>
									AS_RData(0) <= start;
						when others =>
								null;
					end case;
				end if;	
		end if;
	end process AS_Read;
	
	AM_BE <= "1111";
	
	DMA: process(clk, Reset) is
	begin
		
			

		if Reset = '0' then
			state            <= INIT;
			bit31 <= "     INIT";
		
		elsif rising_edge(clk) then
			start_check <= '0';
			aclr 			  <= '0';
			wrreq 			  <= '0';
			AM_Rd 	  <= '0';
			AM_Burstcnt <= (others => '0');
			AM_Add 	   <= (others => '0');
			case state is
				when INIT =>
					bit31 <= "     INIT"; 
					aclr <= '1';
					state <= IDLE;
				when IDLE =>
					bit31 <= "     IDLE"; 
					if (restart = '1') then
						state <= INIT;
					end if;
					burst_cnt      <= (others => '0');
					Length_cnt     <= (others => '0');
					New_Add        <= unsigned(Image_adress);
					if (start = '1') then
						state <= READ_RQST;
						start_check <= '1';
					end if;
				when READ_RQST =>
					bit31 <= "READ_RQST"; 
					if (restart = '1') then
						state <= INIT;
					end if;
					
					if (TOTAL_WORDS - to_integer(unsigned(wrusedw)) >= to_integer(burst)) then
						burst_cnt <= (others => '0');
						AM_Add 	   <= std_logic_vector(New_Add);
						AM_Burstcnt <= std_logic_vector(burst);
						AM_Rd 	   <= '1';
					end if;
					if AM_WaitRq ='0' and (TOTAL_WORDS - to_integer(unsigned(wrusedw)) >= to_integer(burst)) then 
                                                state <= WAIT_DATA;
					else
						state <= READ_RQST;
					end if;
					
  

				when WAIT_DATA =>
					bit31 <= "WAIT_DATA"; 
					if (restart = '1') then
						state <= INIT;
					end if;
					wrreq <= AM_Readdatavalid;
					if AM_Readdatavalid = '1' then
						
						burst_cnt <= burst_cnt + 1;
					end if;
					if burst = burst_cnt then
					   state <= TRANSFER;
					end if;
				when TRANSFER =>
					bit31 <= " TRANSFER"; 
					if (restart = '1') then
						state <= INIT;
					end if;
					Length_cnt <= Length_cnt + 1;
					New_Add 	  <= New_Add + 4*burst;   -- 
					if (Lengthh -1 = Length_cnt)  then    -- si jamais: ==
						state <= IDLE;
					else
						state <= READ_RQST;
					end if;
				when others =>
						state <= INIT;
			end case;
		end if;
	end process DMA;
	
end Arch1;