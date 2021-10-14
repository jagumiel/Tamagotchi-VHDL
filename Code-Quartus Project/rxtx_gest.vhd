library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity rxtx_gest is 
	port(	clk			: in std_logic;
			cl				: in std_logic;
			ready			: in std_logic;
			rx				: in std_logic; --Esta la hemos anadido.
			tx				: out std_logic);
end rxtx_gest;


architecture b of rxtx_gest is 
	
	--Senales internas que permiten unir un modulo con otro
	--rx_command 
	signal cmdready	: std_logic;
	signal ismk			: std_logic;
	signal ismkv		: std_logic;
	signal ismkp		: std_logic;
	signal ismkth		: std_logic;
	signal ismkst		: std_logic;
	signal cmd_ack		: std_logic;
	signal key			: unsigned(5 downto 0);
	signal ta, ha		: unsigned(7 downto 0);
	
	--com_gest
	signal sendmkp  	: STD_LOGIC;
	signal sendmkth 	: STD_LOGIC;
	signal sendmkst 	: STD_LOGIC;
	signal sendmkv  	: STD_LOGIC;
	signal sendmk   	: STD_LOGIC;
	signal req_mkp  	: STD_LOGIC;
	signal req_mkth 	: STD_LOGIC;      
	signal ans_ack 	: STD_LOGIC;
	signal ans_cmd		: STD_LOGIC;

	--tx_answer
	signal str_ver					: string(1 to 4);
	signal peso						: unsigned(6 downto 0);
	signal pulso					: unsigned(9 downto 0);
	signal tensh, tensl			: unsigned(6 downto 0);
	signal coles, azuc, alcoh	: unsigned(9 downto 0);
	signal temp, cans				: unsigned(6 downto 0);
	signal cara						: std_logic_vector(63 downto 0);
	signal hora, minu				: unsigned(5 downto 0);
	signal str_msg					: string(1 to 20);
	signal sendack					:  std_logic;
	
	
	component rx_command is 
		port(	clk		: in std_logic;
				reset		: in std_logic;
				rx			: in std_logic;
				cmdack	: in std_logic;
				cmdready	: out std_logic;
				ismk		: out std_logic;
				ismkv		: out std_logic;
				ismkp		: out std_logic;
				ismkth	: out std_logic;
				ismkst	: out std_logic;
				key		: out unsigned(5 downto 0);
				ta, ha	: out unsigned(7 downto 0));
	end component;

	component com_gest is
	port
	(
			sendmkp  	: out STD_LOGIC;
			sendmkth 	: out STD_LOGIC;
			sendmkst 	: out STD_LOGIC;
			sendmkv  	: out STD_LOGIC;
			sendmk   	: out STD_LOGIC;
			ans_cmd		: out STD_LOGIC;    
			cmdready 	: in std_logic;
			ismk			: in std_logic;
			ismkv			: in std_logic;
			ismkp			: in std_logic;
			ismkth	  	: in std_logic;
			ismkst		: in std_logic;
			ans_ack 		: in std_logic;
			clk      	: in std_logic; 
			cl       	: in std_logic );

	end component;

	component tx_answer is 
	 port(  clk, cl 						: in 	std_logic;
			sendmk, sendmkv, sendmkp  	: in 	std_logic;
			sendmkth, sendmkst        	: in 	std_logic;
			str_ver							: in	string(1 to 4);
			key								: in	unsigned(5 downto 0);
			ta, ha							: in	unsigned(7 downto 0);
			peso								: in	unsigned(6 downto 0);
			pulso								: in	unsigned(9 downto 0);
			tensh, tensl					: in	unsigned(6 downto 0);
			coles, azuc, alcoh			: in	unsigned(9 downto 0);
			temp, cans						: in	unsigned(6 downto 0);
			cara								: in	std_logic_vector(63 downto 0);
			hora, minu						: in	unsigned(5 downto 0);
			str_msg							: in	string(1 to 20);
			sendack           			: out std_logic;
			tx                			: out std_logic );
	end component;
	
	
begin 
	inst_rx_command: rx_command
		port map(	clk => clk,
					reset => cl,
					rx => rx,
					cmdack => cmd_ack,
					cmdready => cmdready,
					ismk => ismk,
					ismkv => ismkv,
					ismkp => ismkp,
					ismkth => ismkth,
					ismkst => ismkst,
					key => key,
					ta => ta,
					ha => ha);
	
	inst_com_gest: com_gest
		port map(	sendmkp => sendmkp,
					sendmkth => sendmkth,
					sendmkst => sendmkst,
					sendmkv => sendmkv,
					sendmk => sendmk,
					ans_cmd => cmd_ack   ,
					cmdready => cmdready,
					ismk => ismk,
					ismkv => ismkv,
					ismkp => ismkp,
					ismkth => ismkth,
					ismkst => ismkst,
					ans_ack => ans_ack,
					clk => clk,
					cl => cl);
					
					
	inst_tx_answer: tx_answer
		port map(	clk => clk,
					cl => cl,
					sendmk => sendmk,
					sendmkv => sendmkv,
					sendmkp => sendmkp,
					sendmkth => sendmkth,
					sendmkst => sendmkst,
					str_ver => "0.99",
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
					str_msg => "Me llamo Mr Tomasulo",
					sendack => ans_ack,
					tx  => tx);
end b;