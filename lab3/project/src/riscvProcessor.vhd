library ieee;
use ieee.std_logic_1164.all;

entity riscvProcessor is
  port(clk: in std_logic);
end entity riscvProcessor;

architecture structure of riscvProcessor is

component IDStage is
port(clk: in std_logic;
	 -- From IF stage
	 ID_inst: in std_logic_vector(31 downto 0);
	 ID_pc: in std_logic_vector(31 downto 0);
	 ID_next_pc: in std_logic_vector(31 downto 0);
	 -- From EX stage
	 EX_rd_bw: in std_logic_vector(4 downto 0);
	 EX_mem_read_bw: in std_logic;
	 MEM_branch_wb: in std_logic;
	 -- From MEM IDStage
	 ID_misprediction: in std_logic
	 ID_alt_ta_bw: in std_logic_vector(31 downto 0);
	 -- From WB stage
	 WB_reg_write_bw: in std_logic;
	 WB_rd_bw: in std_logic_vector(4 downto 0);
	 WB_data: in std_logic_vector(31 downto 0);

	 -- IF stage control signals
	 IF_load_jmp_addr: out std_logic_vector(1 downto 0);
	 IF_jmp_addr: out std_logic_vector(31 downto 0);
	 IF_stall, IF_load_nop: out std_logic;
	 -- EX stage control signals
	 ALU_use_immediate: out std_logic;
	 ALU_op: out t_ALU_OP; --u
	 ALU_oprnd_1, ALU_oprnd_2, ALU_immediate: out std_logic_vector(31 downto 0);
	 -- MEM stage control signals
	 MEM_write, MEM_read: out std_logic
	 MEM_branch: out std_logic;
	 ID_alt_ta: out std_logic_vector(31 downto 0);
	 -- WB stage control signals
	 WB_reg_write: out std_logic;
	 WB_rd: out std_logic_vector(4 downto 0);
	 ID_load_nop, EX_load_nop, MEM_load_nop: out std_logic
	 );
end component;

-- Outputs of ID stage
-- To IF
signal r_IF_load_jmp_addr, IF_load_jmp_addr: std_logic_vector(1 downto 0);
signal IF_jmp_addr: std_logic_vector(31 downto 0);
signal IF_stall, IF_load_nop: std_logic;
-- To EX
signal r_ALU_use_immediate, ALU_use_immediate: std_logic;
signal r_ALU_op, ALU_op: t_ALU_OP;
signal r_ALU_oprnd_1, ALU_oprnd_1, r_ALU_oprnd_2, ALU_oprnd_2, r_ALU_immediate, ALU_immediate: std_logic_vector(31 downto 0);
-- To MEM
signal r_MEM_write, MEM_write, r_MEM_read, MEM_read: std_logic
signal r_MEM_branch, MEM_branch: std_logic;
signal r_ID_alt_ta, ID_alt_ta: std_logic_vector(31 downto 0);
-- To WB
signal r_WB_reg_write, WB_reg_write: std_logic;
signal r_WB_rd, WB_rd: std_logic_vector(4 downto 0);
signal r_ID_load_nop, ID_load_nop, r_EX_load_nop, EX_load_nop, r_MEM_load_nop, MEM_load_nop: std_logic;


begin

compIDStage: IDStage port map(clk, ID_inst, ID_pc, ID_next_pc, EX_rd_bw, EX_mem_rd_bw, MEM_branch_wb, ID_misprediction, ID_alt_ta_bw,
                                WB_reg_write_bw, WB_rd_bw, WB_data, IF_load_jmp_addr, IF_jmp_addr, IF_stall, IF_load_nop, r_ALU_use_immediate, 
                                r_ALU_op,r_ ALU_oprnd_1, r_ALU_oprnd_2, r_ALU_immediate, r_MEM_write, r_MEM_read, r_MEM_branch, r_ID_alt_ta, r_WB_reg_write, r_WB_rd, r_ID_load_nop,
                                r_EX_load_nop, r_MEM_load_nop);

comp_ID_EX_Reg: process(clk)
begin
  if rising_edge(clk) then
    (ALU_use_immediate, ALU_op, ALU_oprnd_1, ALU_oprnd_2, ALU_immediate, MEM_write, MEM_read, MEM_branch, ID_alt_ta, WB_reg_write, WB_rd, ID_load_nop,
    EX_load_nop, MEM_load_nop) <= (r_ALU_use_immediate, r_ALU_op,r_ ALU_oprnd_1, r_ALU_oprnd_2, r_ALU_immediate, r_MEM_write, r_MEM_read, r_MEM_branch, r_ID_alt_ta, r_WB_reg_write, r_WB_rd, r_ID_load_nop,
    r_EX_load_nop, r_MEM_load_nop);
  end if;
end process;

end structure;
