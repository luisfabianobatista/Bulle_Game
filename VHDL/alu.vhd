library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity alu is
port(   --clk : in std_logic; --clock signal
        a,b : in std_logic_vector(31 downto 0); --input operands
        alucontrol: in std_logic_vector(2 downto 0); --Operation to be performed
        result : out std_logic_vector(31 downto 0);  --output of ALU
        zero: out STD_LOGIC);
end alu;

architecture Behavioral of alu is

--temporary signal declaration.
signal Reg1,Reg2,Reg3 : signed(31 downto 0) := (others => '0');

begin
process(a,b,Reg3)
begin
		Reg1 <= SIGNED(a);
		Reg2 <= SIGNED(b);
		result <= STD_LOGIC_VECTOR(Reg3);
end process;


process(Reg1,Reg2,alucontrol)
	begin
		--if clk'event and clk='1' then
        case alucontrol is
            when "010" => 
                Reg3 <= Reg1 + Reg2;  --addition
            when "110" => 
					Reg3 <= Reg1 - Reg2; --subtraction
            when "000" => 
                Reg3 <= Reg1 and Reg2;  --AND gate
            when "001" => 
                Reg3 <= Reg1 or Reg2;  --OR gate  
            when "111" => -- slt gate
					 if Reg1 < Reg2 then
						Reg3 <= to_signed(1,32);
					 else
						Reg3 <= to_signed(0,32);
					 end if;
                --Reg3 <= Reg1 xor Reg2; --XOR gate (Not implemented)
				when "011" => 
                Reg3 <= Reg1(15 downto 0) * Reg2(15 downto 0); --multiplication of low order bits		
            when others =>
                NULL;

        end case;  

			if Reg1 = Reg2 then
				zero <= '1';
			else
				zero <= '0';
			end if;
		-- end if;
end process;    

end Behavioral;