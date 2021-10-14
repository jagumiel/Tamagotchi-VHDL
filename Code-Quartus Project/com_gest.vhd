LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
USE ieee.std_logic_1164.all;

entity com_gest is
port
(
		sendmkp  	: out STD_LOGIC;
		sendmkth 	: out STD_LOGIC;
		sendmkst 	: out STD_LOGIC;
		sendmkv  	: out STD_LOGIC;
		sendmk   	: out STD_LOGIC; 
		ans_cmd		: out STD_LOGIC;
		cmdready 	: in std_logic;
		ismk		: in std_logic;
		ismkv		: in std_logic;
		ismkp		: in std_logic;
		ismkth	  	: in std_logic;
		ismkst		: in std_logic;
		ans_ack 	: in STD_LOGIC;
		clk      	: in STD_LOGIC; 
		cl       	: in STD_LOGIC );

end com_gest;

architecture STRUCT of com_gest is
	type estado is (e0, e1, e2, e3, e4, e5, e6, e7);
	signal ep, es :estado;
  --Como no hay UP. no hacemos arquitectura.

-- Unidad de control
BEGIN
process (ep,cmdready,ismkp,ismkth,ismkst,ismkv,ismk,ans_ack) 
begin
	case ep is
		
		when e0 =>
			if cmdready = '1' then
				es <= e1;
			else
				es <= e0;
			end if;
			
		when e1 => 
		  
		    if ismkp ='1' then
		    es<=e2;
		    end if;
		    
		    if ismkth ='1' then
		    es<=e3;
		    end if;
		    
		    if ismkst ='1' then
		    es<=e4;
		    end if;
		    
		    if ismkv ='1' then
		    es<=e5;
		    end if;
		    
		    if ismk ='1' then
		    es<=e6;
		    end if;
		  
		when e2 =>
			if ans_ack ='1' then
				es<=e7;
			else
				es<=e2;
			end if;

		when e3 =>
		  
			if ans_ack ='1' then
				es<=e7;
			else
				es<=e3;
			end if;

    	when e4 => 
    	  
		   if ans_ack ='1' then
				es<=e7;
			else
				es<=e4;
			end if;
			
		when e5 =>
		  
			if ans_ack ='1' then
				es<=e7;
			else
				es<=e5;
			end if;
			
		when e6 =>
			if ans_ack ='1' then
				es<=e7;
			else
				es<=e6;
			end if;
			
		when e7 =>
			
			if cmdready ='1' then
				es<=e7;
			else
				es<=e0;
			end if;

	end case;
	
end process;
--Correcto respecto al diagrama de flujo.

    
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
sendmkp   <='1' when ep=e2 else '0';
sendmkth  <='1' when ep=e3 else '0';
sendmkst  <='1' when ep=e4 else '0';
sendmkv   <='1' when ep=e5 else '0';
sendmk    <='1' when ep=e6 else '0';
ans_cmd   <='1' when ep=e7 else '0';
--Correcto respecto al diagrama de flujo.

end STRUCT;