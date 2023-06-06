library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pwm3 is

Generic(
	Tt: Integer := 416667
--	Ta: Integer := 30000
);

Port(
		CLK:		in		Std_Logic;
		RED:		in		Std_Logic_Vector(2 downto 0);
		PWM1:		out	Std_Logic;
		GREEN:		in		Std_Logic_Vector(2 downto 0);
		PWM2:		out	Std_Logic;
		BLUE:		in		Std_Logic_Vector(1 downto 0);
		PWM3:		out	Std_Logic
		
);

end Pwm3;

architecture Behavioral of Pwm3 is

signal Cnt1: integer range 0 to Tt;
signal Ta1: integer range 0 to Tt;

signal Cnt2: integer range 0 to Tt;
signal Ta2: integer range 0 to Tt;

signal Cnt3: integer range 0 to Tt;
signal Ta3: integer range 0 to Tt;

begin



process(CLK)
	begin
			if(rising_edge(CLK)) then
-------------------Promedios que se obtienen para el rojo---------------
				Case RED is
					When "001" =>
						Ta1<=59524;
					When "010" =>
						Ta1<=119047;
					When "011" =>
						Ta1<=178571;
					When "100" =>
						Ta1<=238095;
					When "101" =>
						Ta1<=297618;
					When "110" =>
						Ta1<=357142;
					When "111" =>
						Ta1<=416666;
					When others =>
						Ta1<=10000;
				End Case;
-------------------Promedios que se obtienen para el verde---------------
				Case GREEN is
					When "001" =>
						Ta2<=59524;
					When "010" =>
						Ta2<=119047;
					When "011" =>
						Ta2<=178571;
					When "100" =>
						Ta2<=238095;
					When "101" =>
						Ta2<=297618;
					When "110" =>
						Ta2<=357142;
					When "111" =>
						Ta2<=416666;
					When others =>
						Ta2<=10000;
				End Case;
-------------------Promedios que se obtienen para el rojo---------------
				Case BLUE is
					When "01" =>
						Ta3<=138889;
					When "10" =>
						Ta3<=277777;
					When "11" =>
						Ta3<=416666;
					When others =>
						Ta3<=10000;
				End Case;				
-------------------Primer señal de PWM-------------------------				
				if(Cnt1=Tt-1) then
					Cnt1<=0;
				else
					Cnt1<=Cnt1+1;
				end if;
				
				if(Cnt1<Ta1) then
					PWM1<='0';
				else
					PWM1<='1';
				end if;
------------------Segunda señal de PWM--------------------------
				if(Cnt2=Tt-1) then
					Cnt2<=0;
				else
					Cnt2<=Cnt2+1;
				end if;
				
				if(Cnt2<Ta2) then
					PWM2<='0';
				else
					PWM2<='1';
				end if;
-----------------Tercera señal de PWM-----------------------------
				if(Cnt3=Tt-1) then
					Cnt3<=0;
				else
					Cnt3<=Cnt3+1;
				end if;
				
				if(Cnt3<Ta3) then
					PWM3<='0';
				else
					PWM3<='1';
				end if;				
			end if;
end process;

end Behavioral;