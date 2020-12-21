library ieee;
use ieee.std_logic_1164.all;

entity ALU is
    port (
        -- Operands and result
        operand1: in std_logic_vector(31 downto 0);     -- First operand
        operand2: in std_logic_vector(31 downto 0);     -- Second operand
        result: out std_logic_vector(31 downto 0);      -- Result
        -- Control signals
        control: in std_logic_vector(2 downto 0);              -- Control signals
        -- Flags
        N: out std_logic;   -- Negative flag
        Z: out std_logic;   -- Zero flag
        C: out std_logic;   -- Carry out flag
        V: out std_logic    -- Overflow flag
    );
end entity ALU;

architecture structure of ALU is
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
            N: natural := 32;
            SHA_SIZE: natural := 5
        );
        port (
            x: in std_logic_vector(N-1 downto 0);           -- Operand
            sha: in std_logic_vector(SHA_SIZE-1 downto 0);  -- Shift amount
            y: out std_logic_vector(N-1 downto 0)           --
        );
    end component;

    -- Extended controls
    signal sub: std_logic;
    signal sel_result: std_logic_vector(1 downto 0);
    -- Internal results
    signal and_res: std_logic_vector(31 downto 0);
    signal xor_res: std_logic_vector(31 downto 0);
    signal sum_res: std_logic_vector(31 downto 0);
    signal shift_res: std_logic_vector(31 downto 0);
    signal res_select: std_logic_vector(1 downto 0);

    signal adder_cout: std_logic;
    signal adder_ovf: std_logic;
    signal internal_res: std_logic_vector(31 downto 0);
begin
    -- Controls
    sub <= control(2);
    sel_result <= control(1 downto 0);
    -- Operations
    and_res <= operand1 and operand2;
    xor_res <= operand1 xor operand2;
    comp_adder: adder
        generic map(32)
        port map(operand1, operand2, sub, sum_res, adder_ovf, adder_cout);
    comp_barrelShifter: barrelShifter
        generic map(32, 5)
        port map(operand1, operand2(4 downto 0), shift_res);

    -- Select actual result
    with res_select select internal_res <=
        sum_res when "00",
        shift_res when "01",
        and_res when "10",
        xor_res when "11",
        (31 downto 0 => 'X') when others;
    -- Generate flags
    N <= internal_res(31);
    proc_Z_flag: process(internal_res)
        variable temp_nz: std_logic;
    begin
        temp_nz := internal_res(0);
        for i in 1 to 31 loop
            temp_nz := temp_nz or internal_res(i);
        end loop;
        Z <= not temp_nz;
    end process proc_Z_flag;
    C <= adder_cout;
    V <= adder_ovf;
    -- Output result
    result <= internal_res;
end architecture structure;
