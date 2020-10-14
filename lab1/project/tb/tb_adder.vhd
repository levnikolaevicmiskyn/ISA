library ieee; 
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_adder is
end entity tb_adder;

architecture test of tb_adder is

	component adder
		generic	(
					N_BIT 	: positive
				);
		port(
				a			: in signed(N_BIT-1 downto 0);
				b			: in signed(N_BIT-1 downto 0);
				carry_in	: in std_logic;
				sum			: out signed(N_BIT-1 downto 0);
				carry_out	: out std_logic
			);
	end component adder;
	
	signal a_in, b_in, sum_out: signed(3 downto 0); 
	signal c_in, c_out: std_logic;

begin

	input_proc: process
        begin
            a_in <= "0000";
            b_in <= "0000";
            c_in <= '0';
            wait for 10 ns;
            
            loop
                if a_in /= "1111" then
                    a_in <= a_in + "0001";
                else
                    a_in <= "0000";
                    if b_in /= "1111" then
                        b_in <= b_in + "0001";
                    else
                        b_in <= "0000";
                        c_in <= not c_in;
                    end if;
                end if;
                wait for 10 ns;
            end loop;
            wait;
        end process input_proc;
        
	DUT: adder generic map (N_BIT => 4)
			port map(
						a			=> a_in,
						b			=> b_in,
						carry_in	=> c_in,
						sum			=> sum_out,
						carry_out	=> c_out
					);

end architecture test;
