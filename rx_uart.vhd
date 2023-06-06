library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;



entity uart_rx is

	generic(

		contador_bits : integer := 217;  -- 25 MHz/115200 bps
		
		dir : integer := 4096;

		contador_half_bits : integer := 108  -- (12 MHz/115200 bps)*0.5
		
		

	);

	port(

		clk : in std_logic; -- Entrada de reloj y botón de reset
		reset: in std_logic;

		rx_in : in std_logic;	-- Entrada de datos uart_rx

		read_data : out std_logic;	-- Indicará cuando un dato se encuentre listo
		
		address: out integer range 0 to dir - 1;

		rx_data : out std_logic_vector(7 downto 0) -- Dato recibido (8 bits)
		

	);

end uart_rx;



architecture Behavioral of uart_rx is

	type uart_rx is (idle, start, data, stop); -- FSM uart_rx

	signal estados : uart_rx;

	signal contador : integer range 0 to contador_bits - 1 := 0;

	signal indice : integer range 0 to 7 := 0;	-- #bits del dato
	
	signal cont_address: integer range 0 to dir -1:= 0 ;

begin



	process (clk,reset)

	begin
		if (reset ='0') then
			read_data <= '0';
			cont_address <= 0;
			estados <= idle;

		elsif (rising_edge(clk)) then

			case estados is

				when idle =>

					contador <= 0;

					read_data <= '0';

					indice <= 0;

					if (rx_in = '0') then

						estados <= start;

					else

						estados <= idle;

					end if;

				when start =>

					if (contador = contador_half_bits) then

						case rx_in is

							when '0' =>

								contador <= 0;

								estados <= data;

							when others =>

								estados <= idle;

						end case;

					else

						contador <= contador + 1;

						estados <= start;

					end if;

				when data =>

					if (contador = contador_bits - 1) then

						contador <= 0;

						rx_data(indice) <= rx_in;

						if (indice = 7) then

							indice <= 0;

							estados <= stop;

						else

							indice <= indice + 1;

							estados <= data;

						end if;

					else

						contador <= contador + 1;

						estados <= data;

					end if;

				when stop =>

					if (contador = contador_bits -1) then

						contador <= 0;

						estados <= idle;
						
						read_data <= '0';
						
						cont_address <= cont_address + 1;

					else
					
						address <= cont_address; -- address

						read_data <= '1';--es el write enable que se utliza en la memoria
							
						contador <= contador + 1;

						estados <= stop;

					end if;

				when others =>

					estados <= idle;

			end case;

		end if;

	end process;

end Behavioral;
