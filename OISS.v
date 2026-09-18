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
reg [7:0] read_mask    [0:7];
reg [7:0] write_mask   [0:7];

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

        // readmask
        if ((~opcode[i][2]) | (opcode[i][1] & ~opcode[i][0])) begin // ADD, SUB, MUL, DIV, BRANCH
            read_mask[i] = (8'b0000_0001 << rs[i]) | (8'b0000_0001 << rt[i]);

        end else if (opcode[i] == 3'b101) begin // STORE
            read_mask[i] = (8'b0000_0001 << rd[i]);

        end else begin // LOAD, JUMP
            read_mask[i] = 8'b0000_0000;

        end
        // writemask
        if ((~opcode[i][2]) | ((~opcode[i][1]) & (~opcode[i][0]))) begin // ADD, SUB, MUL, DIV, LOAD
            write_mask[i] = (8'b0000_0001 << rd[i]);

        end
        else begin // STORE, BRANCH, JUMP
            write_mask[i] = 8'b0000_0000;

        end

    end
end

// ============================================================
// Dependency Detection
// ============================================================
reg [7:0] access_mask [0:7];
reg [7:0] dep_mask    [0:7];

integer dep_i;
integer dep_j;

always @(*) begin
    // Register access mask
    for (dep_i = 0; dep_i < 8; dep_i = dep_i + 1) begin
        access_mask[dep_i] =  read_mask[dep_i] | write_mask[dep_i];
        // Default: no dependency
        dep_mask[dep_i] = 8'b0000_0000;
    end

    // Dependency matrix generation (Only original-order pairs (i < j) need to be checked)
    for (dep_i = 0; dep_i < 7; dep_i = dep_i + 1) begin
        for (dep_j = dep_i + 1; dep_j < 8; dep_j = dep_j + 1) begin
            dep_mask[dep_i][dep_j] = (|(write_mask[dep_i] & access_mask[dep_j])) |  // RAW WAW
                                     (|(read_mask[dep_i]  & write_mask[dep_j]));  // WAR

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
reg [2:0] chain0_inst [0:7];
reg [2:0] chain1_inst [0:7];
reg [3:0] chain0_len;
reg [3:0] chain1_len;

reg [3:0] c0_ptr;
reg [3:0] c1_ptr;
integer compact_i;

always @(*) begin
    c0_ptr = 4'd0;
    c1_ptr = 4'd0;

    for (compact_i = 0; compact_i < 8; compact_i = compact_i + 1) begin
        chain0_inst[compact_i] = 3'd0;
        chain1_inst[compact_i] = 3'd0;
    end

    for (compact_i = 0; compact_i < 8; compact_i = compact_i + 1) begin
        if (chain0_mask[compact_i]) begin
            chain0_inst[c0_ptr] = compact_i;
            c0_ptr = c0_ptr + 4'd1;
        end
        else if (chain1_mask[compact_i]) begin
            chain1_inst[c1_ptr] = compact_i;
            c1_ptr = c1_ptr + 4'd1;
        end
    end

    chain0_len = c0_ptr;
    chain1_len = c1_ptr;
end


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
// Tree Calculator
// ============================================================

// shared tail precomputation
wire [8:0] A_dep_sum_3 = A_lat_ext[3];
wire [8:0] A_dep_sum_2 = A_lat_ext[2] + A_dep_sum_3;
wire [8:0] A_dep_sum_1 = A_lat_ext[1] + A_dep_sum_2;
wire [8:0] A_dep_sum_0 = A_lat_ext[0] + A_dep_sum_1;

wire [8:0] A_ind_tail_3 = 9'd1 + A_lat_ext[3];
wire [8:0] A_ind_tail_2 = 9'd1 + ((A_lat_ext[2] > A_ind_tail_3) ?
                                   A_lat_ext[2] : A_ind_tail_3);
wire [8:0] A_ind_tail_1 = 9'd1 + ((A_lat_ext[1] > A_ind_tail_2) ?
                                   A_lat_ext[1] : A_ind_tail_2);
wire [8:0] A_ind_tail_0 = 9'd1 + ((A_lat_ext[0] > A_ind_tail_1) ?
                                   A_lat_ext[0] : A_ind_tail_1);

//////// DEPT 2 //////// 
// n_AA
wire [8:0] n_AA_sl, n_AA_fa, n_AA_fb, n_AA_fm;

assign n_AA_sl = (A_dependent && (A_lat_ext[0] > 9'd1)) ? A_lat_ext[0] : 9'd1;
assign n_AA_fa = n_AA_sl + A_lat_ext[1];
assign n_AA_fb = 9'd0;
assign n_AA_fm = (A_lat_ext[0] > n_AA_fa) ? A_lat_ext[0] : n_AA_fa;

// n_AB
wire [8:0] n_AB_sl, n_AB_fa, n_AB_fb, n_AB_fm;

assign n_AB_sl = 9'd1;
assign n_AB_fa = A_lat_ext[0];
assign n_AB_fb = 9'd1 + B_lat_ext[0];
assign n_AB_fm = (n_AB_fa > n_AB_fb) ? n_AB_fa : n_AB_fb;

// n_BA
wire [8:0] n_BA_sl, n_BA_fa, n_BA_fb, n_BA_fm;

assign n_BA_sl = 9'd1;
assign n_BA_fa = 9'd1 + A_lat_ext[0];
assign n_BA_fb = B_lat_ext[0];
assign n_BA_fm = (n_BA_fa > n_BA_fb) ? n_BA_fa : n_BA_fb;

// n_BB
wire [8:0] n_BB_sl, n_BB_fa, n_BB_fb, n_BB_fm;

assign n_BB_sl = (B_dependent && (B_lat_ext[0] > 9'd1)) ? B_lat_ext[0] : 9'd1;
assign n_BB_fa = 9'd0;
assign n_BB_fb = n_BB_sl + B_lat_ext[1];
assign n_BB_fm = (B_lat_ext[0] > n_BB_fb) ? B_lat_ext[0] : n_BB_fb;


`include "OISS_tree_node.vh"
`include "OISS_tree_trail_final_leaves.vh"
`include "OISS_candidate_bank.vh"
`include "OISS_minimum_tree_70.vh"


//////// OUTPUT RECONSTRUCTION ////////
integer order_i;
reg [3:0] a_ptr, b_ptr;

always @(*) begin
    Inst_order_O = 24'd0;
    a_ptr = 4'd0;
    b_ptr = 4'd0;

    for (order_i = 0; order_i < 8; order_i = order_i + 1) begin
        if (best_path[7-order_i]) begin
            Inst_order_O[order_i*3 +: 3] = A_inst[a_ptr];
            a_ptr = a_ptr + 4'd1;
        end else begin
            Inst_order_O[order_i*3 +: 3] = B_inst[b_ptr];
            b_ptr = b_ptr + 4'd1;
        end
    end
end

assign Ex_cycle = best_cycle;

endmodule

