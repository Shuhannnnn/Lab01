// Self-contained OISS hybrid scheduler. No external include files are required.
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


// extend latency
reg [8:0] A_lat_ext [0:7];
reg [8:0] B_lat_ext [0:7];

integer ext_i;

always @(*) begin
    for (ext_i = 0; ext_i < 8; ext_i = ext_i + 1) begin
        A_lat_ext[ext_i] = {3'b000, inst_latency[A_inst[ext_i]]};
        B_lat_ext[ext_i] = {3'b000, inst_latency[B_inst[ext_i]]};
    end
end
// ============================================================
// Backward Tree Calculator
// ============================================================
// Reverse latency indexing is shared by all backward suffix nodes.
reg [5:0] A_rev_lat [0:7];
reg [5:0] B_rev_lat [0:3];
integer rev_i;

always @(*) begin
    for (rev_i = 0; rev_i < 8; rev_i = rev_i + 1) A_rev_lat[rev_i] = 6'd0;
    for (rev_i = 0; rev_i < 4; rev_i = rev_i + 1) B_rev_lat[rev_i] = 6'd0;
    case (B_len)
        3'd0: begin
            A_rev_lat[0] = A_lat_ext[7][5:0]; A_rev_lat[1] = A_lat_ext[6][5:0]; A_rev_lat[2] = A_lat_ext[5][5:0]; A_rev_lat[3] = A_lat_ext[4][5:0];
            A_rev_lat[4] = A_lat_ext[3][5:0]; A_rev_lat[5] = A_lat_ext[2][5:0]; A_rev_lat[6] = A_lat_ext[1][5:0]; A_rev_lat[7] = A_lat_ext[0][5:0];
        end
        3'd1: begin
            A_rev_lat[0] = A_lat_ext[6][5:0]; A_rev_lat[1] = A_lat_ext[5][5:0]; A_rev_lat[2] = A_lat_ext[4][5:0]; A_rev_lat[3] = A_lat_ext[3][5:0];
            A_rev_lat[4] = A_lat_ext[2][5:0]; A_rev_lat[5] = A_lat_ext[1][5:0]; A_rev_lat[6] = A_lat_ext[0][5:0]; B_rev_lat[0] = B_lat_ext[0][5:0];
        end
        3'd2: begin
            A_rev_lat[0] = A_lat_ext[5][5:0]; A_rev_lat[1] = A_lat_ext[4][5:0]; A_rev_lat[2] = A_lat_ext[3][5:0]; A_rev_lat[3] = A_lat_ext[2][5:0];
            A_rev_lat[4] = A_lat_ext[1][5:0]; A_rev_lat[5] = A_lat_ext[0][5:0]; B_rev_lat[0] = B_lat_ext[1][5:0]; B_rev_lat[1] = B_lat_ext[0][5:0];
        end
        3'd3: begin
            A_rev_lat[0] = A_lat_ext[4][5:0]; A_rev_lat[1] = A_lat_ext[3][5:0]; A_rev_lat[2] = A_lat_ext[2][5:0]; A_rev_lat[3] = A_lat_ext[1][5:0]; A_rev_lat[4] = A_lat_ext[0][5:0];
            B_rev_lat[0] = B_lat_ext[2][5:0]; B_rev_lat[1] = B_lat_ext[1][5:0]; B_rev_lat[2] = B_lat_ext[0][5:0];
        end
        3'd4: begin
            A_rev_lat[0] = A_lat_ext[3][5:0]; A_rev_lat[1] = A_lat_ext[2][5:0]; A_rev_lat[2] = A_lat_ext[1][5:0]; A_rev_lat[3] = A_lat_ext[0][5:0];
            B_rev_lat[0] = B_lat_ext[3][5:0]; B_rev_lat[1] = B_lat_ext[2][5:0]; B_rev_lat[2] = B_lat_ext[1][5:0]; B_rev_lat[3] = B_lat_ext[0][5:0];
        end
        default: begin end
    endcase
end

// BEGIN OISS_dual_chain_hybrid.vh
// Exact dual-chain scheduler: fixed suffix tree, bounded merge, small prefix trees.
// A and B are dependency chains. A is the longer group. All latencies are 1..50.

// Fixed suffix depth 1.

// Fixed suffix depth 2.
wire [6:0] d4_AA_sum = A_rev_lat[0] + A_rev_lat[1];
wire [6:0] d4_AB_dep = 1'b0 + A_rev_lat[0];
wire [6:0] d4_AB_issue = B_rev_lat[0] + 7'd1;
wire [6:0] d4_AB_head = (d4_AB_dep >= d4_AB_issue) ? d4_AB_dep : d4_AB_issue;
wire [6:0] d4_BA_dep = 1'b0 + B_rev_lat[0];
wire [6:0] d4_BA_issue = A_rev_lat[0] + 7'd1;
wire [6:0] d4_BA_head = (d4_BA_dep >= d4_BA_issue) ? d4_BA_dep : d4_BA_issue;
wire [6:0] d4_BB_sum = B_rev_lat[0] + B_rev_lat[1];

// Fixed suffix depth 3.
wire [7:0] d4_AAA_sum = d4_AA_sum + A_rev_lat[2];
wire [7:0] d4_AAB_sum = d4_AB_head + A_rev_lat[1];
wire [7:0] d4_ABA_dep = A_rev_lat[0] + A_rev_lat[1];
wire [7:0] d4_ABA_issue = d4_BA_head + 8'd1;
wire [7:0] d4_ABA_head = (d4_ABA_dep >= d4_ABA_issue) ? d4_ABA_dep : d4_ABA_issue;
wire [7:0] d4_ABB_dep = 1'b0 + A_rev_lat[0];
wire [7:0] d4_ABB_issue = d4_BB_sum + 8'd1;
wire [7:0] d4_ABB_head = (d4_ABB_dep >= d4_ABB_issue) ? d4_ABB_dep : d4_ABB_issue;
wire [7:0] d4_BAA_dep = 1'b0 + B_rev_lat[0];
wire [7:0] d4_BAA_issue = d4_AA_sum + 8'd1;
wire [7:0] d4_BAA_head = (d4_BAA_dep >= d4_BAA_issue) ? d4_BAA_dep : d4_BAA_issue;
wire [7:0] d4_BAB_dep = B_rev_lat[0] + B_rev_lat[1];
wire [7:0] d4_BAB_issue = d4_AB_head + 8'd1;
wire [7:0] d4_BAB_head = (d4_BAB_dep >= d4_BAB_issue) ? d4_BAB_dep : d4_BAB_issue;
wire [7:0] d4_BBA_sum = d4_BA_head + B_rev_lat[1];
wire [7:0] d4_BBB_sum = d4_BB_sum + B_rev_lat[2];

// Fixed suffix depth 4.
wire [7:0] d4_AAAA_sum = d4_AAA_sum + A_rev_lat[3];
wire [7:0] d4_AAAB_sum = d4_AAB_sum + A_rev_lat[2];
wire [7:0] d4_AABA_sum = d4_ABA_head + A_rev_lat[2];
wire [7:0] d4_AABB_sum = d4_ABB_head + A_rev_lat[1];
wire [7:0] d4_ABAA_dep = d4_AA_sum + A_rev_lat[2];
wire [7:0] d4_ABAA_issue = d4_BAA_head + 8'd1;
wire [7:0] d4_ABAA_head = (d4_ABAA_dep >= d4_ABAA_issue) ? d4_ABAA_dep : d4_ABAA_issue;
wire [7:0] d4_ABAB_dep = d4_AB_head + A_rev_lat[1];
wire [7:0] d4_ABAB_issue = d4_BAB_head + 8'd1;
wire [7:0] d4_ABAB_head = (d4_ABAB_dep >= d4_ABAB_issue) ? d4_ABAB_dep : d4_ABAB_issue;
wire [7:0] d4_ABBA_dep = A_rev_lat[0] + A_rev_lat[1];
wire [7:0] d4_ABBA_issue = d4_BBA_sum + 8'd1;
wire [7:0] d4_ABBA_head = (d4_ABBA_dep >= d4_ABBA_issue) ? d4_ABBA_dep : d4_ABBA_issue;
wire [7:0] d4_ABBB_dep = 1'b0 + A_rev_lat[0];
wire [7:0] d4_ABBB_issue = d4_BBB_sum + 8'd1;
wire [7:0] d4_ABBB_head = (d4_ABBB_dep >= d4_ABBB_issue) ? d4_ABBB_dep : d4_ABBB_issue;
wire [7:0] d4_BAAA_dep = 1'b0 + B_rev_lat[0];
wire [7:0] d4_BAAA_issue = d4_AAA_sum + 8'd1;
wire [7:0] d4_BAAA_head = (d4_BAAA_dep >= d4_BAAA_issue) ? d4_BAAA_dep : d4_BAAA_issue;
wire [7:0] d4_BAAB_dep = B_rev_lat[0] + B_rev_lat[1];
wire [7:0] d4_BAAB_issue = d4_AAB_sum + 8'd1;
wire [7:0] d4_BAAB_head = (d4_BAAB_dep >= d4_BAAB_issue) ? d4_BAAB_dep : d4_BAAB_issue;
wire [7:0] d4_BABA_dep = d4_BA_head + B_rev_lat[1];
wire [7:0] d4_BABA_issue = d4_ABA_head + 8'd1;
wire [7:0] d4_BABA_head = (d4_BABA_dep >= d4_BABA_issue) ? d4_BABA_dep : d4_BABA_issue;
wire [7:0] d4_BABB_dep = d4_BB_sum + B_rev_lat[2];
wire [7:0] d4_BABB_issue = d4_ABB_head + 8'd1;
wire [7:0] d4_BABB_head = (d4_BABB_dep >= d4_BABB_issue) ? d4_BABB_dep : d4_BABB_issue;
wire [7:0] d4_BBAA_sum = d4_BAA_head + B_rev_lat[1];
wire [7:0] d4_BBAB_sum = d4_BAB_head + B_rev_lat[2];
wire [7:0] d4_BBBA_sum = d4_BBA_sum + B_rev_lat[2];
wire [7:0] d4_BBBB_sum = d4_BBB_sum + B_rev_lat[3];
wire [0:0] d4_sa_0 = 1'b0;
wire [7:0] d4_sa_1 = d4_sa_0 + A_rev_lat[0];
wire [7:0] d4_sa_2 = d4_sa_1 + A_rev_lat[1];
wire [7:0] d4_sa_3 = d4_sa_2 + A_rev_lat[2];
wire [7:0] d4_sa_4 = d4_sa_3 + A_rev_lat[3];
wire [0:0] d4_sb_0 = 1'b0;
wire [7:0] d4_sb_1 = d4_sb_0 + B_rev_lat[0];
wire [7:0] d4_sb_2 = d4_sb_1 + B_rev_lat[1];
wire [7:0] d4_sb_3 = d4_sb_2 + B_rev_lat[2];
wire [7:0] d4_sb_4 = d4_sb_3 + B_rev_lat[3];

// Fixed state slot 0A4B, eB=0.
wire m4_0a4b_eb0_v = 1'b1;
wire [3:0] m4_0a4b_eb0_suffix = 4'b0000;
wire [7:0] m4_0a4b_eb0_ra = 1'b0;
wire [7:0] m4_0a4b_eb0_rb = d4_BBBB_sum;

// Fixed state slot 1A3B, eB=0.
wire [7:0] m4_1a3b_eb0_fixed = d4_sb_3 + 8'd0;
wire [7:0] m4_1a3b_eb0_axis_bound = d4_sb_3 + 8'd1;
wire [7:0] m4_1a3b_eb0_bound = d4_sa_1 + 8'd3;
wire [1:0] m4_1a3b_eb0_ABBB_axis_offset = d4_BBB_sum - d4_sb_3;
wire m4_1a3b_eb0_ABBB_hit = (d4_BBB_sum <= m4_1a3b_eb0_axis_bound) && (d4_ABBB_head <= m4_1a3b_eb0_bound) && (m4_1a3b_eb0_ABBB_axis_offset == 2'd0);
wire [1:0] m4_1a3b_eb0_ABBB_offset = d4_ABBB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb0_BABB_axis_offset = d4_BABB_head - d4_sb_3;
wire m4_1a3b_eb0_BABB_hit = (d4_BABB_head <= m4_1a3b_eb0_axis_bound) && (d4_ABB_head <= m4_1a3b_eb0_bound) && (m4_1a3b_eb0_BABB_axis_offset == 2'd0);
wire [1:0] m4_1a3b_eb0_BABB_offset = d4_ABB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb0_BBAB_axis_offset = d4_BBAB_sum - d4_sb_3;
wire m4_1a3b_eb0_BBAB_hit = (d4_BBAB_sum <= m4_1a3b_eb0_axis_bound) && (d4_AB_head <= m4_1a3b_eb0_bound) && (m4_1a3b_eb0_BBAB_axis_offset == 2'd0);
wire [1:0] m4_1a3b_eb0_BBAB_offset = d4_AB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb0_BBBA_axis_offset = d4_BBBA_sum - d4_sb_3;
wire m4_1a3b_eb0_BBBA_hit = (d4_BBBA_sum <= m4_1a3b_eb0_axis_bound) && (A_rev_lat[0] <= m4_1a3b_eb0_bound) && (m4_1a3b_eb0_BBBA_axis_offset == 2'd0);
wire [1:0] m4_1a3b_eb0_BBBA_offset = A_rev_lat[0] - d4_sa_1;
wire m4_1a3b_eb0_m0_0_pick = m4_1a3b_eb0_ABBB_hit && (!m4_1a3b_eb0_BABB_hit || (m4_1a3b_eb0_ABBB_offset <= m4_1a3b_eb0_BABB_offset));
wire [1:0] m4_1a3b_eb0_m0_0_value = m4_1a3b_eb0_m0_0_pick ? m4_1a3b_eb0_ABBB_offset : m4_1a3b_eb0_BABB_offset;
wire [3:0] m4_1a3b_eb0_m0_0_path = m4_1a3b_eb0_m0_0_pick ? 4'b1000 : 4'b0100;
wire m4_1a3b_eb0_m0_0_v = m4_1a3b_eb0_ABBB_hit || m4_1a3b_eb0_BABB_hit;
wire m4_1a3b_eb0_m0_1_pick = m4_1a3b_eb0_BBAB_hit && (!m4_1a3b_eb0_BBBA_hit || (m4_1a3b_eb0_BBAB_offset <= m4_1a3b_eb0_BBBA_offset));
wire [1:0] m4_1a3b_eb0_m0_1_value = m4_1a3b_eb0_m0_1_pick ? m4_1a3b_eb0_BBAB_offset : m4_1a3b_eb0_BBBA_offset;
wire [3:0] m4_1a3b_eb0_m0_1_path = m4_1a3b_eb0_m0_1_pick ? 4'b0010 : 4'b0001;
wire m4_1a3b_eb0_m0_1_v = m4_1a3b_eb0_BBAB_hit || m4_1a3b_eb0_BBBA_hit;
wire m4_1a3b_eb0_m1_0_pick = m4_1a3b_eb0_m0_0_v && (!m4_1a3b_eb0_m0_1_v || (m4_1a3b_eb0_m0_0_value <= m4_1a3b_eb0_m0_1_value));
wire [1:0] m4_1a3b_eb0_m1_0_value = m4_1a3b_eb0_m1_0_pick ? m4_1a3b_eb0_m0_0_value : m4_1a3b_eb0_m0_1_value;
wire [3:0] m4_1a3b_eb0_m1_0_path = m4_1a3b_eb0_m1_0_pick ? m4_1a3b_eb0_m0_0_path : m4_1a3b_eb0_m0_1_path;
wire m4_1a3b_eb0_m1_0_v = m4_1a3b_eb0_m0_0_v || m4_1a3b_eb0_m0_1_v;
wire [7:0] m4_1a3b_eb0_other = d4_sa_1 + m4_1a3b_eb0_m1_0_value;
wire m4_1a3b_eb0_v = m4_1a3b_eb0_m1_0_v;
wire [3:0] m4_1a3b_eb0_suffix = m4_1a3b_eb0_m1_0_path;
wire [7:0] m4_1a3b_eb0_ra = m4_1a3b_eb0_other;
wire [7:0] m4_1a3b_eb0_rb = m4_1a3b_eb0_fixed;

// Fixed state slot 1A3B, eB=1.
wire [7:0] m4_1a3b_eb1_fixed = d4_sb_3 + 8'd1;
wire [7:0] m4_1a3b_eb1_axis_bound = d4_sb_3 + 8'd1;
wire [7:0] m4_1a3b_eb1_bound = d4_sa_1 + 8'd3;
wire [1:0] m4_1a3b_eb1_ABBB_axis_offset = d4_BBB_sum - d4_sb_3;
wire m4_1a3b_eb1_ABBB_hit = (d4_BBB_sum <= m4_1a3b_eb1_axis_bound) && (d4_ABBB_head <= m4_1a3b_eb1_bound) && (m4_1a3b_eb1_ABBB_axis_offset == 2'd1);
wire [1:0] m4_1a3b_eb1_ABBB_offset = d4_ABBB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb1_BABB_axis_offset = d4_BABB_head - d4_sb_3;
wire m4_1a3b_eb1_BABB_hit = (d4_BABB_head <= m4_1a3b_eb1_axis_bound) && (d4_ABB_head <= m4_1a3b_eb1_bound) && (m4_1a3b_eb1_BABB_axis_offset == 2'd1);
wire [1:0] m4_1a3b_eb1_BABB_offset = d4_ABB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb1_BBAB_axis_offset = d4_BBAB_sum - d4_sb_3;
wire m4_1a3b_eb1_BBAB_hit = (d4_BBAB_sum <= m4_1a3b_eb1_axis_bound) && (d4_AB_head <= m4_1a3b_eb1_bound) && (m4_1a3b_eb1_BBAB_axis_offset == 2'd1);
wire [1:0] m4_1a3b_eb1_BBAB_offset = d4_AB_head - d4_sa_1;
wire [1:0] m4_1a3b_eb1_BBBA_axis_offset = d4_BBBA_sum - d4_sb_3;
wire m4_1a3b_eb1_BBBA_hit = (d4_BBBA_sum <= m4_1a3b_eb1_axis_bound) && (A_rev_lat[0] <= m4_1a3b_eb1_bound) && (m4_1a3b_eb1_BBBA_axis_offset == 2'd1);
wire [1:0] m4_1a3b_eb1_BBBA_offset = A_rev_lat[0] - d4_sa_1;
wire m4_1a3b_eb1_m0_0_pick = m4_1a3b_eb1_ABBB_hit && (!m4_1a3b_eb1_BABB_hit || (m4_1a3b_eb1_ABBB_offset <= m4_1a3b_eb1_BABB_offset));
wire [1:0] m4_1a3b_eb1_m0_0_value = m4_1a3b_eb1_m0_0_pick ? m4_1a3b_eb1_ABBB_offset : m4_1a3b_eb1_BABB_offset;
wire [3:0] m4_1a3b_eb1_m0_0_path = m4_1a3b_eb1_m0_0_pick ? 4'b1000 : 4'b0100;
wire m4_1a3b_eb1_m0_0_v = m4_1a3b_eb1_ABBB_hit || m4_1a3b_eb1_BABB_hit;
wire m4_1a3b_eb1_m0_1_pick = m4_1a3b_eb1_BBAB_hit && (!m4_1a3b_eb1_BBBA_hit || (m4_1a3b_eb1_BBAB_offset <= m4_1a3b_eb1_BBBA_offset));
wire [1:0] m4_1a3b_eb1_m0_1_value = m4_1a3b_eb1_m0_1_pick ? m4_1a3b_eb1_BBAB_offset : m4_1a3b_eb1_BBBA_offset;
wire [3:0] m4_1a3b_eb1_m0_1_path = m4_1a3b_eb1_m0_1_pick ? 4'b0010 : 4'b0001;
wire m4_1a3b_eb1_m0_1_v = m4_1a3b_eb1_BBAB_hit || m4_1a3b_eb1_BBBA_hit;
wire m4_1a3b_eb1_m1_0_pick = m4_1a3b_eb1_m0_0_v && (!m4_1a3b_eb1_m0_1_v || (m4_1a3b_eb1_m0_0_value <= m4_1a3b_eb1_m0_1_value));
wire [1:0] m4_1a3b_eb1_m1_0_value = m4_1a3b_eb1_m1_0_pick ? m4_1a3b_eb1_m0_0_value : m4_1a3b_eb1_m0_1_value;
wire [3:0] m4_1a3b_eb1_m1_0_path = m4_1a3b_eb1_m1_0_pick ? m4_1a3b_eb1_m0_0_path : m4_1a3b_eb1_m0_1_path;
wire m4_1a3b_eb1_m1_0_v = m4_1a3b_eb1_m0_0_v || m4_1a3b_eb1_m0_1_v;
wire [7:0] m4_1a3b_eb1_other = d4_sa_1 + m4_1a3b_eb1_m1_0_value;
wire m4_1a3b_eb1_v = m4_1a3b_eb1_m1_0_v;
wire [3:0] m4_1a3b_eb1_suffix = m4_1a3b_eb1_m1_0_path;
wire [7:0] m4_1a3b_eb1_ra = m4_1a3b_eb1_other;
wire [7:0] m4_1a3b_eb1_rb = m4_1a3b_eb1_fixed;

// Fixed state slot 2A2B, eA=0.
wire [7:0] m4_2a2b_ea0_fixed = d4_sa_2 + 8'd0;
wire [7:0] m4_2a2b_ea0_axis_bound = d4_sa_2 + 8'd2;
wire [7:0] m4_2a2b_ea0_bound = d4_sb_2 + 8'd2;
wire [1:0] m4_2a2b_ea0_AABB_axis_offset = d4_AABB_sum - d4_sa_2;
wire m4_2a2b_ea0_AABB_hit = (d4_AABB_sum <= m4_2a2b_ea0_axis_bound) && (d4_BB_sum <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_AABB_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_AABB_offset = d4_BB_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea0_ABAB_axis_offset = d4_ABAB_head - d4_sa_2;
wire m4_2a2b_ea0_ABAB_hit = (d4_ABAB_head <= m4_2a2b_ea0_axis_bound) && (d4_BAB_head <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_ABAB_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_ABAB_offset = d4_BAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea0_ABBA_axis_offset = d4_ABBA_head - d4_sa_2;
wire m4_2a2b_ea0_ABBA_hit = (d4_ABBA_head <= m4_2a2b_ea0_axis_bound) && (d4_BBA_sum <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_ABBA_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_ABBA_offset = d4_BBA_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea0_BAAB_axis_offset = d4_AAB_sum - d4_sa_2;
wire m4_2a2b_ea0_BAAB_hit = (d4_AAB_sum <= m4_2a2b_ea0_axis_bound) && (d4_BAAB_head <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_BAAB_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_BAAB_offset = d4_BAAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea0_BABA_axis_offset = d4_ABA_head - d4_sa_2;
wire m4_2a2b_ea0_BABA_hit = (d4_ABA_head <= m4_2a2b_ea0_axis_bound) && (d4_BABA_head <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_BABA_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_BABA_offset = d4_BABA_head - d4_sb_2;
wire [1:0] m4_2a2b_ea0_BBAA_axis_offset = d4_AA_sum - d4_sa_2;
wire m4_2a2b_ea0_BBAA_hit = (d4_AA_sum <= m4_2a2b_ea0_axis_bound) && (d4_BBAA_sum <= m4_2a2b_ea0_bound) && (m4_2a2b_ea0_BBAA_axis_offset == 2'd0);
wire [1:0] m4_2a2b_ea0_BBAA_offset = d4_BBAA_sum - d4_sb_2;
wire m4_2a2b_ea0_m0_0_pick = m4_2a2b_ea0_AABB_hit && (!m4_2a2b_ea0_ABAB_hit || (m4_2a2b_ea0_AABB_offset <= m4_2a2b_ea0_ABAB_offset));
wire [1:0] m4_2a2b_ea0_m0_0_value = m4_2a2b_ea0_m0_0_pick ? m4_2a2b_ea0_AABB_offset : m4_2a2b_ea0_ABAB_offset;
wire [3:0] m4_2a2b_ea0_m0_0_path = m4_2a2b_ea0_m0_0_pick ? 4'b1100 : 4'b1010;
wire m4_2a2b_ea0_m0_0_v = m4_2a2b_ea0_AABB_hit || m4_2a2b_ea0_ABAB_hit;
wire m4_2a2b_ea0_m0_1_pick = m4_2a2b_ea0_ABBA_hit && (!m4_2a2b_ea0_BAAB_hit || (m4_2a2b_ea0_ABBA_offset <= m4_2a2b_ea0_BAAB_offset));
wire [1:0] m4_2a2b_ea0_m0_1_value = m4_2a2b_ea0_m0_1_pick ? m4_2a2b_ea0_ABBA_offset : m4_2a2b_ea0_BAAB_offset;
wire [3:0] m4_2a2b_ea0_m0_1_path = m4_2a2b_ea0_m0_1_pick ? 4'b1001 : 4'b0110;
wire m4_2a2b_ea0_m0_1_v = m4_2a2b_ea0_ABBA_hit || m4_2a2b_ea0_BAAB_hit;
wire m4_2a2b_ea0_m0_2_pick = m4_2a2b_ea0_BABA_hit && (!m4_2a2b_ea0_BBAA_hit || (m4_2a2b_ea0_BABA_offset <= m4_2a2b_ea0_BBAA_offset));
wire [1:0] m4_2a2b_ea0_m0_2_value = m4_2a2b_ea0_m0_2_pick ? m4_2a2b_ea0_BABA_offset : m4_2a2b_ea0_BBAA_offset;
wire [3:0] m4_2a2b_ea0_m0_2_path = m4_2a2b_ea0_m0_2_pick ? 4'b0101 : 4'b0011;
wire m4_2a2b_ea0_m0_2_v = m4_2a2b_ea0_BABA_hit || m4_2a2b_ea0_BBAA_hit;
wire m4_2a2b_ea0_m1_0_pick = m4_2a2b_ea0_m0_0_v && (!m4_2a2b_ea0_m0_1_v || (m4_2a2b_ea0_m0_0_value <= m4_2a2b_ea0_m0_1_value));
wire [1:0] m4_2a2b_ea0_m1_0_value = m4_2a2b_ea0_m1_0_pick ? m4_2a2b_ea0_m0_0_value : m4_2a2b_ea0_m0_1_value;
wire [3:0] m4_2a2b_ea0_m1_0_path = m4_2a2b_ea0_m1_0_pick ? m4_2a2b_ea0_m0_0_path : m4_2a2b_ea0_m0_1_path;
wire m4_2a2b_ea0_m1_0_v = m4_2a2b_ea0_m0_0_v || m4_2a2b_ea0_m0_1_v;
wire m4_2a2b_ea0_m2_0_pick = m4_2a2b_ea0_m1_0_v && (!m4_2a2b_ea0_m0_2_v || (m4_2a2b_ea0_m1_0_value <= m4_2a2b_ea0_m0_2_value));
wire [1:0] m4_2a2b_ea0_m2_0_value = m4_2a2b_ea0_m2_0_pick ? m4_2a2b_ea0_m1_0_value : m4_2a2b_ea0_m0_2_value;
wire [3:0] m4_2a2b_ea0_m2_0_path = m4_2a2b_ea0_m2_0_pick ? m4_2a2b_ea0_m1_0_path : m4_2a2b_ea0_m0_2_path;
wire m4_2a2b_ea0_m2_0_v = m4_2a2b_ea0_m1_0_v || m4_2a2b_ea0_m0_2_v;
wire [7:0] m4_2a2b_ea0_other = d4_sb_2 + m4_2a2b_ea0_m2_0_value;
wire m4_2a2b_ea0_v = m4_2a2b_ea0_m2_0_v;
wire [3:0] m4_2a2b_ea0_suffix = m4_2a2b_ea0_m2_0_path;
wire [7:0] m4_2a2b_ea0_ra = m4_2a2b_ea0_fixed;
wire [7:0] m4_2a2b_ea0_rb = m4_2a2b_ea0_other;

// Fixed state slot 2A2B, eA=1.
wire [7:0] m4_2a2b_ea1_fixed = d4_sa_2 + 8'd1;
wire [7:0] m4_2a2b_ea1_axis_bound = d4_sa_2 + 8'd2;
wire [7:0] m4_2a2b_ea1_bound = d4_sb_2 + 8'd2;
wire [1:0] m4_2a2b_ea1_AABB_axis_offset = d4_AABB_sum - d4_sa_2;
wire m4_2a2b_ea1_AABB_hit = (d4_AABB_sum <= m4_2a2b_ea1_axis_bound) && (d4_BB_sum <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_AABB_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_AABB_offset = d4_BB_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea1_ABAB_axis_offset = d4_ABAB_head - d4_sa_2;
wire m4_2a2b_ea1_ABAB_hit = (d4_ABAB_head <= m4_2a2b_ea1_axis_bound) && (d4_BAB_head <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_ABAB_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_ABAB_offset = d4_BAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea1_ABBA_axis_offset = d4_ABBA_head - d4_sa_2;
wire m4_2a2b_ea1_ABBA_hit = (d4_ABBA_head <= m4_2a2b_ea1_axis_bound) && (d4_BBA_sum <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_ABBA_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_ABBA_offset = d4_BBA_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea1_BAAB_axis_offset = d4_AAB_sum - d4_sa_2;
wire m4_2a2b_ea1_BAAB_hit = (d4_AAB_sum <= m4_2a2b_ea1_axis_bound) && (d4_BAAB_head <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_BAAB_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_BAAB_offset = d4_BAAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea1_BABA_axis_offset = d4_ABA_head - d4_sa_2;
wire m4_2a2b_ea1_BABA_hit = (d4_ABA_head <= m4_2a2b_ea1_axis_bound) && (d4_BABA_head <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_BABA_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_BABA_offset = d4_BABA_head - d4_sb_2;
wire [1:0] m4_2a2b_ea1_BBAA_axis_offset = d4_AA_sum - d4_sa_2;
wire m4_2a2b_ea1_BBAA_hit = (d4_AA_sum <= m4_2a2b_ea1_axis_bound) && (d4_BBAA_sum <= m4_2a2b_ea1_bound) && (m4_2a2b_ea1_BBAA_axis_offset == 2'd1);
wire [1:0] m4_2a2b_ea1_BBAA_offset = d4_BBAA_sum - d4_sb_2;
wire m4_2a2b_ea1_m0_0_pick = m4_2a2b_ea1_AABB_hit && (!m4_2a2b_ea1_ABAB_hit || (m4_2a2b_ea1_AABB_offset <= m4_2a2b_ea1_ABAB_offset));
wire [1:0] m4_2a2b_ea1_m0_0_value = m4_2a2b_ea1_m0_0_pick ? m4_2a2b_ea1_AABB_offset : m4_2a2b_ea1_ABAB_offset;
wire [3:0] m4_2a2b_ea1_m0_0_path = m4_2a2b_ea1_m0_0_pick ? 4'b1100 : 4'b1010;
wire m4_2a2b_ea1_m0_0_v = m4_2a2b_ea1_AABB_hit || m4_2a2b_ea1_ABAB_hit;
wire m4_2a2b_ea1_m0_1_pick = m4_2a2b_ea1_ABBA_hit && (!m4_2a2b_ea1_BAAB_hit || (m4_2a2b_ea1_ABBA_offset <= m4_2a2b_ea1_BAAB_offset));
wire [1:0] m4_2a2b_ea1_m0_1_value = m4_2a2b_ea1_m0_1_pick ? m4_2a2b_ea1_ABBA_offset : m4_2a2b_ea1_BAAB_offset;
wire [3:0] m4_2a2b_ea1_m0_1_path = m4_2a2b_ea1_m0_1_pick ? 4'b1001 : 4'b0110;
wire m4_2a2b_ea1_m0_1_v = m4_2a2b_ea1_ABBA_hit || m4_2a2b_ea1_BAAB_hit;
wire m4_2a2b_ea1_m0_2_pick = m4_2a2b_ea1_BABA_hit && (!m4_2a2b_ea1_BBAA_hit || (m4_2a2b_ea1_BABA_offset <= m4_2a2b_ea1_BBAA_offset));
wire [1:0] m4_2a2b_ea1_m0_2_value = m4_2a2b_ea1_m0_2_pick ? m4_2a2b_ea1_BABA_offset : m4_2a2b_ea1_BBAA_offset;
wire [3:0] m4_2a2b_ea1_m0_2_path = m4_2a2b_ea1_m0_2_pick ? 4'b0101 : 4'b0011;
wire m4_2a2b_ea1_m0_2_v = m4_2a2b_ea1_BABA_hit || m4_2a2b_ea1_BBAA_hit;
wire m4_2a2b_ea1_m1_0_pick = m4_2a2b_ea1_m0_0_v && (!m4_2a2b_ea1_m0_1_v || (m4_2a2b_ea1_m0_0_value <= m4_2a2b_ea1_m0_1_value));
wire [1:0] m4_2a2b_ea1_m1_0_value = m4_2a2b_ea1_m1_0_pick ? m4_2a2b_ea1_m0_0_value : m4_2a2b_ea1_m0_1_value;
wire [3:0] m4_2a2b_ea1_m1_0_path = m4_2a2b_ea1_m1_0_pick ? m4_2a2b_ea1_m0_0_path : m4_2a2b_ea1_m0_1_path;
wire m4_2a2b_ea1_m1_0_v = m4_2a2b_ea1_m0_0_v || m4_2a2b_ea1_m0_1_v;
wire m4_2a2b_ea1_m2_0_pick = m4_2a2b_ea1_m1_0_v && (!m4_2a2b_ea1_m0_2_v || (m4_2a2b_ea1_m1_0_value <= m4_2a2b_ea1_m0_2_value));
wire [1:0] m4_2a2b_ea1_m2_0_value = m4_2a2b_ea1_m2_0_pick ? m4_2a2b_ea1_m1_0_value : m4_2a2b_ea1_m0_2_value;
wire [3:0] m4_2a2b_ea1_m2_0_path = m4_2a2b_ea1_m2_0_pick ? m4_2a2b_ea1_m1_0_path : m4_2a2b_ea1_m0_2_path;
wire m4_2a2b_ea1_m2_0_v = m4_2a2b_ea1_m1_0_v || m4_2a2b_ea1_m0_2_v;
wire [7:0] m4_2a2b_ea1_other = d4_sb_2 + m4_2a2b_ea1_m2_0_value;
wire m4_2a2b_ea1_v = m4_2a2b_ea1_m2_0_v;
wire [3:0] m4_2a2b_ea1_suffix = m4_2a2b_ea1_m2_0_path;
wire [7:0] m4_2a2b_ea1_ra = m4_2a2b_ea1_fixed;
wire [7:0] m4_2a2b_ea1_rb = m4_2a2b_ea1_other;

// Fixed state slot 2A2B, eA=2.
wire [7:0] m4_2a2b_ea2_fixed = d4_sa_2 + 8'd2;
wire [7:0] m4_2a2b_ea2_axis_bound = d4_sa_2 + 8'd2;
wire [7:0] m4_2a2b_ea2_bound = d4_sb_2 + 8'd2;
wire [1:0] m4_2a2b_ea2_AABB_axis_offset = d4_AABB_sum - d4_sa_2;
wire m4_2a2b_ea2_AABB_hit = (d4_AABB_sum <= m4_2a2b_ea2_axis_bound) && (d4_BB_sum <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_AABB_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_AABB_offset = d4_BB_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea2_ABAB_axis_offset = d4_ABAB_head - d4_sa_2;
wire m4_2a2b_ea2_ABAB_hit = (d4_ABAB_head <= m4_2a2b_ea2_axis_bound) && (d4_BAB_head <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_ABAB_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_ABAB_offset = d4_BAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea2_ABBA_axis_offset = d4_ABBA_head - d4_sa_2;
wire m4_2a2b_ea2_ABBA_hit = (d4_ABBA_head <= m4_2a2b_ea2_axis_bound) && (d4_BBA_sum <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_ABBA_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_ABBA_offset = d4_BBA_sum - d4_sb_2;
wire [1:0] m4_2a2b_ea2_BAAB_axis_offset = d4_AAB_sum - d4_sa_2;
wire m4_2a2b_ea2_BAAB_hit = (d4_AAB_sum <= m4_2a2b_ea2_axis_bound) && (d4_BAAB_head <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_BAAB_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_BAAB_offset = d4_BAAB_head - d4_sb_2;
wire [1:0] m4_2a2b_ea2_BABA_axis_offset = d4_ABA_head - d4_sa_2;
wire m4_2a2b_ea2_BABA_hit = (d4_ABA_head <= m4_2a2b_ea2_axis_bound) && (d4_BABA_head <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_BABA_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_BABA_offset = d4_BABA_head - d4_sb_2;
wire [1:0] m4_2a2b_ea2_BBAA_axis_offset = d4_AA_sum - d4_sa_2;
wire m4_2a2b_ea2_BBAA_hit = (d4_AA_sum <= m4_2a2b_ea2_axis_bound) && (d4_BBAA_sum <= m4_2a2b_ea2_bound) && (m4_2a2b_ea2_BBAA_axis_offset == 2'd2);
wire [1:0] m4_2a2b_ea2_BBAA_offset = d4_BBAA_sum - d4_sb_2;
wire m4_2a2b_ea2_m0_0_pick = m4_2a2b_ea2_AABB_hit && (!m4_2a2b_ea2_ABAB_hit || (m4_2a2b_ea2_AABB_offset <= m4_2a2b_ea2_ABAB_offset));
wire [1:0] m4_2a2b_ea2_m0_0_value = m4_2a2b_ea2_m0_0_pick ? m4_2a2b_ea2_AABB_offset : m4_2a2b_ea2_ABAB_offset;
wire [3:0] m4_2a2b_ea2_m0_0_path = m4_2a2b_ea2_m0_0_pick ? 4'b1100 : 4'b1010;
wire m4_2a2b_ea2_m0_0_v = m4_2a2b_ea2_AABB_hit || m4_2a2b_ea2_ABAB_hit;
wire m4_2a2b_ea2_m0_1_pick = m4_2a2b_ea2_ABBA_hit && (!m4_2a2b_ea2_BAAB_hit || (m4_2a2b_ea2_ABBA_offset <= m4_2a2b_ea2_BAAB_offset));
wire [1:0] m4_2a2b_ea2_m0_1_value = m4_2a2b_ea2_m0_1_pick ? m4_2a2b_ea2_ABBA_offset : m4_2a2b_ea2_BAAB_offset;
wire [3:0] m4_2a2b_ea2_m0_1_path = m4_2a2b_ea2_m0_1_pick ? 4'b1001 : 4'b0110;
wire m4_2a2b_ea2_m0_1_v = m4_2a2b_ea2_ABBA_hit || m4_2a2b_ea2_BAAB_hit;
wire m4_2a2b_ea2_m0_2_pick = m4_2a2b_ea2_BABA_hit && (!m4_2a2b_ea2_BBAA_hit || (m4_2a2b_ea2_BABA_offset <= m4_2a2b_ea2_BBAA_offset));
wire [1:0] m4_2a2b_ea2_m0_2_value = m4_2a2b_ea2_m0_2_pick ? m4_2a2b_ea2_BABA_offset : m4_2a2b_ea2_BBAA_offset;
wire [3:0] m4_2a2b_ea2_m0_2_path = m4_2a2b_ea2_m0_2_pick ? 4'b0101 : 4'b0011;
wire m4_2a2b_ea2_m0_2_v = m4_2a2b_ea2_BABA_hit || m4_2a2b_ea2_BBAA_hit;
wire m4_2a2b_ea2_m1_0_pick = m4_2a2b_ea2_m0_0_v && (!m4_2a2b_ea2_m0_1_v || (m4_2a2b_ea2_m0_0_value <= m4_2a2b_ea2_m0_1_value));
wire [1:0] m4_2a2b_ea2_m1_0_value = m4_2a2b_ea2_m1_0_pick ? m4_2a2b_ea2_m0_0_value : m4_2a2b_ea2_m0_1_value;
wire [3:0] m4_2a2b_ea2_m1_0_path = m4_2a2b_ea2_m1_0_pick ? m4_2a2b_ea2_m0_0_path : m4_2a2b_ea2_m0_1_path;
wire m4_2a2b_ea2_m1_0_v = m4_2a2b_ea2_m0_0_v || m4_2a2b_ea2_m0_1_v;
wire m4_2a2b_ea2_m2_0_pick = m4_2a2b_ea2_m1_0_v && (!m4_2a2b_ea2_m0_2_v || (m4_2a2b_ea2_m1_0_value <= m4_2a2b_ea2_m0_2_value));
wire [1:0] m4_2a2b_ea2_m2_0_value = m4_2a2b_ea2_m2_0_pick ? m4_2a2b_ea2_m1_0_value : m4_2a2b_ea2_m0_2_value;
wire [3:0] m4_2a2b_ea2_m2_0_path = m4_2a2b_ea2_m2_0_pick ? m4_2a2b_ea2_m1_0_path : m4_2a2b_ea2_m0_2_path;
wire m4_2a2b_ea2_m2_0_v = m4_2a2b_ea2_m1_0_v || m4_2a2b_ea2_m0_2_v;
wire [7:0] m4_2a2b_ea2_other = d4_sb_2 + m4_2a2b_ea2_m2_0_value;
wire m4_2a2b_ea2_v = m4_2a2b_ea2_m2_0_v;
wire [3:0] m4_2a2b_ea2_suffix = m4_2a2b_ea2_m2_0_path;
wire [7:0] m4_2a2b_ea2_ra = m4_2a2b_ea2_fixed;
wire [7:0] m4_2a2b_ea2_rb = m4_2a2b_ea2_other;

// Fixed state slot 3A1B, eA=0.
wire [7:0] m4_3a1b_ea0_fixed = d4_sa_3 + 8'd0;
wire [7:0] m4_3a1b_ea0_axis_bound = d4_sa_3 + 8'd1;
wire [7:0] m4_3a1b_ea0_bound = d4_sb_1 + 8'd3;
wire [1:0] m4_3a1b_ea0_AAAB_axis_offset = d4_AAAB_sum - d4_sa_3;
wire m4_3a1b_ea0_AAAB_hit = (d4_AAAB_sum <= m4_3a1b_ea0_axis_bound) && (B_rev_lat[0] <= m4_3a1b_ea0_bound) && (m4_3a1b_ea0_AAAB_axis_offset == 2'd0);
wire [1:0] m4_3a1b_ea0_AAAB_offset = B_rev_lat[0] - d4_sb_1;
wire [1:0] m4_3a1b_ea0_AABA_axis_offset = d4_AABA_sum - d4_sa_3;
wire m4_3a1b_ea0_AABA_hit = (d4_AABA_sum <= m4_3a1b_ea0_axis_bound) && (d4_BA_head <= m4_3a1b_ea0_bound) && (m4_3a1b_ea0_AABA_axis_offset == 2'd0);
wire [1:0] m4_3a1b_ea0_AABA_offset = d4_BA_head - d4_sb_1;
wire [1:0] m4_3a1b_ea0_ABAA_axis_offset = d4_ABAA_head - d4_sa_3;
wire m4_3a1b_ea0_ABAA_hit = (d4_ABAA_head <= m4_3a1b_ea0_axis_bound) && (d4_BAA_head <= m4_3a1b_ea0_bound) && (m4_3a1b_ea0_ABAA_axis_offset == 2'd0);
wire [1:0] m4_3a1b_ea0_ABAA_offset = d4_BAA_head - d4_sb_1;
wire [1:0] m4_3a1b_ea0_BAAA_axis_offset = d4_AAA_sum - d4_sa_3;
wire m4_3a1b_ea0_BAAA_hit = (d4_AAA_sum <= m4_3a1b_ea0_axis_bound) && (d4_BAAA_head <= m4_3a1b_ea0_bound) && (m4_3a1b_ea0_BAAA_axis_offset == 2'd0);
wire [1:0] m4_3a1b_ea0_BAAA_offset = d4_BAAA_head - d4_sb_1;
wire m4_3a1b_ea0_m0_0_pick = m4_3a1b_ea0_AAAB_hit && (!m4_3a1b_ea0_AABA_hit || (m4_3a1b_ea0_AAAB_offset <= m4_3a1b_ea0_AABA_offset));
wire [1:0] m4_3a1b_ea0_m0_0_value = m4_3a1b_ea0_m0_0_pick ? m4_3a1b_ea0_AAAB_offset : m4_3a1b_ea0_AABA_offset;
wire [3:0] m4_3a1b_ea0_m0_0_path = m4_3a1b_ea0_m0_0_pick ? 4'b1110 : 4'b1101;
wire m4_3a1b_ea0_m0_0_v = m4_3a1b_ea0_AAAB_hit || m4_3a1b_ea0_AABA_hit;
wire m4_3a1b_ea0_m0_1_pick = m4_3a1b_ea0_ABAA_hit && (!m4_3a1b_ea0_BAAA_hit || (m4_3a1b_ea0_ABAA_offset <= m4_3a1b_ea0_BAAA_offset));
wire [1:0] m4_3a1b_ea0_m0_1_value = m4_3a1b_ea0_m0_1_pick ? m4_3a1b_ea0_ABAA_offset : m4_3a1b_ea0_BAAA_offset;
wire [3:0] m4_3a1b_ea0_m0_1_path = m4_3a1b_ea0_m0_1_pick ? 4'b1011 : 4'b0111;
wire m4_3a1b_ea0_m0_1_v = m4_3a1b_ea0_ABAA_hit || m4_3a1b_ea0_BAAA_hit;
wire m4_3a1b_ea0_m1_0_pick = m4_3a1b_ea0_m0_0_v && (!m4_3a1b_ea0_m0_1_v || (m4_3a1b_ea0_m0_0_value <= m4_3a1b_ea0_m0_1_value));
wire [1:0] m4_3a1b_ea0_m1_0_value = m4_3a1b_ea0_m1_0_pick ? m4_3a1b_ea0_m0_0_value : m4_3a1b_ea0_m0_1_value;
wire [3:0] m4_3a1b_ea0_m1_0_path = m4_3a1b_ea0_m1_0_pick ? m4_3a1b_ea0_m0_0_path : m4_3a1b_ea0_m0_1_path;
wire m4_3a1b_ea0_m1_0_v = m4_3a1b_ea0_m0_0_v || m4_3a1b_ea0_m0_1_v;
wire [7:0] m4_3a1b_ea0_other = d4_sb_1 + m4_3a1b_ea0_m1_0_value;
wire m4_3a1b_ea0_v = m4_3a1b_ea0_m1_0_v;
wire [3:0] m4_3a1b_ea0_suffix = m4_3a1b_ea0_m1_0_path;
wire [7:0] m4_3a1b_ea0_ra = m4_3a1b_ea0_fixed;
wire [7:0] m4_3a1b_ea0_rb = m4_3a1b_ea0_other;

// Fixed state slot 3A1B, eA=1.
wire [7:0] m4_3a1b_ea1_fixed = d4_sa_3 + 8'd1;
wire [7:0] m4_3a1b_ea1_axis_bound = d4_sa_3 + 8'd1;
wire [7:0] m4_3a1b_ea1_bound = d4_sb_1 + 8'd3;
wire [1:0] m4_3a1b_ea1_AAAB_axis_offset = d4_AAAB_sum - d4_sa_3;
wire m4_3a1b_ea1_AAAB_hit = (d4_AAAB_sum <= m4_3a1b_ea1_axis_bound) && (B_rev_lat[0] <= m4_3a1b_ea1_bound) && (m4_3a1b_ea1_AAAB_axis_offset == 2'd1);
wire [1:0] m4_3a1b_ea1_AAAB_offset = B_rev_lat[0] - d4_sb_1;
wire [1:0] m4_3a1b_ea1_AABA_axis_offset = d4_AABA_sum - d4_sa_3;
wire m4_3a1b_ea1_AABA_hit = (d4_AABA_sum <= m4_3a1b_ea1_axis_bound) && (d4_BA_head <= m4_3a1b_ea1_bound) && (m4_3a1b_ea1_AABA_axis_offset == 2'd1);
wire [1:0] m4_3a1b_ea1_AABA_offset = d4_BA_head - d4_sb_1;
wire [1:0] m4_3a1b_ea1_ABAA_axis_offset = d4_ABAA_head - d4_sa_3;
wire m4_3a1b_ea1_ABAA_hit = (d4_ABAA_head <= m4_3a1b_ea1_axis_bound) && (d4_BAA_head <= m4_3a1b_ea1_bound) && (m4_3a1b_ea1_ABAA_axis_offset == 2'd1);
wire [1:0] m4_3a1b_ea1_ABAA_offset = d4_BAA_head - d4_sb_1;
wire [1:0] m4_3a1b_ea1_BAAA_axis_offset = d4_AAA_sum - d4_sa_3;
wire m4_3a1b_ea1_BAAA_hit = (d4_AAA_sum <= m4_3a1b_ea1_axis_bound) && (d4_BAAA_head <= m4_3a1b_ea1_bound) && (m4_3a1b_ea1_BAAA_axis_offset == 2'd1);
wire [1:0] m4_3a1b_ea1_BAAA_offset = d4_BAAA_head - d4_sb_1;
wire m4_3a1b_ea1_m0_0_pick = m4_3a1b_ea1_AAAB_hit && (!m4_3a1b_ea1_AABA_hit || (m4_3a1b_ea1_AAAB_offset <= m4_3a1b_ea1_AABA_offset));
wire [1:0] m4_3a1b_ea1_m0_0_value = m4_3a1b_ea1_m0_0_pick ? m4_3a1b_ea1_AAAB_offset : m4_3a1b_ea1_AABA_offset;
wire [3:0] m4_3a1b_ea1_m0_0_path = m4_3a1b_ea1_m0_0_pick ? 4'b1110 : 4'b1101;
wire m4_3a1b_ea1_m0_0_v = m4_3a1b_ea1_AAAB_hit || m4_3a1b_ea1_AABA_hit;
wire m4_3a1b_ea1_m0_1_pick = m4_3a1b_ea1_ABAA_hit && (!m4_3a1b_ea1_BAAA_hit || (m4_3a1b_ea1_ABAA_offset <= m4_3a1b_ea1_BAAA_offset));
wire [1:0] m4_3a1b_ea1_m0_1_value = m4_3a1b_ea1_m0_1_pick ? m4_3a1b_ea1_ABAA_offset : m4_3a1b_ea1_BAAA_offset;
wire [3:0] m4_3a1b_ea1_m0_1_path = m4_3a1b_ea1_m0_1_pick ? 4'b1011 : 4'b0111;
wire m4_3a1b_ea1_m0_1_v = m4_3a1b_ea1_ABAA_hit || m4_3a1b_ea1_BAAA_hit;
wire m4_3a1b_ea1_m1_0_pick = m4_3a1b_ea1_m0_0_v && (!m4_3a1b_ea1_m0_1_v || (m4_3a1b_ea1_m0_0_value <= m4_3a1b_ea1_m0_1_value));
wire [1:0] m4_3a1b_ea1_m1_0_value = m4_3a1b_ea1_m1_0_pick ? m4_3a1b_ea1_m0_0_value : m4_3a1b_ea1_m0_1_value;
wire [3:0] m4_3a1b_ea1_m1_0_path = m4_3a1b_ea1_m1_0_pick ? m4_3a1b_ea1_m0_0_path : m4_3a1b_ea1_m0_1_path;
wire m4_3a1b_ea1_m1_0_v = m4_3a1b_ea1_m0_0_v || m4_3a1b_ea1_m0_1_v;
wire [7:0] m4_3a1b_ea1_other = d4_sb_1 + m4_3a1b_ea1_m1_0_value;
wire m4_3a1b_ea1_v = m4_3a1b_ea1_m1_0_v;
wire [3:0] m4_3a1b_ea1_suffix = m4_3a1b_ea1_m1_0_path;
wire [7:0] m4_3a1b_ea1_ra = m4_3a1b_ea1_fixed;
wire [7:0] m4_3a1b_ea1_rb = m4_3a1b_ea1_other;

// Fixed state slot 4A0B, eA=0.
wire m4_4a0b_ea0_v = 1'b1;
wire [3:0] m4_4a0b_ea0_suffix = 4'b1111;
wire [7:0] m4_4a0b_ea0_ra = d4_AAAA_sum;
wire [7:0] m4_4a0b_ea0_rb = 1'b0;

// Shared continuation for m4_0a4b_eb0; suffix selection is outside this tree.
wire [7:0] t_0a4b_eb0_A_dep = m4_0a4b_eb0_ra + A_rev_lat[0];
wire [7:0] t_0a4b_eb0_A_issue = m4_0a4b_eb0_rb + 8'd1;
wire [7:0] t_0a4b_eb0_A_head = (t_0a4b_eb0_A_dep >= t_0a4b_eb0_A_issue) ? t_0a4b_eb0_A_dep : t_0a4b_eb0_A_issue;
wire [8:0] t_0a4b_eb0_AA_dep = t_0a4b_eb0_A_head + A_rev_lat[1];
wire [8:0] t_0a4b_eb0_AAA_dep = t_0a4b_eb0_AA_dep + A_rev_lat[2];
wire [8:0] t_0a4b_eb0_AAAA_dep = t_0a4b_eb0_AAA_dep + A_rev_lat[3];
wire [8:0] t_0a4b_eb0_AAAA_cycle = (B_len == 3'd4) ? t_0a4b_eb0_AAAA_dep : 9'd511;
wire [8:0] m4_0a4b_eb0_cycle = m4_0a4b_eb0_v ? t_0a4b_eb0_AAAA_cycle : 9'd511;
wire [7:0] m4_0a4b_eb0_path = {4'b1111, m4_0a4b_eb0_suffix};

// Shared continuation for m4_1a3b_eb0; suffix selection is outside this tree.
wire [7:0] t_1a3b_eb0_A_dep = m4_1a3b_eb0_ra + A_rev_lat[1];
wire [7:0] t_1a3b_eb0_A_issue = m4_1a3b_eb0_rb + 8'd1;
wire [7:0] t_1a3b_eb0_A_head = (t_1a3b_eb0_A_dep >= t_1a3b_eb0_A_issue) ? t_1a3b_eb0_A_dep : t_1a3b_eb0_A_issue;
wire [7:0] t_1a3b_eb0_B_dep = m4_1a3b_eb0_rb + B_rev_lat[3];
wire [7:0] t_1a3b_eb0_B_issue = m4_1a3b_eb0_ra + 8'd1;
wire [7:0] t_1a3b_eb0_B_head = (t_1a3b_eb0_B_dep >= t_1a3b_eb0_B_issue) ? t_1a3b_eb0_B_dep : t_1a3b_eb0_B_issue;
wire [8:0] t_1a3b_eb0_AA_dep = t_1a3b_eb0_A_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb0_AB_dep = m4_1a3b_eb0_ra + A_rev_lat[1];
wire [8:0] t_1a3b_eb0_AB_issue = t_1a3b_eb0_B_head + 9'd1;
wire [8:0] t_1a3b_eb0_AB_head = (t_1a3b_eb0_AB_dep >= t_1a3b_eb0_AB_issue) ? t_1a3b_eb0_AB_dep : t_1a3b_eb0_AB_issue;
wire [8:0] t_1a3b_eb0_BA_dep = m4_1a3b_eb0_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb0_BA_issue = t_1a3b_eb0_A_head + 9'd1;
wire [8:0] t_1a3b_eb0_BA_head = (t_1a3b_eb0_BA_dep >= t_1a3b_eb0_BA_issue) ? t_1a3b_eb0_BA_dep : t_1a3b_eb0_BA_issue;
wire [8:0] t_1a3b_eb0_AAA_dep = t_1a3b_eb0_AA_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb0_AAB_dep = t_1a3b_eb0_AB_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb0_ABA_dep = t_1a3b_eb0_A_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb0_ABA_issue = t_1a3b_eb0_BA_head + 9'd1;
wire [8:0] t_1a3b_eb0_ABA_head = (t_1a3b_eb0_ABA_dep >= t_1a3b_eb0_ABA_issue) ? t_1a3b_eb0_ABA_dep : t_1a3b_eb0_ABA_issue;
wire [8:0] t_1a3b_eb0_BAA_dep = m4_1a3b_eb0_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb0_BAA_issue = t_1a3b_eb0_AA_dep + 9'd1;
wire [8:0] t_1a3b_eb0_BAA_head = (t_1a3b_eb0_BAA_dep >= t_1a3b_eb0_BAA_issue) ? t_1a3b_eb0_BAA_dep : t_1a3b_eb0_BAA_issue;
wire [8:0] t_1a3b_eb0_AAAA_dep = t_1a3b_eb0_AAA_dep + A_rev_lat[4];
wire [8:0] t_1a3b_eb0_AAAA_cycle = (B_len == 3'd3) ? t_1a3b_eb0_AAAA_dep : 9'd511;
wire [8:0] t_1a3b_eb0_AAAB_dep = t_1a3b_eb0_AAB_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb0_AAAB_cycle = (B_len == 3'd4) ? t_1a3b_eb0_AAAB_dep : 9'd511;
wire [8:0] t_1a3b_eb0_AABA_dep = t_1a3b_eb0_ABA_head + A_rev_lat[3];
wire [8:0] t_1a3b_eb0_AABA_cycle = (B_len == 3'd4) ? t_1a3b_eb0_AABA_dep : 9'd511;
wire [8:0] t_1a3b_eb0_ABAA_dep = t_1a3b_eb0_AA_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb0_ABAA_issue = t_1a3b_eb0_BAA_head + 9'd1;
wire [8:0] t_1a3b_eb0_ABAA_head = (t_1a3b_eb0_ABAA_dep >= t_1a3b_eb0_ABAA_issue) ? t_1a3b_eb0_ABAA_dep : t_1a3b_eb0_ABAA_issue;
wire [8:0] t_1a3b_eb0_ABAA_cycle = (B_len == 3'd4) ? t_1a3b_eb0_ABAA_head : 9'd511;
wire [8:0] t_1a3b_eb0_BAAA_dep = m4_1a3b_eb0_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb0_BAAA_issue = t_1a3b_eb0_AAA_dep + 9'd1;
wire [8:0] t_1a3b_eb0_BAAA_head = (t_1a3b_eb0_BAAA_dep >= t_1a3b_eb0_BAAA_issue) ? t_1a3b_eb0_BAAA_dep : t_1a3b_eb0_BAAA_issue;
wire [8:0] t_1a3b_eb0_BAAA_cycle = (B_len == 3'd4) ? t_1a3b_eb0_BAAA_head : 9'd511;
wire m4_1a3b_eb0_tail_m0_0_pick = (t_1a3b_eb0_AAAA_cycle <= t_1a3b_eb0_AAAB_cycle);
wire [8:0] m4_1a3b_eb0_tail_m0_0_value = m4_1a3b_eb0_tail_m0_0_pick ? t_1a3b_eb0_AAAA_cycle : t_1a3b_eb0_AAAB_cycle;
wire [3:0] m4_1a3b_eb0_tail_m0_0_path = m4_1a3b_eb0_tail_m0_0_pick ? 4'b1111 : 4'b1110;
wire m4_1a3b_eb0_tail_m0_1_pick = (t_1a3b_eb0_AABA_cycle <= t_1a3b_eb0_ABAA_cycle);
wire [8:0] m4_1a3b_eb0_tail_m0_1_value = m4_1a3b_eb0_tail_m0_1_pick ? t_1a3b_eb0_AABA_cycle : t_1a3b_eb0_ABAA_cycle;
wire [3:0] m4_1a3b_eb0_tail_m0_1_path = m4_1a3b_eb0_tail_m0_1_pick ? 4'b1101 : 4'b1011;
wire m4_1a3b_eb0_tail_m1_0_pick = (m4_1a3b_eb0_tail_m0_0_value <= m4_1a3b_eb0_tail_m0_1_value);
wire [8:0] m4_1a3b_eb0_tail_m1_0_value = m4_1a3b_eb0_tail_m1_0_pick ? m4_1a3b_eb0_tail_m0_0_value : m4_1a3b_eb0_tail_m0_1_value;
wire [3:0] m4_1a3b_eb0_tail_m1_0_path = m4_1a3b_eb0_tail_m1_0_pick ? m4_1a3b_eb0_tail_m0_0_path : m4_1a3b_eb0_tail_m0_1_path;
wire m4_1a3b_eb0_tail_m2_0_pick = (m4_1a3b_eb0_tail_m1_0_value <= t_1a3b_eb0_BAAA_cycle);
wire [8:0] m4_1a3b_eb0_tail_m2_0_value = m4_1a3b_eb0_tail_m2_0_pick ? m4_1a3b_eb0_tail_m1_0_value : t_1a3b_eb0_BAAA_cycle;
wire [3:0] m4_1a3b_eb0_tail_m2_0_path = m4_1a3b_eb0_tail_m2_0_pick ? m4_1a3b_eb0_tail_m1_0_path : 4'b0111;
wire [8:0] m4_1a3b_eb0_cycle = m4_1a3b_eb0_v ? m4_1a3b_eb0_tail_m2_0_value : 9'd511;
wire [7:0] m4_1a3b_eb0_path = {m4_1a3b_eb0_tail_m2_0_path, m4_1a3b_eb0_suffix};

// Shared continuation for m4_1a3b_eb1; suffix selection is outside this tree.
wire [7:0] t_1a3b_eb1_A_dep = m4_1a3b_eb1_ra + A_rev_lat[1];
wire [7:0] t_1a3b_eb1_A_issue = m4_1a3b_eb1_rb + 8'd1;
wire [7:0] t_1a3b_eb1_A_head = (t_1a3b_eb1_A_dep >= t_1a3b_eb1_A_issue) ? t_1a3b_eb1_A_dep : t_1a3b_eb1_A_issue;
wire [7:0] t_1a3b_eb1_B_dep = m4_1a3b_eb1_rb + B_rev_lat[3];
wire [7:0] t_1a3b_eb1_B_issue = m4_1a3b_eb1_ra + 8'd1;
wire [7:0] t_1a3b_eb1_B_head = (t_1a3b_eb1_B_dep >= t_1a3b_eb1_B_issue) ? t_1a3b_eb1_B_dep : t_1a3b_eb1_B_issue;
wire [8:0] t_1a3b_eb1_AA_dep = t_1a3b_eb1_A_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb1_AB_dep = m4_1a3b_eb1_ra + A_rev_lat[1];
wire [8:0] t_1a3b_eb1_AB_issue = t_1a3b_eb1_B_head + 9'd1;
wire [8:0] t_1a3b_eb1_AB_head = (t_1a3b_eb1_AB_dep >= t_1a3b_eb1_AB_issue) ? t_1a3b_eb1_AB_dep : t_1a3b_eb1_AB_issue;
wire [8:0] t_1a3b_eb1_BA_dep = m4_1a3b_eb1_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb1_BA_issue = t_1a3b_eb1_A_head + 9'd1;
wire [8:0] t_1a3b_eb1_BA_head = (t_1a3b_eb1_BA_dep >= t_1a3b_eb1_BA_issue) ? t_1a3b_eb1_BA_dep : t_1a3b_eb1_BA_issue;
wire [8:0] t_1a3b_eb1_AAA_dep = t_1a3b_eb1_AA_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb1_AAB_dep = t_1a3b_eb1_AB_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb1_ABA_dep = t_1a3b_eb1_A_head + A_rev_lat[2];
wire [8:0] t_1a3b_eb1_ABA_issue = t_1a3b_eb1_BA_head + 9'd1;
wire [8:0] t_1a3b_eb1_ABA_head = (t_1a3b_eb1_ABA_dep >= t_1a3b_eb1_ABA_issue) ? t_1a3b_eb1_ABA_dep : t_1a3b_eb1_ABA_issue;
wire [8:0] t_1a3b_eb1_BAA_dep = m4_1a3b_eb1_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb1_BAA_issue = t_1a3b_eb1_AA_dep + 9'd1;
wire [8:0] t_1a3b_eb1_BAA_head = (t_1a3b_eb1_BAA_dep >= t_1a3b_eb1_BAA_issue) ? t_1a3b_eb1_BAA_dep : t_1a3b_eb1_BAA_issue;
wire [8:0] t_1a3b_eb1_AAAA_dep = t_1a3b_eb1_AAA_dep + A_rev_lat[4];
wire [8:0] t_1a3b_eb1_AAAA_cycle = (B_len == 3'd3) ? t_1a3b_eb1_AAAA_dep : 9'd511;
wire [8:0] t_1a3b_eb1_AAAB_dep = t_1a3b_eb1_AAB_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb1_AAAB_cycle = (B_len == 3'd4) ? t_1a3b_eb1_AAAB_dep : 9'd511;
wire [8:0] t_1a3b_eb1_AABA_dep = t_1a3b_eb1_ABA_head + A_rev_lat[3];
wire [8:0] t_1a3b_eb1_AABA_cycle = (B_len == 3'd4) ? t_1a3b_eb1_AABA_dep : 9'd511;
wire [8:0] t_1a3b_eb1_ABAA_dep = t_1a3b_eb1_AA_dep + A_rev_lat[3];
wire [8:0] t_1a3b_eb1_ABAA_issue = t_1a3b_eb1_BAA_head + 9'd1;
wire [8:0] t_1a3b_eb1_ABAA_head = (t_1a3b_eb1_ABAA_dep >= t_1a3b_eb1_ABAA_issue) ? t_1a3b_eb1_ABAA_dep : t_1a3b_eb1_ABAA_issue;
wire [8:0] t_1a3b_eb1_ABAA_cycle = (B_len == 3'd4) ? t_1a3b_eb1_ABAA_head : 9'd511;
wire [8:0] t_1a3b_eb1_BAAA_dep = m4_1a3b_eb1_rb + B_rev_lat[3];
wire [8:0] t_1a3b_eb1_BAAA_issue = t_1a3b_eb1_AAA_dep + 9'd1;
wire [8:0] t_1a3b_eb1_BAAA_head = (t_1a3b_eb1_BAAA_dep >= t_1a3b_eb1_BAAA_issue) ? t_1a3b_eb1_BAAA_dep : t_1a3b_eb1_BAAA_issue;
wire [8:0] t_1a3b_eb1_BAAA_cycle = (B_len == 3'd4) ? t_1a3b_eb1_BAAA_head : 9'd511;
wire m4_1a3b_eb1_tail_m0_0_pick = (t_1a3b_eb1_AAAA_cycle <= t_1a3b_eb1_AAAB_cycle);
wire [8:0] m4_1a3b_eb1_tail_m0_0_value = m4_1a3b_eb1_tail_m0_0_pick ? t_1a3b_eb1_AAAA_cycle : t_1a3b_eb1_AAAB_cycle;
wire [3:0] m4_1a3b_eb1_tail_m0_0_path = m4_1a3b_eb1_tail_m0_0_pick ? 4'b1111 : 4'b1110;
wire m4_1a3b_eb1_tail_m0_1_pick = (t_1a3b_eb1_AABA_cycle <= t_1a3b_eb1_ABAA_cycle);
wire [8:0] m4_1a3b_eb1_tail_m0_1_value = m4_1a3b_eb1_tail_m0_1_pick ? t_1a3b_eb1_AABA_cycle : t_1a3b_eb1_ABAA_cycle;
wire [3:0] m4_1a3b_eb1_tail_m0_1_path = m4_1a3b_eb1_tail_m0_1_pick ? 4'b1101 : 4'b1011;
wire m4_1a3b_eb1_tail_m1_0_pick = (m4_1a3b_eb1_tail_m0_0_value <= m4_1a3b_eb1_tail_m0_1_value);
wire [8:0] m4_1a3b_eb1_tail_m1_0_value = m4_1a3b_eb1_tail_m1_0_pick ? m4_1a3b_eb1_tail_m0_0_value : m4_1a3b_eb1_tail_m0_1_value;
wire [3:0] m4_1a3b_eb1_tail_m1_0_path = m4_1a3b_eb1_tail_m1_0_pick ? m4_1a3b_eb1_tail_m0_0_path : m4_1a3b_eb1_tail_m0_1_path;
wire m4_1a3b_eb1_tail_m2_0_pick = (m4_1a3b_eb1_tail_m1_0_value <= t_1a3b_eb1_BAAA_cycle);
wire [8:0] m4_1a3b_eb1_tail_m2_0_value = m4_1a3b_eb1_tail_m2_0_pick ? m4_1a3b_eb1_tail_m1_0_value : t_1a3b_eb1_BAAA_cycle;
wire [3:0] m4_1a3b_eb1_tail_m2_0_path = m4_1a3b_eb1_tail_m2_0_pick ? m4_1a3b_eb1_tail_m1_0_path : 4'b0111;
wire [8:0] m4_1a3b_eb1_cycle = m4_1a3b_eb1_v ? m4_1a3b_eb1_tail_m2_0_value : 9'd511;
wire [7:0] m4_1a3b_eb1_path = {m4_1a3b_eb1_tail_m2_0_path, m4_1a3b_eb1_suffix};

// Shared continuation for m4_2a2b_ea0; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea0_A_dep = m4_2a2b_ea0_ra + A_rev_lat[2];
wire [7:0] t_2a2b_ea0_A_issue = m4_2a2b_ea0_rb + 8'd1;
wire [7:0] t_2a2b_ea0_A_head = (t_2a2b_ea0_A_dep >= t_2a2b_ea0_A_issue) ? t_2a2b_ea0_A_dep : t_2a2b_ea0_A_issue;
wire [7:0] t_2a2b_ea0_B_dep = m4_2a2b_ea0_rb + B_rev_lat[2];
wire [7:0] t_2a2b_ea0_B_issue = m4_2a2b_ea0_ra + 8'd1;
wire [7:0] t_2a2b_ea0_B_head = (t_2a2b_ea0_B_dep >= t_2a2b_ea0_B_issue) ? t_2a2b_ea0_B_dep : t_2a2b_ea0_B_issue;
wire [8:0] t_2a2b_ea0_AA_dep = t_2a2b_ea0_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_AB_dep = m4_2a2b_ea0_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea0_AB_issue = t_2a2b_ea0_B_head + 9'd1;
wire [8:0] t_2a2b_ea0_AB_head = (t_2a2b_ea0_AB_dep >= t_2a2b_ea0_AB_issue) ? t_2a2b_ea0_AB_dep : t_2a2b_ea0_AB_issue;
wire [8:0] t_2a2b_ea0_BA_dep = m4_2a2b_ea0_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea0_BA_issue = t_2a2b_ea0_A_head + 9'd1;
wire [8:0] t_2a2b_ea0_BA_head = (t_2a2b_ea0_BA_dep >= t_2a2b_ea0_BA_issue) ? t_2a2b_ea0_BA_dep : t_2a2b_ea0_BA_issue;
wire [8:0] t_2a2b_ea0_BB_dep = t_2a2b_ea0_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_AAA_dep = t_2a2b_ea0_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea0_AAB_dep = t_2a2b_ea0_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_ABA_dep = t_2a2b_ea0_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_ABA_issue = t_2a2b_ea0_BA_head + 9'd1;
wire [8:0] t_2a2b_ea0_ABA_head = (t_2a2b_ea0_ABA_dep >= t_2a2b_ea0_ABA_issue) ? t_2a2b_ea0_ABA_dep : t_2a2b_ea0_ABA_issue;
wire [8:0] t_2a2b_ea0_ABB_dep = m4_2a2b_ea0_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea0_ABB_issue = t_2a2b_ea0_BB_dep + 9'd1;
wire [8:0] t_2a2b_ea0_ABB_head = (t_2a2b_ea0_ABB_dep >= t_2a2b_ea0_ABB_issue) ? t_2a2b_ea0_ABB_dep : t_2a2b_ea0_ABB_issue;
wire [8:0] t_2a2b_ea0_BAA_dep = m4_2a2b_ea0_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea0_BAA_issue = t_2a2b_ea0_AA_dep + 9'd1;
wire [8:0] t_2a2b_ea0_BAA_head = (t_2a2b_ea0_BAA_dep >= t_2a2b_ea0_BAA_issue) ? t_2a2b_ea0_BAA_dep : t_2a2b_ea0_BAA_issue;
wire [8:0] t_2a2b_ea0_BAB_dep = t_2a2b_ea0_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_BAB_issue = t_2a2b_ea0_AB_head + 9'd1;
wire [8:0] t_2a2b_ea0_BAB_head = (t_2a2b_ea0_BAB_dep >= t_2a2b_ea0_BAB_issue) ? t_2a2b_ea0_BAB_dep : t_2a2b_ea0_BAB_issue;
wire [8:0] t_2a2b_ea0_BBA_dep = t_2a2b_ea0_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_AAAA_dep = t_2a2b_ea0_AAA_dep + A_rev_lat[5];
wire [8:0] t_2a2b_ea0_AAAA_cycle = (B_len == 3'd2) ? t_2a2b_ea0_AAAA_dep : 9'd511;
wire [8:0] t_2a2b_ea0_AAAB_dep = t_2a2b_ea0_AAB_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea0_AAAB_cycle = (B_len == 3'd3) ? t_2a2b_ea0_AAAB_dep : 9'd511;
wire [8:0] t_2a2b_ea0_AABA_dep = t_2a2b_ea0_ABA_head + A_rev_lat[4];
wire [8:0] t_2a2b_ea0_AABA_cycle = (B_len == 3'd3) ? t_2a2b_ea0_AABA_dep : 9'd511;
wire [8:0] t_2a2b_ea0_AABB_dep = t_2a2b_ea0_ABB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_AABB_cycle = (B_len == 3'd4) ? t_2a2b_ea0_AABB_dep : 9'd511;
wire [8:0] t_2a2b_ea0_ABAA_dep = t_2a2b_ea0_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea0_ABAA_issue = t_2a2b_ea0_BAA_head + 9'd1;
wire [8:0] t_2a2b_ea0_ABAA_head = (t_2a2b_ea0_ABAA_dep >= t_2a2b_ea0_ABAA_issue) ? t_2a2b_ea0_ABAA_dep : t_2a2b_ea0_ABAA_issue;
wire [8:0] t_2a2b_ea0_ABAA_cycle = (B_len == 3'd3) ? t_2a2b_ea0_ABAA_head : 9'd511;
wire [8:0] t_2a2b_ea0_ABAB_dep = t_2a2b_ea0_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_ABAB_issue = t_2a2b_ea0_BAB_head + 9'd1;
wire [8:0] t_2a2b_ea0_ABAB_head = (t_2a2b_ea0_ABAB_dep >= t_2a2b_ea0_ABAB_issue) ? t_2a2b_ea0_ABAB_dep : t_2a2b_ea0_ABAB_issue;
wire [8:0] t_2a2b_ea0_ABAB_cycle = (B_len == 3'd4) ? t_2a2b_ea0_ABAB_head : 9'd511;
wire [8:0] t_2a2b_ea0_ABBA_dep = t_2a2b_ea0_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea0_ABBA_issue = t_2a2b_ea0_BBA_dep + 9'd1;
wire [8:0] t_2a2b_ea0_ABBA_head = (t_2a2b_ea0_ABBA_dep >= t_2a2b_ea0_ABBA_issue) ? t_2a2b_ea0_ABBA_dep : t_2a2b_ea0_ABBA_issue;
wire [8:0] t_2a2b_ea0_ABBA_cycle = (B_len == 3'd4) ? t_2a2b_ea0_ABBA_head : 9'd511;
wire [8:0] t_2a2b_ea0_BAAA_dep = m4_2a2b_ea0_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea0_BAAA_issue = t_2a2b_ea0_AAA_dep + 9'd1;
wire [8:0] t_2a2b_ea0_BAAA_head = (t_2a2b_ea0_BAAA_dep >= t_2a2b_ea0_BAAA_issue) ? t_2a2b_ea0_BAAA_dep : t_2a2b_ea0_BAAA_issue;
wire [8:0] t_2a2b_ea0_BAAA_cycle = (B_len == 3'd3) ? t_2a2b_ea0_BAAA_head : 9'd511;
wire [8:0] t_2a2b_ea0_BAAB_dep = t_2a2b_ea0_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_BAAB_issue = t_2a2b_ea0_AAB_dep + 9'd1;
wire [8:0] t_2a2b_ea0_BAAB_head = (t_2a2b_ea0_BAAB_dep >= t_2a2b_ea0_BAAB_issue) ? t_2a2b_ea0_BAAB_dep : t_2a2b_ea0_BAAB_issue;
wire [8:0] t_2a2b_ea0_BAAB_cycle = (B_len == 3'd4) ? t_2a2b_ea0_BAAB_head : 9'd511;
wire [8:0] t_2a2b_ea0_BABA_dep = t_2a2b_ea0_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_BABA_issue = t_2a2b_ea0_ABA_head + 9'd1;
wire [8:0] t_2a2b_ea0_BABA_head = (t_2a2b_ea0_BABA_dep >= t_2a2b_ea0_BABA_issue) ? t_2a2b_ea0_BABA_dep : t_2a2b_ea0_BABA_issue;
wire [8:0] t_2a2b_ea0_BABA_cycle = (B_len == 3'd4) ? t_2a2b_ea0_BABA_head : 9'd511;
wire [8:0] t_2a2b_ea0_BBAA_dep = t_2a2b_ea0_BAA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea0_BBAA_cycle = (B_len == 3'd4) ? t_2a2b_ea0_BBAA_dep : 9'd511;
wire m4_2a2b_ea0_tail_m0_0_pick = (t_2a2b_ea0_AAAA_cycle <= t_2a2b_ea0_AAAB_cycle);
wire [8:0] m4_2a2b_ea0_tail_m0_0_value = m4_2a2b_ea0_tail_m0_0_pick ? t_2a2b_ea0_AAAA_cycle : t_2a2b_ea0_AAAB_cycle;
wire [3:0] m4_2a2b_ea0_tail_m0_0_path = m4_2a2b_ea0_tail_m0_0_pick ? 4'b1111 : 4'b1110;
wire m4_2a2b_ea0_tail_m0_1_pick = (t_2a2b_ea0_AABA_cycle <= t_2a2b_ea0_AABB_cycle);
wire [8:0] m4_2a2b_ea0_tail_m0_1_value = m4_2a2b_ea0_tail_m0_1_pick ? t_2a2b_ea0_AABA_cycle : t_2a2b_ea0_AABB_cycle;
wire [3:0] m4_2a2b_ea0_tail_m0_1_path = m4_2a2b_ea0_tail_m0_1_pick ? 4'b1101 : 4'b1100;
wire m4_2a2b_ea0_tail_m0_2_pick = (t_2a2b_ea0_ABAA_cycle <= t_2a2b_ea0_ABAB_cycle);
wire [8:0] m4_2a2b_ea0_tail_m0_2_value = m4_2a2b_ea0_tail_m0_2_pick ? t_2a2b_ea0_ABAA_cycle : t_2a2b_ea0_ABAB_cycle;
wire [3:0] m4_2a2b_ea0_tail_m0_2_path = m4_2a2b_ea0_tail_m0_2_pick ? 4'b1011 : 4'b1010;
wire m4_2a2b_ea0_tail_m0_3_pick = (t_2a2b_ea0_ABBA_cycle <= t_2a2b_ea0_BAAA_cycle);
wire [8:0] m4_2a2b_ea0_tail_m0_3_value = m4_2a2b_ea0_tail_m0_3_pick ? t_2a2b_ea0_ABBA_cycle : t_2a2b_ea0_BAAA_cycle;
wire [3:0] m4_2a2b_ea0_tail_m0_3_path = m4_2a2b_ea0_tail_m0_3_pick ? 4'b1001 : 4'b0111;
wire m4_2a2b_ea0_tail_m0_4_pick = (t_2a2b_ea0_BAAB_cycle <= t_2a2b_ea0_BABA_cycle);
wire [8:0] m4_2a2b_ea0_tail_m0_4_value = m4_2a2b_ea0_tail_m0_4_pick ? t_2a2b_ea0_BAAB_cycle : t_2a2b_ea0_BABA_cycle;
wire [3:0] m4_2a2b_ea0_tail_m0_4_path = m4_2a2b_ea0_tail_m0_4_pick ? 4'b0110 : 4'b0101;
wire m4_2a2b_ea0_tail_m1_0_pick = (m4_2a2b_ea0_tail_m0_0_value <= m4_2a2b_ea0_tail_m0_1_value);
wire [8:0] m4_2a2b_ea0_tail_m1_0_value = m4_2a2b_ea0_tail_m1_0_pick ? m4_2a2b_ea0_tail_m0_0_value : m4_2a2b_ea0_tail_m0_1_value;
wire [3:0] m4_2a2b_ea0_tail_m1_0_path = m4_2a2b_ea0_tail_m1_0_pick ? m4_2a2b_ea0_tail_m0_0_path : m4_2a2b_ea0_tail_m0_1_path;
wire m4_2a2b_ea0_tail_m1_1_pick = (m4_2a2b_ea0_tail_m0_2_value <= m4_2a2b_ea0_tail_m0_3_value);
wire [8:0] m4_2a2b_ea0_tail_m1_1_value = m4_2a2b_ea0_tail_m1_1_pick ? m4_2a2b_ea0_tail_m0_2_value : m4_2a2b_ea0_tail_m0_3_value;
wire [3:0] m4_2a2b_ea0_tail_m1_1_path = m4_2a2b_ea0_tail_m1_1_pick ? m4_2a2b_ea0_tail_m0_2_path : m4_2a2b_ea0_tail_m0_3_path;
wire m4_2a2b_ea0_tail_m1_2_pick = (m4_2a2b_ea0_tail_m0_4_value <= t_2a2b_ea0_BBAA_cycle);
wire [8:0] m4_2a2b_ea0_tail_m1_2_value = m4_2a2b_ea0_tail_m1_2_pick ? m4_2a2b_ea0_tail_m0_4_value : t_2a2b_ea0_BBAA_cycle;
wire [3:0] m4_2a2b_ea0_tail_m1_2_path = m4_2a2b_ea0_tail_m1_2_pick ? m4_2a2b_ea0_tail_m0_4_path : 4'b0011;
wire m4_2a2b_ea0_tail_m2_0_pick = (m4_2a2b_ea0_tail_m1_0_value <= m4_2a2b_ea0_tail_m1_1_value);
wire [8:0] m4_2a2b_ea0_tail_m2_0_value = m4_2a2b_ea0_tail_m2_0_pick ? m4_2a2b_ea0_tail_m1_0_value : m4_2a2b_ea0_tail_m1_1_value;
wire [3:0] m4_2a2b_ea0_tail_m2_0_path = m4_2a2b_ea0_tail_m2_0_pick ? m4_2a2b_ea0_tail_m1_0_path : m4_2a2b_ea0_tail_m1_1_path;
wire m4_2a2b_ea0_tail_m3_0_pick = (m4_2a2b_ea0_tail_m2_0_value <= m4_2a2b_ea0_tail_m1_2_value);
wire [8:0] m4_2a2b_ea0_tail_m3_0_value = m4_2a2b_ea0_tail_m3_0_pick ? m4_2a2b_ea0_tail_m2_0_value : m4_2a2b_ea0_tail_m1_2_value;
wire [3:0] m4_2a2b_ea0_tail_m3_0_path = m4_2a2b_ea0_tail_m3_0_pick ? m4_2a2b_ea0_tail_m2_0_path : m4_2a2b_ea0_tail_m1_2_path;
wire [8:0] m4_2a2b_ea0_cycle = m4_2a2b_ea0_v ? m4_2a2b_ea0_tail_m3_0_value : 9'd511;
wire [7:0] m4_2a2b_ea0_path = {m4_2a2b_ea0_tail_m3_0_path, m4_2a2b_ea0_suffix};

// Shared continuation for m4_2a2b_ea1; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea1_A_dep = m4_2a2b_ea1_ra + A_rev_lat[2];
wire [7:0] t_2a2b_ea1_A_issue = m4_2a2b_ea1_rb + 8'd1;
wire [7:0] t_2a2b_ea1_A_head = (t_2a2b_ea1_A_dep >= t_2a2b_ea1_A_issue) ? t_2a2b_ea1_A_dep : t_2a2b_ea1_A_issue;
wire [7:0] t_2a2b_ea1_B_dep = m4_2a2b_ea1_rb + B_rev_lat[2];
wire [7:0] t_2a2b_ea1_B_issue = m4_2a2b_ea1_ra + 8'd1;
wire [7:0] t_2a2b_ea1_B_head = (t_2a2b_ea1_B_dep >= t_2a2b_ea1_B_issue) ? t_2a2b_ea1_B_dep : t_2a2b_ea1_B_issue;
wire [8:0] t_2a2b_ea1_AA_dep = t_2a2b_ea1_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_AB_dep = m4_2a2b_ea1_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea1_AB_issue = t_2a2b_ea1_B_head + 9'd1;
wire [8:0] t_2a2b_ea1_AB_head = (t_2a2b_ea1_AB_dep >= t_2a2b_ea1_AB_issue) ? t_2a2b_ea1_AB_dep : t_2a2b_ea1_AB_issue;
wire [8:0] t_2a2b_ea1_BA_dep = m4_2a2b_ea1_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea1_BA_issue = t_2a2b_ea1_A_head + 9'd1;
wire [8:0] t_2a2b_ea1_BA_head = (t_2a2b_ea1_BA_dep >= t_2a2b_ea1_BA_issue) ? t_2a2b_ea1_BA_dep : t_2a2b_ea1_BA_issue;
wire [8:0] t_2a2b_ea1_BB_dep = t_2a2b_ea1_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_AAA_dep = t_2a2b_ea1_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea1_AAB_dep = t_2a2b_ea1_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_ABA_dep = t_2a2b_ea1_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_ABA_issue = t_2a2b_ea1_BA_head + 9'd1;
wire [8:0] t_2a2b_ea1_ABA_head = (t_2a2b_ea1_ABA_dep >= t_2a2b_ea1_ABA_issue) ? t_2a2b_ea1_ABA_dep : t_2a2b_ea1_ABA_issue;
wire [8:0] t_2a2b_ea1_ABB_dep = m4_2a2b_ea1_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea1_ABB_issue = t_2a2b_ea1_BB_dep + 9'd1;
wire [8:0] t_2a2b_ea1_ABB_head = (t_2a2b_ea1_ABB_dep >= t_2a2b_ea1_ABB_issue) ? t_2a2b_ea1_ABB_dep : t_2a2b_ea1_ABB_issue;
wire [8:0] t_2a2b_ea1_BAA_dep = m4_2a2b_ea1_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea1_BAA_issue = t_2a2b_ea1_AA_dep + 9'd1;
wire [8:0] t_2a2b_ea1_BAA_head = (t_2a2b_ea1_BAA_dep >= t_2a2b_ea1_BAA_issue) ? t_2a2b_ea1_BAA_dep : t_2a2b_ea1_BAA_issue;
wire [8:0] t_2a2b_ea1_BAB_dep = t_2a2b_ea1_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_BAB_issue = t_2a2b_ea1_AB_head + 9'd1;
wire [8:0] t_2a2b_ea1_BAB_head = (t_2a2b_ea1_BAB_dep >= t_2a2b_ea1_BAB_issue) ? t_2a2b_ea1_BAB_dep : t_2a2b_ea1_BAB_issue;
wire [8:0] t_2a2b_ea1_BBA_dep = t_2a2b_ea1_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_AAAA_dep = t_2a2b_ea1_AAA_dep + A_rev_lat[5];
wire [8:0] t_2a2b_ea1_AAAA_cycle = (B_len == 3'd2) ? t_2a2b_ea1_AAAA_dep : 9'd511;
wire [8:0] t_2a2b_ea1_AAAB_dep = t_2a2b_ea1_AAB_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea1_AAAB_cycle = (B_len == 3'd3) ? t_2a2b_ea1_AAAB_dep : 9'd511;
wire [8:0] t_2a2b_ea1_AABA_dep = t_2a2b_ea1_ABA_head + A_rev_lat[4];
wire [8:0] t_2a2b_ea1_AABA_cycle = (B_len == 3'd3) ? t_2a2b_ea1_AABA_dep : 9'd511;
wire [8:0] t_2a2b_ea1_AABB_dep = t_2a2b_ea1_ABB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_AABB_cycle = (B_len == 3'd4) ? t_2a2b_ea1_AABB_dep : 9'd511;
wire [8:0] t_2a2b_ea1_ABAA_dep = t_2a2b_ea1_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea1_ABAA_issue = t_2a2b_ea1_BAA_head + 9'd1;
wire [8:0] t_2a2b_ea1_ABAA_head = (t_2a2b_ea1_ABAA_dep >= t_2a2b_ea1_ABAA_issue) ? t_2a2b_ea1_ABAA_dep : t_2a2b_ea1_ABAA_issue;
wire [8:0] t_2a2b_ea1_ABAA_cycle = (B_len == 3'd3) ? t_2a2b_ea1_ABAA_head : 9'd511;
wire [8:0] t_2a2b_ea1_ABAB_dep = t_2a2b_ea1_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_ABAB_issue = t_2a2b_ea1_BAB_head + 9'd1;
wire [8:0] t_2a2b_ea1_ABAB_head = (t_2a2b_ea1_ABAB_dep >= t_2a2b_ea1_ABAB_issue) ? t_2a2b_ea1_ABAB_dep : t_2a2b_ea1_ABAB_issue;
wire [8:0] t_2a2b_ea1_ABAB_cycle = (B_len == 3'd4) ? t_2a2b_ea1_ABAB_head : 9'd511;
wire [8:0] t_2a2b_ea1_ABBA_dep = t_2a2b_ea1_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea1_ABBA_issue = t_2a2b_ea1_BBA_dep + 9'd1;
wire [8:0] t_2a2b_ea1_ABBA_head = (t_2a2b_ea1_ABBA_dep >= t_2a2b_ea1_ABBA_issue) ? t_2a2b_ea1_ABBA_dep : t_2a2b_ea1_ABBA_issue;
wire [8:0] t_2a2b_ea1_ABBA_cycle = (B_len == 3'd4) ? t_2a2b_ea1_ABBA_head : 9'd511;
wire [8:0] t_2a2b_ea1_BAAA_dep = m4_2a2b_ea1_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea1_BAAA_issue = t_2a2b_ea1_AAA_dep + 9'd1;
wire [8:0] t_2a2b_ea1_BAAA_head = (t_2a2b_ea1_BAAA_dep >= t_2a2b_ea1_BAAA_issue) ? t_2a2b_ea1_BAAA_dep : t_2a2b_ea1_BAAA_issue;
wire [8:0] t_2a2b_ea1_BAAA_cycle = (B_len == 3'd3) ? t_2a2b_ea1_BAAA_head : 9'd511;
wire [8:0] t_2a2b_ea1_BAAB_dep = t_2a2b_ea1_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_BAAB_issue = t_2a2b_ea1_AAB_dep + 9'd1;
wire [8:0] t_2a2b_ea1_BAAB_head = (t_2a2b_ea1_BAAB_dep >= t_2a2b_ea1_BAAB_issue) ? t_2a2b_ea1_BAAB_dep : t_2a2b_ea1_BAAB_issue;
wire [8:0] t_2a2b_ea1_BAAB_cycle = (B_len == 3'd4) ? t_2a2b_ea1_BAAB_head : 9'd511;
wire [8:0] t_2a2b_ea1_BABA_dep = t_2a2b_ea1_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_BABA_issue = t_2a2b_ea1_ABA_head + 9'd1;
wire [8:0] t_2a2b_ea1_BABA_head = (t_2a2b_ea1_BABA_dep >= t_2a2b_ea1_BABA_issue) ? t_2a2b_ea1_BABA_dep : t_2a2b_ea1_BABA_issue;
wire [8:0] t_2a2b_ea1_BABA_cycle = (B_len == 3'd4) ? t_2a2b_ea1_BABA_head : 9'd511;
wire [8:0] t_2a2b_ea1_BBAA_dep = t_2a2b_ea1_BAA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea1_BBAA_cycle = (B_len == 3'd4) ? t_2a2b_ea1_BBAA_dep : 9'd511;
wire m4_2a2b_ea1_tail_m0_0_pick = (t_2a2b_ea1_AAAA_cycle <= t_2a2b_ea1_AAAB_cycle);
wire [8:0] m4_2a2b_ea1_tail_m0_0_value = m4_2a2b_ea1_tail_m0_0_pick ? t_2a2b_ea1_AAAA_cycle : t_2a2b_ea1_AAAB_cycle;
wire [3:0] m4_2a2b_ea1_tail_m0_0_path = m4_2a2b_ea1_tail_m0_0_pick ? 4'b1111 : 4'b1110;
wire m4_2a2b_ea1_tail_m0_1_pick = (t_2a2b_ea1_AABA_cycle <= t_2a2b_ea1_AABB_cycle);
wire [8:0] m4_2a2b_ea1_tail_m0_1_value = m4_2a2b_ea1_tail_m0_1_pick ? t_2a2b_ea1_AABA_cycle : t_2a2b_ea1_AABB_cycle;
wire [3:0] m4_2a2b_ea1_tail_m0_1_path = m4_2a2b_ea1_tail_m0_1_pick ? 4'b1101 : 4'b1100;
wire m4_2a2b_ea1_tail_m0_2_pick = (t_2a2b_ea1_ABAA_cycle <= t_2a2b_ea1_ABAB_cycle);
wire [8:0] m4_2a2b_ea1_tail_m0_2_value = m4_2a2b_ea1_tail_m0_2_pick ? t_2a2b_ea1_ABAA_cycle : t_2a2b_ea1_ABAB_cycle;
wire [3:0] m4_2a2b_ea1_tail_m0_2_path = m4_2a2b_ea1_tail_m0_2_pick ? 4'b1011 : 4'b1010;
wire m4_2a2b_ea1_tail_m0_3_pick = (t_2a2b_ea1_ABBA_cycle <= t_2a2b_ea1_BAAA_cycle);
wire [8:0] m4_2a2b_ea1_tail_m0_3_value = m4_2a2b_ea1_tail_m0_3_pick ? t_2a2b_ea1_ABBA_cycle : t_2a2b_ea1_BAAA_cycle;
wire [3:0] m4_2a2b_ea1_tail_m0_3_path = m4_2a2b_ea1_tail_m0_3_pick ? 4'b1001 : 4'b0111;
wire m4_2a2b_ea1_tail_m0_4_pick = (t_2a2b_ea1_BAAB_cycle <= t_2a2b_ea1_BABA_cycle);
wire [8:0] m4_2a2b_ea1_tail_m0_4_value = m4_2a2b_ea1_tail_m0_4_pick ? t_2a2b_ea1_BAAB_cycle : t_2a2b_ea1_BABA_cycle;
wire [3:0] m4_2a2b_ea1_tail_m0_4_path = m4_2a2b_ea1_tail_m0_4_pick ? 4'b0110 : 4'b0101;
wire m4_2a2b_ea1_tail_m1_0_pick = (m4_2a2b_ea1_tail_m0_0_value <= m4_2a2b_ea1_tail_m0_1_value);
wire [8:0] m4_2a2b_ea1_tail_m1_0_value = m4_2a2b_ea1_tail_m1_0_pick ? m4_2a2b_ea1_tail_m0_0_value : m4_2a2b_ea1_tail_m0_1_value;
wire [3:0] m4_2a2b_ea1_tail_m1_0_path = m4_2a2b_ea1_tail_m1_0_pick ? m4_2a2b_ea1_tail_m0_0_path : m4_2a2b_ea1_tail_m0_1_path;
wire m4_2a2b_ea1_tail_m1_1_pick = (m4_2a2b_ea1_tail_m0_2_value <= m4_2a2b_ea1_tail_m0_3_value);
wire [8:0] m4_2a2b_ea1_tail_m1_1_value = m4_2a2b_ea1_tail_m1_1_pick ? m4_2a2b_ea1_tail_m0_2_value : m4_2a2b_ea1_tail_m0_3_value;
wire [3:0] m4_2a2b_ea1_tail_m1_1_path = m4_2a2b_ea1_tail_m1_1_pick ? m4_2a2b_ea1_tail_m0_2_path : m4_2a2b_ea1_tail_m0_3_path;
wire m4_2a2b_ea1_tail_m1_2_pick = (m4_2a2b_ea1_tail_m0_4_value <= t_2a2b_ea1_BBAA_cycle);
wire [8:0] m4_2a2b_ea1_tail_m1_2_value = m4_2a2b_ea1_tail_m1_2_pick ? m4_2a2b_ea1_tail_m0_4_value : t_2a2b_ea1_BBAA_cycle;
wire [3:0] m4_2a2b_ea1_tail_m1_2_path = m4_2a2b_ea1_tail_m1_2_pick ? m4_2a2b_ea1_tail_m0_4_path : 4'b0011;
wire m4_2a2b_ea1_tail_m2_0_pick = (m4_2a2b_ea1_tail_m1_0_value <= m4_2a2b_ea1_tail_m1_1_value);
wire [8:0] m4_2a2b_ea1_tail_m2_0_value = m4_2a2b_ea1_tail_m2_0_pick ? m4_2a2b_ea1_tail_m1_0_value : m4_2a2b_ea1_tail_m1_1_value;
wire [3:0] m4_2a2b_ea1_tail_m2_0_path = m4_2a2b_ea1_tail_m2_0_pick ? m4_2a2b_ea1_tail_m1_0_path : m4_2a2b_ea1_tail_m1_1_path;
wire m4_2a2b_ea1_tail_m3_0_pick = (m4_2a2b_ea1_tail_m2_0_value <= m4_2a2b_ea1_tail_m1_2_value);
wire [8:0] m4_2a2b_ea1_tail_m3_0_value = m4_2a2b_ea1_tail_m3_0_pick ? m4_2a2b_ea1_tail_m2_0_value : m4_2a2b_ea1_tail_m1_2_value;
wire [3:0] m4_2a2b_ea1_tail_m3_0_path = m4_2a2b_ea1_tail_m3_0_pick ? m4_2a2b_ea1_tail_m2_0_path : m4_2a2b_ea1_tail_m1_2_path;
wire [8:0] m4_2a2b_ea1_cycle = m4_2a2b_ea1_v ? m4_2a2b_ea1_tail_m3_0_value : 9'd511;
wire [7:0] m4_2a2b_ea1_path = {m4_2a2b_ea1_tail_m3_0_path, m4_2a2b_ea1_suffix};

// Shared continuation for m4_2a2b_ea2; suffix selection is outside this tree.
wire [7:0] t_2a2b_ea2_A_dep = m4_2a2b_ea2_ra + A_rev_lat[2];
wire [7:0] t_2a2b_ea2_A_issue = m4_2a2b_ea2_rb + 8'd1;
wire [7:0] t_2a2b_ea2_A_head = (t_2a2b_ea2_A_dep >= t_2a2b_ea2_A_issue) ? t_2a2b_ea2_A_dep : t_2a2b_ea2_A_issue;
wire [7:0] t_2a2b_ea2_B_dep = m4_2a2b_ea2_rb + B_rev_lat[2];
wire [7:0] t_2a2b_ea2_B_issue = m4_2a2b_ea2_ra + 8'd1;
wire [7:0] t_2a2b_ea2_B_head = (t_2a2b_ea2_B_dep >= t_2a2b_ea2_B_issue) ? t_2a2b_ea2_B_dep : t_2a2b_ea2_B_issue;
wire [8:0] t_2a2b_ea2_AA_dep = t_2a2b_ea2_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_AB_dep = m4_2a2b_ea2_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea2_AB_issue = t_2a2b_ea2_B_head + 9'd1;
wire [8:0] t_2a2b_ea2_AB_head = (t_2a2b_ea2_AB_dep >= t_2a2b_ea2_AB_issue) ? t_2a2b_ea2_AB_dep : t_2a2b_ea2_AB_issue;
wire [8:0] t_2a2b_ea2_BA_dep = m4_2a2b_ea2_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea2_BA_issue = t_2a2b_ea2_A_head + 9'd1;
wire [8:0] t_2a2b_ea2_BA_head = (t_2a2b_ea2_BA_dep >= t_2a2b_ea2_BA_issue) ? t_2a2b_ea2_BA_dep : t_2a2b_ea2_BA_issue;
wire [8:0] t_2a2b_ea2_BB_dep = t_2a2b_ea2_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_AAA_dep = t_2a2b_ea2_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea2_AAB_dep = t_2a2b_ea2_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_ABA_dep = t_2a2b_ea2_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_ABA_issue = t_2a2b_ea2_BA_head + 9'd1;
wire [8:0] t_2a2b_ea2_ABA_head = (t_2a2b_ea2_ABA_dep >= t_2a2b_ea2_ABA_issue) ? t_2a2b_ea2_ABA_dep : t_2a2b_ea2_ABA_issue;
wire [8:0] t_2a2b_ea2_ABB_dep = m4_2a2b_ea2_ra + A_rev_lat[2];
wire [8:0] t_2a2b_ea2_ABB_issue = t_2a2b_ea2_BB_dep + 9'd1;
wire [8:0] t_2a2b_ea2_ABB_head = (t_2a2b_ea2_ABB_dep >= t_2a2b_ea2_ABB_issue) ? t_2a2b_ea2_ABB_dep : t_2a2b_ea2_ABB_issue;
wire [8:0] t_2a2b_ea2_BAA_dep = m4_2a2b_ea2_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea2_BAA_issue = t_2a2b_ea2_AA_dep + 9'd1;
wire [8:0] t_2a2b_ea2_BAA_head = (t_2a2b_ea2_BAA_dep >= t_2a2b_ea2_BAA_issue) ? t_2a2b_ea2_BAA_dep : t_2a2b_ea2_BAA_issue;
wire [8:0] t_2a2b_ea2_BAB_dep = t_2a2b_ea2_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_BAB_issue = t_2a2b_ea2_AB_head + 9'd1;
wire [8:0] t_2a2b_ea2_BAB_head = (t_2a2b_ea2_BAB_dep >= t_2a2b_ea2_BAB_issue) ? t_2a2b_ea2_BAB_dep : t_2a2b_ea2_BAB_issue;
wire [8:0] t_2a2b_ea2_BBA_dep = t_2a2b_ea2_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_AAAA_dep = t_2a2b_ea2_AAA_dep + A_rev_lat[5];
wire [8:0] t_2a2b_ea2_AAAA_cycle = (B_len == 3'd2) ? t_2a2b_ea2_AAAA_dep : 9'd511;
wire [8:0] t_2a2b_ea2_AAAB_dep = t_2a2b_ea2_AAB_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea2_AAAB_cycle = (B_len == 3'd3) ? t_2a2b_ea2_AAAB_dep : 9'd511;
wire [8:0] t_2a2b_ea2_AABA_dep = t_2a2b_ea2_ABA_head + A_rev_lat[4];
wire [8:0] t_2a2b_ea2_AABA_cycle = (B_len == 3'd3) ? t_2a2b_ea2_AABA_dep : 9'd511;
wire [8:0] t_2a2b_ea2_AABB_dep = t_2a2b_ea2_ABB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_AABB_cycle = (B_len == 3'd4) ? t_2a2b_ea2_AABB_dep : 9'd511;
wire [8:0] t_2a2b_ea2_ABAA_dep = t_2a2b_ea2_AA_dep + A_rev_lat[4];
wire [8:0] t_2a2b_ea2_ABAA_issue = t_2a2b_ea2_BAA_head + 9'd1;
wire [8:0] t_2a2b_ea2_ABAA_head = (t_2a2b_ea2_ABAA_dep >= t_2a2b_ea2_ABAA_issue) ? t_2a2b_ea2_ABAA_dep : t_2a2b_ea2_ABAA_issue;
wire [8:0] t_2a2b_ea2_ABAA_cycle = (B_len == 3'd3) ? t_2a2b_ea2_ABAA_head : 9'd511;
wire [8:0] t_2a2b_ea2_ABAB_dep = t_2a2b_ea2_AB_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_ABAB_issue = t_2a2b_ea2_BAB_head + 9'd1;
wire [8:0] t_2a2b_ea2_ABAB_head = (t_2a2b_ea2_ABAB_dep >= t_2a2b_ea2_ABAB_issue) ? t_2a2b_ea2_ABAB_dep : t_2a2b_ea2_ABAB_issue;
wire [8:0] t_2a2b_ea2_ABAB_cycle = (B_len == 3'd4) ? t_2a2b_ea2_ABAB_head : 9'd511;
wire [8:0] t_2a2b_ea2_ABBA_dep = t_2a2b_ea2_A_head + A_rev_lat[3];
wire [8:0] t_2a2b_ea2_ABBA_issue = t_2a2b_ea2_BBA_dep + 9'd1;
wire [8:0] t_2a2b_ea2_ABBA_head = (t_2a2b_ea2_ABBA_dep >= t_2a2b_ea2_ABBA_issue) ? t_2a2b_ea2_ABBA_dep : t_2a2b_ea2_ABBA_issue;
wire [8:0] t_2a2b_ea2_ABBA_cycle = (B_len == 3'd4) ? t_2a2b_ea2_ABBA_head : 9'd511;
wire [8:0] t_2a2b_ea2_BAAA_dep = m4_2a2b_ea2_rb + B_rev_lat[2];
wire [8:0] t_2a2b_ea2_BAAA_issue = t_2a2b_ea2_AAA_dep + 9'd1;
wire [8:0] t_2a2b_ea2_BAAA_head = (t_2a2b_ea2_BAAA_dep >= t_2a2b_ea2_BAAA_issue) ? t_2a2b_ea2_BAAA_dep : t_2a2b_ea2_BAAA_issue;
wire [8:0] t_2a2b_ea2_BAAA_cycle = (B_len == 3'd3) ? t_2a2b_ea2_BAAA_head : 9'd511;
wire [8:0] t_2a2b_ea2_BAAB_dep = t_2a2b_ea2_B_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_BAAB_issue = t_2a2b_ea2_AAB_dep + 9'd1;
wire [8:0] t_2a2b_ea2_BAAB_head = (t_2a2b_ea2_BAAB_dep >= t_2a2b_ea2_BAAB_issue) ? t_2a2b_ea2_BAAB_dep : t_2a2b_ea2_BAAB_issue;
wire [8:0] t_2a2b_ea2_BAAB_cycle = (B_len == 3'd4) ? t_2a2b_ea2_BAAB_head : 9'd511;
wire [8:0] t_2a2b_ea2_BABA_dep = t_2a2b_ea2_BA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_BABA_issue = t_2a2b_ea2_ABA_head + 9'd1;
wire [8:0] t_2a2b_ea2_BABA_head = (t_2a2b_ea2_BABA_dep >= t_2a2b_ea2_BABA_issue) ? t_2a2b_ea2_BABA_dep : t_2a2b_ea2_BABA_issue;
wire [8:0] t_2a2b_ea2_BABA_cycle = (B_len == 3'd4) ? t_2a2b_ea2_BABA_head : 9'd511;
wire [8:0] t_2a2b_ea2_BBAA_dep = t_2a2b_ea2_BAA_head + B_rev_lat[3];
wire [8:0] t_2a2b_ea2_BBAA_cycle = (B_len == 3'd4) ? t_2a2b_ea2_BBAA_dep : 9'd511;
wire m4_2a2b_ea2_tail_m0_0_pick = (t_2a2b_ea2_AAAA_cycle <= t_2a2b_ea2_AAAB_cycle);
wire [8:0] m4_2a2b_ea2_tail_m0_0_value = m4_2a2b_ea2_tail_m0_0_pick ? t_2a2b_ea2_AAAA_cycle : t_2a2b_ea2_AAAB_cycle;
wire [3:0] m4_2a2b_ea2_tail_m0_0_path = m4_2a2b_ea2_tail_m0_0_pick ? 4'b1111 : 4'b1110;
wire m4_2a2b_ea2_tail_m0_1_pick = (t_2a2b_ea2_AABA_cycle <= t_2a2b_ea2_AABB_cycle);
wire [8:0] m4_2a2b_ea2_tail_m0_1_value = m4_2a2b_ea2_tail_m0_1_pick ? t_2a2b_ea2_AABA_cycle : t_2a2b_ea2_AABB_cycle;
wire [3:0] m4_2a2b_ea2_tail_m0_1_path = m4_2a2b_ea2_tail_m0_1_pick ? 4'b1101 : 4'b1100;
wire m4_2a2b_ea2_tail_m0_2_pick = (t_2a2b_ea2_ABAA_cycle <= t_2a2b_ea2_ABAB_cycle);
wire [8:0] m4_2a2b_ea2_tail_m0_2_value = m4_2a2b_ea2_tail_m0_2_pick ? t_2a2b_ea2_ABAA_cycle : t_2a2b_ea2_ABAB_cycle;
wire [3:0] m4_2a2b_ea2_tail_m0_2_path = m4_2a2b_ea2_tail_m0_2_pick ? 4'b1011 : 4'b1010;
wire m4_2a2b_ea2_tail_m0_3_pick = (t_2a2b_ea2_ABBA_cycle <= t_2a2b_ea2_BAAA_cycle);
wire [8:0] m4_2a2b_ea2_tail_m0_3_value = m4_2a2b_ea2_tail_m0_3_pick ? t_2a2b_ea2_ABBA_cycle : t_2a2b_ea2_BAAA_cycle;
wire [3:0] m4_2a2b_ea2_tail_m0_3_path = m4_2a2b_ea2_tail_m0_3_pick ? 4'b1001 : 4'b0111;
wire m4_2a2b_ea2_tail_m0_4_pick = (t_2a2b_ea2_BAAB_cycle <= t_2a2b_ea2_BABA_cycle);
wire [8:0] m4_2a2b_ea2_tail_m0_4_value = m4_2a2b_ea2_tail_m0_4_pick ? t_2a2b_ea2_BAAB_cycle : t_2a2b_ea2_BABA_cycle;
wire [3:0] m4_2a2b_ea2_tail_m0_4_path = m4_2a2b_ea2_tail_m0_4_pick ? 4'b0110 : 4'b0101;
wire m4_2a2b_ea2_tail_m1_0_pick = (m4_2a2b_ea2_tail_m0_0_value <= m4_2a2b_ea2_tail_m0_1_value);
wire [8:0] m4_2a2b_ea2_tail_m1_0_value = m4_2a2b_ea2_tail_m1_0_pick ? m4_2a2b_ea2_tail_m0_0_value : m4_2a2b_ea2_tail_m0_1_value;
wire [3:0] m4_2a2b_ea2_tail_m1_0_path = m4_2a2b_ea2_tail_m1_0_pick ? m4_2a2b_ea2_tail_m0_0_path : m4_2a2b_ea2_tail_m0_1_path;
wire m4_2a2b_ea2_tail_m1_1_pick = (m4_2a2b_ea2_tail_m0_2_value <= m4_2a2b_ea2_tail_m0_3_value);
wire [8:0] m4_2a2b_ea2_tail_m1_1_value = m4_2a2b_ea2_tail_m1_1_pick ? m4_2a2b_ea2_tail_m0_2_value : m4_2a2b_ea2_tail_m0_3_value;
wire [3:0] m4_2a2b_ea2_tail_m1_1_path = m4_2a2b_ea2_tail_m1_1_pick ? m4_2a2b_ea2_tail_m0_2_path : m4_2a2b_ea2_tail_m0_3_path;
wire m4_2a2b_ea2_tail_m1_2_pick = (m4_2a2b_ea2_tail_m0_4_value <= t_2a2b_ea2_BBAA_cycle);
wire [8:0] m4_2a2b_ea2_tail_m1_2_value = m4_2a2b_ea2_tail_m1_2_pick ? m4_2a2b_ea2_tail_m0_4_value : t_2a2b_ea2_BBAA_cycle;
wire [3:0] m4_2a2b_ea2_tail_m1_2_path = m4_2a2b_ea2_tail_m1_2_pick ? m4_2a2b_ea2_tail_m0_4_path : 4'b0011;
wire m4_2a2b_ea2_tail_m2_0_pick = (m4_2a2b_ea2_tail_m1_0_value <= m4_2a2b_ea2_tail_m1_1_value);
wire [8:0] m4_2a2b_ea2_tail_m2_0_value = m4_2a2b_ea2_tail_m2_0_pick ? m4_2a2b_ea2_tail_m1_0_value : m4_2a2b_ea2_tail_m1_1_value;
wire [3:0] m4_2a2b_ea2_tail_m2_0_path = m4_2a2b_ea2_tail_m2_0_pick ? m4_2a2b_ea2_tail_m1_0_path : m4_2a2b_ea2_tail_m1_1_path;
wire m4_2a2b_ea2_tail_m3_0_pick = (m4_2a2b_ea2_tail_m2_0_value <= m4_2a2b_ea2_tail_m1_2_value);
wire [8:0] m4_2a2b_ea2_tail_m3_0_value = m4_2a2b_ea2_tail_m3_0_pick ? m4_2a2b_ea2_tail_m2_0_value : m4_2a2b_ea2_tail_m1_2_value;
wire [3:0] m4_2a2b_ea2_tail_m3_0_path = m4_2a2b_ea2_tail_m3_0_pick ? m4_2a2b_ea2_tail_m2_0_path : m4_2a2b_ea2_tail_m1_2_path;
wire [8:0] m4_2a2b_ea2_cycle = m4_2a2b_ea2_v ? m4_2a2b_ea2_tail_m3_0_value : 9'd511;
wire [7:0] m4_2a2b_ea2_path = {m4_2a2b_ea2_tail_m3_0_path, m4_2a2b_ea2_suffix};

// Shared continuation for m4_3a1b_ea0; suffix selection is outside this tree.
wire [7:0] t_3a1b_ea0_A_dep = m4_3a1b_ea0_ra + A_rev_lat[3];
wire [7:0] t_3a1b_ea0_A_issue = m4_3a1b_ea0_rb + 8'd1;
wire [7:0] t_3a1b_ea0_A_head = (t_3a1b_ea0_A_dep >= t_3a1b_ea0_A_issue) ? t_3a1b_ea0_A_dep : t_3a1b_ea0_A_issue;
wire [7:0] t_3a1b_ea0_B_dep = m4_3a1b_ea0_rb + B_rev_lat[1];
wire [7:0] t_3a1b_ea0_B_issue = m4_3a1b_ea0_ra + 8'd1;
wire [7:0] t_3a1b_ea0_B_head = (t_3a1b_ea0_B_dep >= t_3a1b_ea0_B_issue) ? t_3a1b_ea0_B_dep : t_3a1b_ea0_B_issue;
wire [8:0] t_3a1b_ea0_AA_dep = t_3a1b_ea0_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_AB_dep = m4_3a1b_ea0_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea0_AB_issue = t_3a1b_ea0_B_head + 9'd1;
wire [8:0] t_3a1b_ea0_AB_head = (t_3a1b_ea0_AB_dep >= t_3a1b_ea0_AB_issue) ? t_3a1b_ea0_AB_dep : t_3a1b_ea0_AB_issue;
wire [8:0] t_3a1b_ea0_BA_dep = m4_3a1b_ea0_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea0_BA_issue = t_3a1b_ea0_A_head + 9'd1;
wire [8:0] t_3a1b_ea0_BA_head = (t_3a1b_ea0_BA_dep >= t_3a1b_ea0_BA_issue) ? t_3a1b_ea0_BA_dep : t_3a1b_ea0_BA_issue;
wire [8:0] t_3a1b_ea0_BB_dep = t_3a1b_ea0_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_AAA_dep = t_3a1b_ea0_AA_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea0_AAB_dep = t_3a1b_ea0_AB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_ABA_dep = t_3a1b_ea0_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_ABA_issue = t_3a1b_ea0_BA_head + 9'd1;
wire [8:0] t_3a1b_ea0_ABA_head = (t_3a1b_ea0_ABA_dep >= t_3a1b_ea0_ABA_issue) ? t_3a1b_ea0_ABA_dep : t_3a1b_ea0_ABA_issue;
wire [8:0] t_3a1b_ea0_ABB_dep = m4_3a1b_ea0_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea0_ABB_issue = t_3a1b_ea0_BB_dep + 9'd1;
wire [8:0] t_3a1b_ea0_ABB_head = (t_3a1b_ea0_ABB_dep >= t_3a1b_ea0_ABB_issue) ? t_3a1b_ea0_ABB_dep : t_3a1b_ea0_ABB_issue;
wire [8:0] t_3a1b_ea0_BAA_dep = m4_3a1b_ea0_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea0_BAA_issue = t_3a1b_ea0_AA_dep + 9'd1;
wire [8:0] t_3a1b_ea0_BAA_head = (t_3a1b_ea0_BAA_dep >= t_3a1b_ea0_BAA_issue) ? t_3a1b_ea0_BAA_dep : t_3a1b_ea0_BAA_issue;
wire [8:0] t_3a1b_ea0_BAB_dep = t_3a1b_ea0_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_BAB_issue = t_3a1b_ea0_AB_head + 9'd1;
wire [8:0] t_3a1b_ea0_BAB_head = (t_3a1b_ea0_BAB_dep >= t_3a1b_ea0_BAB_issue) ? t_3a1b_ea0_BAB_dep : t_3a1b_ea0_BAB_issue;
wire [8:0] t_3a1b_ea0_BBA_dep = t_3a1b_ea0_BA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_BBB_dep = t_3a1b_ea0_BB_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea0_AAAB_dep = t_3a1b_ea0_AAB_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea0_AAAB_cycle = (B_len == 3'd2) ? t_3a1b_ea0_AAAB_dep : 9'd511;
wire [8:0] t_3a1b_ea0_AABA_dep = t_3a1b_ea0_ABA_head + A_rev_lat[5];
wire [8:0] t_3a1b_ea0_AABA_cycle = (B_len == 3'd2) ? t_3a1b_ea0_AABA_dep : 9'd511;
wire [8:0] t_3a1b_ea0_AABB_dep = t_3a1b_ea0_ABB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_AABB_cycle = (B_len == 3'd3) ? t_3a1b_ea0_AABB_dep : 9'd511;
wire [8:0] t_3a1b_ea0_ABAA_dep = t_3a1b_ea0_AA_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea0_ABAA_issue = t_3a1b_ea0_BAA_head + 9'd1;
wire [8:0] t_3a1b_ea0_ABAA_head = (t_3a1b_ea0_ABAA_dep >= t_3a1b_ea0_ABAA_issue) ? t_3a1b_ea0_ABAA_dep : t_3a1b_ea0_ABAA_issue;
wire [8:0] t_3a1b_ea0_ABAA_cycle = (B_len == 3'd2) ? t_3a1b_ea0_ABAA_head : 9'd511;
wire [8:0] t_3a1b_ea0_ABAB_dep = t_3a1b_ea0_AB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_ABAB_issue = t_3a1b_ea0_BAB_head + 9'd1;
wire [8:0] t_3a1b_ea0_ABAB_head = (t_3a1b_ea0_ABAB_dep >= t_3a1b_ea0_ABAB_issue) ? t_3a1b_ea0_ABAB_dep : t_3a1b_ea0_ABAB_issue;
wire [8:0] t_3a1b_ea0_ABAB_cycle = (B_len == 3'd3) ? t_3a1b_ea0_ABAB_head : 9'd511;
wire [8:0] t_3a1b_ea0_ABBA_dep = t_3a1b_ea0_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea0_ABBA_issue = t_3a1b_ea0_BBA_dep + 9'd1;
wire [8:0] t_3a1b_ea0_ABBA_head = (t_3a1b_ea0_ABBA_dep >= t_3a1b_ea0_ABBA_issue) ? t_3a1b_ea0_ABBA_dep : t_3a1b_ea0_ABBA_issue;
wire [8:0] t_3a1b_ea0_ABBA_cycle = (B_len == 3'd3) ? t_3a1b_ea0_ABBA_head : 9'd511;
wire [8:0] t_3a1b_ea0_ABBB_dep = m4_3a1b_ea0_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea0_ABBB_issue = t_3a1b_ea0_BBB_dep + 9'd1;
wire [8:0] t_3a1b_ea0_ABBB_head = (t_3a1b_ea0_ABBB_dep >= t_3a1b_ea0_ABBB_issue) ? t_3a1b_ea0_ABBB_dep : t_3a1b_ea0_ABBB_issue;
wire [8:0] t_3a1b_ea0_ABBB_cycle = (B_len == 3'd4) ? t_3a1b_ea0_ABBB_head : 9'd511;
wire [8:0] t_3a1b_ea0_BAAA_dep = m4_3a1b_ea0_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea0_BAAA_issue = t_3a1b_ea0_AAA_dep + 9'd1;
wire [8:0] t_3a1b_ea0_BAAA_head = (t_3a1b_ea0_BAAA_dep >= t_3a1b_ea0_BAAA_issue) ? t_3a1b_ea0_BAAA_dep : t_3a1b_ea0_BAAA_issue;
wire [8:0] t_3a1b_ea0_BAAA_cycle = (B_len == 3'd2) ? t_3a1b_ea0_BAAA_head : 9'd511;
wire [8:0] t_3a1b_ea0_BAAB_dep = t_3a1b_ea0_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_BAAB_issue = t_3a1b_ea0_AAB_dep + 9'd1;
wire [8:0] t_3a1b_ea0_BAAB_head = (t_3a1b_ea0_BAAB_dep >= t_3a1b_ea0_BAAB_issue) ? t_3a1b_ea0_BAAB_dep : t_3a1b_ea0_BAAB_issue;
wire [8:0] t_3a1b_ea0_BAAB_cycle = (B_len == 3'd3) ? t_3a1b_ea0_BAAB_head : 9'd511;
wire [8:0] t_3a1b_ea0_BABA_dep = t_3a1b_ea0_BA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_BABA_issue = t_3a1b_ea0_ABA_head + 9'd1;
wire [8:0] t_3a1b_ea0_BABA_head = (t_3a1b_ea0_BABA_dep >= t_3a1b_ea0_BABA_issue) ? t_3a1b_ea0_BABA_dep : t_3a1b_ea0_BABA_issue;
wire [8:0] t_3a1b_ea0_BABA_cycle = (B_len == 3'd3) ? t_3a1b_ea0_BABA_head : 9'd511;
wire [8:0] t_3a1b_ea0_BABB_dep = t_3a1b_ea0_BB_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea0_BABB_issue = t_3a1b_ea0_ABB_head + 9'd1;
wire [8:0] t_3a1b_ea0_BABB_head = (t_3a1b_ea0_BABB_dep >= t_3a1b_ea0_BABB_issue) ? t_3a1b_ea0_BABB_dep : t_3a1b_ea0_BABB_issue;
wire [8:0] t_3a1b_ea0_BABB_cycle = (B_len == 3'd4) ? t_3a1b_ea0_BABB_head : 9'd511;
wire [8:0] t_3a1b_ea0_BBAA_dep = t_3a1b_ea0_BAA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea0_BBAA_cycle = (B_len == 3'd3) ? t_3a1b_ea0_BBAA_dep : 9'd511;
wire [8:0] t_3a1b_ea0_BBAB_dep = t_3a1b_ea0_BAB_head + B_rev_lat[3];
wire [8:0] t_3a1b_ea0_BBAB_cycle = (B_len == 3'd4) ? t_3a1b_ea0_BBAB_dep : 9'd511;
wire [8:0] t_3a1b_ea0_BBBA_dep = t_3a1b_ea0_BBA_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea0_BBBA_cycle = (B_len == 3'd4) ? t_3a1b_ea0_BBBA_dep : 9'd511;
wire m4_3a1b_ea0_tail_m0_0_pick = (t_3a1b_ea0_AAAB_cycle <= t_3a1b_ea0_AABA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_0_value = m4_3a1b_ea0_tail_m0_0_pick ? t_3a1b_ea0_AAAB_cycle : t_3a1b_ea0_AABA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_0_path = m4_3a1b_ea0_tail_m0_0_pick ? 4'b1110 : 4'b1101;
wire m4_3a1b_ea0_tail_m0_1_pick = (t_3a1b_ea0_AABB_cycle <= t_3a1b_ea0_ABAA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_1_value = m4_3a1b_ea0_tail_m0_1_pick ? t_3a1b_ea0_AABB_cycle : t_3a1b_ea0_ABAA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_1_path = m4_3a1b_ea0_tail_m0_1_pick ? 4'b1100 : 4'b1011;
wire m4_3a1b_ea0_tail_m0_2_pick = (t_3a1b_ea0_ABAB_cycle <= t_3a1b_ea0_ABBA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_2_value = m4_3a1b_ea0_tail_m0_2_pick ? t_3a1b_ea0_ABAB_cycle : t_3a1b_ea0_ABBA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_2_path = m4_3a1b_ea0_tail_m0_2_pick ? 4'b1010 : 4'b1001;
wire m4_3a1b_ea0_tail_m0_3_pick = (t_3a1b_ea0_ABBB_cycle <= t_3a1b_ea0_BAAA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_3_value = m4_3a1b_ea0_tail_m0_3_pick ? t_3a1b_ea0_ABBB_cycle : t_3a1b_ea0_BAAA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_3_path = m4_3a1b_ea0_tail_m0_3_pick ? 4'b1000 : 4'b0111;
wire m4_3a1b_ea0_tail_m0_4_pick = (t_3a1b_ea0_BAAB_cycle <= t_3a1b_ea0_BABA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_4_value = m4_3a1b_ea0_tail_m0_4_pick ? t_3a1b_ea0_BAAB_cycle : t_3a1b_ea0_BABA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_4_path = m4_3a1b_ea0_tail_m0_4_pick ? 4'b0110 : 4'b0101;
wire m4_3a1b_ea0_tail_m0_5_pick = (t_3a1b_ea0_BABB_cycle <= t_3a1b_ea0_BBAA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_5_value = m4_3a1b_ea0_tail_m0_5_pick ? t_3a1b_ea0_BABB_cycle : t_3a1b_ea0_BBAA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_5_path = m4_3a1b_ea0_tail_m0_5_pick ? 4'b0100 : 4'b0011;
wire m4_3a1b_ea0_tail_m0_6_pick = (t_3a1b_ea0_BBAB_cycle <= t_3a1b_ea0_BBBA_cycle);
wire [8:0] m4_3a1b_ea0_tail_m0_6_value = m4_3a1b_ea0_tail_m0_6_pick ? t_3a1b_ea0_BBAB_cycle : t_3a1b_ea0_BBBA_cycle;
wire [3:0] m4_3a1b_ea0_tail_m0_6_path = m4_3a1b_ea0_tail_m0_6_pick ? 4'b0010 : 4'b0001;
wire m4_3a1b_ea0_tail_m1_0_pick = (m4_3a1b_ea0_tail_m0_0_value <= m4_3a1b_ea0_tail_m0_1_value);
wire [8:0] m4_3a1b_ea0_tail_m1_0_value = m4_3a1b_ea0_tail_m1_0_pick ? m4_3a1b_ea0_tail_m0_0_value : m4_3a1b_ea0_tail_m0_1_value;
wire [3:0] m4_3a1b_ea0_tail_m1_0_path = m4_3a1b_ea0_tail_m1_0_pick ? m4_3a1b_ea0_tail_m0_0_path : m4_3a1b_ea0_tail_m0_1_path;
wire m4_3a1b_ea0_tail_m1_1_pick = (m4_3a1b_ea0_tail_m0_2_value <= m4_3a1b_ea0_tail_m0_3_value);
wire [8:0] m4_3a1b_ea0_tail_m1_1_value = m4_3a1b_ea0_tail_m1_1_pick ? m4_3a1b_ea0_tail_m0_2_value : m4_3a1b_ea0_tail_m0_3_value;
wire [3:0] m4_3a1b_ea0_tail_m1_1_path = m4_3a1b_ea0_tail_m1_1_pick ? m4_3a1b_ea0_tail_m0_2_path : m4_3a1b_ea0_tail_m0_3_path;
wire m4_3a1b_ea0_tail_m1_2_pick = (m4_3a1b_ea0_tail_m0_4_value <= m4_3a1b_ea0_tail_m0_5_value);
wire [8:0] m4_3a1b_ea0_tail_m1_2_value = m4_3a1b_ea0_tail_m1_2_pick ? m4_3a1b_ea0_tail_m0_4_value : m4_3a1b_ea0_tail_m0_5_value;
wire [3:0] m4_3a1b_ea0_tail_m1_2_path = m4_3a1b_ea0_tail_m1_2_pick ? m4_3a1b_ea0_tail_m0_4_path : m4_3a1b_ea0_tail_m0_5_path;
wire m4_3a1b_ea0_tail_m2_0_pick = (m4_3a1b_ea0_tail_m1_0_value <= m4_3a1b_ea0_tail_m1_1_value);
wire [8:0] m4_3a1b_ea0_tail_m2_0_value = m4_3a1b_ea0_tail_m2_0_pick ? m4_3a1b_ea0_tail_m1_0_value : m4_3a1b_ea0_tail_m1_1_value;
wire [3:0] m4_3a1b_ea0_tail_m2_0_path = m4_3a1b_ea0_tail_m2_0_pick ? m4_3a1b_ea0_tail_m1_0_path : m4_3a1b_ea0_tail_m1_1_path;
wire m4_3a1b_ea0_tail_m2_1_pick = (m4_3a1b_ea0_tail_m1_2_value <= m4_3a1b_ea0_tail_m0_6_value);
wire [8:0] m4_3a1b_ea0_tail_m2_1_value = m4_3a1b_ea0_tail_m2_1_pick ? m4_3a1b_ea0_tail_m1_2_value : m4_3a1b_ea0_tail_m0_6_value;
wire [3:0] m4_3a1b_ea0_tail_m2_1_path = m4_3a1b_ea0_tail_m2_1_pick ? m4_3a1b_ea0_tail_m1_2_path : m4_3a1b_ea0_tail_m0_6_path;
wire m4_3a1b_ea0_tail_m3_0_pick = (m4_3a1b_ea0_tail_m2_0_value <= m4_3a1b_ea0_tail_m2_1_value);
wire [8:0] m4_3a1b_ea0_tail_m3_0_value = m4_3a1b_ea0_tail_m3_0_pick ? m4_3a1b_ea0_tail_m2_0_value : m4_3a1b_ea0_tail_m2_1_value;
wire [3:0] m4_3a1b_ea0_tail_m3_0_path = m4_3a1b_ea0_tail_m3_0_pick ? m4_3a1b_ea0_tail_m2_0_path : m4_3a1b_ea0_tail_m2_1_path;
wire [8:0] m4_3a1b_ea0_cycle = m4_3a1b_ea0_v ? m4_3a1b_ea0_tail_m3_0_value : 9'd511;
wire [7:0] m4_3a1b_ea0_path = {m4_3a1b_ea0_tail_m3_0_path, m4_3a1b_ea0_suffix};

// Shared continuation for m4_3a1b_ea1; suffix selection is outside this tree.
wire [7:0] t_3a1b_ea1_A_dep = m4_3a1b_ea1_ra + A_rev_lat[3];
wire [7:0] t_3a1b_ea1_A_issue = m4_3a1b_ea1_rb + 8'd1;
wire [7:0] t_3a1b_ea1_A_head = (t_3a1b_ea1_A_dep >= t_3a1b_ea1_A_issue) ? t_3a1b_ea1_A_dep : t_3a1b_ea1_A_issue;
wire [7:0] t_3a1b_ea1_B_dep = m4_3a1b_ea1_rb + B_rev_lat[1];
wire [7:0] t_3a1b_ea1_B_issue = m4_3a1b_ea1_ra + 8'd1;
wire [7:0] t_3a1b_ea1_B_head = (t_3a1b_ea1_B_dep >= t_3a1b_ea1_B_issue) ? t_3a1b_ea1_B_dep : t_3a1b_ea1_B_issue;
wire [8:0] t_3a1b_ea1_AA_dep = t_3a1b_ea1_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_AB_dep = m4_3a1b_ea1_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea1_AB_issue = t_3a1b_ea1_B_head + 9'd1;
wire [8:0] t_3a1b_ea1_AB_head = (t_3a1b_ea1_AB_dep >= t_3a1b_ea1_AB_issue) ? t_3a1b_ea1_AB_dep : t_3a1b_ea1_AB_issue;
wire [8:0] t_3a1b_ea1_BA_dep = m4_3a1b_ea1_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea1_BA_issue = t_3a1b_ea1_A_head + 9'd1;
wire [8:0] t_3a1b_ea1_BA_head = (t_3a1b_ea1_BA_dep >= t_3a1b_ea1_BA_issue) ? t_3a1b_ea1_BA_dep : t_3a1b_ea1_BA_issue;
wire [8:0] t_3a1b_ea1_BB_dep = t_3a1b_ea1_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_AAA_dep = t_3a1b_ea1_AA_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea1_AAB_dep = t_3a1b_ea1_AB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_ABA_dep = t_3a1b_ea1_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_ABA_issue = t_3a1b_ea1_BA_head + 9'd1;
wire [8:0] t_3a1b_ea1_ABA_head = (t_3a1b_ea1_ABA_dep >= t_3a1b_ea1_ABA_issue) ? t_3a1b_ea1_ABA_dep : t_3a1b_ea1_ABA_issue;
wire [8:0] t_3a1b_ea1_ABB_dep = m4_3a1b_ea1_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea1_ABB_issue = t_3a1b_ea1_BB_dep + 9'd1;
wire [8:0] t_3a1b_ea1_ABB_head = (t_3a1b_ea1_ABB_dep >= t_3a1b_ea1_ABB_issue) ? t_3a1b_ea1_ABB_dep : t_3a1b_ea1_ABB_issue;
wire [8:0] t_3a1b_ea1_BAA_dep = m4_3a1b_ea1_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea1_BAA_issue = t_3a1b_ea1_AA_dep + 9'd1;
wire [8:0] t_3a1b_ea1_BAA_head = (t_3a1b_ea1_BAA_dep >= t_3a1b_ea1_BAA_issue) ? t_3a1b_ea1_BAA_dep : t_3a1b_ea1_BAA_issue;
wire [8:0] t_3a1b_ea1_BAB_dep = t_3a1b_ea1_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_BAB_issue = t_3a1b_ea1_AB_head + 9'd1;
wire [8:0] t_3a1b_ea1_BAB_head = (t_3a1b_ea1_BAB_dep >= t_3a1b_ea1_BAB_issue) ? t_3a1b_ea1_BAB_dep : t_3a1b_ea1_BAB_issue;
wire [8:0] t_3a1b_ea1_BBA_dep = t_3a1b_ea1_BA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_BBB_dep = t_3a1b_ea1_BB_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea1_AAAB_dep = t_3a1b_ea1_AAB_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea1_AAAB_cycle = (B_len == 3'd2) ? t_3a1b_ea1_AAAB_dep : 9'd511;
wire [8:0] t_3a1b_ea1_AABA_dep = t_3a1b_ea1_ABA_head + A_rev_lat[5];
wire [8:0] t_3a1b_ea1_AABA_cycle = (B_len == 3'd2) ? t_3a1b_ea1_AABA_dep : 9'd511;
wire [8:0] t_3a1b_ea1_AABB_dep = t_3a1b_ea1_ABB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_AABB_cycle = (B_len == 3'd3) ? t_3a1b_ea1_AABB_dep : 9'd511;
wire [8:0] t_3a1b_ea1_ABAA_dep = t_3a1b_ea1_AA_dep + A_rev_lat[5];
wire [8:0] t_3a1b_ea1_ABAA_issue = t_3a1b_ea1_BAA_head + 9'd1;
wire [8:0] t_3a1b_ea1_ABAA_head = (t_3a1b_ea1_ABAA_dep >= t_3a1b_ea1_ABAA_issue) ? t_3a1b_ea1_ABAA_dep : t_3a1b_ea1_ABAA_issue;
wire [8:0] t_3a1b_ea1_ABAA_cycle = (B_len == 3'd2) ? t_3a1b_ea1_ABAA_head : 9'd511;
wire [8:0] t_3a1b_ea1_ABAB_dep = t_3a1b_ea1_AB_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_ABAB_issue = t_3a1b_ea1_BAB_head + 9'd1;
wire [8:0] t_3a1b_ea1_ABAB_head = (t_3a1b_ea1_ABAB_dep >= t_3a1b_ea1_ABAB_issue) ? t_3a1b_ea1_ABAB_dep : t_3a1b_ea1_ABAB_issue;
wire [8:0] t_3a1b_ea1_ABAB_cycle = (B_len == 3'd3) ? t_3a1b_ea1_ABAB_head : 9'd511;
wire [8:0] t_3a1b_ea1_ABBA_dep = t_3a1b_ea1_A_head + A_rev_lat[4];
wire [8:0] t_3a1b_ea1_ABBA_issue = t_3a1b_ea1_BBA_dep + 9'd1;
wire [8:0] t_3a1b_ea1_ABBA_head = (t_3a1b_ea1_ABBA_dep >= t_3a1b_ea1_ABBA_issue) ? t_3a1b_ea1_ABBA_dep : t_3a1b_ea1_ABBA_issue;
wire [8:0] t_3a1b_ea1_ABBA_cycle = (B_len == 3'd3) ? t_3a1b_ea1_ABBA_head : 9'd511;
wire [8:0] t_3a1b_ea1_ABBB_dep = m4_3a1b_ea1_ra + A_rev_lat[3];
wire [8:0] t_3a1b_ea1_ABBB_issue = t_3a1b_ea1_BBB_dep + 9'd1;
wire [8:0] t_3a1b_ea1_ABBB_head = (t_3a1b_ea1_ABBB_dep >= t_3a1b_ea1_ABBB_issue) ? t_3a1b_ea1_ABBB_dep : t_3a1b_ea1_ABBB_issue;
wire [8:0] t_3a1b_ea1_ABBB_cycle = (B_len == 3'd4) ? t_3a1b_ea1_ABBB_head : 9'd511;
wire [8:0] t_3a1b_ea1_BAAA_dep = m4_3a1b_ea1_rb + B_rev_lat[1];
wire [8:0] t_3a1b_ea1_BAAA_issue = t_3a1b_ea1_AAA_dep + 9'd1;
wire [8:0] t_3a1b_ea1_BAAA_head = (t_3a1b_ea1_BAAA_dep >= t_3a1b_ea1_BAAA_issue) ? t_3a1b_ea1_BAAA_dep : t_3a1b_ea1_BAAA_issue;
wire [8:0] t_3a1b_ea1_BAAA_cycle = (B_len == 3'd2) ? t_3a1b_ea1_BAAA_head : 9'd511;
wire [8:0] t_3a1b_ea1_BAAB_dep = t_3a1b_ea1_B_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_BAAB_issue = t_3a1b_ea1_AAB_dep + 9'd1;
wire [8:0] t_3a1b_ea1_BAAB_head = (t_3a1b_ea1_BAAB_dep >= t_3a1b_ea1_BAAB_issue) ? t_3a1b_ea1_BAAB_dep : t_3a1b_ea1_BAAB_issue;
wire [8:0] t_3a1b_ea1_BAAB_cycle = (B_len == 3'd3) ? t_3a1b_ea1_BAAB_head : 9'd511;
wire [8:0] t_3a1b_ea1_BABA_dep = t_3a1b_ea1_BA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_BABA_issue = t_3a1b_ea1_ABA_head + 9'd1;
wire [8:0] t_3a1b_ea1_BABA_head = (t_3a1b_ea1_BABA_dep >= t_3a1b_ea1_BABA_issue) ? t_3a1b_ea1_BABA_dep : t_3a1b_ea1_BABA_issue;
wire [8:0] t_3a1b_ea1_BABA_cycle = (B_len == 3'd3) ? t_3a1b_ea1_BABA_head : 9'd511;
wire [8:0] t_3a1b_ea1_BABB_dep = t_3a1b_ea1_BB_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea1_BABB_issue = t_3a1b_ea1_ABB_head + 9'd1;
wire [8:0] t_3a1b_ea1_BABB_head = (t_3a1b_ea1_BABB_dep >= t_3a1b_ea1_BABB_issue) ? t_3a1b_ea1_BABB_dep : t_3a1b_ea1_BABB_issue;
wire [8:0] t_3a1b_ea1_BABB_cycle = (B_len == 3'd4) ? t_3a1b_ea1_BABB_head : 9'd511;
wire [8:0] t_3a1b_ea1_BBAA_dep = t_3a1b_ea1_BAA_head + B_rev_lat[2];
wire [8:0] t_3a1b_ea1_BBAA_cycle = (B_len == 3'd3) ? t_3a1b_ea1_BBAA_dep : 9'd511;
wire [8:0] t_3a1b_ea1_BBAB_dep = t_3a1b_ea1_BAB_head + B_rev_lat[3];
wire [8:0] t_3a1b_ea1_BBAB_cycle = (B_len == 3'd4) ? t_3a1b_ea1_BBAB_dep : 9'd511;
wire [8:0] t_3a1b_ea1_BBBA_dep = t_3a1b_ea1_BBA_dep + B_rev_lat[3];
wire [8:0] t_3a1b_ea1_BBBA_cycle = (B_len == 3'd4) ? t_3a1b_ea1_BBBA_dep : 9'd511;
wire m4_3a1b_ea1_tail_m0_0_pick = (t_3a1b_ea1_AAAB_cycle <= t_3a1b_ea1_AABA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_0_value = m4_3a1b_ea1_tail_m0_0_pick ? t_3a1b_ea1_AAAB_cycle : t_3a1b_ea1_AABA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_0_path = m4_3a1b_ea1_tail_m0_0_pick ? 4'b1110 : 4'b1101;
wire m4_3a1b_ea1_tail_m0_1_pick = (t_3a1b_ea1_AABB_cycle <= t_3a1b_ea1_ABAA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_1_value = m4_3a1b_ea1_tail_m0_1_pick ? t_3a1b_ea1_AABB_cycle : t_3a1b_ea1_ABAA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_1_path = m4_3a1b_ea1_tail_m0_1_pick ? 4'b1100 : 4'b1011;
wire m4_3a1b_ea1_tail_m0_2_pick = (t_3a1b_ea1_ABAB_cycle <= t_3a1b_ea1_ABBA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_2_value = m4_3a1b_ea1_tail_m0_2_pick ? t_3a1b_ea1_ABAB_cycle : t_3a1b_ea1_ABBA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_2_path = m4_3a1b_ea1_tail_m0_2_pick ? 4'b1010 : 4'b1001;
wire m4_3a1b_ea1_tail_m0_3_pick = (t_3a1b_ea1_ABBB_cycle <= t_3a1b_ea1_BAAA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_3_value = m4_3a1b_ea1_tail_m0_3_pick ? t_3a1b_ea1_ABBB_cycle : t_3a1b_ea1_BAAA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_3_path = m4_3a1b_ea1_tail_m0_3_pick ? 4'b1000 : 4'b0111;
wire m4_3a1b_ea1_tail_m0_4_pick = (t_3a1b_ea1_BAAB_cycle <= t_3a1b_ea1_BABA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_4_value = m4_3a1b_ea1_tail_m0_4_pick ? t_3a1b_ea1_BAAB_cycle : t_3a1b_ea1_BABA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_4_path = m4_3a1b_ea1_tail_m0_4_pick ? 4'b0110 : 4'b0101;
wire m4_3a1b_ea1_tail_m0_5_pick = (t_3a1b_ea1_BABB_cycle <= t_3a1b_ea1_BBAA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_5_value = m4_3a1b_ea1_tail_m0_5_pick ? t_3a1b_ea1_BABB_cycle : t_3a1b_ea1_BBAA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_5_path = m4_3a1b_ea1_tail_m0_5_pick ? 4'b0100 : 4'b0011;
wire m4_3a1b_ea1_tail_m0_6_pick = (t_3a1b_ea1_BBAB_cycle <= t_3a1b_ea1_BBBA_cycle);
wire [8:0] m4_3a1b_ea1_tail_m0_6_value = m4_3a1b_ea1_tail_m0_6_pick ? t_3a1b_ea1_BBAB_cycle : t_3a1b_ea1_BBBA_cycle;
wire [3:0] m4_3a1b_ea1_tail_m0_6_path = m4_3a1b_ea1_tail_m0_6_pick ? 4'b0010 : 4'b0001;
wire m4_3a1b_ea1_tail_m1_0_pick = (m4_3a1b_ea1_tail_m0_0_value <= m4_3a1b_ea1_tail_m0_1_value);
wire [8:0] m4_3a1b_ea1_tail_m1_0_value = m4_3a1b_ea1_tail_m1_0_pick ? m4_3a1b_ea1_tail_m0_0_value : m4_3a1b_ea1_tail_m0_1_value;
wire [3:0] m4_3a1b_ea1_tail_m1_0_path = m4_3a1b_ea1_tail_m1_0_pick ? m4_3a1b_ea1_tail_m0_0_path : m4_3a1b_ea1_tail_m0_1_path;
wire m4_3a1b_ea1_tail_m1_1_pick = (m4_3a1b_ea1_tail_m0_2_value <= m4_3a1b_ea1_tail_m0_3_value);
wire [8:0] m4_3a1b_ea1_tail_m1_1_value = m4_3a1b_ea1_tail_m1_1_pick ? m4_3a1b_ea1_tail_m0_2_value : m4_3a1b_ea1_tail_m0_3_value;
wire [3:0] m4_3a1b_ea1_tail_m1_1_path = m4_3a1b_ea1_tail_m1_1_pick ? m4_3a1b_ea1_tail_m0_2_path : m4_3a1b_ea1_tail_m0_3_path;
wire m4_3a1b_ea1_tail_m1_2_pick = (m4_3a1b_ea1_tail_m0_4_value <= m4_3a1b_ea1_tail_m0_5_value);
wire [8:0] m4_3a1b_ea1_tail_m1_2_value = m4_3a1b_ea1_tail_m1_2_pick ? m4_3a1b_ea1_tail_m0_4_value : m4_3a1b_ea1_tail_m0_5_value;
wire [3:0] m4_3a1b_ea1_tail_m1_2_path = m4_3a1b_ea1_tail_m1_2_pick ? m4_3a1b_ea1_tail_m0_4_path : m4_3a1b_ea1_tail_m0_5_path;
wire m4_3a1b_ea1_tail_m2_0_pick = (m4_3a1b_ea1_tail_m1_0_value <= m4_3a1b_ea1_tail_m1_1_value);
wire [8:0] m4_3a1b_ea1_tail_m2_0_value = m4_3a1b_ea1_tail_m2_0_pick ? m4_3a1b_ea1_tail_m1_0_value : m4_3a1b_ea1_tail_m1_1_value;
wire [3:0] m4_3a1b_ea1_tail_m2_0_path = m4_3a1b_ea1_tail_m2_0_pick ? m4_3a1b_ea1_tail_m1_0_path : m4_3a1b_ea1_tail_m1_1_path;
wire m4_3a1b_ea1_tail_m2_1_pick = (m4_3a1b_ea1_tail_m1_2_value <= m4_3a1b_ea1_tail_m0_6_value);
wire [8:0] m4_3a1b_ea1_tail_m2_1_value = m4_3a1b_ea1_tail_m2_1_pick ? m4_3a1b_ea1_tail_m1_2_value : m4_3a1b_ea1_tail_m0_6_value;
wire [3:0] m4_3a1b_ea1_tail_m2_1_path = m4_3a1b_ea1_tail_m2_1_pick ? m4_3a1b_ea1_tail_m1_2_path : m4_3a1b_ea1_tail_m0_6_path;
wire m4_3a1b_ea1_tail_m3_0_pick = (m4_3a1b_ea1_tail_m2_0_value <= m4_3a1b_ea1_tail_m2_1_value);
wire [8:0] m4_3a1b_ea1_tail_m3_0_value = m4_3a1b_ea1_tail_m3_0_pick ? m4_3a1b_ea1_tail_m2_0_value : m4_3a1b_ea1_tail_m2_1_value;
wire [3:0] m4_3a1b_ea1_tail_m3_0_path = m4_3a1b_ea1_tail_m3_0_pick ? m4_3a1b_ea1_tail_m2_0_path : m4_3a1b_ea1_tail_m2_1_path;
wire [8:0] m4_3a1b_ea1_cycle = m4_3a1b_ea1_v ? m4_3a1b_ea1_tail_m3_0_value : 9'd511;
wire [7:0] m4_3a1b_ea1_path = {m4_3a1b_ea1_tail_m3_0_path, m4_3a1b_ea1_suffix};

// Shared continuation for m4_4a0b_ea0; suffix selection is outside this tree.
wire [7:0] t_4a0b_ea0_A_dep = m4_4a0b_ea0_ra + A_rev_lat[4];
wire [7:0] t_4a0b_ea0_A_issue = m4_4a0b_ea0_rb + 8'd1;
wire [7:0] t_4a0b_ea0_A_head = (t_4a0b_ea0_A_dep >= t_4a0b_ea0_A_issue) ? t_4a0b_ea0_A_dep : t_4a0b_ea0_A_issue;
wire [7:0] t_4a0b_ea0_B_dep = m4_4a0b_ea0_rb + B_rev_lat[0];
wire [7:0] t_4a0b_ea0_B_issue = m4_4a0b_ea0_ra + 8'd1;
wire [7:0] t_4a0b_ea0_B_head = (t_4a0b_ea0_B_dep >= t_4a0b_ea0_B_issue) ? t_4a0b_ea0_B_dep : t_4a0b_ea0_B_issue;
wire [8:0] t_4a0b_ea0_AA_dep = t_4a0b_ea0_A_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_AB_dep = m4_4a0b_ea0_ra + A_rev_lat[4];
wire [8:0] t_4a0b_ea0_AB_issue = t_4a0b_ea0_B_head + 9'd1;
wire [8:0] t_4a0b_ea0_AB_head = (t_4a0b_ea0_AB_dep >= t_4a0b_ea0_AB_issue) ? t_4a0b_ea0_AB_dep : t_4a0b_ea0_AB_issue;
wire [8:0] t_4a0b_ea0_BA_dep = m4_4a0b_ea0_rb + B_rev_lat[0];
wire [8:0] t_4a0b_ea0_BA_issue = t_4a0b_ea0_A_head + 9'd1;
wire [8:0] t_4a0b_ea0_BA_head = (t_4a0b_ea0_BA_dep >= t_4a0b_ea0_BA_issue) ? t_4a0b_ea0_BA_dep : t_4a0b_ea0_BA_issue;
wire [8:0] t_4a0b_ea0_BB_dep = t_4a0b_ea0_B_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_AAB_dep = t_4a0b_ea0_AB_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABA_dep = t_4a0b_ea0_A_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABA_issue = t_4a0b_ea0_BA_head + 9'd1;
wire [8:0] t_4a0b_ea0_ABA_head = (t_4a0b_ea0_ABA_dep >= t_4a0b_ea0_ABA_issue) ? t_4a0b_ea0_ABA_dep : t_4a0b_ea0_ABA_issue;
wire [8:0] t_4a0b_ea0_ABB_dep = m4_4a0b_ea0_ra + A_rev_lat[4];
wire [8:0] t_4a0b_ea0_ABB_issue = t_4a0b_ea0_BB_dep + 9'd1;
wire [8:0] t_4a0b_ea0_ABB_head = (t_4a0b_ea0_ABB_dep >= t_4a0b_ea0_ABB_issue) ? t_4a0b_ea0_ABB_dep : t_4a0b_ea0_ABB_issue;
wire [8:0] t_4a0b_ea0_BAA_dep = m4_4a0b_ea0_rb + B_rev_lat[0];
wire [8:0] t_4a0b_ea0_BAA_issue = t_4a0b_ea0_AA_dep + 9'd1;
wire [8:0] t_4a0b_ea0_BAA_head = (t_4a0b_ea0_BAA_dep >= t_4a0b_ea0_BAA_issue) ? t_4a0b_ea0_BAA_dep : t_4a0b_ea0_BAA_issue;
wire [8:0] t_4a0b_ea0_BAB_dep = t_4a0b_ea0_B_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BAB_issue = t_4a0b_ea0_AB_head + 9'd1;
wire [8:0] t_4a0b_ea0_BAB_head = (t_4a0b_ea0_BAB_dep >= t_4a0b_ea0_BAB_issue) ? t_4a0b_ea0_BAB_dep : t_4a0b_ea0_BAB_issue;
wire [8:0] t_4a0b_ea0_BBA_dep = t_4a0b_ea0_BA_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BBB_dep = t_4a0b_ea0_BB_dep + B_rev_lat[2];
wire [8:0] t_4a0b_ea0_AABB_dep = t_4a0b_ea0_ABB_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_AABB_cycle = (B_len == 3'd2) ? t_4a0b_ea0_AABB_dep : 9'd511;
wire [8:0] t_4a0b_ea0_ABAB_dep = t_4a0b_ea0_AB_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABAB_issue = t_4a0b_ea0_BAB_head + 9'd1;
wire [8:0] t_4a0b_ea0_ABAB_head = (t_4a0b_ea0_ABAB_dep >= t_4a0b_ea0_ABAB_issue) ? t_4a0b_ea0_ABAB_dep : t_4a0b_ea0_ABAB_issue;
wire [8:0] t_4a0b_ea0_ABAB_cycle = (B_len == 3'd2) ? t_4a0b_ea0_ABAB_head : 9'd511;
wire [8:0] t_4a0b_ea0_ABBA_dep = t_4a0b_ea0_A_head + A_rev_lat[5];
wire [8:0] t_4a0b_ea0_ABBA_issue = t_4a0b_ea0_BBA_dep + 9'd1;
wire [8:0] t_4a0b_ea0_ABBA_head = (t_4a0b_ea0_ABBA_dep >= t_4a0b_ea0_ABBA_issue) ? t_4a0b_ea0_ABBA_dep : t_4a0b_ea0_ABBA_issue;
wire [8:0] t_4a0b_ea0_ABBA_cycle = (B_len == 3'd2) ? t_4a0b_ea0_ABBA_head : 9'd511;
wire [8:0] t_4a0b_ea0_ABBB_dep = m4_4a0b_ea0_ra + A_rev_lat[4];
wire [8:0] t_4a0b_ea0_ABBB_issue = t_4a0b_ea0_BBB_dep + 9'd1;
wire [8:0] t_4a0b_ea0_ABBB_head = (t_4a0b_ea0_ABBB_dep >= t_4a0b_ea0_ABBB_issue) ? t_4a0b_ea0_ABBB_dep : t_4a0b_ea0_ABBB_issue;
wire [8:0] t_4a0b_ea0_ABBB_cycle = (B_len == 3'd3) ? t_4a0b_ea0_ABBB_head : 9'd511;
wire [8:0] t_4a0b_ea0_BAAB_dep = t_4a0b_ea0_B_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BAAB_issue = t_4a0b_ea0_AAB_dep + 9'd1;
wire [8:0] t_4a0b_ea0_BAAB_head = (t_4a0b_ea0_BAAB_dep >= t_4a0b_ea0_BAAB_issue) ? t_4a0b_ea0_BAAB_dep : t_4a0b_ea0_BAAB_issue;
wire [8:0] t_4a0b_ea0_BAAB_cycle = (B_len == 3'd2) ? t_4a0b_ea0_BAAB_head : 9'd511;
wire [8:0] t_4a0b_ea0_BABA_dep = t_4a0b_ea0_BA_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BABA_issue = t_4a0b_ea0_ABA_head + 9'd1;
wire [8:0] t_4a0b_ea0_BABA_head = (t_4a0b_ea0_BABA_dep >= t_4a0b_ea0_BABA_issue) ? t_4a0b_ea0_BABA_dep : t_4a0b_ea0_BABA_issue;
wire [8:0] t_4a0b_ea0_BABA_cycle = (B_len == 3'd2) ? t_4a0b_ea0_BABA_head : 9'd511;
wire [8:0] t_4a0b_ea0_BABB_dep = t_4a0b_ea0_BB_dep + B_rev_lat[2];
wire [8:0] t_4a0b_ea0_BABB_issue = t_4a0b_ea0_ABB_head + 9'd1;
wire [8:0] t_4a0b_ea0_BABB_head = (t_4a0b_ea0_BABB_dep >= t_4a0b_ea0_BABB_issue) ? t_4a0b_ea0_BABB_dep : t_4a0b_ea0_BABB_issue;
wire [8:0] t_4a0b_ea0_BABB_cycle = (B_len == 3'd3) ? t_4a0b_ea0_BABB_head : 9'd511;
wire [8:0] t_4a0b_ea0_BBAA_dep = t_4a0b_ea0_BAA_head + B_rev_lat[1];
wire [8:0] t_4a0b_ea0_BBAA_cycle = (B_len == 3'd2) ? t_4a0b_ea0_BBAA_dep : 9'd511;
wire [8:0] t_4a0b_ea0_BBAB_dep = t_4a0b_ea0_BAB_head + B_rev_lat[2];
wire [8:0] t_4a0b_ea0_BBAB_cycle = (B_len == 3'd3) ? t_4a0b_ea0_BBAB_dep : 9'd511;
wire [8:0] t_4a0b_ea0_BBBA_dep = t_4a0b_ea0_BBA_dep + B_rev_lat[2];
wire [8:0] t_4a0b_ea0_BBBA_cycle = (B_len == 3'd3) ? t_4a0b_ea0_BBBA_dep : 9'd511;
wire [8:0] t_4a0b_ea0_BBBB_dep = t_4a0b_ea0_BBB_dep + B_rev_lat[3];
wire [8:0] t_4a0b_ea0_BBBB_cycle = (B_len == 3'd4) ? t_4a0b_ea0_BBBB_dep : 9'd511;
wire m4_4a0b_ea0_tail_m0_0_pick = (t_4a0b_ea0_AABB_cycle <= t_4a0b_ea0_ABAB_cycle);
wire [8:0] m4_4a0b_ea0_tail_m0_0_value = m4_4a0b_ea0_tail_m0_0_pick ? t_4a0b_ea0_AABB_cycle : t_4a0b_ea0_ABAB_cycle;
wire [3:0] m4_4a0b_ea0_tail_m0_0_path = m4_4a0b_ea0_tail_m0_0_pick ? 4'b1100 : 4'b1010;
wire m4_4a0b_ea0_tail_m0_1_pick = (t_4a0b_ea0_ABBA_cycle <= t_4a0b_ea0_ABBB_cycle);
wire [8:0] m4_4a0b_ea0_tail_m0_1_value = m4_4a0b_ea0_tail_m0_1_pick ? t_4a0b_ea0_ABBA_cycle : t_4a0b_ea0_ABBB_cycle;
wire [3:0] m4_4a0b_ea0_tail_m0_1_path = m4_4a0b_ea0_tail_m0_1_pick ? 4'b1001 : 4'b1000;
wire m4_4a0b_ea0_tail_m0_2_pick = (t_4a0b_ea0_BAAB_cycle <= t_4a0b_ea0_BABA_cycle);
wire [8:0] m4_4a0b_ea0_tail_m0_2_value = m4_4a0b_ea0_tail_m0_2_pick ? t_4a0b_ea0_BAAB_cycle : t_4a0b_ea0_BABA_cycle;
wire [3:0] m4_4a0b_ea0_tail_m0_2_path = m4_4a0b_ea0_tail_m0_2_pick ? 4'b0110 : 4'b0101;
wire m4_4a0b_ea0_tail_m0_3_pick = (t_4a0b_ea0_BABB_cycle <= t_4a0b_ea0_BBAA_cycle);
wire [8:0] m4_4a0b_ea0_tail_m0_3_value = m4_4a0b_ea0_tail_m0_3_pick ? t_4a0b_ea0_BABB_cycle : t_4a0b_ea0_BBAA_cycle;
wire [3:0] m4_4a0b_ea0_tail_m0_3_path = m4_4a0b_ea0_tail_m0_3_pick ? 4'b0100 : 4'b0011;
wire m4_4a0b_ea0_tail_m0_4_pick = (t_4a0b_ea0_BBAB_cycle <= t_4a0b_ea0_BBBA_cycle);
wire [8:0] m4_4a0b_ea0_tail_m0_4_value = m4_4a0b_ea0_tail_m0_4_pick ? t_4a0b_ea0_BBAB_cycle : t_4a0b_ea0_BBBA_cycle;
wire [3:0] m4_4a0b_ea0_tail_m0_4_path = m4_4a0b_ea0_tail_m0_4_pick ? 4'b0010 : 4'b0001;
wire m4_4a0b_ea0_tail_m1_0_pick = (m4_4a0b_ea0_tail_m0_0_value <= m4_4a0b_ea0_tail_m0_1_value);
wire [8:0] m4_4a0b_ea0_tail_m1_0_value = m4_4a0b_ea0_tail_m1_0_pick ? m4_4a0b_ea0_tail_m0_0_value : m4_4a0b_ea0_tail_m0_1_value;
wire [3:0] m4_4a0b_ea0_tail_m1_0_path = m4_4a0b_ea0_tail_m1_0_pick ? m4_4a0b_ea0_tail_m0_0_path : m4_4a0b_ea0_tail_m0_1_path;
wire m4_4a0b_ea0_tail_m1_1_pick = (m4_4a0b_ea0_tail_m0_2_value <= m4_4a0b_ea0_tail_m0_3_value);
wire [8:0] m4_4a0b_ea0_tail_m1_1_value = m4_4a0b_ea0_tail_m1_1_pick ? m4_4a0b_ea0_tail_m0_2_value : m4_4a0b_ea0_tail_m0_3_value;
wire [3:0] m4_4a0b_ea0_tail_m1_1_path = m4_4a0b_ea0_tail_m1_1_pick ? m4_4a0b_ea0_tail_m0_2_path : m4_4a0b_ea0_tail_m0_3_path;
wire m4_4a0b_ea0_tail_m1_2_pick = (m4_4a0b_ea0_tail_m0_4_value <= t_4a0b_ea0_BBBB_cycle);
wire [8:0] m4_4a0b_ea0_tail_m1_2_value = m4_4a0b_ea0_tail_m1_2_pick ? m4_4a0b_ea0_tail_m0_4_value : t_4a0b_ea0_BBBB_cycle;
wire [3:0] m4_4a0b_ea0_tail_m1_2_path = m4_4a0b_ea0_tail_m1_2_pick ? m4_4a0b_ea0_tail_m0_4_path : 4'b0000;
wire m4_4a0b_ea0_tail_m2_0_pick = (m4_4a0b_ea0_tail_m1_0_value <= m4_4a0b_ea0_tail_m1_1_value);
wire [8:0] m4_4a0b_ea0_tail_m2_0_value = m4_4a0b_ea0_tail_m2_0_pick ? m4_4a0b_ea0_tail_m1_0_value : m4_4a0b_ea0_tail_m1_1_value;
wire [3:0] m4_4a0b_ea0_tail_m2_0_path = m4_4a0b_ea0_tail_m2_0_pick ? m4_4a0b_ea0_tail_m1_0_path : m4_4a0b_ea0_tail_m1_1_path;
wire m4_4a0b_ea0_tail_m3_0_pick = (m4_4a0b_ea0_tail_m2_0_value <= m4_4a0b_ea0_tail_m1_2_value);
wire [8:0] m4_4a0b_ea0_tail_m3_0_value = m4_4a0b_ea0_tail_m3_0_pick ? m4_4a0b_ea0_tail_m2_0_value : m4_4a0b_ea0_tail_m1_2_value;
wire [3:0] m4_4a0b_ea0_tail_m3_0_path = m4_4a0b_ea0_tail_m3_0_pick ? m4_4a0b_ea0_tail_m2_0_path : m4_4a0b_ea0_tail_m1_2_path;
wire [8:0] m4_4a0b_ea0_cycle = m4_4a0b_ea0_v ? m4_4a0b_ea0_tail_m3_0_value : 9'd511;
wire [7:0] m4_4a0b_ea0_path = {m4_4a0b_ea0_tail_m3_0_path, m4_4a0b_ea0_suffix};
wire dual_final_m0_0_pick = (m4_0a4b_eb0_cycle <= m4_1a3b_eb0_cycle);
wire [8:0] dual_final_m0_0_value = dual_final_m0_0_pick ? m4_0a4b_eb0_cycle : m4_1a3b_eb0_cycle;
wire [7:0] dual_final_m0_0_path = dual_final_m0_0_pick ? m4_0a4b_eb0_path : m4_1a3b_eb0_path;
wire dual_final_m0_1_pick = (m4_1a3b_eb1_cycle <= m4_2a2b_ea0_cycle);
wire [8:0] dual_final_m0_1_value = dual_final_m0_1_pick ? m4_1a3b_eb1_cycle : m4_2a2b_ea0_cycle;
wire [7:0] dual_final_m0_1_path = dual_final_m0_1_pick ? m4_1a3b_eb1_path : m4_2a2b_ea0_path;
wire dual_final_m0_2_pick = (m4_2a2b_ea1_cycle <= m4_2a2b_ea2_cycle);
wire [8:0] dual_final_m0_2_value = dual_final_m0_2_pick ? m4_2a2b_ea1_cycle : m4_2a2b_ea2_cycle;
wire [7:0] dual_final_m0_2_path = dual_final_m0_2_pick ? m4_2a2b_ea1_path : m4_2a2b_ea2_path;
wire dual_final_m0_3_pick = (m4_3a1b_ea0_cycle <= m4_3a1b_ea1_cycle);
wire [8:0] dual_final_m0_3_value = dual_final_m0_3_pick ? m4_3a1b_ea0_cycle : m4_3a1b_ea1_cycle;
wire [7:0] dual_final_m0_3_path = dual_final_m0_3_pick ? m4_3a1b_ea0_path : m4_3a1b_ea1_path;
wire dual_final_m1_0_pick = (dual_final_m0_0_value <= dual_final_m0_1_value);
wire [8:0] dual_final_m1_0_value = dual_final_m1_0_pick ? dual_final_m0_0_value : dual_final_m0_1_value;
wire [7:0] dual_final_m1_0_path = dual_final_m1_0_pick ? dual_final_m0_0_path : dual_final_m0_1_path;
wire dual_final_m1_1_pick = (dual_final_m0_2_value <= dual_final_m0_3_value);
wire [8:0] dual_final_m1_1_value = dual_final_m1_1_pick ? dual_final_m0_2_value : dual_final_m0_3_value;
wire [7:0] dual_final_m1_1_path = dual_final_m1_1_pick ? dual_final_m0_2_path : dual_final_m0_3_path;
wire dual_final_m2_0_pick = (dual_final_m1_0_value <= dual_final_m1_1_value);
wire [8:0] dual_final_m2_0_value = dual_final_m2_0_pick ? dual_final_m1_0_value : dual_final_m1_1_value;
wire [7:0] dual_final_m2_0_path = dual_final_m2_0_pick ? dual_final_m1_0_path : dual_final_m1_1_path;
wire dual_final_m3_0_pick = (dual_final_m2_0_value <= m4_4a0b_ea0_cycle);
wire [8:0] dual_final_m3_0_value = dual_final_m3_0_pick ? dual_final_m2_0_value : m4_4a0b_ea0_cycle;
wire [7:0] dual_final_m3_0_path = dual_final_m3_0_pick ? dual_final_m2_0_path : m4_4a0b_ea0_path;
wire [8:0] dual_best_cycle = dual_final_m3_0_value;
wire [7:0] dual_best_path = dual_final_m3_0_path;
// END OISS_dual_chain_hybrid.vh
// BEGIN OISS_single_chain_dp.vh
// Exact scalar DP for one dependency chain C and sorted independent group I.
// Ties choose I to retain a representative whose C suffix is back-to-back.
wire [5:0] sc_c0 = A_dependent ? A_rev_lat[0] : B_rev_lat[0];
wire [5:0] sc_c1 = A_dependent ? A_rev_lat[1] : B_rev_lat[1];
wire [5:0] sc_c2 = A_dependent ? A_rev_lat[2] : B_rev_lat[2];
wire [5:0] sc_c3 = A_dependent ? A_rev_lat[3] : B_rev_lat[3];
wire [5:0] sc_c4 = A_rev_lat[4];
wire [5:0] sc_c5 = A_rev_lat[5];
wire [5:0] sc_c6 = A_rev_lat[6];
wire [5:0] sc_i0 = A_dependent ? B_rev_lat[0] : A_rev_lat[0];
wire [5:0] sc_i1 = A_dependent ? B_rev_lat[1] : A_rev_lat[1];
wire [5:0] sc_i2 = A_dependent ? B_rev_lat[2] : A_rev_lat[2];
wire [5:0] sc_i3 = A_dependent ? B_rev_lat[3] : A_rev_lat[3];
wire [5:0] sc_i4 = A_rev_lat[4];
wire [5:0] sc_i5 = A_rev_lat[5];
wire [0:0] sc_sum0 = 1'b0;
wire [5:0] sc_sum1 = sc_sum0 + sc_c0;
wire [6:0] sc_sum2 = sc_sum1 + sc_c1;
wire [7:0] sc_sum3 = sc_sum2 + sc_c2;
wire [7:0] sc_sum4 = sc_sum3 + sc_c3;
wire [7:0] sc_sum5 = sc_sum4 + sc_c4;
wire [8:0] sc_sum6 = sc_sum5 + sc_c5;
wire [8:0] sc_sum7 = sc_sum6 + sc_c6;

// Scalar DP depth 1.
wire [5:0] sc_0c1i_ready = 1'b0 + 6'd1;
wire [5:0] sc_0c1i_cost = (sc_0c1i_ready >= sc_i0) ? sc_0c1i_ready : sc_i0;
wire [0:0] sc_0c1i_path = 1'd0;
wire [5:0] sc_1c0i_cost = sc_sum1;
wire [0:0] sc_1c0i_path = 1'b1;

// Scalar DP depth 2.
wire [5:0] sc_0c2i_ready = sc_0c1i_cost + 6'd1;
wire [5:0] sc_0c2i_cost = (sc_0c2i_ready >= sc_i1) ? sc_0c2i_ready : sc_i1;
wire [1:0] sc_0c2i_path = 2'd0;
wire [5:0] sc_1c1i_cr = sc_0c1i_cost + 6'd1;
wire [5:0] sc_1c1i_ir = sc_1c0i_cost + 6'd1;
wire [5:0] sc_1c1i_cc = (sc_1c1i_cr >= sc_sum1) ? sc_1c1i_cr : sc_sum1;
wire [5:0] sc_1c1i_ic = (sc_1c1i_ir >= sc_i0) ? sc_1c1i_ir : sc_i0;
wire sc_1c1i_pick_c = (sc_1c1i_cc < sc_1c1i_ic);
wire [5:0] sc_1c1i_cost = sc_1c1i_pick_c ? sc_1c1i_cc : sc_1c1i_ic;
wire [1:0] sc_1c1i_path = sc_1c1i_pick_c ? {1'b1, sc_0c1i_path} : {1'b0, sc_1c0i_path};
wire [6:0] sc_2c0i_cost = sc_sum2;
wire [1:0] sc_2c0i_path = 2'b11;

// Scalar DP depth 3.
wire [5:0] sc_0c3i_ready = sc_0c2i_cost + 6'd1;
wire [5:0] sc_0c3i_cost = (sc_0c3i_ready >= sc_i2) ? sc_0c3i_ready : sc_i2;
wire [2:0] sc_0c3i_path = 3'd0;
wire [5:0] sc_1c2i_cr = sc_0c2i_cost + 6'd1;
wire [5:0] sc_1c2i_ir = sc_1c1i_cost + 6'd1;
wire [5:0] sc_1c2i_cc = (sc_1c2i_cr >= sc_sum1) ? sc_1c2i_cr : sc_sum1;
wire [5:0] sc_1c2i_ic = (sc_1c2i_ir >= sc_i1) ? sc_1c2i_ir : sc_i1;
wire sc_1c2i_pick_c = (sc_1c2i_cc < sc_1c2i_ic);
wire [5:0] sc_1c2i_cost = sc_1c2i_pick_c ? sc_1c2i_cc : sc_1c2i_ic;
wire [2:0] sc_1c2i_path = sc_1c2i_pick_c ? {1'b1, sc_0c2i_path} : {1'b0, sc_1c1i_path};
wire [6:0] sc_2c1i_cr = sc_1c1i_cost + 7'd1;
wire [6:0] sc_2c1i_ir = sc_2c0i_cost + 7'd1;
wire [6:0] sc_2c1i_cc = (sc_2c1i_cr >= sc_sum2) ? sc_2c1i_cr : sc_sum2;
wire [6:0] sc_2c1i_ic = (sc_2c1i_ir >= sc_i0) ? sc_2c1i_ir : sc_i0;
wire sc_2c1i_pick_c = (sc_2c1i_cc < sc_2c1i_ic);
wire [6:0] sc_2c1i_cost = sc_2c1i_pick_c ? sc_2c1i_cc : sc_2c1i_ic;
wire [2:0] sc_2c1i_path = sc_2c1i_pick_c ? {1'b1, sc_1c1i_path} : {1'b0, sc_2c0i_path};
wire [7:0] sc_3c0i_cost = sc_sum3;
wire [2:0] sc_3c0i_path = 3'b111;

// Scalar DP depth 4.
wire [5:0] sc_0c4i_ready = sc_0c3i_cost + 6'd1;
wire [5:0] sc_0c4i_cost = (sc_0c4i_ready >= sc_i3) ? sc_0c4i_ready : sc_i3;
wire [3:0] sc_0c4i_path = 4'd0;
wire [5:0] sc_1c3i_cr = sc_0c3i_cost + 6'd1;
wire [5:0] sc_1c3i_ir = sc_1c2i_cost + 6'd1;
wire [5:0] sc_1c3i_cc = (sc_1c3i_cr >= sc_sum1) ? sc_1c3i_cr : sc_sum1;
wire [5:0] sc_1c3i_ic = (sc_1c3i_ir >= sc_i2) ? sc_1c3i_ir : sc_i2;
wire sc_1c3i_pick_c = (sc_1c3i_cc < sc_1c3i_ic);
wire [5:0] sc_1c3i_cost = sc_1c3i_pick_c ? sc_1c3i_cc : sc_1c3i_ic;
wire [3:0] sc_1c3i_path = sc_1c3i_pick_c ? {1'b1, sc_0c3i_path} : {1'b0, sc_1c2i_path};
wire [6:0] sc_2c2i_cr = sc_1c2i_cost + 7'd1;
wire [6:0] sc_2c2i_ir = sc_2c1i_cost + 7'd1;
wire [6:0] sc_2c2i_cc = (sc_2c2i_cr >= sc_sum2) ? sc_2c2i_cr : sc_sum2;
wire [6:0] sc_2c2i_ic = (sc_2c2i_ir >= sc_i1) ? sc_2c2i_ir : sc_i1;
wire sc_2c2i_pick_c = (sc_2c2i_cc < sc_2c2i_ic);
wire [6:0] sc_2c2i_cost = sc_2c2i_pick_c ? sc_2c2i_cc : sc_2c2i_ic;
wire [3:0] sc_2c2i_path = sc_2c2i_pick_c ? {1'b1, sc_1c2i_path} : {1'b0, sc_2c1i_path};
wire [7:0] sc_3c1i_cr = sc_2c1i_cost + 8'd1;
wire [7:0] sc_3c1i_ir = sc_3c0i_cost + 8'd1;
wire [7:0] sc_3c1i_cc = (sc_3c1i_cr >= sc_sum3) ? sc_3c1i_cr : sc_sum3;
wire [7:0] sc_3c1i_ic = (sc_3c1i_ir >= sc_i0) ? sc_3c1i_ir : sc_i0;
wire sc_3c1i_pick_c = (sc_3c1i_cc < sc_3c1i_ic);
wire [7:0] sc_3c1i_cost = sc_3c1i_pick_c ? sc_3c1i_cc : sc_3c1i_ic;
wire [3:0] sc_3c1i_path = sc_3c1i_pick_c ? {1'b1, sc_2c1i_path} : {1'b0, sc_3c0i_path};
wire [7:0] sc_4c0i_cost = sc_sum4;
wire [3:0] sc_4c0i_path = 4'b1111;

// Scalar DP depth 5.
wire [5:0] sc_0c5i_ready = sc_0c4i_cost + 6'd1;
wire [5:0] sc_0c5i_cost = (sc_0c5i_ready >= sc_i4) ? sc_0c5i_ready : sc_i4;
wire [4:0] sc_0c5i_path = 5'd0;
wire [5:0] sc_1c4i_cr = sc_0c4i_cost + 6'd1;
wire [5:0] sc_1c4i_ir = sc_1c3i_cost + 6'd1;
wire [5:0] sc_1c4i_cc = (sc_1c4i_cr >= sc_sum1) ? sc_1c4i_cr : sc_sum1;
wire [5:0] sc_1c4i_ic = (sc_1c4i_ir >= sc_i3) ? sc_1c4i_ir : sc_i3;
wire sc_1c4i_pick_c = (sc_1c4i_cc < sc_1c4i_ic);
wire [5:0] sc_1c4i_cost = sc_1c4i_pick_c ? sc_1c4i_cc : sc_1c4i_ic;
wire [4:0] sc_1c4i_path = sc_1c4i_pick_c ? {1'b1, sc_0c4i_path} : {1'b0, sc_1c3i_path};
wire [6:0] sc_2c3i_cr = sc_1c3i_cost + 7'd1;
wire [6:0] sc_2c3i_ir = sc_2c2i_cost + 7'd1;
wire [6:0] sc_2c3i_cc = (sc_2c3i_cr >= sc_sum2) ? sc_2c3i_cr : sc_sum2;
wire [6:0] sc_2c3i_ic = (sc_2c3i_ir >= sc_i2) ? sc_2c3i_ir : sc_i2;
wire sc_2c3i_pick_c = (sc_2c3i_cc < sc_2c3i_ic);
wire [6:0] sc_2c3i_cost = sc_2c3i_pick_c ? sc_2c3i_cc : sc_2c3i_ic;
wire [4:0] sc_2c3i_path = sc_2c3i_pick_c ? {1'b1, sc_1c3i_path} : {1'b0, sc_2c2i_path};
wire [7:0] sc_3c2i_cr = sc_2c2i_cost + 8'd1;
wire [7:0] sc_3c2i_ir = sc_3c1i_cost + 8'd1;
wire [7:0] sc_3c2i_cc = (sc_3c2i_cr >= sc_sum3) ? sc_3c2i_cr : sc_sum3;
wire [7:0] sc_3c2i_ic = (sc_3c2i_ir >= sc_i1) ? sc_3c2i_ir : sc_i1;
wire sc_3c2i_pick_c = (sc_3c2i_cc < sc_3c2i_ic);
wire [7:0] sc_3c2i_cost = sc_3c2i_pick_c ? sc_3c2i_cc : sc_3c2i_ic;
wire [4:0] sc_3c2i_path = sc_3c2i_pick_c ? {1'b1, sc_2c2i_path} : {1'b0, sc_3c1i_path};
wire [7:0] sc_4c1i_cr = sc_3c1i_cost + 8'd1;
wire [7:0] sc_4c1i_ir = sc_4c0i_cost + 8'd1;
wire [7:0] sc_4c1i_cc = (sc_4c1i_cr >= sc_sum4) ? sc_4c1i_cr : sc_sum4;
wire [7:0] sc_4c1i_ic = (sc_4c1i_ir >= sc_i0) ? sc_4c1i_ir : sc_i0;
wire sc_4c1i_pick_c = (sc_4c1i_cc < sc_4c1i_ic);
wire [7:0] sc_4c1i_cost = sc_4c1i_pick_c ? sc_4c1i_cc : sc_4c1i_ic;
wire [4:0] sc_4c1i_path = sc_4c1i_pick_c ? {1'b1, sc_3c1i_path} : {1'b0, sc_4c0i_path};
wire [7:0] sc_5c0i_cost = sc_sum5;
wire [4:0] sc_5c0i_path = 5'b11111;

// Scalar DP depth 6.
wire [5:0] sc_0c6i_ready = sc_0c5i_cost + 6'd1;
wire [5:0] sc_0c6i_cost = (sc_0c6i_ready >= sc_i5) ? sc_0c6i_ready : sc_i5;
wire [5:0] sc_0c6i_path = 6'd0;
wire [5:0] sc_1c5i_cr = sc_0c5i_cost + 6'd1;
wire [5:0] sc_1c5i_ir = sc_1c4i_cost + 6'd1;
wire [5:0] sc_1c5i_cc = (sc_1c5i_cr >= sc_sum1) ? sc_1c5i_cr : sc_sum1;
wire [5:0] sc_1c5i_ic = (sc_1c5i_ir >= sc_i4) ? sc_1c5i_ir : sc_i4;
wire sc_1c5i_pick_c = (sc_1c5i_cc < sc_1c5i_ic);
wire [5:0] sc_1c5i_cost = sc_1c5i_pick_c ? sc_1c5i_cc : sc_1c5i_ic;
wire [5:0] sc_1c5i_path = sc_1c5i_pick_c ? {1'b1, sc_0c5i_path} : {1'b0, sc_1c4i_path};
wire [6:0] sc_2c4i_cr = sc_1c4i_cost + 7'd1;
wire [6:0] sc_2c4i_ir = sc_2c3i_cost + 7'd1;
wire [6:0] sc_2c4i_cc = (sc_2c4i_cr >= sc_sum2) ? sc_2c4i_cr : sc_sum2;
wire [6:0] sc_2c4i_ic = (sc_2c4i_ir >= sc_i3) ? sc_2c4i_ir : sc_i3;
wire sc_2c4i_pick_c = (sc_2c4i_cc < sc_2c4i_ic);
wire [6:0] sc_2c4i_cost = sc_2c4i_pick_c ? sc_2c4i_cc : sc_2c4i_ic;
wire [5:0] sc_2c4i_path = sc_2c4i_pick_c ? {1'b1, sc_1c4i_path} : {1'b0, sc_2c3i_path};
wire [7:0] sc_3c3i_cr = sc_2c3i_cost + 8'd1;
wire [7:0] sc_3c3i_ir = sc_3c2i_cost + 8'd1;
wire [7:0] sc_3c3i_cc = (sc_3c3i_cr >= sc_sum3) ? sc_3c3i_cr : sc_sum3;
wire [7:0] sc_3c3i_ic = (sc_3c3i_ir >= sc_i2) ? sc_3c3i_ir : sc_i2;
wire sc_3c3i_pick_c = (sc_3c3i_cc < sc_3c3i_ic);
wire [7:0] sc_3c3i_cost = sc_3c3i_pick_c ? sc_3c3i_cc : sc_3c3i_ic;
wire [5:0] sc_3c3i_path = sc_3c3i_pick_c ? {1'b1, sc_2c3i_path} : {1'b0, sc_3c2i_path};
wire [7:0] sc_4c2i_cr = sc_3c2i_cost + 8'd1;
wire [7:0] sc_4c2i_ir = sc_4c1i_cost + 8'd1;
wire [7:0] sc_4c2i_cc = (sc_4c2i_cr >= sc_sum4) ? sc_4c2i_cr : sc_sum4;
wire [7:0] sc_4c2i_ic = (sc_4c2i_ir >= sc_i1) ? sc_4c2i_ir : sc_i1;
wire sc_4c2i_pick_c = (sc_4c2i_cc < sc_4c2i_ic);
wire [7:0] sc_4c2i_cost = sc_4c2i_pick_c ? sc_4c2i_cc : sc_4c2i_ic;
wire [5:0] sc_4c2i_path = sc_4c2i_pick_c ? {1'b1, sc_3c2i_path} : {1'b0, sc_4c1i_path};
wire [7:0] sc_5c1i_cr = sc_4c1i_cost + 8'd1;
wire [7:0] sc_5c1i_ir = sc_5c0i_cost + 8'd1;
wire [7:0] sc_5c1i_cc = (sc_5c1i_cr >= sc_sum5) ? sc_5c1i_cr : sc_sum5;
wire [7:0] sc_5c1i_ic = (sc_5c1i_ir >= sc_i0) ? sc_5c1i_ir : sc_i0;
wire sc_5c1i_pick_c = (sc_5c1i_cc < sc_5c1i_ic);
wire [7:0] sc_5c1i_cost = sc_5c1i_pick_c ? sc_5c1i_cc : sc_5c1i_ic;
wire [5:0] sc_5c1i_path = sc_5c1i_pick_c ? {1'b1, sc_4c1i_path} : {1'b0, sc_5c0i_path};
wire [8:0] sc_6c0i_cost = sc_sum6;
wire [5:0] sc_6c0i_path = 6'b111111;

// Scalar DP depth 7.
wire [5:0] sc_1c6i_cr = sc_0c6i_cost + 6'd1;
wire [5:0] sc_1c6i_ir = sc_1c5i_cost + 6'd1;
wire [5:0] sc_1c6i_cc = (sc_1c6i_cr >= sc_sum1) ? sc_1c6i_cr : sc_sum1;
wire [5:0] sc_1c6i_ic = (sc_1c6i_ir >= sc_i5) ? sc_1c6i_ir : sc_i5;
wire sc_1c6i_pick_c = (sc_1c6i_cc < sc_1c6i_ic);
wire [5:0] sc_1c6i_cost = sc_1c6i_pick_c ? sc_1c6i_cc : sc_1c6i_ic;
wire [6:0] sc_1c6i_path = sc_1c6i_pick_c ? {1'b1, sc_0c6i_path} : {1'b0, sc_1c5i_path};
wire [6:0] sc_2c5i_cr = sc_1c5i_cost + 7'd1;
wire [6:0] sc_2c5i_ir = sc_2c4i_cost + 7'd1;
wire [6:0] sc_2c5i_cc = (sc_2c5i_cr >= sc_sum2) ? sc_2c5i_cr : sc_sum2;
wire [6:0] sc_2c5i_ic = (sc_2c5i_ir >= sc_i4) ? sc_2c5i_ir : sc_i4;
wire sc_2c5i_pick_c = (sc_2c5i_cc < sc_2c5i_ic);
wire [6:0] sc_2c5i_cost = sc_2c5i_pick_c ? sc_2c5i_cc : sc_2c5i_ic;
wire [6:0] sc_2c5i_path = sc_2c5i_pick_c ? {1'b1, sc_1c5i_path} : {1'b0, sc_2c4i_path};
wire [7:0] sc_3c4i_cr = sc_2c4i_cost + 8'd1;
wire [7:0] sc_3c4i_ir = sc_3c3i_cost + 8'd1;
wire [7:0] sc_3c4i_cc = (sc_3c4i_cr >= sc_sum3) ? sc_3c4i_cr : sc_sum3;
wire [7:0] sc_3c4i_ic = (sc_3c4i_ir >= sc_i3) ? sc_3c4i_ir : sc_i3;
wire sc_3c4i_pick_c = (sc_3c4i_cc < sc_3c4i_ic);
wire [7:0] sc_3c4i_cost = sc_3c4i_pick_c ? sc_3c4i_cc : sc_3c4i_ic;
wire [6:0] sc_3c4i_path = sc_3c4i_pick_c ? {1'b1, sc_2c4i_path} : {1'b0, sc_3c3i_path};
wire [7:0] sc_4c3i_cr = sc_3c3i_cost + 8'd1;
wire [7:0] sc_4c3i_ir = sc_4c2i_cost + 8'd1;
wire [7:0] sc_4c3i_cc = (sc_4c3i_cr >= sc_sum4) ? sc_4c3i_cr : sc_sum4;
wire [7:0] sc_4c3i_ic = (sc_4c3i_ir >= sc_i2) ? sc_4c3i_ir : sc_i2;
wire sc_4c3i_pick_c = (sc_4c3i_cc < sc_4c3i_ic);
wire [7:0] sc_4c3i_cost = sc_4c3i_pick_c ? sc_4c3i_cc : sc_4c3i_ic;
wire [6:0] sc_4c3i_path = sc_4c3i_pick_c ? {1'b1, sc_3c3i_path} : {1'b0, sc_4c2i_path};
wire [7:0] sc_5c2i_cr = sc_4c2i_cost + 8'd1;
wire [7:0] sc_5c2i_ir = sc_5c1i_cost + 8'd1;
wire [7:0] sc_5c2i_cc = (sc_5c2i_cr >= sc_sum5) ? sc_5c2i_cr : sc_sum5;
wire [7:0] sc_5c2i_ic = (sc_5c2i_ir >= sc_i1) ? sc_5c2i_ir : sc_i1;
wire sc_5c2i_pick_c = (sc_5c2i_cc < sc_5c2i_ic);
wire [7:0] sc_5c2i_cost = sc_5c2i_pick_c ? sc_5c2i_cc : sc_5c2i_ic;
wire [6:0] sc_5c2i_path = sc_5c2i_pick_c ? {1'b1, sc_4c2i_path} : {1'b0, sc_5c1i_path};
wire [8:0] sc_6c1i_cr = sc_5c1i_cost + 9'd1;
wire [8:0] sc_6c1i_ir = sc_6c0i_cost + 9'd1;
wire [8:0] sc_6c1i_cc = (sc_6c1i_cr >= sc_sum6) ? sc_6c1i_cr : sc_sum6;
wire [8:0] sc_6c1i_ic = (sc_6c1i_ir >= sc_i0) ? sc_6c1i_ir : sc_i0;
wire sc_6c1i_pick_c = (sc_6c1i_cc < sc_6c1i_ic);
wire [8:0] sc_6c1i_cost = sc_6c1i_pick_c ? sc_6c1i_cc : sc_6c1i_ic;
wire [6:0] sc_6c1i_path = sc_6c1i_pick_c ? {1'b1, sc_5c1i_path} : {1'b0, sc_6c0i_path};
wire [8:0] sc_7c0i_cost = sc_sum7;
wire [6:0] sc_7c0i_path = 7'b1111111;

// Scalar DP depth 8.
wire [6:0] sc_2c6i_cr = sc_1c6i_cost + 7'd1;
wire [6:0] sc_2c6i_ir = sc_2c5i_cost + 7'd1;
wire [6:0] sc_2c6i_cc = (sc_2c6i_cr >= sc_sum2) ? sc_2c6i_cr : sc_sum2;
wire [6:0] sc_2c6i_ic = (sc_2c6i_ir >= sc_i5) ? sc_2c6i_ir : sc_i5;
wire sc_2c6i_pick_c = (sc_2c6i_cc < sc_2c6i_ic);
wire [6:0] sc_2c6i_cost = sc_2c6i_pick_c ? sc_2c6i_cc : sc_2c6i_ic;
wire [7:0] sc_2c6i_path = sc_2c6i_pick_c ? {1'b1, sc_1c6i_path} : {1'b0, sc_2c5i_path};
wire [7:0] sc_3c5i_cr = sc_2c5i_cost + 8'd1;
wire [7:0] sc_3c5i_ir = sc_3c4i_cost + 8'd1;
wire [7:0] sc_3c5i_cc = (sc_3c5i_cr >= sc_sum3) ? sc_3c5i_cr : sc_sum3;
wire [7:0] sc_3c5i_ic = (sc_3c5i_ir >= sc_i4) ? sc_3c5i_ir : sc_i4;
wire sc_3c5i_pick_c = (sc_3c5i_cc < sc_3c5i_ic);
wire [7:0] sc_3c5i_cost = sc_3c5i_pick_c ? sc_3c5i_cc : sc_3c5i_ic;
wire [7:0] sc_3c5i_path = sc_3c5i_pick_c ? {1'b1, sc_2c5i_path} : {1'b0, sc_3c4i_path};
wire [7:0] sc_4c4i_cr = sc_3c4i_cost + 8'd1;
wire [7:0] sc_4c4i_ir = sc_4c3i_cost + 8'd1;
wire [7:0] sc_4c4i_cc = (sc_4c4i_cr >= sc_sum4) ? sc_4c4i_cr : sc_sum4;
wire [7:0] sc_4c4i_ic = (sc_4c4i_ir >= sc_i3) ? sc_4c4i_ir : sc_i3;
wire sc_4c4i_pick_c = (sc_4c4i_cc < sc_4c4i_ic);
wire [7:0] sc_4c4i_cost = sc_4c4i_pick_c ? sc_4c4i_cc : sc_4c4i_ic;
wire [7:0] sc_4c4i_path = sc_4c4i_pick_c ? {1'b1, sc_3c4i_path} : {1'b0, sc_4c3i_path};
wire [7:0] sc_5c3i_cr = sc_4c3i_cost + 8'd1;
wire [7:0] sc_5c3i_ir = sc_5c2i_cost + 8'd1;
wire [7:0] sc_5c3i_cc = (sc_5c3i_cr >= sc_sum5) ? sc_5c3i_cr : sc_sum5;
wire [7:0] sc_5c3i_ic = (sc_5c3i_ir >= sc_i2) ? sc_5c3i_ir : sc_i2;
wire sc_5c3i_pick_c = (sc_5c3i_cc < sc_5c3i_ic);
wire [7:0] sc_5c3i_cost = sc_5c3i_pick_c ? sc_5c3i_cc : sc_5c3i_ic;
wire [7:0] sc_5c3i_path = sc_5c3i_pick_c ? {1'b1, sc_4c3i_path} : {1'b0, sc_5c2i_path};
wire [8:0] sc_6c2i_cr = sc_5c2i_cost + 9'd1;
wire [8:0] sc_6c2i_ir = sc_6c1i_cost + 9'd1;
wire [8:0] sc_6c2i_cc = (sc_6c2i_cr >= sc_sum6) ? sc_6c2i_cr : sc_sum6;
wire [8:0] sc_6c2i_ic = (sc_6c2i_ir >= sc_i1) ? sc_6c2i_ir : sc_i1;
wire sc_6c2i_pick_c = (sc_6c2i_cc < sc_6c2i_ic);
wire [8:0] sc_6c2i_cost = sc_6c2i_pick_c ? sc_6c2i_cc : sc_6c2i_ic;
wire [7:0] sc_6c2i_path = sc_6c2i_pick_c ? {1'b1, sc_5c2i_path} : {1'b0, sc_6c1i_path};
wire [8:0] sc_7c1i_cr = sc_6c1i_cost + 9'd1;
wire [8:0] sc_7c1i_ir = sc_7c0i_cost + 9'd1;
wire [8:0] sc_7c1i_cc = (sc_7c1i_cr >= sc_sum7) ? sc_7c1i_cr : sc_sum7;
wire [8:0] sc_7c1i_ic = (sc_7c1i_ir >= sc_i0) ? sc_7c1i_ir : sc_i0;
wire sc_7c1i_pick_c = (sc_7c1i_cc < sc_7c1i_ic);
wire [8:0] sc_7c1i_cost = sc_7c1i_pick_c ? sc_7c1i_cc : sc_7c1i_ic;
wire [7:0] sc_7c1i_path = sc_7c1i_pick_c ? {1'b1, sc_6c1i_path} : {1'b0, sc_7c0i_path};
reg [8:0] single_best_cycle;
reg [7:0] single_chain_path;
always @(*) begin
    single_best_cycle = 9'd0;
    single_chain_path = 8'd0;
    case (B_len)
        3'd1: begin
            single_best_cycle = sc_7c1i_cost;
            single_chain_path = sc_7c1i_path;
        end
        3'd2: begin
            single_best_cycle = A_dependent ? sc_6c2i_cost : sc_2c6i_cost;
            single_chain_path = A_dependent ? sc_6c2i_path : sc_2c6i_path;
        end
        3'd3: begin
            single_best_cycle = A_dependent ? sc_5c3i_cost : sc_3c5i_cost;
            single_chain_path = A_dependent ? sc_5c3i_path : sc_3c5i_path;
        end
        3'd4: begin
            single_best_cycle = sc_4c4i_cost;
            single_chain_path = sc_4c4i_path;
        end
        default: begin end
    endcase
end
wire [7:0] single_best_path = single_chain_path ^ {8{!A_dependent}};
// END OISS_single_chain_dp.vh
// Direct solutions when every instruction belongs to group A.
wire [0:0] only_a_sum0 = 1'b0;
wire [5:0] only_a_sum1 = only_a_sum0 + A_rev_lat[0];
wire [6:0] only_a_sum2 = only_a_sum1 + A_rev_lat[1];
wire [7:0] only_a_sum3 = only_a_sum2 + A_rev_lat[2];
wire [7:0] only_a_sum4 = only_a_sum3 + A_rev_lat[3];
wire [7:0] only_a_sum5 = only_a_sum4 + A_rev_lat[4];
wire [8:0] only_a_sum6 = only_a_sum5 + A_rev_lat[5];
wire [8:0] only_a_sum7 = only_a_sum6 + A_rev_lat[6];
wire [8:0] only_a_sum8 = only_a_sum7 + A_rev_lat[7];
wire [5:0] ind_finish0 = A_lat_ext[0][5:0] + 6'd0;
wire [5:0] ind_finish1 = A_lat_ext[1][5:0] + 6'd1;
wire [5:0] ind_finish2 = A_lat_ext[2][5:0] + 6'd2;
wire [5:0] ind_finish3 = A_lat_ext[3][5:0] + 6'd3;
wire [5:0] ind_finish4 = A_lat_ext[4][5:0] + 6'd4;
wire [5:0] ind_finish5 = A_lat_ext[5][5:0] + 6'd5;
wire [5:0] ind_finish6 = A_lat_ext[6][5:0] + 6'd6;
wire [5:0] ind_finish7 = A_lat_ext[7][5:0] + 6'd7;
wire [5:0] ind_max0_0 = (ind_finish0 >= ind_finish1) ? ind_finish0 : ind_finish1;
wire [5:0] ind_max0_1 = (ind_finish2 >= ind_finish3) ? ind_finish2 : ind_finish3;
wire [5:0] ind_max0_2 = (ind_finish4 >= ind_finish5) ? ind_finish4 : ind_finish5;
wire [5:0] ind_max0_3 = (ind_finish6 >= ind_finish7) ? ind_finish6 : ind_finish7;
wire [5:0] ind_max1_0 = (ind_max0_0 >= ind_max0_1) ? ind_max0_0 : ind_max0_1;
wire [5:0] ind_max1_1 = (ind_max0_2 >= ind_max0_3) ? ind_max0_2 : ind_max0_3;
wire [5:0] ind_max2_0 = (ind_max1_0 >= ind_max1_1) ? ind_max1_0 : ind_max1_1;
wire [8:0] only_a_cycle = A_dependent ? only_a_sum8 : ind_max2_0;
wire [8:0] best_cycle = (B_len == 3'd0) ? only_a_cycle : (A_dependent && B_dependent) ? dual_best_cycle : single_best_cycle;
wire [7:0] best_path = (B_len == 3'd0) ? 8'hff : (A_dependent && B_dependent) ? dual_best_path : single_best_path;

//////// OUTPUT RECONSTRUCTION ////////
integer order_i;
reg [2:0] a_ptr;
reg [1:0] b_ptr;

always @(*) begin
    Inst_order_O = 24'd0;
    a_ptr = 3'd0;
    b_ptr = 2'd0;

    for (order_i = 0; order_i < 8; order_i = order_i + 1) begin
        if (best_path[7-order_i]) begin
            Inst_order_O[order_i*3 +: 3] = A_inst[a_ptr];
            a_ptr = a_ptr + 3'd1;
        end else begin
            Inst_order_O[order_i*3 +: 3] = B_inst[b_ptr];
            b_ptr = b_ptr + 2'd1;
        end
    end
end

assign Ex_cycle = best_cycle;

endmodule
