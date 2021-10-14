LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_1164.all;

entity tamagotchi is
port
( 	 
			clk, cl 						   : in 	std_logic;
			reqmkp  							: in 	std_logic;
			reqmkth				        	: in 	std_logic;							
			key								: in	unsigned(5 downto 0);
			ta, ha							: in	unsigned(7 downto 0);
			peso								: out	unsigned(6 downto 0);
			pulso								: out	unsigned(9 downto 0);
			tensh, tensl					: out	unsigned(6 downto 0);
			coles, azuc, alcoh			: out	unsigned(9 downto 0);
			temp, cans						: out	unsigned(6 downto 0);
			cara								: out	std_logic_vector(63 downto 0);
			hora, minu						: out	unsigned(5 downto 0);
			str_msg							: out	string(1 to 20);
			sendacktam          			: out std_logic);
			
end tamagotchi;



architecture STRUCT of tamagotchi is
	type estado is (e0, e1);
	signal ep, es :estado;
	signal pesot						: unsigned(6 downto 0);
	signal pulsot						: unsigned(9 downto 0);
	signal tensht, tenslt			: unsigned(6 downto 0);
	signal colest, azuct, alcoht	: unsigned(9 downto 0);
	signal tempt, canst				: unsigned(6 downto 0);
	signal carat						: std_logic_vector(63 downto 0);
	signal horat, minut				: unsigned(5 downto 0);
	signal CS							: integer range 1 to 50000001;
	signal str_msgt					: string(1 to 20);
	signal keyt							: integer range 1 to 19;
-- Unidad de control
BEGIN
process (ep,reqmkp,reqmkth) 
begin
	case ep is
		
		when e0 =>
			if reqmkp ='1'
				es<=e1;
			else
				es<=e0;	
		
		if reqmkth ='1'
				es<=e2;
			else
				es<=e0;
			
		when e1 => 
			es<=e0;
		
		when e2 =>
			es<=e0;

	end case;
	
end process;

-- salidas de la UC 

sendacktam   <='1' when ep=e2 or ep=e1 else '0';

-- Traspaso de variables internas

hora<=horat;
minu<=minut;
peso<=pesot;
peso<=pesot;								 
pulso<=pulsot;		
tensh<=tensht; 
tensl<=tenslt;					 
coles<=colest;
azuc<=azuct;
alcoh<=alcoht;	 
temp<=tempt;
cans<=canst					 
cara<=carat;							 
str_msg<=str_msgt;		

-- Conversion de variable externa casteada internamente
keyt<=to_integer(unsigned(key));
--Reloj
process (clk, cl)
begin
	if cl = '1' then --clear, reiniciamos a e0
		ep <= e0;
	elsif clk'event and clk='1' then --Para cambiar de estado
		ep <= es; 
	end if;
end process;

--CS (Contador de Segundos)
process( clk, cl)
begin
	if (cl='1') then
		CS<=0;
	elsif clk'event and clk='1'then
			if (CS=50000001) then  --ciclos que se necesitan para 1 solo segundo 
					CS<=1;
					if (minut<"111011") then   --59 en binario
						minut++;
					else 
						minut="000000";
						if (horat<"010111") then --23 en binario
						horat++;
						else 
						horat="000000";
						end if;
					end if;	
			else
				CS<=CS+1;
			end if;
		end if;
	end if;
end process;
end STRUCT;		