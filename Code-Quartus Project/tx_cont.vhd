library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_cont is
	port (	clk, cl					: in	std_logic;
			sendmk, sendmkv, sendmkp	: in	std_logic;
			sendmkth, sendmkst			: in	std_logic;
			charack						: in	std_logic;
			str_ver						: in	string(1 to 4);
			key							: in	unsigned(5 downto 0);
			ta, ha						: in	unsigned(7 downto 0);
			peso				: in	unsigned(6 downto 0);
			pulso						: in	unsigned(9 downto 0);
			tensh, tensl				: in	unsigned(6 downto 0);
			coles, azuc, alcoh			: in	unsigned(9 downto 0);
			temp, cans					: in	unsigned(6 downto 0);
			cara						: in	std_logic_vector(63 downto 0);
			hora, minu					: in	unsigned(5 downto 0);
			str_msg						: in	string(1 to 20);
			char 						: out	std_logic_vector(7 downto 0);
			sendchar					: out std_logic;
			sendack						: out std_logic	);
end tx_cont;

architecture rtl of tx_cont is
	constant TXT_L : natural := 84;
-- petición de envio
	signal send : std_logic;
-- registro con texto a enviar
	signal txt : string(1 to TXT_L);
	signal ld_txt : std_logic;
-- strings con parámetros y completa
	signal str_key, str_ta, str_ha, str_peso, str_tensh, str_tensl	: string(1 to 2);
	signal str_temp, str_cans, str_hora, str_minu					: string(1 to 2);
	signal str_pulso, str_coles, str_azuc , str_alcoh				: string(1 to 3);
	signal str_cara													: string(1 to 8);
	signal str 														: string(1 to TXT_L);
-- detección CR
	signal iscr : std_logic;
-- estados presente y siguiente de la UC
	TYPE  state is (idle, ldtxt, waitsend, chkcr, nextchar, ackwait);
	SIGNAL st, next_st		: state;
-- contador índice al texto
	SIGNAL index			: integer range 1 TO TXT_L;
	SIGNAL ini_index		: STD_LOGIC;
	SIGNAL inc_index		: STD_LOGIC;

begin
-- ==================================================
-- Unidad de control
-- calculo de estado siguiente -------------------------
	process (st, send, charack, iscr)	
	begin
		case st is
			when idle	=>
				if send = '1' then			next_st <= ldtxt;
				else 						next_st <= idle;
				end if;
			when ldtxt => 					next_st <= waitsend;
			when waitsend =>
				if charack = '1' then	 	next_st <= chkcr; 
				else						next_st <= waitsend;
				end if;
			when chkcr =>
				if iscr = '1' then   		next_st <= ackwait;
				else						next_st <= nextchar;
				end if;
			when nextchar => 				next_st <= waitsend;
			when ackwait	=>
				if send = '0' then			next_st <= idle;
				else 						next_st <= ackwait;
				end if;
		end case;
	end process;
-- almacenamiento de estado presente --------------
	process (clk, cl)
	begin
		if (cl = '1') then 
			st <= idle;
		elsif (clk'event and clk='1') then 
			st <= next_st;
		end if;
	end process;
-- señales de control --------------------------------
	ini_index	<= '1' when st = idle 			else '0';
	ld_txt		<= '1' when st = ldtxt 			else '0';
	sendchar	<= '1' when st = waitsend		else '0';
	inc_index	<= '1' when st = nextchar		else '0';
	sendack		<= '1' when st = ackwait		else '0';
	
-- ==================================================
-- unidad de proceso
-- detección petición de envio
	send <= sendmk or sendmkv or sendmkp or sendmkth or sendmkst;
-- conversion parámetros a strings ---------------------
	str_key(2) <= character'val((to_integer(key) rem 10)+48);
	str_key(1) <= character'val(to_integer(key)/10+48);
	str_ta(2) <= character'val((to_integer(ta) rem 10)+48);
	str_ta(1) <= character'val(to_integer(ta)/10+48);
	str_ha(2) <= character'val((to_integer(ha) rem 10)+48);
	str_ha(1) <= character'val(to_integer(ha)/10+48);
	str_peso(2) <= character'val((to_integer(peso) rem 10)+48);
	str_peso(1) <= character'val(to_integer(peso)/10+48);
	str_pulso(3) <= character'val((to_integer(pulso) rem 10)+48);
	str_pulso(2) <= character'val(((to_integer(pulso)/10) rem 10)+48);
	str_pulso(1) <= character'val(to_integer(pulso)/100+48);
	str_tensh(2) <= character'val((to_integer(tensh) rem 10)+48);
	str_tensh(1) <= character'val(to_integer(tensh)/10+48);
	str_tensl(2) <= character'val((to_integer(tensl) rem 10)+48);
	str_tensl(1) <= character'val(to_integer(tensl)/10+48);
	str_coles(3) <= character'val((to_integer(coles) rem 10)+48);
	str_coles(2) <= character'val(((to_integer(coles)/10) rem 10)+48);
	str_coles(1) <= character'val(to_integer(coles)/100+48);
	str_azuc(3) <= character'val((to_integer(azuc) rem 10)+48);
	str_azuc(2) <= character'val(((to_integer(azuc)/10) rem 10)+48);
	str_azuc(1) <= character'val(to_integer(azuc)/100+48);
	str_alcoh(3) <= character'val((to_integer(alcoh) rem 10)+48);
	str_alcoh(2) <= character'val(((to_integer(alcoh)/10) rem 10)+48);
	str_alcoh(1) <= character'val(to_integer(alcoh)/100+48);
	str_temp(2) <= character'val((to_integer(temp) rem 10)+48);
	str_temp(1) <= character'val(to_integer(temp)/10+48);
	str_cans(2) <= character'val((to_integer(cans) rem 10)+48);
	str_cans(1) <= character'val(to_integer(cans)/10+48);
	str_cara(1) <= character'val(to_integer(unsigned(cara(63 downto 56))));
	str_cara(2) <= character'val(to_integer(unsigned(cara(55 downto 48))));
	str_cara(3) <= character'val(to_integer(unsigned(cara(47 downto 40))));
	str_cara(4) <= character'val(to_integer(unsigned(cara(39 downto 32))));
	str_cara(5) <= character'val(to_integer(unsigned(cara(31 downto 24))));
	str_cara(6) <= character'val(to_integer(unsigned(cara(23 downto 16))));
	str_cara(7) <= character'val(to_integer(unsigned(cara(15 downto  8))));
	str_cara(8) <= character'val(to_integer(unsigned(cara( 7 downto  0))));
	str_hora(2) <= character'val((to_integer(hora) rem 10)+48);
	str_hora(1) <= character'val(to_integer(hora)/10+48);
	str_minu(2) <= character'val((to_integer(minu) rem 10)+48);
	str_minu(1) <= character'val(to_integer(minu)/10+48);
-- tabla de mensajes ----------------------------------
	process(sendmk, sendmkv, sendmkp, sendmkth, sendmkst, str_ver, str_key, str_peso, str_pulso,
				str_tensh, str_tensl, str_coles, str_azuc , str_alcoh, str_temp, str_cans,
				str_cara, str_hora, str_minu, str_ta, str_ha, str_msg)
	begin
		str <= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; -- la longitud es TXT_L
		if sendmk='1' then
			str(1 to 9) <= "+MK:,OK" & LF & CR;
		elsif sendmkv='1' then
			str(1 to 12) <= "+V:" & str_ver & ",OK" & LF & CR;
		elsif sendmkp='1' then
			str(1 to 10) <= "+P:" & str_key & ",OK" & LF & CR;
		elsif sendmkth='1' then
			str(1 to 14) <= "+TH:" & str_ta & "," & str_ha & ",OK" & LF & CR;
		elsif sendmkst='1' then
			str(1 to 84) <= "+STATE:" & str_peso & "," & str_pulso & "," & str_tensh & "," &
											str_tensl & "," & str_coles & "," & str_azuc & "," & 
											str_alcoh & "," & str_temp & "," & str_cans & "," & 
											str_cara & "," & str_hora & "," & str_minu & "," & 
											str_ta & "," & str_ha & "," & str_msg & ",OK" & LF & CR;
		end if;
	end process;	 
-- registro de texto ---------------
	process (clk, cl)
	begin
		if (cl = '1') then
			txt <= "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
		elsif (clk'event and clk ='1') then
			if (ld_txt = '1') then
				txt <= str;
			end if;
		end if;
	end process;
-- contador índice al texto ---------------
	process (clk, cl)
	begin
		if (cl = '1') then
			index <= 1;
		elsif (clk'event and clk ='1') then
			if (ini_index = '1') then
				index <= 1;
			elsif (inc_index = '1') then
				index <= index + 1;
			end if;
		end if;
	end process;
-- detección CR -------------------------
	iscr <= '1' when txt(index) = CR else '0';
-- MUX para extraer char -------------------------
	char <= std_logic_vector(to_unsigned(character'pos(txt(index)),8));
  
end rtl;