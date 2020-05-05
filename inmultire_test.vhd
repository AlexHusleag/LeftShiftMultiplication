LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY inmultire_test IS
GENERIC (per : time := 20 ns);
END inmultire_test;


ARCHITECTURE inmultire_test OF inmultire_test IS
COMPONENT inmultire
	PORT  ( clk      : IN  std_logic;
	        start    : IN  std_logic; 
	        reset    : IN  std_logic;
				     
	        A        : IN  std_logic_vector(3 DOWNTO 0);
	        B        : IN  std_logic_vector(3 DOWNTO 0);
			
	        rezultat : OUT std_logic_vector(7 DOWNTO 0);
	        valid    : OUT std_logic
		   );
END COMPONENT;
	

	SIGNAL clk		 : std_logic := '1';
	SIGNAL start	 : std_logic;
	SIGNAL reset	 : std_logic;
	
	SIGNAL A		 : std_logic_vector(3 DOWNTO 0);
	SIGNAL B         : std_logic_vector(3 DOWNTO 0);
	
	SIGNAL rezultat  : std_logic_vector(7 DOWNTO 0);
	SIGNAL valid     : std_logic;
	
	

BEGIN	

	 clk <= NOT clk AFTER per/2;
	 reset <= '0', '1' AFTER 2*per;
	 start <= '0', '1' AFTER 5*per, '0' AFTER 6*per, '1' AFTER 15*per, '0' AFTER 16*per;
	 A <= "0111", "1000" AFTER 25*per;
	 B <= "1011", "1000" AFTER 25*per;
	 
	 dut: inmultire
     PORT MAP( 
           clk       => clk, 
           reset     => reset, 
		   start     => start,
	 
           A         => A,  
           B         => B,  
    
           rezultat  => rezultat,     
           valid     => valid
      );

END inmultire_test;
