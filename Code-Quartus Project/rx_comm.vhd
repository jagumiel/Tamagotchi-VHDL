LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_1164.all;


entity rx_comm is
port
(
      ready    	: in STD_LOGIC ; 
      char     	: in std_logic_vector (7 downto 0) ;  
      cmd_ack  	: in STD_LOGIC ; 
      ack      	: out STD_LOGIC ; 
      cmdready 	: out STD_LOGIC ; 
      ismk     	: out STD_LOGIC ; 
      ismkv    	: out STD_LOGIC ; 
      ismkp    	: out STD_LOGIC ; 
      ismkth   	: out STD_LOGIC ; 
      ismkst   	: out STD_LOGIC ;
      key      	: out unsigned (5 downto 0) ;  
      ta       	: out unsigned (7 downto 0) ;  
      ha       	: out unsigned (7 downto 0) ;  
      clk		: in STD_LOGIC;
      cl	   	: in STD_LOGIC );
      
end rx_comm;


architecture STRUCT of rx_comm is
								
	signal dato			: string (1 to 12); 		-- es el comando que se genera segun llegan los caracteres      
	signal comandoFinal	: std_logic; 				-- es el final del comando, cuando se recibe CR, sirve como se�al de carga del banco de registros (char)
	signal index		: integer range 1 to 13; 	-- nos permite saber las posiciones del comando (el tama?o m?ximo son 12 bytes, 12 posiciones)
	signal INC_B		: std_logic;				--Incrementa el contador de posiciones
	signal CL_B 		: std_logic; 				-- Nos indica que queremos resetear el contador de posiciones del comando;
	signal CL_D 		: std_logic; 				-- Nos indica que queremos resetear banco de registros;
	signal LD_C		: std_logic;				--Incrementa el contador del banco de registros

	type estado is (e0, e1, e2, e3);
	signal ep, es :estado;


-- Unidad de control

BEGIN
process (ep, comandoFinal, cmd_ack, ready) 	--Revisar lista de sensibilidad
begin
	case ep is
		when e0 =>
			if ready='1' then
				es <= e2;
			else
				es <= e0;
			end if;
		
		when e1 =>
				 if ready='1' then
				 es <=e2;
				 else
				 es<=e1;
				 end if;
		when e2 => 
			if comandoFinal='1' then
				es <= e3;
			else
				es <=e1;
			end if;
		
		when e3 =>
			if cmd_ack='1' then 
				es <= e0;
			else
				es <= e3;
			end if;
	end case;
end process;


--Reloj
process (clk, cl)
begin
	if cl = '1' then --clear, reiniciamos a e0
		ep <= e0;
	elsif clk'event and clk='1' then 
		ep <= es; 
	end if;
end process;

-- salidas de la UC  
 
ack     	<= '1' 	when ep=e2 else '0';
cmdready		<='1' when ep=e3 else '0';
INC_B	  	<= '1'  when ep = e2 	else '0';
CL_B	   	<= '1'  when ep = e0 	else '0';
CL_D	   	<= '1'  when ep = e0 	else '0';
LD_C	  	<= '1'  when ep = e2 	else '0';


--Bloque combinacional

ismk 	  <= '1' when index = 4 else '0';
ismkv 	 <= '1' when index = 6 else '0';
ismkp 	 <= '1' when index = 9 else '0';
ismkth 	<= '1' when index = 13 else '0';
ismkst 	<= '1' when index = 10 else '0';


key<= to_unsigned((character'pos(dato(6))-48)*10 + (character'pos(dato(7))-48), 6);
ta	<= to_unsigned((character'pos(dato(7))-48)*10 + (character'pos(dato(8))-48), 8);
ha	<= to_unsigned((character'pos(dato(10))-48)*10 + (character'pos(dato(11))-48), 8);

-- para el testbench char<=std_logic_vector(to_unsigned('M'));

comandoFinal	<='1' when (character'val(to_integer(unsigned(char)))= CR) else '0';

		
--Banco de Registros
process(clk, cl)
begin
	if (cl='1') then
		dato<="000000000000";
	elsif (clk'event and clk='1')then
		if (CL_D='1') then 
			dato<="000000000000";
		elsif (LD_C='1' and comandoFinal='0') then 
			dato(index)<=character'val(to_integer(unsigned(char)));
		end if;
	end if;
end process;


--CPOS (Contador de Posiciones):
process(clk,cl) --Cuenta las posiciones que tiene el comando que nos mandan.
begin --incluye el CR
	if (cl='1') then
		index<=1;
	elsif (clk'event and clk='1') then
		if (CL_B='1') then
			index<=1;	--Hacemos un reset de index
		elsif (INC_B='1' and index<=12) then
			index<=index + 1;
		end if;
	end if;				 
end process;
--UV
end STRUCT;


