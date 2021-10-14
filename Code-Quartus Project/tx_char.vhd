---------------------
--  tx_char.vhd
---------------------
--	Transmision asincrona por una linea serie RS232 (TX) de un dato 
-- de 8 bits (CHAR) con 1 bit de send ('0') y 1 bit de stop ('1')
-- La entrada SEND indica el comienzo de la transmision y la 
-- salida ACK se activa para indicar el final
-------------------------------------------------------------------
--	Andoni Arruti - 19/10/2015
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tx_char is
	generic(
 		BAUD_RATE : natural := 9600;
		CLK_FREQ  : natural := 50000000);
	port( clk,cl : in std_logic;
		    send     : in std_logic;
		    char      : in std_logic_vector (7 downto 0);
		    tx        : out std_logic;
		    ack     : out std_logic );
end tx_char;

architecture a of tx_char is
	constant CICLOS_BIT : natural := CLK_FREQ/BAUD_RATE;
-- estados presente y siguiente de la uc
	type  state is (idle, load, waitbit, putbit, ackwait);
	signal st, next_st : state;
-- registro de desplazamiento para dato a transmitir
	signal sreg : std_logic_vector (8 downto 0);	
	signal ld_char : std_logic;
	signal sh_right : std_logic;
-- contador de bits transmitidos
	signal bits : integer range 0 to 9;
	signal cl_bits : std_logic;
	signal inc_bits : std_logic;
	signal lastbit : std_logic;
-- contador de tiempo por bit
	signal ciclos : integer range 0 to CICLOS_BIT-1 ;
	signal cl_ciclos : std_logic;
	signal inc_ciclos : std_logic;
	signal finbit : std_logic;

begin	
-- ==================================================
-- unidad de control
-- calculo de estado siguiente -------------------------
	process (st, send, lastbit, finbit)	
	begin
		case st is
			when idle	=>
				if send = '1' then			     next_st <= load;
				else 						              next_st <= idle;
				end if;
			when load =>                next_st <= waitbit;
			when waitbit =>
				if finbit = '0' then	     next_st <= waitbit;
				elsif lastbit = '0' then  next_st <= putbit; 
				else						              next_st <= ackwait;
				end if;
			when putbit =>    	         next_st <= waitbit;
			when ackwait =>
				if send = '1' then			     next_st <= ackwait;
				else 						              next_st <= idle;
				end if;
		end case;
	end process;
-- almacenamiento de estado presente --------------
	process (clk, cl)
	begin
		if cl = '1' then 
			st <= idle;
		elsif clk'event and clk='1' then 
			st <= next_st;
		end if;
	end process;
-- señales de control --------------------------------
	ld_char		<= '1' when st = load 			             else '0';
	cl_bits		<= ld_char;
	cl_ciclos	<= '1' when st = load or st = putbit	else '0';
	inc_ciclos	<= '1' when st = waitbit			         else '0';
	sh_right	<= '1' when st = putbit 			          else '0';
	inc_bits 	<= sh_right;
	ack		<= '1' when st = ackwait				              else '0';
-- ==================================================
-- unidad de proceso
-- registro de desplazamiento -------------------------
	process (clk, cl)
	begin
		if cl = '1' then
			sreg <= "000000001";
		elsif clk'event and clk='1' then
			if ld_char = '1' then
				sreg <=	char & '0';
			elsif sh_right = '1' then
				sreg(8 downto 0) <=	'1' & sreg(8 downto 1);
			end if;
		end if;
	end process;
-- contador de tiempo -------------------------
	process (clk, cl)
	begin
		if cl = '1' then
			ciclos <= 0;
		elsif clk'event and clk = '1' then 
			if cl_ciclos = '1' then
				ciclos <= 0;
			elsif inc_ciclos = '1' then
				ciclos <= ciclos + 1;
			end if;
		end if;
	end process;
	finbit	<= '1' when ciclos = CICLOS_BIT-2	else '0';
-- contador de bits -------------------------
	process (clk, cl)
	begin
		if cl = '1' then
			bits <= 0;
		elsif clk'event and clk ='1' then
			if cl_bits = '1' then
				bits <= 0;
			elsif inc_bits = '1' then
				bits <= bits + 1;
			end if;
		end if;
	end process;
	lastbit <= '1' when bits = 9 else  '0';
-- salida -------------------------
	tx	<=	sreg(0);
end a;

