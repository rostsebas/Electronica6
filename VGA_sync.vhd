----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity VGA_sync is

	generic(
		count_h : integer := 800;
		dir: integer := 4096;
		--t_pixel : integer := 10; -- 10 -1 de divicion 640/64
		count_v : integer := 525	
	);

	port(
		clk : in std_logic; --25MHz
		Red_in,Green_in : in std_logic_vector (2 downto 0); -- entrada de rojo y verde
		Blue_in: in std_logic_vector (2 downto 1);-- entrada de azul
		check_in : in std_logic;-- entrada de check_out
		HSync, VSync : out std_logic;
		Red, Green : out std_logic_vector(2 downto 0);
		read_en : out std_logic;
		address_vga : out integer range 0 to dir -1;
		enable_fi1: out std_logic;
		enable_fi2: out std_logic;
		enable_co1: out std_logic;
		enable_co2: out std_logic;
		memo_lin1: out integer range 0 to 63;
		memo_lin2: out integer range 0 to 63;		
		memo_co1: out integer range 0 to 63;
		memo_co2: out integer range 0 to 63;
		Blue : out std_logic_vector (2 downto 1)
	);
end VGA_sync;

architecture Behavioral of VGA_sync is
	signal columna :  integer range 0 to count_h-1;
	signal linea :  integer range 0 to count_v-1;
	signal pos_actual : integer range 0 to dir - 1 :=0;
	--signal pos_inicial : integer range 0 to dir -1 := 0;
	--signal cont_pos_h : integer range 0 to t_pixel - 1:= 0 ;
	--signal cont_pos_v : integer range 0 to 6 := 0;-- corresponde
	signal pos_max : integer range 63 to dir - 1:= 63;
	signal pos_base : integer range 0 to dir - 64:= 0;
	signal mem_lin1 : integer range 0 to 63:=0;
	signal mem_lin2 : integer range 0 to 63:=0;
	signal mem_co1 : integer range 0 to 63:=0;
	signal mem_co2 : integer range 0 to 63:=0;	

begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			--HSync signal
			if (columna>=96) then
				HSync <= '1';
			else
				HSync <= '0';
			end if;
			--VSync signal
			if (linea>=2) then
				VSync <= '1';
			else
				VSync <= '0';
			end if;
			--Frame H(0 - 799) V(0-524)
			if (columna = 799) then
				columna <= 0;
				linea <= linea+1;
				--SEÑAL OUT PARA CHEQUEO DE PROMEDIOS
				--cont_pos_v <= cont_pos_v + 1; --contador de cada 7 lineas para agrandar vertical
				if (linea > 86 and linea < 469)then
					pos_base <= pos_base + 64;
					pos_max <= pos_max+64;
				else
					pos_base <= 0;
			--		pos_max <= 63;
				end if;
				
				if (linea=524) then
					
					linea <= 0;
					--cont_pos_v <= 0;
					--pos_inicial <= 0;
				end if;
			else
				columna <= columna +1;
			end if;
			--Imagen (parte visible del frame)
			--Recordar que check_in 	
		
				if(check_in = '1')then
						read_en <= '1';
						If(linea >= 86) and (linea <= 469) and (columna >= 100) and (columna <= 739) then	
							address_vga <= pos_actual ;
							pos_actual <= pos_actual + 1;
							if (pos_actual = pos_max) then
									pos_actual <= pos_base;
							end if;
						else 
							read_en <= '0';	--Debemos de apagar la lectura porque sino, se seguirá recoriendo la memoria
						end if;
						
						if(pos_actual = dir -1) then
							pos_actual <= 0;
							pos_max <= 63;
							pos_base <= 0;
						end if;
---------------------------------------------------------------------------------------------------
					if(linea >= 86) and (linea <= 186)and (columna >= 100) and (columna <= 739) then
						enable_fi1 <= '1';
						
						if (mem_lin1 < 64)then 
							mem_lin1 <= mem_lin1 +1;
						else
							mem_lin1 <= 0;
						end if;
						
					else 
						enable_fi1 <= '0';
					end if;
---------------------------------------------------------------------------------------------------
					if(linea >= 369) and (linea <= 469) and (columna >= 100) and (columna <= 739) then
						enable_fi2 <= '1';
						
						if (mem_lin2 < 64)then 
							mem_lin2 <= mem_lin2 +1;
						else
							mem_lin2 <= 0;
						end if;
						
					else 
						enable_fi2 <= '0';
					end if;
---------------------------------------------------------------------------------------------------	
---------------------------------------------------------------------------------------------------
					if(linea >= 150) and (linea <=213 ) and (columna = 163) then
						enable_co1 <= '1';
						
						if (mem_co1 < 64)then 
							mem_co1 <= mem_co1 +1;
						else
							mem_co1 <= 0;
						end if;
						
					else 
						enable_co1 <= '0';
					end if;
---------------------------------------------------------------------------------------------------					
					if(linea >= 150) and (linea <=213 ) and (columna =675 ) then
						enable_co2 <= '1';
						
						if (mem_co2 < 64)then 
							mem_co2 <= mem_co2 +1;
						else
							mem_co2 <= 0;
						end if;
						
					else 
						enable_co2 <= '0';
					end if;
----------------------------------------------------------------------------------------------------------				
				end if;	
						
				end if;

	end process;	
		
	Red <= Red_in;
	Green <= Green_in;
	Blue <= Blue_in;
	memo_lin1 <= mem_lin1;	
	memo_lin2 <= mem_lin2;
	memo_co1 <= mem_co1;	
	memo_co2 <= mem_co2;	
end Behavioral;