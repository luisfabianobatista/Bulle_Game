library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

entity imem_tb is
end;
architecture test of imem_tb is
	component imem
		port (a: 	in STD_LOGIC_VECTOR (5 downto 0);
				rd: 	out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	signal addr: STD_LOGIC_VECTOR(5 downto 0);
	signal rdata: STD_LOGIC_VECTOR(31 downto 0);
	--signal clk: STD_LOGIC;
begin
	-- instantiate device to be tested
	dut: imem port map (addr, rdata);
	-- Generate clock with 10 ns period
	
	--process begin
		--clk <= '1';
		--wait for 5 ns;
		--clk <= '0';
		--wait for 5 ns;
	--end process;
	
	process begin
			for i in 0 to 26 loop
				addr <= STD_LOGIC_VECTOR(to_unsigned(i,6));
				wait for 5 ns;
			end loop;
	end process;
end;