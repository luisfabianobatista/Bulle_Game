library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op: 						in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: 	out STD_LOGIC;
			branch, branchmode, alusrc: 		out STD_LOGIC;
			regdst, regwrite: 	out STD_LOGIC;
			jump: 					out STD_LOGIC;
			jumpmode: 				out STD_LOGIC_VECTOR(1 downto 0);
			aluop: 					out STD_LOGIC_VECTOR (1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(11 downto 0);
begin
	process(op) begin
		case op is
			when "000000" => controls <= "110000000010"; -- Rtyp
			when "100011" => controls <= "101000100000"; -- LW
			when "101011" => controls <= "001001000000"; -- SW
			when "000100" => controls <= "000100000001"; -- BEQ
			when "000001" => controls <= "000110000001"; -- BGE
			when "001000" => controls <= "101000000000"; -- ADDI
			when "000010" => controls <= "000000010000"; -- J
			when "000011" => controls <= "100000010100"; -- JAL
			when "000101" => controls <= "000000011000"; -- JR
			
			when others => controls <= "------------"; -- illegal op
		end case;
	end process;
	regwrite <= controls(11);
	regdst <= controls(10);
	alusrc <= controls(9);
	branch <= controls(8);
	branchmode <= controls(7);
	memwrite <= controls(6);
	memtoreg <= controls(5);
	jump <= controls(4);
	jumpmode <= controls(3 downto 2);
	aluop <= controls(1 downto 0);
end;