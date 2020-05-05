LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY inmultire_control IS
PORT (
		 clk       : IN  std_logic;
		 reset     : IN  std_logic;
		 
		 -- FSM inputs
		 start     : IN  std_logic;
		 n_is_zero : IN  std_logic;
		 MSB_A     : IN  std_logic;
		 
		 -- FSM outputs
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
END inmultire_control;

ARCHITECTURE inmultire_control OF inmultire_control IS

	TYPE state IS (S0, S1, S2, S3, S4);
	SIGNAL currentState        : state;
    SIGNAL nextState           : state;
    SIGNAL load_rezultat_valid : std_logic;
	
BEGIN

CLC: PROCESS ( currentState, start, n_is_zero, MSB_A) BEGIN
  CASE currentState IS
    WHEN S0 => IF ( start   = '1' ) THEN
      	            nextState <= S1;
               ELSE 
      	            nextState <= S0;
               END IF; 
    WHEN S1 => nextState <= S2;
	WHEN S2 => IF (MSB_A     = '1') THEN
					nextState <= S3;
			   ELSE
					nextState <= S4;
			   END IF;
	WHEN S3 => nextState <= S4;
	WHEN S4 => IF(n_is_zero = '1')  THEN
					nextState <= S0;
			   ELSE
					nextState <= S1;
			   END IF;
  END CASE;
END PROCESS CLC;


REG: PROCESS ( clk ) BEGIN
  IF (clk'EVENT AND clk = '1') THEN
    IF (reset = '0') THEN
        currentState <= S0;
    ELSE
        currentState <= nextState;
    END IF;
  END IF;
END PROCESS REG;


--FSM outputs
load_A              <= '1' WHEN ((currentState = S0) AND (start = '1'))                      ELSE '0';
load_B              <= '1' WHEN ((currentState = S0) AND (start = '1'))                      ELSE '0';
clear_produs        <= '1' WHEN ((currentState = S0) AND (start = '1'))                      ELSE '0';
shift_produs        <= '1' WHEN  (currentState = S1)                                         ELSE '0';
load_produs         <= '1' WHEN ((currentState = S2) AND (MSB_A = '1'))                      ELSE '0';
shift_A             <= '1' WHEN ((currentState = S3) OR (currentState = S2 AND MSB_A = '0')) ELSE '0';
decrement_n         <= '1' WHEN ((currentState = S4) AND (n_is_zero = '0'))                  ELSE '0';

load_rezultat_valid <= '1' WHEN ((currentState = S4) AND (n_is_zero = '1'))                  ELSE '0';
load_rezultat       <= load_rezultat_valid;


-- valid is load_rezultat delayed
PROCESS ( clk ) BEGIN
  IF (clk'EVENT AND clk = '1') THEN
    IF (reset = '0') THEN
        valid <= '0';
    ELSE
        valid <= load_rezultat_valid;
    END IF;
  END IF;
END PROCESS;


END inmultire_control;