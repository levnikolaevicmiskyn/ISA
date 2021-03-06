library ieee;
use ieee.std_logic_1164.all;

library work;
use work.globals;
use work.ALUpkg;

entity ALU is
    port (
        -- Control signals
        operation: globals.t_ALU_OP;
        -- Operands and result
        operand1: in std_logic_vector(31 downto 0);     -- First operand
        operand2: in std_logic_vector(31 downto 0);     -- Second operand
        result: out std_logic_vector(31 downto 0);      -- Result
        -- Flags
        N: out std_logic;   -- Negative flag
        Z: out std_logic;   -- Zero flag
        C: out std_logic;   -- Carry out flag
        V: out std_logic    -- Overflow flag
    );
end entity ALU;

architecture structure of ALU is
    component ALUController is
        port (
            operation: in globals.t_ALU_OP; -- ALU abstract operation
            control: out ALUpkg.t_Control   -- Control signals
        );
    end component;

    component ALUDatapath is
        port (
            -- Control
            control:  in ALUpkg.t_Control;
            -- Operands and result
            operand1: in  std_logic_vector(31 downto 0);     -- First operand
            operand2: in  std_logic_vector(31 downto 0);     -- Second operand
            result:   out std_logic_vector(31 downto 0);     -- Result
            -- Flags
            N: out std_logic; -- Negative
            Z: out std_logic; -- Zero
            C: out std_logic; -- Carry out
            V: out std_logic  -- Signed Overflow
        );
    end component;
    signal control: ALUpkg.t_Control;
begin
    comp_controller: ALUController
        port map(operation, control);

    comp_datapath: ALUDatapath
        port map(control, operand1, operand2, result, N, Z, C, V);
end architecture structure;
