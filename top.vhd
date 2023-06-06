
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
	generic(
		dir: integer := 4096;
		bits : integer := 8
	);
	port(
	-------------------------------VGA---------------------------------------
		clk_12 : in std_logic; --25MHz
		HSync, VSync : out std_logic; --SE QUEDA
		Red, Green : out std_logic_vector(2 downto 0); --SE QUEDA
		Blue : out std_logic_vector (2 downto 1);--SE QUEDA
	-----------------------------UART_MEMORIA--------------------------------
		reset : in std_logic;
		--UART-------------------------------------------------------------------
		rx_in : in std_logic;	-- Entrada de datos uart_rx
		-------------------------------------------------------------------------
		PWM_OUT1  : out std_logic;
		PWM_OUT2  : out std_logic;
		PWM_OUT3  : out std_logic;
		PWM_OUT4  : out std_logic;
		PWM_OUT5  : out std_logic;
		PWM_OUT6  : out std_logic;	
		PWM_OUT7  : out std_logic;
		PWM_OUT8  : out std_logic;
		PWM_OUT9  : out std_logic;		
		PWM_OUT10  : out std_logic;
		PWM_OUT11  : out std_logic;
		PWM_OUT12  : out std_logic						
	);
end top;

architecture Behavioral of top is
----------------RELOJ PARA VGA------------------------------------------------
	signal clk_25 : std_logic;
----------------Señales de UART y Memoria-------------------------------------	
	signal uart_to_mem:std_logic_vector(7 downto 0); --esta signal es la que conecta los datos uart con la memoria 
	signal add_uart_mem: integer range 0 to dir - 1;
	signal begin_write: std_logic;
	---------------------SEÑALES A PARTE------------------------------
	signal direccion_vga: integer range 0 to dir -1;
	signal lectura_vga: std_logic;
	signal chequeo: std_logic;	
	signal colores: std_logic_vector(7 downto 0);
	-----------------------------------------------------------------
	signal ward: std_logic_vector(7 downto 0);
	-----------------------------------------------------------------
	signal en_fi1: std_logic;
	-----------------------------------------------------------------
	signal mem_lin1: integer range 0 to 63;
	signal pwm1_data: std_logic_Vector(7 downto 0);
	-----------------------------------------------------------------
	signal en_fi2: std_logic;
	-----------------------------------------------------------------
	signal mem_lin2: integer range 0 to 63;
	signal pwm2_data: std_logic_Vector(7 downto 0);
	-----------------------------------------------------------------
	signal en_co1: std_logic;
	-----------------------------------------------------------------
	signal mem_co1: integer range 0 to 63;
	signal pwm3_data: std_logic_Vector(7 downto 0);	
	-----------------------------------------------------------------
	signal en_co2: std_logic;
	-----------------------------------------------------------------
	signal mem_co2: integer range 0 to 63;
	signal pwm4_data: std_logic_Vector(7 downto 0);	
	
begin

VGA_sync_1 : entity work.VGA_sync
	port map(
		--port_modulo (copia) => señales_top
		clk => clk_25,
		Red_in => colores(2 downto 0), 
		Green_in => colores(5 downto 3),
		Blue_in => colores(7 downto 6), 
		check_in => chequeo,
		HSync => HSync,
		VSync => VSync,
		read_en => lectura_vga,
		address_vga => direccion_vga, 
		Red => ward(2 downto 0),
		Green => ward(5 downto 3),
		enable_fi1 => en_fi1,
		enable_fi2 => en_fi2,
		memo_lin1 => mem_lin1,
		memo_lin2 => mem_lin2,
		enable_co1 => en_co1,
		memo_co1 => mem_co1,
		enable_co2 => en_co2,
		memo_co2 => mem_co2,				
		Blue => ward(7 downto 6)
	);
	
clock_25_1 :  entity work.clock_25
	port map(
		CLKIN_IN => clk_12,
		CLKFX_OUT => clk_25
	);
Mem1: entity work.Memoria port map(
	clk => clk_25,
	write_en => begin_write,
	address => add_uart_mem,
	address_vga => direccion_vga,	
   data_in  => uart_to_mem, 
   data_out => colores,  
	read_en => lectura_vga,
	reset => reset,
	check_out => chequeo	
);

UART: entity work.uart_rx port map(
	clk => clk_25,
	reset => reset,
	rx_in => rx_in,
	read_data => begin_write,
	rx_data => uart_to_mem,
	address => add_uart_mem
);

PWM_1: entity work.Pwm port map(
		CLK => clk_25,
		RED => pwm1_data(2 downto 0),
		PWM1 => PWM_OUT1,
		GREEN => pwm1_data(5 downto 3),
		PWM2 => PWM_OUT2,
		BLUE => pwm1_data(7 downto 6),
		PWM3 => PWM_OUT3
);

MEM_2: entity work.MEM2 port map(
	clk => clk_25,
   write_en => en_fi1,  
   data_in  => ward,
   data_out  => pwm1_data,
	reset => reset,
	memo_lin1 => mem_lin1	
);

PWM_3: entity work.Pwm1 port map(
		CLK => clk_25,
		RED => pwm2_data(2 downto 0),
		PWM1 => PWM_OUT4,
		GREEN => pwm2_data(5 downto 3),
		PWM2 => PWM_OUT5,
		BLUE => pwm2_data(7 downto 6),
		PWM3 => PWM_OUT6
);

MEM_3: entity work.MEM3 port map(
	clk => clk_25,
   write_en => en_fi2,  
   data_in  => ward,
   data_out  => pwm2_data,
	reset => reset,
	memo_lin1 => mem_lin2	
);

PWM_4: entity work.Pwm2 port map(
		CLK => clk_25,
		RED => pwm3_data(2 downto 0),
		PWM1 => PWM_OUT7,
		GREEN => pwm3_data(5 downto 3),
		PWM2 => PWM_OUT8,
		BLUE => pwm3_data(7 downto 6),
		PWM3 => PWM_OUT9
);

MEM_4: entity work.MEM4 port map(
	clk => clk_25,
   write_en => en_co1,  
   data_in  => ward,
   data_out  => pwm3_data,
	reset => reset,
	memo_lin1 => mem_co1	
);

PWM_5: entity work.Pwm3 port map(
		CLK => clk_25,
		RED => pwm4_data(2 downto 0),
		PWM1 => PWM_OUT10,
		GREEN => pwm4_data(5 downto 3),
		PWM2 => PWM_OUT11,
		BLUE => pwm4_data(7 downto 6),
		PWM3 => PWM_OUT12
);

MEM_5: entity work.MEM5 port map(
	clk => clk_25,
   write_en => en_co2,  
   data_in  => ward,
   data_out  => pwm4_data,
	reset => reset,
	memo_lin1 => mem_co2	
);


	RED <= ward(2 downto 0);
	GREEN <= ward(5 downto 3);
	BLUE <= ward(7 downto 6);
end Behavioral;

