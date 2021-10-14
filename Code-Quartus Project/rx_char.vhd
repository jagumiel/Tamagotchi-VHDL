LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_1164.all;


--entity rx_char is
--port
--(
--	rx		: in std_logic;
--	ack		: in std_logic;
--ready	: out std_logic;
--	char	: out std_logic_vector (7 downto 0);
--	cl		: in std_logic;
--	clk		:in std_logic
--);
--end rx_char;

entity rx_char is
port
(
      ready   : out STD_LOGIC ; 
      clk     : in STD_LOGIC ; 
      char    : out std_logic_vector (7 downto 0) ; 
      rx      : in STD_LOGIC ; 
      cl      : in STD_LOGIC ; 
      ack     : in STD_LOGIC ); 
end rx_char;

architecture STRUCT of rx_char is
	type estado is (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9);
	signal ep, es :estado;

	signal LD_BIT 	: std_logic;		--Carga contador de bits
	signal INC_BIT	: std_logic;		--Incrementa contador de bits
	signal FIN_BIT 	: std_logic;		--Fin de un bit
	signal LD_CMS 	: std_logic;		--Carga contador de ciclos
	signal INC_CMS 	: std_logic;		--Activa contador de ciclos
	signal FIN_CMS 	: std_logic;		--Fin de un ciclos
	signal FIN_CERO	: std_logic;		--Fin medio ciclo
	signal SR 		: std_logic;		--Senal registro de desplazamiento
	signal RX_S	: std_logic;			--Señal de entrada sincronizada.
	signal T : integer range 0 to 5208;
  signal N: integer range 0 to 7;
  signal DAT : std_logic_vector (7 downto 0);

	--poner en la entidada  como out para realizar las pruebas exclusivamente de la UC.

-- Unidad de control
BEGIN
process (ep, FIN_BIT, FIN_CMS, RX_S, FIN_CERO, ack) 	--En los  combinacionales como este hay que meter como entrada las señales que se van a usar: RX_S
begin
	case ep is
		when e0 =>
			if RX_S = '0' then
				es <= e1;
			else
				es <= e0;
			end if;
			
		when e1 => 
			es <= e2;
			
		when e2 =>
			if FIN_CERO = '1' then
				if RX_S = '1' then
					es <= e0;
				else
					es <= e3;
				end if;
			else
				es <= e2;
			end if;
			
		when e3 =>
			es <= e4;

    	when e4 => 
			if FIN_CMS = '1' then
				es <= e5;
			else
				es <= e4;
			end if;
			
		when e5 =>
			if FIN_BIT = '1' then
				es <= e7;
			else
				es <= e6;
			end if;
			
		when e6 =>
			es <= e3;
			
		when e7 =>
			es <= e8;
			
		when e8 =>
			if FIN_CMS = '1' then
				if RX_S = '1' then
					es <= e9;
				else
					es <= e0;
				end if;
			else
				es <= e8;
			end if;
			
		when e9 =>
			if ack = '1' then
				es <= e0;
			else
				es <= e9;
			end if;
			
	end case;
end process;
--Correcto respecto al diagrama de flujo.

--FFD
process( clk, cl)
  begin
  if cl = '1' then
    RX_S <= '1';
  elsif clk'event and clk='1' then
    if rx='0' then 
      RX_S<='0';
    else
      RX_S<='1'; 
    end if;
  end if;
end process; 
    
--Reloj
process (clk, cl)
begin
	if cl = '1' then --clear, reiniciamos a e0
		ep <= e0;
	elsif clk'event and clk='1' then --Para cambiar de estado
		ep <= es; 
	end if;
end process;

-- salidas de la UC  

FIN_CMS 	<= '1' 	when T=5207 	else '0';
FIN_CERO	<= '1' 	when T=2603 	else '0';
FIN_BIT 	<= '1' 	when N=7 		else '0';
LD_CMS	   	<= '1'  when ep = e1 or ep = e3 or ep = e7	else '0';
LD_BIT	  	<= '1'  when ep = e1 	else '0';
INC_CMS	   	<= '1'  when ep = e2 or ep = e4	or ep = e8	else '0';
INC_BIT		<= '1'  when ep = e6	else '0';
SR		    <= '1'  when ep = e5 	else '0';
ready       <= '1'  when ep = e9   	else '0';
char 		<= DAT;
--Correcto respecto al diagrama de flujo.

 
--SREG(Registro de desplazamiento):
Process(clk, cl)
begin
	if cl='1' then
		DAT<="00000000";
	elsif (clk'event and clk='1') then 
		if SR='1' then	--Almacena los datos que le llegan desplazando los anteriores.
			DAT <= rx & DAT (7 downto 1);
		end if;
	end if;
end process;


 
--CBIT (Contador de bits):
process(clk,cl) --Cuenta para que pueda terminar una vez que tenga los 8 bits.
begin
	if (cl='1') then
		N<=0;
	elsif clk'event and clk='1' then
		if (LD_BIT='1') then
			N<=0;	
		elsif (INC_BIT='1') then
			if (N=7) then
				N<=0;
			else
				N<=N+1;
			end if;
		end if;				 
	end if;
end process;

 
--CMS (Contador de Ciclos)
process( clk, cl)
begin
	if (cl='1') then
		T<=0;
	elsif clk'event and clk='1'then
		if (LD_CMS ='1') then
			T<=0;
		elsif (INC_CMS='1') then
			if (T=5208) then
				T<=0;		
			else
				T<=T+1;
			end if;
		end if;
	end if;
end process;

end STRUCT;