library ieee;
use ieee.std_logic_1164.all;
library work;
use work.globals.all;

entity riscvProcessor is
  port(clk, rst_n                                             : in  std_logic;
       phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_in : out std_logic_vector(31 downto 0);
       phy_instr_mem_out, phy_data_mem_out                    : in  std_logic_vector(31 downto 0);
       phy_data_mem_wr_en                                     : out std_logic);
end entity riscvProcessor;

architecture structure of riscvProcessor is
  component IDStage is
    port(clk, rst_n              : in std_logic;
         -- From IF stage
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
  end component;

  component IFStage is
    port (clk, rst_n : in  std_logic;
          IFSigs_load_jmp_addr, IFSigs_stall: in std_logic;
		  IFSigs_jmp_addr: in std_logic_vector(31 downto 0);
          IDSigs     : out t_IDSigs;
          address    : out std_logic_vector(31 downto 0);
          instr      : in  std_logic_vector(31 downto 0));
  end component;

  component memoryInterface is
    port (
      inst_address, data_address                             : in  std_logic_vector(31 downto 0);
      rd, wr                                                 : in  std_logic;
      data_in                                                : in  std_logic_vector(31 downto 0);
      data_out, instr_out                                    : out std_logic_vector(31 downto 0);
      phy_mem_data_in, phy_mem_data_addr, phy_mem_instr_addr : out std_logic_vector(31 downto 0);
      phy_mem_wr_en                                          : out std_logic;
      phy_mem_data_out, phy_mem_instr_out                    : in  std_logic_vector(31 downto 0));
  end component;

  component MEMStage is
    port(                               -- From control unit
      branch, branch_taken, mem_read, mem_write: in std_logic;
	  data_for_mem: in std_logic_vector(31 downto 0);
      -- Results from EX stage
		Z: in std_logic;
		result: in std_logic_vector(31 downto 0);
      -- Wrong prediction flag
      ID_misprediction : out std_logic;
      -- Memory
      address          : out std_logic_vector(31 downto 0);
      rd, wr           : out std_logic;
      data_in          : in  std_logic_vector(31 downto 0);
      data_out         : out std_logic_vector(31 downto 0);
      -- Signals for WB stage
      WB_data          : out std_logic_vector(31 downto 0)
      );
  end component;

  component EXStage is
      port (
          ex_sigs: in t_EXSigs;    -- Stage control signals and numerical operands
          fwd_sigs: in t_FWDSigs;  -- Control signals and data from the FWD unit
          ex_data: out t_EXData    -- Results
      );
  end component EXStage;

  component fwdUnit is
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
  end component;

  signal IDSigs_IF_out, IDSigs_ID_in                                                             : t_IDSigs;
  signal EXSigs_ID_out, EXSigs_EX_in                                                             : t_EXSigs;
  signal FWDSigs                                                                                 : t_FWDSigs;
  signal MEMSigs_ID_out, MEMSigs_EX_in, MEMSigs_EX_out, MEMSigs_MEM_in                           : t_MEMSigs;
  signal WBSigs_ID_out, WBSigs_EX_in, WBSigs_EX_out, WBSigs_MEM_in, WBSigs_MEM_out, WBSigs_WB_in : t_WBSigs;
  signal EXData_EX_out, EXData_MEM_in                                                            : t_EXData;
  signal IFSigs_ID_out                                                                           : t_IFSigs;
  signal ID_misprediction                                                                        : std_logic;
  signal ID_load_nop, EX_load_nop, MEM_load_nop                                                  : std_logic;
  signal WB_data_from_mem, WB_data_from_ex, WB_result_bw, WB_mem_data                            : std_logic_vector(31 downto 0);

  signal instr_address, instruction, data_mem_address, data_mem_read_data, data_mem_write_data : std_logic_vector(31 downto 0);
  signal data_mem_write_en, data_mem_read_en                                                   : std_logic;
begin
  compIDStage : IDStage
    port map(clk,rst_n, IDSigs_ID_in, WBSigs_EX_in.rd, MEMSigs_EX_in.mem_read, ID_misprediction, MEMSigs_MEM_in.alt_ta, WBSigs_WB_in.reg_write, WBSigs_WB_in.rd, WB_result_bw, IFSigs_ID_out, EXSigs_ID_out, MEMSigs_ID_out, WBSigs_ID_out, ID_load_nop, EX_load_nop, MEM_load_nop
             );

  comp_ID_EX_Reg : process(clk)
  begin
    if rst_n = '0' then
      MEMSigs_EX_in.mem_write <= '0';
      MEMSigs_EX_in.branch    <= '0';
      MEMSigs_EX_in.mem_read  <= '0';

      WBSigs_EX_in.reg_write <= '0';
      WBSigs_EX_in.rd        <= (others => '0');
    elsif rising_edge(clk) then
      if ID_load_nop = '1' then
        MEMSigs_EX_in.mem_write <= '0';
        MEMSigs_EX_in.branch    <= '0';
        MEMSigs_EX_in.mem_read  <= '0';

        WBSigs_EX_in.reg_write <= '0';
      else
        EXSigs_EX_in  <= EXSigs_ID_out;
        MEMSigs_EX_in <= MEMSigs_ID_out;
        WBSigs_EX_in  <= WBSigs_ID_out;
      end if;
    end if;
  end process;

  compIFStage : IFStage port map(clk, rst_n, IFSigs_ID_out.load_jmp_addr, IFSigs_ID_out.stall, IFSigs_ID_out.jmp_addr, IDSigs_IF_out, instr_address, instruction);

  comp_IF_ID_Reg : process(clk)
  begin
    if rst_n = '0' then
      IDSigs_ID_in.inst <= NOP_instr;
      IDSigs_ID_in.pc   <= IDSigs_IF_out.pc;
    elsif rising_edge(clk) then
      if IFSigs_ID_out.load_nop = '1' then
        -- Load a nop instead of the instruction just fetched
        IDSigs_ID_in.inst <= NOP_instr;
        IDSigs_ID_in.pc   <= IDSigs_IF_out.pc;
      elsif IFSigs_ID_out.stall = '0' then
        IDSigs_ID_in <= IDSigs_IF_out;
      end if;

    end if;
  end process;


  comp_EX_MEM_Reg : process(clk)
  begin
    if rst_n = '0' then
      MEMSigs_MEM_in.mem_write    <= '0';
      MEMSigs_MEM_in.mem_read     <= '0';
      MEMSigs_MEM_in.branch       <= '0';
      EXData_MEM_in.result        <= (others => '0');
      MEMSigs_MEM_in.data_for_mem <= (others => '0');

      WBSigs_MEM_in.reg_write <= '0';
    elsif rising_edge(clk) then
      if EX_load_nop = '0' then
        EXData_MEM_in  <= EXData_EX_out;
        MEMSigs_MEM_in <= MEMSigs_EX_out;
        WBSigs_MEM_in  <= WBSigs_EX_out;
      else
        MEMSigs_MEM_in.mem_write <= '0';
        MEMSigs_MEM_in.mem_read  <= '0';
        MEMSigs_MEM_in.branch    <= '0';

        WBSigs_MEM_in.reg_write <= '0';
      end if;
    end if;
  end process;

  compMemStage : MEMStage port map(MEMSigs_MEM_in.branch, MEMSigs_MEM_in.branch_taken, MEMSigs_MEM_in.mem_read, MEMSigs_MEM_in.mem_write, MEMSigs_MEM_in.data_for_mem, 
  EXData_MEM_in.Z, EXData_MEM_in.result, ID_misprediction, data_mem_address, data_mem_read_en, data_mem_write_en, data_mem_read_data, data_mem_write_data, WB_mem_data);
  WBSigs_MEM_out <= WBSigs_MEM_in;
  
  FWDSigs.MEM_data <= EXData_MEM_in.result;
  FWDSigs.WB_data <= WB_result_bw;
  
  compEXStage  : EXStage
    port map(EXSigs_EX_in, FWDSigs, EXData_EX_out);

  MEMSigs_EX_out.data_for_mem <= EXSigs_EX_in.oprnd_2 when FWDSigs.sel_forward2 = "00" else
                                 FWDSigs.MEM_data when FWDSigs.sel_forward2= "10" else
                                 FWDSigs.WB_data;

  MEMSigs_EX_out.branch <= MEMSigs_EX_in.branch;
  MEMSigs_EX_out.branch_taken <= MEMSigs_EX_in.branch_taken;
  MEMSigs_EX_out.mem_write <= MEMSigs_EX_in.mem_write;
  MEMSigs_EX_out.alt_ta <= MEMSigs_EX_in.alt_ta;
  MEMSigs_EX_out.mem_read <= MEMSigs_EX_in.mem_read;
  
  WBSigs_EX_out  <= WBSigs_EX_in;
  
  compFWDUnit: fwdUnit
    port map(EXSigs_EX_in.rs1, EXSigs_EX_in.rs2, WBSigs_MEM_in.rd, WBSigs_WB_in.rd, WBSigs_MEM_in.reg_write, WBSigs_WB_in.reg_write, FWDSigs.sel_forward1, FWDSigs.sel_forward2);

  compMemInterface : memoryInterface
    port map(
      instr_address, data_mem_address,
      data_mem_read_en, data_mem_write_en,
      data_mem_write_data, data_mem_read_data,
      instruction,
      phy_data_mem_in, phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_wr_en, phy_data_mem_out, phy_instr_mem_out
    );


  comp_MEM_WB_Reg : process(clk)
  begin
    if rst_n = '0' then
      WBSigs_WB_in.reg_write <= '0';
    elsif rising_edge(clk) then
      if MEM_load_nop = '0' then
        WBSigs_WB_in     <= WBSigs_MEM_out;
        WB_data_from_mem <= WB_mem_data;
        WB_data_from_ex  <= EXData_MEM_in.result;
      else
        WBSigs_WB_in.reg_write <= '0';
      end if;
    end if;
  end process;

  compWBStage : WB_result_bw <= WB_data_from_mem when WBSigs_WB_in.mem_to_reg = '1' else WB_data_from_ex;

end structure;
