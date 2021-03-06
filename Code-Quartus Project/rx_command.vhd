library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity rx_command is 
	port(	clk,reset	: in std_logic;
			rx			: in std_logic;
			cmdack		: in std_logic;
			cmdready	: out std_logic;
			ismk		: out std_logic;
			ismkv		: out std_logic;
			ismkp		: out std_logic;
			ismkth		: out std_logic;
			ismkst		: out std_logic;
			key			: out unsigned(5 downto 0);
			ta, ha		: out unsigned(7 downto 0)	);
end rx_command;

architecture a of rx_command is 
	
	component rx_char
		port(	clk			: in std_logic;
				cl			: in std_logic;
				rx			: in std_logic;
				ack			: in std_logic;
				char		: out std_logic_vector(7 downto 0);
				ready		: out std_logic	);
	end component;

	component rx_comm
		port(	clk			: in std_logic;
				cl			: in std_logic;
				char		: in std_logic_vector(7 downto 0);
				ready		: in std_logic; --Nuestro ready es su charready.
				cmd_ack		: in std_logic; --Nuestro cmd_ack es su cmdack.
				ack			: out std_logic; --Nuestro ack es su charack.
				cmdready	: out std_logic;
				ismk		: out std_logic;
				ismkv		: out std_logic;
				ismkp		: out std_logic;
				ismkth		: out std_logic;
				ismkst		: out std_logic;
				key			: out unsigned(5 downto 0);
				ta, ha		: out unsigned(7 downto 0)	);
	end component;
	
	signal	char :  std_logic_vector(7 downto 0);
	signal 	ready : std_logic;
	signal 	ack : std_logic;
	
begin 

	inst_rx_char: rx_char
		port map(	clk => clk,
					cl => reset,
					rx => rx,
					ack => ack,
					char => char,
					ready => ready);
	
	inst_rx_cont: rx_comm
		port map(	clk => clk,
					cl => reset,
					char => char,
					ready => ready,
					cmd_ack => cmdack,
					ack => ack,
					cmdready => cmdready,
					ismk => ismk,
					ismkv => ismkv,
					ismkp => ismkp,
					ismkth => ismkth,
					ismkst => ismkst,
					key => key,
					ta => ta,
					ha => ha);

end a;