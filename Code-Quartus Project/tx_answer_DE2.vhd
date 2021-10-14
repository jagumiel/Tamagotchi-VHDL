library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity tx_answer_de2 is 
 port(	CLOCK_50 	:  	IN  STD_LOGIC;
		KEY 		:  	IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
		SW 			:  	IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		LEDG 		:  	OUT  STD_LOGIC_VECTOR(7 DOWNTO 7);
		UART_TXD 	: 	OUT STD_LOGIC);
end tx_answer_de2;

architecture a of tx_answer_de2 is 

	component tx_answer
		port(	clk							: in  std_logic;
				cl 						: in  std_logic;
				sendmk, sendmkv, sendmkp  	: in 	std_logic;
				sendmkth, sendmkst        	: in 	std_logic;
				str_ver						: in	string(1 to 4); --Este lo manda el tamagotchi
				key							: in	unsigned(4 downto 0); --Este lo manda el tamagotchi
				ta, ha, peso				: in	unsigned(6 downto 0); --Este lo manda el tamagotchi
				pulso						: in	unsigned(9 downto 0); --Este lo manda el tamagotchi
				tensh, tensl				: in	unsigned(6 downto 0); --Este lo manda el tamagotchi
				coles, azuc, alcoh			: in	unsigned(9 downto 0); --Este lo manda el tamagotchi
				temp, cans					: in	unsigned(6 downto 0); --Este lo manda el tamagotchi
				cara						: in	std_logic_vector(63 downto 0); --Este lo manda el tamagotchi
				hora, minu					: in	unsigned(5 downto 0); --Este lo manda el tamagotchi
				str_msg						: in	string(1 to 20); --Este lo manda el tamagotchi
				sendack          			: out 	std_logic;
				tx                			: out 	std_logic );
	end component;

	SIGNAL	cl :  STD_LOGIC;
	signal 	sendmk, sendmkv, sendmkp, sendmkth, sendmkst : STD_LOGIC;
	
BEGIN 
	cl <= not(KEY(0));
	process (CLOCK_50, cl)
	begin
		if 	cl='1' then
			sendmk 		<= '0';
			sendmkv 	<= '0';
			sendmkp 	<= '0';
			sendmkth 	<= '0';
			sendmkst 	<= '0';
		elsif	(CLOCK_50'event and CLOCK_50='1') then
			sendmk 		<= SW(0);
			sendmkv 	<= SW(1);
			sendmkp 	<= SW(2);
			sendmkth 	<= SW(3);
			sendmkst 	<= SW(4);
		end if;
	end process;
	
	inst_tx_answer: tx_answer
		PORT MAP(cl 			=> cl,
					clk 		=> CLOCK_50,
					sendmk 		=> sendmk,
					sendmkv 	=> sendmkv,
					sendmkp 	=> sendmkp,
					sendmkth 	=> sendmkth,
					sendmkst 	=> sendmkst,
					str_ver 	=> "ABCD",
					key 		=> to_unsigned(3, 5),
					ta 			=> to_unsigned(25, 7),
					ha 			=> to_unsigned(82, 7),
					peso 		=> to_unsigned(15, 7),
					pulso 		=> to_unsigned(135, 10),
					tensh 		=> to_unsigned(13, 7),
					tensl 		=> to_unsigned(6, 7),
					coles 		=> to_unsigned(125, 10),
					azuc 		=> to_unsigned(354, 10),
					alcoh	 	=> to_unsigned(224, 10),
					temp 		=> to_unsigned(37, 7),
					cans 		=> to_unsigned(41, 7),
					cara 		=> x"AA55AA55AA55AA55",
					hora 		=> to_unsigned(14, 6),
					minu 		=> to_unsigned(58, 6),
					str_msg 	=> "Hola, me llamo Pablo",
					sendack 	=> LEDG(7),
					tx 			=> UART_TXD);
END a;