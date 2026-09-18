// Backward tail and final leaves.
// Leaf names are unchanged so the existing candidate bank and minimum tree can be reused.

//////// TAIL LEAVES ////////

// l44_AAAABBBB_cycle
wire [5:0] t_AAAABBBB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AAAABBBB_b4_path = bw_BBB_rb + {{2{1'b0}}, t_AAAABBBB_b4_step};
wire [7:0] t_AAAABBBB_b4_rb = (t_AAAABBBB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AAAABBBB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [0:0] t_AAAABBBB_b4_ra = bw_BBB_ra;
wire [7:0] t_AAAABBBB_a0_issue = t_AAAABBBB_b4_rb + 8'd1;
wire [5:0] t_AAAABBBB_a0_dep = A_rev_lat[0] + (A_dependent ? {{5{1'b0}}, t_AAAABBBB_b4_ra} : 6'd0);
wire [7:0] t_AAAABBBB_a0_ra = (t_AAAABBBB_a0_issue > {{2{1'b0}}, t_AAAABBBB_a0_dep}) ? t_AAAABBBB_a0_issue : {{2{1'b0}}, t_AAAABBBB_a0_dep};
wire [7:0] t_AAAABBBB_a0_rb = t_AAAABBBB_b4_rb;
wire [5:0] t_AAAABBBB_a1_step = A_dependent ? A_rev_lat[1] : 6'd1;
wire [7:0] t_AAAABBBB_a1_path = t_AAAABBBB_a0_ra + {{2{1'b0}}, t_AAAABBBB_a1_step};
wire [7:0] t_AAAABBBB_a1_ra = (t_AAAABBBB_a1_path > {{2{1'b0}}, A_rev_lat[1]}) ? t_AAAABBBB_a1_path : {{2{1'b0}}, A_rev_lat[1]};
wire [7:0] t_AAAABBBB_a1_rb = t_AAAABBBB_a0_rb;
wire [5:0] t_AAAABBBB_a2_step = A_dependent ? A_rev_lat[2] : 6'd1;
wire [8:0] t_AAAABBBB_a2_path = {{1{1'b0}}, t_AAAABBBB_a1_ra} + {{3{1'b0}}, t_AAAABBBB_a2_step};
wire [8:0] t_AAAABBBB_a2_ra = (t_AAAABBBB_a2_path > {{3{1'b0}}, A_rev_lat[2]}) ? t_AAAABBBB_a2_path : {{3{1'b0}}, A_rev_lat[2]};
wire [7:0] t_AAAABBBB_a2_rb = t_AAAABBBB_a1_rb;
wire [5:0] t_AAAABBBB_a3_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AAAABBBB_a3_path = t_AAAABBBB_a2_ra + {{3{1'b0}}, t_AAAABBBB_a3_step};
wire [8:0] t_AAAABBBB_a3_ra = (t_AAAABBBB_a3_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AAAABBBB_a3_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AAAABBBB_a3_rb = t_AAAABBBB_a2_rb;
wire [8:0] l44_AAAABBBB_cycle = t_AAAABBBB_a3_ra;

// l44_AAABABBB_cycle
wire [7:0] t_AAABABBB_b4_issue = bw_ABBB_ra + 8'd1;
wire [7:0] t_AAABABBB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBB_rb : 8'd0);
wire [7:0] t_AAABABBB_b4_rb = (t_AAABABBB_b4_issue > t_AAABABBB_b4_dep) ? t_AAABABBB_b4_issue : t_AAABABBB_b4_dep;
wire [7:0] t_AAABABBB_b4_ra = bw_ABBB_ra;
wire [7:0] t_AAABABBB_a0_issue = t_AAABABBB_b4_rb + 8'd1;
wire [7:0] t_AAABABBB_a0_dep = {{2{1'b0}}, A_rev_lat[1]} + (A_dependent ? t_AAABABBB_b4_ra : 8'd0);
wire [7:0] t_AAABABBB_a0_ra = (t_AAABABBB_a0_issue > t_AAABABBB_a0_dep) ? t_AAABABBB_a0_issue : t_AAABABBB_a0_dep;
wire [7:0] t_AAABABBB_a0_rb = t_AAABABBB_b4_rb;
wire [5:0] t_AAABABBB_a1_step = A_dependent ? A_rev_lat[2] : 6'd1;
wire [7:0] t_AAABABBB_a1_path = t_AAABABBB_a0_ra + {{2{1'b0}}, t_AAABABBB_a1_step};
wire [7:0] t_AAABABBB_a1_ra = (t_AAABABBB_a1_path > {{2{1'b0}}, A_rev_lat[2]}) ? t_AAABABBB_a1_path : {{2{1'b0}}, A_rev_lat[2]};
wire [7:0] t_AAABABBB_a1_rb = t_AAABABBB_a0_rb;
wire [5:0] t_AAABABBB_a2_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AAABABBB_a2_path = {{1{1'b0}}, t_AAABABBB_a1_ra} + {{3{1'b0}}, t_AAABABBB_a2_step};
wire [8:0] t_AAABABBB_a2_ra = (t_AAABABBB_a2_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AAABABBB_a2_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AAABABBB_a2_rb = t_AAABABBB_a1_rb;
wire [8:0] l44_AAABABBB_cycle = t_AAABABBB_a2_ra;

// l44_AAABBABB_cycle
wire [5:0] t_AAABBABB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AAABBABB_b4_path = bw_BABB_rb + {{2{1'b0}}, t_AAABBABB_b4_step};
wire [7:0] t_AAABBABB_b4_rb = (t_AAABBABB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AAABBABB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AAABBABB_b4_ra = bw_BABB_ra;
wire [7:0] t_AAABBABB_a0_issue = t_AAABBABB_b4_rb + 8'd1;
wire [7:0] t_AAABBABB_a0_dep = {{2{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, t_AAABBABB_b4_ra} : 8'd0);
wire [7:0] t_AAABBABB_a0_ra = (t_AAABBABB_a0_issue > t_AAABBABB_a0_dep) ? t_AAABBABB_a0_issue : t_AAABBABB_a0_dep;
wire [7:0] t_AAABBABB_a0_rb = t_AAABBABB_b4_rb;
wire [5:0] t_AAABBABB_a1_step = A_dependent ? A_rev_lat[2] : 6'd1;
wire [7:0] t_AAABBABB_a1_path = t_AAABBABB_a0_ra + {{2{1'b0}}, t_AAABBABB_a1_step};
wire [7:0] t_AAABBABB_a1_ra = (t_AAABBABB_a1_path > {{2{1'b0}}, A_rev_lat[2]}) ? t_AAABBABB_a1_path : {{2{1'b0}}, A_rev_lat[2]};
wire [7:0] t_AAABBABB_a1_rb = t_AAABBABB_a0_rb;
wire [5:0] t_AAABBABB_a2_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AAABBABB_a2_path = {{1{1'b0}}, t_AAABBABB_a1_ra} + {{3{1'b0}}, t_AAABBABB_a2_step};
wire [8:0] t_AAABBABB_a2_ra = (t_AAABBABB_a2_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AAABBABB_a2_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AAABBABB_a2_rb = t_AAABBABB_a1_rb;
wire [8:0] l44_AAABBABB_cycle = t_AAABBABB_a2_ra;

// l44_AAABBBAB_cycle
wire [5:0] t_AAABBBAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AAABBBAB_b4_path = bw_BBAB_rb + {{2{1'b0}}, t_AAABBBAB_b4_step};
wire [7:0] t_AAABBBAB_b4_rb = (t_AAABBBAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AAABBBAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [5:0] t_AAABBBAB_b4_ra = bw_BBAB_ra;
wire [7:0] t_AAABBBAB_a0_issue = t_AAABBBAB_b4_rb + 8'd1;
wire [6:0] t_AAABBBAB_a0_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, t_AAABBBAB_b4_ra} : 7'd0);
wire [7:0] t_AAABBBAB_a0_ra = (t_AAABBBAB_a0_issue > {{1{1'b0}}, t_AAABBBAB_a0_dep}) ? t_AAABBBAB_a0_issue : {{1{1'b0}}, t_AAABBBAB_a0_dep};
wire [7:0] t_AAABBBAB_a0_rb = t_AAABBBAB_b4_rb;
wire [5:0] t_AAABBBAB_a1_step = A_dependent ? A_rev_lat[2] : 6'd1;
wire [7:0] t_AAABBBAB_a1_path = t_AAABBBAB_a0_ra + {{2{1'b0}}, t_AAABBBAB_a1_step};
wire [7:0] t_AAABBBAB_a1_ra = (t_AAABBBAB_a1_path > {{2{1'b0}}, A_rev_lat[2]}) ? t_AAABBBAB_a1_path : {{2{1'b0}}, A_rev_lat[2]};
wire [7:0] t_AAABBBAB_a1_rb = t_AAABBBAB_a0_rb;
wire [5:0] t_AAABBBAB_a2_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AAABBBAB_a2_path = {{1{1'b0}}, t_AAABBBAB_a1_ra} + {{3{1'b0}}, t_AAABBBAB_a2_step};
wire [8:0] t_AAABBBAB_a2_ra = (t_AAABBBAB_a2_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AAABBBAB_a2_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AAABBBAB_a2_rb = t_AAABBBAB_a1_rb;
wire [8:0] l44_AAABBBAB_cycle = t_AAABBBAB_a2_ra;

// l44_AAABBBBA_cycle
wire [5:0] t_AAABBBBA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AAABBBBA_b4_path = bw_BBBA_rb + {{2{1'b0}}, t_AAABBBBA_b4_step};
wire [7:0] t_AAABBBBA_b4_rb = (t_AAABBBBA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AAABBBBA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [5:0] t_AAABBBBA_b4_ra = bw_BBBA_ra;
wire [7:0] t_AAABBBBA_a0_issue = t_AAABBBBA_b4_rb + 8'd1;
wire [6:0] t_AAABBBBA_a0_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, t_AAABBBBA_b4_ra} : 7'd0);
wire [7:0] t_AAABBBBA_a0_ra = (t_AAABBBBA_a0_issue > {{1{1'b0}}, t_AAABBBBA_a0_dep}) ? t_AAABBBBA_a0_issue : {{1{1'b0}}, t_AAABBBBA_a0_dep};
wire [7:0] t_AAABBBBA_a0_rb = t_AAABBBBA_b4_rb;
wire [5:0] t_AAABBBBA_a1_step = A_dependent ? A_rev_lat[2] : 6'd1;
wire [7:0] t_AAABBBBA_a1_path = t_AAABBBBA_a0_ra + {{2{1'b0}}, t_AAABBBBA_a1_step};
wire [7:0] t_AAABBBBA_a1_ra = (t_AAABBBBA_a1_path > {{2{1'b0}}, A_rev_lat[2]}) ? t_AAABBBBA_a1_path : {{2{1'b0}}, A_rev_lat[2]};
wire [7:0] t_AAABBBBA_a1_rb = t_AAABBBBA_a0_rb;
wire [5:0] t_AAABBBBA_a2_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AAABBBBA_a2_path = {{1{1'b0}}, t_AAABBBBA_a1_ra} + {{3{1'b0}}, t_AAABBBBA_a2_step};
wire [8:0] t_AAABBBBA_a2_ra = (t_AAABBBBA_a2_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AAABBBBA_a2_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AAABBBBA_a2_rb = t_AAABBBBA_a1_rb;
wire [8:0] l44_AAABBBBA_cycle = t_AAABBBBA_a2_ra;

// l44_AABAABBB_cycle
wire [7:0] t_AABAABBB_b4_issue = bw_AABBB_ra + 8'd1;
wire [7:0] t_AABAABBB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBB_rb : 8'd0);
wire [7:0] t_AABAABBB_b4_rb = (t_AABAABBB_b4_issue > t_AABAABBB_b4_dep) ? t_AABAABBB_b4_issue : t_AABAABBB_b4_dep;
wire [7:0] t_AABAABBB_b4_ra = bw_AABBB_ra;
wire [7:0] t_AABAABBB_a0_issue = t_AABAABBB_b4_rb + 8'd1;
wire [7:0] t_AABAABBB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? t_AABAABBB_b4_ra : 8'd0);
wire [7:0] t_AABAABBB_a0_ra = (t_AABAABBB_a0_issue > t_AABAABBB_a0_dep) ? t_AABAABBB_a0_issue : t_AABAABBB_a0_dep;
wire [7:0] t_AABAABBB_a0_rb = t_AABAABBB_b4_rb;
wire [5:0] t_AABAABBB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AABAABBB_a1_path = {{1{1'b0}}, t_AABAABBB_a0_ra} + {{3{1'b0}}, t_AABAABBB_a1_step};
wire [8:0] t_AABAABBB_a1_ra = (t_AABAABBB_a1_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AABAABBB_a1_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABAABBB_a1_rb = t_AABAABBB_a0_rb;
wire [8:0] l44_AABAABBB_cycle = t_AABAABBB_a1_ra;

// l44_AABABABB_cycle
wire [7:0] t_AABABABB_b4_issue = bw_ABABB_ra + 8'd1;
wire [7:0] t_AABABABB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABB_rb : 8'd0);
wire [7:0] t_AABABABB_b4_rb = (t_AABABABB_b4_issue > t_AABABABB_b4_dep) ? t_AABABABB_b4_issue : t_AABABABB_b4_dep;
wire [7:0] t_AABABABB_b4_ra = bw_ABABB_ra;
wire [7:0] t_AABABABB_a0_issue = t_AABABABB_b4_rb + 8'd1;
wire [7:0] t_AABABABB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? t_AABABABB_b4_ra : 8'd0);
wire [7:0] t_AABABABB_a0_ra = (t_AABABABB_a0_issue > t_AABABABB_a0_dep) ? t_AABABABB_a0_issue : t_AABABABB_a0_dep;
wire [7:0] t_AABABABB_a0_rb = t_AABABABB_b4_rb;
wire [5:0] t_AABABABB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABABABB_a1_path = t_AABABABB_a0_ra + {{2{1'b0}}, t_AABABABB_a1_step};
wire [7:0] t_AABABABB_a1_ra = (t_AABABABB_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABABABB_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABABABB_a1_rb = t_AABABABB_a0_rb;
wire [8:0] l44_AABABABB_cycle = {{1{1'b0}}, t_AABABABB_a1_ra};

// l44_AABABBAB_cycle
wire [7:0] t_AABABBAB_b4_issue = bw_ABBAB_ra + 8'd1;
wire [7:0] t_AABABBAB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBAB_rb : 8'd0);
wire [7:0] t_AABABBAB_b4_rb = (t_AABABBAB_b4_issue > t_AABABBAB_b4_dep) ? t_AABABBAB_b4_issue : t_AABABBAB_b4_dep;
wire [7:0] t_AABABBAB_b4_ra = bw_ABBAB_ra;
wire [7:0] t_AABABBAB_a0_issue = t_AABABBAB_b4_rb + 8'd1;
wire [7:0] t_AABABBAB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? t_AABABBAB_b4_ra : 8'd0);
wire [7:0] t_AABABBAB_a0_ra = (t_AABABBAB_a0_issue > t_AABABBAB_a0_dep) ? t_AABABBAB_a0_issue : t_AABABBAB_a0_dep;
wire [7:0] t_AABABBAB_a0_rb = t_AABABBAB_b4_rb;
wire [5:0] t_AABABBAB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABABBAB_a1_path = t_AABABBAB_a0_ra + {{2{1'b0}}, t_AABABBAB_a1_step};
wire [7:0] t_AABABBAB_a1_ra = (t_AABABBAB_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABABBAB_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABABBAB_a1_rb = t_AABABBAB_a0_rb;
wire [8:0] l44_AABABBAB_cycle = {{1{1'b0}}, t_AABABBAB_a1_ra};

// l44_AABABBBA_cycle
wire [7:0] t_AABABBBA_b4_issue = bw_ABBBA_ra + 8'd1;
wire [7:0] t_AABABBBA_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBBA_rb : 8'd0);
wire [7:0] t_AABABBBA_b4_rb = (t_AABABBBA_b4_issue > t_AABABBBA_b4_dep) ? t_AABABBBA_b4_issue : t_AABABBBA_b4_dep;
wire [7:0] t_AABABBBA_b4_ra = bw_ABBBA_ra;
wire [7:0] t_AABABBBA_a0_issue = t_AABABBBA_b4_rb + 8'd1;
wire [7:0] t_AABABBBA_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? t_AABABBBA_b4_ra : 8'd0);
wire [7:0] t_AABABBBA_a0_ra = (t_AABABBBA_a0_issue > t_AABABBBA_a0_dep) ? t_AABABBBA_a0_issue : t_AABABBBA_a0_dep;
wire [7:0] t_AABABBBA_a0_rb = t_AABABBBA_b4_rb;
wire [5:0] t_AABABBBA_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABABBBA_a1_path = t_AABABBBA_a0_ra + {{2{1'b0}}, t_AABABBBA_a1_step};
wire [7:0] t_AABABBBA_a1_ra = (t_AABABBBA_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABABBBA_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABABBBA_a1_rb = t_AABABBBA_a0_rb;
wire [8:0] l44_AABABBBA_cycle = {{1{1'b0}}, t_AABABBBA_a1_ra};

// l44_AABBAABB_cycle
wire [5:0] t_AABBAABB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBAABB_b4_path = bw_BAABB_rb + {{2{1'b0}}, t_AABBAABB_b4_step};
wire [7:0] t_AABBAABB_b4_rb = (t_AABBAABB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBAABB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_AABBAABB_b4_ra = bw_BAABB_ra;
wire [7:0] t_AABBAABB_a0_issue = t_AABBAABB_b4_rb + 8'd1;
wire [7:0] t_AABBAABB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? t_AABBAABB_b4_ra : 8'd0);
wire [7:0] t_AABBAABB_a0_ra = (t_AABBAABB_a0_issue > t_AABBAABB_a0_dep) ? t_AABBAABB_a0_issue : t_AABBAABB_a0_dep;
wire [7:0] t_AABBAABB_a0_rb = t_AABBAABB_b4_rb;
wire [5:0] t_AABBAABB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABBAABB_a1_path = t_AABBAABB_a0_ra + {{2{1'b0}}, t_AABBAABB_a1_step};
wire [7:0] t_AABBAABB_a1_ra = (t_AABBAABB_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABBAABB_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBAABB_a1_rb = t_AABBAABB_a0_rb;
wire [8:0] l44_AABBAABB_cycle = {{1{1'b0}}, t_AABBAABB_a1_ra};

// l44_AABBABAB_cycle
wire [5:0] t_AABBABAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBABAB_b4_path = bw_BABAB_rb + {{2{1'b0}}, t_AABBABAB_b4_step};
wire [7:0] t_AABBABAB_b4_rb = (t_AABBABAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBABAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AABBABAB_b4_ra = bw_BABAB_ra;
wire [7:0] t_AABBABAB_a0_issue = t_AABBABAB_b4_rb + 8'd1;
wire [7:0] t_AABBABAB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, t_AABBABAB_b4_ra} : 8'd0);
wire [7:0] t_AABBABAB_a0_ra = (t_AABBABAB_a0_issue > t_AABBABAB_a0_dep) ? t_AABBABAB_a0_issue : t_AABBABAB_a0_dep;
wire [7:0] t_AABBABAB_a0_rb = t_AABBABAB_b4_rb;
wire [5:0] t_AABBABAB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABBABAB_a1_path = t_AABBABAB_a0_ra + {{2{1'b0}}, t_AABBABAB_a1_step};
wire [7:0] t_AABBABAB_a1_ra = (t_AABBABAB_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABBABAB_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBABAB_a1_rb = t_AABBABAB_a0_rb;
wire [8:0] l44_AABBABAB_cycle = {{1{1'b0}}, t_AABBABAB_a1_ra};

// l44_AABBABBA_cycle
wire [5:0] t_AABBABBA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBABBA_b4_path = bw_BABBA_rb + {{2{1'b0}}, t_AABBABBA_b4_step};
wire [7:0] t_AABBABBA_b4_rb = (t_AABBABBA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBABBA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AABBABBA_b4_ra = bw_BABBA_ra;
wire [7:0] t_AABBABBA_a0_issue = t_AABBABBA_b4_rb + 8'd1;
wire [7:0] t_AABBABBA_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, t_AABBABBA_b4_ra} : 8'd0);
wire [7:0] t_AABBABBA_a0_ra = (t_AABBABBA_a0_issue > t_AABBABBA_a0_dep) ? t_AABBABBA_a0_issue : t_AABBABBA_a0_dep;
wire [7:0] t_AABBABBA_a0_rb = t_AABBABBA_b4_rb;
wire [5:0] t_AABBABBA_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABBABBA_a1_path = t_AABBABBA_a0_ra + {{2{1'b0}}, t_AABBABBA_a1_step};
wire [7:0] t_AABBABBA_a1_ra = (t_AABBABBA_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABBABBA_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBABBA_a1_rb = t_AABBABBA_a0_rb;
wire [8:0] l44_AABBABBA_cycle = {{1{1'b0}}, t_AABBABBA_a1_ra};

// l44_AABBBAAB_cycle
wire [5:0] t_AABBBAAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBBAAB_b4_path = bw_BBAAB_rb + {{2{1'b0}}, t_AABBBAAB_b4_step};
wire [7:0] t_AABBBAAB_b4_rb = (t_AABBBAAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBBAAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AABBBAAB_b4_ra = bw_BBAAB_ra;
wire [7:0] t_AABBBAAB_a0_issue = t_AABBBAAB_b4_rb + 8'd1;
wire [7:0] t_AABBBAAB_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, t_AABBBAAB_b4_ra} : 8'd0);
wire [7:0] t_AABBBAAB_a0_ra = (t_AABBBAAB_a0_issue > t_AABBBAAB_a0_dep) ? t_AABBBAAB_a0_issue : t_AABBBAAB_a0_dep;
wire [7:0] t_AABBBAAB_a0_rb = t_AABBBAAB_b4_rb;
wire [5:0] t_AABBBAAB_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABBBAAB_a1_path = t_AABBBAAB_a0_ra + {{2{1'b0}}, t_AABBBAAB_a1_step};
wire [7:0] t_AABBBAAB_a1_ra = (t_AABBBAAB_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABBBAAB_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBBAAB_a1_rb = t_AABBBAAB_a0_rb;
wire [8:0] l44_AABBBAAB_cycle = {{1{1'b0}}, t_AABBBAAB_a1_ra};

// l44_AABBBABA_cycle
wire [5:0] t_AABBBABA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBBABA_b4_path = bw_BBABA_rb + {{2{1'b0}}, t_AABBBABA_b4_step};
wire [7:0] t_AABBBABA_b4_rb = (t_AABBBABA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBBABA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AABBBABA_b4_ra = bw_BBABA_ra;
wire [7:0] t_AABBBABA_a0_issue = t_AABBBABA_b4_rb + 8'd1;
wire [7:0] t_AABBBABA_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, t_AABBBABA_b4_ra} : 8'd0);
wire [7:0] t_AABBBABA_a0_ra = (t_AABBBABA_a0_issue > t_AABBBABA_a0_dep) ? t_AABBBABA_a0_issue : t_AABBBABA_a0_dep;
wire [7:0] t_AABBBABA_a0_rb = t_AABBBABA_b4_rb;
wire [5:0] t_AABBBABA_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [7:0] t_AABBBABA_a1_path = t_AABBBABA_a0_ra + {{2{1'b0}}, t_AABBBABA_a1_step};
wire [7:0] t_AABBBABA_a1_ra = (t_AABBBABA_a1_path > {{2{1'b0}}, A_rev_lat[3]}) ? t_AABBBABA_a1_path : {{2{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBBABA_a1_rb = t_AABBBABA_a0_rb;
wire [8:0] l44_AABBBABA_cycle = {{1{1'b0}}, t_AABBBABA_a1_ra};

// l44_AABBBBAA_cycle
wire [5:0] t_AABBBBAA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_AABBBBAA_b4_path = bw_BBBAA_rb + {{2{1'b0}}, t_AABBBBAA_b4_step};
wire [7:0] t_AABBBBAA_b4_rb = (t_AABBBBAA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_AABBBBAA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [6:0] t_AABBBBAA_b4_ra = bw_BBBAA_ra;
wire [7:0] t_AABBBBAA_a0_issue = t_AABBBBAA_b4_rb + 8'd1;
wire [7:0] t_AABBBBAA_a0_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, t_AABBBBAA_b4_ra} : 8'd0);
wire [7:0] t_AABBBBAA_a0_ra = (t_AABBBBAA_a0_issue > t_AABBBBAA_a0_dep) ? t_AABBBBAA_a0_issue : t_AABBBBAA_a0_dep;
wire [7:0] t_AABBBBAA_a0_rb = t_AABBBBAA_b4_rb;
wire [5:0] t_AABBBBAA_a1_step = A_dependent ? A_rev_lat[3] : 6'd1;
wire [8:0] t_AABBBBAA_a1_path = {{1{1'b0}}, t_AABBBBAA_a0_ra} + {{3{1'b0}}, t_AABBBBAA_a1_step};
wire [8:0] t_AABBBBAA_a1_ra = (t_AABBBBAA_a1_path > {{3{1'b0}}, A_rev_lat[3]}) ? t_AABBBBAA_a1_path : {{3{1'b0}}, A_rev_lat[3]};
wire [7:0] t_AABBBBAA_a1_rb = t_AABBBBAA_a0_rb;
wire [8:0] l44_AABBBBAA_cycle = t_AABBBBAA_a1_ra;

// l44_ABAAABBB_cycle
wire [7:0] t_ABAAABBB_b4_issue = bw_AAABBB_ra + 8'd1;
wire [7:0] t_ABAAABBB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AAABBB_rb : 8'd0);
wire [7:0] t_ABAAABBB_b4_rb = (t_ABAAABBB_b4_issue > t_ABAAABBB_b4_dep) ? t_ABAAABBB_b4_issue : t_ABAAABBB_b4_dep;
wire [7:0] t_ABAAABBB_b4_ra = bw_AAABBB_ra;
wire [7:0] t_ABAAABBB_a0_issue = t_ABAAABBB_b4_rb + 8'd1;
wire [8:0] t_ABAAABBB_a0_dep = {{3{1'b0}}, A_rev_lat[3]} + (A_dependent ? {{1{1'b0}}, t_ABAAABBB_b4_ra} : 9'd0);
wire [8:0] t_ABAAABBB_a0_ra = ({{1{1'b0}}, t_ABAAABBB_a0_issue} > t_ABAAABBB_a0_dep) ? {{1{1'b0}}, t_ABAAABBB_a0_issue} : t_ABAAABBB_a0_dep;
wire [7:0] t_ABAAABBB_a0_rb = t_ABAAABBB_b4_rb;
wire [8:0] l44_ABAAABBB_cycle = t_ABAAABBB_a0_ra;

// l44_ABAABABB_cycle
wire [7:0] t_ABAABABB_b4_issue = bw_AABABB_ra + 8'd1;
wire [7:0] t_ABAABABB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABABB_rb : 8'd0);
wire [7:0] t_ABAABABB_b4_rb = (t_ABAABABB_b4_issue > t_ABAABABB_b4_dep) ? t_ABAABABB_b4_issue : t_ABAABABB_b4_dep;
wire [7:0] t_ABAABABB_b4_ra = bw_AABABB_ra;
wire [7:0] t_ABAABABB_a0_issue = t_ABAABABB_b4_rb + 8'd1;
wire [7:0] t_ABAABABB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABAABABB_b4_ra : 8'd0);
wire [7:0] t_ABAABABB_a0_ra = (t_ABAABABB_a0_issue > t_ABAABABB_a0_dep) ? t_ABAABABB_a0_issue : t_ABAABABB_a0_dep;
wire [7:0] t_ABAABABB_a0_rb = t_ABAABABB_b4_rb;
wire [8:0] l44_ABAABABB_cycle = {{1{1'b0}}, t_ABAABABB_a0_ra};

// l44_ABAABBAB_cycle
wire [7:0] t_ABAABBAB_b4_issue = bw_AABBAB_ra + 8'd1;
wire [7:0] t_ABAABBAB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBAB_rb : 8'd0);
wire [7:0] t_ABAABBAB_b4_rb = (t_ABAABBAB_b4_issue > t_ABAABBAB_b4_dep) ? t_ABAABBAB_b4_issue : t_ABAABBAB_b4_dep;
wire [7:0] t_ABAABBAB_b4_ra = bw_AABBAB_ra;
wire [7:0] t_ABAABBAB_a0_issue = t_ABAABBAB_b4_rb + 8'd1;
wire [7:0] t_ABAABBAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABAABBAB_b4_ra : 8'd0);
wire [7:0] t_ABAABBAB_a0_ra = (t_ABAABBAB_a0_issue > t_ABAABBAB_a0_dep) ? t_ABAABBAB_a0_issue : t_ABAABBAB_a0_dep;
wire [7:0] t_ABAABBAB_a0_rb = t_ABAABBAB_b4_rb;
wire [8:0] l44_ABAABBAB_cycle = {{1{1'b0}}, t_ABAABBAB_a0_ra};

// l44_ABAABBBA_cycle
wire [7:0] t_ABAABBBA_b4_issue = bw_AABBBA_ra + 8'd1;
wire [7:0] t_ABAABBBA_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBBA_rb : 8'd0);
wire [7:0] t_ABAABBBA_b4_rb = (t_ABAABBBA_b4_issue > t_ABAABBBA_b4_dep) ? t_ABAABBBA_b4_issue : t_ABAABBBA_b4_dep;
wire [7:0] t_ABAABBBA_b4_ra = bw_AABBBA_ra;
wire [7:0] t_ABAABBBA_a0_issue = t_ABAABBBA_b4_rb + 8'd1;
wire [7:0] t_ABAABBBA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABAABBBA_b4_ra : 8'd0);
wire [7:0] t_ABAABBBA_a0_ra = (t_ABAABBBA_a0_issue > t_ABAABBBA_a0_dep) ? t_ABAABBBA_a0_issue : t_ABAABBBA_a0_dep;
wire [7:0] t_ABAABBBA_a0_rb = t_ABAABBBA_b4_rb;
wire [8:0] l44_ABAABBBA_cycle = {{1{1'b0}}, t_ABAABBBA_a0_ra};

// l44_ABABAABB_cycle
wire [7:0] t_ABABAABB_b4_issue = bw_ABAABB_ra + 8'd1;
wire [7:0] t_ABABAABB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABAABB_rb : 8'd0);
wire [7:0] t_ABABAABB_b4_rb = (t_ABABAABB_b4_issue > t_ABABAABB_b4_dep) ? t_ABABAABB_b4_issue : t_ABABAABB_b4_dep;
wire [7:0] t_ABABAABB_b4_ra = bw_ABAABB_ra;
wire [7:0] t_ABABAABB_a0_issue = t_ABABAABB_b4_rb + 8'd1;
wire [7:0] t_ABABAABB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABAABB_b4_ra : 8'd0);
wire [7:0] t_ABABAABB_a0_ra = (t_ABABAABB_a0_issue > t_ABABAABB_a0_dep) ? t_ABABAABB_a0_issue : t_ABABAABB_a0_dep;
wire [7:0] t_ABABAABB_a0_rb = t_ABABAABB_b4_rb;
wire [8:0] l44_ABABAABB_cycle = {{1{1'b0}}, t_ABABAABB_a0_ra};

// l44_ABABABAB_cycle
wire [7:0] t_ABABABAB_b4_issue = bw_ABABAB_ra + 8'd1;
wire [7:0] t_ABABABAB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABAB_rb : 8'd0);
wire [7:0] t_ABABABAB_b4_rb = (t_ABABABAB_b4_issue > t_ABABABAB_b4_dep) ? t_ABABABAB_b4_issue : t_ABABABAB_b4_dep;
wire [7:0] t_ABABABAB_b4_ra = bw_ABABAB_ra;
wire [7:0] t_ABABABAB_a0_issue = t_ABABABAB_b4_rb + 8'd1;
wire [7:0] t_ABABABAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABABAB_b4_ra : 8'd0);
wire [7:0] t_ABABABAB_a0_ra = (t_ABABABAB_a0_issue > t_ABABABAB_a0_dep) ? t_ABABABAB_a0_issue : t_ABABABAB_a0_dep;
wire [7:0] t_ABABABAB_a0_rb = t_ABABABAB_b4_rb;
wire [8:0] l44_ABABABAB_cycle = {{1{1'b0}}, t_ABABABAB_a0_ra};

// l44_ABABABBA_cycle
wire [7:0] t_ABABABBA_b4_issue = bw_ABABBA_ra + 8'd1;
wire [7:0] t_ABABABBA_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABBA_rb : 8'd0);
wire [7:0] t_ABABABBA_b4_rb = (t_ABABABBA_b4_issue > t_ABABABBA_b4_dep) ? t_ABABABBA_b4_issue : t_ABABABBA_b4_dep;
wire [7:0] t_ABABABBA_b4_ra = bw_ABABBA_ra;
wire [7:0] t_ABABABBA_a0_issue = t_ABABABBA_b4_rb + 8'd1;
wire [7:0] t_ABABABBA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABABBA_b4_ra : 8'd0);
wire [7:0] t_ABABABBA_a0_ra = (t_ABABABBA_a0_issue > t_ABABABBA_a0_dep) ? t_ABABABBA_a0_issue : t_ABABABBA_a0_dep;
wire [7:0] t_ABABABBA_a0_rb = t_ABABABBA_b4_rb;
wire [8:0] l44_ABABABBA_cycle = {{1{1'b0}}, t_ABABABBA_a0_ra};

// l44_ABABBAAB_cycle
wire [7:0] t_ABABBAAB_b4_issue = bw_ABBAAB_ra + 8'd1;
wire [7:0] t_ABABBAAB_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBAAB_rb : 8'd0);
wire [7:0] t_ABABBAAB_b4_rb = (t_ABABBAAB_b4_issue > t_ABABBAAB_b4_dep) ? t_ABABBAAB_b4_issue : t_ABABBAAB_b4_dep;
wire [7:0] t_ABABBAAB_b4_ra = bw_ABBAAB_ra;
wire [7:0] t_ABABBAAB_a0_issue = t_ABABBAAB_b4_rb + 8'd1;
wire [7:0] t_ABABBAAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABBAAB_b4_ra : 8'd0);
wire [7:0] t_ABABBAAB_a0_ra = (t_ABABBAAB_a0_issue > t_ABABBAAB_a0_dep) ? t_ABABBAAB_a0_issue : t_ABABBAAB_a0_dep;
wire [7:0] t_ABABBAAB_a0_rb = t_ABABBAAB_b4_rb;
wire [8:0] l44_ABABBAAB_cycle = {{1{1'b0}}, t_ABABBAAB_a0_ra};

// l44_ABABBABA_cycle
wire [7:0] t_ABABBABA_b4_issue = bw_ABBABA_ra + 8'd1;
wire [7:0] t_ABABBABA_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBABA_rb : 8'd0);
wire [7:0] t_ABABBABA_b4_rb = (t_ABABBABA_b4_issue > t_ABABBABA_b4_dep) ? t_ABABBABA_b4_issue : t_ABABBABA_b4_dep;
wire [7:0] t_ABABBABA_b4_ra = bw_ABBABA_ra;
wire [7:0] t_ABABBABA_a0_issue = t_ABABBABA_b4_rb + 8'd1;
wire [7:0] t_ABABBABA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABBABA_b4_ra : 8'd0);
wire [7:0] t_ABABBABA_a0_ra = (t_ABABBABA_a0_issue > t_ABABBABA_a0_dep) ? t_ABABBABA_a0_issue : t_ABABBABA_a0_dep;
wire [7:0] t_ABABBABA_a0_rb = t_ABABBABA_b4_rb;
wire [8:0] l44_ABABBABA_cycle = {{1{1'b0}}, t_ABABBABA_a0_ra};

// l44_ABABBBAA_cycle
wire [7:0] t_ABABBBAA_b4_issue = bw_ABBBAA_ra + 8'd1;
wire [7:0] t_ABABBBAA_b4_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBBAA_rb : 8'd0);
wire [7:0] t_ABABBBAA_b4_rb = (t_ABABBBAA_b4_issue > t_ABABBBAA_b4_dep) ? t_ABABBBAA_b4_issue : t_ABABBBAA_b4_dep;
wire [7:0] t_ABABBBAA_b4_ra = bw_ABBBAA_ra;
wire [7:0] t_ABABBBAA_a0_issue = t_ABABBBAA_b4_rb + 8'd1;
wire [7:0] t_ABABBBAA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABABBBAA_b4_ra : 8'd0);
wire [7:0] t_ABABBBAA_a0_ra = (t_ABABBBAA_a0_issue > t_ABABBBAA_a0_dep) ? t_ABABBBAA_a0_issue : t_ABABBBAA_a0_dep;
wire [7:0] t_ABABBBAA_a0_rb = t_ABABBBAA_b4_rb;
wire [8:0] l44_ABABBBAA_cycle = {{1{1'b0}}, t_ABABBBAA_a0_ra};

// l44_ABBAAABB_cycle
wire [5:0] t_ABBAAABB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBAAABB_b4_path = bw_BAAABB_rb + {{2{1'b0}}, t_ABBAAABB_b4_step};
wire [7:0] t_ABBAAABB_b4_rb = (t_ABBAAABB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBAAABB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBAAABB_b4_ra = bw_BAAABB_ra;
wire [7:0] t_ABBAAABB_a0_issue = t_ABBAAABB_b4_rb + 8'd1;
wire [7:0] t_ABBAAABB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBAAABB_b4_ra : 8'd0);
wire [7:0] t_ABBAAABB_a0_ra = (t_ABBAAABB_a0_issue > t_ABBAAABB_a0_dep) ? t_ABBAAABB_a0_issue : t_ABBAAABB_a0_dep;
wire [7:0] t_ABBAAABB_a0_rb = t_ABBAAABB_b4_rb;
wire [8:0] l44_ABBAAABB_cycle = {{1{1'b0}}, t_ABBAAABB_a0_ra};

// l44_ABBAABAB_cycle
wire [5:0] t_ABBAABAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBAABAB_b4_path = bw_BAABAB_rb + {{2{1'b0}}, t_ABBAABAB_b4_step};
wire [7:0] t_ABBAABAB_b4_rb = (t_ABBAABAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBAABAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBAABAB_b4_ra = bw_BAABAB_ra;
wire [7:0] t_ABBAABAB_a0_issue = t_ABBAABAB_b4_rb + 8'd1;
wire [7:0] t_ABBAABAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBAABAB_b4_ra : 8'd0);
wire [7:0] t_ABBAABAB_a0_ra = (t_ABBAABAB_a0_issue > t_ABBAABAB_a0_dep) ? t_ABBAABAB_a0_issue : t_ABBAABAB_a0_dep;
wire [7:0] t_ABBAABAB_a0_rb = t_ABBAABAB_b4_rb;
wire [8:0] l44_ABBAABAB_cycle = {{1{1'b0}}, t_ABBAABAB_a0_ra};

// l44_ABBAABBA_cycle
wire [5:0] t_ABBAABBA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBAABBA_b4_path = bw_BAABBA_rb + {{2{1'b0}}, t_ABBAABBA_b4_step};
wire [7:0] t_ABBAABBA_b4_rb = (t_ABBAABBA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBAABBA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBAABBA_b4_ra = bw_BAABBA_ra;
wire [7:0] t_ABBAABBA_a0_issue = t_ABBAABBA_b4_rb + 8'd1;
wire [7:0] t_ABBAABBA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBAABBA_b4_ra : 8'd0);
wire [7:0] t_ABBAABBA_a0_ra = (t_ABBAABBA_a0_issue > t_ABBAABBA_a0_dep) ? t_ABBAABBA_a0_issue : t_ABBAABBA_a0_dep;
wire [7:0] t_ABBAABBA_a0_rb = t_ABBAABBA_b4_rb;
wire [8:0] l44_ABBAABBA_cycle = {{1{1'b0}}, t_ABBAABBA_a0_ra};

// l44_ABBABAAB_cycle
wire [5:0] t_ABBABAAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBABAAB_b4_path = bw_BABAAB_rb + {{2{1'b0}}, t_ABBABAAB_b4_step};
wire [7:0] t_ABBABAAB_b4_rb = (t_ABBABAAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBABAAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBABAAB_b4_ra = bw_BABAAB_ra;
wire [7:0] t_ABBABAAB_a0_issue = t_ABBABAAB_b4_rb + 8'd1;
wire [7:0] t_ABBABAAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBABAAB_b4_ra : 8'd0);
wire [7:0] t_ABBABAAB_a0_ra = (t_ABBABAAB_a0_issue > t_ABBABAAB_a0_dep) ? t_ABBABAAB_a0_issue : t_ABBABAAB_a0_dep;
wire [7:0] t_ABBABAAB_a0_rb = t_ABBABAAB_b4_rb;
wire [8:0] l44_ABBABAAB_cycle = {{1{1'b0}}, t_ABBABAAB_a0_ra};

// l44_ABBABABA_cycle
wire [5:0] t_ABBABABA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBABABA_b4_path = bw_BABABA_rb + {{2{1'b0}}, t_ABBABABA_b4_step};
wire [7:0] t_ABBABABA_b4_rb = (t_ABBABABA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBABABA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBABABA_b4_ra = bw_BABABA_ra;
wire [7:0] t_ABBABABA_a0_issue = t_ABBABABA_b4_rb + 8'd1;
wire [7:0] t_ABBABABA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBABABA_b4_ra : 8'd0);
wire [7:0] t_ABBABABA_a0_ra = (t_ABBABABA_a0_issue > t_ABBABABA_a0_dep) ? t_ABBABABA_a0_issue : t_ABBABABA_a0_dep;
wire [7:0] t_ABBABABA_a0_rb = t_ABBABABA_b4_rb;
wire [8:0] l44_ABBABABA_cycle = {{1{1'b0}}, t_ABBABABA_a0_ra};

// l44_ABBABBAA_cycle
wire [5:0] t_ABBABBAA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBABBAA_b4_path = bw_BABBAA_rb + {{2{1'b0}}, t_ABBABBAA_b4_step};
wire [7:0] t_ABBABBAA_b4_rb = (t_ABBABBAA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBABBAA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBABBAA_b4_ra = bw_BABBAA_ra;
wire [7:0] t_ABBABBAA_a0_issue = t_ABBABBAA_b4_rb + 8'd1;
wire [7:0] t_ABBABBAA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBABBAA_b4_ra : 8'd0);
wire [7:0] t_ABBABBAA_a0_ra = (t_ABBABBAA_a0_issue > t_ABBABBAA_a0_dep) ? t_ABBABBAA_a0_issue : t_ABBABBAA_a0_dep;
wire [7:0] t_ABBABBAA_a0_rb = t_ABBABBAA_b4_rb;
wire [8:0] l44_ABBABBAA_cycle = {{1{1'b0}}, t_ABBABBAA_a0_ra};

// l44_ABBBAAAB_cycle
wire [5:0] t_ABBBAAAB_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBBAAAB_b4_path = bw_BBAAAB_rb + {{2{1'b0}}, t_ABBBAAAB_b4_step};
wire [7:0] t_ABBBAAAB_b4_rb = (t_ABBBAAAB_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBBAAAB_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBBAAAB_b4_ra = bw_BBAAAB_ra;
wire [7:0] t_ABBBAAAB_a0_issue = t_ABBBAAAB_b4_rb + 8'd1;
wire [7:0] t_ABBBAAAB_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBBAAAB_b4_ra : 8'd0);
wire [7:0] t_ABBBAAAB_a0_ra = (t_ABBBAAAB_a0_issue > t_ABBBAAAB_a0_dep) ? t_ABBBAAAB_a0_issue : t_ABBBAAAB_a0_dep;
wire [7:0] t_ABBBAAAB_a0_rb = t_ABBBAAAB_b4_rb;
wire [8:0] l44_ABBBAAAB_cycle = {{1{1'b0}}, t_ABBBAAAB_a0_ra};

// l44_ABBBAABA_cycle
wire [5:0] t_ABBBAABA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBBAABA_b4_path = bw_BBAABA_rb + {{2{1'b0}}, t_ABBBAABA_b4_step};
wire [7:0] t_ABBBAABA_b4_rb = (t_ABBBAABA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBBAABA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBBAABA_b4_ra = bw_BBAABA_ra;
wire [7:0] t_ABBBAABA_a0_issue = t_ABBBAABA_b4_rb + 8'd1;
wire [7:0] t_ABBBAABA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBBAABA_b4_ra : 8'd0);
wire [7:0] t_ABBBAABA_a0_ra = (t_ABBBAABA_a0_issue > t_ABBBAABA_a0_dep) ? t_ABBBAABA_a0_issue : t_ABBBAABA_a0_dep;
wire [7:0] t_ABBBAABA_a0_rb = t_ABBBAABA_b4_rb;
wire [8:0] l44_ABBBAABA_cycle = {{1{1'b0}}, t_ABBBAABA_a0_ra};

// l44_ABBBABAA_cycle
wire [5:0] t_ABBBABAA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] t_ABBBABAA_b4_path = bw_BBABAA_rb + {{2{1'b0}}, t_ABBBABAA_b4_step};
wire [7:0] t_ABBBABAA_b4_rb = (t_ABBBABAA_b4_path > {{2{1'b0}}, B_rev_lat[3]}) ? t_ABBBABAA_b4_path : {{2{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBBABAA_b4_ra = bw_BBABAA_ra;
wire [7:0] t_ABBBABAA_a0_issue = t_ABBBABAA_b4_rb + 8'd1;
wire [7:0] t_ABBBABAA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBBABAA_b4_ra : 8'd0);
wire [7:0] t_ABBBABAA_a0_ra = (t_ABBBABAA_a0_issue > t_ABBBABAA_a0_dep) ? t_ABBBABAA_a0_issue : t_ABBBABAA_a0_dep;
wire [7:0] t_ABBBABAA_a0_rb = t_ABBBABAA_b4_rb;
wire [8:0] l44_ABBBABAA_cycle = {{1{1'b0}}, t_ABBBABAA_a0_ra};

// l44_ABBBBAAA_cycle
wire [5:0] t_ABBBBAAA_b4_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] t_ABBBBAAA_b4_path = {{1{1'b0}}, bw_BBBAAA_rb} + {{3{1'b0}}, t_ABBBBAAA_b4_step};
wire [8:0] t_ABBBBAAA_b4_rb = (t_ABBBBAAA_b4_path > {{3{1'b0}}, B_rev_lat[3]}) ? t_ABBBBAAA_b4_path : {{3{1'b0}}, B_rev_lat[3]};
wire [7:0] t_ABBBBAAA_b4_ra = bw_BBBAAA_ra;
wire [8:0] t_ABBBBAAA_a0_issue = t_ABBBBAAA_b4_rb + 9'd1;
wire [7:0] t_ABBBBAAA_a0_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? t_ABBBBAAA_b4_ra : 8'd0);
wire [8:0] t_ABBBBAAA_a0_ra = (t_ABBBBAAA_a0_issue > {{1{1'b0}}, t_ABBBBAAA_a0_dep}) ? t_ABBBBAAA_a0_issue : {{1{1'b0}}, t_ABBBBAAA_a0_dep};
wire [8:0] t_ABBBBAAA_a0_rb = t_ABBBBAAA_b4_rb;
wire [8:0] l44_ABBBBAAA_cycle = t_ABBBBAAA_a0_ra;

//////// FINAL LEAVES ////////

// l80_AAAAAAAA_cycle
wire [5:0] f_AAAAAAAA_step = A_dependent ? A_rev_lat[7] : 6'd1;
wire [8:0] f_AAAAAAAA_path = bw_AAAAAAA_ra + {{3{1'b0}}, f_AAAAAAAA_step};
wire [8:0] f_AAAAAAAA_ra = (f_AAAAAAAA_path > {{3{1'b0}}, A_rev_lat[7]}) ? f_AAAAAAAA_path : {{3{1'b0}}, A_rev_lat[7]};
wire [8:0] l80_AAAAAAAA_cycle = f_AAAAAAAA_ra;

// l71_AAAAAAAB_cycle
wire [5:0] f_AAAAAAAB_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AAAAAAAB_path = bw_AAAAAAB_ra + {{3{1'b0}}, f_AAAAAAAB_step};
wire [8:0] f_AAAAAAAB_ra = (f_AAAAAAAB_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AAAAAAAB_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AAAAAAAB_cycle = f_AAAAAAAB_ra;

// l71_AAAAAABA_cycle
wire [5:0] f_AAAAAABA_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AAAAAABA_path = bw_AAAAABA_ra + {{3{1'b0}}, f_AAAAAABA_step};
wire [8:0] f_AAAAAABA_ra = (f_AAAAAABA_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AAAAAABA_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AAAAAABA_cycle = f_AAAAAABA_ra;

// l62_AAAAAABB_cycle
wire [5:0] f_AAAAAABB_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAAAABB_path = bw_AAAAABB_ra + {{3{1'b0}}, f_AAAAAABB_step};
wire [8:0] f_AAAAAABB_ra = (f_AAAAAABB_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAAAABB_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAAAABB_cycle = f_AAAAAABB_ra;

// l71_AAAAABAA_cycle
wire [5:0] f_AAAAABAA_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AAAAABAA_path = bw_AAAABAA_ra + {{3{1'b0}}, f_AAAAABAA_step};
wire [8:0] f_AAAAABAA_ra = (f_AAAAABAA_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AAAAABAA_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AAAAABAA_cycle = f_AAAAABAA_ra;

// l62_AAAAABAB_cycle
wire [5:0] f_AAAAABAB_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAAABAB_path = {{1{1'b0}}, bw_AAAABAB_ra} + {{3{1'b0}}, f_AAAAABAB_step};
wire [8:0] f_AAAAABAB_ra = (f_AAAAABAB_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAAABAB_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAAABAB_cycle = f_AAAAABAB_ra;

// l62_AAAAABBA_cycle
wire [5:0] f_AAAAABBA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAAABBA_path = {{1{1'b0}}, bw_AAAABBA_ra} + {{3{1'b0}}, f_AAAAABBA_step};
wire [8:0] f_AAAAABBA_ra = (f_AAAAABBA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAAABBA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAAABBA_cycle = f_AAAAABBA_ra;

// l53_AAAAABBB_cycle
wire [5:0] f_AAAAABBB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAAAABBB_path = bw_AAAABBB_ra + {{3{1'b0}}, f_AAAAABBB_step};
wire [8:0] f_AAAAABBB_ra = (f_AAAAABBB_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAAAABBB_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAAAABBB_cycle = f_AAAAABBB_ra;

// l71_AAAABAAA_cycle
wire [5:0] f_AAAABAAA_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AAAABAAA_path = bw_AAABAAA_ra + {{3{1'b0}}, f_AAAABAAA_step};
wire [8:0] f_AAAABAAA_ra = (f_AAAABAAA_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AAAABAAA_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AAAABAAA_cycle = f_AAAABAAA_ra;

// l62_AAAABAAB_cycle
wire [5:0] f_AAAABAAB_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAABAAB_path = {{1{1'b0}}, bw_AAABAAB_ra} + {{3{1'b0}}, f_AAAABAAB_step};
wire [8:0] f_AAAABAAB_ra = (f_AAAABAAB_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAABAAB_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAABAAB_cycle = f_AAAABAAB_ra;

// l62_AAAABABA_cycle
wire [5:0] f_AAAABABA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAABABA_path = {{1{1'b0}}, bw_AAABABA_ra} + {{3{1'b0}}, f_AAAABABA_step};
wire [8:0] f_AAAABABA_ra = (f_AAAABABA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAABABA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAABABA_cycle = f_AAAABABA_ra;

// l53_AAAABABB_cycle
wire [5:0] f_AAAABABB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAAABABB_path = {{1{1'b0}}, bw_AAABABB_ra} + {{3{1'b0}}, f_AAAABABB_step};
wire [8:0] f_AAAABABB_ra = (f_AAAABABB_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAAABABB_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAAABABB_cycle = f_AAAABABB_ra;

// l62_AAAABBAA_cycle
wire [5:0] f_AAAABBAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAAABBAA_path = {{1{1'b0}}, bw_AAABBAA_ra} + {{3{1'b0}}, f_AAAABBAA_step};
wire [8:0] f_AAAABBAA_ra = (f_AAAABBAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAAABBAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAAABBAA_cycle = f_AAAABBAA_ra;

// l53_AAAABBAB_cycle
wire [5:0] f_AAAABBAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAAABBAB_path = {{1{1'b0}}, bw_AAABBAB_ra} + {{3{1'b0}}, f_AAAABBAB_step};
wire [8:0] f_AAAABBAB_ra = (f_AAAABBAB_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAAABBAB_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAAABBAB_cycle = f_AAAABBAB_ra;

// l53_AAAABBBA_cycle
wire [5:0] f_AAAABBBA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAAABBBA_path = {{1{1'b0}}, bw_AAABBBA_ra} + {{3{1'b0}}, f_AAAABBBA_step};
wire [8:0] f_AAAABBBA_ra = (f_AAAABBBA_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAAABBBA_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAAABBBA_cycle = f_AAAABBBA_ra;

// l71_AAABAAAA_cycle
wire [5:0] f_AAABAAAA_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AAABAAAA_path = bw_AABAAAA_ra + {{3{1'b0}}, f_AAABAAAA_step};
wire [8:0] f_AAABAAAA_ra = (f_AAABAAAA_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AAABAAAA_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AAABAAAA_cycle = f_AAABAAAA_ra;

// l62_AAABAAAB_cycle
wire [5:0] f_AAABAAAB_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAABAAAB_path = {{1{1'b0}}, bw_AABAAAB_ra} + {{3{1'b0}}, f_AAABAAAB_step};
wire [8:0] f_AAABAAAB_ra = (f_AAABAAAB_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAABAAAB_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAABAAAB_cycle = f_AAABAAAB_ra;

// l62_AAABAABA_cycle
wire [5:0] f_AAABAABA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAABAABA_path = {{1{1'b0}}, bw_AABAABA_ra} + {{3{1'b0}}, f_AAABAABA_step};
wire [8:0] f_AAABAABA_ra = (f_AAABAABA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAABAABA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAABAABA_cycle = f_AAABAABA_ra;

// l53_AAABAABB_cycle
wire [5:0] f_AAABAABB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAABAABB_path = {{1{1'b0}}, bw_AABAABB_ra} + {{3{1'b0}}, f_AAABAABB_step};
wire [8:0] f_AAABAABB_ra = (f_AAABAABB_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAABAABB_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABAABB_cycle = f_AAABAABB_ra;

// l62_AAABABAA_cycle
wire [5:0] f_AAABABAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAABABAA_path = {{1{1'b0}}, bw_AABABAA_ra} + {{3{1'b0}}, f_AAABABAA_step};
wire [8:0] f_AAABABAA_ra = (f_AAABABAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAABABAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAABABAA_cycle = f_AAABABAA_ra;

// l53_AAABABAB_cycle
wire [5:0] f_AAABABAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AAABABAB_path = bw_AABABAB_ra + {{2{1'b0}}, f_AAABABAB_step};
wire [7:0] f_AAABABAB_ra = (f_AAABABAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AAABABAB_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABABAB_cycle = {{1{1'b0}}, f_AAABABAB_ra};

// l53_AAABABBA_cycle
wire [5:0] f_AAABABBA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AAABABBA_path = bw_AABABBA_ra + {{2{1'b0}}, f_AAABABBA_step};
wire [7:0] f_AAABABBA_ra = (f_AAABABBA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AAABABBA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABABBA_cycle = {{1{1'b0}}, f_AAABABBA_ra};

// l62_AAABBAAA_cycle
wire [5:0] f_AAABBAAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AAABBAAA_path = {{1{1'b0}}, bw_AABBAAA_ra} + {{3{1'b0}}, f_AAABBAAA_step};
wire [8:0] f_AAABBAAA_ra = (f_AAABBAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AAABBAAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AAABBAAA_cycle = f_AAABBAAA_ra;

// l53_AAABBAAB_cycle
wire [5:0] f_AAABBAAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AAABBAAB_path = bw_AABBAAB_ra + {{2{1'b0}}, f_AAABBAAB_step};
wire [7:0] f_AAABBAAB_ra = (f_AAABBAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AAABBAAB_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABBAAB_cycle = {{1{1'b0}}, f_AAABBAAB_ra};

// l53_AAABBABA_cycle
wire [5:0] f_AAABBABA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AAABBABA_path = bw_AABBABA_ra + {{2{1'b0}}, f_AAABBABA_step};
wire [7:0] f_AAABBABA_ra = (f_AAABBABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AAABBABA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABBABA_cycle = {{1{1'b0}}, f_AAABBABA_ra};

// l53_AAABBBAA_cycle
wire [5:0] f_AAABBBAA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AAABBBAA_path = {{1{1'b0}}, bw_AABBBAA_ra} + {{3{1'b0}}, f_AAABBBAA_step};
wire [8:0] f_AAABBBAA_ra = (f_AAABBBAA_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AAABBBAA_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AAABBBAA_cycle = f_AAABBBAA_ra;

// l71_AABAAAAA_cycle
wire [5:0] f_AABAAAAA_step = A_dependent ? A_rev_lat[6] : 6'd1;
wire [8:0] f_AABAAAAA_path = bw_ABAAAAA_ra + {{3{1'b0}}, f_AABAAAAA_step};
wire [8:0] f_AABAAAAA_ra = (f_AABAAAAA_path > {{3{1'b0}}, A_rev_lat[6]}) ? f_AABAAAAA_path : {{3{1'b0}}, A_rev_lat[6]};
wire [8:0] l71_AABAAAAA_cycle = f_AABAAAAA_ra;

// l62_AABAAAAB_cycle
wire [5:0] f_AABAAAAB_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AABAAAAB_path = {{1{1'b0}}, bw_ABAAAAB_ra} + {{3{1'b0}}, f_AABAAAAB_step};
wire [8:0] f_AABAAAAB_ra = (f_AABAAAAB_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AABAAAAB_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AABAAAAB_cycle = f_AABAAAAB_ra;

// l62_AABAAABA_cycle
wire [5:0] f_AABAAABA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AABAAABA_path = {{1{1'b0}}, bw_ABAAABA_ra} + {{3{1'b0}}, f_AABAAABA_step};
wire [8:0] f_AABAAABA_ra = (f_AABAAABA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AABAAABA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AABAAABA_cycle = f_AABAAABA_ra;

// l53_AABAAABB_cycle
wire [5:0] f_AABAAABB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AABAAABB_path = {{1{1'b0}}, bw_ABAAABB_ra} + {{3{1'b0}}, f_AABAAABB_step};
wire [8:0] f_AABAAABB_ra = (f_AABAAABB_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AABAAABB_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABAAABB_cycle = f_AABAAABB_ra;

// l62_AABAABAA_cycle
wire [5:0] f_AABAABAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AABAABAA_path = {{1{1'b0}}, bw_ABAABAA_ra} + {{3{1'b0}}, f_AABAABAA_step};
wire [8:0] f_AABAABAA_ra = (f_AABAABAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AABAABAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AABAABAA_cycle = f_AABAABAA_ra;

// l53_AABAABAB_cycle
wire [5:0] f_AABAABAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABAABAB_path = bw_ABAABAB_ra + {{2{1'b0}}, f_AABAABAB_step};
wire [7:0] f_AABAABAB_ra = (f_AABAABAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABAABAB_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABAABAB_cycle = {{1{1'b0}}, f_AABAABAB_ra};

// l53_AABAABBA_cycle
wire [5:0] f_AABAABBA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABAABBA_path = bw_ABAABBA_ra + {{2{1'b0}}, f_AABAABBA_step};
wire [7:0] f_AABAABBA_ra = (f_AABAABBA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABAABBA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABAABBA_cycle = {{1{1'b0}}, f_AABAABBA_ra};

// l62_AABABAAA_cycle
wire [5:0] f_AABABAAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AABABAAA_path = {{1{1'b0}}, bw_ABABAAA_ra} + {{3{1'b0}}, f_AABABAAA_step};
wire [8:0] f_AABABAAA_ra = (f_AABABAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AABABAAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AABABAAA_cycle = f_AABABAAA_ra;

// l53_AABABAAB_cycle
wire [5:0] f_AABABAAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABABAAB_path = bw_ABABAAB_ra + {{2{1'b0}}, f_AABABAAB_step};
wire [7:0] f_AABABAAB_ra = (f_AABABAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABABAAB_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABABAAB_cycle = {{1{1'b0}}, f_AABABAAB_ra};

// l53_AABABABA_cycle
wire [5:0] f_AABABABA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABABABA_path = bw_ABABABA_ra + {{2{1'b0}}, f_AABABABA_step};
wire [7:0] f_AABABABA_ra = (f_AABABABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABABABA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABABABA_cycle = {{1{1'b0}}, f_AABABABA_ra};

// l53_AABABBAA_cycle
wire [5:0] f_AABABBAA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABABBAA_path = bw_ABABBAA_ra + {{2{1'b0}}, f_AABABBAA_step};
wire [7:0] f_AABABBAA_ra = (f_AABABBAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABABBAA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABABBAA_cycle = {{1{1'b0}}, f_AABABBAA_ra};

// l62_AABBAAAA_cycle
wire [5:0] f_AABBAAAA_step = A_dependent ? A_rev_lat[5] : 6'd1;
wire [8:0] f_AABBAAAA_path = {{1{1'b0}}, bw_ABBAAAA_ra} + {{3{1'b0}}, f_AABBAAAA_step};
wire [8:0] f_AABBAAAA_ra = (f_AABBAAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? f_AABBAAAA_path : {{3{1'b0}}, A_rev_lat[5]};
wire [8:0] l62_AABBAAAA_cycle = f_AABBAAAA_ra;

// l53_AABBAAAB_cycle
wire [5:0] f_AABBAAAB_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABBAAAB_path = bw_ABBAAAB_ra + {{2{1'b0}}, f_AABBAAAB_step};
wire [7:0] f_AABBAAAB_ra = (f_AABBAAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABBAAAB_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABBAAAB_cycle = {{1{1'b0}}, f_AABBAAAB_ra};

// l53_AABBAABA_cycle
wire [5:0] f_AABBAABA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABBAABA_path = bw_ABBAABA_ra + {{2{1'b0}}, f_AABBAABA_step};
wire [7:0] f_AABBAABA_ra = (f_AABBAABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABBAABA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABBAABA_cycle = {{1{1'b0}}, f_AABBAABA_ra};

// l53_AABBABAA_cycle
wire [5:0] f_AABBABAA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [7:0] f_AABBABAA_path = bw_ABBABAA_ra + {{2{1'b0}}, f_AABBABAA_step};
wire [7:0] f_AABBABAA_ra = (f_AABBABAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? f_AABBABAA_path : {{2{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABBABAA_cycle = {{1{1'b0}}, f_AABBABAA_ra};

// l53_AABBBAAA_cycle
wire [5:0] f_AABBBAAA_step = A_dependent ? A_rev_lat[4] : 6'd1;
wire [8:0] f_AABBBAAA_path = {{1{1'b0}}, bw_ABBBAAA_ra} + {{3{1'b0}}, f_AABBBAAA_step};
wire [8:0] f_AABBBAAA_ra = (f_AABBBAAA_path > {{3{1'b0}}, A_rev_lat[4]}) ? f_AABBBAAA_path : {{3{1'b0}}, A_rev_lat[4]};
wire [8:0] l53_AABBBAAA_cycle = f_AABBBAAA_ra;

// l71_ABAAAAAA_cycle
wire [8:0] f_ABAAAAAA_issue = bw_BAAAAAA_rb + 9'd1;
wire [8:0] f_ABAAAAAA_dep = {{3{1'b0}}, A_rev_lat[6]} + (A_dependent ? bw_BAAAAAA_ra : 9'd0);
wire [8:0] f_ABAAAAAA_ra = (f_ABAAAAAA_issue > f_ABAAAAAA_dep) ? f_ABAAAAAA_issue : f_ABAAAAAA_dep;
wire [8:0] l71_ABAAAAAA_cycle = f_ABAAAAAA_ra;

// l62_ABAAAAAB_cycle
wire [7:0] f_ABAAAAAB_issue = bw_BAAAAAB_rb + 8'd1;
wire [8:0] f_ABAAAAAB_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BAAAAAB_ra} : 9'd0);
wire [8:0] f_ABAAAAAB_ra = ({{1{1'b0}}, f_ABAAAAAB_issue} > f_ABAAAAAB_dep) ? {{1{1'b0}}, f_ABAAAAAB_issue} : f_ABAAAAAB_dep;
wire [8:0] l62_ABAAAAAB_cycle = f_ABAAAAAB_ra;

// l62_ABAAAABA_cycle
wire [7:0] f_ABAAAABA_issue = bw_BAAAABA_rb + 8'd1;
wire [8:0] f_ABAAAABA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BAAAABA_ra} : 9'd0);
wire [8:0] f_ABAAAABA_ra = ({{1{1'b0}}, f_ABAAAABA_issue} > f_ABAAAABA_dep) ? {{1{1'b0}}, f_ABAAAABA_issue} : f_ABAAAABA_dep;
wire [8:0] l62_ABAAAABA_cycle = f_ABAAAABA_ra;

// l53_ABAAAABB_cycle
wire [7:0] f_ABAAAABB_issue = bw_BAAAABB_rb + 8'd1;
wire [8:0] f_ABAAAABB_dep = {{3{1'b0}}, A_rev_lat[4]} + (A_dependent ? {{1{1'b0}}, bw_BAAAABB_ra} : 9'd0);
wire [8:0] f_ABAAAABB_ra = ({{1{1'b0}}, f_ABAAAABB_issue} > f_ABAAAABB_dep) ? {{1{1'b0}}, f_ABAAAABB_issue} : f_ABAAAABB_dep;
wire [8:0] l53_ABAAAABB_cycle = f_ABAAAABB_ra;

// l62_ABAAABAA_cycle
wire [7:0] f_ABAAABAA_issue = bw_BAAABAA_rb + 8'd1;
wire [8:0] f_ABAAABAA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BAAABAA_ra} : 9'd0);
wire [8:0] f_ABAAABAA_ra = ({{1{1'b0}}, f_ABAAABAA_issue} > f_ABAAABAA_dep) ? {{1{1'b0}}, f_ABAAABAA_issue} : f_ABAAABAA_dep;
wire [8:0] l62_ABAAABAA_cycle = f_ABAAABAA_ra;

// l53_ABAAABAB_cycle
wire [7:0] f_ABAAABAB_issue = bw_BAAABAB_rb + 8'd1;
wire [7:0] f_ABAAABAB_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAAABAB_ra : 8'd0);
wire [7:0] f_ABAAABAB_ra = (f_ABAAABAB_issue > f_ABAAABAB_dep) ? f_ABAAABAB_issue : f_ABAAABAB_dep;
wire [8:0] l53_ABAAABAB_cycle = {{1{1'b0}}, f_ABAAABAB_ra};

// l53_ABAAABBA_cycle
wire [7:0] f_ABAAABBA_issue = bw_BAAABBA_rb + 8'd1;
wire [7:0] f_ABAAABBA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAAABBA_ra : 8'd0);
wire [7:0] f_ABAAABBA_ra = (f_ABAAABBA_issue > f_ABAAABBA_dep) ? f_ABAAABBA_issue : f_ABAAABBA_dep;
wire [8:0] l53_ABAAABBA_cycle = {{1{1'b0}}, f_ABAAABBA_ra};

// l62_ABAABAAA_cycle
wire [7:0] f_ABAABAAA_issue = bw_BAABAAA_rb + 8'd1;
wire [8:0] f_ABAABAAA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BAABAAA_ra} : 9'd0);
wire [8:0] f_ABAABAAA_ra = ({{1{1'b0}}, f_ABAABAAA_issue} > f_ABAABAAA_dep) ? {{1{1'b0}}, f_ABAABAAA_issue} : f_ABAABAAA_dep;
wire [8:0] l62_ABAABAAA_cycle = f_ABAABAAA_ra;

// l53_ABAABAAB_cycle
wire [7:0] f_ABAABAAB_issue = bw_BAABAAB_rb + 8'd1;
wire [7:0] f_ABAABAAB_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAABAAB_ra : 8'd0);
wire [7:0] f_ABAABAAB_ra = (f_ABAABAAB_issue > f_ABAABAAB_dep) ? f_ABAABAAB_issue : f_ABAABAAB_dep;
wire [8:0] l53_ABAABAAB_cycle = {{1{1'b0}}, f_ABAABAAB_ra};

// l53_ABAABABA_cycle
wire [7:0] f_ABAABABA_issue = bw_BAABABA_rb + 8'd1;
wire [7:0] f_ABAABABA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAABABA_ra : 8'd0);
wire [7:0] f_ABAABABA_ra = (f_ABAABABA_issue > f_ABAABABA_dep) ? f_ABAABABA_issue : f_ABAABABA_dep;
wire [8:0] l53_ABAABABA_cycle = {{1{1'b0}}, f_ABAABABA_ra};

// l53_ABAABBAA_cycle
wire [7:0] f_ABAABBAA_issue = bw_BAABBAA_rb + 8'd1;
wire [7:0] f_ABAABBAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAABBAA_ra : 8'd0);
wire [7:0] f_ABAABBAA_ra = (f_ABAABBAA_issue > f_ABAABBAA_dep) ? f_ABAABBAA_issue : f_ABAABBAA_dep;
wire [8:0] l53_ABAABBAA_cycle = {{1{1'b0}}, f_ABAABBAA_ra};

// l62_ABABAAAA_cycle
wire [7:0] f_ABABAAAA_issue = bw_BABAAAA_rb + 8'd1;
wire [8:0] f_ABABAAAA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BABAAAA_ra} : 9'd0);
wire [8:0] f_ABABAAAA_ra = ({{1{1'b0}}, f_ABABAAAA_issue} > f_ABABAAAA_dep) ? {{1{1'b0}}, f_ABABAAAA_issue} : f_ABABAAAA_dep;
wire [8:0] l62_ABABAAAA_cycle = f_ABABAAAA_ra;

// l53_ABABAAAB_cycle
wire [7:0] f_ABABAAAB_issue = bw_BABAAAB_rb + 8'd1;
wire [7:0] f_ABABAAAB_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BABAAAB_ra : 8'd0);
wire [7:0] f_ABABAAAB_ra = (f_ABABAAAB_issue > f_ABABAAAB_dep) ? f_ABABAAAB_issue : f_ABABAAAB_dep;
wire [8:0] l53_ABABAAAB_cycle = {{1{1'b0}}, f_ABABAAAB_ra};

// l53_ABABAABA_cycle
wire [7:0] f_ABABAABA_issue = bw_BABAABA_rb + 8'd1;
wire [7:0] f_ABABAABA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BABAABA_ra : 8'd0);
wire [7:0] f_ABABAABA_ra = (f_ABABAABA_issue > f_ABABAABA_dep) ? f_ABABAABA_issue : f_ABABAABA_dep;
wire [8:0] l53_ABABAABA_cycle = {{1{1'b0}}, f_ABABAABA_ra};

// l53_ABABABAA_cycle
wire [7:0] f_ABABABAA_issue = bw_BABABAA_rb + 8'd1;
wire [7:0] f_ABABABAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BABABAA_ra : 8'd0);
wire [7:0] f_ABABABAA_ra = (f_ABABABAA_issue > f_ABABABAA_dep) ? f_ABABABAA_issue : f_ABABABAA_dep;
wire [8:0] l53_ABABABAA_cycle = {{1{1'b0}}, f_ABABABAA_ra};

// l53_ABABBAAA_cycle
wire [7:0] f_ABABBAAA_issue = bw_BABBAAA_rb + 8'd1;
wire [7:0] f_ABABBAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BABBAAA_ra : 8'd0);
wire [7:0] f_ABABBAAA_ra = (f_ABABBAAA_issue > f_ABABBAAA_dep) ? f_ABABBAAA_issue : f_ABABBAAA_dep;
wire [8:0] l53_ABABBAAA_cycle = {{1{1'b0}}, f_ABABBAAA_ra};

// l62_ABBAAAAA_cycle
wire [8:0] f_ABBAAAAA_issue = bw_BBAAAAA_rb + 9'd1;
wire [8:0] f_ABBAAAAA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BBAAAAA_ra} : 9'd0);
wire [8:0] f_ABBAAAAA_ra = (f_ABBAAAAA_issue > f_ABBAAAAA_dep) ? f_ABBAAAAA_issue : f_ABBAAAAA_dep;
wire [8:0] l62_ABBAAAAA_cycle = f_ABBAAAAA_ra;

// l53_ABBAAAAB_cycle
wire [7:0] f_ABBAAAAB_issue = bw_BBAAAAB_rb + 8'd1;
wire [7:0] f_ABBAAAAB_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBAAAAB_ra : 8'd0);
wire [7:0] f_ABBAAAAB_ra = (f_ABBAAAAB_issue > f_ABBAAAAB_dep) ? f_ABBAAAAB_issue : f_ABBAAAAB_dep;
wire [8:0] l53_ABBAAAAB_cycle = {{1{1'b0}}, f_ABBAAAAB_ra};

// l53_ABBAAABA_cycle
wire [7:0] f_ABBAAABA_issue = bw_BBAAABA_rb + 8'd1;
wire [7:0] f_ABBAAABA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBAAABA_ra : 8'd0);
wire [7:0] f_ABBAAABA_ra = (f_ABBAAABA_issue > f_ABBAAABA_dep) ? f_ABBAAABA_issue : f_ABBAAABA_dep;
wire [8:0] l53_ABBAAABA_cycle = {{1{1'b0}}, f_ABBAAABA_ra};

// l53_ABBAABAA_cycle
wire [7:0] f_ABBAABAA_issue = bw_BBAABAA_rb + 8'd1;
wire [7:0] f_ABBAABAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBAABAA_ra : 8'd0);
wire [7:0] f_ABBAABAA_ra = (f_ABBAABAA_issue > f_ABBAABAA_dep) ? f_ABBAABAA_issue : f_ABBAABAA_dep;
wire [8:0] l53_ABBAABAA_cycle = {{1{1'b0}}, f_ABBAABAA_ra};

// l53_ABBABAAA_cycle
wire [7:0] f_ABBABAAA_issue = bw_BBABAAA_rb + 8'd1;
wire [7:0] f_ABBABAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBABAAA_ra : 8'd0);
wire [7:0] f_ABBABAAA_ra = (f_ABBABAAA_issue > f_ABBABAAA_dep) ? f_ABBABAAA_issue : f_ABBABAAA_dep;
wire [8:0] l53_ABBABAAA_cycle = {{1{1'b0}}, f_ABBABAAA_ra};

// l53_ABBBAAAA_cycle
wire [8:0] f_ABBBAAAA_issue = bw_BBBAAAA_rb + 9'd1;
wire [7:0] f_ABBBAAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBBAAAA_ra : 8'd0);
wire [8:0] f_ABBBAAAA_ra = (f_ABBBAAAA_issue > {{1{1'b0}}, f_ABBBAAAA_dep}) ? f_ABBBAAAA_issue : {{1{1'b0}}, f_ABBBAAAA_dep};
wire [8:0] l53_ABBBAAAA_cycle = f_ABBBAAAA_ra;

// l71_BAAAAAAA_cycle
wire [8:0] f_BAAAAAAA_issue = bw_AAAAAAA_ra + 9'd1;
wire [5:0] f_BAAAAAAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AAAAAAA_rb} : 6'd0);
wire [8:0] f_BAAAAAAA_rb = (f_BAAAAAAA_issue > {{3{1'b0}}, f_BAAAAAAA_dep}) ? f_BAAAAAAA_issue : {{3{1'b0}}, f_BAAAAAAA_dep};
wire [8:0] l71_BAAAAAAA_cycle = f_BAAAAAAA_rb;

// l62_BAAAAAAB_cycle
wire [8:0] f_BAAAAAAB_issue = bw_AAAAAAB_ra + 9'd1;
wire [6:0] f_BAAAAAAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAAAAB_rb} : 7'd0);
wire [8:0] f_BAAAAAAB_rb = (f_BAAAAAAB_issue > {{2{1'b0}}, f_BAAAAAAB_dep}) ? f_BAAAAAAB_issue : {{2{1'b0}}, f_BAAAAAAB_dep};
wire [8:0] l62_BAAAAAAB_cycle = f_BAAAAAAB_rb;

// l62_BAAAAABA_cycle
wire [8:0] f_BAAAAABA_issue = bw_AAAAABA_ra + 9'd1;
wire [6:0] f_BAAAAABA_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAAABA_rb} : 7'd0);
wire [8:0] f_BAAAAABA_rb = (f_BAAAAABA_issue > {{2{1'b0}}, f_BAAAAABA_dep}) ? f_BAAAAABA_issue : {{2{1'b0}}, f_BAAAAABA_dep};
wire [8:0] l62_BAAAAABA_cycle = f_BAAAAABA_rb;

// l53_BAAAAABB_cycle
wire [8:0] f_BAAAAABB_issue = bw_AAAAABB_ra + 9'd1;
wire [7:0] f_BAAAAABB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAAAABB_rb} : 8'd0);
wire [8:0] f_BAAAAABB_rb = (f_BAAAAABB_issue > {{1{1'b0}}, f_BAAAAABB_dep}) ? f_BAAAAABB_issue : {{1{1'b0}}, f_BAAAAABB_dep};
wire [8:0] l53_BAAAAABB_cycle = f_BAAAAABB_rb;

// l62_BAAAABAA_cycle
wire [8:0] f_BAAAABAA_issue = bw_AAAABAA_ra + 9'd1;
wire [7:0] f_BAAAABAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAABAA_rb} : 8'd0);
wire [8:0] f_BAAAABAA_rb = (f_BAAAABAA_issue > {{1{1'b0}}, f_BAAAABAA_dep}) ? f_BAAAABAA_issue : {{1{1'b0}}, f_BAAAABAA_dep};
wire [8:0] l62_BAAAABAA_cycle = f_BAAAABAA_rb;

// l53_BAAAABAB_cycle
wire [7:0] f_BAAAABAB_issue = bw_AAAABAB_ra + 8'd1;
wire [7:0] f_BAAAABAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAAABAB_rb} : 8'd0);
wire [7:0] f_BAAAABAB_rb = (f_BAAAABAB_issue > f_BAAAABAB_dep) ? f_BAAAABAB_issue : f_BAAAABAB_dep;
wire [8:0] l53_BAAAABAB_cycle = {{1{1'b0}}, f_BAAAABAB_rb};

// l53_BAAAABBA_cycle
wire [7:0] f_BAAAABBA_issue = bw_AAAABBA_ra + 8'd1;
wire [7:0] f_BAAAABBA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAAABBA_rb} : 8'd0);
wire [7:0] f_BAAAABBA_rb = (f_BAAAABBA_issue > f_BAAAABBA_dep) ? f_BAAAABBA_issue : f_BAAAABBA_dep;
wire [8:0] l53_BAAAABBA_cycle = {{1{1'b0}}, f_BAAAABBA_rb};

// l44_BAAAABBB_cycle
wire [8:0] f_BAAAABBB_issue = bw_AAAABBB_ra + 9'd1;
wire [7:0] f_BAAAABBB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AAAABBB_rb : 8'd0);
wire [8:0] f_BAAAABBB_rb = (f_BAAAABBB_issue > {{1{1'b0}}, f_BAAAABBB_dep}) ? f_BAAAABBB_issue : {{1{1'b0}}, f_BAAAABBB_dep};
wire [8:0] l44_BAAAABBB_cycle = f_BAAAABBB_rb;

// l62_BAAABAAA_cycle
wire [8:0] f_BAAABAAA_issue = bw_AAABAAA_ra + 9'd1;
wire [7:0] f_BAAABAAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? bw_AAABAAA_rb : 8'd0);
wire [8:0] f_BAAABAAA_rb = (f_BAAABAAA_issue > {{1{1'b0}}, f_BAAABAAA_dep}) ? f_BAAABAAA_issue : {{1{1'b0}}, f_BAAABAAA_dep};
wire [8:0] l62_BAAABAAA_cycle = f_BAAABAAA_rb;

// l53_BAAABAAB_cycle
wire [7:0] f_BAAABAAB_issue = bw_AAABAAB_ra + 8'd1;
wire [7:0] f_BAAABAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAABAAB_rb} : 8'd0);
wire [7:0] f_BAAABAAB_rb = (f_BAAABAAB_issue > f_BAAABAAB_dep) ? f_BAAABAAB_issue : f_BAAABAAB_dep;
wire [8:0] l53_BAAABAAB_cycle = {{1{1'b0}}, f_BAAABAAB_rb};

// l53_BAAABABA_cycle
wire [7:0] f_BAAABABA_issue = bw_AAABABA_ra + 8'd1;
wire [7:0] f_BAAABABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAABABA_rb} : 8'd0);
wire [7:0] f_BAAABABA_rb = (f_BAAABABA_issue > f_BAAABABA_dep) ? f_BAAABABA_issue : f_BAAABABA_dep;
wire [8:0] l53_BAAABABA_cycle = {{1{1'b0}}, f_BAAABABA_rb};

// l44_BAAABABB_cycle
wire [7:0] f_BAAABABB_issue = bw_AAABABB_ra + 8'd1;
wire [7:0] f_BAAABABB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AAABABB_rb : 8'd0);
wire [7:0] f_BAAABABB_rb = (f_BAAABABB_issue > f_BAAABABB_dep) ? f_BAAABABB_issue : f_BAAABABB_dep;
wire [8:0] l44_BAAABABB_cycle = {{1{1'b0}}, f_BAAABABB_rb};

// l53_BAAABBAA_cycle
wire [7:0] f_BAAABBAA_issue = bw_AAABBAA_ra + 8'd1;
wire [7:0] f_BAAABBAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AAABBAA_rb : 8'd0);
wire [7:0] f_BAAABBAA_rb = (f_BAAABBAA_issue > f_BAAABBAA_dep) ? f_BAAABBAA_issue : f_BAAABBAA_dep;
wire [8:0] l53_BAAABBAA_cycle = {{1{1'b0}}, f_BAAABBAA_rb};

// l44_BAAABBAB_cycle
wire [7:0] f_BAAABBAB_issue = bw_AAABBAB_ra + 8'd1;
wire [7:0] f_BAAABBAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AAABBAB_rb : 8'd0);
wire [7:0] f_BAAABBAB_rb = (f_BAAABBAB_issue > f_BAAABBAB_dep) ? f_BAAABBAB_issue : f_BAAABBAB_dep;
wire [8:0] l44_BAAABBAB_cycle = {{1{1'b0}}, f_BAAABBAB_rb};

// l44_BAAABBBA_cycle
wire [7:0] f_BAAABBBA_issue = bw_AAABBBA_ra + 8'd1;
wire [7:0] f_BAAABBBA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AAABBBA_rb : 8'd0);
wire [7:0] f_BAAABBBA_rb = (f_BAAABBBA_issue > f_BAAABBBA_dep) ? f_BAAABBBA_issue : f_BAAABBBA_dep;
wire [8:0] l44_BAAABBBA_cycle = {{1{1'b0}}, f_BAAABBBA_rb};

// l62_BAABAAAA_cycle
wire [8:0] f_BAABAAAA_issue = bw_AABAAAA_ra + 9'd1;
wire [7:0] f_BAABAAAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? bw_AABAAAA_rb : 8'd0);
wire [8:0] f_BAABAAAA_rb = (f_BAABAAAA_issue > {{1{1'b0}}, f_BAABAAAA_dep}) ? f_BAABAAAA_issue : {{1{1'b0}}, f_BAABAAAA_dep};
wire [8:0] l62_BAABAAAA_cycle = f_BAABAAAA_rb;

// l53_BAABAAAB_cycle
wire [7:0] f_BAABAAAB_issue = bw_AABAAAB_ra + 8'd1;
wire [7:0] f_BAABAAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AABAAAB_rb : 8'd0);
wire [7:0] f_BAABAAAB_rb = (f_BAABAAAB_issue > f_BAABAAAB_dep) ? f_BAABAAAB_issue : f_BAABAAAB_dep;
wire [8:0] l53_BAABAAAB_cycle = {{1{1'b0}}, f_BAABAAAB_rb};

// l53_BAABAABA_cycle
wire [7:0] f_BAABAABA_issue = bw_AABAABA_ra + 8'd1;
wire [7:0] f_BAABAABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AABAABA_rb : 8'd0);
wire [7:0] f_BAABAABA_rb = (f_BAABAABA_issue > f_BAABAABA_dep) ? f_BAABAABA_issue : f_BAABAABA_dep;
wire [8:0] l53_BAABAABA_cycle = {{1{1'b0}}, f_BAABAABA_rb};

// l44_BAABAABB_cycle
wire [7:0] f_BAABAABB_issue = bw_AABAABB_ra + 8'd1;
wire [7:0] f_BAABAABB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABAABB_rb : 8'd0);
wire [7:0] f_BAABAABB_rb = (f_BAABAABB_issue > f_BAABAABB_dep) ? f_BAABAABB_issue : f_BAABAABB_dep;
wire [8:0] l44_BAABAABB_cycle = {{1{1'b0}}, f_BAABAABB_rb};

// l53_BAABABAA_cycle
wire [7:0] f_BAABABAA_issue = bw_AABABAA_ra + 8'd1;
wire [7:0] f_BAABABAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AABABAA_rb : 8'd0);
wire [7:0] f_BAABABAA_rb = (f_BAABABAA_issue > f_BAABABAA_dep) ? f_BAABABAA_issue : f_BAABABAA_dep;
wire [8:0] l53_BAABABAA_cycle = {{1{1'b0}}, f_BAABABAA_rb};

// l44_BAABABAB_cycle
wire [7:0] f_BAABABAB_issue = bw_AABABAB_ra + 8'd1;
wire [7:0] f_BAABABAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABABAB_rb : 8'd0);
wire [7:0] f_BAABABAB_rb = (f_BAABABAB_issue > f_BAABABAB_dep) ? f_BAABABAB_issue : f_BAABABAB_dep;
wire [8:0] l44_BAABABAB_cycle = {{1{1'b0}}, f_BAABABAB_rb};

// l44_BAABABBA_cycle
wire [7:0] f_BAABABBA_issue = bw_AABABBA_ra + 8'd1;
wire [7:0] f_BAABABBA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABABBA_rb : 8'd0);
wire [7:0] f_BAABABBA_rb = (f_BAABABBA_issue > f_BAABABBA_dep) ? f_BAABABBA_issue : f_BAABABBA_dep;
wire [8:0] l44_BAABABBA_cycle = {{1{1'b0}}, f_BAABABBA_rb};

// l53_BAABBAAA_cycle
wire [7:0] f_BAABBAAA_issue = bw_AABBAAA_ra + 8'd1;
wire [7:0] f_BAABBAAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AABBAAA_rb : 8'd0);
wire [7:0] f_BAABBAAA_rb = (f_BAABBAAA_issue > f_BAABBAAA_dep) ? f_BAABBAAA_issue : f_BAABBAAA_dep;
wire [8:0] l53_BAABBAAA_cycle = {{1{1'b0}}, f_BAABBAAA_rb};

// l44_BAABBAAB_cycle
wire [7:0] f_BAABBAAB_issue = bw_AABBAAB_ra + 8'd1;
wire [7:0] f_BAABBAAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBAAB_rb : 8'd0);
wire [7:0] f_BAABBAAB_rb = (f_BAABBAAB_issue > f_BAABBAAB_dep) ? f_BAABBAAB_issue : f_BAABBAAB_dep;
wire [8:0] l44_BAABBAAB_cycle = {{1{1'b0}}, f_BAABBAAB_rb};

// l44_BAABBABA_cycle
wire [7:0] f_BAABBABA_issue = bw_AABBABA_ra + 8'd1;
wire [7:0] f_BAABBABA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBABA_rb : 8'd0);
wire [7:0] f_BAABBABA_rb = (f_BAABBABA_issue > f_BAABBABA_dep) ? f_BAABBABA_issue : f_BAABBABA_dep;
wire [8:0] l44_BAABBABA_cycle = {{1{1'b0}}, f_BAABBABA_rb};

// l44_BAABBBAA_cycle
wire [7:0] f_BAABBBAA_issue = bw_AABBBAA_ra + 8'd1;
wire [7:0] f_BAABBBAA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_AABBBAA_rb : 8'd0);
wire [7:0] f_BAABBBAA_rb = (f_BAABBBAA_issue > f_BAABBBAA_dep) ? f_BAABBBAA_issue : f_BAABBBAA_dep;
wire [8:0] l44_BAABBBAA_cycle = {{1{1'b0}}, f_BAABBBAA_rb};

// l62_BABAAAAA_cycle
wire [8:0] f_BABAAAAA_issue = bw_ABAAAAA_ra + 9'd1;
wire [8:0] f_BABAAAAA_dep = {{3{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_ABAAAAA_rb} : 9'd0);
wire [8:0] f_BABAAAAA_rb = (f_BABAAAAA_issue > f_BABAAAAA_dep) ? f_BABAAAAA_issue : f_BABAAAAA_dep;
wire [8:0] l62_BABAAAAA_cycle = f_BABAAAAA_rb;

// l53_BABAAAAB_cycle
wire [7:0] f_BABAAAAB_issue = bw_ABAAAAB_ra + 8'd1;
wire [7:0] f_BABAAAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABAAAAB_rb : 8'd0);
wire [7:0] f_BABAAAAB_rb = (f_BABAAAAB_issue > f_BABAAAAB_dep) ? f_BABAAAAB_issue : f_BABAAAAB_dep;
wire [8:0] l53_BABAAAAB_cycle = {{1{1'b0}}, f_BABAAAAB_rb};

// l53_BABAAABA_cycle
wire [7:0] f_BABAAABA_issue = bw_ABAAABA_ra + 8'd1;
wire [7:0] f_BABAAABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABAAABA_rb : 8'd0);
wire [7:0] f_BABAAABA_rb = (f_BABAAABA_issue > f_BABAAABA_dep) ? f_BABAAABA_issue : f_BABAAABA_dep;
wire [8:0] l53_BABAAABA_cycle = {{1{1'b0}}, f_BABAAABA_rb};

// l44_BABAAABB_cycle
wire [7:0] f_BABAAABB_issue = bw_ABAAABB_ra + 8'd1;
wire [7:0] f_BABAAABB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABAAABB_rb : 8'd0);
wire [7:0] f_BABAAABB_rb = (f_BABAAABB_issue > f_BABAAABB_dep) ? f_BABAAABB_issue : f_BABAAABB_dep;
wire [8:0] l44_BABAAABB_cycle = {{1{1'b0}}, f_BABAAABB_rb};

// l53_BABAABAA_cycle
wire [7:0] f_BABAABAA_issue = bw_ABAABAA_ra + 8'd1;
wire [7:0] f_BABAABAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABAABAA_rb : 8'd0);
wire [7:0] f_BABAABAA_rb = (f_BABAABAA_issue > f_BABAABAA_dep) ? f_BABAABAA_issue : f_BABAABAA_dep;
wire [8:0] l53_BABAABAA_cycle = {{1{1'b0}}, f_BABAABAA_rb};

// l44_BABAABAB_cycle
wire [7:0] f_BABAABAB_issue = bw_ABAABAB_ra + 8'd1;
wire [7:0] f_BABAABAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABAABAB_rb : 8'd0);
wire [7:0] f_BABAABAB_rb = (f_BABAABAB_issue > f_BABAABAB_dep) ? f_BABAABAB_issue : f_BABAABAB_dep;
wire [8:0] l44_BABAABAB_cycle = {{1{1'b0}}, f_BABAABAB_rb};

// l44_BABAABBA_cycle
wire [7:0] f_BABAABBA_issue = bw_ABAABBA_ra + 8'd1;
wire [7:0] f_BABAABBA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABAABBA_rb : 8'd0);
wire [7:0] f_BABAABBA_rb = (f_BABAABBA_issue > f_BABAABBA_dep) ? f_BABAABBA_issue : f_BABAABBA_dep;
wire [8:0] l44_BABAABBA_cycle = {{1{1'b0}}, f_BABAABBA_rb};

// l53_BABABAAA_cycle
wire [7:0] f_BABABAAA_issue = bw_ABABAAA_ra + 8'd1;
wire [7:0] f_BABABAAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABABAAA_rb : 8'd0);
wire [7:0] f_BABABAAA_rb = (f_BABABAAA_issue > f_BABABAAA_dep) ? f_BABABAAA_issue : f_BABABAAA_dep;
wire [8:0] l53_BABABAAA_cycle = {{1{1'b0}}, f_BABABAAA_rb};

// l44_BABABAAB_cycle
wire [7:0] f_BABABAAB_issue = bw_ABABAAB_ra + 8'd1;
wire [7:0] f_BABABAAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABAAB_rb : 8'd0);
wire [7:0] f_BABABAAB_rb = (f_BABABAAB_issue > f_BABABAAB_dep) ? f_BABABAAB_issue : f_BABABAAB_dep;
wire [8:0] l44_BABABAAB_cycle = {{1{1'b0}}, f_BABABAAB_rb};

// l44_BABABABA_cycle
wire [7:0] f_BABABABA_issue = bw_ABABABA_ra + 8'd1;
wire [7:0] f_BABABABA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABABA_rb : 8'd0);
wire [7:0] f_BABABABA_rb = (f_BABABABA_issue > f_BABABABA_dep) ? f_BABABABA_issue : f_BABABABA_dep;
wire [8:0] l44_BABABABA_cycle = {{1{1'b0}}, f_BABABABA_rb};

// l44_BABABBAA_cycle
wire [7:0] f_BABABBAA_issue = bw_ABABBAA_ra + 8'd1;
wire [7:0] f_BABABBAA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABABBAA_rb : 8'd0);
wire [7:0] f_BABABBAA_rb = (f_BABABBAA_issue > f_BABABBAA_dep) ? f_BABABBAA_issue : f_BABABBAA_dep;
wire [8:0] l44_BABABBAA_cycle = {{1{1'b0}}, f_BABABBAA_rb};

// l53_BABBAAAA_cycle
wire [7:0] f_BABBAAAA_issue = bw_ABBAAAA_ra + 8'd1;
wire [8:0] f_BABBAAAA_dep = {{3{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABBAAAA_rb} : 9'd0);
wire [8:0] f_BABBAAAA_rb = ({{1{1'b0}}, f_BABBAAAA_issue} > f_BABBAAAA_dep) ? {{1{1'b0}}, f_BABBAAAA_issue} : f_BABBAAAA_dep;
wire [8:0] l53_BABBAAAA_cycle = f_BABBAAAA_rb;

// l44_BABBAAAB_cycle
wire [7:0] f_BABBAAAB_issue = bw_ABBAAAB_ra + 8'd1;
wire [7:0] f_BABBAAAB_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBAAAB_rb : 8'd0);
wire [7:0] f_BABBAAAB_rb = (f_BABBAAAB_issue > f_BABBAAAB_dep) ? f_BABBAAAB_issue : f_BABBAAAB_dep;
wire [8:0] l44_BABBAAAB_cycle = {{1{1'b0}}, f_BABBAAAB_rb};

// l44_BABBAABA_cycle
wire [7:0] f_BABBAABA_issue = bw_ABBAABA_ra + 8'd1;
wire [7:0] f_BABBAABA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBAABA_rb : 8'd0);
wire [7:0] f_BABBAABA_rb = (f_BABBAABA_issue > f_BABBAABA_dep) ? f_BABBAABA_issue : f_BABBAABA_dep;
wire [8:0] l44_BABBAABA_cycle = {{1{1'b0}}, f_BABBAABA_rb};

// l44_BABBABAA_cycle
wire [7:0] f_BABBABAA_issue = bw_ABBABAA_ra + 8'd1;
wire [7:0] f_BABBABAA_dep = {{2{1'b0}}, B_rev_lat[3]} + (B_dependent ? bw_ABBABAA_rb : 8'd0);
wire [7:0] f_BABBABAA_rb = (f_BABBABAA_issue > f_BABBABAA_dep) ? f_BABBABAA_issue : f_BABBABAA_dep;
wire [8:0] l44_BABBABAA_cycle = {{1{1'b0}}, f_BABBABAA_rb};

// l44_BABBBAAA_cycle
wire [7:0] f_BABBBAAA_issue = bw_ABBBAAA_ra + 8'd1;
wire [8:0] f_BABBBAAA_dep = {{3{1'b0}}, B_rev_lat[3]} + (B_dependent ? {{1{1'b0}}, bw_ABBBAAA_rb} : 9'd0);
wire [8:0] f_BABBBAAA_rb = ({{1{1'b0}}, f_BABBBAAA_issue} > f_BABBBAAA_dep) ? {{1{1'b0}}, f_BABBBAAA_issue} : f_BABBBAAA_dep;
wire [8:0] l44_BABBBAAA_cycle = f_BABBBAAA_rb;

// l62_BBAAAAAA_cycle
wire [5:0] f_BBAAAAAA_step = B_dependent ? B_rev_lat[1] : 6'd1;
wire [8:0] f_BBAAAAAA_path = bw_BAAAAAA_rb + {{3{1'b0}}, f_BBAAAAAA_step};
wire [8:0] f_BBAAAAAA_rb = (f_BBAAAAAA_path > {{3{1'b0}}, B_rev_lat[1]}) ? f_BBAAAAAA_path : {{3{1'b0}}, B_rev_lat[1]};
wire [8:0] l62_BBAAAAAA_cycle = f_BBAAAAAA_rb;

// l53_BBAAAAAB_cycle
wire [5:0] f_BBAAAAAB_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBAAAAAB_path = {{1{1'b0}}, bw_BAAAAAB_rb} + {{3{1'b0}}, f_BBAAAAAB_step};
wire [8:0] f_BBAAAAAB_rb = (f_BBAAAAAB_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBAAAAAB_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBAAAAAB_cycle = f_BBAAAAAB_rb;

// l53_BBAAAABA_cycle
wire [5:0] f_BBAAAABA_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBAAAABA_path = {{1{1'b0}}, bw_BAAAABA_rb} + {{3{1'b0}}, f_BBAAAABA_step};
wire [8:0] f_BBAAAABA_rb = (f_BBAAAABA_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBAAAABA_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBAAAABA_cycle = f_BBAAAABA_rb;

// l44_BBAAAABB_cycle
wire [5:0] f_BBAAAABB_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBAAAABB_path = {{1{1'b0}}, bw_BAAAABB_rb} + {{3{1'b0}}, f_BBAAAABB_step};
wire [8:0] f_BBAAAABB_rb = (f_BBAAAABB_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBAAAABB_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAAAABB_cycle = f_BBAAAABB_rb;

// l53_BBAAABAA_cycle
wire [5:0] f_BBAAABAA_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBAAABAA_path = {{1{1'b0}}, bw_BAAABAA_rb} + {{3{1'b0}}, f_BBAAABAA_step};
wire [8:0] f_BBAAABAA_rb = (f_BBAAABAA_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBAAABAA_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBAAABAA_cycle = f_BBAAABAA_rb;

// l44_BBAAABAB_cycle
wire [5:0] f_BBAAABAB_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBAAABAB_path = bw_BAAABAB_rb + {{2{1'b0}}, f_BBAAABAB_step};
wire [7:0] f_BBAAABAB_rb = (f_BBAAABAB_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBAAABAB_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAAABAB_cycle = {{1{1'b0}}, f_BBAAABAB_rb};

// l44_BBAAABBA_cycle
wire [5:0] f_BBAAABBA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBAAABBA_path = bw_BAAABBA_rb + {{2{1'b0}}, f_BBAAABBA_step};
wire [7:0] f_BBAAABBA_rb = (f_BBAAABBA_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBAAABBA_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAAABBA_cycle = {{1{1'b0}}, f_BBAAABBA_rb};

// l53_BBAABAAA_cycle
wire [5:0] f_BBAABAAA_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBAABAAA_path = {{1{1'b0}}, bw_BAABAAA_rb} + {{3{1'b0}}, f_BBAABAAA_step};
wire [8:0] f_BBAABAAA_rb = (f_BBAABAAA_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBAABAAA_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBAABAAA_cycle = f_BBAABAAA_rb;

// l44_BBAABAAB_cycle
wire [5:0] f_BBAABAAB_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBAABAAB_path = bw_BAABAAB_rb + {{2{1'b0}}, f_BBAABAAB_step};
wire [7:0] f_BBAABAAB_rb = (f_BBAABAAB_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBAABAAB_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAABAAB_cycle = {{1{1'b0}}, f_BBAABAAB_rb};

// l44_BBAABABA_cycle
wire [5:0] f_BBAABABA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBAABABA_path = bw_BAABABA_rb + {{2{1'b0}}, f_BBAABABA_step};
wire [7:0] f_BBAABABA_rb = (f_BBAABABA_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBAABABA_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAABABA_cycle = {{1{1'b0}}, f_BBAABABA_rb};

// l44_BBAABBAA_cycle
wire [5:0] f_BBAABBAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBAABBAA_path = bw_BAABBAA_rb + {{2{1'b0}}, f_BBAABBAA_step};
wire [7:0] f_BBAABBAA_rb = (f_BBAABBAA_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBAABBAA_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBAABBAA_cycle = {{1{1'b0}}, f_BBAABBAA_rb};

// l53_BBABAAAA_cycle
wire [5:0] f_BBABAAAA_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBABAAAA_path = {{1{1'b0}}, bw_BABAAAA_rb} + {{3{1'b0}}, f_BBABAAAA_step};
wire [8:0] f_BBABAAAA_rb = (f_BBABAAAA_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBABAAAA_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBABAAAA_cycle = f_BBABAAAA_rb;

// l44_BBABAAAB_cycle
wire [5:0] f_BBABAAAB_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBABAAAB_path = bw_BABAAAB_rb + {{2{1'b0}}, f_BBABAAAB_step};
wire [7:0] f_BBABAAAB_rb = (f_BBABAAAB_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBABAAAB_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBABAAAB_cycle = {{1{1'b0}}, f_BBABAAAB_rb};

// l44_BBABAABA_cycle
wire [5:0] f_BBABAABA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBABAABA_path = bw_BABAABA_rb + {{2{1'b0}}, f_BBABAABA_step};
wire [7:0] f_BBABAABA_rb = (f_BBABAABA_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBABAABA_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBABAABA_cycle = {{1{1'b0}}, f_BBABAABA_rb};

// l44_BBABABAA_cycle
wire [5:0] f_BBABABAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [7:0] f_BBABABAA_path = bw_BABABAA_rb + {{2{1'b0}}, f_BBABABAA_step};
wire [7:0] f_BBABABAA_rb = (f_BBABABAA_path > {{2{1'b0}}, B_rev_lat[3]}) ? f_BBABABAA_path : {{2{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBABABAA_cycle = {{1{1'b0}}, f_BBABABAA_rb};

// l44_BBABBAAA_cycle
wire [5:0] f_BBABBAAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBABBAAA_path = {{1{1'b0}}, bw_BABBAAA_rb} + {{3{1'b0}}, f_BBABBAAA_step};
wire [8:0] f_BBABBAAA_rb = (f_BBABBAAA_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBABBAAA_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBABBAAA_cycle = f_BBABBAAA_rb;

// l53_BBBAAAAA_cycle
wire [5:0] f_BBBAAAAA_step = B_dependent ? B_rev_lat[2] : 6'd1;
wire [8:0] f_BBBAAAAA_path = bw_BBAAAAA_rb + {{3{1'b0}}, f_BBBAAAAA_step};
wire [8:0] f_BBBAAAAA_rb = (f_BBBAAAAA_path > {{3{1'b0}}, B_rev_lat[2]}) ? f_BBBAAAAA_path : {{3{1'b0}}, B_rev_lat[2]};
wire [8:0] l53_BBBAAAAA_cycle = f_BBBAAAAA_rb;

// l44_BBBAAAAB_cycle
wire [5:0] f_BBBAAAAB_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBBAAAAB_path = {{1{1'b0}}, bw_BBAAAAB_rb} + {{3{1'b0}}, f_BBBAAAAB_step};
wire [8:0] f_BBBAAAAB_rb = (f_BBBAAAAB_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBBAAAAB_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBBAAAAB_cycle = f_BBBAAAAB_rb;

// l44_BBBAAABA_cycle
wire [5:0] f_BBBAAABA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBBAAABA_path = {{1{1'b0}}, bw_BBAAABA_rb} + {{3{1'b0}}, f_BBBAAABA_step};
wire [8:0] f_BBBAAABA_rb = (f_BBBAAABA_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBBAAABA_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBBAAABA_cycle = f_BBBAAABA_rb;

// l44_BBBAABAA_cycle
wire [5:0] f_BBBAABAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBBAABAA_path = {{1{1'b0}}, bw_BBAABAA_rb} + {{3{1'b0}}, f_BBBAABAA_step};
wire [8:0] f_BBBAABAA_rb = (f_BBBAABAA_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBBAABAA_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBBAABAA_cycle = f_BBBAABAA_rb;

// l44_BBBABAAA_cycle
wire [5:0] f_BBBABAAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBBABAAA_path = {{1{1'b0}}, bw_BBABAAA_rb} + {{3{1'b0}}, f_BBBABAAA_step};
wire [8:0] f_BBBABAAA_rb = (f_BBBABAAA_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBBABAAA_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBBABAAA_cycle = f_BBBABAAA_rb;

// l44_BBBBAAAA_cycle
wire [5:0] f_BBBBAAAA_step = B_dependent ? B_rev_lat[3] : 6'd1;
wire [8:0] f_BBBBAAAA_path = bw_BBBAAAA_rb + {{3{1'b0}}, f_BBBBAAAA_step};
wire [8:0] f_BBBBAAAA_rb = (f_BBBBAAAA_path > {{3{1'b0}}, B_rev_lat[3]}) ? f_BBBBAAAA_path : {{3{1'b0}}, B_rev_lat[3]};
wire [8:0] l44_BBBBAAAA_cycle = f_BBBBAAAA_rb;

