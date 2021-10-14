library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_command_DE2 is
	port(	KEY 		: in std_logic_vector(0 downto 0);
			SW 		: in std_logic_vector(0 downto 0);
			CLOCK_50	: in std_logic;
			UART_RXD 	: in std_logic;
			LEDG		: out std_logic_vector(7 downto 0);
			LEDR		: out std_logic_vector (15 downto 0)	);
end rx_command_DE2;

architecture a of rx_command_DE2 is

	component rx_command is
		port(	clk			: in std_logic;
				reset		: in std_logic;
				rx			: in std_logic;
				cmdreq		: in std_logic;
				cmdack		: in std_logic;
				cmdready	: out std_logic;
				ismk		: out std_logic;
				ismkv		: out std_logic;
				ismkp		: out std_logic;
				ismkth		: out std_logic;
				ismkst		: out std_logic;
				key			: out unsigned(5 downto 0); --Cambiado de 4 a 5 para que coincida.
				ta			: out unsigned(7 downto 0); --Cambiado 6 a 7.
				ha			: out unsigned(7 downto 0)	); --Cambiado 6 a 7.
	end component;

	signal keyt : unsigned (5 downto 0);
	signal ta, ha : unsigned (7 downto 0);
	signal cmdready, ismk, ismkv, ismkth, ismkp, ismkst : std_logic;
	SIGNAL	cl :  STD_LOGIC;
	
begin

	inst_rx_command : rx_command  
		port map (	clk => CLOCK_50,
					reset => cl,
					rx => UART_RXD,
					cmdreq => '1',
					cmdack => SW(0),
					cmdready => cmdready,
					ismk   => ismk,
					ismkv   => ismkv, 
					ismkp   => ismkp,
					ismkth   => ismkth,
					ismkst   => ismkst,
					key   => keyt,
					ta   => ta,
					ha => ha	);
	 
	cl <= not(KEY(0));			
	LEDG(0)<= ismk;
	LEDG(1)<= ismkv;
	LEDG(2)<= ismkp;
	LEDG(3)<= ismkth;
	LEDG(4)<= ismkst;
	LEDG(7)<= cmdready;
	process(ismkp, ismkth, CLOCK_50, cl)
	begin
	  if 	cl='1' then	
	  LEDR(15 downto 0) <= "0000000000000000"; 
	  
	  elsif	(CLOCK_50'event and CLOCK_50='1') then 
		   if ismkp='1' then
			 LEDR(15 downto 0) <= "0000000000" & std_logic_vector(keyt);
	    	elsif ismkth='1' then
			 LEDR(15 downto 0) <= std_logic_vector(ta) & std_logic_vector(ha);
		   else
		  	LEDR(15 downto 0) <= "0000000000000000";
	    	end if;
	  	end if;
	  	
	end process;
	
end a;
