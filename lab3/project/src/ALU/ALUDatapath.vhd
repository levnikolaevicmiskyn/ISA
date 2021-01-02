library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALUpkg

entity ALUDatapath is
    port (
        -- Control
        control:  in ALUpkg.t_Control
        -- Operands and result
        operand1: in  std_logic_vector(31 downto 0);     -- First operand
        operand2: in  std_logic_vector(31 downto 0);     -- Second operand
        result:   out std_logic_vector(31 downto 0)      -- Result
        -- Flags
        signal N: out std_logic; -- Negative
        signal Z: out std_logic; -- Zero
        signal C: out std_logic; -- Carry out
        signal V: out std_logic  -- Signed Overflow
    );
end entity ALUDatapath;

architecture structure of ALUDatapath is
    component adder is
        generic (N : positive := 32);
        port (
            a: in  std_logic_vector(N-1 downto 0);  -- First operand
            b: in  std_logic_vector(N-1 downto 0);  -- Second operand
            sub: in std_logic;                      -- Subtract instead of adding
            s: out std_logic_vector(N-1 downto 0);  -- Sum
            ovf: out std_logic;                     -- Overflow
            cout: out std_logic                     -- Output carry
        );
    end component;

    component barrelShifter is
        generic (
            N: natural := 32;           -- Input size
            SHA_SIZE: natural := 5      -- Shift amount size (usually log2(N))
        );
        port (
            x: in std_logic_vector(N-1 downto 0);           -- Operand
            sha: in std_logic_vector(SHA_SIZE-1 downto 0);  -- Shift amount
            y: out std_logic_vector(N-1 downto 0)           -- Result
        );
    end component;

    component comparatorExtension is
        generic (N : positive := 0)
        port (
            -- ALU flags
            N, Z, C, V: in std_logic;
            -- Control signals
            signed_data: in std_logic;
            comparison: in ALUpkg.t_Comparison;
            -- Result
            result: out std_logic_vector(N-1 downto 0)
        );
    end component;
    -- Internal results
    signal res_sum:     std_logic_vector(31 downto 0);
    signal res_shift:   std_logic_vector(31 downto 0);
    signal res_and:     std_logic_vector(31 downto 0);
    signal res_xor:     std_logic_vector(31 downto 0);
    signal res_comp:    std_logic_vector(31 downto 0);
    signal res_tmp:     std_logic_vector(31 downto 0);
    -- Flags
    signal flag_reference_result: std_logic_vector(31 downto 0);
    signal intN, intZ, intC, intV: std_logic;
begin
    -- Compute results
    comp_adder: adder
        generic map(32)
        port map(operand1, operand2, control.adder_sub, res_sum, intV, intC);

    comp_barrel_shifter: barrelShifter
        generic map(32, 5)
        port map(operand1, operand2(4 downto 0), res_shift);

    comp_comparator_extension: comparatorExtension
        generic map(32)
        port map(
            intN, intZ, intC, intV,
            control.comp_signed_data, control.comp_comparison,
            res_comp
        );
    res_and <= operand1 and operand2;
    res_xor <= operand1 xor operand2;

    -- Select requested result
    with control.operation select res_tmp <=
        res_sum              when ALUpkg.OP_SUM,
        res_shift            when ALUpkg.OP_SHIFT,
        res_and              when ALUpkg.OP_AND,
        res_xor              when ALUpkg.OP_XOR,
        res_comp             when ALUpkg.OP_COMP,
        (31 downto 0 => 'X') when others;

    -- Compute partial flags
    flag_reference_result <= res_sum;
    intN <= res_add(0);
    proc_Z_flag: process(flag_reference_result)
            variable nz: std_logic;
        begin
            nz := flag_reference_result(0);
            for i in 1 to 31 loop
                nz := nz or flag_reference_result(i);
            end loop;
            intZ <= not nz;
        end process proc_Z_flag;

    -- Assign results
    result <= res_tmp;
    N <= intN;
    Z <= intZ;
    C <= intC;
    V <= intV;
end architecture structure;
