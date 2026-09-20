// Self-contained OISS: exact single-chain greedy and bounded dual-chain scheduler.
// Legal-input optimization: every opcode latency is 1..50 cycles.
// See Lab01_Exercise_2026_fall.pdf for the narrower per-opcode ranges.
module OISS (
    input  [95:0] Inst_seq_I,
    input  [47:0] Inst_latency_I,
    output reg [23:0] Inst_order_O,
    output [8:0]  Ex_cycle
);
reg [2:0] opcode [0:7];
reg [2:0] rs     [0:7];
reg [2:0] rt     [0:7];
reg [2:0] rd     [0:7];

reg [5:0] inst_latency [0:7];
reg [7:0] read_two_en;
reg [7:0] read_rd_en;
reg [7:0] write_rd_en;

integer i;

// ============================================================
// Instruction Decode
// ============================================================
always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
        opcode[i] = Inst_seq_I[i*12 + 9 +: 3];
        rs[i]     = Inst_seq_I[i*12 + 6 +: 3];
        rt[i]     = Inst_seq_I[i*12 + 3 +: 3];
        rd[i]     = Inst_seq_I[i*12     +: 3];

        case (opcode[i])
            3'b000: inst_latency[i] = Inst_latency_I[5:0];
            3'b001: inst_latency[i] = Inst_latency_I[11:6];
            3'b010: inst_latency[i] = Inst_latency_I[17:12];
            3'b011: inst_latency[i] = Inst_latency_I[23:18];
            3'b100: inst_latency[i] = Inst_latency_I[29:24];
            3'b101: inst_latency[i] = Inst_latency_I[35:30];
            3'b110: inst_latency[i] = Inst_latency_I[41:36];
            3'b111: inst_latency[i] = Inst_latency_I[47:42];
        endcase

        // Operand-access flags.  Register matches are evaluated directly in
        // the dependency matrix; this avoids one-hot decoders and 8-bit masks.
        read_two_en[i] = (~opcode[i][2]) | (opcode[i][1] & ~opcode[i][0]); // ALU, BRANCH: rs, rt
        read_rd_en[i]  = (opcode[i] == 3'b101);                             // STORE: rd
        write_rd_en[i] = (~opcode[i][2]) | ((~opcode[i][1]) & (~opcode[i][0])); // ALU, LOAD: rd

    end
end

// ============================================================
// Dependency Detection
// ============================================================
reg [7:0] dep_mask    [0:7];
reg [7:0] eq_rd_rd    [0:7];
reg [7:0] eq_rd_rs    [0:7];
reg [7:0] eq_rd_rt    [0:7];
reg [7:0] eq_rs_rd    [0:7];
reg [7:0] eq_rt_rd    [0:7];

integer dep_i;
integer dep_j;

always @(*) begin
    for (dep_i = 0; dep_i < 8; dep_i = dep_i + 1) begin
        dep_mask[dep_i] = 8'b0000_0000;
        eq_rd_rd[dep_i] = 8'b0000_0000;
        eq_rd_rs[dep_i] = 8'b0000_0000;
        eq_rd_rt[dep_i] = 8'b0000_0000;
        eq_rs_rd[dep_i] = 8'b0000_0000;
        eq_rt_rd[dep_i] = 8'b0000_0000;
    end

    // Dependency matrix generation (only original-order pairs i < j).
    // Keep each 3-bit equality as a shared signal because rd_i == rd_j is
    // needed by both WAW and STORE-related RAW/WAR checks.
    for (dep_i = 0; dep_i < 7; dep_i = dep_i + 1) begin
        for (dep_j = dep_i + 1; dep_j < 8; dep_j = dep_j + 1) begin
            eq_rd_rd[dep_i][dep_j] = (rd[dep_i] == rd[dep_j]);
            eq_rd_rs[dep_i][dep_j] = (rd[dep_i] == rs[dep_j]);
            eq_rd_rt[dep_i][dep_j] = (rd[dep_i] == rt[dep_j]);
            eq_rs_rd[dep_i][dep_j] = (rs[dep_i] == rd[dep_j]);
            eq_rt_rd[dep_i][dep_j] = (rt[dep_i] == rd[dep_j]);

            dep_mask[dep_i][dep_j] =
                // write_i -> write_j / STORE_j
                (write_rd_en[dep_i] & (write_rd_en[dep_j] | read_rd_en[dep_j]) & eq_rd_rd[dep_i][dep_j]) |
                // write_i -> ALU/BRANCH_j
                (write_rd_en[dep_i] & read_two_en[dep_j] & (eq_rd_rs[dep_i][dep_j] | eq_rd_rt[dep_i][dep_j])) |
                // STORE_i -> write_j
                (write_rd_en[dep_j] & read_rd_en[dep_i] & eq_rd_rd[dep_i][dep_j]) |
                // ALU/BRANCH_i -> write_j
                (write_rd_en[dep_j] & read_two_en[dep_i] & (eq_rs_rd[dep_i][dep_j] | eq_rt_rd[dep_i][dep_j]));

        end
    end

end





// ============================================================
// Chain Extraction
// ============================================================
//////// ACTIVE INSTRUCTION ////////
wire [7:0] active;

assign active[0] = |dep_mask[0][7:1];
assign active[1] = dep_mask[0][1] | (|dep_mask[1][7:2]);
assign active[2] = dep_mask[0][2] | dep_mask[1][2] | (|dep_mask[2][7:3]);
assign active[3] = dep_mask[0][3] | dep_mask[1][3] | dep_mask[2][3] | (|dep_mask[3][7:4]);
assign active[4] = dep_mask[0][4] | dep_mask[1][4] | dep_mask[2][4] | dep_mask[3][4] | (|dep_mask[4][7:5]);
assign active[5] = dep_mask[0][5] | dep_mask[1][5] | dep_mask[2][5] | dep_mask[3][5] | dep_mask[4][5] | (|dep_mask[5][7:6]);
assign active[6] = dep_mask[0][6] | dep_mask[1][6] | dep_mask[2][6] | dep_mask[3][6] | dep_mask[4][6] | dep_mask[5][6] | dep_mask[6][7];
assign active[7] = dep_mask[0][7] | dep_mask[1][7] | dep_mask[2][7] | dep_mask[3][7] | dep_mask[4][7] | dep_mask[5][7] | dep_mask[6][7];


//////// DEPENDENCY GROUPING ////////
wire [7:0] first_active;

assign first_active[0] = active[0];
assign first_active[1] = active[1] & ~active[0];
assign first_active[2] = active[2] & ~active[1] & ~active[0];
assign first_active[3] = active[3] & ~active[2] & ~active[1] & ~active[0];
assign first_active[4] = active[4] & ~active[3] & ~active[2] & ~active[1] & ~active[0];
assign first_active[5] = active[5] & ~active[4] & ~active[3] & ~active[2] & ~active[1] & ~active[0];
assign first_active[6] = active[6] & ~active[5] & ~active[4] & ~active[3] & ~active[2] & ~active[1] & ~active[0];
assign first_active[7] = active[7] & ~active[6] & ~active[5] & ~active[4] & ~active[3] & ~active[2] & ~active[1] & ~active[0];

wire [7:0] chain0_mask;

assign chain0_mask[0] = first_active[0];
assign chain0_mask[1] = first_active[1] | (chain0_mask[0] & dep_mask[0][1]);
assign chain0_mask[2] = first_active[2] | (chain0_mask[0] & dep_mask[0][2]) | (chain0_mask[1] & dep_mask[1][2]);
assign chain0_mask[3] = first_active[3] | (chain0_mask[0] & dep_mask[0][3]) | (chain0_mask[1] & dep_mask[1][3]) | (chain0_mask[2] & dep_mask[2][3]);
assign chain0_mask[4] = first_active[4] | (chain0_mask[0] & dep_mask[0][4]) | (chain0_mask[1] & dep_mask[1][4]) | (chain0_mask[2] & dep_mask[2][4]) | (chain0_mask[3] & dep_mask[3][4]);
assign chain0_mask[5] = first_active[5] | (chain0_mask[0] & dep_mask[0][5]) | (chain0_mask[1] & dep_mask[1][5]) | (chain0_mask[2] & dep_mask[2][5]) | (chain0_mask[3] & dep_mask[3][5]) | (chain0_mask[4] & dep_mask[4][5]);
assign chain0_mask[6] = first_active[6] | (chain0_mask[0] & dep_mask[0][6]) | (chain0_mask[1] & dep_mask[1][6]) | (chain0_mask[2] & dep_mask[2][6]) | (chain0_mask[3] & dep_mask[3][6]) | (chain0_mask[4] & dep_mask[4][6]) | (chain0_mask[5] & dep_mask[5][6]);
assign chain0_mask[7] = first_active[7] | (chain0_mask[0] & dep_mask[0][7]) | (chain0_mask[1] & dep_mask[1][7]) | (chain0_mask[2] & dep_mask[2][7]) | (chain0_mask[3] & dep_mask[3][7]) | (chain0_mask[4] & dep_mask[4][7]) | (chain0_mask[5] & dep_mask[5][7]) | (chain0_mask[6] & dep_mask[6][7]);

wire [7:0] chain1_mask = active & ~chain0_mask;
wire [7:0] indep_mask = ~active;


//////// CHAIN COMPACTION ////////
wire [2:0] chain0_inst [0:7];
wire [2:0] chain1_inst [0:7];
wire [3:0] c0_rank [0:8];
wire [3:0] c1_rank [0:8];
assign c0_rank[0] = 4'd0;
assign c1_rank[0] = 4'd0;
genvar compact_g;
generate for (compact_g=0; compact_g<8; compact_g=compact_g+1) begin: GEN_RANK
  assign c0_rank[compact_g+1] = c0_rank[compact_g] + {3'd0,chain0_mask[compact_g]};
  assign c1_rank[compact_g+1] = c1_rank[compact_g] + {3'd0,chain1_mask[compact_g]};
end endgenerate
wire [3:0] chain0_len = c0_rank[8];
wire [3:0] chain1_len = c1_rank[8];
assign chain0_inst[0] = ({3{chain0_mask[1] && (c0_rank[1] == 4'd0)}} & 3'd1) |
    ({3{chain0_mask[2] && (c0_rank[2] == 4'd0)}} & 3'd2) |
    ({3{chain0_mask[3] && (c0_rank[3] == 4'd0)}} & 3'd3) |
    ({3{chain0_mask[4] && (c0_rank[4] == 4'd0)}} & 3'd4) |
    ({3{chain0_mask[5] && (c0_rank[5] == 4'd0)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd0)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd0)}} & 3'd7);
assign chain0_inst[1] = ({3{chain0_mask[1] && (c0_rank[1] == 4'd1)}} & 3'd1) |
    ({3{chain0_mask[2] && (c0_rank[2] == 4'd1)}} & 3'd2) |
    ({3{chain0_mask[3] && (c0_rank[3] == 4'd1)}} & 3'd3) |
    ({3{chain0_mask[4] && (c0_rank[4] == 4'd1)}} & 3'd4) |
    ({3{chain0_mask[5] && (c0_rank[5] == 4'd1)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd1)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd1)}} & 3'd7);
assign chain0_inst[2] = ({3{chain0_mask[2] && (c0_rank[2] == 4'd2)}} & 3'd2) |
    ({3{chain0_mask[3] && (c0_rank[3] == 4'd2)}} & 3'd3) |
    ({3{chain0_mask[4] && (c0_rank[4] == 4'd2)}} & 3'd4) |
    ({3{chain0_mask[5] && (c0_rank[5] == 4'd2)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd2)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd2)}} & 3'd7);
assign chain0_inst[3] = ({3{chain0_mask[3] && (c0_rank[3] == 4'd3)}} & 3'd3) |
    ({3{chain0_mask[4] && (c0_rank[4] == 4'd3)}} & 3'd4) |
    ({3{chain0_mask[5] && (c0_rank[5] == 4'd3)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd3)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd3)}} & 3'd7);
assign chain0_inst[4] = ({3{chain0_mask[4] && (c0_rank[4] == 4'd4)}} & 3'd4) |
    ({3{chain0_mask[5] && (c0_rank[5] == 4'd4)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd4)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd4)}} & 3'd7);
assign chain0_inst[5] = ({3{chain0_mask[5] && (c0_rank[5] == 4'd5)}} & 3'd5) |
    ({3{chain0_mask[6] && (c0_rank[6] == 4'd5)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd5)}} & 3'd7);
assign chain0_inst[6] = ({3{chain0_mask[6] && (c0_rank[6] == 4'd6)}} & 3'd6) |
    ({3{chain0_mask[7] && (c0_rank[7] == 4'd6)}} & 3'd7);
assign chain0_inst[7] = ({3{chain0_mask[7] && (c0_rank[7] == 4'd7)}} & 3'd7);
assign chain1_inst[0] = ({3{chain1_mask[1] && (c1_rank[1] == 4'd0)}} & 3'd1) |
    ({3{chain1_mask[2] && (c1_rank[2] == 4'd0)}} & 3'd2) |
    ({3{chain1_mask[3] && (c1_rank[3] == 4'd0)}} & 3'd3) |
    ({3{chain1_mask[4] && (c1_rank[4] == 4'd0)}} & 3'd4) |
    ({3{chain1_mask[5] && (c1_rank[5] == 4'd0)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd0)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd0)}} & 3'd7);
assign chain1_inst[1] = ({3{chain1_mask[1] && (c1_rank[1] == 4'd1)}} & 3'd1) |
    ({3{chain1_mask[2] && (c1_rank[2] == 4'd1)}} & 3'd2) |
    ({3{chain1_mask[3] && (c1_rank[3] == 4'd1)}} & 3'd3) |
    ({3{chain1_mask[4] && (c1_rank[4] == 4'd1)}} & 3'd4) |
    ({3{chain1_mask[5] && (c1_rank[5] == 4'd1)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd1)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd1)}} & 3'd7);
assign chain1_inst[2] = ({3{chain1_mask[2] && (c1_rank[2] == 4'd2)}} & 3'd2) |
    ({3{chain1_mask[3] && (c1_rank[3] == 4'd2)}} & 3'd3) |
    ({3{chain1_mask[4] && (c1_rank[4] == 4'd2)}} & 3'd4) |
    ({3{chain1_mask[5] && (c1_rank[5] == 4'd2)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd2)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd2)}} & 3'd7);
assign chain1_inst[3] = ({3{chain1_mask[3] && (c1_rank[3] == 4'd3)}} & 3'd3) |
    ({3{chain1_mask[4] && (c1_rank[4] == 4'd3)}} & 3'd4) |
    ({3{chain1_mask[5] && (c1_rank[5] == 4'd3)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd3)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd3)}} & 3'd7);
assign chain1_inst[4] = ({3{chain1_mask[4] && (c1_rank[4] == 4'd4)}} & 3'd4) |
    ({3{chain1_mask[5] && (c1_rank[5] == 4'd4)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd4)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd4)}} & 3'd7);
assign chain1_inst[5] = ({3{chain1_mask[5] && (c1_rank[5] == 4'd5)}} & 3'd5) |
    ({3{chain1_mask[6] && (c1_rank[6] == 4'd5)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd5)}} & 3'd7);
assign chain1_inst[6] = ({3{chain1_mask[6] && (c1_rank[6] == 4'd6)}} & 3'd6) |
    ({3{chain1_mask[7] && (c1_rank[7] == 4'd6)}} & 3'd7);
assign chain1_inst[7] = ({3{chain1_mask[7] && (c1_rank[7] == 4'd7)}} & 3'd7);

//////// INDEPENDENT SORTING ////////
function [8:0] ind_hi;
    input [8:0] x;
    input [8:0] y;
    begin
        ind_hi = (x[8:3] >= y[8:3]) ? x : y;
    end
endfunction

function [8:0] ind_lo;
    input [8:0] x;
    input [8:0] y;
    begin
        ind_lo = (x[8:3] >= y[8:3]) ? y : x;
    end
endfunction

wire [8:0] ind_s0_0 = indep_mask[0] ? {inst_latency[0], 3'd0} : 9'd0;
wire [8:0] ind_s0_1 = indep_mask[1] ? {inst_latency[1], 3'd1} : 9'd0;
wire [8:0] ind_s0_2 = indep_mask[2] ? {inst_latency[2], 3'd2} : 9'd0;
wire [8:0] ind_s0_3 = indep_mask[3] ? {inst_latency[3], 3'd3} : 9'd0;
wire [8:0] ind_s0_4 = indep_mask[4] ? {inst_latency[4], 3'd4} : 9'd0;
wire [8:0] ind_s0_5 = indep_mask[5] ? {inst_latency[5], 3'd5} : 9'd0;
wire [8:0] ind_s0_6 = indep_mask[6] ? {inst_latency[6], 3'd6} : 9'd0;
wire [8:0] ind_s0_7 = indep_mask[7] ? {inst_latency[7], 3'd7} : 9'd0;

//////// SORT STAGE 1 ////////
wire [8:0] ind_s1_0 = ind_hi(ind_s0_0, ind_s0_2);
wire [8:0] ind_s1_2 = ind_lo(ind_s0_0, ind_s0_2);
wire [8:0] ind_s1_1 = ind_hi(ind_s0_1, ind_s0_3);
wire [8:0] ind_s1_3 = ind_lo(ind_s0_1, ind_s0_3);
wire [8:0] ind_s1_4 = ind_hi(ind_s0_4, ind_s0_6);
wire [8:0] ind_s1_6 = ind_lo(ind_s0_4, ind_s0_6);
wire [8:0] ind_s1_5 = ind_hi(ind_s0_5, ind_s0_7);
wire [8:0] ind_s1_7 = ind_lo(ind_s0_5, ind_s0_7);

//////// SORT STAGE 2 ////////
wire [8:0] ind_s2_0 = ind_hi(ind_s1_0, ind_s1_4);
wire [8:0] ind_s2_4 = ind_lo(ind_s1_0, ind_s1_4);
wire [8:0] ind_s2_1 = ind_hi(ind_s1_1, ind_s1_5);
wire [8:0] ind_s2_5 = ind_lo(ind_s1_1, ind_s1_5);
wire [8:0] ind_s2_2 = ind_hi(ind_s1_2, ind_s1_6);
wire [8:0] ind_s2_6 = ind_lo(ind_s1_2, ind_s1_6);
wire [8:0] ind_s2_3 = ind_hi(ind_s1_3, ind_s1_7);
wire [8:0] ind_s2_7 = ind_lo(ind_s1_3, ind_s1_7);

//////// SORT STAGE 3 ////////
wire [8:0] ind_s3_0 = ind_hi(ind_s2_0, ind_s2_1);
wire [8:0] ind_s3_1 = ind_lo(ind_s2_0, ind_s2_1);
wire [8:0] ind_s3_2 = ind_hi(ind_s2_2, ind_s2_3);
wire [8:0] ind_s3_3 = ind_lo(ind_s2_2, ind_s2_3);
wire [8:0] ind_s3_4 = ind_hi(ind_s2_4, ind_s2_5);
wire [8:0] ind_s3_5 = ind_lo(ind_s2_4, ind_s2_5);
wire [8:0] ind_s3_6 = ind_hi(ind_s2_6, ind_s2_7);
wire [8:0] ind_s3_7 = ind_lo(ind_s2_6, ind_s2_7);

//////// SORT STAGE 4 ////////
wire [8:0] ind_s4_0 = ind_s3_0;
wire [8:0] ind_s4_1 = ind_s3_1;
wire [8:0] ind_s4_2 = ind_hi(ind_s3_2, ind_s3_4);
wire [8:0] ind_s4_4 = ind_lo(ind_s3_2, ind_s3_4);
wire [8:0] ind_s4_3 = ind_hi(ind_s3_3, ind_s3_5);
wire [8:0] ind_s4_5 = ind_lo(ind_s3_3, ind_s3_5);
wire [8:0] ind_s4_6 = ind_s3_6;
wire [8:0] ind_s4_7 = ind_s3_7;

//////// SORT STAGE 5 ////////
wire [8:0] ind_s5_0 = ind_s4_0;
wire [8:0] ind_s5_1 = ind_hi(ind_s4_1, ind_s4_4);
wire [8:0] ind_s5_4 = ind_lo(ind_s4_1, ind_s4_4);
wire [8:0] ind_s5_2 = ind_s4_2;
wire [8:0] ind_s5_3 = ind_hi(ind_s4_3, ind_s4_6);
wire [8:0] ind_s5_6 = ind_lo(ind_s4_3, ind_s4_6);
wire [8:0] ind_s5_5 = ind_s4_5;
wire [8:0] ind_s5_7 = ind_s4_7;

//////// SORT STAGE 6 ////////
wire [8:0] ind_s6_0 = ind_s5_0;
wire [8:0] ind_s6_1 = ind_hi(ind_s5_1, ind_s5_2);
wire [8:0] ind_s6_2 = ind_lo(ind_s5_1, ind_s5_2);
wire [8:0] ind_s6_3 = ind_hi(ind_s5_3, ind_s5_4);
wire [8:0] ind_s6_4 = ind_lo(ind_s5_3, ind_s5_4);
wire [8:0] ind_s6_5 = ind_hi(ind_s5_5, ind_s5_6);
wire [8:0] ind_s6_6 = ind_lo(ind_s5_5, ind_s5_6);
wire [8:0] ind_s6_7 = ind_s5_7;

wire [2:0] indep_inst [0:7];

assign indep_inst[0] = ind_s6_0[2:0];
assign indep_inst[1] = ind_s6_1[2:0];
assign indep_inst[2] = ind_s6_2[2:0];
assign indep_inst[3] = ind_s6_3[2:0];
assign indep_inst[4] = ind_s6_4[2:0];
assign indep_inst[5] = ind_s6_5[2:0];
assign indep_inst[6] = ind_s6_6[2:0];
assign indep_inst[7] = ind_s6_7[2:0];

wire [3:0] indep_len = 4'd8 - chain0_len - chain1_len;


//////// A/B GROUPING ////////

localparam SRC_EMPTY  = 2'd0;
localparam SRC_CHAIN0 = 2'd1;
localparam SRC_CHAIN1 = 2'd2;
localparam SRC_INDEP  = 2'd3;

reg [1:0] A_src;
reg [1:0] B_src;

reg [2:0] A_inst [0:7];
reg [2:0] B_inst [0:7];

reg A_dependent;
reg B_dependent;
reg [2:0] B_len;

integer ab_i;

always @(*) begin
    A_src = SRC_EMPTY;
    B_src = SRC_EMPTY;
    A_dependent = 1'b0;
    B_dependent = 1'b0;
    B_len = 3'd0;

    if (chain0_len == 4'd0) begin
        A_src = SRC_INDEP;
    end else if (chain1_len != 4'd0) begin
        A_dependent = 1'b1;
        B_dependent = 1'b1;

        if (chain0_len >= chain1_len) begin
            A_src = SRC_CHAIN0;
            B_src = SRC_CHAIN1;
            B_len = chain1_len[2:0];
        end else begin
            A_src = SRC_CHAIN1;
            B_src = SRC_CHAIN0;
            B_len = chain0_len[2:0];
        end
    end else if (indep_len != 4'd0) begin
        if (chain0_len >= indep_len) begin
            A_src = SRC_CHAIN0;
            B_src = SRC_INDEP;
            A_dependent = 1'b1;
            B_dependent = 1'b0;
            B_len = indep_len[2:0];
        end else begin
            A_src = SRC_INDEP;
            B_src = SRC_CHAIN0;
            A_dependent = 1'b0;
            B_dependent = 1'b1;
            B_len = chain0_len[2:0];
        end
    end else begin
        A_src = SRC_CHAIN0;
        A_dependent = 1'b1;
    end

    for (ab_i = 0; ab_i < 8; ab_i = ab_i + 1) begin
        case (A_src)
            SRC_CHAIN0: A_inst[ab_i] = chain0_inst[ab_i];
            SRC_CHAIN1: A_inst[ab_i] = chain1_inst[ab_i];
            SRC_INDEP:  A_inst[ab_i] = indep_inst[ab_i];
            default:    A_inst[ab_i] = 3'd0;
        endcase

        case (B_src)
            SRC_CHAIN0: B_inst[ab_i] = chain0_inst[ab_i];
            SRC_CHAIN1: B_inst[ab_i] = chain1_inst[ab_i];
            SRC_INDEP:  B_inst[ab_i] = indep_inst[ab_i];
            default:    B_inst[ab_i] = 3'd0;
        endcase
    end
end


// Pack chain latencies directly in reverse original order.
// Ranks count selected instructions with larger original indices.
wire [5:0] chain0_rev_lat [0:7];
wire [1:0] c0_rev_count_1_3 = chain0_mask[1] + chain0_mask[2];
wire [1:0] c0_rev_count_3_5 = chain0_mask[3] + chain0_mask[4];
wire [2:0] c0_rev_count_1_5 = c0_rev_count_1_3 + c0_rev_count_3_5;
wire [1:0] c0_rev_count_5_7 = chain0_mask[5] + chain0_mask[6];
wire [1:0] c0_rev_count_5_8 = c0_rev_count_5_7 + chain0_mask[7];
wire [2:0] c0_rev_count_1_8 = c0_rev_count_1_5 + c0_rev_count_5_8;
wire [1:0] c0_rev_count_2_4 = chain0_mask[2] + chain0_mask[3];
wire [1:0] c0_rev_count_4_6 = chain0_mask[4] + chain0_mask[5];
wire [2:0] c0_rev_count_2_6 = c0_rev_count_2_4 + c0_rev_count_4_6;
wire [1:0] c0_rev_count_6_8 = chain0_mask[6] + chain0_mask[7];
wire [2:0] c0_rev_count_2_8 = c0_rev_count_2_6 + c0_rev_count_6_8;
wire [2:0] c0_rev_count_3_7 = c0_rev_count_3_5 + c0_rev_count_5_7;
wire [2:0] c0_rev_count_3_8 = c0_rev_count_3_7 + chain0_mask[7];
wire [2:0] c0_rev_count_4_8 = c0_rev_count_4_6 + c0_rev_count_6_8;
wire c0_rev0_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd0);
wire c0_rev0_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd0);
wire c0_rev0_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd0);
wire c0_rev0_hit3 = chain0_mask[3] && (c0_rev_count_4_8 == 3'd0);
wire c0_rev0_hit4 = chain0_mask[4] && (c0_rev_count_5_8 == 3'd0);
wire c0_rev0_hit5 = chain0_mask[5] && (c0_rev_count_6_8 == 3'd0);
wire c0_rev0_hit6 = chain0_mask[6] && (chain0_mask[7] == 3'd0);
wire c0_rev0_hit7 = chain0_mask[7] && (1'b0 == 3'd0);
assign chain0_rev_lat[0] = (((({6{c0_rev0_hit0}} & inst_latency[0]) | ({6{c0_rev0_hit1}} & inst_latency[1])) | (({6{c0_rev0_hit2}} & inst_latency[2]) | ({6{c0_rev0_hit3}} & inst_latency[3]))) | ((({6{c0_rev0_hit4}} & inst_latency[4]) | ({6{c0_rev0_hit5}} & inst_latency[5])) | (({6{c0_rev0_hit6}} & inst_latency[6]) | ({6{c0_rev0_hit7}} & inst_latency[7]))));
wire c0_rev1_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd1);
wire c0_rev1_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd1);
wire c0_rev1_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd1);
wire c0_rev1_hit3 = chain0_mask[3] && (c0_rev_count_4_8 == 3'd1);
wire c0_rev1_hit4 = chain0_mask[4] && (c0_rev_count_5_8 == 3'd1);
wire c0_rev1_hit5 = chain0_mask[5] && (c0_rev_count_6_8 == 3'd1);
wire c0_rev1_hit6 = chain0_mask[6] && (chain0_mask[7] == 3'd1);
assign chain0_rev_lat[1] = ((({6{c0_rev1_hit0}} & inst_latency[0]) | (({6{c0_rev1_hit1}} & inst_latency[1]) | ({6{c0_rev1_hit2}} & inst_latency[2]))) | ((({6{c0_rev1_hit3}} & inst_latency[3]) | ({6{c0_rev1_hit4}} & inst_latency[4])) | (({6{c0_rev1_hit5}} & inst_latency[5]) | ({6{c0_rev1_hit6}} & inst_latency[6]))));
wire c0_rev2_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd2);
wire c0_rev2_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd2);
wire c0_rev2_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd2);
wire c0_rev2_hit3 = chain0_mask[3] && (c0_rev_count_4_8 == 3'd2);
wire c0_rev2_hit4 = chain0_mask[4] && (c0_rev_count_5_8 == 3'd2);
wire c0_rev2_hit5 = chain0_mask[5] && (c0_rev_count_6_8 == 3'd2);
assign chain0_rev_lat[2] = ((({6{c0_rev2_hit0}} & inst_latency[0]) | (({6{c0_rev2_hit1}} & inst_latency[1]) | ({6{c0_rev2_hit2}} & inst_latency[2]))) | (({6{c0_rev2_hit3}} & inst_latency[3]) | (({6{c0_rev2_hit4}} & inst_latency[4]) | ({6{c0_rev2_hit5}} & inst_latency[5]))));
wire c0_rev3_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd3);
wire c0_rev3_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd3);
wire c0_rev3_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd3);
wire c0_rev3_hit3 = chain0_mask[3] && (c0_rev_count_4_8 == 3'd3);
wire c0_rev3_hit4 = chain0_mask[4] && (c0_rev_count_5_8 == 3'd3);
assign chain0_rev_lat[3] = ((({6{c0_rev3_hit0}} & inst_latency[0]) | ({6{c0_rev3_hit1}} & inst_latency[1])) | (({6{c0_rev3_hit2}} & inst_latency[2]) | (({6{c0_rev3_hit3}} & inst_latency[3]) | ({6{c0_rev3_hit4}} & inst_latency[4]))));
wire c0_rev4_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd4);
wire c0_rev4_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd4);
wire c0_rev4_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd4);
wire c0_rev4_hit3 = chain0_mask[3] && (c0_rev_count_4_8 == 3'd4);
assign chain0_rev_lat[4] = ((({6{c0_rev4_hit0}} & inst_latency[0]) | ({6{c0_rev4_hit1}} & inst_latency[1])) | (({6{c0_rev4_hit2}} & inst_latency[2]) | ({6{c0_rev4_hit3}} & inst_latency[3])));
wire c0_rev5_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd5);
wire c0_rev5_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd5);
wire c0_rev5_hit2 = chain0_mask[2] && (c0_rev_count_3_8 == 3'd5);
assign chain0_rev_lat[5] = (({6{c0_rev5_hit0}} & inst_latency[0]) | (({6{c0_rev5_hit1}} & inst_latency[1]) | ({6{c0_rev5_hit2}} & inst_latency[2])));
wire c0_rev6_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd6);
wire c0_rev6_hit1 = chain0_mask[1] && (c0_rev_count_2_8 == 3'd6);
assign chain0_rev_lat[6] = (({6{c0_rev6_hit0}} & inst_latency[0]) | ({6{c0_rev6_hit1}} & inst_latency[1]));
wire c0_rev7_hit0 = chain0_mask[0] && (c0_rev_count_1_8 == 3'd7);
assign chain0_rev_lat[7] = ({6{c0_rev7_hit0}} & inst_latency[0]);
wire [5:0] chain1_rev_lat [0:7];
wire [1:0] c1_rev_count_1_3 = chain1_mask[1] + chain1_mask[2];
wire [1:0] c1_rev_count_3_5 = chain1_mask[3] + chain1_mask[4];
wire [2:0] c1_rev_count_1_5 = c1_rev_count_1_3 + c1_rev_count_3_5;
wire [1:0] c1_rev_count_5_7 = chain1_mask[5] + chain1_mask[6];
wire [1:0] c1_rev_count_5_8 = c1_rev_count_5_7 + chain1_mask[7];
wire [2:0] c1_rev_count_1_8 = c1_rev_count_1_5 + c1_rev_count_5_8;
wire [1:0] c1_rev_count_2_4 = chain1_mask[2] + chain1_mask[3];
wire [1:0] c1_rev_count_4_6 = chain1_mask[4] + chain1_mask[5];
wire [2:0] c1_rev_count_2_6 = c1_rev_count_2_4 + c1_rev_count_4_6;
wire [1:0] c1_rev_count_6_8 = chain1_mask[6] + chain1_mask[7];
wire [2:0] c1_rev_count_2_8 = c1_rev_count_2_6 + c1_rev_count_6_8;
wire [2:0] c1_rev_count_3_7 = c1_rev_count_3_5 + c1_rev_count_5_7;
wire [2:0] c1_rev_count_3_8 = c1_rev_count_3_7 + chain1_mask[7];
wire [2:0] c1_rev_count_4_8 = c1_rev_count_4_6 + c1_rev_count_6_8;
wire c1_rev0_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd0);
wire c1_rev0_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd0);
wire c1_rev0_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd0);
wire c1_rev0_hit3 = chain1_mask[3] && (c1_rev_count_4_8 == 3'd0);
wire c1_rev0_hit4 = chain1_mask[4] && (c1_rev_count_5_8 == 3'd0);
wire c1_rev0_hit5 = chain1_mask[5] && (c1_rev_count_6_8 == 3'd0);
wire c1_rev0_hit6 = chain1_mask[6] && (chain1_mask[7] == 3'd0);
wire c1_rev0_hit7 = chain1_mask[7] && (1'b0 == 3'd0);
assign chain1_rev_lat[0] = (((({6{c1_rev0_hit0}} & inst_latency[0]) | ({6{c1_rev0_hit1}} & inst_latency[1])) | (({6{c1_rev0_hit2}} & inst_latency[2]) | ({6{c1_rev0_hit3}} & inst_latency[3]))) | ((({6{c1_rev0_hit4}} & inst_latency[4]) | ({6{c1_rev0_hit5}} & inst_latency[5])) | (({6{c1_rev0_hit6}} & inst_latency[6]) | ({6{c1_rev0_hit7}} & inst_latency[7]))));
wire c1_rev1_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd1);
wire c1_rev1_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd1);
wire c1_rev1_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd1);
wire c1_rev1_hit3 = chain1_mask[3] && (c1_rev_count_4_8 == 3'd1);
wire c1_rev1_hit4 = chain1_mask[4] && (c1_rev_count_5_8 == 3'd1);
wire c1_rev1_hit5 = chain1_mask[5] && (c1_rev_count_6_8 == 3'd1);
wire c1_rev1_hit6 = chain1_mask[6] && (chain1_mask[7] == 3'd1);
assign chain1_rev_lat[1] = ((({6{c1_rev1_hit0}} & inst_latency[0]) | (({6{c1_rev1_hit1}} & inst_latency[1]) | ({6{c1_rev1_hit2}} & inst_latency[2]))) | ((({6{c1_rev1_hit3}} & inst_latency[3]) | ({6{c1_rev1_hit4}} & inst_latency[4])) | (({6{c1_rev1_hit5}} & inst_latency[5]) | ({6{c1_rev1_hit6}} & inst_latency[6]))));
wire c1_rev2_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd2);
wire c1_rev2_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd2);
wire c1_rev2_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd2);
wire c1_rev2_hit3 = chain1_mask[3] && (c1_rev_count_4_8 == 3'd2);
wire c1_rev2_hit4 = chain1_mask[4] && (c1_rev_count_5_8 == 3'd2);
wire c1_rev2_hit5 = chain1_mask[5] && (c1_rev_count_6_8 == 3'd2);
assign chain1_rev_lat[2] = ((({6{c1_rev2_hit0}} & inst_latency[0]) | (({6{c1_rev2_hit1}} & inst_latency[1]) | ({6{c1_rev2_hit2}} & inst_latency[2]))) | (({6{c1_rev2_hit3}} & inst_latency[3]) | (({6{c1_rev2_hit4}} & inst_latency[4]) | ({6{c1_rev2_hit5}} & inst_latency[5]))));
wire c1_rev3_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd3);
wire c1_rev3_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd3);
wire c1_rev3_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd3);
wire c1_rev3_hit3 = chain1_mask[3] && (c1_rev_count_4_8 == 3'd3);
wire c1_rev3_hit4 = chain1_mask[4] && (c1_rev_count_5_8 == 3'd3);
assign chain1_rev_lat[3] = ((({6{c1_rev3_hit0}} & inst_latency[0]) | ({6{c1_rev3_hit1}} & inst_latency[1])) | (({6{c1_rev3_hit2}} & inst_latency[2]) | (({6{c1_rev3_hit3}} & inst_latency[3]) | ({6{c1_rev3_hit4}} & inst_latency[4]))));
wire c1_rev4_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd4);
wire c1_rev4_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd4);
wire c1_rev4_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd4);
wire c1_rev4_hit3 = chain1_mask[3] && (c1_rev_count_4_8 == 3'd4);
assign chain1_rev_lat[4] = ((({6{c1_rev4_hit0}} & inst_latency[0]) | ({6{c1_rev4_hit1}} & inst_latency[1])) | (({6{c1_rev4_hit2}} & inst_latency[2]) | ({6{c1_rev4_hit3}} & inst_latency[3])));
wire c1_rev5_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd5);
wire c1_rev5_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd5);
wire c1_rev5_hit2 = chain1_mask[2] && (c1_rev_count_3_8 == 3'd5);
assign chain1_rev_lat[5] = (({6{c1_rev5_hit0}} & inst_latency[0]) | (({6{c1_rev5_hit1}} & inst_latency[1]) | ({6{c1_rev5_hit2}} & inst_latency[2])));
wire c1_rev6_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd6);
wire c1_rev6_hit1 = chain1_mask[1] && (c1_rev_count_2_8 == 3'd6);
assign chain1_rev_lat[6] = (({6{c1_rev6_hit0}} & inst_latency[0]) | ({6{c1_rev6_hit1}} & inst_latency[1]));
wire c1_rev7_hit0 = chain1_mask[0] && (c1_rev_count_1_8 == 3'd7);
assign chain1_rev_lat[7] = ({6{c1_rev7_hit0}} & inst_latency[0]);
// Dedicated dual-chain inputs bypass independent sorting and index lookup.
wire dual_swap = (chain0_len < chain1_len);
wire [5:0] dual_A_rev_lat [0:7];
wire [5:0] dual_B_rev_lat [0:3];
assign dual_A_rev_lat[0] = dual_swap ? chain1_rev_lat[0] : chain0_rev_lat[0];
assign dual_B_rev_lat[0] = dual_swap ? chain0_rev_lat[0] : chain1_rev_lat[0];
assign dual_A_rev_lat[1] = dual_swap ? chain1_rev_lat[1] : chain0_rev_lat[1];
assign dual_B_rev_lat[1] = dual_swap ? chain0_rev_lat[1] : chain1_rev_lat[1];
assign dual_A_rev_lat[2] = dual_swap ? chain1_rev_lat[2] : chain0_rev_lat[2];
assign dual_B_rev_lat[2] = dual_swap ? chain0_rev_lat[2] : chain1_rev_lat[2];
assign dual_A_rev_lat[3] = dual_swap ? chain1_rev_lat[3] : chain0_rev_lat[3];
assign dual_B_rev_lat[3] = dual_swap ? chain0_rev_lat[3] : chain1_rev_lat[3];
assign dual_A_rev_lat[4] = dual_swap ? chain1_rev_lat[4] : chain0_rev_lat[4];
assign dual_A_rev_lat[5] = dual_swap ? chain1_rev_lat[5] : chain0_rev_lat[5];
assign dual_A_rev_lat[6] = dual_swap ? chain1_rev_lat[6] : chain0_rev_lat[6];
assign dual_A_rev_lat[7] = dual_swap ? chain1_rev_lat[7] : chain0_rev_lat[7];
// The scalar solver uses canonical C/I inputs without an A/B round trip.
// Sorting already carries each latency, so no index-based latency lookup is needed.
reg [5:0] ind_rev_lat [0:5];
integer ind_rev_i;
always @(*) begin
    for (ind_rev_i=0; ind_rev_i<6; ind_rev_i=ind_rev_i+1) ind_rev_lat[ind_rev_i] = 6'd0;
    case (indep_len)
        4'd1: begin
            ind_rev_lat[0] = ind_s6_0[8:3];
        end
        4'd2: begin
            ind_rev_lat[0] = ind_s6_1[8:3];
            ind_rev_lat[1] = ind_s6_0[8:3];
        end
        4'd3: begin
            ind_rev_lat[0] = ind_s6_2[8:3];
            ind_rev_lat[1] = ind_s6_1[8:3];
            ind_rev_lat[2] = ind_s6_0[8:3];
        end
        4'd4: begin
            ind_rev_lat[0] = ind_s6_3[8:3];
            ind_rev_lat[1] = ind_s6_2[8:3];
            ind_rev_lat[2] = ind_s6_1[8:3];
            ind_rev_lat[3] = ind_s6_0[8:3];
        end
        4'd5: begin
            ind_rev_lat[0] = ind_s6_4[8:3];
            ind_rev_lat[1] = ind_s6_3[8:3];
            ind_rev_lat[2] = ind_s6_2[8:3];
            ind_rev_lat[3] = ind_s6_1[8:3];
            ind_rev_lat[4] = ind_s6_0[8:3];
        end
        4'd6: begin
            ind_rev_lat[0] = ind_s6_5[8:3];
            ind_rev_lat[1] = ind_s6_4[8:3];
            ind_rev_lat[2] = ind_s6_3[8:3];
            ind_rev_lat[3] = ind_s6_2[8:3];
            ind_rev_lat[4] = ind_s6_1[8:3];
            ind_rev_lat[5] = ind_s6_0[8:3];
        end
        default: begin end
    endcase
end
// Timing solver input boundary.
// Unsigned compare via a balanced carry-out tree for a + ~b + 1.
// Generate/propagate uses AND/OR only; no sum bits or serial borrow chain.
function oiss_ge6;
    input [5:0] a, b;
    reg c_0_5_g, c_0_5_p;
    reg c_0_2_g, c_0_2_p;
    reg c_0_1_g, c_0_1_p;
    reg c_0_0_g, c_0_0_p;
    reg c_1_1_g, c_1_1_p;
    reg c_2_2_g, c_2_2_p;
    reg c_3_5_g, c_3_5_p;
    reg c_3_4_g, c_3_4_p;
    reg c_3_3_g, c_3_3_p;
    reg c_4_4_g, c_4_4_p;
    reg c_5_5_g, c_5_5_p;
    begin
        c_0_0_g = a[0] | ~b[0];
        c_0_0_p = a[0] | ~b[0];
        c_1_1_g = a[1] & ~b[1];
        c_1_1_p = a[1] | ~b[1];
        c_0_1_g = c_1_1_g | (c_1_1_p & c_0_0_g);
        c_0_1_p = c_1_1_p & c_0_0_p;
        c_2_2_g = a[2] & ~b[2];
        c_2_2_p = a[2] | ~b[2];
        c_0_2_g = c_2_2_g | (c_2_2_p & c_0_1_g);
        c_0_2_p = c_2_2_p & c_0_1_p;
        c_3_3_g = a[3] & ~b[3];
        c_3_3_p = a[3] | ~b[3];
        c_4_4_g = a[4] & ~b[4];
        c_4_4_p = a[4] | ~b[4];
        c_3_4_g = c_4_4_g | (c_4_4_p & c_3_3_g);
        c_3_4_p = c_4_4_p & c_3_3_p;
        c_5_5_g = a[5] & ~b[5];
        c_5_5_p = a[5] | ~b[5];
        c_3_5_g = c_5_5_g | (c_5_5_p & c_3_4_g);
        c_3_5_p = c_5_5_p & c_3_4_p;
        c_0_5_g = c_3_5_g | (c_3_5_p & c_0_2_g);
        c_0_5_p = c_3_5_p & c_0_2_p;
        oiss_ge6 = c_0_5_g;
    end
endfunction

function oiss_ge7;
    input [6:0] a, b;
    reg c_0_6_g, c_0_6_p;
    reg c_0_3_g, c_0_3_p;
    reg c_0_1_g, c_0_1_p;
    reg c_0_0_g, c_0_0_p;
    reg c_1_1_g, c_1_1_p;
    reg c_2_3_g, c_2_3_p;
    reg c_2_2_g, c_2_2_p;
    reg c_3_3_g, c_3_3_p;
    reg c_4_6_g, c_4_6_p;
    reg c_4_5_g, c_4_5_p;
    reg c_4_4_g, c_4_4_p;
    reg c_5_5_g, c_5_5_p;
    reg c_6_6_g, c_6_6_p;
    begin
        c_0_0_g = a[0] | ~b[0];
        c_0_0_p = a[0] | ~b[0];
        c_1_1_g = a[1] & ~b[1];
        c_1_1_p = a[1] | ~b[1];
        c_0_1_g = c_1_1_g | (c_1_1_p & c_0_0_g);
        c_0_1_p = c_1_1_p & c_0_0_p;
        c_2_2_g = a[2] & ~b[2];
        c_2_2_p = a[2] | ~b[2];
        c_3_3_g = a[3] & ~b[3];
        c_3_3_p = a[3] | ~b[3];
        c_2_3_g = c_3_3_g | (c_3_3_p & c_2_2_g);
        c_2_3_p = c_3_3_p & c_2_2_p;
        c_0_3_g = c_2_3_g | (c_2_3_p & c_0_1_g);
        c_0_3_p = c_2_3_p & c_0_1_p;
        c_4_4_g = a[4] & ~b[4];
        c_4_4_p = a[4] | ~b[4];
        c_5_5_g = a[5] & ~b[5];
        c_5_5_p = a[5] | ~b[5];
        c_4_5_g = c_5_5_g | (c_5_5_p & c_4_4_g);
        c_4_5_p = c_5_5_p & c_4_4_p;
        c_6_6_g = a[6] & ~b[6];
        c_6_6_p = a[6] | ~b[6];
        c_4_6_g = c_6_6_g | (c_6_6_p & c_4_5_g);
        c_4_6_p = c_6_6_p & c_4_5_p;
        c_0_6_g = c_4_6_g | (c_4_6_p & c_0_3_g);
        c_0_6_p = c_4_6_p & c_0_3_p;
        oiss_ge7 = c_0_6_g;
    end
endfunction

function oiss_ge8;
    input [7:0] a, b;
    reg c_0_7_g, c_0_7_p;
    reg c_0_3_g, c_0_3_p;
    reg c_0_1_g, c_0_1_p;
    reg c_0_0_g, c_0_0_p;
    reg c_1_1_g, c_1_1_p;
    reg c_2_3_g, c_2_3_p;
    reg c_2_2_g, c_2_2_p;
    reg c_3_3_g, c_3_3_p;
    reg c_4_7_g, c_4_7_p;
    reg c_4_5_g, c_4_5_p;
    reg c_4_4_g, c_4_4_p;
    reg c_5_5_g, c_5_5_p;
    reg c_6_7_g, c_6_7_p;
    reg c_6_6_g, c_6_6_p;
    reg c_7_7_g, c_7_7_p;
    begin
        c_0_0_g = a[0] | ~b[0];
        c_0_0_p = a[0] | ~b[0];
        c_1_1_g = a[1] & ~b[1];
        c_1_1_p = a[1] | ~b[1];
        c_0_1_g = c_1_1_g | (c_1_1_p & c_0_0_g);
        c_0_1_p = c_1_1_p & c_0_0_p;
        c_2_2_g = a[2] & ~b[2];
        c_2_2_p = a[2] | ~b[2];
        c_3_3_g = a[3] & ~b[3];
        c_3_3_p = a[3] | ~b[3];
        c_2_3_g = c_3_3_g | (c_3_3_p & c_2_2_g);
        c_2_3_p = c_3_3_p & c_2_2_p;
        c_0_3_g = c_2_3_g | (c_2_3_p & c_0_1_g);
        c_0_3_p = c_2_3_p & c_0_1_p;
        c_4_4_g = a[4] & ~b[4];
        c_4_4_p = a[4] | ~b[4];
        c_5_5_g = a[5] & ~b[5];
        c_5_5_p = a[5] | ~b[5];
        c_4_5_g = c_5_5_g | (c_5_5_p & c_4_4_g);
        c_4_5_p = c_5_5_p & c_4_4_p;
        c_6_6_g = a[6] & ~b[6];
        c_6_6_p = a[6] | ~b[6];
        c_7_7_g = a[7] & ~b[7];
        c_7_7_p = a[7] | ~b[7];
        c_6_7_g = c_7_7_g | (c_7_7_p & c_6_6_g);
        c_6_7_p = c_7_7_p & c_6_6_p;
        c_4_7_g = c_6_7_g | (c_6_7_p & c_4_5_g);
        c_4_7_p = c_6_7_p & c_4_5_p;
        c_0_7_g = c_4_7_g | (c_4_7_p & c_0_3_g);
        c_0_7_p = c_4_7_p & c_0_3_p;
        oiss_ge8 = c_0_7_g;
    end
endfunction

function oiss_ge9;
    input [8:0] a, b;
    reg c_0_8_g, c_0_8_p;
    reg c_0_4_g, c_0_4_p;
    reg c_0_2_g, c_0_2_p;
    reg c_0_1_g, c_0_1_p;
    reg c_0_0_g, c_0_0_p;
    reg c_1_1_g, c_1_1_p;
    reg c_2_2_g, c_2_2_p;
    reg c_3_4_g, c_3_4_p;
    reg c_3_3_g, c_3_3_p;
    reg c_4_4_g, c_4_4_p;
    reg c_5_8_g, c_5_8_p;
    reg c_5_6_g, c_5_6_p;
    reg c_5_5_g, c_5_5_p;
    reg c_6_6_g, c_6_6_p;
    reg c_7_8_g, c_7_8_p;
    reg c_7_7_g, c_7_7_p;
    reg c_8_8_g, c_8_8_p;
    begin
        c_0_0_g = a[0] | ~b[0];
        c_0_0_p = a[0] | ~b[0];
        c_1_1_g = a[1] & ~b[1];
        c_1_1_p = a[1] | ~b[1];
        c_0_1_g = c_1_1_g | (c_1_1_p & c_0_0_g);
        c_0_1_p = c_1_1_p & c_0_0_p;
        c_2_2_g = a[2] & ~b[2];
        c_2_2_p = a[2] | ~b[2];
        c_0_2_g = c_2_2_g | (c_2_2_p & c_0_1_g);
        c_0_2_p = c_2_2_p & c_0_1_p;
        c_3_3_g = a[3] & ~b[3];
        c_3_3_p = a[3] | ~b[3];
        c_4_4_g = a[4] & ~b[4];
        c_4_4_p = a[4] | ~b[4];
        c_3_4_g = c_4_4_g | (c_4_4_p & c_3_3_g);
        c_3_4_p = c_4_4_p & c_3_3_p;
        c_0_4_g = c_3_4_g | (c_3_4_p & c_0_2_g);
        c_0_4_p = c_3_4_p & c_0_2_p;
        c_5_5_g = a[5] & ~b[5];
        c_5_5_p = a[5] | ~b[5];
        c_6_6_g = a[6] & ~b[6];
        c_6_6_p = a[6] | ~b[6];
        c_5_6_g = c_6_6_g | (c_6_6_p & c_5_5_g);
        c_5_6_p = c_6_6_p & c_5_5_p;
        c_7_7_g = a[7] & ~b[7];
        c_7_7_p = a[7] | ~b[7];
        c_8_8_g = a[8] & ~b[8];
        c_8_8_p = a[8] | ~b[8];
        c_7_8_g = c_8_8_g | (c_8_8_p & c_7_7_g);
        c_7_8_p = c_8_8_p & c_7_7_p;
        c_5_8_g = c_7_8_g | (c_7_8_p & c_5_6_g);
        c_5_8_p = c_7_8_p & c_5_6_p;
        c_0_8_g = c_5_8_g | (c_5_8_p & c_0_4_g);
        c_0_8_p = c_5_8_p & c_0_4_p;
        oiss_ge9 = c_0_8_g;
    end
endfunction

// Exact dual-chain scheduler: fixed suffix tree, bounded merge, small prefix trees.
// A and B are dependency chains. A is the longer group. All latencies are 1..50.

// Fixed suffix depth 1.

// Fixed suffix depth 2.
wire [6:0] d4_AA_sum = dual_A_rev_lat[0] + dual_A_rev_lat[1];
wire [5:0] d4_AB_dep = 1'b0 + dual_A_rev_lat[0];
wire [5:0] d4_AB_issue = dual_B_rev_lat[0] + 6'd1;
wire [5:0] d4_AB_head = (oiss_ge6(d4_AB_dep, d4_AB_issue)) ? d4_AB_dep : d4_AB_issue;
wire [5:0] d4_BA_dep = 1'b0 + dual_B_rev_lat[0];
wire [5:0] d4_BA_issue = dual_A_rev_lat[0] + 6'd1;
wire [5:0] d4_BA_head = (oiss_ge6(d4_BA_dep, d4_BA_issue)) ? d4_BA_dep : d4_BA_issue;
wire [6:0] d4_BB_sum = dual_B_rev_lat[0] + dual_B_rev_lat[1];

// Fixed suffix depth 3.
wire [7:0] d4_AAA_sum = d4_AA_sum + dual_A_rev_lat[2];
wire [6:0] d4_AAB_sum = d4_AB_head + dual_A_rev_lat[1];
wire [6:0] d4_ABA_dep = dual_A_rev_lat[0] + dual_A_rev_lat[1];
wire [5:0] d4_ABA_issue = d4_BA_head + 6'd1;
wire [6:0] d4_ABA_head = (oiss_ge7(d4_ABA_dep, d4_ABA_issue)) ? d4_ABA_dep : d4_ABA_issue;
wire [5:0] d4_ABB_dep = 1'b0 + dual_A_rev_lat[0];
wire [6:0] d4_ABB_issue = d4_BB_sum + 7'd1;
wire [6:0] d4_ABB_head = (oiss_ge7(d4_ABB_dep, d4_ABB_issue)) ? d4_ABB_dep : d4_ABB_issue;
wire [5:0] d4_BAA_dep = 1'b0 + dual_B_rev_lat[0];
wire [6:0] d4_BAA_issue = d4_AA_sum + 7'd1;
wire [6:0] d4_BAA_head = (oiss_ge7(d4_BAA_dep, d4_BAA_issue)) ? d4_BAA_dep : d4_BAA_issue;
wire [6:0] d4_BAB_dep = dual_B_rev_lat[0] + dual_B_rev_lat[1];
wire [5:0] d4_BAB_issue = d4_AB_head + 6'd1;
wire [6:0] d4_BAB_head = (oiss_ge7(d4_BAB_dep, d4_BAB_issue)) ? d4_BAB_dep : d4_BAB_issue;
wire [6:0] d4_BBA_sum = d4_BA_head + dual_B_rev_lat[1];
wire [7:0] d4_BBB_sum = d4_BB_sum + dual_B_rev_lat[2];

// Fixed suffix depth 4.
wire [7:0] d4_AAAA_sum = d4_AAA_sum + dual_A_rev_lat[3];
wire [7:0] d4_AAAB_sum = d4_AAB_sum + dual_A_rev_lat[2];
wire [7:0] d4_AABA_sum = d4_ABA_head + dual_A_rev_lat[2];
wire [7:0] d4_AABB_sum = d4_ABB_head + dual_A_rev_lat[1];
wire [7:0] d4_ABAA_dep = d4_AA_sum + dual_A_rev_lat[2];
wire [6:0] d4_ABAA_issue = d4_BAA_head + 7'd1;
wire [7:0] d4_ABAA_head = (oiss_ge8(d4_ABAA_dep, d4_ABAA_issue)) ? d4_ABAA_dep : d4_ABAA_issue;
wire [6:0] d4_ABAB_dep = d4_AB_head + dual_A_rev_lat[1];
wire [6:0] d4_ABAB_issue = d4_BAB_head + 7'd1;
wire [6:0] d4_ABAB_head = (oiss_ge7(d4_ABAB_dep, d4_ABAB_issue)) ? d4_ABAB_dep : d4_ABAB_issue;
wire [6:0] d4_ABBA_dep = dual_A_rev_lat[0] + dual_A_rev_lat[1];
wire [6:0] d4_ABBA_issue = d4_BBA_sum + 7'd1;
wire [6:0] d4_ABBA_head = (oiss_ge7(d4_ABBA_dep, d4_ABBA_issue)) ? d4_ABBA_dep : d4_ABBA_issue;
wire [5:0] d4_ABBB_dep = 1'b0 + dual_A_rev_lat[0];
wire [7:0] d4_ABBB_issue = d4_BBB_sum + 8'd1;
wire [7:0] d4_ABBB_head = (oiss_ge8(d4_ABBB_dep, d4_ABBB_issue)) ? d4_ABBB_dep : d4_ABBB_issue;
wire [5:0] d4_BAAA_dep = 1'b0 + dual_B_rev_lat[0];
wire [7:0] d4_BAAA_issue = d4_AAA_sum + 8'd1;
wire [7:0] d4_BAAA_head = (oiss_ge8(d4_BAAA_dep, d4_BAAA_issue)) ? d4_BAAA_dep : d4_BAAA_issue;
wire [6:0] d4_BAAB_dep = dual_B_rev_lat[0] + dual_B_rev_lat[1];
wire [6:0] d4_BAAB_issue = d4_AAB_sum + 7'd1;
wire [6:0] d4_BAAB_head = (oiss_ge7(d4_BAAB_dep, d4_BAAB_issue)) ? d4_BAAB_dep : d4_BAAB_issue;
wire [6:0] d4_BABA_dep = d4_BA_head + dual_B_rev_lat[1];
wire [6:0] d4_BABA_issue = d4_ABA_head + 7'd1;
wire [6:0] d4_BABA_head = (oiss_ge7(d4_BABA_dep, d4_BABA_issue)) ? d4_BABA_dep : d4_BABA_issue;
wire [7:0] d4_BABB_dep = d4_BB_sum + dual_B_rev_lat[2];
wire [6:0] d4_BABB_issue = d4_ABB_head + 7'd1;
wire [7:0] d4_BABB_head = (oiss_ge8(d4_BABB_dep, d4_BABB_issue)) ? d4_BABB_dep : d4_BABB_issue;
wire [7:0] d4_BBAA_sum = d4_BAA_head + dual_B_rev_lat[1];
wire [7:0] d4_BBAB_sum = d4_BAB_head + dual_B_rev_lat[2];
wire [7:0] d4_BBBA_sum = d4_BBA_sum + dual_B_rev_lat[2];
wire [7:0] d4_BBBB_sum = d4_BBB_sum + dual_B_rev_lat[3];
wire [0:0] d4_sa_0 = 1'b0;
wire [5:0] d4_sa_1 = d4_sa_0 + dual_A_rev_lat[0];
wire [6:0] d4_sa_2 = d4_sa_1 + dual_A_rev_lat[1];
wire [7:0] d4_sa_3 = d4_sa_2 + dual_A_rev_lat[2];
wire [7:0] d4_sa_4 = d4_sa_3 + dual_A_rev_lat[3];
wire [0:0] d4_sb_0 = 1'b0;
wire [5:0] d4_sb_1 = d4_sb_0 + dual_B_rev_lat[0];
wire [6:0] d4_sb_2 = d4_sb_1 + dual_B_rev_lat[1];
wire [7:0] d4_sb_3 = d4_sb_2 + dual_B_rev_lat[2];
wire [7:0] d4_sb_4 = d4_sb_3 + dual_B_rev_lat[3];

// Shared full-width thresholds and equality decoders for bounded merge.
// Valid instruction latencies: 1..50. No truncated-offset membership tests.
wire [7:0] eq_d4_sb_3_plus0 = d4_sb_3;
wire [5:0] eq_d4_sa_1_plus0 = d4_sa_1;
wire [5:0] eq_d4_sa_1_plus1 = d4_sa_1 + 6'd1;
wire [5:0] eq_d4_sa_1_plus2 = d4_sa_1 + 6'd2;
wire [5:0] eq_d4_sa_1_plus3 = d4_sa_1 + 6'd3;
wire [7:0] eq_d4_sb_3_plus1 = d4_sb_3 + 8'd1;
wire [6:0] eq_d4_sa_2_plus0 = d4_sa_2;
wire [6:0] eq_d4_sb_2_plus0 = d4_sb_2;
wire [6:0] eq_d4_sb_2_plus1 = d4_sb_2 + 7'd1;
wire [6:0] eq_d4_sb_2_plus2 = d4_sb_2 + 7'd2;
wire [6:0] eq_d4_sa_2_plus1 = d4_sa_2 + 7'd1;
wire [6:0] eq_d4_sa_2_plus2 = d4_sa_2 + 7'd2;
wire [7:0] eq_d4_sa_3_plus0 = d4_sa_3;
wire [5:0] eq_d4_sb_1_plus0 = d4_sb_1;
wire [5:0] eq_d4_sb_1_plus1 = d4_sb_1 + 6'd1;
wire [5:0] eq_d4_sb_1_plus2 = d4_sb_1 + 6'd2;
wire [5:0] eq_d4_sb_1_plus3 = d4_sb_1 + 6'd3;
wire [7:0] eq_d4_sa_3_plus1 = d4_sa_3 + 8'd1;
wire eq_match_0 = (d4_BBB_sum == eq_d4_sb_3_plus0);
wire eq_match_1 = (d4_ABBB_head == eq_d4_sa_1_plus0);
wire eq_match_2 = (d4_BABB_head == eq_d4_sb_3_plus0);
wire eq_match_3 = (d4_ABB_head == eq_d4_sa_1_plus0);
wire eq_match_4 = (d4_BBAB_sum == eq_d4_sb_3_plus0);
wire eq_match_5 = (d4_AB_head == eq_d4_sa_1_plus0);
wire eq_match_6 = (d4_BBBA_sum == eq_d4_sb_3_plus0);
wire eq_match_7 = (dual_A_rev_lat[0] == eq_d4_sa_1_plus0);
wire eq_match_8 = (d4_ABBB_head == eq_d4_sa_1_plus1);
wire eq_match_9 = (d4_ABB_head == eq_d4_sa_1_plus1);
wire eq_match_10 = (d4_AB_head == eq_d4_sa_1_plus1);
wire eq_match_11 = (dual_A_rev_lat[0] == eq_d4_sa_1_plus1);
wire eq_match_12 = (d4_ABBB_head == eq_d4_sa_1_plus2);
wire eq_match_13 = (d4_ABB_head == eq_d4_sa_1_plus2);
wire eq_match_14 = (d4_AB_head == eq_d4_sa_1_plus2);
wire eq_match_15 = (dual_A_rev_lat[0] == eq_d4_sa_1_plus2);
wire eq_match_16 = (d4_ABBB_head == eq_d4_sa_1_plus3);
wire eq_match_17 = (d4_ABB_head == eq_d4_sa_1_plus3);
wire eq_match_18 = (d4_AB_head == eq_d4_sa_1_plus3);
wire eq_match_19 = (dual_A_rev_lat[0] == eq_d4_sa_1_plus3);
wire eq_match_20 = (d4_BBB_sum == eq_d4_sb_3_plus1);
wire eq_match_21 = (d4_BABB_head == eq_d4_sb_3_plus1);
wire eq_match_22 = (d4_BBAB_sum == eq_d4_sb_3_plus1);
wire eq_match_23 = (d4_BBBA_sum == eq_d4_sb_3_plus1);
wire eq_match_24 = (d4_AABB_sum == eq_d4_sa_2_plus0);
wire eq_match_25 = (d4_BB_sum == eq_d4_sb_2_plus0);
wire eq_match_26 = (d4_ABAB_head == eq_d4_sa_2_plus0);
wire eq_match_27 = (d4_BAB_head == eq_d4_sb_2_plus0);
wire eq_match_28 = (d4_ABBA_head == eq_d4_sa_2_plus0);
wire eq_match_29 = (d4_BBA_sum == eq_d4_sb_2_plus0);
wire eq_match_30 = (d4_AAB_sum == eq_d4_sa_2_plus0);
wire eq_match_31 = (d4_BAAB_head == eq_d4_sb_2_plus0);
wire eq_match_32 = (d4_ABA_head == eq_d4_sa_2_plus0);
wire eq_match_33 = (d4_BABA_head == eq_d4_sb_2_plus0);
wire eq_match_34 = (d4_AA_sum == eq_d4_sa_2_plus0);
wire eq_match_35 = (d4_BBAA_sum == eq_d4_sb_2_plus0);
wire eq_match_36 = (d4_BB_sum == eq_d4_sb_2_plus1);
wire eq_match_37 = (d4_BAB_head == eq_d4_sb_2_plus1);
wire eq_match_38 = (d4_BBA_sum == eq_d4_sb_2_plus1);
wire eq_match_39 = (d4_BAAB_head == eq_d4_sb_2_plus1);
wire eq_match_40 = (d4_BABA_head == eq_d4_sb_2_plus1);
wire eq_match_41 = (d4_BBAA_sum == eq_d4_sb_2_plus1);
wire eq_match_42 = (d4_BB_sum == eq_d4_sb_2_plus2);
wire eq_match_43 = (d4_BAB_head == eq_d4_sb_2_plus2);
wire eq_match_44 = (d4_BBA_sum == eq_d4_sb_2_plus2);
wire eq_match_45 = (d4_BAAB_head == eq_d4_sb_2_plus2);
wire eq_match_46 = (d4_BABA_head == eq_d4_sb_2_plus2);
wire eq_match_47 = (d4_BBAA_sum == eq_d4_sb_2_plus2);
wire eq_match_48 = (d4_AABB_sum == eq_d4_sa_2_plus1);
wire eq_match_49 = (d4_ABAB_head == eq_d4_sa_2_plus1);
wire eq_match_50 = (d4_ABBA_head == eq_d4_sa_2_plus1);
wire eq_match_51 = (d4_AAB_sum == eq_d4_sa_2_plus1);
wire eq_match_52 = (d4_ABA_head == eq_d4_sa_2_plus1);
wire eq_match_53 = (d4_AA_sum == eq_d4_sa_2_plus1);
wire eq_match_54 = (d4_AABB_sum == eq_d4_sa_2_plus2);
wire eq_match_55 = (d4_ABAB_head == eq_d4_sa_2_plus2);
wire eq_match_56 = (d4_ABBA_head == eq_d4_sa_2_plus2);
wire eq_match_57 = (d4_AAB_sum == eq_d4_sa_2_plus2);
wire eq_match_58 = (d4_ABA_head == eq_d4_sa_2_plus2);
wire eq_match_59 = (d4_AA_sum == eq_d4_sa_2_plus2);
wire eq_match_60 = (d4_AAAB_sum == eq_d4_sa_3_plus0);
wire eq_match_61 = (dual_B_rev_lat[0] == eq_d4_sb_1_plus0);
wire eq_match_62 = (d4_AABA_sum == eq_d4_sa_3_plus0);
wire eq_match_63 = (d4_BA_head == eq_d4_sb_1_plus0);
wire eq_match_64 = (d4_ABAA_head == eq_d4_sa_3_plus0);
wire eq_match_65 = (d4_BAA_head == eq_d4_sb_1_plus0);
wire eq_match_66 = (d4_AAA_sum == eq_d4_sa_3_plus0);
wire eq_match_67 = (d4_BAAA_head == eq_d4_sb_1_plus0);
wire eq_match_68 = (dual_B_rev_lat[0] == eq_d4_sb_1_plus1);
wire eq_match_69 = (d4_BA_head == eq_d4_sb_1_plus1);
wire eq_match_70 = (d4_BAA_head == eq_d4_sb_1_plus1);
wire eq_match_71 = (d4_BAAA_head == eq_d4_sb_1_plus1);
wire eq_match_72 = (dual_B_rev_lat[0] == eq_d4_sb_1_plus2);
wire eq_match_73 = (d4_BA_head == eq_d4_sb_1_plus2);
wire eq_match_74 = (d4_BAA_head == eq_d4_sb_1_plus2);
wire eq_match_75 = (d4_BAAA_head == eq_d4_sb_1_plus2);
wire eq_match_76 = (dual_B_rev_lat[0] == eq_d4_sb_1_plus3);
wire eq_match_77 = (d4_BA_head == eq_d4_sb_1_plus3);
wire eq_match_78 = (d4_BAA_head == eq_d4_sb_1_plus3);
wire eq_match_79 = (d4_BAAA_head == eq_d4_sb_1_plus3);
wire eq_match_80 = (d4_AAAB_sum == eq_d4_sa_3_plus1);
wire eq_match_81 = (d4_AABA_sum == eq_d4_sa_3_plus1);
wire eq_match_82 = (d4_ABAA_head == eq_d4_sa_3_plus1);
wire eq_match_83 = (d4_AAA_sum == eq_d4_sa_3_plus1);

// Fixed state slot 0A4B, eB=0.
wire m4_0a4b_eb0_v = 1'b1;
wire [3:0] m4_0a4b_eb0_suffix = 4'b0000;
wire [0:0] m4_0a4b_eb0_ra = 1'b0;
wire [7:0] m4_0a4b_eb0_rb = d4_BBBB_sum;

// Fixed state slot 1A3B, eB=0.
wire [7:0] m4_1a3b_eb0_fixed = eq_d4_sb_3_plus0;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_1a3b_eb0_bucket0_0 = eq_match_0 && eq_match_1;
wire m4_1a3b_eb0_bucket0_1 = eq_match_2 && eq_match_3;
wire m4_1a3b_eb0_bucket0_2 = eq_match_4 && eq_match_5;
wire m4_1a3b_eb0_bucket0_3 = eq_match_6 && eq_match_7;
wire m4_1a3b_eb0_has0 = m4_1a3b_eb0_bucket0_0 | m4_1a3b_eb0_bucket0_1 | m4_1a3b_eb0_bucket0_2 | m4_1a3b_eb0_bucket0_3;
wire m4_1a3b_eb0_bucket1_0 = eq_match_0 && eq_match_8;
wire m4_1a3b_eb0_bucket1_1 = eq_match_2 && eq_match_9;
wire m4_1a3b_eb0_bucket1_2 = eq_match_4 && eq_match_10;
wire m4_1a3b_eb0_bucket1_3 = eq_match_6 && eq_match_11;
wire m4_1a3b_eb0_has1 = m4_1a3b_eb0_bucket1_0 | m4_1a3b_eb0_bucket1_1 | m4_1a3b_eb0_bucket1_2 | m4_1a3b_eb0_bucket1_3;
wire m4_1a3b_eb0_bucket2_0 = eq_match_0 && eq_match_12;
wire m4_1a3b_eb0_bucket2_1 = eq_match_2 && eq_match_13;
wire m4_1a3b_eb0_bucket2_2 = eq_match_4 && eq_match_14;
wire m4_1a3b_eb0_bucket2_3 = eq_match_6 && eq_match_15;
wire m4_1a3b_eb0_has2 = m4_1a3b_eb0_bucket2_0 | m4_1a3b_eb0_bucket2_1 | m4_1a3b_eb0_bucket2_2 | m4_1a3b_eb0_bucket2_3;
wire m4_1a3b_eb0_bucket3_0 = eq_match_0 && eq_match_16;
wire m4_1a3b_eb0_bucket3_1 = eq_match_2 && eq_match_17;
wire m4_1a3b_eb0_bucket3_2 = eq_match_4 && eq_match_18;
wire m4_1a3b_eb0_bucket3_3 = eq_match_6 && eq_match_19;
wire m4_1a3b_eb0_has3 = m4_1a3b_eb0_bucket3_0 | m4_1a3b_eb0_bucket3_1 | m4_1a3b_eb0_bucket3_2 | m4_1a3b_eb0_bucket3_3;
wire m4_1a3b_eb0_choose0 = m4_1a3b_eb0_has0;
wire m4_1a3b_eb0_choose1 = m4_1a3b_eb0_has1 && !(m4_1a3b_eb0_has0);
wire m4_1a3b_eb0_choose2 = m4_1a3b_eb0_has2 && !(m4_1a3b_eb0_has0 | m4_1a3b_eb0_has1);
wire m4_1a3b_eb0_choose3 = m4_1a3b_eb0_has3 && !(m4_1a3b_eb0_has0 | m4_1a3b_eb0_has1 | m4_1a3b_eb0_has2);
wire [1:0] m4_1a3b_eb0_offset_min = ({2{m4_1a3b_eb0_choose1}} & 2'd1) | ({2{m4_1a3b_eb0_choose2}} & 2'd2) | ({2{m4_1a3b_eb0_choose3}} & 2'd3);
wire m4_1a3b_eb0_occupied = m4_1a3b_eb0_has0 | m4_1a3b_eb0_has1 | m4_1a3b_eb0_has2 | m4_1a3b_eb0_has3;
wire m4_1a3b_eb0_winner0 = (m4_1a3b_eb0_choose0 && m4_1a3b_eb0_bucket0_0) | (m4_1a3b_eb0_choose1 && m4_1a3b_eb0_bucket1_0) | (m4_1a3b_eb0_choose2 && m4_1a3b_eb0_bucket2_0) | (m4_1a3b_eb0_choose3 && m4_1a3b_eb0_bucket3_0);
wire m4_1a3b_eb0_winner1 = (m4_1a3b_eb0_choose0 && m4_1a3b_eb0_bucket0_1) | (m4_1a3b_eb0_choose1 && m4_1a3b_eb0_bucket1_1) | (m4_1a3b_eb0_choose2 && m4_1a3b_eb0_bucket2_1) | (m4_1a3b_eb0_choose3 && m4_1a3b_eb0_bucket3_1);
wire m4_1a3b_eb0_winner2 = (m4_1a3b_eb0_choose0 && m4_1a3b_eb0_bucket0_2) | (m4_1a3b_eb0_choose1 && m4_1a3b_eb0_bucket1_2) | (m4_1a3b_eb0_choose2 && m4_1a3b_eb0_bucket2_2) | (m4_1a3b_eb0_choose3 && m4_1a3b_eb0_bucket3_2);
wire m4_1a3b_eb0_winner3 = (m4_1a3b_eb0_choose0 && m4_1a3b_eb0_bucket0_3) | (m4_1a3b_eb0_choose1 && m4_1a3b_eb0_bucket1_3) | (m4_1a3b_eb0_choose2 && m4_1a3b_eb0_bucket2_3) | (m4_1a3b_eb0_choose3 && m4_1a3b_eb0_bucket3_3);
wire [3:0] m4_1a3b_eb0_selected_path = ({4{m4_1a3b_eb0_winner0}} & 4'b1000) | ({4{m4_1a3b_eb0_winner1 && !(m4_1a3b_eb0_winner0)}} & 4'b0100) | ({4{m4_1a3b_eb0_winner2 && !(m4_1a3b_eb0_winner0 | m4_1a3b_eb0_winner1)}} & 4'b0010) | ({4{m4_1a3b_eb0_winner3 && !(m4_1a3b_eb0_winner0 | m4_1a3b_eb0_winner1 | m4_1a3b_eb0_winner2)}} & 4'b0001);
wire [5:0] m4_1a3b_eb0_other = d4_sa_1 + m4_1a3b_eb0_offset_min;
wire m4_1a3b_eb0_v = m4_1a3b_eb0_occupied;
wire [3:0] m4_1a3b_eb0_suffix = m4_1a3b_eb0_selected_path;
wire [5:0] m4_1a3b_eb0_ra = m4_1a3b_eb0_other;
wire [7:0] m4_1a3b_eb0_rb = m4_1a3b_eb0_fixed;

// Fixed state slot 1A3B, eB=1.
wire [7:0] m4_1a3b_eb1_fixed = eq_d4_sb_3_plus1;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_1a3b_eb1_bucket0_0 = eq_match_20 && eq_match_1;
wire m4_1a3b_eb1_bucket0_1 = eq_match_21 && eq_match_3;
wire m4_1a3b_eb1_bucket0_2 = eq_match_22 && eq_match_5;
wire m4_1a3b_eb1_bucket0_3 = eq_match_23 && eq_match_7;
wire m4_1a3b_eb1_has0 = m4_1a3b_eb1_bucket0_0 | m4_1a3b_eb1_bucket0_1 | m4_1a3b_eb1_bucket0_2 | m4_1a3b_eb1_bucket0_3;
wire m4_1a3b_eb1_bucket1_0 = eq_match_20 && eq_match_8;
wire m4_1a3b_eb1_bucket1_1 = eq_match_21 && eq_match_9;
wire m4_1a3b_eb1_bucket1_2 = eq_match_22 && eq_match_10;
wire m4_1a3b_eb1_bucket1_3 = eq_match_23 && eq_match_11;
wire m4_1a3b_eb1_has1 = m4_1a3b_eb1_bucket1_0 | m4_1a3b_eb1_bucket1_1 | m4_1a3b_eb1_bucket1_2 | m4_1a3b_eb1_bucket1_3;
wire m4_1a3b_eb1_bucket2_0 = eq_match_20 && eq_match_12;
wire m4_1a3b_eb1_bucket2_1 = eq_match_21 && eq_match_13;
wire m4_1a3b_eb1_bucket2_2 = eq_match_22 && eq_match_14;
wire m4_1a3b_eb1_bucket2_3 = eq_match_23 && eq_match_15;
wire m4_1a3b_eb1_has2 = m4_1a3b_eb1_bucket2_0 | m4_1a3b_eb1_bucket2_1 | m4_1a3b_eb1_bucket2_2 | m4_1a3b_eb1_bucket2_3;
wire m4_1a3b_eb1_bucket3_0 = eq_match_20 && eq_match_16;
wire m4_1a3b_eb1_bucket3_1 = eq_match_21 && eq_match_17;
wire m4_1a3b_eb1_bucket3_2 = eq_match_22 && eq_match_18;
wire m4_1a3b_eb1_bucket3_3 = eq_match_23 && eq_match_19;
wire m4_1a3b_eb1_has3 = m4_1a3b_eb1_bucket3_0 | m4_1a3b_eb1_bucket3_1 | m4_1a3b_eb1_bucket3_2 | m4_1a3b_eb1_bucket3_3;
wire m4_1a3b_eb1_choose0 = m4_1a3b_eb1_has0;
wire m4_1a3b_eb1_choose1 = m4_1a3b_eb1_has1 && !(m4_1a3b_eb1_has0);
wire m4_1a3b_eb1_choose2 = m4_1a3b_eb1_has2 && !(m4_1a3b_eb1_has0 | m4_1a3b_eb1_has1);
wire m4_1a3b_eb1_choose3 = m4_1a3b_eb1_has3 && !(m4_1a3b_eb1_has0 | m4_1a3b_eb1_has1 | m4_1a3b_eb1_has2);
wire [1:0] m4_1a3b_eb1_offset_min = ({2{m4_1a3b_eb1_choose1}} & 2'd1) | ({2{m4_1a3b_eb1_choose2}} & 2'd2) | ({2{m4_1a3b_eb1_choose3}} & 2'd3);
wire m4_1a3b_eb1_occupied = m4_1a3b_eb1_has0 | m4_1a3b_eb1_has1 | m4_1a3b_eb1_has2 | m4_1a3b_eb1_has3;
wire m4_1a3b_eb1_winner0 = (m4_1a3b_eb1_choose0 && m4_1a3b_eb1_bucket0_0) | (m4_1a3b_eb1_choose1 && m4_1a3b_eb1_bucket1_0) | (m4_1a3b_eb1_choose2 && m4_1a3b_eb1_bucket2_0) | (m4_1a3b_eb1_choose3 && m4_1a3b_eb1_bucket3_0);
wire m4_1a3b_eb1_winner1 = (m4_1a3b_eb1_choose0 && m4_1a3b_eb1_bucket0_1) | (m4_1a3b_eb1_choose1 && m4_1a3b_eb1_bucket1_1) | (m4_1a3b_eb1_choose2 && m4_1a3b_eb1_bucket2_1) | (m4_1a3b_eb1_choose3 && m4_1a3b_eb1_bucket3_1);
wire m4_1a3b_eb1_winner2 = (m4_1a3b_eb1_choose0 && m4_1a3b_eb1_bucket0_2) | (m4_1a3b_eb1_choose1 && m4_1a3b_eb1_bucket1_2) | (m4_1a3b_eb1_choose2 && m4_1a3b_eb1_bucket2_2) | (m4_1a3b_eb1_choose3 && m4_1a3b_eb1_bucket3_2);
wire m4_1a3b_eb1_winner3 = (m4_1a3b_eb1_choose0 && m4_1a3b_eb1_bucket0_3) | (m4_1a3b_eb1_choose1 && m4_1a3b_eb1_bucket1_3) | (m4_1a3b_eb1_choose2 && m4_1a3b_eb1_bucket2_3) | (m4_1a3b_eb1_choose3 && m4_1a3b_eb1_bucket3_3);
wire [3:0] m4_1a3b_eb1_selected_path = ({4{m4_1a3b_eb1_winner0}} & 4'b1000) | ({4{m4_1a3b_eb1_winner1 && !(m4_1a3b_eb1_winner0)}} & 4'b0100) | ({4{m4_1a3b_eb1_winner2 && !(m4_1a3b_eb1_winner0 | m4_1a3b_eb1_winner1)}} & 4'b0010) | ({4{m4_1a3b_eb1_winner3 && !(m4_1a3b_eb1_winner0 | m4_1a3b_eb1_winner1 | m4_1a3b_eb1_winner2)}} & 4'b0001);
wire [5:0] m4_1a3b_eb1_other = d4_sa_1 + m4_1a3b_eb1_offset_min;
wire m4_1a3b_eb1_v = m4_1a3b_eb1_occupied;
wire [3:0] m4_1a3b_eb1_suffix = m4_1a3b_eb1_selected_path;
wire [5:0] m4_1a3b_eb1_ra = m4_1a3b_eb1_other;
wire [7:0] m4_1a3b_eb1_rb = m4_1a3b_eb1_fixed;

// Fixed state slot 2A2B, eA=0.
wire [6:0] m4_2a2b_ea0_fixed = eq_d4_sa_2_plus0;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_2a2b_ea0_bucket0_0 = eq_match_24 && eq_match_25;
wire m4_2a2b_ea0_bucket0_1 = eq_match_26 && eq_match_27;
wire m4_2a2b_ea0_bucket0_2 = eq_match_28 && eq_match_29;
wire m4_2a2b_ea0_bucket0_3 = eq_match_30 && eq_match_31;
wire m4_2a2b_ea0_bucket0_4 = eq_match_32 && eq_match_33;
wire m4_2a2b_ea0_bucket0_5 = eq_match_34 && eq_match_35;
wire m4_2a2b_ea0_has0 = m4_2a2b_ea0_bucket0_0 | m4_2a2b_ea0_bucket0_1 | m4_2a2b_ea0_bucket0_2 | m4_2a2b_ea0_bucket0_3 | m4_2a2b_ea0_bucket0_4 | m4_2a2b_ea0_bucket0_5;
wire m4_2a2b_ea0_bucket1_0 = eq_match_24 && eq_match_36;
wire m4_2a2b_ea0_bucket1_1 = eq_match_26 && eq_match_37;
wire m4_2a2b_ea0_bucket1_2 = eq_match_28 && eq_match_38;
wire m4_2a2b_ea0_bucket1_3 = eq_match_30 && eq_match_39;
wire m4_2a2b_ea0_bucket1_4 = eq_match_32 && eq_match_40;
wire m4_2a2b_ea0_bucket1_5 = eq_match_34 && eq_match_41;
wire m4_2a2b_ea0_has1 = m4_2a2b_ea0_bucket1_0 | m4_2a2b_ea0_bucket1_1 | m4_2a2b_ea0_bucket1_2 | m4_2a2b_ea0_bucket1_3 | m4_2a2b_ea0_bucket1_4 | m4_2a2b_ea0_bucket1_5;
wire m4_2a2b_ea0_bucket2_0 = eq_match_24 && eq_match_42;
wire m4_2a2b_ea0_bucket2_1 = eq_match_26 && eq_match_43;
wire m4_2a2b_ea0_bucket2_2 = eq_match_28 && eq_match_44;
wire m4_2a2b_ea0_bucket2_3 = eq_match_30 && eq_match_45;
wire m4_2a2b_ea0_bucket2_4 = eq_match_32 && eq_match_46;
wire m4_2a2b_ea0_bucket2_5 = eq_match_34 && eq_match_47;
wire m4_2a2b_ea0_has2 = m4_2a2b_ea0_bucket2_0 | m4_2a2b_ea0_bucket2_1 | m4_2a2b_ea0_bucket2_2 | m4_2a2b_ea0_bucket2_3 | m4_2a2b_ea0_bucket2_4 | m4_2a2b_ea0_bucket2_5;
wire m4_2a2b_ea0_choose0 = m4_2a2b_ea0_has0;
wire m4_2a2b_ea0_choose1 = m4_2a2b_ea0_has1 && !(m4_2a2b_ea0_has0);
wire m4_2a2b_ea0_choose2 = m4_2a2b_ea0_has2 && !(m4_2a2b_ea0_has0 | m4_2a2b_ea0_has1);
wire [1:0] m4_2a2b_ea0_offset_min = ({2{m4_2a2b_ea0_choose1}} & 2'd1) | ({2{m4_2a2b_ea0_choose2}} & 2'd2);
wire m4_2a2b_ea0_occupied = m4_2a2b_ea0_has0 | m4_2a2b_ea0_has1 | m4_2a2b_ea0_has2;
wire m4_2a2b_ea0_winner0 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_0) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_0) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_0);
wire m4_2a2b_ea0_winner1 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_1) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_1) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_1);
wire m4_2a2b_ea0_winner2 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_2) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_2) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_2);
wire m4_2a2b_ea0_winner3 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_3) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_3) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_3);
wire m4_2a2b_ea0_winner4 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_4) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_4) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_4);
wire m4_2a2b_ea0_winner5 = (m4_2a2b_ea0_choose0 && m4_2a2b_ea0_bucket0_5) | (m4_2a2b_ea0_choose1 && m4_2a2b_ea0_bucket1_5) | (m4_2a2b_ea0_choose2 && m4_2a2b_ea0_bucket2_5);
wire [3:0] m4_2a2b_ea0_selected_path = ({4{m4_2a2b_ea0_winner0}} & 4'b1100) | ({4{m4_2a2b_ea0_winner1 && !(m4_2a2b_ea0_winner0)}} & 4'b1010) | ({4{m4_2a2b_ea0_winner2 && !(m4_2a2b_ea0_winner0 | m4_2a2b_ea0_winner1)}} & 4'b1001) | ({4{m4_2a2b_ea0_winner3 && !(m4_2a2b_ea0_winner0 | m4_2a2b_ea0_winner1 | m4_2a2b_ea0_winner2)}} & 4'b0110) | ({4{m4_2a2b_ea0_winner4 && !(m4_2a2b_ea0_winner0 | m4_2a2b_ea0_winner1 | m4_2a2b_ea0_winner2 | m4_2a2b_ea0_winner3)}} & 4'b0101) | ({4{m4_2a2b_ea0_winner5 && !(m4_2a2b_ea0_winner0 | m4_2a2b_ea0_winner1 | m4_2a2b_ea0_winner2 | m4_2a2b_ea0_winner3 | m4_2a2b_ea0_winner4)}} & 4'b0011);
wire [6:0] m4_2a2b_ea0_other = d4_sb_2 + m4_2a2b_ea0_offset_min;
wire m4_2a2b_ea0_v = m4_2a2b_ea0_occupied;
wire [3:0] m4_2a2b_ea0_suffix = m4_2a2b_ea0_selected_path;
wire [6:0] m4_2a2b_ea0_ra = m4_2a2b_ea0_fixed;
wire [6:0] m4_2a2b_ea0_rb = m4_2a2b_ea0_other;

// Fixed state slot 2A2B, eA=1.
wire [6:0] m4_2a2b_ea1_fixed = eq_d4_sa_2_plus1;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_2a2b_ea1_bucket0_0 = eq_match_48 && eq_match_25;
wire m4_2a2b_ea1_bucket0_1 = eq_match_49 && eq_match_27;
wire m4_2a2b_ea1_bucket0_2 = eq_match_50 && eq_match_29;
wire m4_2a2b_ea1_bucket0_3 = eq_match_51 && eq_match_31;
wire m4_2a2b_ea1_bucket0_4 = eq_match_52 && eq_match_33;
wire m4_2a2b_ea1_bucket0_5 = eq_match_53 && eq_match_35;
wire m4_2a2b_ea1_has0 = m4_2a2b_ea1_bucket0_0 | m4_2a2b_ea1_bucket0_1 | m4_2a2b_ea1_bucket0_2 | m4_2a2b_ea1_bucket0_3 | m4_2a2b_ea1_bucket0_4 | m4_2a2b_ea1_bucket0_5;
wire m4_2a2b_ea1_bucket1_0 = eq_match_48 && eq_match_36;
wire m4_2a2b_ea1_bucket1_1 = eq_match_49 && eq_match_37;
wire m4_2a2b_ea1_bucket1_2 = eq_match_50 && eq_match_38;
wire m4_2a2b_ea1_bucket1_3 = eq_match_51 && eq_match_39;
wire m4_2a2b_ea1_bucket1_4 = eq_match_52 && eq_match_40;
wire m4_2a2b_ea1_bucket1_5 = eq_match_53 && eq_match_41;
wire m4_2a2b_ea1_has1 = m4_2a2b_ea1_bucket1_0 | m4_2a2b_ea1_bucket1_1 | m4_2a2b_ea1_bucket1_2 | m4_2a2b_ea1_bucket1_3 | m4_2a2b_ea1_bucket1_4 | m4_2a2b_ea1_bucket1_5;
wire m4_2a2b_ea1_bucket2_0 = eq_match_48 && eq_match_42;
wire m4_2a2b_ea1_bucket2_1 = eq_match_49 && eq_match_43;
wire m4_2a2b_ea1_bucket2_2 = eq_match_50 && eq_match_44;
wire m4_2a2b_ea1_bucket2_3 = eq_match_51 && eq_match_45;
wire m4_2a2b_ea1_bucket2_4 = eq_match_52 && eq_match_46;
wire m4_2a2b_ea1_bucket2_5 = eq_match_53 && eq_match_47;
wire m4_2a2b_ea1_has2 = m4_2a2b_ea1_bucket2_0 | m4_2a2b_ea1_bucket2_1 | m4_2a2b_ea1_bucket2_2 | m4_2a2b_ea1_bucket2_3 | m4_2a2b_ea1_bucket2_4 | m4_2a2b_ea1_bucket2_5;
wire m4_2a2b_ea1_choose0 = m4_2a2b_ea1_has0;
wire m4_2a2b_ea1_choose1 = m4_2a2b_ea1_has1 && !(m4_2a2b_ea1_has0);
wire m4_2a2b_ea1_choose2 = m4_2a2b_ea1_has2 && !(m4_2a2b_ea1_has0 | m4_2a2b_ea1_has1);
wire [1:0] m4_2a2b_ea1_offset_min = ({2{m4_2a2b_ea1_choose1}} & 2'd1) | ({2{m4_2a2b_ea1_choose2}} & 2'd2);
wire m4_2a2b_ea1_occupied = m4_2a2b_ea1_has0 | m4_2a2b_ea1_has1 | m4_2a2b_ea1_has2;
wire m4_2a2b_ea1_winner0 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_0) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_0) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_0);
wire m4_2a2b_ea1_winner1 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_1) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_1) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_1);
wire m4_2a2b_ea1_winner2 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_2) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_2) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_2);
wire m4_2a2b_ea1_winner3 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_3) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_3) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_3);
wire m4_2a2b_ea1_winner4 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_4) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_4) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_4);
wire m4_2a2b_ea1_winner5 = (m4_2a2b_ea1_choose0 && m4_2a2b_ea1_bucket0_5) | (m4_2a2b_ea1_choose1 && m4_2a2b_ea1_bucket1_5) | (m4_2a2b_ea1_choose2 && m4_2a2b_ea1_bucket2_5);
wire [3:0] m4_2a2b_ea1_selected_path = ({4{m4_2a2b_ea1_winner0}} & 4'b1100) | ({4{m4_2a2b_ea1_winner1 && !(m4_2a2b_ea1_winner0)}} & 4'b1010) | ({4{m4_2a2b_ea1_winner2 && !(m4_2a2b_ea1_winner0 | m4_2a2b_ea1_winner1)}} & 4'b1001) | ({4{m4_2a2b_ea1_winner3 && !(m4_2a2b_ea1_winner0 | m4_2a2b_ea1_winner1 | m4_2a2b_ea1_winner2)}} & 4'b0110) | ({4{m4_2a2b_ea1_winner4 && !(m4_2a2b_ea1_winner0 | m4_2a2b_ea1_winner1 | m4_2a2b_ea1_winner2 | m4_2a2b_ea1_winner3)}} & 4'b0101) | ({4{m4_2a2b_ea1_winner5 && !(m4_2a2b_ea1_winner0 | m4_2a2b_ea1_winner1 | m4_2a2b_ea1_winner2 | m4_2a2b_ea1_winner3 | m4_2a2b_ea1_winner4)}} & 4'b0011);
wire [6:0] m4_2a2b_ea1_other = d4_sb_2 + m4_2a2b_ea1_offset_min;
wire m4_2a2b_ea1_v = m4_2a2b_ea1_occupied;
wire [3:0] m4_2a2b_ea1_suffix = m4_2a2b_ea1_selected_path;
wire [6:0] m4_2a2b_ea1_ra = m4_2a2b_ea1_fixed;
wire [6:0] m4_2a2b_ea1_rb = m4_2a2b_ea1_other;

// Fixed state slot 2A2B, eA=2.
wire [6:0] m4_2a2b_ea2_fixed = eq_d4_sa_2_plus2;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_2a2b_ea2_bucket0_0 = eq_match_54 && eq_match_25;
wire m4_2a2b_ea2_bucket0_1 = eq_match_55 && eq_match_27;
wire m4_2a2b_ea2_bucket0_2 = eq_match_56 && eq_match_29;
wire m4_2a2b_ea2_bucket0_3 = eq_match_57 && eq_match_31;
wire m4_2a2b_ea2_bucket0_4 = eq_match_58 && eq_match_33;
wire m4_2a2b_ea2_bucket0_5 = eq_match_59 && eq_match_35;
wire m4_2a2b_ea2_has0 = m4_2a2b_ea2_bucket0_0 | m4_2a2b_ea2_bucket0_1 | m4_2a2b_ea2_bucket0_2 | m4_2a2b_ea2_bucket0_3 | m4_2a2b_ea2_bucket0_4 | m4_2a2b_ea2_bucket0_5;
wire m4_2a2b_ea2_bucket1_0 = eq_match_54 && eq_match_36;
wire m4_2a2b_ea2_bucket1_1 = eq_match_55 && eq_match_37;
wire m4_2a2b_ea2_bucket1_2 = eq_match_56 && eq_match_38;
wire m4_2a2b_ea2_bucket1_3 = eq_match_57 && eq_match_39;
wire m4_2a2b_ea2_bucket1_4 = eq_match_58 && eq_match_40;
wire m4_2a2b_ea2_bucket1_5 = eq_match_59 && eq_match_41;
wire m4_2a2b_ea2_has1 = m4_2a2b_ea2_bucket1_0 | m4_2a2b_ea2_bucket1_1 | m4_2a2b_ea2_bucket1_2 | m4_2a2b_ea2_bucket1_3 | m4_2a2b_ea2_bucket1_4 | m4_2a2b_ea2_bucket1_5;
wire m4_2a2b_ea2_bucket2_0 = eq_match_54 && eq_match_42;
wire m4_2a2b_ea2_bucket2_1 = eq_match_55 && eq_match_43;
wire m4_2a2b_ea2_bucket2_2 = eq_match_56 && eq_match_44;
wire m4_2a2b_ea2_bucket2_3 = eq_match_57 && eq_match_45;
wire m4_2a2b_ea2_bucket2_4 = eq_match_58 && eq_match_46;
wire m4_2a2b_ea2_bucket2_5 = eq_match_59 && eq_match_47;
wire m4_2a2b_ea2_has2 = m4_2a2b_ea2_bucket2_0 | m4_2a2b_ea2_bucket2_1 | m4_2a2b_ea2_bucket2_2 | m4_2a2b_ea2_bucket2_3 | m4_2a2b_ea2_bucket2_4 | m4_2a2b_ea2_bucket2_5;
wire m4_2a2b_ea2_choose0 = m4_2a2b_ea2_has0;
wire m4_2a2b_ea2_choose1 = m4_2a2b_ea2_has1 && !(m4_2a2b_ea2_has0);
wire m4_2a2b_ea2_choose2 = m4_2a2b_ea2_has2 && !(m4_2a2b_ea2_has0 | m4_2a2b_ea2_has1);
wire [1:0] m4_2a2b_ea2_offset_min = ({2{m4_2a2b_ea2_choose1}} & 2'd1) | ({2{m4_2a2b_ea2_choose2}} & 2'd2);
wire m4_2a2b_ea2_occupied = m4_2a2b_ea2_has0 | m4_2a2b_ea2_has1 | m4_2a2b_ea2_has2;
wire m4_2a2b_ea2_winner0 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_0) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_0) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_0);
wire m4_2a2b_ea2_winner1 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_1) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_1) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_1);
wire m4_2a2b_ea2_winner2 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_2) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_2) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_2);
wire m4_2a2b_ea2_winner3 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_3) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_3) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_3);
wire m4_2a2b_ea2_winner4 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_4) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_4) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_4);
wire m4_2a2b_ea2_winner5 = (m4_2a2b_ea2_choose0 && m4_2a2b_ea2_bucket0_5) | (m4_2a2b_ea2_choose1 && m4_2a2b_ea2_bucket1_5) | (m4_2a2b_ea2_choose2 && m4_2a2b_ea2_bucket2_5);
wire [3:0] m4_2a2b_ea2_selected_path = ({4{m4_2a2b_ea2_winner0}} & 4'b1100) | ({4{m4_2a2b_ea2_winner1 && !(m4_2a2b_ea2_winner0)}} & 4'b1010) | ({4{m4_2a2b_ea2_winner2 && !(m4_2a2b_ea2_winner0 | m4_2a2b_ea2_winner1)}} & 4'b1001) | ({4{m4_2a2b_ea2_winner3 && !(m4_2a2b_ea2_winner0 | m4_2a2b_ea2_winner1 | m4_2a2b_ea2_winner2)}} & 4'b0110) | ({4{m4_2a2b_ea2_winner4 && !(m4_2a2b_ea2_winner0 | m4_2a2b_ea2_winner1 | m4_2a2b_ea2_winner2 | m4_2a2b_ea2_winner3)}} & 4'b0101) | ({4{m4_2a2b_ea2_winner5 && !(m4_2a2b_ea2_winner0 | m4_2a2b_ea2_winner1 | m4_2a2b_ea2_winner2 | m4_2a2b_ea2_winner3 | m4_2a2b_ea2_winner4)}} & 4'b0011);
wire [6:0] m4_2a2b_ea2_other = d4_sb_2 + m4_2a2b_ea2_offset_min;
wire m4_2a2b_ea2_v = m4_2a2b_ea2_occupied;
wire [3:0] m4_2a2b_ea2_suffix = m4_2a2b_ea2_selected_path;
wire [6:0] m4_2a2b_ea2_ra = m4_2a2b_ea2_fixed;
wire [6:0] m4_2a2b_ea2_rb = m4_2a2b_ea2_other;

// Fixed state slot 3A1B, eA=0.
wire [7:0] m4_3a1b_ea0_fixed = eq_d4_sa_3_plus0;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_3a1b_ea0_bucket0_0 = eq_match_60 && eq_match_61;
wire m4_3a1b_ea0_bucket0_1 = eq_match_62 && eq_match_63;
wire m4_3a1b_ea0_bucket0_2 = eq_match_64 && eq_match_65;
wire m4_3a1b_ea0_bucket0_3 = eq_match_66 && eq_match_67;
wire m4_3a1b_ea0_has0 = m4_3a1b_ea0_bucket0_0 | m4_3a1b_ea0_bucket0_1 | m4_3a1b_ea0_bucket0_2 | m4_3a1b_ea0_bucket0_3;
wire m4_3a1b_ea0_bucket1_0 = eq_match_60 && eq_match_68;
wire m4_3a1b_ea0_bucket1_1 = eq_match_62 && eq_match_69;
wire m4_3a1b_ea0_bucket1_2 = eq_match_64 && eq_match_70;
wire m4_3a1b_ea0_bucket1_3 = eq_match_66 && eq_match_71;
wire m4_3a1b_ea0_has1 = m4_3a1b_ea0_bucket1_0 | m4_3a1b_ea0_bucket1_1 | m4_3a1b_ea0_bucket1_2 | m4_3a1b_ea0_bucket1_3;
wire m4_3a1b_ea0_bucket2_0 = eq_match_60 && eq_match_72;
wire m4_3a1b_ea0_bucket2_1 = eq_match_62 && eq_match_73;
wire m4_3a1b_ea0_bucket2_2 = eq_match_64 && eq_match_74;
wire m4_3a1b_ea0_bucket2_3 = eq_match_66 && eq_match_75;
wire m4_3a1b_ea0_has2 = m4_3a1b_ea0_bucket2_0 | m4_3a1b_ea0_bucket2_1 | m4_3a1b_ea0_bucket2_2 | m4_3a1b_ea0_bucket2_3;
wire m4_3a1b_ea0_bucket3_0 = eq_match_60 && eq_match_76;
wire m4_3a1b_ea0_bucket3_1 = eq_match_62 && eq_match_77;
wire m4_3a1b_ea0_bucket3_2 = eq_match_64 && eq_match_78;
wire m4_3a1b_ea0_bucket3_3 = eq_match_66 && eq_match_79;
wire m4_3a1b_ea0_has3 = m4_3a1b_ea0_bucket3_0 | m4_3a1b_ea0_bucket3_1 | m4_3a1b_ea0_bucket3_2 | m4_3a1b_ea0_bucket3_3;
wire m4_3a1b_ea0_choose0 = m4_3a1b_ea0_has0;
wire m4_3a1b_ea0_choose1 = m4_3a1b_ea0_has1 && !(m4_3a1b_ea0_has0);
wire m4_3a1b_ea0_choose2 = m4_3a1b_ea0_has2 && !(m4_3a1b_ea0_has0 | m4_3a1b_ea0_has1);
wire m4_3a1b_ea0_choose3 = m4_3a1b_ea0_has3 && !(m4_3a1b_ea0_has0 | m4_3a1b_ea0_has1 | m4_3a1b_ea0_has2);
wire [1:0] m4_3a1b_ea0_offset_min = ({2{m4_3a1b_ea0_choose1}} & 2'd1) | ({2{m4_3a1b_ea0_choose2}} & 2'd2) | ({2{m4_3a1b_ea0_choose3}} & 2'd3);
wire m4_3a1b_ea0_occupied = m4_3a1b_ea0_has0 | m4_3a1b_ea0_has1 | m4_3a1b_ea0_has2 | m4_3a1b_ea0_has3;
wire m4_3a1b_ea0_winner0 = (m4_3a1b_ea0_choose0 && m4_3a1b_ea0_bucket0_0) | (m4_3a1b_ea0_choose1 && m4_3a1b_ea0_bucket1_0) | (m4_3a1b_ea0_choose2 && m4_3a1b_ea0_bucket2_0) | (m4_3a1b_ea0_choose3 && m4_3a1b_ea0_bucket3_0);
wire m4_3a1b_ea0_winner1 = (m4_3a1b_ea0_choose0 && m4_3a1b_ea0_bucket0_1) | (m4_3a1b_ea0_choose1 && m4_3a1b_ea0_bucket1_1) | (m4_3a1b_ea0_choose2 && m4_3a1b_ea0_bucket2_1) | (m4_3a1b_ea0_choose3 && m4_3a1b_ea0_bucket3_1);
wire m4_3a1b_ea0_winner2 = (m4_3a1b_ea0_choose0 && m4_3a1b_ea0_bucket0_2) | (m4_3a1b_ea0_choose1 && m4_3a1b_ea0_bucket1_2) | (m4_3a1b_ea0_choose2 && m4_3a1b_ea0_bucket2_2) | (m4_3a1b_ea0_choose3 && m4_3a1b_ea0_bucket3_2);
wire m4_3a1b_ea0_winner3 = (m4_3a1b_ea0_choose0 && m4_3a1b_ea0_bucket0_3) | (m4_3a1b_ea0_choose1 && m4_3a1b_ea0_bucket1_3) | (m4_3a1b_ea0_choose2 && m4_3a1b_ea0_bucket2_3) | (m4_3a1b_ea0_choose3 && m4_3a1b_ea0_bucket3_3);
wire [3:0] m4_3a1b_ea0_selected_path = ({4{m4_3a1b_ea0_winner0}} & 4'b1110) | ({4{m4_3a1b_ea0_winner1 && !(m4_3a1b_ea0_winner0)}} & 4'b1101) | ({4{m4_3a1b_ea0_winner2 && !(m4_3a1b_ea0_winner0 | m4_3a1b_ea0_winner1)}} & 4'b1011) | ({4{m4_3a1b_ea0_winner3 && !(m4_3a1b_ea0_winner0 | m4_3a1b_ea0_winner1 | m4_3a1b_ea0_winner2)}} & 4'b0111);
wire [5:0] m4_3a1b_ea0_other = d4_sb_1 + m4_3a1b_ea0_offset_min;
wire m4_3a1b_ea0_v = m4_3a1b_ea0_occupied;
wire [3:0] m4_3a1b_ea0_suffix = m4_3a1b_ea0_selected_path;
wire [7:0] m4_3a1b_ea0_ra = m4_3a1b_ea0_fixed;
wire [5:0] m4_3a1b_ea0_rb = m4_3a1b_ea0_other;

// Fixed state slot 3A1B, eA=1.
wire [7:0] m4_3a1b_ea1_fixed = eq_d4_sa_3_plus1;
// Decode the bounded offset domain in parallel, then select its first occupied value.
wire m4_3a1b_ea1_bucket0_0 = eq_match_80 && eq_match_61;
wire m4_3a1b_ea1_bucket0_1 = eq_match_81 && eq_match_63;
wire m4_3a1b_ea1_bucket0_2 = eq_match_82 && eq_match_65;
wire m4_3a1b_ea1_bucket0_3 = eq_match_83 && eq_match_67;
wire m4_3a1b_ea1_has0 = m4_3a1b_ea1_bucket0_0 | m4_3a1b_ea1_bucket0_1 | m4_3a1b_ea1_bucket0_2 | m4_3a1b_ea1_bucket0_3;
wire m4_3a1b_ea1_bucket1_0 = eq_match_80 && eq_match_68;
wire m4_3a1b_ea1_bucket1_1 = eq_match_81 && eq_match_69;
wire m4_3a1b_ea1_bucket1_2 = eq_match_82 && eq_match_70;
wire m4_3a1b_ea1_bucket1_3 = eq_match_83 && eq_match_71;
wire m4_3a1b_ea1_has1 = m4_3a1b_ea1_bucket1_0 | m4_3a1b_ea1_bucket1_1 | m4_3a1b_ea1_bucket1_2 | m4_3a1b_ea1_bucket1_3;
wire m4_3a1b_ea1_bucket2_0 = eq_match_80 && eq_match_72;
wire m4_3a1b_ea1_bucket2_1 = eq_match_81 && eq_match_73;
wire m4_3a1b_ea1_bucket2_2 = eq_match_82 && eq_match_74;
wire m4_3a1b_ea1_bucket2_3 = eq_match_83 && eq_match_75;
wire m4_3a1b_ea1_has2 = m4_3a1b_ea1_bucket2_0 | m4_3a1b_ea1_bucket2_1 | m4_3a1b_ea1_bucket2_2 | m4_3a1b_ea1_bucket2_3;
wire m4_3a1b_ea1_bucket3_0 = eq_match_80 && eq_match_76;
wire m4_3a1b_ea1_bucket3_1 = eq_match_81 && eq_match_77;
wire m4_3a1b_ea1_bucket3_2 = eq_match_82 && eq_match_78;
wire m4_3a1b_ea1_bucket3_3 = eq_match_83 && eq_match_79;
wire m4_3a1b_ea1_has3 = m4_3a1b_ea1_bucket3_0 | m4_3a1b_ea1_bucket3_1 | m4_3a1b_ea1_bucket3_2 | m4_3a1b_ea1_bucket3_3;
wire m4_3a1b_ea1_choose0 = m4_3a1b_ea1_has0;
wire m4_3a1b_ea1_choose1 = m4_3a1b_ea1_has1 && !(m4_3a1b_ea1_has0);
wire m4_3a1b_ea1_choose2 = m4_3a1b_ea1_has2 && !(m4_3a1b_ea1_has0 | m4_3a1b_ea1_has1);
wire m4_3a1b_ea1_choose3 = m4_3a1b_ea1_has3 && !(m4_3a1b_ea1_has0 | m4_3a1b_ea1_has1 | m4_3a1b_ea1_has2);
wire [1:0] m4_3a1b_ea1_offset_min = ({2{m4_3a1b_ea1_choose1}} & 2'd1) | ({2{m4_3a1b_ea1_choose2}} & 2'd2) | ({2{m4_3a1b_ea1_choose3}} & 2'd3);
wire m4_3a1b_ea1_occupied = m4_3a1b_ea1_has0 | m4_3a1b_ea1_has1 | m4_3a1b_ea1_has2 | m4_3a1b_ea1_has3;
wire m4_3a1b_ea1_winner0 = (m4_3a1b_ea1_choose0 && m4_3a1b_ea1_bucket0_0) | (m4_3a1b_ea1_choose1 && m4_3a1b_ea1_bucket1_0) | (m4_3a1b_ea1_choose2 && m4_3a1b_ea1_bucket2_0) | (m4_3a1b_ea1_choose3 && m4_3a1b_ea1_bucket3_0);
wire m4_3a1b_ea1_winner1 = (m4_3a1b_ea1_choose0 && m4_3a1b_ea1_bucket0_1) | (m4_3a1b_ea1_choose1 && m4_3a1b_ea1_bucket1_1) | (m4_3a1b_ea1_choose2 && m4_3a1b_ea1_bucket2_1) | (m4_3a1b_ea1_choose3 && m4_3a1b_ea1_bucket3_1);
wire m4_3a1b_ea1_winner2 = (m4_3a1b_ea1_choose0 && m4_3a1b_ea1_bucket0_2) | (m4_3a1b_ea1_choose1 && m4_3a1b_ea1_bucket1_2) | (m4_3a1b_ea1_choose2 && m4_3a1b_ea1_bucket2_2) | (m4_3a1b_ea1_choose3 && m4_3a1b_ea1_bucket3_2);
wire m4_3a1b_ea1_winner3 = (m4_3a1b_ea1_choose0 && m4_3a1b_ea1_bucket0_3) | (m4_3a1b_ea1_choose1 && m4_3a1b_ea1_bucket1_3) | (m4_3a1b_ea1_choose2 && m4_3a1b_ea1_bucket2_3) | (m4_3a1b_ea1_choose3 && m4_3a1b_ea1_bucket3_3);
wire [3:0] m4_3a1b_ea1_selected_path = ({4{m4_3a1b_ea1_winner0}} & 4'b1110) | ({4{m4_3a1b_ea1_winner1 && !(m4_3a1b_ea1_winner0)}} & 4'b1101) | ({4{m4_3a1b_ea1_winner2 && !(m4_3a1b_ea1_winner0 | m4_3a1b_ea1_winner1)}} & 4'b1011) | ({4{m4_3a1b_ea1_winner3 && !(m4_3a1b_ea1_winner0 | m4_3a1b_ea1_winner1 | m4_3a1b_ea1_winner2)}} & 4'b0111);
wire [5:0] m4_3a1b_ea1_other = d4_sb_1 + m4_3a1b_ea1_offset_min;
wire m4_3a1b_ea1_v = m4_3a1b_ea1_occupied;
wire [3:0] m4_3a1b_ea1_suffix = m4_3a1b_ea1_selected_path;
wire [7:0] m4_3a1b_ea1_ra = m4_3a1b_ea1_fixed;
wire [5:0] m4_3a1b_ea1_rb = m4_3a1b_ea1_other;

// Fixed state slot 4A0B, eA=0.
wire m4_4a0b_ea0_v = 1'b1;
wire [3:0] m4_4a0b_ea0_suffix = 4'b1111;
wire [7:0] m4_4a0b_ea0_ra = d4_AAAA_sum;
wire [0:0] m4_4a0b_ea0_rb = 1'b0;

// Shared continuation for m4_0a4b_eb0; suffix selection is outside this tree.
wire [5:0] t_0a4b_eb0_A_dep = m4_0a4b_eb0_ra + dual_A_rev_lat[0];
wire [7:0] t_0a4b_eb0_A_issue = m4_0a4b_eb0_rb + 8'd1;
wire [7:0] t_0a4b_eb0_A_head = (oiss_ge8(t_0a4b_eb0_A_dep, t_0a4b_eb0_A_issue)) ? t_0a4b_eb0_A_dep : t_0a4b_eb0_A_issue;
wire [7:0] t_0a4b_eb0_AA_dep = t_0a4b_eb0_A_head + dual_A_rev_lat[1];
wire [8:0] t_0a4b_eb0_AAA_dep = t_0a4b_eb0_AA_dep + dual_A_rev_lat[2];
wire [8:0] t_0a4b_eb0_AAAA_dep = t_0a4b_eb0_AAA_dep + dual_A_rev_lat[3];
wire [8:0] m4_0a4b_eb0_cycle = m4_0a4b_eb0_v && (B_len == 3'd4) ? t_0a4b_eb0_AAAA_dep : 9'd511;
wire [7:0] m4_0a4b_eb0_path = {4'b1111, m4_0a4b_eb0_suffix};

// Shared continuation for m4_1a3b_eb0; suffix selection is outside this tree.
wire [6:0] t_1a3b_eb0_A_dep = m4_1a3b_eb0_ra + dual_A_rev_lat[1];
wire [7:0] t_1a3b_eb0_A_issue = m4_1a3b_eb0_rb + 8'd1;
wire [7:0] t_1a3b_eb0_A_head = (oiss_ge8(t_1a3b_eb0_A_dep, t_1a3b_eb0_A_issue)) ? t_1a3b_eb0_A_dep : t_1a3b_eb0_A_issue;
wire [7:0] t_1a3b_eb0_B_dep = m4_1a3b_eb0_rb + dual_B_rev_lat[3];
wire [5:0] t_1a3b_eb0_B_issue = m4_1a3b_eb0_ra + 6'd1;
wire [7:0] t_1a3b_eb0_B_head = (oiss_ge8(t_1a3b_eb0_B_dep, t_1a3b_eb0_B_issue)) ? t_1a3b_eb0_B_dep : t_1a3b_eb0_B_issue;
wire [7:0] t_1a3b_eb0_AA_dep = t_1a3b_eb0_A_head + dual_A_rev_lat[2];
wire [6:0] t_1a3b_eb0_AB_dep = m4_1a3b_eb0_ra + dual_A_rev_lat[1];
wire [7:0] t_1a3b_eb0_AB_issue = t_1a3b_eb0_B_head + 8'd1;
wire [7:0] t_1a3b_eb0_AB_head = (oiss_ge8(t_1a3b_eb0_AB_dep, t_1a3b_eb0_AB_issue)) ? t_1a3b_eb0_AB_dep : t_1a3b_eb0_AB_issue;
wire [7:0] t_1a3b_eb0_BA_dep = m4_1a3b_eb0_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb0_BA_issue = t_1a3b_eb0_A_head + 8'd1;
wire [7:0] t_1a3b_eb0_BA_head = (oiss_ge8(t_1a3b_eb0_BA_dep, t_1a3b_eb0_BA_issue)) ? t_1a3b_eb0_BA_dep : t_1a3b_eb0_BA_issue;
wire [7:0] t_1a3b_eb0_AAA_dep = t_1a3b_eb0_AA_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb0_AAB_dep = t_1a3b_eb0_AB_head + dual_A_rev_lat[2];
wire [7:0] t_1a3b_eb0_ABA_dep = t_1a3b_eb0_A_head + dual_A_rev_lat[2];
wire [7:0] t_1a3b_eb0_ABA_issue = t_1a3b_eb0_BA_head + 8'd1;
wire [7:0] t_1a3b_eb0_ABA_head = (oiss_ge8(t_1a3b_eb0_ABA_dep, t_1a3b_eb0_ABA_issue)) ? t_1a3b_eb0_ABA_dep : t_1a3b_eb0_ABA_issue;
wire [7:0] t_1a3b_eb0_BAA_dep = m4_1a3b_eb0_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb0_BAA_issue = t_1a3b_eb0_AA_dep + 8'd1;
wire [7:0] t_1a3b_eb0_BAA_head = (oiss_ge8(t_1a3b_eb0_BAA_dep, t_1a3b_eb0_BAA_issue)) ? t_1a3b_eb0_BAA_dep : t_1a3b_eb0_BAA_issue;
wire [8:0] t_1a3b_eb0_AAAA_dep = t_1a3b_eb0_AAA_dep + dual_A_rev_lat[4];
wire [8:0] t_1a3b_eb0_AAAB_dep = t_1a3b_eb0_AAB_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb0_AABA_dep = t_1a3b_eb0_ABA_head + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb0_ABAA_dep = t_1a3b_eb0_AA_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb0_ABAA_issue = t_1a3b_eb0_BAA_head + 8'd1;
wire [7:0] t_1a3b_eb0_ABAA_head = (oiss_ge8(t_1a3b_eb0_ABAA_dep, t_1a3b_eb0_ABAA_issue)) ? t_1a3b_eb0_ABAA_dep : t_1a3b_eb0_ABAA_issue;
wire [7:0] t_1a3b_eb0_BAAA_dep = m4_1a3b_eb0_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb0_BAAA_issue = t_1a3b_eb0_AAA_dep + 8'd1;
wire [7:0] t_1a3b_eb0_BAAA_head = (oiss_ge8(t_1a3b_eb0_BAAA_dep, t_1a3b_eb0_BAAA_issue)) ? t_1a3b_eb0_BAAA_dep : t_1a3b_eb0_BAAA_issue;
wire m4_1a3b_eb0_mode_lane3_m0_0_pick = (B_len == 3'd3);
wire [8:0] m4_1a3b_eb0_mode_lane3_m0_0_value = m4_1a3b_eb0_mode_lane3_m0_0_pick ? t_1a3b_eb0_AAAA_dep : t_1a3b_eb0_ABAA_head;
wire [3:0] m4_1a3b_eb0_mode_lane3_m0_0_path = m4_1a3b_eb0_mode_lane3_m0_0_pick ? 4'b1111 : 4'b1011;
wire m4_1a3b_eb0_tail_m0_0_pick = (oiss_ge9(t_1a3b_eb0_BAAA_head, t_1a3b_eb0_AAAB_dep));
wire [8:0] m4_1a3b_eb0_tail_m0_0_value = m4_1a3b_eb0_tail_m0_0_pick ? t_1a3b_eb0_AAAB_dep : t_1a3b_eb0_BAAA_head;
wire [3:0] m4_1a3b_eb0_tail_m0_0_path = m4_1a3b_eb0_tail_m0_0_pick ? 4'b1110 : 4'b0111;
wire m4_1a3b_eb0_tail_m0_1_pick = (B_len == 3'd4) && (oiss_ge9(m4_1a3b_eb0_mode_lane3_m0_0_value, t_1a3b_eb0_AABA_dep));
wire [8:0] m4_1a3b_eb0_tail_m0_1_value = m4_1a3b_eb0_tail_m0_1_pick ? t_1a3b_eb0_AABA_dep : m4_1a3b_eb0_mode_lane3_m0_0_value;
wire [3:0] m4_1a3b_eb0_tail_m0_1_path = m4_1a3b_eb0_tail_m0_1_pick ? 4'b1101 : m4_1a3b_eb0_mode_lane3_m0_0_path;
wire m4_1a3b_eb0_tail_m1_0_pick = (B_len == 3'd4) && (oiss_ge9(m4_1a3b_eb0_tail_m0_1_value, m4_1a3b_eb0_tail_m0_0_value));
wire [8:0] m4_1a3b_eb0_tail_m1_0_value = m4_1a3b_eb0_tail_m1_0_pick ? m4_1a3b_eb0_tail_m0_0_value : m4_1a3b_eb0_tail_m0_1_value;
wire [3:0] m4_1a3b_eb0_tail_m1_0_path = m4_1a3b_eb0_tail_m1_0_pick ? m4_1a3b_eb0_tail_m0_0_path : m4_1a3b_eb0_tail_m0_1_path;
wire [8:0] m4_1a3b_eb0_cycle = m4_1a3b_eb0_v && (B_len == 3'd3 || B_len == 3'd4) ? m4_1a3b_eb0_tail_m1_0_value : 9'd511;
wire [7:0] m4_1a3b_eb0_path = {m4_1a3b_eb0_tail_m1_0_path, m4_1a3b_eb0_suffix};

// Shared continuation for m4_1a3b_eb1; suffix selection is outside this tree.
wire [6:0] t_1a3b_eb1_A_dep = m4_1a3b_eb1_ra + dual_A_rev_lat[1];
wire [7:0] t_1a3b_eb1_A_issue = m4_1a3b_eb1_rb + 8'd1;
wire [7:0] t_1a3b_eb1_A_head = (oiss_ge8(t_1a3b_eb1_A_dep, t_1a3b_eb1_A_issue)) ? t_1a3b_eb1_A_dep : t_1a3b_eb1_A_issue;
wire [7:0] t_1a3b_eb1_B_dep = m4_1a3b_eb1_rb + dual_B_rev_lat[3];
wire [5:0] t_1a3b_eb1_B_issue = m4_1a3b_eb1_ra + 6'd1;
wire [7:0] t_1a3b_eb1_B_head = (oiss_ge8(t_1a3b_eb1_B_dep, t_1a3b_eb1_B_issue)) ? t_1a3b_eb1_B_dep : t_1a3b_eb1_B_issue;
wire [7:0] t_1a3b_eb1_AA_dep = t_1a3b_eb1_A_head + dual_A_rev_lat[2];
wire [6:0] t_1a3b_eb1_AB_dep = m4_1a3b_eb1_ra + dual_A_rev_lat[1];
wire [7:0] t_1a3b_eb1_AB_issue = t_1a3b_eb1_B_head + 8'd1;
wire [7:0] t_1a3b_eb1_AB_head = (oiss_ge8(t_1a3b_eb1_AB_dep, t_1a3b_eb1_AB_issue)) ? t_1a3b_eb1_AB_dep : t_1a3b_eb1_AB_issue;
wire [7:0] t_1a3b_eb1_BA_dep = m4_1a3b_eb1_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb1_BA_issue = t_1a3b_eb1_A_head + 8'd1;
wire [7:0] t_1a3b_eb1_BA_head = (oiss_ge8(t_1a3b_eb1_BA_dep, t_1a3b_eb1_BA_issue)) ? t_1a3b_eb1_BA_dep : t_1a3b_eb1_BA_issue;
wire [7:0] t_1a3b_eb1_AAA_dep = t_1a3b_eb1_AA_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb1_AAB_dep = t_1a3b_eb1_AB_head + dual_A_rev_lat[2];
wire [7:0] t_1a3b_eb1_ABA_dep = t_1a3b_eb1_A_head + dual_A_rev_lat[2];
wire [7:0] t_1a3b_eb1_ABA_issue = t_1a3b_eb1_BA_head + 8'd1;
wire [7:0] t_1a3b_eb1_ABA_head = (oiss_ge8(t_1a3b_eb1_ABA_dep, t_1a3b_eb1_ABA_issue)) ? t_1a3b_eb1_ABA_dep : t_1a3b_eb1_ABA_issue;
wire [7:0] t_1a3b_eb1_BAA_dep = m4_1a3b_eb1_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb1_BAA_issue = t_1a3b_eb1_AA_dep + 8'd1;
wire [7:0] t_1a3b_eb1_BAA_head = (oiss_ge8(t_1a3b_eb1_BAA_dep, t_1a3b_eb1_BAA_issue)) ? t_1a3b_eb1_BAA_dep : t_1a3b_eb1_BAA_issue;
wire [8:0] t_1a3b_eb1_AAAA_dep = t_1a3b_eb1_AAA_dep + dual_A_rev_lat[4];
wire [8:0] t_1a3b_eb1_AAAB_dep = t_1a3b_eb1_AAB_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb1_AABA_dep = t_1a3b_eb1_ABA_head + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb1_ABAA_dep = t_1a3b_eb1_AA_dep + dual_A_rev_lat[3];
wire [7:0] t_1a3b_eb1_ABAA_issue = t_1a3b_eb1_BAA_head + 8'd1;
wire [7:0] t_1a3b_eb1_ABAA_head = (oiss_ge8(t_1a3b_eb1_ABAA_dep, t_1a3b_eb1_ABAA_issue)) ? t_1a3b_eb1_ABAA_dep : t_1a3b_eb1_ABAA_issue;
wire [7:0] t_1a3b_eb1_BAAA_dep = m4_1a3b_eb1_rb + dual_B_rev_lat[3];
wire [7:0] t_1a3b_eb1_BAAA_issue = t_1a3b_eb1_AAA_dep + 8'd1;
wire [7:0] t_1a3b_eb1_BAAA_head = (oiss_ge8(t_1a3b_eb1_BAAA_dep, t_1a3b_eb1_BAAA_issue)) ? t_1a3b_eb1_BAAA_dep : t_1a3b_eb1_BAAA_issue;
wire m4_1a3b_eb1_mode_lane3_m0_0_pick = (B_len == 3'd3);
wire [8:0] m4_1a3b_eb1_mode_lane3_m0_0_value = m4_1a3b_eb1_mode_lane3_m0_0_pick ? t_1a3b_eb1_AAAA_dep : t_1a3b_eb1_ABAA_head;
wire [3:0] m4_1a3b_eb1_mode_lane3_m0_0_path = m4_1a3b_eb1_mode_lane3_m0_0_pick ? 4'b1111 : 4'b1011;
wire m4_1a3b_eb1_tail_m0_0_pick = (oiss_ge9(t_1a3b_eb1_BAAA_head, t_1a3b_eb1_AAAB_dep));
wire [8:0] m4_1a3b_eb1_tail_m0_0_value = m4_1a3b_eb1_tail_m0_0_pick ? t_1a3b_eb1_AAAB_dep : t_1a3b_eb1_BAAA_head;
wire [3:0] m4_1a3b_eb1_tail_m0_0_path = m4_1a3b_eb1_tail_m0_0_pick ? 4'b1110 : 4'b0111;
wire m4_1a3b_eb1_tail_m0_1_pick = (B_len == 3'd4) && (oiss_ge9(m4_1a3b_eb1_mode_lane3_m0_0_value, t_1a3b_eb1_AABA_dep));
wire [8:0] m4_1a3b_eb1_tail_m0_1_value = m4_1a3b_eb1_tail_m0_1_pick ? t_1a3b_eb1_AABA_dep : m4_1a3b_eb1_mode_lane3_m0_0_value;
wire [3:0] m4_1a3b_eb1_tail_m0_1_path = m4_1a3b_eb1_tail_m0_1_pick ? 4'b1101 : m4_1a3b_eb1_mode_lane3_m0_0_path;
wire m4_1a3b_eb1_tail_m1_0_pick = (B_len == 3'd4) && (oiss_ge9(m4_1a3b_eb1_tail_m0_1_value, m4_1a3b_eb1_tail_m0_0_value));
wire [8:0] m4_1a3b_eb1_tail_m1_0_value = m4_1a3b_eb1_tail_m1_0_pick ? m4_1a3b_eb1_tail_m0_0_value : m4_1a3b_eb1_tail_m0_1_value;
wire [3:0] m4_1a3b_eb1_tail_m1_0_path = m4_1a3b_eb1_tail_m1_0_pick ? m4_1a3b_eb1_tail_m0_0_path : m4_1a3b_eb1_tail_m0_1_path;
wire [8:0] m4_1a3b_eb1_cycle = m4_1a3b_eb1_v && (B_len == 3'd3 || B_len == 3'd4) ? m4_1a3b_eb1_tail_m1_0_value : 9'd511;
wire [7:0] m4_1a3b_eb1_path = {m4_1a3b_eb1_tail_m1_0_path, m4_1a3b_eb1_suffix};

// Shared continuation for m4_2a2b_ea0; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea0_A_dep = m4_2a2b_ea0_ra + dual_A_rev_lat[2];
wire [6:0] t_2a2b_ea0_A_issue = m4_2a2b_ea0_rb + 7'd1;
wire [7:0] t_2a2b_ea0_A_head = (oiss_ge8(t_2a2b_ea0_A_dep, t_2a2b_ea0_A_issue)) ? t_2a2b_ea0_A_dep : t_2a2b_ea0_A_issue;
wire [7:0] t_2a2b_ea0_B_dep = m4_2a2b_ea0_rb + dual_B_rev_lat[2];
wire [6:0] t_2a2b_ea0_B_issue = m4_2a2b_ea0_ra + 7'd1;
wire [7:0] t_2a2b_ea0_B_head = (oiss_ge8(t_2a2b_ea0_B_dep, t_2a2b_ea0_B_issue)) ? t_2a2b_ea0_B_dep : t_2a2b_ea0_B_issue;
wire [7:0] t_2a2b_ea0_AA_dep = t_2a2b_ea0_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_AB_dep = m4_2a2b_ea0_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea0_AB_issue = t_2a2b_ea0_B_head + 8'd1;
wire [7:0] t_2a2b_ea0_AB_head = (oiss_ge8(t_2a2b_ea0_AB_dep, t_2a2b_ea0_AB_issue)) ? t_2a2b_ea0_AB_dep : t_2a2b_ea0_AB_issue;
wire [7:0] t_2a2b_ea0_BA_dep = m4_2a2b_ea0_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea0_BA_issue = t_2a2b_ea0_A_head + 8'd1;
wire [7:0] t_2a2b_ea0_BA_head = (oiss_ge8(t_2a2b_ea0_BA_dep, t_2a2b_ea0_BA_issue)) ? t_2a2b_ea0_BA_dep : t_2a2b_ea0_BA_issue;
wire [7:0] t_2a2b_ea0_BB_dep = t_2a2b_ea0_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea0_AAA_dep = t_2a2b_ea0_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea0_AAB_dep = t_2a2b_ea0_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_ABA_dep = t_2a2b_ea0_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_ABA_issue = t_2a2b_ea0_BA_head + 8'd1;
wire [7:0] t_2a2b_ea0_ABA_head = (oiss_ge8(t_2a2b_ea0_ABA_dep, t_2a2b_ea0_ABA_issue)) ? t_2a2b_ea0_ABA_dep : t_2a2b_ea0_ABA_issue;
wire [7:0] t_2a2b_ea0_ABB_dep = m4_2a2b_ea0_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea0_ABB_issue = t_2a2b_ea0_BB_dep + 8'd1;
wire [7:0] t_2a2b_ea0_ABB_head = (oiss_ge8(t_2a2b_ea0_ABB_dep, t_2a2b_ea0_ABB_issue)) ? t_2a2b_ea0_ABB_dep : t_2a2b_ea0_ABB_issue;
wire [7:0] t_2a2b_ea0_BAA_dep = m4_2a2b_ea0_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea0_BAA_issue = t_2a2b_ea0_AA_dep + 8'd1;
wire [7:0] t_2a2b_ea0_BAA_head = (oiss_ge8(t_2a2b_ea0_BAA_dep, t_2a2b_ea0_BAA_issue)) ? t_2a2b_ea0_BAA_dep : t_2a2b_ea0_BAA_issue;
wire [7:0] t_2a2b_ea0_BAB_dep = t_2a2b_ea0_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea0_BAB_issue = t_2a2b_ea0_AB_head + 8'd1;
wire [7:0] t_2a2b_ea0_BAB_head = (oiss_ge8(t_2a2b_ea0_BAB_dep, t_2a2b_ea0_BAB_issue)) ? t_2a2b_ea0_BAB_dep : t_2a2b_ea0_BAB_issue;
wire [7:0] t_2a2b_ea0_BBA_dep = t_2a2b_ea0_BA_head + dual_B_rev_lat[3];
wire [8:0] t_2a2b_ea0_AAAA_dep = t_2a2b_ea0_AAA_dep + dual_A_rev_lat[5];
wire [7:0] t_2a2b_ea0_AAAB_dep = t_2a2b_ea0_AAB_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea0_AABA_dep = t_2a2b_ea0_ABA_head + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea0_AABB_dep = t_2a2b_ea0_ABB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_ABAA_dep = t_2a2b_ea0_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea0_ABAA_issue = t_2a2b_ea0_BAA_head + 8'd1;
wire [7:0] t_2a2b_ea0_ABAA_head = (oiss_ge8(t_2a2b_ea0_ABAA_dep, t_2a2b_ea0_ABAA_issue)) ? t_2a2b_ea0_ABAA_dep : t_2a2b_ea0_ABAA_issue;
wire [7:0] t_2a2b_ea0_ABAB_dep = t_2a2b_ea0_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_ABAB_issue = t_2a2b_ea0_BAB_head + 8'd1;
wire [7:0] t_2a2b_ea0_ABAB_head = (oiss_ge8(t_2a2b_ea0_ABAB_dep, t_2a2b_ea0_ABAB_issue)) ? t_2a2b_ea0_ABAB_dep : t_2a2b_ea0_ABAB_issue;
wire [7:0] t_2a2b_ea0_ABBA_dep = t_2a2b_ea0_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea0_ABBA_issue = t_2a2b_ea0_BBA_dep + 8'd1;
wire [7:0] t_2a2b_ea0_ABBA_head = (oiss_ge8(t_2a2b_ea0_ABBA_dep, t_2a2b_ea0_ABBA_issue)) ? t_2a2b_ea0_ABBA_dep : t_2a2b_ea0_ABBA_issue;
wire [7:0] t_2a2b_ea0_BAAA_dep = m4_2a2b_ea0_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea0_BAAA_issue = t_2a2b_ea0_AAA_dep + 8'd1;
wire [7:0] t_2a2b_ea0_BAAA_head = (oiss_ge8(t_2a2b_ea0_BAAA_dep, t_2a2b_ea0_BAAA_issue)) ? t_2a2b_ea0_BAAA_dep : t_2a2b_ea0_BAAA_issue;
wire [7:0] t_2a2b_ea0_BAAB_dep = t_2a2b_ea0_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea0_BAAB_issue = t_2a2b_ea0_AAB_dep + 8'd1;
wire [7:0] t_2a2b_ea0_BAAB_head = (oiss_ge8(t_2a2b_ea0_BAAB_dep, t_2a2b_ea0_BAAB_issue)) ? t_2a2b_ea0_BAAB_dep : t_2a2b_ea0_BAAB_issue;
wire [7:0] t_2a2b_ea0_BABA_dep = t_2a2b_ea0_BA_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea0_BABA_issue = t_2a2b_ea0_ABA_head + 8'd1;
wire [7:0] t_2a2b_ea0_BABA_head = (oiss_ge8(t_2a2b_ea0_BABA_dep, t_2a2b_ea0_BABA_issue)) ? t_2a2b_ea0_BABA_dep : t_2a2b_ea0_BABA_issue;
wire [7:0] t_2a2b_ea0_BBAA_dep = t_2a2b_ea0_BAA_head + dual_B_rev_lat[3];
wire m4_2a2b_ea0_mode_lane2_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea0_mode_lane2_m0_0_value = m4_2a2b_ea0_mode_lane2_m0_0_pick ? t_2a2b_ea0_AAAB_dep : t_2a2b_ea0_ABBA_head;
wire [3:0] m4_2a2b_ea0_mode_lane2_m0_0_path = m4_2a2b_ea0_mode_lane2_m0_0_pick ? 4'b1110 : 4'b1001;
wire m4_2a2b_ea0_mode_lane3_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea0_mode_lane3_m0_0_value = m4_2a2b_ea0_mode_lane3_m0_0_pick ? t_2a2b_ea0_BAAA_head : t_2a2b_ea0_BAAB_head;
wire [3:0] m4_2a2b_ea0_mode_lane3_m0_0_path = m4_2a2b_ea0_mode_lane3_m0_0_pick ? 4'b0111 : 4'b0110;
wire m4_2a2b_ea0_mode_lane4_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea0_mode_lane4_m0_0_value = m4_2a2b_ea0_mode_lane4_m0_0_pick ? t_2a2b_ea0_AABA_dep : t_2a2b_ea0_ABAB_head;
wire [3:0] m4_2a2b_ea0_mode_lane4_m0_0_path = m4_2a2b_ea0_mode_lane4_m0_0_pick ? 4'b1101 : 4'b1010;
wire m4_2a2b_ea0_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_2a2b_ea0_mode_lane5_m0_0_value = m4_2a2b_ea0_mode_lane5_m0_0_pick ? t_2a2b_ea0_AAAA_dep : t_2a2b_ea0_ABAA_head;
wire [3:0] m4_2a2b_ea0_mode_lane5_m0_0_path = m4_2a2b_ea0_mode_lane5_m0_0_pick ? 4'b1111 : 4'b1011;
wire m4_2a2b_ea0_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_2a2b_ea0_mode_lane5_m1_0_value = m4_2a2b_ea0_mode_lane5_m1_0_pick ? m4_2a2b_ea0_mode_lane5_m0_0_value : t_2a2b_ea0_BABA_head;
wire [3:0] m4_2a2b_ea0_mode_lane5_m1_0_path = m4_2a2b_ea0_mode_lane5_m1_0_pick ? m4_2a2b_ea0_mode_lane5_m0_0_path : 4'b0101;
wire m4_2a2b_ea0_tail_m0_0_pick = (oiss_ge8(t_2a2b_ea0_BBAA_dep, t_2a2b_ea0_AABB_dep));
wire [7:0] m4_2a2b_ea0_tail_m0_0_value = m4_2a2b_ea0_tail_m0_0_pick ? t_2a2b_ea0_AABB_dep : t_2a2b_ea0_BBAA_dep;
wire [3:0] m4_2a2b_ea0_tail_m0_0_path = m4_2a2b_ea0_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_2a2b_ea0_tail_m0_1_pick = (oiss_ge8(m4_2a2b_ea0_mode_lane3_m0_0_value, m4_2a2b_ea0_mode_lane2_m0_0_value));
wire [7:0] m4_2a2b_ea0_tail_m0_1_value = m4_2a2b_ea0_tail_m0_1_pick ? m4_2a2b_ea0_mode_lane2_m0_0_value : m4_2a2b_ea0_mode_lane3_m0_0_value;
wire [3:0] m4_2a2b_ea0_tail_m0_1_path = m4_2a2b_ea0_tail_m0_1_pick ? m4_2a2b_ea0_mode_lane2_m0_0_path : m4_2a2b_ea0_mode_lane3_m0_0_path;
wire m4_2a2b_ea0_tail_m0_2_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea0_mode_lane5_m1_0_value, m4_2a2b_ea0_mode_lane4_m0_0_value));
wire [8:0] m4_2a2b_ea0_tail_m0_2_value = m4_2a2b_ea0_tail_m0_2_pick ? m4_2a2b_ea0_mode_lane4_m0_0_value : m4_2a2b_ea0_mode_lane5_m1_0_value;
wire [3:0] m4_2a2b_ea0_tail_m0_2_path = m4_2a2b_ea0_tail_m0_2_pick ? m4_2a2b_ea0_mode_lane4_m0_0_path : m4_2a2b_ea0_mode_lane5_m1_0_path;
wire m4_2a2b_ea0_tail_m1_0_pick = (B_len == 3'd4) && (oiss_ge8(m4_2a2b_ea0_tail_m0_1_value, m4_2a2b_ea0_tail_m0_0_value));
wire [7:0] m4_2a2b_ea0_tail_m1_0_value = m4_2a2b_ea0_tail_m1_0_pick ? m4_2a2b_ea0_tail_m0_0_value : m4_2a2b_ea0_tail_m0_1_value;
wire [3:0] m4_2a2b_ea0_tail_m1_0_path = m4_2a2b_ea0_tail_m1_0_pick ? m4_2a2b_ea0_tail_m0_0_path : m4_2a2b_ea0_tail_m0_1_path;
wire m4_2a2b_ea0_tail_m2_0_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea0_tail_m0_2_value, m4_2a2b_ea0_tail_m1_0_value));
wire [8:0] m4_2a2b_ea0_tail_m2_0_value = m4_2a2b_ea0_tail_m2_0_pick ? m4_2a2b_ea0_tail_m1_0_value : m4_2a2b_ea0_tail_m0_2_value;
wire [3:0] m4_2a2b_ea0_tail_m2_0_path = m4_2a2b_ea0_tail_m2_0_pick ? m4_2a2b_ea0_tail_m1_0_path : m4_2a2b_ea0_tail_m0_2_path;
wire [8:0] m4_2a2b_ea0_cycle = m4_2a2b_ea0_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_2a2b_ea0_tail_m2_0_value : 9'd511;
wire [7:0] m4_2a2b_ea0_path = {m4_2a2b_ea0_tail_m2_0_path, m4_2a2b_ea0_suffix};

// Shared continuation for m4_2a2b_ea1; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea1_A_dep = m4_2a2b_ea1_ra + dual_A_rev_lat[2];
wire [6:0] t_2a2b_ea1_A_issue = m4_2a2b_ea1_rb + 7'd1;
wire [7:0] t_2a2b_ea1_A_head = (oiss_ge8(t_2a2b_ea1_A_dep, t_2a2b_ea1_A_issue)) ? t_2a2b_ea1_A_dep : t_2a2b_ea1_A_issue;
wire [7:0] t_2a2b_ea1_B_dep = m4_2a2b_ea1_rb + dual_B_rev_lat[2];
wire [6:0] t_2a2b_ea1_B_issue = m4_2a2b_ea1_ra + 7'd1;
wire [7:0] t_2a2b_ea1_B_head = (oiss_ge8(t_2a2b_ea1_B_dep, t_2a2b_ea1_B_issue)) ? t_2a2b_ea1_B_dep : t_2a2b_ea1_B_issue;
wire [7:0] t_2a2b_ea1_AA_dep = t_2a2b_ea1_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_AB_dep = m4_2a2b_ea1_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea1_AB_issue = t_2a2b_ea1_B_head + 8'd1;
wire [7:0] t_2a2b_ea1_AB_head = (oiss_ge8(t_2a2b_ea1_AB_dep, t_2a2b_ea1_AB_issue)) ? t_2a2b_ea1_AB_dep : t_2a2b_ea1_AB_issue;
wire [7:0] t_2a2b_ea1_BA_dep = m4_2a2b_ea1_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea1_BA_issue = t_2a2b_ea1_A_head + 8'd1;
wire [7:0] t_2a2b_ea1_BA_head = (oiss_ge8(t_2a2b_ea1_BA_dep, t_2a2b_ea1_BA_issue)) ? t_2a2b_ea1_BA_dep : t_2a2b_ea1_BA_issue;
wire [7:0] t_2a2b_ea1_BB_dep = t_2a2b_ea1_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea1_AAA_dep = t_2a2b_ea1_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea1_AAB_dep = t_2a2b_ea1_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_ABA_dep = t_2a2b_ea1_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_ABA_issue = t_2a2b_ea1_BA_head + 8'd1;
wire [7:0] t_2a2b_ea1_ABA_head = (oiss_ge8(t_2a2b_ea1_ABA_dep, t_2a2b_ea1_ABA_issue)) ? t_2a2b_ea1_ABA_dep : t_2a2b_ea1_ABA_issue;
wire [7:0] t_2a2b_ea1_ABB_dep = m4_2a2b_ea1_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea1_ABB_issue = t_2a2b_ea1_BB_dep + 8'd1;
wire [7:0] t_2a2b_ea1_ABB_head = (oiss_ge8(t_2a2b_ea1_ABB_dep, t_2a2b_ea1_ABB_issue)) ? t_2a2b_ea1_ABB_dep : t_2a2b_ea1_ABB_issue;
wire [7:0] t_2a2b_ea1_BAA_dep = m4_2a2b_ea1_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea1_BAA_issue = t_2a2b_ea1_AA_dep + 8'd1;
wire [7:0] t_2a2b_ea1_BAA_head = (oiss_ge8(t_2a2b_ea1_BAA_dep, t_2a2b_ea1_BAA_issue)) ? t_2a2b_ea1_BAA_dep : t_2a2b_ea1_BAA_issue;
wire [7:0] t_2a2b_ea1_BAB_dep = t_2a2b_ea1_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea1_BAB_issue = t_2a2b_ea1_AB_head + 8'd1;
wire [7:0] t_2a2b_ea1_BAB_head = (oiss_ge8(t_2a2b_ea1_BAB_dep, t_2a2b_ea1_BAB_issue)) ? t_2a2b_ea1_BAB_dep : t_2a2b_ea1_BAB_issue;
wire [7:0] t_2a2b_ea1_BBA_dep = t_2a2b_ea1_BA_head + dual_B_rev_lat[3];
wire [8:0] t_2a2b_ea1_AAAA_dep = t_2a2b_ea1_AAA_dep + dual_A_rev_lat[5];
wire [7:0] t_2a2b_ea1_AAAB_dep = t_2a2b_ea1_AAB_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea1_AABA_dep = t_2a2b_ea1_ABA_head + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea1_AABB_dep = t_2a2b_ea1_ABB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_ABAA_dep = t_2a2b_ea1_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea1_ABAA_issue = t_2a2b_ea1_BAA_head + 8'd1;
wire [7:0] t_2a2b_ea1_ABAA_head = (oiss_ge8(t_2a2b_ea1_ABAA_dep, t_2a2b_ea1_ABAA_issue)) ? t_2a2b_ea1_ABAA_dep : t_2a2b_ea1_ABAA_issue;
wire [7:0] t_2a2b_ea1_ABAB_dep = t_2a2b_ea1_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_ABAB_issue = t_2a2b_ea1_BAB_head + 8'd1;
wire [7:0] t_2a2b_ea1_ABAB_head = (oiss_ge8(t_2a2b_ea1_ABAB_dep, t_2a2b_ea1_ABAB_issue)) ? t_2a2b_ea1_ABAB_dep : t_2a2b_ea1_ABAB_issue;
wire [7:0] t_2a2b_ea1_ABBA_dep = t_2a2b_ea1_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea1_ABBA_issue = t_2a2b_ea1_BBA_dep + 8'd1;
wire [7:0] t_2a2b_ea1_ABBA_head = (oiss_ge8(t_2a2b_ea1_ABBA_dep, t_2a2b_ea1_ABBA_issue)) ? t_2a2b_ea1_ABBA_dep : t_2a2b_ea1_ABBA_issue;
wire [7:0] t_2a2b_ea1_BAAA_dep = m4_2a2b_ea1_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea1_BAAA_issue = t_2a2b_ea1_AAA_dep + 8'd1;
wire [7:0] t_2a2b_ea1_BAAA_head = (oiss_ge8(t_2a2b_ea1_BAAA_dep, t_2a2b_ea1_BAAA_issue)) ? t_2a2b_ea1_BAAA_dep : t_2a2b_ea1_BAAA_issue;
wire [7:0] t_2a2b_ea1_BAAB_dep = t_2a2b_ea1_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea1_BAAB_issue = t_2a2b_ea1_AAB_dep + 8'd1;
wire [7:0] t_2a2b_ea1_BAAB_head = (oiss_ge8(t_2a2b_ea1_BAAB_dep, t_2a2b_ea1_BAAB_issue)) ? t_2a2b_ea1_BAAB_dep : t_2a2b_ea1_BAAB_issue;
wire [7:0] t_2a2b_ea1_BABA_dep = t_2a2b_ea1_BA_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea1_BABA_issue = t_2a2b_ea1_ABA_head + 8'd1;
wire [7:0] t_2a2b_ea1_BABA_head = (oiss_ge8(t_2a2b_ea1_BABA_dep, t_2a2b_ea1_BABA_issue)) ? t_2a2b_ea1_BABA_dep : t_2a2b_ea1_BABA_issue;
wire [7:0] t_2a2b_ea1_BBAA_dep = t_2a2b_ea1_BAA_head + dual_B_rev_lat[3];
wire m4_2a2b_ea1_mode_lane2_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea1_mode_lane2_m0_0_value = m4_2a2b_ea1_mode_lane2_m0_0_pick ? t_2a2b_ea1_AAAB_dep : t_2a2b_ea1_ABBA_head;
wire [3:0] m4_2a2b_ea1_mode_lane2_m0_0_path = m4_2a2b_ea1_mode_lane2_m0_0_pick ? 4'b1110 : 4'b1001;
wire m4_2a2b_ea1_mode_lane3_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea1_mode_lane3_m0_0_value = m4_2a2b_ea1_mode_lane3_m0_0_pick ? t_2a2b_ea1_BAAA_head : t_2a2b_ea1_BAAB_head;
wire [3:0] m4_2a2b_ea1_mode_lane3_m0_0_path = m4_2a2b_ea1_mode_lane3_m0_0_pick ? 4'b0111 : 4'b0110;
wire m4_2a2b_ea1_mode_lane4_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea1_mode_lane4_m0_0_value = m4_2a2b_ea1_mode_lane4_m0_0_pick ? t_2a2b_ea1_AABA_dep : t_2a2b_ea1_ABAB_head;
wire [3:0] m4_2a2b_ea1_mode_lane4_m0_0_path = m4_2a2b_ea1_mode_lane4_m0_0_pick ? 4'b1101 : 4'b1010;
wire m4_2a2b_ea1_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_2a2b_ea1_mode_lane5_m0_0_value = m4_2a2b_ea1_mode_lane5_m0_0_pick ? t_2a2b_ea1_AAAA_dep : t_2a2b_ea1_ABAA_head;
wire [3:0] m4_2a2b_ea1_mode_lane5_m0_0_path = m4_2a2b_ea1_mode_lane5_m0_0_pick ? 4'b1111 : 4'b1011;
wire m4_2a2b_ea1_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_2a2b_ea1_mode_lane5_m1_0_value = m4_2a2b_ea1_mode_lane5_m1_0_pick ? m4_2a2b_ea1_mode_lane5_m0_0_value : t_2a2b_ea1_BABA_head;
wire [3:0] m4_2a2b_ea1_mode_lane5_m1_0_path = m4_2a2b_ea1_mode_lane5_m1_0_pick ? m4_2a2b_ea1_mode_lane5_m0_0_path : 4'b0101;
wire m4_2a2b_ea1_tail_m0_0_pick = (oiss_ge8(t_2a2b_ea1_BBAA_dep, t_2a2b_ea1_AABB_dep));
wire [7:0] m4_2a2b_ea1_tail_m0_0_value = m4_2a2b_ea1_tail_m0_0_pick ? t_2a2b_ea1_AABB_dep : t_2a2b_ea1_BBAA_dep;
wire [3:0] m4_2a2b_ea1_tail_m0_0_path = m4_2a2b_ea1_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_2a2b_ea1_tail_m0_1_pick = (oiss_ge8(m4_2a2b_ea1_mode_lane3_m0_0_value, m4_2a2b_ea1_mode_lane2_m0_0_value));
wire [7:0] m4_2a2b_ea1_tail_m0_1_value = m4_2a2b_ea1_tail_m0_1_pick ? m4_2a2b_ea1_mode_lane2_m0_0_value : m4_2a2b_ea1_mode_lane3_m0_0_value;
wire [3:0] m4_2a2b_ea1_tail_m0_1_path = m4_2a2b_ea1_tail_m0_1_pick ? m4_2a2b_ea1_mode_lane2_m0_0_path : m4_2a2b_ea1_mode_lane3_m0_0_path;
wire m4_2a2b_ea1_tail_m0_2_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea1_mode_lane5_m1_0_value, m4_2a2b_ea1_mode_lane4_m0_0_value));
wire [8:0] m4_2a2b_ea1_tail_m0_2_value = m4_2a2b_ea1_tail_m0_2_pick ? m4_2a2b_ea1_mode_lane4_m0_0_value : m4_2a2b_ea1_mode_lane5_m1_0_value;
wire [3:0] m4_2a2b_ea1_tail_m0_2_path = m4_2a2b_ea1_tail_m0_2_pick ? m4_2a2b_ea1_mode_lane4_m0_0_path : m4_2a2b_ea1_mode_lane5_m1_0_path;
wire m4_2a2b_ea1_tail_m1_0_pick = (B_len == 3'd4) && (oiss_ge8(m4_2a2b_ea1_tail_m0_1_value, m4_2a2b_ea1_tail_m0_0_value));
wire [7:0] m4_2a2b_ea1_tail_m1_0_value = m4_2a2b_ea1_tail_m1_0_pick ? m4_2a2b_ea1_tail_m0_0_value : m4_2a2b_ea1_tail_m0_1_value;
wire [3:0] m4_2a2b_ea1_tail_m1_0_path = m4_2a2b_ea1_tail_m1_0_pick ? m4_2a2b_ea1_tail_m0_0_path : m4_2a2b_ea1_tail_m0_1_path;
wire m4_2a2b_ea1_tail_m2_0_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea1_tail_m0_2_value, m4_2a2b_ea1_tail_m1_0_value));
wire [8:0] m4_2a2b_ea1_tail_m2_0_value = m4_2a2b_ea1_tail_m2_0_pick ? m4_2a2b_ea1_tail_m1_0_value : m4_2a2b_ea1_tail_m0_2_value;
wire [3:0] m4_2a2b_ea1_tail_m2_0_path = m4_2a2b_ea1_tail_m2_0_pick ? m4_2a2b_ea1_tail_m1_0_path : m4_2a2b_ea1_tail_m0_2_path;
wire [8:0] m4_2a2b_ea1_cycle = m4_2a2b_ea1_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_2a2b_ea1_tail_m2_0_value : 9'd511;
wire [7:0] m4_2a2b_ea1_path = {m4_2a2b_ea1_tail_m2_0_path, m4_2a2b_ea1_suffix};

// Shared continuation for m4_2a2b_ea2; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea2_A_dep = m4_2a2b_ea2_ra + dual_A_rev_lat[2];
wire [6:0] t_2a2b_ea2_A_issue = m4_2a2b_ea2_rb + 7'd1;
wire [7:0] t_2a2b_ea2_A_head = (oiss_ge8(t_2a2b_ea2_A_dep, t_2a2b_ea2_A_issue)) ? t_2a2b_ea2_A_dep : t_2a2b_ea2_A_issue;
wire [7:0] t_2a2b_ea2_B_dep = m4_2a2b_ea2_rb + dual_B_rev_lat[2];
wire [6:0] t_2a2b_ea2_B_issue = m4_2a2b_ea2_ra + 7'd1;
wire [7:0] t_2a2b_ea2_B_head = (oiss_ge8(t_2a2b_ea2_B_dep, t_2a2b_ea2_B_issue)) ? t_2a2b_ea2_B_dep : t_2a2b_ea2_B_issue;
wire [7:0] t_2a2b_ea2_AA_dep = t_2a2b_ea2_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_AB_dep = m4_2a2b_ea2_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea2_AB_issue = t_2a2b_ea2_B_head + 8'd1;
wire [7:0] t_2a2b_ea2_AB_head = (oiss_ge8(t_2a2b_ea2_AB_dep, t_2a2b_ea2_AB_issue)) ? t_2a2b_ea2_AB_dep : t_2a2b_ea2_AB_issue;
wire [7:0] t_2a2b_ea2_BA_dep = m4_2a2b_ea2_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea2_BA_issue = t_2a2b_ea2_A_head + 8'd1;
wire [7:0] t_2a2b_ea2_BA_head = (oiss_ge8(t_2a2b_ea2_BA_dep, t_2a2b_ea2_BA_issue)) ? t_2a2b_ea2_BA_dep : t_2a2b_ea2_BA_issue;
wire [7:0] t_2a2b_ea2_BB_dep = t_2a2b_ea2_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea2_AAA_dep = t_2a2b_ea2_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea2_AAB_dep = t_2a2b_ea2_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_ABA_dep = t_2a2b_ea2_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_ABA_issue = t_2a2b_ea2_BA_head + 8'd1;
wire [7:0] t_2a2b_ea2_ABA_head = (oiss_ge8(t_2a2b_ea2_ABA_dep, t_2a2b_ea2_ABA_issue)) ? t_2a2b_ea2_ABA_dep : t_2a2b_ea2_ABA_issue;
wire [7:0] t_2a2b_ea2_ABB_dep = m4_2a2b_ea2_ra + dual_A_rev_lat[2];
wire [7:0] t_2a2b_ea2_ABB_issue = t_2a2b_ea2_BB_dep + 8'd1;
wire [7:0] t_2a2b_ea2_ABB_head = (oiss_ge8(t_2a2b_ea2_ABB_dep, t_2a2b_ea2_ABB_issue)) ? t_2a2b_ea2_ABB_dep : t_2a2b_ea2_ABB_issue;
wire [7:0] t_2a2b_ea2_BAA_dep = m4_2a2b_ea2_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea2_BAA_issue = t_2a2b_ea2_AA_dep + 8'd1;
wire [7:0] t_2a2b_ea2_BAA_head = (oiss_ge8(t_2a2b_ea2_BAA_dep, t_2a2b_ea2_BAA_issue)) ? t_2a2b_ea2_BAA_dep : t_2a2b_ea2_BAA_issue;
wire [7:0] t_2a2b_ea2_BAB_dep = t_2a2b_ea2_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea2_BAB_issue = t_2a2b_ea2_AB_head + 8'd1;
wire [7:0] t_2a2b_ea2_BAB_head = (oiss_ge8(t_2a2b_ea2_BAB_dep, t_2a2b_ea2_BAB_issue)) ? t_2a2b_ea2_BAB_dep : t_2a2b_ea2_BAB_issue;
wire [7:0] t_2a2b_ea2_BBA_dep = t_2a2b_ea2_BA_head + dual_B_rev_lat[3];
wire [8:0] t_2a2b_ea2_AAAA_dep = t_2a2b_ea2_AAA_dep + dual_A_rev_lat[5];
wire [7:0] t_2a2b_ea2_AAAB_dep = t_2a2b_ea2_AAB_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea2_AABA_dep = t_2a2b_ea2_ABA_head + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea2_AABB_dep = t_2a2b_ea2_ABB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_ABAA_dep = t_2a2b_ea2_AA_dep + dual_A_rev_lat[4];
wire [7:0] t_2a2b_ea2_ABAA_issue = t_2a2b_ea2_BAA_head + 8'd1;
wire [7:0] t_2a2b_ea2_ABAA_head = (oiss_ge8(t_2a2b_ea2_ABAA_dep, t_2a2b_ea2_ABAA_issue)) ? t_2a2b_ea2_ABAA_dep : t_2a2b_ea2_ABAA_issue;
wire [7:0] t_2a2b_ea2_ABAB_dep = t_2a2b_ea2_AB_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_ABAB_issue = t_2a2b_ea2_BAB_head + 8'd1;
wire [7:0] t_2a2b_ea2_ABAB_head = (oiss_ge8(t_2a2b_ea2_ABAB_dep, t_2a2b_ea2_ABAB_issue)) ? t_2a2b_ea2_ABAB_dep : t_2a2b_ea2_ABAB_issue;
wire [7:0] t_2a2b_ea2_ABBA_dep = t_2a2b_ea2_A_head + dual_A_rev_lat[3];
wire [7:0] t_2a2b_ea2_ABBA_issue = t_2a2b_ea2_BBA_dep + 8'd1;
wire [7:0] t_2a2b_ea2_ABBA_head = (oiss_ge8(t_2a2b_ea2_ABBA_dep, t_2a2b_ea2_ABBA_issue)) ? t_2a2b_ea2_ABBA_dep : t_2a2b_ea2_ABBA_issue;
wire [7:0] t_2a2b_ea2_BAAA_dep = m4_2a2b_ea2_rb + dual_B_rev_lat[2];
wire [7:0] t_2a2b_ea2_BAAA_issue = t_2a2b_ea2_AAA_dep + 8'd1;
wire [7:0] t_2a2b_ea2_BAAA_head = (oiss_ge8(t_2a2b_ea2_BAAA_dep, t_2a2b_ea2_BAAA_issue)) ? t_2a2b_ea2_BAAA_dep : t_2a2b_ea2_BAAA_issue;
wire [7:0] t_2a2b_ea2_BAAB_dep = t_2a2b_ea2_B_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea2_BAAB_issue = t_2a2b_ea2_AAB_dep + 8'd1;
wire [7:0] t_2a2b_ea2_BAAB_head = (oiss_ge8(t_2a2b_ea2_BAAB_dep, t_2a2b_ea2_BAAB_issue)) ? t_2a2b_ea2_BAAB_dep : t_2a2b_ea2_BAAB_issue;
wire [7:0] t_2a2b_ea2_BABA_dep = t_2a2b_ea2_BA_head + dual_B_rev_lat[3];
wire [7:0] t_2a2b_ea2_BABA_issue = t_2a2b_ea2_ABA_head + 8'd1;
wire [7:0] t_2a2b_ea2_BABA_head = (oiss_ge8(t_2a2b_ea2_BABA_dep, t_2a2b_ea2_BABA_issue)) ? t_2a2b_ea2_BABA_dep : t_2a2b_ea2_BABA_issue;
wire [7:0] t_2a2b_ea2_BBAA_dep = t_2a2b_ea2_BAA_head + dual_B_rev_lat[3];
wire m4_2a2b_ea2_mode_lane2_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea2_mode_lane2_m0_0_value = m4_2a2b_ea2_mode_lane2_m0_0_pick ? t_2a2b_ea2_AAAB_dep : t_2a2b_ea2_ABBA_head;
wire [3:0] m4_2a2b_ea2_mode_lane2_m0_0_path = m4_2a2b_ea2_mode_lane2_m0_0_pick ? 4'b1110 : 4'b1001;
wire m4_2a2b_ea2_mode_lane3_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea2_mode_lane3_m0_0_value = m4_2a2b_ea2_mode_lane3_m0_0_pick ? t_2a2b_ea2_BAAA_head : t_2a2b_ea2_BAAB_head;
wire [3:0] m4_2a2b_ea2_mode_lane3_m0_0_path = m4_2a2b_ea2_mode_lane3_m0_0_pick ? 4'b0111 : 4'b0110;
wire m4_2a2b_ea2_mode_lane4_m0_0_pick = (B_len == 3'd3);
wire [7:0] m4_2a2b_ea2_mode_lane4_m0_0_value = m4_2a2b_ea2_mode_lane4_m0_0_pick ? t_2a2b_ea2_AABA_dep : t_2a2b_ea2_ABAB_head;
wire [3:0] m4_2a2b_ea2_mode_lane4_m0_0_path = m4_2a2b_ea2_mode_lane4_m0_0_pick ? 4'b1101 : 4'b1010;
wire m4_2a2b_ea2_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_2a2b_ea2_mode_lane5_m0_0_value = m4_2a2b_ea2_mode_lane5_m0_0_pick ? t_2a2b_ea2_AAAA_dep : t_2a2b_ea2_ABAA_head;
wire [3:0] m4_2a2b_ea2_mode_lane5_m0_0_path = m4_2a2b_ea2_mode_lane5_m0_0_pick ? 4'b1111 : 4'b1011;
wire m4_2a2b_ea2_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_2a2b_ea2_mode_lane5_m1_0_value = m4_2a2b_ea2_mode_lane5_m1_0_pick ? m4_2a2b_ea2_mode_lane5_m0_0_value : t_2a2b_ea2_BABA_head;
wire [3:0] m4_2a2b_ea2_mode_lane5_m1_0_path = m4_2a2b_ea2_mode_lane5_m1_0_pick ? m4_2a2b_ea2_mode_lane5_m0_0_path : 4'b0101;
wire m4_2a2b_ea2_tail_m0_0_pick = (oiss_ge8(t_2a2b_ea2_BBAA_dep, t_2a2b_ea2_AABB_dep));
wire [7:0] m4_2a2b_ea2_tail_m0_0_value = m4_2a2b_ea2_tail_m0_0_pick ? t_2a2b_ea2_AABB_dep : t_2a2b_ea2_BBAA_dep;
wire [3:0] m4_2a2b_ea2_tail_m0_0_path = m4_2a2b_ea2_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_2a2b_ea2_tail_m0_1_pick = (oiss_ge8(m4_2a2b_ea2_mode_lane3_m0_0_value, m4_2a2b_ea2_mode_lane2_m0_0_value));
wire [7:0] m4_2a2b_ea2_tail_m0_1_value = m4_2a2b_ea2_tail_m0_1_pick ? m4_2a2b_ea2_mode_lane2_m0_0_value : m4_2a2b_ea2_mode_lane3_m0_0_value;
wire [3:0] m4_2a2b_ea2_tail_m0_1_path = m4_2a2b_ea2_tail_m0_1_pick ? m4_2a2b_ea2_mode_lane2_m0_0_path : m4_2a2b_ea2_mode_lane3_m0_0_path;
wire m4_2a2b_ea2_tail_m0_2_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea2_mode_lane5_m1_0_value, m4_2a2b_ea2_mode_lane4_m0_0_value));
wire [8:0] m4_2a2b_ea2_tail_m0_2_value = m4_2a2b_ea2_tail_m0_2_pick ? m4_2a2b_ea2_mode_lane4_m0_0_value : m4_2a2b_ea2_mode_lane5_m1_0_value;
wire [3:0] m4_2a2b_ea2_tail_m0_2_path = m4_2a2b_ea2_tail_m0_2_pick ? m4_2a2b_ea2_mode_lane4_m0_0_path : m4_2a2b_ea2_mode_lane5_m1_0_path;
wire m4_2a2b_ea2_tail_m1_0_pick = (B_len == 3'd4) && (oiss_ge8(m4_2a2b_ea2_tail_m0_1_value, m4_2a2b_ea2_tail_m0_0_value));
wire [7:0] m4_2a2b_ea2_tail_m1_0_value = m4_2a2b_ea2_tail_m1_0_pick ? m4_2a2b_ea2_tail_m0_0_value : m4_2a2b_ea2_tail_m0_1_value;
wire [3:0] m4_2a2b_ea2_tail_m1_0_path = m4_2a2b_ea2_tail_m1_0_pick ? m4_2a2b_ea2_tail_m0_0_path : m4_2a2b_ea2_tail_m0_1_path;
wire m4_2a2b_ea2_tail_m2_0_pick = (B_len == 3'd3 || B_len == 3'd4) && (oiss_ge9(m4_2a2b_ea2_tail_m0_2_value, m4_2a2b_ea2_tail_m1_0_value));
wire [8:0] m4_2a2b_ea2_tail_m2_0_value = m4_2a2b_ea2_tail_m2_0_pick ? m4_2a2b_ea2_tail_m1_0_value : m4_2a2b_ea2_tail_m0_2_value;
wire [3:0] m4_2a2b_ea2_tail_m2_0_path = m4_2a2b_ea2_tail_m2_0_pick ? m4_2a2b_ea2_tail_m1_0_path : m4_2a2b_ea2_tail_m0_2_path;
wire [8:0] m4_2a2b_ea2_cycle = m4_2a2b_ea2_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_2a2b_ea2_tail_m2_0_value : 9'd511;
wire [7:0] m4_2a2b_ea2_path = {m4_2a2b_ea2_tail_m2_0_path, m4_2a2b_ea2_suffix};

// Shared continuation for m4_3a1b_ea0; suffix selection is outside this tree.
wire [7:0] t_3a1b_ea0_A_dep = m4_3a1b_ea0_ra + dual_A_rev_lat[3];
wire [5:0] t_3a1b_ea0_A_issue = m4_3a1b_ea0_rb + 6'd1;
wire [7:0] t_3a1b_ea0_A_head = (oiss_ge8(t_3a1b_ea0_A_dep, t_3a1b_ea0_A_issue)) ? t_3a1b_ea0_A_dep : t_3a1b_ea0_A_issue;
wire [6:0] t_3a1b_ea0_B_dep = m4_3a1b_ea0_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea0_B_issue = m4_3a1b_ea0_ra + 8'd1;
wire [7:0] t_3a1b_ea0_B_head = (oiss_ge8(t_3a1b_ea0_B_dep, t_3a1b_ea0_B_issue)) ? t_3a1b_ea0_B_dep : t_3a1b_ea0_B_issue;
wire [7:0] t_3a1b_ea0_AA_dep = t_3a1b_ea0_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea0_AB_dep = m4_3a1b_ea0_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea0_AB_issue = t_3a1b_ea0_B_head + 8'd1;
wire [7:0] t_3a1b_ea0_AB_head = (oiss_ge8(t_3a1b_ea0_AB_dep, t_3a1b_ea0_AB_issue)) ? t_3a1b_ea0_AB_dep : t_3a1b_ea0_AB_issue;
wire [6:0] t_3a1b_ea0_BA_dep = m4_3a1b_ea0_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea0_BA_issue = t_3a1b_ea0_A_head + 8'd1;
wire [7:0] t_3a1b_ea0_BA_head = (oiss_ge8(t_3a1b_ea0_BA_dep, t_3a1b_ea0_BA_issue)) ? t_3a1b_ea0_BA_dep : t_3a1b_ea0_BA_issue;
wire [7:0] t_3a1b_ea0_BB_dep = t_3a1b_ea0_B_head + dual_B_rev_lat[2];
wire [8:0] t_3a1b_ea0_AAA_dep = t_3a1b_ea0_AA_dep + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea0_AAB_dep = t_3a1b_ea0_AB_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea0_ABA_dep = t_3a1b_ea0_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea0_ABA_issue = t_3a1b_ea0_BA_head + 8'd1;
wire [7:0] t_3a1b_ea0_ABA_head = (oiss_ge8(t_3a1b_ea0_ABA_dep, t_3a1b_ea0_ABA_issue)) ? t_3a1b_ea0_ABA_dep : t_3a1b_ea0_ABA_issue;
wire [7:0] t_3a1b_ea0_ABB_dep = m4_3a1b_ea0_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea0_ABB_issue = t_3a1b_ea0_BB_dep + 8'd1;
wire [7:0] t_3a1b_ea0_ABB_head = (oiss_ge8(t_3a1b_ea0_ABB_dep, t_3a1b_ea0_ABB_issue)) ? t_3a1b_ea0_ABB_dep : t_3a1b_ea0_ABB_issue;
wire [6:0] t_3a1b_ea0_BAA_dep = m4_3a1b_ea0_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea0_BAA_issue = t_3a1b_ea0_AA_dep + 8'd1;
wire [7:0] t_3a1b_ea0_BAA_head = (oiss_ge8(t_3a1b_ea0_BAA_dep, t_3a1b_ea0_BAA_issue)) ? t_3a1b_ea0_BAA_dep : t_3a1b_ea0_BAA_issue;
wire [7:0] t_3a1b_ea0_BAB_dep = t_3a1b_ea0_B_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea0_BAB_issue = t_3a1b_ea0_AB_head + 8'd1;
wire [7:0] t_3a1b_ea0_BAB_head = (oiss_ge8(t_3a1b_ea0_BAB_dep, t_3a1b_ea0_BAB_issue)) ? t_3a1b_ea0_BAB_dep : t_3a1b_ea0_BAB_issue;
wire [7:0] t_3a1b_ea0_BBA_dep = t_3a1b_ea0_BA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea0_BBB_dep = t_3a1b_ea0_BB_dep + dual_B_rev_lat[3];
wire [8:0] t_3a1b_ea0_AAAB_dep = t_3a1b_ea0_AAB_dep + dual_A_rev_lat[5];
wire [8:0] t_3a1b_ea0_AABA_dep = t_3a1b_ea0_ABA_head + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea0_AABB_dep = t_3a1b_ea0_ABB_head + dual_A_rev_lat[4];
wire [8:0] t_3a1b_ea0_ABAA_dep = t_3a1b_ea0_AA_dep + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea0_ABAA_issue = t_3a1b_ea0_BAA_head + 8'd1;
wire [8:0] t_3a1b_ea0_ABAA_head = (oiss_ge9(t_3a1b_ea0_ABAA_dep, t_3a1b_ea0_ABAA_issue)) ? t_3a1b_ea0_ABAA_dep : t_3a1b_ea0_ABAA_issue;
wire [7:0] t_3a1b_ea0_ABAB_dep = t_3a1b_ea0_AB_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea0_ABAB_issue = t_3a1b_ea0_BAB_head + 8'd1;
wire [7:0] t_3a1b_ea0_ABAB_head = (oiss_ge8(t_3a1b_ea0_ABAB_dep, t_3a1b_ea0_ABAB_issue)) ? t_3a1b_ea0_ABAB_dep : t_3a1b_ea0_ABAB_issue;
wire [7:0] t_3a1b_ea0_ABBA_dep = t_3a1b_ea0_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea0_ABBA_issue = t_3a1b_ea0_BBA_dep + 8'd1;
wire [7:0] t_3a1b_ea0_ABBA_head = (oiss_ge8(t_3a1b_ea0_ABBA_dep, t_3a1b_ea0_ABBA_issue)) ? t_3a1b_ea0_ABBA_dep : t_3a1b_ea0_ABBA_issue;
wire [7:0] t_3a1b_ea0_ABBB_dep = m4_3a1b_ea0_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea0_ABBB_issue = t_3a1b_ea0_BBB_dep + 8'd1;
wire [7:0] t_3a1b_ea0_ABBB_head = (oiss_ge8(t_3a1b_ea0_ABBB_dep, t_3a1b_ea0_ABBB_issue)) ? t_3a1b_ea0_ABBB_dep : t_3a1b_ea0_ABBB_issue;
wire [6:0] t_3a1b_ea0_BAAA_dep = m4_3a1b_ea0_rb + dual_B_rev_lat[1];
wire [8:0] t_3a1b_ea0_BAAA_issue = t_3a1b_ea0_AAA_dep + 9'd1;
wire [8:0] t_3a1b_ea0_BAAA_head = (oiss_ge9(t_3a1b_ea0_BAAA_dep, t_3a1b_ea0_BAAA_issue)) ? t_3a1b_ea0_BAAA_dep : t_3a1b_ea0_BAAA_issue;
wire [7:0] t_3a1b_ea0_BAAB_dep = t_3a1b_ea0_B_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea0_BAAB_issue = t_3a1b_ea0_AAB_dep + 8'd1;
wire [7:0] t_3a1b_ea0_BAAB_head = (oiss_ge8(t_3a1b_ea0_BAAB_dep, t_3a1b_ea0_BAAB_issue)) ? t_3a1b_ea0_BAAB_dep : t_3a1b_ea0_BAAB_issue;
wire [7:0] t_3a1b_ea0_BABA_dep = t_3a1b_ea0_BA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea0_BABA_issue = t_3a1b_ea0_ABA_head + 8'd1;
wire [7:0] t_3a1b_ea0_BABA_head = (oiss_ge8(t_3a1b_ea0_BABA_dep, t_3a1b_ea0_BABA_issue)) ? t_3a1b_ea0_BABA_dep : t_3a1b_ea0_BABA_issue;
wire [7:0] t_3a1b_ea0_BABB_dep = t_3a1b_ea0_BB_dep + dual_B_rev_lat[3];
wire [7:0] t_3a1b_ea0_BABB_issue = t_3a1b_ea0_ABB_head + 8'd1;
wire [7:0] t_3a1b_ea0_BABB_head = (oiss_ge8(t_3a1b_ea0_BABB_dep, t_3a1b_ea0_BABB_issue)) ? t_3a1b_ea0_BABB_dep : t_3a1b_ea0_BABB_issue;
wire [8:0] t_3a1b_ea0_BBAA_dep = t_3a1b_ea0_BAA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea0_BBAB_dep = t_3a1b_ea0_BAB_head + dual_B_rev_lat[3];
wire [8:0] t_3a1b_ea0_BBBA_dep = t_3a1b_ea0_BBA_dep + dual_B_rev_lat[3];
wire m4_3a1b_ea0_mode_lane2_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea0_mode_lane2_m0_0_value = m4_3a1b_ea0_mode_lane2_m0_0_pick ? t_3a1b_ea0_AAAB_dep : t_3a1b_ea0_ABBA_head;
wire [3:0] m4_3a1b_ea0_mode_lane2_m0_0_path = m4_3a1b_ea0_mode_lane2_m0_0_pick ? 4'b1110 : 4'b1001;
wire m4_3a1b_ea0_mode_lane2_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea0_mode_lane2_m1_0_value = m4_3a1b_ea0_mode_lane2_m1_0_pick ? m4_3a1b_ea0_mode_lane2_m0_0_value : t_3a1b_ea0_ABBB_head;
wire [3:0] m4_3a1b_ea0_mode_lane2_m1_0_path = m4_3a1b_ea0_mode_lane2_m1_0_pick ? m4_3a1b_ea0_mode_lane2_m0_0_path : 4'b1000;
wire m4_3a1b_ea0_mode_lane3_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea0_mode_lane3_m0_0_value = m4_3a1b_ea0_mode_lane3_m0_0_pick ? t_3a1b_ea0_BAAA_head : t_3a1b_ea0_BAAB_head;
wire [3:0] m4_3a1b_ea0_mode_lane3_m0_0_path = m4_3a1b_ea0_mode_lane3_m0_0_pick ? 4'b0111 : 4'b0110;
wire m4_3a1b_ea0_mode_lane3_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea0_mode_lane3_m1_0_value = m4_3a1b_ea0_mode_lane3_m1_0_pick ? m4_3a1b_ea0_mode_lane3_m0_0_value : t_3a1b_ea0_BBBA_dep;
wire [3:0] m4_3a1b_ea0_mode_lane3_m1_0_path = m4_3a1b_ea0_mode_lane3_m1_0_pick ? m4_3a1b_ea0_mode_lane3_m0_0_path : 4'b0001;
wire m4_3a1b_ea0_mode_lane4_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea0_mode_lane4_m0_0_value = m4_3a1b_ea0_mode_lane4_m0_0_pick ? t_3a1b_ea0_AABA_dep : t_3a1b_ea0_ABAB_head;
wire [3:0] m4_3a1b_ea0_mode_lane4_m0_0_path = m4_3a1b_ea0_mode_lane4_m0_0_pick ? 4'b1101 : 4'b1010;
wire m4_3a1b_ea0_mode_lane4_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea0_mode_lane4_m1_0_value = m4_3a1b_ea0_mode_lane4_m1_0_pick ? m4_3a1b_ea0_mode_lane4_m0_0_value : t_3a1b_ea0_BABB_head;
wire [3:0] m4_3a1b_ea0_mode_lane4_m1_0_path = m4_3a1b_ea0_mode_lane4_m1_0_pick ? m4_3a1b_ea0_mode_lane4_m0_0_path : 4'b0100;
wire m4_3a1b_ea0_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea0_mode_lane5_m0_0_value = m4_3a1b_ea0_mode_lane5_m0_0_pick ? t_3a1b_ea0_ABAA_head : t_3a1b_ea0_BABA_head;
wire [3:0] m4_3a1b_ea0_mode_lane5_m0_0_path = m4_3a1b_ea0_mode_lane5_m0_0_pick ? 4'b1011 : 4'b0101;
wire m4_3a1b_ea0_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea0_mode_lane5_m1_0_value = m4_3a1b_ea0_mode_lane5_m1_0_pick ? m4_3a1b_ea0_mode_lane5_m0_0_value : t_3a1b_ea0_BBAB_dep;
wire [3:0] m4_3a1b_ea0_mode_lane5_m1_0_path = m4_3a1b_ea0_mode_lane5_m1_0_pick ? m4_3a1b_ea0_mode_lane5_m0_0_path : 4'b0010;
wire m4_3a1b_ea0_tail_m0_0_pick = (oiss_ge9(t_3a1b_ea0_BBAA_dep, t_3a1b_ea0_AABB_dep));
wire [8:0] m4_3a1b_ea0_tail_m0_0_value = m4_3a1b_ea0_tail_m0_0_pick ? t_3a1b_ea0_AABB_dep : t_3a1b_ea0_BBAA_dep;
wire [3:0] m4_3a1b_ea0_tail_m0_0_path = m4_3a1b_ea0_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_3a1b_ea0_tail_m0_1_pick = (oiss_ge9(m4_3a1b_ea0_mode_lane3_m1_0_value, m4_3a1b_ea0_mode_lane2_m1_0_value));
wire [8:0] m4_3a1b_ea0_tail_m0_1_value = m4_3a1b_ea0_tail_m0_1_pick ? m4_3a1b_ea0_mode_lane2_m1_0_value : m4_3a1b_ea0_mode_lane3_m1_0_value;
wire [3:0] m4_3a1b_ea0_tail_m0_1_path = m4_3a1b_ea0_tail_m0_1_pick ? m4_3a1b_ea0_mode_lane2_m1_0_path : m4_3a1b_ea0_mode_lane3_m1_0_path;
wire m4_3a1b_ea0_tail_m0_2_pick = (oiss_ge9(m4_3a1b_ea0_mode_lane5_m1_0_value, m4_3a1b_ea0_mode_lane4_m1_0_value));
wire [8:0] m4_3a1b_ea0_tail_m0_2_value = m4_3a1b_ea0_tail_m0_2_pick ? m4_3a1b_ea0_mode_lane4_m1_0_value : m4_3a1b_ea0_mode_lane5_m1_0_value;
wire [3:0] m4_3a1b_ea0_tail_m0_2_path = m4_3a1b_ea0_tail_m0_2_pick ? m4_3a1b_ea0_mode_lane4_m1_0_path : m4_3a1b_ea0_mode_lane5_m1_0_path;
wire m4_3a1b_ea0_tail_m1_0_pick = (B_len == 3'd3) && (oiss_ge9(m4_3a1b_ea0_tail_m0_1_value, m4_3a1b_ea0_tail_m0_0_value));
wire [8:0] m4_3a1b_ea0_tail_m1_0_value = m4_3a1b_ea0_tail_m1_0_pick ? m4_3a1b_ea0_tail_m0_0_value : m4_3a1b_ea0_tail_m0_1_value;
wire [3:0] m4_3a1b_ea0_tail_m1_0_path = m4_3a1b_ea0_tail_m1_0_pick ? m4_3a1b_ea0_tail_m0_0_path : m4_3a1b_ea0_tail_m0_1_path;
wire m4_3a1b_ea0_tail_m2_0_pick = (oiss_ge9(m4_3a1b_ea0_tail_m0_2_value, m4_3a1b_ea0_tail_m1_0_value));
wire [8:0] m4_3a1b_ea0_tail_m2_0_value = m4_3a1b_ea0_tail_m2_0_pick ? m4_3a1b_ea0_tail_m1_0_value : m4_3a1b_ea0_tail_m0_2_value;
wire [3:0] m4_3a1b_ea0_tail_m2_0_path = m4_3a1b_ea0_tail_m2_0_pick ? m4_3a1b_ea0_tail_m1_0_path : m4_3a1b_ea0_tail_m0_2_path;
wire [8:0] m4_3a1b_ea0_cycle = m4_3a1b_ea0_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_3a1b_ea0_tail_m2_0_value : 9'd511;
wire [7:0] m4_3a1b_ea0_path = {m4_3a1b_ea0_tail_m2_0_path, m4_3a1b_ea0_suffix};

// Shared continuation for m4_3a1b_ea1; suffix selection is outside this tree.
wire [7:0] t_3a1b_ea1_A_dep = m4_3a1b_ea1_ra + dual_A_rev_lat[3];
wire [5:0] t_3a1b_ea1_A_issue = m4_3a1b_ea1_rb + 6'd1;
wire [7:0] t_3a1b_ea1_A_head = (oiss_ge8(t_3a1b_ea1_A_dep, t_3a1b_ea1_A_issue)) ? t_3a1b_ea1_A_dep : t_3a1b_ea1_A_issue;
wire [6:0] t_3a1b_ea1_B_dep = m4_3a1b_ea1_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea1_B_issue = m4_3a1b_ea1_ra + 8'd1;
wire [7:0] t_3a1b_ea1_B_head = (oiss_ge8(t_3a1b_ea1_B_dep, t_3a1b_ea1_B_issue)) ? t_3a1b_ea1_B_dep : t_3a1b_ea1_B_issue;
wire [7:0] t_3a1b_ea1_AA_dep = t_3a1b_ea1_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea1_AB_dep = m4_3a1b_ea1_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea1_AB_issue = t_3a1b_ea1_B_head + 8'd1;
wire [7:0] t_3a1b_ea1_AB_head = (oiss_ge8(t_3a1b_ea1_AB_dep, t_3a1b_ea1_AB_issue)) ? t_3a1b_ea1_AB_dep : t_3a1b_ea1_AB_issue;
wire [6:0] t_3a1b_ea1_BA_dep = m4_3a1b_ea1_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea1_BA_issue = t_3a1b_ea1_A_head + 8'd1;
wire [7:0] t_3a1b_ea1_BA_head = (oiss_ge8(t_3a1b_ea1_BA_dep, t_3a1b_ea1_BA_issue)) ? t_3a1b_ea1_BA_dep : t_3a1b_ea1_BA_issue;
wire [7:0] t_3a1b_ea1_BB_dep = t_3a1b_ea1_B_head + dual_B_rev_lat[2];
wire [8:0] t_3a1b_ea1_AAA_dep = t_3a1b_ea1_AA_dep + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea1_AAB_dep = t_3a1b_ea1_AB_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea1_ABA_dep = t_3a1b_ea1_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea1_ABA_issue = t_3a1b_ea1_BA_head + 8'd1;
wire [7:0] t_3a1b_ea1_ABA_head = (oiss_ge8(t_3a1b_ea1_ABA_dep, t_3a1b_ea1_ABA_issue)) ? t_3a1b_ea1_ABA_dep : t_3a1b_ea1_ABA_issue;
wire [7:0] t_3a1b_ea1_ABB_dep = m4_3a1b_ea1_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea1_ABB_issue = t_3a1b_ea1_BB_dep + 8'd1;
wire [7:0] t_3a1b_ea1_ABB_head = (oiss_ge8(t_3a1b_ea1_ABB_dep, t_3a1b_ea1_ABB_issue)) ? t_3a1b_ea1_ABB_dep : t_3a1b_ea1_ABB_issue;
wire [6:0] t_3a1b_ea1_BAA_dep = m4_3a1b_ea1_rb + dual_B_rev_lat[1];
wire [7:0] t_3a1b_ea1_BAA_issue = t_3a1b_ea1_AA_dep + 8'd1;
wire [7:0] t_3a1b_ea1_BAA_head = (oiss_ge8(t_3a1b_ea1_BAA_dep, t_3a1b_ea1_BAA_issue)) ? t_3a1b_ea1_BAA_dep : t_3a1b_ea1_BAA_issue;
wire [7:0] t_3a1b_ea1_BAB_dep = t_3a1b_ea1_B_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea1_BAB_issue = t_3a1b_ea1_AB_head + 8'd1;
wire [7:0] t_3a1b_ea1_BAB_head = (oiss_ge8(t_3a1b_ea1_BAB_dep, t_3a1b_ea1_BAB_issue)) ? t_3a1b_ea1_BAB_dep : t_3a1b_ea1_BAB_issue;
wire [7:0] t_3a1b_ea1_BBA_dep = t_3a1b_ea1_BA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea1_BBB_dep = t_3a1b_ea1_BB_dep + dual_B_rev_lat[3];
wire [8:0] t_3a1b_ea1_AAAB_dep = t_3a1b_ea1_AAB_dep + dual_A_rev_lat[5];
wire [8:0] t_3a1b_ea1_AABA_dep = t_3a1b_ea1_ABA_head + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea1_AABB_dep = t_3a1b_ea1_ABB_head + dual_A_rev_lat[4];
wire [8:0] t_3a1b_ea1_ABAA_dep = t_3a1b_ea1_AA_dep + dual_A_rev_lat[5];
wire [7:0] t_3a1b_ea1_ABAA_issue = t_3a1b_ea1_BAA_head + 8'd1;
wire [8:0] t_3a1b_ea1_ABAA_head = (oiss_ge9(t_3a1b_ea1_ABAA_dep, t_3a1b_ea1_ABAA_issue)) ? t_3a1b_ea1_ABAA_dep : t_3a1b_ea1_ABAA_issue;
wire [7:0] t_3a1b_ea1_ABAB_dep = t_3a1b_ea1_AB_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea1_ABAB_issue = t_3a1b_ea1_BAB_head + 8'd1;
wire [7:0] t_3a1b_ea1_ABAB_head = (oiss_ge8(t_3a1b_ea1_ABAB_dep, t_3a1b_ea1_ABAB_issue)) ? t_3a1b_ea1_ABAB_dep : t_3a1b_ea1_ABAB_issue;
wire [7:0] t_3a1b_ea1_ABBA_dep = t_3a1b_ea1_A_head + dual_A_rev_lat[4];
wire [7:0] t_3a1b_ea1_ABBA_issue = t_3a1b_ea1_BBA_dep + 8'd1;
wire [7:0] t_3a1b_ea1_ABBA_head = (oiss_ge8(t_3a1b_ea1_ABBA_dep, t_3a1b_ea1_ABBA_issue)) ? t_3a1b_ea1_ABBA_dep : t_3a1b_ea1_ABBA_issue;
wire [7:0] t_3a1b_ea1_ABBB_dep = m4_3a1b_ea1_ra + dual_A_rev_lat[3];
wire [7:0] t_3a1b_ea1_ABBB_issue = t_3a1b_ea1_BBB_dep + 8'd1;
wire [7:0] t_3a1b_ea1_ABBB_head = (oiss_ge8(t_3a1b_ea1_ABBB_dep, t_3a1b_ea1_ABBB_issue)) ? t_3a1b_ea1_ABBB_dep : t_3a1b_ea1_ABBB_issue;
wire [6:0] t_3a1b_ea1_BAAA_dep = m4_3a1b_ea1_rb + dual_B_rev_lat[1];
wire [8:0] t_3a1b_ea1_BAAA_issue = t_3a1b_ea1_AAA_dep + 9'd1;
wire [8:0] t_3a1b_ea1_BAAA_head = (oiss_ge9(t_3a1b_ea1_BAAA_dep, t_3a1b_ea1_BAAA_issue)) ? t_3a1b_ea1_BAAA_dep : t_3a1b_ea1_BAAA_issue;
wire [7:0] t_3a1b_ea1_BAAB_dep = t_3a1b_ea1_B_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea1_BAAB_issue = t_3a1b_ea1_AAB_dep + 8'd1;
wire [7:0] t_3a1b_ea1_BAAB_head = (oiss_ge8(t_3a1b_ea1_BAAB_dep, t_3a1b_ea1_BAAB_issue)) ? t_3a1b_ea1_BAAB_dep : t_3a1b_ea1_BAAB_issue;
wire [7:0] t_3a1b_ea1_BABA_dep = t_3a1b_ea1_BA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea1_BABA_issue = t_3a1b_ea1_ABA_head + 8'd1;
wire [7:0] t_3a1b_ea1_BABA_head = (oiss_ge8(t_3a1b_ea1_BABA_dep, t_3a1b_ea1_BABA_issue)) ? t_3a1b_ea1_BABA_dep : t_3a1b_ea1_BABA_issue;
wire [7:0] t_3a1b_ea1_BABB_dep = t_3a1b_ea1_BB_dep + dual_B_rev_lat[3];
wire [7:0] t_3a1b_ea1_BABB_issue = t_3a1b_ea1_ABB_head + 8'd1;
wire [7:0] t_3a1b_ea1_BABB_head = (oiss_ge8(t_3a1b_ea1_BABB_dep, t_3a1b_ea1_BABB_issue)) ? t_3a1b_ea1_BABB_dep : t_3a1b_ea1_BABB_issue;
wire [8:0] t_3a1b_ea1_BBAA_dep = t_3a1b_ea1_BAA_head + dual_B_rev_lat[2];
wire [7:0] t_3a1b_ea1_BBAB_dep = t_3a1b_ea1_BAB_head + dual_B_rev_lat[3];
wire [8:0] t_3a1b_ea1_BBBA_dep = t_3a1b_ea1_BBA_dep + dual_B_rev_lat[3];
wire m4_3a1b_ea1_mode_lane2_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea1_mode_lane2_m0_0_value = m4_3a1b_ea1_mode_lane2_m0_0_pick ? t_3a1b_ea1_AAAB_dep : t_3a1b_ea1_ABBA_head;
wire [3:0] m4_3a1b_ea1_mode_lane2_m0_0_path = m4_3a1b_ea1_mode_lane2_m0_0_pick ? 4'b1110 : 4'b1001;
wire m4_3a1b_ea1_mode_lane2_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea1_mode_lane2_m1_0_value = m4_3a1b_ea1_mode_lane2_m1_0_pick ? m4_3a1b_ea1_mode_lane2_m0_0_value : t_3a1b_ea1_ABBB_head;
wire [3:0] m4_3a1b_ea1_mode_lane2_m1_0_path = m4_3a1b_ea1_mode_lane2_m1_0_pick ? m4_3a1b_ea1_mode_lane2_m0_0_path : 4'b1000;
wire m4_3a1b_ea1_mode_lane3_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea1_mode_lane3_m0_0_value = m4_3a1b_ea1_mode_lane3_m0_0_pick ? t_3a1b_ea1_BAAA_head : t_3a1b_ea1_BAAB_head;
wire [3:0] m4_3a1b_ea1_mode_lane3_m0_0_path = m4_3a1b_ea1_mode_lane3_m0_0_pick ? 4'b0111 : 4'b0110;
wire m4_3a1b_ea1_mode_lane3_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea1_mode_lane3_m1_0_value = m4_3a1b_ea1_mode_lane3_m1_0_pick ? m4_3a1b_ea1_mode_lane3_m0_0_value : t_3a1b_ea1_BBBA_dep;
wire [3:0] m4_3a1b_ea1_mode_lane3_m1_0_path = m4_3a1b_ea1_mode_lane3_m1_0_pick ? m4_3a1b_ea1_mode_lane3_m0_0_path : 4'b0001;
wire m4_3a1b_ea1_mode_lane4_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea1_mode_lane4_m0_0_value = m4_3a1b_ea1_mode_lane4_m0_0_pick ? t_3a1b_ea1_AABA_dep : t_3a1b_ea1_ABAB_head;
wire [3:0] m4_3a1b_ea1_mode_lane4_m0_0_path = m4_3a1b_ea1_mode_lane4_m0_0_pick ? 4'b1101 : 4'b1010;
wire m4_3a1b_ea1_mode_lane4_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea1_mode_lane4_m1_0_value = m4_3a1b_ea1_mode_lane4_m1_0_pick ? m4_3a1b_ea1_mode_lane4_m0_0_value : t_3a1b_ea1_BABB_head;
wire [3:0] m4_3a1b_ea1_mode_lane4_m1_0_path = m4_3a1b_ea1_mode_lane4_m1_0_pick ? m4_3a1b_ea1_mode_lane4_m0_0_path : 4'b0100;
wire m4_3a1b_ea1_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_3a1b_ea1_mode_lane5_m0_0_value = m4_3a1b_ea1_mode_lane5_m0_0_pick ? t_3a1b_ea1_ABAA_head : t_3a1b_ea1_BABA_head;
wire [3:0] m4_3a1b_ea1_mode_lane5_m0_0_path = m4_3a1b_ea1_mode_lane5_m0_0_pick ? 4'b1011 : 4'b0101;
wire m4_3a1b_ea1_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_3a1b_ea1_mode_lane5_m1_0_value = m4_3a1b_ea1_mode_lane5_m1_0_pick ? m4_3a1b_ea1_mode_lane5_m0_0_value : t_3a1b_ea1_BBAB_dep;
wire [3:0] m4_3a1b_ea1_mode_lane5_m1_0_path = m4_3a1b_ea1_mode_lane5_m1_0_pick ? m4_3a1b_ea1_mode_lane5_m0_0_path : 4'b0010;
wire m4_3a1b_ea1_tail_m0_0_pick = (oiss_ge9(t_3a1b_ea1_BBAA_dep, t_3a1b_ea1_AABB_dep));
wire [8:0] m4_3a1b_ea1_tail_m0_0_value = m4_3a1b_ea1_tail_m0_0_pick ? t_3a1b_ea1_AABB_dep : t_3a1b_ea1_BBAA_dep;
wire [3:0] m4_3a1b_ea1_tail_m0_0_path = m4_3a1b_ea1_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_3a1b_ea1_tail_m0_1_pick = (oiss_ge9(m4_3a1b_ea1_mode_lane3_m1_0_value, m4_3a1b_ea1_mode_lane2_m1_0_value));
wire [8:0] m4_3a1b_ea1_tail_m0_1_value = m4_3a1b_ea1_tail_m0_1_pick ? m4_3a1b_ea1_mode_lane2_m1_0_value : m4_3a1b_ea1_mode_lane3_m1_0_value;
wire [3:0] m4_3a1b_ea1_tail_m0_1_path = m4_3a1b_ea1_tail_m0_1_pick ? m4_3a1b_ea1_mode_lane2_m1_0_path : m4_3a1b_ea1_mode_lane3_m1_0_path;
wire m4_3a1b_ea1_tail_m0_2_pick = (oiss_ge9(m4_3a1b_ea1_mode_lane5_m1_0_value, m4_3a1b_ea1_mode_lane4_m1_0_value));
wire [8:0] m4_3a1b_ea1_tail_m0_2_value = m4_3a1b_ea1_tail_m0_2_pick ? m4_3a1b_ea1_mode_lane4_m1_0_value : m4_3a1b_ea1_mode_lane5_m1_0_value;
wire [3:0] m4_3a1b_ea1_tail_m0_2_path = m4_3a1b_ea1_tail_m0_2_pick ? m4_3a1b_ea1_mode_lane4_m1_0_path : m4_3a1b_ea1_mode_lane5_m1_0_path;
wire m4_3a1b_ea1_tail_m1_0_pick = (B_len == 3'd3) && (oiss_ge9(m4_3a1b_ea1_tail_m0_1_value, m4_3a1b_ea1_tail_m0_0_value));
wire [8:0] m4_3a1b_ea1_tail_m1_0_value = m4_3a1b_ea1_tail_m1_0_pick ? m4_3a1b_ea1_tail_m0_0_value : m4_3a1b_ea1_tail_m0_1_value;
wire [3:0] m4_3a1b_ea1_tail_m1_0_path = m4_3a1b_ea1_tail_m1_0_pick ? m4_3a1b_ea1_tail_m0_0_path : m4_3a1b_ea1_tail_m0_1_path;
wire m4_3a1b_ea1_tail_m2_0_pick = (oiss_ge9(m4_3a1b_ea1_tail_m0_2_value, m4_3a1b_ea1_tail_m1_0_value));
wire [8:0] m4_3a1b_ea1_tail_m2_0_value = m4_3a1b_ea1_tail_m2_0_pick ? m4_3a1b_ea1_tail_m1_0_value : m4_3a1b_ea1_tail_m0_2_value;
wire [3:0] m4_3a1b_ea1_tail_m2_0_path = m4_3a1b_ea1_tail_m2_0_pick ? m4_3a1b_ea1_tail_m1_0_path : m4_3a1b_ea1_tail_m0_2_path;
wire [8:0] m4_3a1b_ea1_cycle = m4_3a1b_ea1_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_3a1b_ea1_tail_m2_0_value : 9'd511;
wire [7:0] m4_3a1b_ea1_path = {m4_3a1b_ea1_tail_m2_0_path, m4_3a1b_ea1_suffix};

// Shared continuation for m4_4a0b_ea0; suffix selection is outside this tree.
wire [7:0] t_4a0b_ea0_A_dep = m4_4a0b_ea0_ra + dual_A_rev_lat[4];
wire [0:0] t_4a0b_ea0_A_issue = m4_4a0b_ea0_rb + 1'd1;
wire [7:0] t_4a0b_ea0_A_head = (oiss_ge8(t_4a0b_ea0_A_dep, t_4a0b_ea0_A_issue)) ? t_4a0b_ea0_A_dep : t_4a0b_ea0_A_issue;
wire [5:0] t_4a0b_ea0_B_dep = m4_4a0b_ea0_rb + dual_B_rev_lat[0];
wire [7:0] t_4a0b_ea0_B_issue = m4_4a0b_ea0_ra + 8'd1;
wire [7:0] t_4a0b_ea0_B_head = (oiss_ge8(t_4a0b_ea0_B_dep, t_4a0b_ea0_B_issue)) ? t_4a0b_ea0_B_dep : t_4a0b_ea0_B_issue;
wire [8:0] t_4a0b_ea0_AA_dep = t_4a0b_ea0_A_head + dual_A_rev_lat[5];
wire [7:0] t_4a0b_ea0_AB_dep = m4_4a0b_ea0_ra + dual_A_rev_lat[4];
wire [7:0] t_4a0b_ea0_AB_issue = t_4a0b_ea0_B_head + 8'd1;
wire [7:0] t_4a0b_ea0_AB_head = (oiss_ge8(t_4a0b_ea0_AB_dep, t_4a0b_ea0_AB_issue)) ? t_4a0b_ea0_AB_dep : t_4a0b_ea0_AB_issue;
wire [5:0] t_4a0b_ea0_BA_dep = m4_4a0b_ea0_rb + dual_B_rev_lat[0];
wire [7:0] t_4a0b_ea0_BA_issue = t_4a0b_ea0_A_head + 8'd1;
wire [7:0] t_4a0b_ea0_BA_head = (oiss_ge8(t_4a0b_ea0_BA_dep, t_4a0b_ea0_BA_issue)) ? t_4a0b_ea0_BA_dep : t_4a0b_ea0_BA_issue;
wire [7:0] t_4a0b_ea0_BB_dep = t_4a0b_ea0_B_head + dual_B_rev_lat[1];
wire [8:0] t_4a0b_ea0_AAB_dep = t_4a0b_ea0_AB_head + dual_A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABA_dep = t_4a0b_ea0_A_head + dual_A_rev_lat[5];
wire [7:0] t_4a0b_ea0_ABA_issue = t_4a0b_ea0_BA_head + 8'd1;
wire [8:0] t_4a0b_ea0_ABA_head = (oiss_ge9(t_4a0b_ea0_ABA_dep, t_4a0b_ea0_ABA_issue)) ? t_4a0b_ea0_ABA_dep : t_4a0b_ea0_ABA_issue;
wire [7:0] t_4a0b_ea0_ABB_dep = m4_4a0b_ea0_ra + dual_A_rev_lat[4];
wire [7:0] t_4a0b_ea0_ABB_issue = t_4a0b_ea0_BB_dep + 8'd1;
wire [7:0] t_4a0b_ea0_ABB_head = (oiss_ge8(t_4a0b_ea0_ABB_dep, t_4a0b_ea0_ABB_issue)) ? t_4a0b_ea0_ABB_dep : t_4a0b_ea0_ABB_issue;
wire [5:0] t_4a0b_ea0_BAA_dep = m4_4a0b_ea0_rb + dual_B_rev_lat[0];
wire [8:0] t_4a0b_ea0_BAA_issue = t_4a0b_ea0_AA_dep + 9'd1;
wire [8:0] t_4a0b_ea0_BAA_head = (oiss_ge9(t_4a0b_ea0_BAA_dep, t_4a0b_ea0_BAA_issue)) ? t_4a0b_ea0_BAA_dep : t_4a0b_ea0_BAA_issue;
wire [7:0] t_4a0b_ea0_BAB_dep = t_4a0b_ea0_B_head + dual_B_rev_lat[1];
wire [7:0] t_4a0b_ea0_BAB_issue = t_4a0b_ea0_AB_head + 8'd1;
wire [7:0] t_4a0b_ea0_BAB_head = (oiss_ge8(t_4a0b_ea0_BAB_dep, t_4a0b_ea0_BAB_issue)) ? t_4a0b_ea0_BAB_dep : t_4a0b_ea0_BAB_issue;
wire [8:0] t_4a0b_ea0_BBA_dep = t_4a0b_ea0_BA_head + dual_B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BBB_dep = t_4a0b_ea0_BB_dep + dual_B_rev_lat[2];
wire [8:0] t_4a0b_ea0_AABB_dep = t_4a0b_ea0_ABB_head + dual_A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABAB_dep = t_4a0b_ea0_AB_head + dual_A_rev_lat[5];
wire [7:0] t_4a0b_ea0_ABAB_issue = t_4a0b_ea0_BAB_head + 8'd1;
wire [8:0] t_4a0b_ea0_ABAB_head = (oiss_ge9(t_4a0b_ea0_ABAB_dep, t_4a0b_ea0_ABAB_issue)) ? t_4a0b_ea0_ABAB_dep : t_4a0b_ea0_ABAB_issue;
wire [8:0] t_4a0b_ea0_ABBA_dep = t_4a0b_ea0_A_head + dual_A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABBA_issue = t_4a0b_ea0_BBA_dep + 9'd1;
wire [8:0] t_4a0b_ea0_ABBA_head = (oiss_ge9(t_4a0b_ea0_ABBA_dep, t_4a0b_ea0_ABBA_issue)) ? t_4a0b_ea0_ABBA_dep : t_4a0b_ea0_ABBA_issue;
wire [7:0] t_4a0b_ea0_ABBB_dep = m4_4a0b_ea0_ra + dual_A_rev_lat[4];
wire [8:0] t_4a0b_ea0_ABBB_issue = t_4a0b_ea0_BBB_dep + 9'd1;
wire [8:0] t_4a0b_ea0_ABBB_head = (oiss_ge9(t_4a0b_ea0_ABBB_dep, t_4a0b_ea0_ABBB_issue)) ? t_4a0b_ea0_ABBB_dep : t_4a0b_ea0_ABBB_issue;
wire [7:0] t_4a0b_ea0_BAAB_dep = t_4a0b_ea0_B_head + dual_B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BAAB_issue = t_4a0b_ea0_AAB_dep + 9'd1;
wire [8:0] t_4a0b_ea0_BAAB_head = (oiss_ge9(t_4a0b_ea0_BAAB_dep, t_4a0b_ea0_BAAB_issue)) ? t_4a0b_ea0_BAAB_dep : t_4a0b_ea0_BAAB_issue;
wire [8:0] t_4a0b_ea0_BABA_dep = t_4a0b_ea0_BA_head + dual_B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BABA_issue = t_4a0b_ea0_ABA_head + 9'd1;
wire [8:0] t_4a0b_ea0_BABA_head = (oiss_ge9(t_4a0b_ea0_BABA_dep, t_4a0b_ea0_BABA_issue)) ? t_4a0b_ea0_BABA_dep : t_4a0b_ea0_BABA_issue;
wire [8:0] t_4a0b_ea0_BABB_dep = t_4a0b_ea0_BB_dep + dual_B_rev_lat[2];
wire [7:0] t_4a0b_ea0_BABB_issue = t_4a0b_ea0_ABB_head + 8'd1;
wire [8:0] t_4a0b_ea0_BABB_head = (oiss_ge9(t_4a0b_ea0_BABB_dep, t_4a0b_ea0_BABB_issue)) ? t_4a0b_ea0_BABB_dep : t_4a0b_ea0_BABB_issue;
wire [8:0] t_4a0b_ea0_BBAA_dep = t_4a0b_ea0_BAA_head + dual_B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BBAB_dep = t_4a0b_ea0_BAB_head + dual_B_rev_lat[2];
wire [8:0] t_4a0b_ea0_BBBA_dep = t_4a0b_ea0_BBA_dep + dual_B_rev_lat[2];
wire [8:0] t_4a0b_ea0_BBBB_dep = t_4a0b_ea0_BBB_dep + dual_B_rev_lat[3];
wire m4_4a0b_ea0_mode_lane2_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_4a0b_ea0_mode_lane2_m0_0_value = m4_4a0b_ea0_mode_lane2_m0_0_pick ? t_4a0b_ea0_ABBA_head : t_4a0b_ea0_ABBB_head;
wire [3:0] m4_4a0b_ea0_mode_lane2_m0_0_path = m4_4a0b_ea0_mode_lane2_m0_0_pick ? 4'b1001 : 4'b1000;
wire m4_4a0b_ea0_mode_lane3_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_4a0b_ea0_mode_lane3_m0_0_value = m4_4a0b_ea0_mode_lane3_m0_0_pick ? t_4a0b_ea0_BAAB_head : t_4a0b_ea0_BBBA_dep;
wire [3:0] m4_4a0b_ea0_mode_lane3_m0_0_path = m4_4a0b_ea0_mode_lane3_m0_0_pick ? 4'b0110 : 4'b0001;
wire m4_4a0b_ea0_mode_lane4_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_4a0b_ea0_mode_lane4_m0_0_value = m4_4a0b_ea0_mode_lane4_m0_0_pick ? t_4a0b_ea0_ABAB_head : t_4a0b_ea0_BABB_head;
wire [3:0] m4_4a0b_ea0_mode_lane4_m0_0_path = m4_4a0b_ea0_mode_lane4_m0_0_pick ? 4'b1010 : 4'b0100;
wire m4_4a0b_ea0_mode_lane5_m0_0_pick = (B_len == 3'd2);
wire [8:0] m4_4a0b_ea0_mode_lane5_m0_0_value = m4_4a0b_ea0_mode_lane5_m0_0_pick ? t_4a0b_ea0_BABA_head : t_4a0b_ea0_BBAB_dep;
wire [3:0] m4_4a0b_ea0_mode_lane5_m0_0_path = m4_4a0b_ea0_mode_lane5_m0_0_pick ? 4'b0101 : 4'b0010;
wire m4_4a0b_ea0_mode_lane5_m1_0_pick = (B_len == 3'd2 || B_len == 3'd3);
wire [8:0] m4_4a0b_ea0_mode_lane5_m1_0_value = m4_4a0b_ea0_mode_lane5_m1_0_pick ? m4_4a0b_ea0_mode_lane5_m0_0_value : t_4a0b_ea0_BBBB_dep;
wire [3:0] m4_4a0b_ea0_mode_lane5_m1_0_path = m4_4a0b_ea0_mode_lane5_m1_0_pick ? m4_4a0b_ea0_mode_lane5_m0_0_path : 4'b0000;
wire m4_4a0b_ea0_tail_m0_0_pick = (oiss_ge9(t_4a0b_ea0_BBAA_dep, t_4a0b_ea0_AABB_dep));
wire [8:0] m4_4a0b_ea0_tail_m0_0_value = m4_4a0b_ea0_tail_m0_0_pick ? t_4a0b_ea0_AABB_dep : t_4a0b_ea0_BBAA_dep;
wire [3:0] m4_4a0b_ea0_tail_m0_0_path = m4_4a0b_ea0_tail_m0_0_pick ? 4'b1100 : 4'b0011;
wire m4_4a0b_ea0_tail_m0_1_pick = (oiss_ge9(m4_4a0b_ea0_mode_lane3_m0_0_value, m4_4a0b_ea0_mode_lane2_m0_0_value));
wire [8:0] m4_4a0b_ea0_tail_m0_1_value = m4_4a0b_ea0_tail_m0_1_pick ? m4_4a0b_ea0_mode_lane2_m0_0_value : m4_4a0b_ea0_mode_lane3_m0_0_value;
wire [3:0] m4_4a0b_ea0_tail_m0_1_path = m4_4a0b_ea0_tail_m0_1_pick ? m4_4a0b_ea0_mode_lane2_m0_0_path : m4_4a0b_ea0_mode_lane3_m0_0_path;
wire m4_4a0b_ea0_tail_m0_2_pick = (B_len == 3'd2 || B_len == 3'd3) && (oiss_ge9(m4_4a0b_ea0_mode_lane5_m1_0_value, m4_4a0b_ea0_mode_lane4_m0_0_value));
wire [8:0] m4_4a0b_ea0_tail_m0_2_value = m4_4a0b_ea0_tail_m0_2_pick ? m4_4a0b_ea0_mode_lane4_m0_0_value : m4_4a0b_ea0_mode_lane5_m1_0_value;
wire [3:0] m4_4a0b_ea0_tail_m0_2_path = m4_4a0b_ea0_tail_m0_2_pick ? m4_4a0b_ea0_mode_lane4_m0_0_path : m4_4a0b_ea0_mode_lane5_m1_0_path;
wire m4_4a0b_ea0_tail_m1_0_pick = (B_len == 3'd2) && (oiss_ge9(m4_4a0b_ea0_tail_m0_1_value, m4_4a0b_ea0_tail_m0_0_value));
wire [8:0] m4_4a0b_ea0_tail_m1_0_value = m4_4a0b_ea0_tail_m1_0_pick ? m4_4a0b_ea0_tail_m0_0_value : m4_4a0b_ea0_tail_m0_1_value;
wire [3:0] m4_4a0b_ea0_tail_m1_0_path = m4_4a0b_ea0_tail_m1_0_pick ? m4_4a0b_ea0_tail_m0_0_path : m4_4a0b_ea0_tail_m0_1_path;
wire m4_4a0b_ea0_tail_m2_0_pick = (B_len == 3'd2 || B_len == 3'd3) && (oiss_ge9(m4_4a0b_ea0_tail_m0_2_value, m4_4a0b_ea0_tail_m1_0_value));
wire [8:0] m4_4a0b_ea0_tail_m2_0_value = m4_4a0b_ea0_tail_m2_0_pick ? m4_4a0b_ea0_tail_m1_0_value : m4_4a0b_ea0_tail_m0_2_value;
wire [3:0] m4_4a0b_ea0_tail_m2_0_path = m4_4a0b_ea0_tail_m2_0_pick ? m4_4a0b_ea0_tail_m1_0_path : m4_4a0b_ea0_tail_m0_2_path;
wire [8:0] m4_4a0b_ea0_cycle = m4_4a0b_ea0_v && (B_len == 3'd2 || B_len == 3'd3 || B_len == 3'd4) ? m4_4a0b_ea0_tail_m2_0_value : 9'd511;
wire [7:0] m4_4a0b_ea0_path = {m4_4a0b_ea0_tail_m2_0_path, m4_4a0b_ea0_suffix};
// Combine the two early pure-axis results before the balanced eight-way tree.
wire dual_early_m0_0_pick = (oiss_ge9(m4_4a0b_ea0_cycle, m4_0a4b_eb0_cycle));
wire [8:0] dual_early_m0_0_value = dual_early_m0_0_pick ? m4_0a4b_eb0_cycle : m4_4a0b_ea0_cycle;
wire [7:0] dual_early_m0_0_path = dual_early_m0_0_pick ? m4_0a4b_eb0_path : m4_4a0b_ea0_path;
wire dual_final_m0_0_pick = (oiss_ge9(m4_1a3b_eb0_cycle, dual_early_m0_0_value));
wire [8:0] dual_final_m0_0_value = dual_final_m0_0_pick ? dual_early_m0_0_value : m4_1a3b_eb0_cycle;
wire [7:0] dual_final_m0_0_path = dual_final_m0_0_pick ? dual_early_m0_0_path : m4_1a3b_eb0_path;
wire dual_final_m0_1_pick = (oiss_ge9(m4_2a2b_ea0_cycle, m4_1a3b_eb1_cycle));
wire [8:0] dual_final_m0_1_value = dual_final_m0_1_pick ? m4_1a3b_eb1_cycle : m4_2a2b_ea0_cycle;
wire [7:0] dual_final_m0_1_path = dual_final_m0_1_pick ? m4_1a3b_eb1_path : m4_2a2b_ea0_path;
wire dual_final_m0_2_pick = (oiss_ge9(m4_2a2b_ea2_cycle, m4_2a2b_ea1_cycle));
wire [8:0] dual_final_m0_2_value = dual_final_m0_2_pick ? m4_2a2b_ea1_cycle : m4_2a2b_ea2_cycle;
wire [7:0] dual_final_m0_2_path = dual_final_m0_2_pick ? m4_2a2b_ea1_path : m4_2a2b_ea2_path;
wire dual_final_m0_3_pick = (oiss_ge9(m4_3a1b_ea1_cycle, m4_3a1b_ea0_cycle));
wire [8:0] dual_final_m0_3_value = dual_final_m0_3_pick ? m4_3a1b_ea0_cycle : m4_3a1b_ea1_cycle;
wire [7:0] dual_final_m0_3_path = dual_final_m0_3_pick ? m4_3a1b_ea0_path : m4_3a1b_ea1_path;
wire dual_final_m1_0_pick = (oiss_ge9(dual_final_m0_1_value, dual_final_m0_0_value));
wire [8:0] dual_final_m1_0_value = dual_final_m1_0_pick ? dual_final_m0_0_value : dual_final_m0_1_value;
wire [7:0] dual_final_m1_0_path = dual_final_m1_0_pick ? dual_final_m0_0_path : dual_final_m0_1_path;
wire dual_final_m1_1_pick = (oiss_ge9(dual_final_m0_3_value, dual_final_m0_2_value));
wire [8:0] dual_final_m1_1_value = dual_final_m1_1_pick ? dual_final_m0_2_value : dual_final_m0_3_value;
wire [7:0] dual_final_m1_1_path = dual_final_m1_1_pick ? dual_final_m0_2_path : dual_final_m0_3_path;
wire dual_final_m2_0_pick = (oiss_ge9(dual_final_m1_1_value, dual_final_m1_0_value));
wire [8:0] dual_final_m2_0_value = dual_final_m2_0_pick ? dual_final_m1_0_value : dual_final_m1_1_value;
wire [7:0] dual_final_m2_0_path = dual_final_m2_0_pick ? dual_final_m1_0_path : dual_final_m1_1_path;
wire [8:0] dual_best_cycle = dual_final_m2_0_value;
wire [7:0] dual_best_path = dual_final_m2_0_path;
// Exact single-chain greedy with a latest-possible, gap-free chain.
// S[i] reserves reverse-time chain issue slots. Independents use the earliest free slots.
// q is the free-slot rank after removing the chain reservations.
wire [0:0] gc_sum0 = 1'b0;
wire [5:0] gc_sum1 = gc_sum0 + chain0_rev_lat[0];
wire gc_cvalid1 = (chain0_len >= 4'd1);
wire [5:0] gc_key1 = gc_sum1 - 6'd1;
wire [6:0] gc_sum2 = gc_sum1 + chain0_rev_lat[1];
wire gc_cvalid2 = (chain0_len >= 4'd2);
wire [6:0] gc_key2 = gc_sum2 - 7'd2;
wire [7:0] gc_sum3 = gc_sum2 + chain0_rev_lat[2];
wire gc_cvalid3 = (chain0_len >= 4'd3);
wire [7:0] gc_key3 = gc_sum3 - 8'd3;
wire [7:0] gc_sum4 = gc_sum3 + chain0_rev_lat[3];
wire gc_cvalid4 = (chain0_len >= 4'd4);
wire [7:0] gc_key4 = gc_sum4 - 8'd4;
wire [7:0] gc_sum5 = gc_sum4 + chain0_rev_lat[4];
wire gc_cvalid5 = (chain0_len >= 4'd5);
wire [7:0] gc_key5 = gc_sum5 - 8'd5;
wire [8:0] gc_sum6 = gc_sum5 + chain0_rev_lat[5];
wire gc_cvalid6 = (chain0_len >= 4'd6);
wire [8:0] gc_key6 = gc_sum6 - 9'd6;
wire [8:0] gc_sum7 = gc_sum6 + chain0_rev_lat[6];
wire gc_cvalid7 = (chain0_len >= 4'd7);
wire [8:0] gc_key7 = gc_sum7 - 9'd7;
wire gc_ivalid0 = (indep_len > 4'd0);
wire gc_before_0_1 = (gc_sum1 < ind_rev_lat[0]);
wire gc_before_0_2 = (gc_sum2 < ind_rev_lat[0]);
wire gc_before_0_3 = gc_cvalid3 && (gc_sum3 < ind_rev_lat[0]);
wire gc_before_0_4 = gc_cvalid4 && (gc_sum4 < ind_rev_lat[0]);
wire gc_before_0_5 = gc_cvalid5 && (gc_sum5 < ind_rev_lat[0]);
wire gc_before_0_6 = gc_cvalid6 && (gc_sum6 < ind_rev_lat[0]);
wire gc_before_0_7 = gc_cvalid7 && (gc_sum7 < ind_rev_lat[0]);
wire [1:0] gc_before_count0ll = gc_before_0_1 + gc_before_0_2;
wire [1:0] gc_before_count0lr = gc_before_0_3 + gc_before_0_4;
wire [2:0] gc_before_count0l = gc_before_count0ll + gc_before_count0lr;
wire [1:0] gc_before_count0rl = gc_before_0_5 + gc_before_0_6;
wire [1:0] gc_before_count0r = gc_before_count0rl + gc_before_0_7;
wire [2:0] gc_before_count0 = gc_before_count0l + gc_before_count0r;
wire [5:0] gc_bound0 = ind_rev_lat[0] - gc_before_count0;
wire gc_ivalid1 = (indep_len > 4'd1);
wire gc_before_1_1 = (gc_sum1 < ind_rev_lat[1]);
wire gc_before_1_2 = (gc_sum2 < ind_rev_lat[1]);
wire gc_before_1_3 = gc_cvalid3 && (gc_sum3 < ind_rev_lat[1]);
wire gc_before_1_4 = gc_cvalid4 && (gc_sum4 < ind_rev_lat[1]);
wire gc_before_1_5 = gc_cvalid5 && (gc_sum5 < ind_rev_lat[1]);
wire gc_before_1_6 = gc_cvalid6 && (gc_sum6 < ind_rev_lat[1]);
wire [1:0] gc_before_count1ll = gc_before_1_1 + gc_before_1_2;
wire [1:0] gc_before_count1lr = gc_before_1_3 + gc_before_1_4;
wire [2:0] gc_before_count1l = gc_before_count1ll + gc_before_count1lr;
wire [1:0] gc_before_count1r = gc_before_1_5 + gc_before_1_6;
wire [2:0] gc_before_count1 = gc_before_count1l + gc_before_count1r;
wire [5:0] gc_bound1 = ind_rev_lat[1] - gc_before_count1;
wire gc_ivalid2 = (indep_len > 4'd2);
wire gc_before_2_1 = (gc_sum1 < ind_rev_lat[2]);
wire gc_before_2_2 = (gc_sum2 < ind_rev_lat[2]);
wire gc_before_2_3 = gc_cvalid3 && (gc_sum3 < ind_rev_lat[2]);
wire gc_before_2_4 = gc_cvalid4 && (gc_sum4 < ind_rev_lat[2]);
wire gc_before_2_5 = gc_cvalid5 && (gc_sum5 < ind_rev_lat[2]);
wire [1:0] gc_before_count2ll = gc_before_2_1 + gc_before_2_2;
wire [1:0] gc_before_count2lr = gc_before_2_3 + gc_before_2_4;
wire [2:0] gc_before_count2l = gc_before_count2ll + gc_before_count2lr;
wire [2:0] gc_before_count2 = gc_before_count2l + gc_before_2_5;
wire [5:0] gc_bound2 = ind_rev_lat[2] - gc_before_count2;
wire gc_ivalid3 = (indep_len > 4'd3);
wire gc_before_3_1 = (gc_sum1 < ind_rev_lat[3]);
wire gc_before_3_2 = (gc_sum2 < ind_rev_lat[3]);
wire gc_before_3_3 = gc_cvalid3 && (gc_sum3 < ind_rev_lat[3]);
wire gc_before_3_4 = gc_cvalid4 && (gc_sum4 < ind_rev_lat[3]);
wire [1:0] gc_before_count3l = gc_before_3_1 + gc_before_3_2;
wire [1:0] gc_before_count3r = gc_before_3_3 + gc_before_3_4;
wire [2:0] gc_before_count3 = gc_before_count3l + gc_before_count3r;
wire [5:0] gc_bound3 = ind_rev_lat[3] - gc_before_count3;
wire gc_ivalid4 = (indep_len > 4'd4);
wire gc_before_4_1 = (gc_sum1 < ind_rev_lat[4]);
wire gc_before_4_2 = (gc_sum2 < ind_rev_lat[4]);
wire gc_before_4_3 = gc_cvalid3 && (gc_sum3 < ind_rev_lat[4]);
wire [1:0] gc_before_count4l = gc_before_4_1 + gc_before_4_2;
wire [1:0] gc_before_count4 = gc_before_count4l + gc_before_4_3;
wire [5:0] gc_bound4 = ind_rev_lat[4] - gc_before_count4;
wire gc_ivalid5 = (indep_len > 4'd5);
wire gc_before_5_1 = (gc_sum1 < ind_rev_lat[5]);
wire gc_before_5_2 = (gc_sum2 < ind_rev_lat[5]);
wire [1:0] gc_before_count5 = gc_before_5_1 + gc_before_5_2;
wire [5:0] gc_bound5 = ind_rev_lat[5] - gc_before_count5;
wire [5:0] gc_norm0 = gc_bound0 + 6'd5;
wire [5:0] gc_norm1 = gc_bound1 + 6'd4;
wire [5:0] gc_norm2 = gc_bound2 + 6'd3;
wire [5:0] gc_norm3 = gc_bound3 + 6'd2;
wire [5:0] gc_norm4 = gc_bound4 + 6'd1;
wire [5:0] gc_norm5 = gc_bound5 + 6'd0;
wire [5:0] gc_q0 = gc_norm0 - 6'd5;
wire gc_skip_0_1 = (!oiss_ge6(gc_key1, gc_q0));
wire gc_skip_0_2 = (!oiss_ge7(gc_key2, gc_q0));
wire gc_skip_0_3 = gc_cvalid3 && (!oiss_ge8(gc_key3, gc_q0));
wire gc_skip_0_4 = gc_cvalid4 && (!oiss_ge8(gc_key4, gc_q0));
wire gc_skip_0_5 = gc_cvalid5 && (!oiss_ge8(gc_key5, gc_q0));
wire gc_skip_0_6 = gc_cvalid6 && (!oiss_ge9(gc_key6, gc_q0));
wire gc_skip_0_7 = gc_cvalid7 && (!oiss_ge9(gc_key7, gc_q0));
wire [1:0] gc_skip_count0ll = gc_skip_0_1 + gc_skip_0_2;
wire [1:0] gc_skip_count0lr = gc_skip_0_3 + gc_skip_0_4;
wire [2:0] gc_skip_count0l = gc_skip_count0ll + gc_skip_count0lr;
wire [1:0] gc_skip_count0rl = gc_skip_0_5 + gc_skip_0_6;
wire [1:0] gc_skip_count0r = gc_skip_count0rl + gc_skip_0_7;
wire [2:0] gc_skip_count0 = gc_skip_count0l + gc_skip_count0r;
wire [5:0] gc_time0 = gc_q0 + gc_skip_count0;
wire [2:0] gc_pos0 = gc_skip_count0 + 3'd0;
wire [7:0] gc_mask0 = gc_ivalid0 ? (8'b1 << gc_pos0) : 8'd0;
wire [5:0] gc_norm_max_0_2 = (oiss_ge6(gc_norm0, gc_norm1)) ? gc_norm0 : gc_norm1;
wire [5:0] gc_q1 = gc_norm_max_0_2 - 6'd4;
wire gc_skip_1_1 = (!oiss_ge6(gc_key1, gc_q1));
wire gc_skip_1_2 = (!oiss_ge7(gc_key2, gc_q1));
wire gc_skip_1_3 = gc_cvalid3 && (!oiss_ge8(gc_key3, gc_q1));
wire gc_skip_1_4 = gc_cvalid4 && (!oiss_ge8(gc_key4, gc_q1));
wire gc_skip_1_5 = gc_cvalid5 && (!oiss_ge8(gc_key5, gc_q1));
wire gc_skip_1_6 = gc_cvalid6 && (!oiss_ge9(gc_key6, gc_q1));
wire [1:0] gc_skip_count1ll = gc_skip_1_1 + gc_skip_1_2;
wire [1:0] gc_skip_count1lr = gc_skip_1_3 + gc_skip_1_4;
wire [2:0] gc_skip_count1l = gc_skip_count1ll + gc_skip_count1lr;
wire [1:0] gc_skip_count1r = gc_skip_1_5 + gc_skip_1_6;
wire [2:0] gc_skip_count1 = gc_skip_count1l + gc_skip_count1r;
wire [5:0] gc_time1 = gc_q1 + gc_skip_count1;
wire [2:0] gc_pos1 = gc_skip_count1 + 3'd1;
wire [7:0] gc_mask1 = gc_ivalid1 ? (8'b1 << gc_pos1) : 8'd0;
wire [5:0] gc_norm_max_0_3 = (oiss_ge6(gc_norm_max_0_2, gc_norm2)) ? gc_norm_max_0_2 : gc_norm2;
wire [5:0] gc_q2 = gc_norm_max_0_3 - 6'd3;
wire gc_skip_2_1 = (!oiss_ge6(gc_key1, gc_q2));
wire gc_skip_2_2 = (!oiss_ge7(gc_key2, gc_q2));
wire gc_skip_2_3 = gc_cvalid3 && (!oiss_ge8(gc_key3, gc_q2));
wire gc_skip_2_4 = gc_cvalid4 && (!oiss_ge8(gc_key4, gc_q2));
wire gc_skip_2_5 = gc_cvalid5 && (!oiss_ge8(gc_key5, gc_q2));
wire [1:0] gc_skip_count2ll = gc_skip_2_1 + gc_skip_2_2;
wire [1:0] gc_skip_count2lr = gc_skip_2_3 + gc_skip_2_4;
wire [2:0] gc_skip_count2l = gc_skip_count2ll + gc_skip_count2lr;
wire [2:0] gc_skip_count2 = gc_skip_count2l + gc_skip_2_5;
wire [5:0] gc_time2 = gc_q2 + gc_skip_count2;
wire [2:0] gc_pos2 = gc_skip_count2 + 3'd2;
wire [7:0] gc_mask2 = gc_ivalid2 ? (8'b1 << gc_pos2) : 8'd0;
wire [5:0] gc_norm_max_2_4 = (oiss_ge6(gc_norm2, gc_norm3)) ? gc_norm2 : gc_norm3;
wire [5:0] gc_norm_max_0_4 = (oiss_ge6(gc_norm_max_0_2, gc_norm_max_2_4)) ? gc_norm_max_0_2 : gc_norm_max_2_4;
wire [5:0] gc_q3 = gc_norm_max_0_4 - 6'd2;
wire gc_skip_3_1 = (!oiss_ge6(gc_key1, gc_q3));
wire gc_skip_3_2 = (!oiss_ge7(gc_key2, gc_q3));
wire gc_skip_3_3 = gc_cvalid3 && (!oiss_ge8(gc_key3, gc_q3));
wire gc_skip_3_4 = gc_cvalid4 && (!oiss_ge8(gc_key4, gc_q3));
wire [1:0] gc_skip_count3l = gc_skip_3_1 + gc_skip_3_2;
wire [1:0] gc_skip_count3r = gc_skip_3_3 + gc_skip_3_4;
wire [2:0] gc_skip_count3 = gc_skip_count3l + gc_skip_count3r;
wire [5:0] gc_time3 = gc_q3 + gc_skip_count3;
wire [2:0] gc_pos3 = gc_skip_count3 + 3'd3;
wire [7:0] gc_mask3 = gc_ivalid3 ? (8'b1 << gc_pos3) : 8'd0;
wire [5:0] gc_norm_max_0_5 = (oiss_ge6(gc_norm_max_0_4, gc_norm4)) ? gc_norm_max_0_4 : gc_norm4;
wire [5:0] gc_q4 = gc_norm_max_0_5 - 6'd1;
wire gc_skip_4_1 = (!oiss_ge6(gc_key1, gc_q4));
wire gc_skip_4_2 = (!oiss_ge7(gc_key2, gc_q4));
wire gc_skip_4_3 = gc_cvalid3 && (!oiss_ge8(gc_key3, gc_q4));
wire [1:0] gc_skip_count4l = gc_skip_4_1 + gc_skip_4_2;
wire [1:0] gc_skip_count4 = gc_skip_count4l + gc_skip_4_3;
wire [5:0] gc_time4 = gc_q4 + gc_skip_count4;
wire [2:0] gc_pos4 = gc_skip_count4 + 3'd4;
wire [7:0] gc_mask4 = gc_ivalid4 ? (8'b1 << gc_pos4) : 8'd0;
wire [5:0] gc_norm_max_4_6 = (oiss_ge6(gc_norm4, gc_norm5)) ? gc_norm4 : gc_norm5;
wire [5:0] gc_norm_max_0_6 = (oiss_ge6(gc_norm_max_0_4, gc_norm_max_4_6)) ? gc_norm_max_0_4 : gc_norm_max_4_6;
wire [5:0] gc_q5 = gc_norm_max_0_6 - 6'd0;
wire gc_skip_5_1 = (!oiss_ge6(gc_key1, gc_q5));
wire gc_skip_5_2 = (!oiss_ge7(gc_key2, gc_q5));
wire [1:0] gc_skip_count5 = gc_skip_5_1 + gc_skip_5_2;
wire [5:0] gc_time5 = gc_q5 + gc_skip_count5;
wire [2:0] gc_pos5 = gc_skip_count5 + 3'd5;
wire [7:0] gc_mask5 = gc_ivalid5 ? (8'b1 << gc_pos5) : 8'd0;
reg [8:0] gc_chain_total;
reg [5:0] gc_ind_total;
always @(*) begin
    gc_chain_total = 9'd0;
    case (chain0_len)
        4'd2: gc_chain_total = gc_sum2;
        4'd3: gc_chain_total = gc_sum3;
        4'd4: gc_chain_total = gc_sum4;
        4'd5: gc_chain_total = gc_sum5;
        4'd6: gc_chain_total = gc_sum6;
        4'd7: gc_chain_total = gc_sum7;
        default: begin end
    endcase
    gc_ind_total = 6'd0;
    case (indep_len)
        4'd1: gc_ind_total = gc_time0;
        4'd2: gc_ind_total = gc_time1;
        4'd3: gc_ind_total = gc_time2;
        4'd4: gc_ind_total = gc_time3;
        4'd5: gc_ind_total = gc_time4;
        4'd6: gc_ind_total = gc_time5;
        default: begin end
    endcase
end
wire [8:0] single_best_cycle = (oiss_ge9(gc_chain_total, gc_ind_total)) ? gc_chain_total : gc_ind_total;
wire [7:0] single_chain_path = ~(gc_mask0 | gc_mask1 | gc_mask2 | gc_mask3 | gc_mask4 | gc_mask5);
wire [7:0] single_best_path = single_chain_path ^ {8{!A_dependent}};
// Direct solutions when every instruction belongs to group A.
wire [0:0] only_a_sum0 = 1'b0;
wire [5:0] only_a_sum1 = only_a_sum0 + chain0_rev_lat[0];
wire [6:0] only_a_sum2 = only_a_sum1 + chain0_rev_lat[1];
wire [7:0] only_a_sum3 = only_a_sum2 + chain0_rev_lat[2];
wire [7:0] only_a_sum4 = only_a_sum3 + chain0_rev_lat[3];
wire [7:0] only_a_sum5 = only_a_sum4 + chain0_rev_lat[4];
wire [8:0] only_a_sum6 = only_a_sum5 + chain0_rev_lat[5];
wire [8:0] only_a_sum7 = only_a_sum6 + chain0_rev_lat[6];
wire [8:0] only_a_sum8 = only_a_sum7 + chain0_rev_lat[7];
wire [5:0] ind_finish0 = ind_s6_0[8:3] + 6'd0;
wire [5:0] ind_finish1 = ind_s6_1[8:3] + 6'd1;
wire [5:0] ind_finish2 = ind_s6_2[8:3] + 6'd2;
wire [5:0] ind_finish3 = ind_s6_3[8:3] + 6'd3;
wire [5:0] ind_finish4 = ind_s6_4[8:3] + 6'd4;
wire [5:0] ind_finish5 = ind_s6_5[8:3] + 6'd5;
wire [5:0] ind_finish6 = ind_s6_6[8:3] + 6'd6;
wire [5:0] ind_finish7 = ind_s6_7[8:3] + 6'd7;
wire [5:0] ind_max0_0 = (oiss_ge6(ind_finish0, ind_finish1)) ? ind_finish0 : ind_finish1;
wire [5:0] ind_max0_1 = (oiss_ge6(ind_finish2, ind_finish3)) ? ind_finish2 : ind_finish3;
wire [5:0] ind_max0_2 = (oiss_ge6(ind_finish4, ind_finish5)) ? ind_finish4 : ind_finish5;
wire [5:0] ind_max0_3 = (oiss_ge6(ind_finish6, ind_finish7)) ? ind_finish6 : ind_finish7;
wire [5:0] ind_max1_0 = (oiss_ge6(ind_max0_0, ind_max0_1)) ? ind_max0_0 : ind_max0_1;
wire [5:0] ind_max1_1 = (oiss_ge6(ind_max0_2, ind_max0_3)) ? ind_max0_2 : ind_max0_3;
wire [5:0] ind_max2_0 = (oiss_ge6(ind_max1_0, ind_max1_1)) ? ind_max1_0 : ind_max1_1;
wire [8:0] only_a_cycle = A_dependent ? only_a_sum8 : ind_max2_0;
wire [8:0] best_cycle = (B_len == 3'd0) ? only_a_cycle : (A_dependent && B_dependent) ? dual_best_cycle : single_best_cycle;
wire [7:0] best_path = (B_len == 3'd0) ? 8'hff : (A_dependent && B_dependent) ? dual_best_path : single_best_path;

//////// OUTPUT RECONSTRUCTION ////////
// Shared balanced prefix populations; all eight output indices are generated in parallel.
wire [2:0] out_a_index0 = 1'b0;
wire [1:0] out_b_index0 = 1'b0;
wire [2:0] out_a_index1 = best_path[7];
wire [1:0] out_b_index1 = (!best_path[7]);
wire [1:0] out_a_count_0_2 = best_path[7] + best_path[6];
wire [1:0] out_b_count_0_2 = (!best_path[7]) + (!best_path[6]);
wire [2:0] out_a_index2 = out_a_count_0_2;
wire [1:0] out_b_index2 = out_b_count_0_2;
wire [1:0] out_a_count_0_3 = out_a_count_0_2 + best_path[5];
wire [1:0] out_b_count_0_3 = out_b_count_0_2 + (!best_path[5]);
wire [2:0] out_a_index3 = out_a_count_0_3;
wire [1:0] out_b_index3 = out_b_count_0_3;
wire [1:0] out_a_count_2_4 = best_path[5] + best_path[4];
wire [2:0] out_a_count_0_4 = out_a_count_0_2 + out_a_count_2_4;
wire [1:0] out_b_count_2_4 = (!best_path[5]) + (!best_path[4]);
wire [2:0] out_b_count_0_4 = out_b_count_0_2 + out_b_count_2_4;
wire [2:0] out_a_index4 = out_a_count_0_4;
wire [1:0] out_b_index4 = out_b_count_0_4;
wire [2:0] out_a_count_0_5 = out_a_count_0_4 + best_path[3];
wire [2:0] out_b_count_0_5 = out_b_count_0_4 + (!best_path[3]);
wire [2:0] out_a_index5 = out_a_count_0_5;
wire [1:0] out_b_index5 = out_b_count_0_5;
wire [1:0] out_a_count_4_6 = best_path[3] + best_path[2];
wire [2:0] out_a_count_0_6 = out_a_count_0_4 + out_a_count_4_6;
wire [1:0] out_b_count_4_6 = (!best_path[3]) + (!best_path[2]);
wire [2:0] out_b_count_0_6 = out_b_count_0_4 + out_b_count_4_6;
wire [2:0] out_a_index6 = out_a_count_0_6;
wire [1:0] out_b_index6 = out_b_count_0_6;
wire [1:0] out_a_count_4_7 = out_a_count_4_6 + best_path[1];
wire [2:0] out_a_count_0_7 = out_a_count_0_4 + out_a_count_4_7;
wire [1:0] out_b_count_4_7 = out_b_count_4_6 + (!best_path[1]);
wire [2:0] out_b_count_0_7 = out_b_count_0_4 + out_b_count_4_7;
wire [2:0] out_a_index7 = out_a_count_0_7;
wire [1:0] out_b_index7 = out_b_count_0_7;
always @(*) begin
    Inst_order_O[0 +: 3] = best_path[7] ? A_inst[out_a_index0] : B_inst[out_b_index0];
    Inst_order_O[3 +: 3] = best_path[6] ? A_inst[out_a_index1] : B_inst[out_b_index1];
    Inst_order_O[6 +: 3] = best_path[5] ? A_inst[out_a_index2] : B_inst[out_b_index2];
    Inst_order_O[9 +: 3] = best_path[4] ? A_inst[out_a_index3] : B_inst[out_b_index3];
    Inst_order_O[12 +: 3] = best_path[3] ? A_inst[out_a_index4] : B_inst[out_b_index4];
    Inst_order_O[15 +: 3] = best_path[2] ? A_inst[out_a_index5] : B_inst[out_b_index5];
    Inst_order_O[18 +: 3] = best_path[1] ? A_inst[out_a_index6] : B_inst[out_b_index6];
    Inst_order_O[21 +: 3] = best_path[0] ? A_inst[out_a_index7] : B_inst[out_b_index7];
end

assign Ex_cycle = best_cycle;

endmodule
