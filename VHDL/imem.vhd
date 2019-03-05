library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all; 
use IEEE.STD_LOGIC_ARITH.all;

entity imem is -- instruction memory
	port (a: 	in STD_LOGIC_VECTOR (5 downto 0);
			rd: 	out STD_LOGIC_VECTOR (31 downto 0));
end;
architecture behave of imem is
begin
	--La ligne suivane etait comme "process is" 
	process (a)is

		type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
		variable mem: ramtype;
begin
	-- initialize memory from file
	for i in 0 to 63 loop -- set all contents low
		mem (conv_integer(i)) := CONV_STD_LOGIC_VECTOR (0, 32);
	end loop;

	mem (0) := x"20020005"; 
	mem (1) := x"2003000c"; 
	mem (2) := x"2067fff7"; 
	mem (3) := x"00e22025"; 
	mem (4) := x"00642824";
	mem (5) := x"00a42820";
	mem (6) := x"10a7000a";
	mem (7) := x"0064202a";
	mem (8) := x"10800001";
	mem (09) := x"20050000";
	mem (10) := x"00e2202a";
	mem (11) := x"00853820";
	mem (12) := x"00e23822";
	mem (13) := x"ac670044";
	mem (14) := x"8c020050";
	mem (15) := x"0482000a";
	mem (16) := x"0c000013";
	mem (17) := x"04450004";
	mem (18) := x"20020001";
	mem (19) := x"00a31030";
	mem (20) := x"17E00000";
	mem (21) := x"20020001";
	mem (22) := x"04420001";
	mem (23) := x"20020001";
	mem (24) := x"0800001a";
	mem (25) := x"20020001";
	mem (26) := x"ac020054";
	
	-- read memory

		rd <= mem(CONV_INTEGER(a));

	end process;
end;