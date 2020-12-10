library ieee;
use ieee.std_logic_1164.all;

entity fwdUnit is
    port(
        Rs1:                in std_logic_vector(4 downto 0);    -- operand register 1 from instruction
        Rs2:                in std_logic_vector(4 downto 0);    -- operand register 2 form instruction 
        EX_MEM_Rd:          in std_logic_vector(4 downto 0);    -- destination register after execution stage
        MEM_WB_Rd:          in std_logic_vector(4 downto 0);    -- destination register after memory stage
        EX_MEM_Write_Back:  in std_logic;                       -- write back to register file signal after execution stage
        MEM_WB_Write_Back:  in std_logic;                       -- write back to register file signal after memory stage
        Forward_A:          out std_logic_vector(1 downto 0);   -- ALU operand 1 mux selection
        Forward_B:          out std_logic_vector(1 downto 0)    -- ALU operand 2 mux selection
        );
end entity fwdUnit;

architecture behavioral of fwdUnit is

begin
    proc_fwd_A: process(Rs1, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Write_Back, MEM_WB_Write_Back)
                begin
                    Forward_A <= "00";      -- default output, operand 1 from register file
                    
                    -- EX_MEM forwarding
                    -- forward if Rd is not x0 and the instruction will write back to memory
                    if (Rs1 = EX_MEM_Rd) and (EX_MEM_Rd /= "00000") and (EX_MEM_Write_Back = '1') then    
                        Forward_A <= "10";  -- forward: operand 1 from execution stage
                    
                    -- MEM_WB forwarding
                    -- forward if Rd is not x0 and the instruction will write back to memory
                    elsif(Rs1 = MEM_WB_Rd) and (MEM_WB_Rd /= "00000") and (MEM_WB_Write_Back = '1') then
                        Forward_A <= "01";  -- forward: operand 1 from memory stage
                        
                    end if;
                                        
                    end process proc_fwd_A;
                    
        proc_fwd_B: process(Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Write_Back, MEM_WB_Write_Back)
            begin
                Forward_B <= "00";      -- default output, operand 2 from register file
                
                -- EX_MEM forwarding
                -- forward if Rd is not x0 and the instruction will write back to memory
                if (Rs2 = EX_MEM_Rd) and (EX_MEM_Rd /= "00000") and (EX_MEM_Write_Back = '1') then    
                    Forward_B <= "10";  -- forward: operand 2 from execution stage
                
                -- MEM_WB forwarding
                -- forward if Rd is not x0 and the instruction will write back to memory
                elsif(Rs1 = MEM_WB_Rd) and (MEM_WB_Rd /= "00000") and (MEM_WB_Write_Back = '1') then
                    Forward_B <= "01";  -- forward: operand 2 from memory stage
                    
                end if;
                
                end process proc_fwd_B;
                        

end architecture behavioral;
