library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDStage is
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
end entity IDStage;

architecture RTL of IDStage is

component instDecoder is
	  port(
			-- From IF stage
	    inst: in std_logic_vector(31 downto 0);
			branch_predicion: in std_logic;
	    -- From EX stage
	    EX_rd_bw: in std_logic_vector(4 downto 0);
	    EX_mem_read_bw: in std_logic;
	    -- IF control signals
	    IF_stall: out std_logic;
	    -- EX control signals
	    op: out t_ALU_OP;
	    alu_use_immediate, use_pc: out std_logic;
	    -- MEM control signals
	    MEM_write, MEM_read, WB_reg_write: out std_logic;
	    immediate: out std_logic_vector(31 downto 0);
	    rs1, rs2, rd: out std_logic_vector(4 downto 0);
	    jump, branch: out std_logic
	    );
	end component;

component regFile is
port (clk, reg_write: in std_logic;
	    read_addr_1, read_addr_2, write_addr_1: in std_logic_vector(4 downto 0);
	    write_data_1: in std_logic_vector(31 downto 0);
	   read_data_1, read_data_2: out std_logic_vector(31 downto 0) );
end component;

component BPU is
  port(pc: in std_logic_vector(31 downto 0);
       prediction: out std_logic);
end component;

signal read_addr_1, read_addr_2, write_addr_1: std_logic_vector(4 downto 0);
signal read_data_1, read_data_2, immediate: std_logic_vector(31 downto 0);
signal oprnd_1_is_pc;
signal jump_addr_adder_out: std_logic_vector(31 downto 0);
signal jump, branch: std_logic;

signal branch_prediction: std_logic;

begin
compInstDecoder: instDecoder port map(ID_inst, branch_prediction, EX_rd_bw, EX_mem_read_bw, IF_stall, ALU_op,
																			ALU_use_immediate, oprnd_1_is_pc, MEM_write, MEM_read, WB_reg_write, immediate,
																			read_addr_1, read_addr_2, WB_rd, jump, branch);

compRegFile: regFile port map(clk, WB_reg_write_bw, read_addr_1, read_addr_2, WB_rd_bw, WB_data, read_data_1, read_data_2);

-- Assign ALU operands
ALU_oprnd_1 <= read_data_1 when oprnd_1_is_pc = '0' else ID_pc;
ALU_oprnd_2 <= read_data_2;

-- Branch prediction unit
compBPU: BPU port map(ID_pc, ID_misprediction, branch_prediction);

-- Adder to compute the jump or branch target address to be stored in PC
compAdder: Adder port map(pc, immediate, jump_addr_adder_out);

IF_jmp_addr <= jump_addr_adder_out when ID_misprediction = '0' else ID_alt_ta_bw;
IF_load_jmp_addr <= jump or ID_misprediction;
IF_load_nop <= jump or ID_misprediction;

ID_alt_ta <= ID_next_pc when jump = '1' else jump_addr_adder_out;

-- Mispredictions
EX_load_nop <= ID_misprediction;
ID_load_nop <= ID_misprediction;
MEM_load_nop <= ID_misprediction;
end RTL;
