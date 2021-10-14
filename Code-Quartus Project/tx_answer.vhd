library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity tx_answer is 
 port(  clk, cl :  in  std_logic;
		    sendmk, sendmkv, sendmkp  : in std_logic;
		    sendmkth, sendmkst        : in std_logic;
			  str_ver						      : in	string(1 to 4);
			  key							       : in	unsigned(5 downto 0);
			  ta, ha							: in	unsigned(7 downto 0);
			  peso				   : in	unsigned(6 downto 0);
			  pulso						        : in	unsigned(9 downto 0);
			  tensh, tensl				   : in	unsigned(6 downto 0);
			  coles, azuc, alcoh	: in	unsigned(9 downto 0);
			  temp, cans					    : in	unsigned(6 downto 0);
			  cara						         : in	std_logic_vector(63 downto 0);
			  hora, minu					    : in	unsigned(5 downto 0);
			  str_msg						      : in	string(1 to 20);
      		sendack           : out std_logic;
      		tx                : out std_logic );
end tx_answer;

architecture a of tx_answer is 

	signal	charack :  std_logic;
	signal	char :  std_logic_vector(7 downto 0);
	signal sendchar : std_logic;

	component tx_cont
	port (	clk, cl					       : in	std_logic;
			sendmk, sendmkv, sendmkp	: in	std_logic;
			sendmkth, sendmkst			    : in	std_logic;
			charack						            : in	std_logic;
			str_ver						      : in	string(1 to 4);
			key							     : in	unsigned(5 downto 0);
			ta, ha				   : in	unsigned(7 downto 0);
			peso				   : in	unsigned(6 downto 0);
			pulso						       : in	unsigned(9 downto 0);
			tensh, tensl				   : in	unsigned(6 downto 0);
			coles, azuc, alcoh	: in	unsigned(9 downto 0);
			temp, cans					    : in	unsigned(6 downto 0);
			cara						       : in	std_logic_vector(63 downto 0);
			hora, minu					    : in	unsigned(5 downto 0);
			str_msg						      : in	string(1 to 20);
			char 						           : out	std_logic_vector(7 downto 0);
			sendchar					          : out std_logic;
			sendack						          : out std_logic	);
	end component;

	component tx_char
	 generic(  BAUD_RATE : natural;
				     CLK_FREQ : natural);
	 port( clk,cl : in std_logic;
		     send : in std_logic;
		     char : in std_logic_vector (7 downto 0);
		     tx : out std_logic;
		     ack : out std_logic  );
	end component;
	
begin 
	inst_tx_cont: tx_cont
		port map(cl => cl,
					   clk => clk,
					   sendmk => sendmk,
					   sendmkv => sendmkv,
					   sendmkp => sendmkp,
			       sendmkth => sendmkth,
			       sendmkst => sendmkst,
					   charack => charack,
					   str_ver => str_ver,
					   key => key,
					   ta => ta,
					   ha => ha,
					   peso => peso,
					   pulso => pulso,
					   tensh => tensh,
					   tensl => tensl,
					   coles => coles,
					   azuc => azuc,
					   alcoh => alcoh,
					   temp => temp,
					   cans => cans,
					   cara => cara,
					   hora => hora,
					   minu => minu,
					   str_msg => str_msg,
					   sendack => sendack,
					   char => char,
					   sendchar => sendchar  );
	
	inst_tx_char: tx_char
	  generic map(BAUD_RATE => 9600,
					      CLK_FREQ => 50000000)
		port map(clk => clk,
					   cl => cl,
					   send => sendchar,
					   char => char,
					   tx => tx,
					   ack => charack  );
end a;