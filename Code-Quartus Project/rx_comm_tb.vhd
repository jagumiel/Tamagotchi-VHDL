LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY rx_comm_tb  IS 
END ; 
 
ARCHITECTURE rx_comm_tb_arch OF rx_comm_tb IS
  SIGNAL ready    :  STD_LOGIC :='0' ; 
  SIGNAL char     :  std_logic_vector (7 downto 0) :="00000000" ; 
  SIGNAL cmd_ack  :  STD_LOGIC :='0' ;
  SIGNAL ack      :  STD_LOGIC ; 
  SIGNAL cmdready :  STD_LOGIC ; 
  SIGNAL ismk     :  STD_LOGIC ; 
  SIGNAL ismkv    :  STD_LOGIC ; 
  SIGNAL ismkp    :  STD_LOGIC ; 
  SIGNAL ismkth   :  STD_LOGIC ; 
  SIGNAL ismkst   :  STD_LOGIC ;
  SIGNAL key      :  unsigned (5 downto 0) ;  
  SIGNAL ta       :  unsigned (7 downto 0) ;  
  SIGNAL ha       :  unsigned (7 downto 0) ;  
  SIGNAL clk		    :  STD_LOGIC :='1';
  SIGNAL cl	   	  :  STD_LOGIC :='1';
  
   COMPONENT rx_comm  
    PORT (   
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
      clk		     : in STD_LOGIC;
      cl	   	   : in STD_LOGIC );
  END COMPONENT ; 
BEGIN
  DUT  : rx_comm  
    PORT MAP ( 
      ready   => ready  ,
      char    => char  ,
      cmd_ack => cmd_ack  ,
      ack     => ack   ,  
      cmdready => cmdready  ,
      ismk => ismk  , 
      ismkv => ismkv  ,
      ismkp => ismkp  ,
      ismkth => ismkth  ,
      ismkst => ismkst  ,
      key => key  ,
      ta => ta  ,
      ha => ha  ,
      clk  => clk  ,
      cl   => cl  ) ; 
      
      --Reloj
      clk <= not (clk) after 10 ns;
      
      --entradas
     stimulus : process 
begin


 wait for 10 ns; 
 cl <= '0';
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('M'),8));
 wait on ack; --en cuanto se produce un cambio de 1 a 0 o de 0 a 1 salta de este wait
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('K'),8));
 wait on ack; 
 ready <='0';
 wait on ack;
 ready <='1';
  char<=std_logic_vector(to_unsigned(character'pos(CR),8));
 wait on ack; 
 cmd_ack<='1';
 ready <='0';
 
 
wait for 5 ns; 
 cl <= '1';
 cmd_ack<='0';
 
 wait for 10 ns; 
 cl <= '0';
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('M'),8));
 wait on ack; 
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('K'),8));
 wait on ack; 
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('+'),8));
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('V'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos(CR),8)); 
 wait on ack; 
 cmd_ack<='1';
 ready <='0';
 
  
wait for 5 ns; 
 cl <= '1';
 cmd_ack<='0';
 
 wait for 10 ns; 
 cl <= '0';
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('M'),8));
 wait on ack; 
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('K'),8));
 wait on ack; 
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('+'),8));
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('T'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('H'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos(':'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('1'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('3'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos(','),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('0'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos('1'),8)); 
 wait on ack;
 ready <='0';
 wait on ack;
 ready <='1';
 char<=std_logic_vector(to_unsigned(character'pos(CR),8)); 
 wait on ack; 
 cmd_ack<='1';
 ready <='0';

wait for 10 ns; 

END PROCESS; 
END;



