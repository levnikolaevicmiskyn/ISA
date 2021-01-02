library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.globals.all;

entity IDStage is
  port(clk: in std_logic;-- From IF stage
       IDSigs           : in t_IDSigs;
       -- From EX stage
       EX_rd_bw         : in std_logic_vector(4 downto 0);
       EX_mem_read_bw   : in std_logic;
       -- From MEM IDStage
       ID_misprediction : in std_logic;
       ID_alt_ta_bw     : in std_logic_vector(31 downto 0);
       -- From WB stage
       WB_reg_write_bw  : in std_logic;
       WB_rd_bw         : in std_logic_vector(4 downto 0);
       WB_data          : in std_logic_vector(31 downto 0);
       -- IF stage control signals
       IFSigs                                 : out t_IFSigs;
       -- EX stage control signals
       EXSigs                                 : out t_EXSigs;
       -- MEM stage control signals
       MEMSigs                                : out t_MEMSigs;
       -- WB stage control signals
       WBSigs                                 : out t_WBSigs;
       ID_load_nop, EX_load_nop, MEM_load_nop : out std_logic
       );
end entity IDStage;

architecture RTL of IDStage is

  component instDecoder is
    port(
      -- From IF stage
      inst                              : in  std_logic_vector(31 downto 0);
      branch_prediction                 : in  std_logic;
      -- From EX stage
      EX_rd_bw                          : in  std_logic_vector(4 downto 0);
      EX_mem_read_bw                    : in  std_logic;
      -- IF control signals
      IF_stall                          : out std_logic;
      -- EX control signals
      op                                : out t_ALU_OP;
      alu_sel: out t_ALU_SEL;
      -- MEM control signals
      MEM_write, MEM_read, WB_reg_write : out std_logic;
      immediate                         : out std_logic_vector(31 downto 0);
      rs1, rs2, rd                      : out std_logic_vector(4 downto 0);
      jump, branch                      : out std_logic
      );
  end component;

  component regFile is
    port (clk, reg_write                         : in  std_logic;
          read_addr_1, read_addr_2, write_addr_1 : in  std_logic_vector(4 downto 0);
          write_data_1                           : in  std_logic_vector(31 downto 0);
          read_data_1, read_data_2               : out std_logic_vector(31 downto 0));
  end component;

  component BPU is
    port(pc               : in  std_logic_vector(31 downto 0);
         ID_misprediction : in  std_logic;
         prediction       : out std_logic);
  end component;

  component adder is
    generic (N : positive := 32);
    port (
      a    : in  std_logic_vector(N-1 downto 0);  -- First operand
      b    : in  std_logic_vector(N-1 downto 0);  -- Second operand
      sub  : in  std_logic;                       -- Subtract instead of adding
      s    : out std_logic_vector(N-1 downto 0);  -- Sum
      ovf  : out std_logic;                       -- Overflow
      cout : out std_logic                        -- Output carry
      );
  end component;


  signal read_addr_1, read_addr_2, write_addr_1 : std_logic_vector(4 downto 0);
  signal read_data_1, read_data_2, immediate    : std_logic_vector(31 downto 0);
  signal oprnd_1_is_pc, ALU_use_immediate                          : std_logic;
  signal jump_addr_adder_out                    : std_logic_vector(31 downto 0);
  signal jump, branch                           : std_logic;
  signal ALU_op : t_ALU_OP;
  signal ALU_sel: t_ALU_SEL;
  signal IF_stall: std_logic;
  signal branch_prediction : std_logic;
  signal MEM_write, MEM_read, WB_reg_write: std_logic;
  signal WB_rd: std_logic_vector(4 downto 0);

begin
  compInstDecoder : instDecoder port map(IDSigs.inst, branch_prediction, EX_rd_bw, EX_mem_read_bw, IF_stall, ALU_op, ALU_sel, MEM_write,
                                         MEM_read, WB_reg_write, immediate, read_addr_1, read_addr_2, WB_rd, jump, branch);

  compRegFile : regFile port map(clk, WB_reg_write_bw, read_addr_1, read_addr_2, WB_rd_bw, WB_data, read_data_1, read_data_2);

-- Assign ALU operands
  EXSigs.oprnd_1       <= read_data_1;
  EXSigs.oprnd_2       <= read_data_2;
  EXSigs.op <= ALU_op;
  EXSigs.immediate <= immediate;
  EXSigs.pc <= IDSigs.next_pc;
  EXSigs.rs1 <= read_addr_1;
  EXSigs.rs2 <=read_addr_2;
  EXSigs.oprnd_sel <= ALU_sel;

-- Branch prediction unit
  compBPU : BPU port map(IDSigs.pc, ID_misprediction, branch_prediction);

-- Adder to compute the jump or branch target address to be stored in PC
  compAdder :-- adder generic map(32)
    -- port map(IDSigs.pc, immediate, '0', jump_addr_adder_out, open, open);
    jump_addr_adder_out <= std_logic_vector(unsigned(IDSigs.pc) + unsigned(immediate));
  
  IFSigs.jmp_addr      <= jump_addr_adder_out when ID_misprediction = '0' else ID_alt_ta_bw;
  IFSigs.load_jmp_addr <= jump or ID_misprediction;
  -- Replace fetched instruction with nop in case of a jump, misprediction or hazard.
  IFSigs.load_nop      <= jump or ID_misprediction or IF_stall;
  IFSigs.stall <= IF_stall;

  MEMSigs.alt_ta    <= IDSigs.next_pc when jump = '1' else jump_addr_adder_out;
  MEMSigs.branch    <= branch;
  MEMSigs.branch_taken     <= jump;
  MEMSigs.mem_write <= MEM_write;
  MEMSigs.mem_read  <= MEM_read;
  MEMSigs.data_for_mem <= read_data_2; -- rs2 is the source for store operations

  WBSigs.reg_write <= WB_reg_write;
  WBSigs.rd <= WB_rd;
  WBSigs.mem_to_reg <= MEM_read;

-- Mispredictions
  EX_load_nop  <= ID_misprediction;
  ID_load_nop  <= ID_misprediction;
  MEM_load_nop <= ID_misprediction;
end RTL;
