library ieee;
use ieee.std_logic_1164.all;

package globals is
    constant INSTR_MEM_START_ADDR: integer := 16#00400000#;
    constant INSTR_MEM_END_ADDR:   integer := 16#7fffffff#;
    constant DATA_MEM_START_ADDR:  integer := 16#10010000#;
    constant DATA_MEM_END_ADDR:    integer := 16#100101fc#;

    type t_ALU_OP is (
        alu_op_add,
        alu_op_shift,
        alu_op_abs,
        alu_op_and,
        alu_op_xor,
        alu_op_lt
    );
    type t_ALUInstructionType is (alu_sel_reg_reg, alu_sel_reg_imm, alu_sel_pc_imm, alu_sel_pc_4, alu_sel_0_imm, alu_sel_0_0);

    alias t_ALU_SEL is t_ALUInstructionType;
    
    constant PC_SEL_JUMP  : std_logic_vector(1 downto 0) := "10";
    constant PC_SEL_STALL : std_logic_vector(1 downto 0) := "01";
    constant PC_SEL_INC   : std_logic_vector(1 downto 0) := "00";

    function getOp(x : std_logic_vector(2 downto 0)) return t_ALU_OP;

    -- Record types
    type t_EXSigs is record
        op:           t_ALU_OP;
        oprnd_1:         std_logic_vector(31 downto 0);
        oprnd_2:         std_logic_vector(31 downto 0);
        immediate:        std_logic_vector(31 downto 0);
        pc:               std_logic_vector(31 downto 0);
        rs1:              std_logic_vector(4 downto 0);
        rs2:              std_logic_vector(4 downto 0);
        oprnd_sel: t_ALU_SEL;
    end record;

    type t_IFSigs is record
        load_jmp_addr : std_logic;
        jmp_addr      : std_logic_vector(31 downto 0);
        stall         : std_logic;
        load_nop      : std_logic;
    end record;

    type t_IDSigs is record
        inst    : std_logic_vector(31 downto 0);
        pc      : std_logic_vector(31 downto 0);
        next_pc : std_logic_vector(31 downto 0);
    end record;

    type t_MEMSigs is record
        mem_write    : std_logic;
        branch       : std_logic;
        branch_taken : std_logic;
        mem_read     : std_logic;
        alt_ta       : std_logic_vector(31 downto 0);
        data_for_mem: std_logic_vector(31 downto 0);
    end record;

    type t_WBSigs is record
        reg_write : std_logic;
        rd        : std_logic_vector(4 downto 0);
        mem_to_reg: std_logic;
    end record;

    type t_FWDSigs is record
        MEM_data: std_logic_vector(31 downto 0);
        WB_data: std_logic_vector(31 downto 0);
        sel_forward1: std_logic_vector(1 downto 0);
        sel_forward2: std_logic_vector(1 downto 0);
    end record;

    type t_EXData is record
        result : std_logic_vector(31 downto 0);
        N      : std_logic;
        Z      : std_logic;
        C      : std_logic;
        V      : std_logic;
    end record;
    constant NOP_INSTR : std_logic_vector(31 downto 0) := ((31 downto 7 => '0') & "0010011");
end package globals;

package body globals is
    function getOp(x : std_logic_vector(2 downto 0)) return t_ALU_Op is
        variable y : t_ALU_OP;
    begin
        case x is
            when "000"  => y := alu_op_add;
            when "001"  => y := alu_op_shift;
            when "010"  => y := alu_op_and;
            when "011"  => y := alu_op_xor;
            when "100"  => y := alu_op_lt;
            when "101"  => y := alu_op_abs;
            when others => y := alu_op_add;
        end case;
        return y;
    end function getOp;
end package body;
