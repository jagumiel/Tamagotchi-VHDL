library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rxtx_gest_DE2 is
	port(	KEY 		: in std_logic_vector(0 downto 0);
			SW 		: in std_logic_vector(0 downto 0);
			CLOCK_50	: in std_logic;
			UART_RXD : in std_logic;
			UART_TXD : out std_logic;
			LEDG		: out std_logic_vector(7 downto 0);
			LEDR		: out std_logic_vector (15 downto 0)	);
end rxtx_gest_DE2;


architecture b of rxtx_gest_DE2 is 

	signal keyt 		: unsigned (5 downto 0); --Ponemos keyt porque key esta reservado.
	signal ta, ha 		: unsigned (7 downto 0);
	signal cmdready, ismk, ismkv, ismkth, ismkp, ismkst : std_logic;
	signal cl 			: STD_LOGIC;
	signal sendmk, sendmkv, sendmkp, sendmkth, sendmkst : STD_LOGIC;
	signal cmd_ack		: std_logic;
	signal sendack		: std_LOGIC;
	signal tx			: std_LOGIC;
	

	component rxtx_gest
		port(	
			clk		: in std_logic;
			cl			: in std_logic;
			ready		: in std_logic;
			rx			: in std_logic;
			tx			: out std_logic);
	end component;
	
	begin
	cl <= not(KEY(0));
	process (CLOCK_50, cl)
	begin
		if 	cl='1' then
			tx 		<= '0';
			
		elsif	(CLOCK_50'event and CLOCK_50='1') then
					
		LEDG(0)<= ismk;
		LEDG(1)<= ismkv;
		LEDG(2)<= ismkp;
		LEDG(3)<= ismkth;
		LEDG(4)<= ismkst;
		LEDG(7)<= cmdready;
		
		LEDR(0)<= sendmk;
		LEDR(1)<= sendmkv;
		LEDR(2)<= sendmkp;
		LEDR(3)<= sendmkth;
		LEDR(4)<= sendmkst;
	end if;
	end process;
	
	
	inst_rxtx_gest: rxtx_gest
		port map(
			clk		=> CLOCK_50,
			cl 		=> cl,
			ready 	=> SW(0), 
			rx 		=> UART_RXD, --UART_RXD
			tx 		=> UART_TXD); --tx
		
	end b;