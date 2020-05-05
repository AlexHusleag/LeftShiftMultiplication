LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY inmultire IS

PORT ( 
			clk      : IN  std_logic;
		    reset    : IN  std_logic;
	        start    : IN  std_logic; 
			
	        A        : IN  std_logic_vector(3 DOWNTO 0);
	        B        : IN  std_logic_vector(3 DOWNTO 0);
			
	        rezultat : OUT std_logic_vector(7 DOWNTO 0);
	        valid    : OUT std_logic
	  );	
END inmultire;


ARCHITECTURE inmultire OF inmultire IS
	COMPONENT inmultire_date
		PORT (
			clk           : IN  std_logic;
			reset         : IN  std_logic;
	        start         : IN  std_logic; 
			
			A             : IN  std_logic_vector(3 DOWNTO 0);
			B             : IN  std_logic_vector(3 DOWNTO 0);
			
			MSB_A         : OUT std_logic;
		    n_is_zero     : OUT std_logic;
		    rezultat      : OUT std_logic_vector(7 DOWNTO 0);
			
			-- FSM SIGNALS
			load_produs   : IN std_logic;
			load_A        : IN std_logic;
			load_B        : IN std_logic;
			shift_produs  : IN std_logic;
			shift_A       : IN std_logic; 
			load_rezultat : IN std_logic;
			decrement_n   : IN std_logic;
			clear_produs  : IN std_logic
			
		);	
	END COMPONENT;
	
	COMPONENT inmultire_control
		PORT (
			clk            : IN  std_logic;
            reset          : IN  std_logic;
			
			--FSM inputs
            start          : IN  std_logic;
            n_is_zero      : IN  std_logic;
			MSB_A          : IN  std_logic;
			
			--FSM outputs
            load_A        : OUT std_logic;
			load_B        : OUT std_logic;
			load_produs   : OUT std_logic;
			shift_produs  : OUT std_logic;
			shift_A       : OUT std_logic; 
			load_rezultat : OUT std_logic;
			decrement_n   : OUT std_logic;
			clear_produs  : OUT std_logic;
			
			valid         : OUT std_logic
		);
	END COMPONENT;
	
-- signals to connect inmultire/inmultire_control  
SIGNAL load_A, load_B, load_produs, shift_produs, shift_A, load_rezultat, decrement_n, clear_produs, n_is_zero, MSB_A: std_logic; 


BEGIN
	i_inmultire: inmultire_date
	PORT MAP(
		clk           => clk, 
        reset         => reset, 
		start         => start,
					  
		A             => A,
		B             => B,
		
		load_A        => load_A,  
        load_B        => load_B,  
        load_produs   => load_produs,
        shift_produs  => shift_produs, 
        shift_A       => shift_A ,  
        load_rezultat => load_rezultat ,  
        decrement_n   => decrement_n ,
        clear_produs  => clear_produs,
		
		n_is_zero     => n_is_zero,
		MSB_A         => MSB_A,
		rezultat      => rezultat
	);
	
	i_ctrl: inmultire_control
	PORT MAP(
	    clk         => clk, 
        reset       => reset, 

        start       => start,  
        n_is_zero   => n_is_zero,
	    MSB_A       => MSB_A,		
		
		load_A        => load_A,  
        load_B        => load_B,    
        load_produs   => load_produs,
        shift_produs  => shift_produs, 
        shift_A       => shift_A,
		load_rezultat => load_rezultat,
	    decrement_n   => decrement_n,
	    clear_produs  => clear_produs,
		
		valid         => valid
	);
	
END inmultire;