library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.globals.all;
use work.HDU_pkg.all;

entity instDecoder is
  port( -- From IF stage
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
end entity instDecoder;

architecture struct of instDecoder is
  type t_INST is (t_INST_R, t_INST_SB, t_INST_U, t_INST_S, t_INST_I, t_INST_J);
  signal inst_type: t_INST;
  signal opcode: std_logic_vector(6 downto 0);
  signal funct7: std_logic_vector(31 downto 25);
  signal funct3: std_logic_vector(14 downto 12);
  signal rs1_i, rs2_i, rd_i: std_logic_vector(4 downto 0);

begin
  -- Fetch opcode
  opcode <= inst(6 downto 0);
  funct7 <= inst(31 downto 25);
  funct3 <= inst(14 downto 12);


  proc_inst_type: process(opcode)
  begin
    -- Default signal assignments
    inst_type <= t_INST_R;
    op <= alu_op_nop;
    alu_use_immediate <= '0';
    use_pc <= '0';
    WB_reg_write <= '0';
    MEM_read <= '0';
    MEM_write <= '0';
    branch <= '0';
    jump <= '0';
    IF_stall <= '0';

    case opcode is
      when "0110011" =>	-- Arithmetic operations
        inst_type <= t_INST_R;
        alu_use_immediate <= '0'; -- Use register operands
        if hazard(rs1_i, rs2_i, rd_i) = '0' then
          if funct7 = "0000000" and funct3 = "000" then
					-- ADD
            op <= alu_op_add;
            WB_reg_write <= '1';
          elsif funct7 = "0000000" and funct3 = "100" then
					-- XOR
            op <= alu_op_xor;
            WB_reg_write <= '1';
          elsif funct7 = "0000000" and funct3 = "010" then
					-- SLT
            op <= alu_op_lt;
            WB_reg_write <= '1';
          else
					-- Undefined behavior
            assert false report "Invalid instruction encountered. Behavior is undefined." severity warning;
          end if;
        else
          IF_stall <= '1';
        end if;

      when "0010011" =>
        inst_type <= t_INST_I;
        alu_use_immediate <= '1'; -- Use immediate operand
        if hazard(rs_1, rd) = '0' then
          if funct3 = "000" then
					-- ADDI
            op <= alu_op_add;
            WB_reg_write <= '1';
          elsif funct3 = "111" then
					-- ANDI
            op <= alu_op_and;
            WB_reg_write <= '1';
          elsif funct3 = "101" and funct7 = "0100000" then
					-- SRAI
            op <= alu_op_shift;
            WB_reg_write <= '1';
          else
					-- Undefined behavior
            assert false report "Invalid instruction encountered. Behavior is undefined." severity warning;
          end if;
        else
          IF_stall <= '1';
        end if;

      when "0010111" =>   -- AUIPC
        inst_type <= t_INST_U;
        use_pc <= '1'; 			-- Use pc as first operand
        alu_use_immediate <= '1';   -- Use immediate as second operand
        op <= alu_op_add;
        WB_reg_write <= '1';

      when "0110111" =>   -- LUI
        inst_type <= t_INST_U;
        alu_use_immediate <= '1';
        op <= alu_op_nop;
        WB_reg_write <= '1';

      when "1100011" =>   -- BEQ
        inst_type <= t_INST_SB;
        if hazard(rs_1, rs_2, rd) = '0' then
          op <= alu_op_lt; -- Resulting data will be discarded and zero flag will be used to decide on branch
          alu_use_immediate <= '0';
          use_pc <= '0';
          WB_reg_write <= '0';
          branch <= '1';
          -- Set jump in case this branch is predicted to be taken so that the pc will
          -- be loaded with the target address
          jump <= branch_prediction;
        else
          IF_stall <= '1';
        end if;

      when "0000011" =>   -- LW
        inst_type <= t_INST_I;
        op <= alu_op_nop;
        if hazard(rs_1, rd) = '0' then
          WB_reg_write <= '1';
          MEM_read <= '1';
        --mem_to_reg <= '1';
        else
          IF_stall <= '1';
        end if;
      when "1101111" =>   -- JAL
        inst_type <= t_INST_UJ;
        -- In this case sum 4 to the current pc before jumping
        use_pc <= '1';
        alu_op <= alu_op_inc_4;
        WB_reg_write <= '1';
        jump <= '1';

      when "0100011" =>   -- SW
        inst_type <= t_INST_S;
        op <= alu_op_nop;
        if hazard(rs_1, rs_2, rd) = '0' then
          WB_reg_write <= '1';
          mem_write <= '1';
        else
          IF_stall <= '1';
        end if;
      when others =>
        -- Undefined behavior
        assert false report "Invalid opcode encountered. Behavior is undefined." severity warning;
        -- Allow logic simplification
        alu_use_immediate <= '-';
        use_pc <= '-';
        WB_reg_write <= '-';
        MEM_read <= '-';
        MEM_write <= '-';
        jump <= '0';
        branch <= '0';
    end case;
  end process;

  -- Source and destination are always in the same position
  rs1_i <= inst(19 downto 15);
  rs2_i <= inst(24 downto 20);
  rd_i  <= inst(11 downto 7);
  rs1 <= rs1_i;
  rs2 <= rs2_i;
  rd <= rd_i;

  -- Immediate operand generation (see figure 2.4 page 18 in Vol.1)
  immediate(31) <= inst(31);
  immediate(0) <= inst(20) when inst_type = t_INST_I else
                  inst(7)  when inst_type = t_INST_S else '0';

  immediate(4 downto 1) <= inst(24 downto 21) when inst_type = t_INST_I else
                           inst(11 downto 8)  when inst_type = t_INST_S  else
                           inst(11 downto 8)  when inst_type = t_INST_SB else
                           inst(24 downto 21) when inst_type=t_INST_J   else (others => '0');

  immediate(10 downto 5) <= inst(30 downto 25) when inst_type =t_INST_I   else
                            inst(30 downto 25) when inst_type = t_INST_S  else
                            inst(30 downto 25) when inst_type = t_INST_SB else
                            inst(30 downto 25) when inst_type = t_INST_J  else (others => '0');

  immediate(11) <= inst(31) when (inst_type = t_INST_I or inst_type = t_INST_S) else
                   inst(7)  when inst_type = t_INST_SB else
                   '0'      when inst_type = t_INST_U else
                   inst(20); -- when t_INST_J;

  immediate(19 downto 12) <= (others => inst(31)) when (inst_type = t_INST_I or inst_type = t_INST_S or inst_type = t_INST_SB) else
                             inst(19 downto 12);

  immediate(30 downto 20) <= inst(30 downto 20) when inst_type = t_INST_U else (others => inst(31));

--immediate(63 downto 32) <= (others => inst(31)); -- Sign extension to 64 bits
end struct;
