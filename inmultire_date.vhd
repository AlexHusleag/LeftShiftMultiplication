LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;

ENTITY inmultire_date IS
PORT ( 
	   clk      : IN  std_logic;
	   reset    : IN  std_logic;
	   start    : IN  std_logic; 
	   
	   A        : IN  std_logic_vector(3  DOWNTO 0);
	   B        : IN  std_logic_vector(3  DOWNTO 0);
	   
	   MSB_A    : OUT std_logic;
	   n_is_zero: OUT std_logic;
	   rezultat : OUT std_logic_vector(7 DOWNTO 0);
	   
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
	  
END inmultire_date;

ARCHITECTURE inmultire_date OF inmultire_date IS
  SIGNAL reg_A     	  : std_logic_vector(3 DOWNTO 0);
  SIGNAL reg_B   	  : std_logic_vector(3 DOWNTO 0);
  SIGNAL reg_N        : std_logic_vector(3 DOWNTO 0);
  SIGNAL reg_P        : std_logic_vector(7 DOWNTO 0);
  SIGNAL reg_R        : std_logic_vector(7 DOWNTO 0);
BEGIN


-- reg_A
PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN 
			IF(reset = '0') THEN
				reg_A <= (others => '0');
			ELSIF (load_A = '1') THEN
				reg_A <= A;
			ELSIF (shift_A = '1' ) THEN
				--reg_A <= reg_A & "000X";
				reg_A <= reg_A(2 DOWNTO 0) & "X";
			END IF;
		END IF;
END PROCESS;

MSB_A <= reg_A(3);

-- reg_B
PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN 
			IF(reset = '0') THEN
				reg_B <= (others => '0');
			ELSIF (load_B = '1') THEN
				reg_B <= B;
			END IF;
		END IF;
END PROCESS;


-- reg_N
PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN 
			IF(reset = '0') THEN
				reg_N <= (others => '0');
			ELSIF (load_A = '1' AND load_B ='1') THEN
				reg_N <= "0100";
			ELSIF (decrement_n = '1') THEN
				reg_N <= reg_N - "0001";
			END IF;
		END IF;
END PROCESS;
n_is_zero <= '1' WHEN reg_N = "0001" ELSE '0';


-- reg_P
PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN 
			IF(reset = '0') THEN
				reg_P <= (others => '0');
			ELSIF (clear_produs='1') THEN
				reg_P <= (others => '0');
			ELSIF(load_produs = '1') THEN
				-- reg_P <= reg_P + ('0' & reg_B);
				reg_P <= reg_P + ("0000" & reg_B);
			ELSIF (shift_produs = '1') THEN
				reg_P <= reg_P(6 DOWNTO 0) & '0';
			END IF;
		END IF;
END PROCESS;
	
	
-- REG_R
PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN 
			IF (reset = '0') THEN 
				reg_R <= (others => '0');
			ELSIF (load_rezultat <= '1') THEN
				reg_R <= reg_P;
			END IF;
		END IF;
END PROCESS;
rezultat <= reg_R;


end inmultire_date;


