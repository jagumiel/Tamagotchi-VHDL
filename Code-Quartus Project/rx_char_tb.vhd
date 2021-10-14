LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY rx_char_tb  IS 
END ; 
 
ARCHITECTURE rx_char_tb_arch OF rx_char_tb IS
  SIGNAL ready    :  STD_LOGIC :='1' ; 
  SIGNAL clk      :  STD_LOGIC :='1' ; 
  SIGNAL char     :  std_logic_vector (7 downto 0) ; 
  SIGNAL rx       :  STD_LOGIC :='1' ; 
  SIGNAL cl       :  STD_LOGIC :='1'; 
  SIGNAL ack      :  STD_LOGIC :='0' ; 
  COMPONENT rx_char  
    PORT ( 
      ready   : out STD_LOGIC ; 
      clk     : in STD_LOGIC ; 
      char    : out std_logic_vector (7 downto 0) ; 
      rx      : in STD_LOGIC ; 
      cl      : in STD_LOGIC ; 
      ack     : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : rx_char  
    PORT MAP ( 
      ready   => ready  ,
      clk     => clk  ,
      char    => char  ,
      rx      => rx  ,
      cl      => cl  ,
      ack     => ack   ) ; 
      
      --Reloj
      clk <= not (clk) after 10 ns;
      
      --entradas
     stimulus : process 
begin
  --clk <= not (clk) after 10 ns; 
 wait for 10 ns; 
 cl <= '0';
 rx<='0';
 wait for 104.2 us;
  rx<='0';
 wait for 104.2 us;
  rx<='1';
 wait for 104.2 us;
  rx<='1';
 wait for 104.2 us;
  rx<='0';
 wait for 104.2 us;
  rx<='1';
 wait for 104.2 us;
  rx<='0';
  wait for 104.2 us;
  rx<='1';
  wait for 104.2 us;
  rx<='1';
  wait for 104.2 us;
  rx<='1';
  wait for 1 ms;
        
END PROCESS; 
END;

