----------------------------------------------------------------------------------
-- RAM (dir*bits)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Memoria is
	generic(
		bits : integer := 8;
		dir :	integer	:= 4096
	);
	
	port (	
		clk : in std_logic;
      write_en : in std_logic; --(0-leyendo/1-escribiendo) Cable del UART
      address : in integer range 0 to dir - 1;--Contador de integers del UART
		address_vga : in integer range 0 to dir -1;--Dejarlo como una señal, contador integers VGA
      data_in   : in std_logic_vector(bits - 1 downto 0);
      data_out   : out std_logic_vector(bits - 1 downto 0):= (others => '0');
		read_en : in std_logic;
		reset : in std_logic;
		check_out : out std_logic
	
	);		
end Memoria;

architecture Behavioral of Memoria is
type ram_16x8 is array (0 to dir - 1) of std_logic_vector (bits - 1 downto 0);
signal mem: ram_16x8;


type FSM  is (write_in, read_out);
signal memstate : FSM;

begin

	process (clk,reset)
	begin
		if (reset ='0') then
			memstate <=write_in;
			check_out <= '0';
			
		elsif (rising_edge(clk))then
			case memstate is
				when write_in=>		-- en este estado se encuetra a la espera de todos los datos
					
					if(write_en ='1') then
						mem(address) <= data_in;	--- mientras este activado se escribe el dato en la posicon de la memoria
						if (address= dir-1)then		-- se se llena la memoria entonces se cambia al estado de lectura o salida de la memoria
							check_out <= '1';
							memstate <= read_out; --cambia al siguiente estado
						else
							check_out <= '0';
						end if;
					else 
						memstate <= write_in;
					end if;
					
				when  read_out =>
					if (read_en ='1') then
						data_out <= mem(address_vga);
					else 
						data_out <= (others => '0');
						memstate <= read_out;
					end if;
			end case;

		end if;
	end process;
	
	
end Behavioral;


