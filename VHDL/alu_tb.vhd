library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity alu_tb is
end;
architecture test of alu_tb is
	component alu
		port (--clk : in std_logic; --clock signal
        a,b : in std_logic_vector(31 downto 0); --input operands
        alucontrol: in std_logic_vector(2 downto 0); --Operation to be performed
        result : out std_logic_vector(31 downto 0);  --output of ALU
        zero: out STD_LOGIC);
	end component;
	signal inputA: STD_LOGIC_VECTOR(31 downto 0);
	signal inputB: STD_LOGIC_VECTOR(31 downto 0);
	signal aluCTR: std_logic_vector(2 downto 0);
	signal aluRST: STD_LOGIC_VECTOR(31 downto 0);
	signal aluZero: std_logic;
	
	--signal r: integer;
	
	--signal clk: STD_LOGIC;
begin
	-- instantiate device to be tested
	dut: alu port map (inputA, inputB, aluCTR, aluRST, aluZero);
	-- Generate clock with 10 ns period
	
	--process begin
		--clk <= '1';
		--wait for 5 ns;
		--clk <= '0';
		--wait for 5 ns;
	--end process;
	
	process begin
	
	-- testing addition
	inputA <= std_logic_vector(to_signed(20,32));
	inputB <= std_logic_vector(to_signed(1001,32));
	aluCTR <="010"; 

	assert to_integer(signed(aluRST)) = 1021 report "addition failed";
	 wait for 5ns;
	 
	 --test subtraction
	 aluCTR <="110";
	 assert to_integer(signed(aluRST)) = 981 report "subtraction failed";
	 wait for 5ns;
	 
	 --test multiplication
	 aluCTR <="011";
	 assert to_integer(signed(aluRST)) = 20020 report "multiplication failed";
	 wait for 5ns;
	 
	 --test smaller than
	 	inputB <= std_logic_vector(to_signed(20,32));
		inputA <= std_logic_vector(to_signed(1001,32));
	 aluCTR <="111";
	 assert to_integer(signed(aluRST)) = 0 report "A>B slt failed";
	 wait for 5ns;
	 inputA <= std_logic_vector(to_signed(20,32));
		inputB <= std_logic_vector(to_signed(1001,32));
	 assert to_integer(signed(aluRST)) = 1 report "B > A slt failed";
	 wait for 5ns;
	
	--test if equal
		 inputB <= std_logic_vector(to_signed(40,32));
		inputA <= std_logic_vector(to_signed(40,32));
	 assert aluZero='1' report "equality failed";
	 wait for 5ns;
	 
	end process;
end;