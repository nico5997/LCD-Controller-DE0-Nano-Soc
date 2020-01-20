library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_controller is 
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
			
			CSX		        : out std_logic;
			DCX		        : out std_logic;
			WRX		        : out std_logic;
			D	              : out std_logic_vector(15 downto 0);
			
			LCD_Config		  : out std_logic_vector(1 downto 0)
	);
	
	
end LCD_controller;

architecture Arch3 of LCD_controller is

signal fifo_aclr		   : std_logic;
signal fifo_data_in		: std_logic_vector(31 DOWNTO 0);
signal fifo_rdreq		   : std_logic;
signal fifo_wrreq		   : std_logic;
signal fifo_data_out		: std_logic_vector(15 DOWNTO 0);
signal fifo_rdusedw		: std_logic_vector(9 DOWNTO 0);
signal fifo_wrusedw		: std_logic_vector(8 DOWNTO 0);

signal write_LT24       : std_logic;
signal write_DMA        : std_logic;
signal wait_rqst_LT24   : std_logic;
signal wait_rqst_DMA    : std_logic;

component LT24 
	port(
	
		clk              : in  std_logic;
		Reset            : in  std_logic := '1';
		
		AS_CS            : in  std_logic;
		AS_wr            : in  std_logic;
		AS_WData         : in  std_logic_vector(31 downto 0);
		AS_WaitRq        : out std_logic;
		
		rdreq		        : out  std_logic;
		q		           : in std_logic_vector(15 DOWNTO 0);
		rdusedw		     : in STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		CSX		        : out std_logic;
		DCX		        : out std_logic;
		WRX		        : out std_logic;
		D	              : out std_logic_vector(15 downto 0);
		
		LCD_Config		  : out std_logic_vector(1 downto 0)
		
	);
end component;

component DMA
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
		wrusedw	        : in std_logic_vector(8 DOWNTO 0)
		
	);
end component;

component FIFO
	port(
	
		aclr		   : IN STD_LOGIC;
		data		   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		   : IN STD_LOGIC;
		rdreq		   : IN STD_LOGIC;
		wrclk		   : IN STD_LOGIC;
		wrreq		   : IN STD_LOGIC;
		q		      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdusedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrusedw		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
		
	);
end component;

begin
		
		--if (AS_Add = "000"  or AS_Add = "001" or AS_Add = "010" or AS_Add = "011") then
			--write_DMA 	<= AS_wr;
		--else
			--write_DMA = '0';
		--end if;
		
		--if (AS_Add = "100")
			--write_LT24 <= AS_wr;
		--else
			--write_LT24 = '0';
		--end if;
		
		write_DMA <= AS_wr when AS_Add /= "100" else '0';
		write_LT24 <= AS_wr when AS_Add = "100" else '0';
		AS_WaitRq <= wait_rqst_LT24 or wait_rqst_DMA ; 

LT24_P: LT24
	port map(
	
		clk => clk,
		Reset => Reset,
		
		AS_CS => AS_CS,
		AS_wr => write_LT24,
		AS_WData => AS_WData,
		AS_WaitRq => wait_rqst_LT24,
		
		q => fifo_data_out,
		rdreq => fifo_rdreq,
		rdusedw => fifo_rdusedw,
		
		CSX => CSX,
		DCX => DCX,
		WRX => WRX,
		D => D,
		LCD_Config => LCD_Config
		
	);
	
DMA_P: DMA
	port map(
	
		clk => clk,
		Reset => Reset,
		AS_Add => AS_Add,
		AS_CS => AS_CS,
		AS_wr => write_DMA,
		AS_WData => AS_WData,
		AS_Rd => AS_Rd,
		AS_RData => AS_RData,
		AS_WaitRq => wait_rqst_DMA,
		
		AM_Add => AM_Add,
		AM_BE => AM_BE,
		AM_Rd => AM_Rd,
		AM_RData => AM_RData,
		AM_WaitRq => AM_WaitRq,     
		AM_Burstcnt => AM_Burstcnt,   
		AM_Readdatavalid => AM_Readdatavalid,
		
		data => fifo_data_in,              
		wrreq => fifo_wrreq,          
		aclr =>  fifo_aclr,        
		wrusedw => fifo_wrusedw
		
	);
	
FIFO_P:FIFO
     port map(
   
	   aclr => fifo_aclr,
		data => fifo_data_in,
		rdclk => clk,
		rdreq	=> fifo_rdreq,
		wrclk => clk,
		wrreq => fifo_wrreq,
		q => fifo_data_out,
		rdusedw => fifo_rdusedw,
		wrusedw => fifo_wrusedw
	);
end architecture Arch3;