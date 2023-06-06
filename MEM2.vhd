----------------------------------------------------------------------------------
-- RAM (dir*bits)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity MEM2 is
	generic(
		bits : integer := 8;
		dir :	integer	:= 64
	);
	
	port (	
		clk : in std_logic;
      write_en : in std_logic; --ENABLE QUE VIENE DEL VGA
      data_in   : in std_logic_vector(bits - 1 downto 0); --VIENE DEL VGA
      data_out   : out std_logic_vector(bits - 1 downto 0):= (others => '0'); --LO QUE VA AL PWM
		reset : in std_logic;
		-----------------------------------------------
		memo_lin1: in integer range 0 to 63 --SE CONECTA AL VGA	
	);		
end MEM2;

architecture Behavioral of MEM2 is
type ram_16x8 is array (0 to dir - 1) of std_logic_vector (bits - 1 downto 0);
signal mem: ram_16x8;


type FSM  is (write_in, read_out);
signal memstate : FSM;

signal mem_coder: integer range 0 to dir - 1;

begin

	process (clk,reset)
	begin
		if (reset ='0') then
			memstate <=write_in;
			
		elsif (rising_edge(clk))then
			case memstate is
				when write_in=>		-- en este estado se encuetra a la espera de todos los datos
					data_out <= "00000000";
					if(write_en ='1') then
						mem(memo_lin1) <= data_in;	--- mientras este activado se escribe el dato en la posicon de la memoria
						if (memo_lin1= dir-1)then		-- se se llena la memoria entonces se cambia al estado de lectura o salida de la memoria
							memstate <= read_out; --cambia al siguiente estado
						end if;
					else 
						memstate <= write_in;
					end if;
					
				when  read_out =>
						data_out <= mem(mem_coder);
						if (mem_coder = dir -1)then
							mem_coder <= 0;
						else 
							mem_coder <= mem_coder +1;
						end if;
			end case;
		end if;
	end process;
	
	
end Behavioral;

