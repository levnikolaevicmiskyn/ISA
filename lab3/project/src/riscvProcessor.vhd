library ieee;
use ieee.std_logic_1164.all;
library work;
use work.globals.all;

entity riscvProcessor is
  port(clk                                        : in  std_logic;
       phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_in : out std_logic_vector(31 downto 0);
       phy_instr_mem_out, phy_data_mem_out: in std_logic_vector(31 downto 0);
       phy_data_mem_wr_en                                  : out std_logic);
end entity riscvProcessor;

architecture structure of riscvProcessor is
  component IDStage is
    port(clk: in std_logic;
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
    port (clk     : in  std_logic;
          IFSigs  : in  t_IFSigs;
          IDSigs  : out t_IDSigs;
          address : out std_logic_vector(31 downto 0);
          instr   : in  std_logic_vector(31 downto 0));
  end component;

component memoryInterface is
  port (
        inst_address, data_address : in  std_logic_vector(31 downto 0);
        rd, wr                     : in  std_logic;
        data_in                    : in  std_logic_vector(31 downto 0);
        data_out, instr_out: out std_logic_vector(31 downto 0);
        phy_mem_data_in, phy_mem_data_addr, phy_mem_instr_addr: out std_logic_vector(31 downto 0);
        phy_mem_wr_en: out std_logic;
        phy_mem_data_out, phy_mem_instr_out: in std_logic_vector(31 downto 0));
end component;

  component MEMStage is
    port(                               -- From control unit
      MEMSigs          : in  t_MEMSigs;
      -- Results from EX stage
      EXData           : in  t_EXData;
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

  signal IDSigs_IF_out, IDSigs_ID_in                                                             : t_IDSigs;
  signal EXSigs_ID_out, EXSigs_EX_in                                                             : t_EXSigs;
  signal MEMSigs_ID_out, MEMSigs_EX_in, MEMSigs_EX_out, MEMSigs_MEM_in                           : t_MEMSigs;
  signal WBSigs_ID_out, WBSigs_EX_in, WBSigs_EX_out, WBSigs_MEM_in, WBSigs_MEM_out, WBSigs_WB_in : t_WBSigs;
  signal EXData_EX_out, EXData_MEM_in : t_EXData;
  signal WB_mem_data                                                                             : std_logic_vector(31 downto 0);
  signal IFSigs_ID_out                                                                           : t_IFSigs;
  signal ID_misprediction                                                                        : std_logic;
  signal ID_load_nop, EX_load_nop, MEM_load_nop                                                  : std_logic;

  signal instr_address, instruction, data_mem_address, data_mem_read_data, data_mem_write_data : std_logic_vector(31 downto 0);
  signal data_mem_write_en, data_mem_read_en                                                   : std_logic;
begin
  compIDStage : IDStage
    port map(clk, IDSigs_ID_in, WBSigs_EX_in.rd, MEMSigs_EX_in.mem_read, ID_misprediction, MEMSigs_MEM_in.alt_ta, WBSigs_WB_in.reg_write, WBSigs_WB_in.rd, WBSigs_WB_in.result, IFSigs_ID_out, EXSigs_ID_out, MEMSigs_ID_out, WBSigs_ID_out, ID_load_nop, EX_load_nop, MEM_load_nop
             );

  comp_ID_EX_Reg : process(clk)
  begin
    if rising_edge(clk) then
      if ID_load_nop = '1' then
        EXSigs_EX_in.op            <= ALU_op_nop;
        EXSigs_EX_in.use_pc        <= '0';
        EXSigs_EX_in.use_immediate <= '0';
        EXSigs_EX_in.oprnd_1       <= (others => '0');
        EXSigs_EX_in.oprnd_2       <= (others => '0');
        EXSigs_EX_in.immediate     <= EXSigs_ID_out.immediate;
        EXSigs_EX_in.next_pc       <= EXSigs_ID_out.next_pc;

        MEMSigs_EX_in.mem_write <= '0';
        MEMSigs_EX_in.branch    <= '0';
        MEMSigs_EX_in.mem_read  <= '0';
        MEMSigs_EX_in.alt_ta    <= MEMSigs_ID_out.alt_ta;

        WBSigs_EX_in.reg_write <= '0';
        WBSigs_EX_in.rd        <= (others => '0');
      else
        EXSigs_EX_in  <= EXSigs_ID_out;
        MEMSigs_EX_in <= MEMSigs_ID_out;
        WBSigs_EX_in  <= WBSigs_ID_out;
      end if;
    end if;
    end process;

      compIFStage : IFStage port map(clk, IFSigs_ID_out, IDSigs_IF_out, instr_address, instruction);

      comp_IF_ID_Reg : process(clk)
      begin
        if rising_edge(clk) then
          if IFSigs_ID_out.load_nop = '1' then
            -- Load a nop instead of the instruction just fetched
            IDSigs_ID_in.inst <= NOP_instr;
            IDSigs_ID_in.pc   <= IDSigs_IF_out.pc;
            --IDSigs_ID_in.pc   <= IDSigs_IF_out.next_pc;
          else
            IDSigs_ID_in <= IDSigs_IF_out;
          end if;

        end if;
      end process;


      comp_EX_MEM_Reg : process(clk)
      begin
        if rising_edge(clk) then
          EXData_MEM_in <= EXData_EX_out;
        end if;
      end process;

    compMemStage     : MEMStage port map(MEMSigs_MEM_in, EXData_MEM_in, ID_misprediction, data_mem_address, data_mem_read_en, data_mem_write_en, data_mem_read_data, data_mem_write_data, WB_mem_data);

    compMemInterface : memoryInterface port map(instr_address, data_mem_address, data_mem_read_en, data_mem_write_en, data_mem_write_data, data_mem_read_data, instruction, phy_data_mem_in, phy_data_mem_addr, phy_instr_mem_addr, phy_data_mem_wr_en, phy_data_mem_out, phy_instr_mem_out);
    end structure;

