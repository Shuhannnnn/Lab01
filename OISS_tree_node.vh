// Backward suffix tree for OISS scheduling.
// Each node keeps RA/RB: longest distance from the first A/B in this suffix to final completion.
// Paths are written in forward issue order, while construction prepends instructions from right to left.

//////// BACKWARD DEPTH 1 ////////
// bw_A
wire [5:0] bw_A_ra;
wire [0:0] bw_A_rb;
assign bw_A_ra = A_rev_lat[0];
assign bw_A_rb = 1'b0;

// bw_B
wire [0:0] bw_B_ra;
wire [5:0] bw_B_rb;
assign bw_B_ra = 1'b0;
assign bw_B_rb = B_rev_lat[0];


//////// BACKWARD DEPTH 2 ////////
// bw_AA
wire [6:0] bw_AA_ra;
wire [0:0] bw_AA_rb;
wire [6:0] bw_AA_path = {{1{1'b0}}, bw_A_ra} + {{1{1'b0}}, A_bw_step_1};
assign bw_AA_ra = (bw_AA_path > {{1{1'b0}}, A_rev_lat[1]}) ? bw_AA_path : {{1{1'b0}}, A_rev_lat[1]};
assign bw_AA_rb = bw_A_rb;

// bw_AB
wire [5:0] bw_AB_ra;
wire [5:0] bw_AB_rb;
wire [5:0] bw_AB_issue = bw_B_rb + 6'd1;
wire [5:0] bw_AB_dep = A_rev_lat[0] + (A_dependent ? {{5{1'b0}}, bw_B_ra} : 6'd0);
assign bw_AB_ra = (bw_AB_issue > bw_AB_dep) ? bw_AB_issue : bw_AB_dep;
assign bw_AB_rb = bw_B_rb;

// bw_BA
wire [5:0] bw_BA_ra;
wire [5:0] bw_BA_rb;
wire [5:0] bw_BA_issue = bw_A_ra + 6'd1;
wire [5:0] bw_BA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_A_rb} : 6'd0);
assign bw_BA_rb = (bw_BA_issue > bw_BA_dep) ? bw_BA_issue : bw_BA_dep;
assign bw_BA_ra = bw_A_ra;

// bw_BB
wire [0:0] bw_BB_ra;
wire [6:0] bw_BB_rb;
wire [6:0] bw_BB_path = {{1{1'b0}}, bw_B_rb} + {{1{1'b0}}, B_bw_step_1};
assign bw_BB_rb = (bw_BB_path > {{1{1'b0}}, B_rev_lat[1]}) ? bw_BB_path : {{1{1'b0}}, B_rev_lat[1]};
assign bw_BB_ra = bw_B_ra;


//////// BACKWARD DEPTH 3 ////////
// bw_AAA
wire [7:0] bw_AAA_ra;
wire [0:0] bw_AAA_rb;
wire [7:0] bw_AAA_path = {{1{1'b0}}, bw_AA_ra} + {{2{1'b0}}, A_bw_step_2};
assign bw_AAA_ra = (bw_AAA_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AAA_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AAA_rb = bw_AA_rb;

// bw_AAB
wire [6:0] bw_AAB_ra;
wire [5:0] bw_AAB_rb;
wire [6:0] bw_AAB_path = {{1{1'b0}}, bw_AB_ra} + {{1{1'b0}}, A_bw_step_1};
assign bw_AAB_ra = (bw_AAB_path > {{1{1'b0}}, A_rev_lat[1]}) ? bw_AAB_path : {{1{1'b0}}, A_rev_lat[1]};
assign bw_AAB_rb = bw_AB_rb;

// bw_ABA
wire [6:0] bw_ABA_ra;
wire [5:0] bw_ABA_rb;
wire [5:0] bw_ABA_issue = bw_BA_rb + 6'd1;
wire [6:0] bw_ABA_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BA_ra} : 7'd0);
assign bw_ABA_ra = ({{1{1'b0}}, bw_ABA_issue} > bw_ABA_dep) ? {{1{1'b0}}, bw_ABA_issue} : bw_ABA_dep;
assign bw_ABA_rb = bw_BA_rb;

// bw_ABB
wire [6:0] bw_ABB_ra;
wire [6:0] bw_ABB_rb;
wire [6:0] bw_ABB_issue = bw_BB_rb + 7'd1;
wire [5:0] bw_ABB_dep = A_rev_lat[0] + (A_dependent ? {{5{1'b0}}, bw_BB_ra} : 6'd0);
assign bw_ABB_ra = (bw_ABB_issue > {{1{1'b0}}, bw_ABB_dep}) ? bw_ABB_issue : {{1{1'b0}}, bw_ABB_dep};
assign bw_ABB_rb = bw_BB_rb;

// bw_BAA
wire [6:0] bw_BAA_ra;
wire [6:0] bw_BAA_rb;
wire [6:0] bw_BAA_issue = bw_AA_ra + 7'd1;
wire [5:0] bw_BAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AA_rb} : 6'd0);
assign bw_BAA_rb = (bw_BAA_issue > {{1{1'b0}}, bw_BAA_dep}) ? bw_BAA_issue : {{1{1'b0}}, bw_BAA_dep};
assign bw_BAA_ra = bw_AA_ra;

// bw_BAB
wire [5:0] bw_BAB_ra;
wire [6:0] bw_BAB_rb;
wire [5:0] bw_BAB_issue = bw_AB_ra + 6'd1;
wire [6:0] bw_BAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AB_rb} : 7'd0);
assign bw_BAB_rb = ({{1{1'b0}}, bw_BAB_issue} > bw_BAB_dep) ? {{1{1'b0}}, bw_BAB_issue} : bw_BAB_dep;
assign bw_BAB_ra = bw_AB_ra;

// bw_BBA
wire [5:0] bw_BBA_ra;
wire [6:0] bw_BBA_rb;
wire [6:0] bw_BBA_path = {{1{1'b0}}, bw_BA_rb} + {{1{1'b0}}, B_bw_step_1};
assign bw_BBA_rb = (bw_BBA_path > {{1{1'b0}}, B_rev_lat[1]}) ? bw_BBA_path : {{1{1'b0}}, B_rev_lat[1]};
assign bw_BBA_ra = bw_BA_ra;

// bw_BBB
wire [0:0] bw_BBB_ra;
wire [7:0] bw_BBB_rb;
wire [7:0] bw_BBB_path = {{1{1'b0}}, bw_BB_rb} + {{2{1'b0}}, B_bw_step_2};
assign bw_BBB_rb = (bw_BBB_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBB_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBB_ra = bw_BB_ra;


//////// BACKWARD DEPTH 4 ////////
// bw_AAAA
wire [7:0] bw_AAAA_ra;
wire [0:0] bw_AAAA_rb;
wire [7:0] bw_AAAA_path = bw_AAA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAAA_ra = (bw_AAAA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAAA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAAA_rb = bw_AAA_rb;

// bw_AAAB
wire [7:0] bw_AAAB_ra;
wire [5:0] bw_AAAB_rb;
wire [7:0] bw_AAAB_path = {{1{1'b0}}, bw_AAB_ra} + {{2{1'b0}}, A_bw_step_2};
assign bw_AAAB_ra = (bw_AAAB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AAAB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AAAB_rb = bw_AAB_rb;

// bw_AABA
wire [7:0] bw_AABA_ra;
wire [5:0] bw_AABA_rb;
wire [7:0] bw_AABA_path = {{1{1'b0}}, bw_ABA_ra} + {{2{1'b0}}, A_bw_step_2};
assign bw_AABA_ra = (bw_AABA_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABA_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABA_rb = bw_ABA_rb;

// bw_AABB
wire [7:0] bw_AABB_ra;
wire [6:0] bw_AABB_rb;
wire [7:0] bw_AABB_path = {{1{1'b0}}, bw_ABB_ra} + {{2{1'b0}}, A_bw_step_1};
assign bw_AABB_ra = (bw_AABB_path > {{2{1'b0}}, A_rev_lat[1]}) ? bw_AABB_path : {{2{1'b0}}, A_rev_lat[1]};
assign bw_AABB_rb = bw_ABB_rb;

// bw_ABAA
wire [7:0] bw_ABAA_ra;
wire [6:0] bw_ABAA_rb;
wire [6:0] bw_ABAA_issue = bw_BAA_rb + 7'd1;
wire [7:0] bw_ABAA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BAA_ra} : 8'd0);
assign bw_ABAA_ra = ({{1{1'b0}}, bw_ABAA_issue} > bw_ABAA_dep) ? {{1{1'b0}}, bw_ABAA_issue} : bw_ABAA_dep;
assign bw_ABAA_rb = bw_BAA_rb;

// bw_ABAB
wire [6:0] bw_ABAB_ra;
wire [6:0] bw_ABAB_rb;
wire [6:0] bw_ABAB_issue = bw_BAB_rb + 7'd1;
wire [6:0] bw_ABAB_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BAB_ra} : 7'd0);
assign bw_ABAB_ra = (bw_ABAB_issue > bw_ABAB_dep) ? bw_ABAB_issue : bw_ABAB_dep;
assign bw_ABAB_rb = bw_BAB_rb;

// bw_ABBA
wire [6:0] bw_ABBA_ra;
wire [6:0] bw_ABBA_rb;
wire [6:0] bw_ABBA_issue = bw_BBA_rb + 7'd1;
wire [6:0] bw_ABBA_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BBA_ra} : 7'd0);
assign bw_ABBA_ra = (bw_ABBA_issue > bw_ABBA_dep) ? bw_ABBA_issue : bw_ABBA_dep;
assign bw_ABBA_rb = bw_BBA_rb;

// bw_ABBB
wire [7:0] bw_ABBB_ra;
wire [7:0] bw_ABBB_rb;
wire [7:0] bw_ABBB_issue = bw_BBB_rb + 8'd1;
wire [5:0] bw_ABBB_dep = A_rev_lat[0] + (A_dependent ? {{5{1'b0}}, bw_BBB_ra} : 6'd0);
assign bw_ABBB_ra = (bw_ABBB_issue > {{2{1'b0}}, bw_ABBB_dep}) ? bw_ABBB_issue : {{2{1'b0}}, bw_ABBB_dep};
assign bw_ABBB_rb = bw_BBB_rb;

// bw_BAAA
wire [7:0] bw_BAAA_ra;
wire [7:0] bw_BAAA_rb;
wire [7:0] bw_BAAA_issue = bw_AAA_ra + 8'd1;
wire [5:0] bw_BAAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AAA_rb} : 6'd0);
assign bw_BAAA_rb = (bw_BAAA_issue > {{2{1'b0}}, bw_BAAA_dep}) ? bw_BAAA_issue : {{2{1'b0}}, bw_BAAA_dep};
assign bw_BAAA_ra = bw_AAA_ra;

// bw_BAAB
wire [6:0] bw_BAAB_ra;
wire [6:0] bw_BAAB_rb;
wire [6:0] bw_BAAB_issue = bw_AAB_ra + 7'd1;
wire [6:0] bw_BAAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAB_rb} : 7'd0);
assign bw_BAAB_rb = (bw_BAAB_issue > bw_BAAB_dep) ? bw_BAAB_issue : bw_BAAB_dep;
assign bw_BAAB_ra = bw_AAB_ra;

// bw_BABA
wire [6:0] bw_BABA_ra;
wire [6:0] bw_BABA_rb;
wire [6:0] bw_BABA_issue = bw_ABA_ra + 7'd1;
wire [6:0] bw_BABA_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_ABA_rb} : 7'd0);
assign bw_BABA_rb = (bw_BABA_issue > bw_BABA_dep) ? bw_BABA_issue : bw_BABA_dep;
assign bw_BABA_ra = bw_ABA_ra;

// bw_BABB
wire [6:0] bw_BABB_ra;
wire [7:0] bw_BABB_rb;
wire [6:0] bw_BABB_issue = bw_ABB_ra + 7'd1;
wire [7:0] bw_BABB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABB_rb} : 8'd0);
assign bw_BABB_rb = ({{1{1'b0}}, bw_BABB_issue} > bw_BABB_dep) ? {{1{1'b0}}, bw_BABB_issue} : bw_BABB_dep;
assign bw_BABB_ra = bw_ABB_ra;

// bw_BBAA
wire [6:0] bw_BBAA_ra;
wire [7:0] bw_BBAA_rb;
wire [7:0] bw_BBAA_path = {{1{1'b0}}, bw_BAA_rb} + {{2{1'b0}}, B_bw_step_1};
assign bw_BBAA_rb = (bw_BBAA_path > {{2{1'b0}}, B_rev_lat[1]}) ? bw_BBAA_path : {{2{1'b0}}, B_rev_lat[1]};
assign bw_BBAA_ra = bw_BAA_ra;

// bw_BBAB
wire [5:0] bw_BBAB_ra;
wire [7:0] bw_BBAB_rb;
wire [7:0] bw_BBAB_path = {{1{1'b0}}, bw_BAB_rb} + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAB_rb = (bw_BBAB_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAB_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAB_ra = bw_BAB_ra;

// bw_BBBA
wire [5:0] bw_BBBA_ra;
wire [7:0] bw_BBBA_rb;
wire [7:0] bw_BBBA_path = {{1{1'b0}}, bw_BBA_rb} + {{2{1'b0}}, B_bw_step_2};
assign bw_BBBA_rb = (bw_BBBA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBBA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBBA_ra = bw_BBA_ra;


//////// BACKWARD DEPTH 5 ////////
// bw_AAAAA
wire [7:0] bw_AAAAA_ra;
wire [0:0] bw_AAAAA_rb;
wire [7:0] bw_AAAAA_path = bw_AAAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAAAA_ra = (bw_AAAAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAAAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAAAA_rb = bw_AAAA_rb;

// bw_AAAAB
wire [7:0] bw_AAAAB_ra;
wire [5:0] bw_AAAAB_rb;
wire [7:0] bw_AAAAB_path = bw_AAAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAAAB_ra = (bw_AAAAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAAAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAAAB_rb = bw_AAAB_rb;

// bw_AAABA
wire [7:0] bw_AAABA_ra;
wire [5:0] bw_AAABA_rb;
wire [7:0] bw_AAABA_path = bw_AABA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABA_ra = (bw_AAABA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABA_rb = bw_AABA_rb;

// bw_AAABB
wire [7:0] bw_AAABB_ra;
wire [6:0] bw_AAABB_rb;
wire [7:0] bw_AAABB_path = bw_AABB_ra + {{2{1'b0}}, A_bw_step_2};
assign bw_AAABB_ra = (bw_AAABB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AAABB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AAABB_rb = bw_AABB_rb;

// bw_AABAA
wire [7:0] bw_AABAA_ra;
wire [6:0] bw_AABAA_rb;
wire [7:0] bw_AABAA_path = bw_ABAA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABAA_ra = (bw_AABAA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABAA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABAA_rb = bw_ABAA_rb;

// bw_AABAB
wire [7:0] bw_AABAB_ra;
wire [6:0] bw_AABAB_rb;
wire [7:0] bw_AABAB_path = {{1{1'b0}}, bw_ABAB_ra} + {{2{1'b0}}, A_bw_step_2};
assign bw_AABAB_ra = (bw_AABAB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABAB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABAB_rb = bw_ABAB_rb;

// bw_AABBA
wire [7:0] bw_AABBA_ra;
wire [6:0] bw_AABBA_rb;
wire [7:0] bw_AABBA_path = {{1{1'b0}}, bw_ABBA_ra} + {{2{1'b0}}, A_bw_step_2};
assign bw_AABBA_ra = (bw_AABBA_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABBA_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABBA_rb = bw_ABBA_rb;

// bw_AABBB
wire [7:0] bw_AABBB_ra;
wire [7:0] bw_AABBB_rb;
wire [7:0] bw_AABBB_path = bw_ABBB_ra + {{2{1'b0}}, A_bw_step_1};
assign bw_AABBB_ra = (bw_AABBB_path > {{2{1'b0}}, A_rev_lat[1]}) ? bw_AABBB_path : {{2{1'b0}}, A_rev_lat[1]};
assign bw_AABBB_rb = bw_ABBB_rb;

// bw_ABAAA
wire [7:0] bw_ABAAA_ra;
wire [7:0] bw_ABAAA_rb;
wire [7:0] bw_ABAAA_issue = bw_BAAA_rb + 8'd1;
wire [7:0] bw_ABAAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAAA_ra : 8'd0);
assign bw_ABAAA_ra = (bw_ABAAA_issue > bw_ABAAA_dep) ? bw_ABAAA_issue : bw_ABAAA_dep;
assign bw_ABAAA_rb = bw_BAAA_rb;

// bw_ABAAB
wire [7:0] bw_ABAAB_ra;
wire [6:0] bw_ABAAB_rb;
wire [6:0] bw_ABAAB_issue = bw_BAAB_rb + 7'd1;
wire [7:0] bw_ABAAB_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BAAB_ra} : 8'd0);
assign bw_ABAAB_ra = ({{1{1'b0}}, bw_ABAAB_issue} > bw_ABAAB_dep) ? {{1{1'b0}}, bw_ABAAB_issue} : bw_ABAAB_dep;
assign bw_ABAAB_rb = bw_BAAB_rb;

// bw_ABABA
wire [7:0] bw_ABABA_ra;
wire [6:0] bw_ABABA_rb;
wire [6:0] bw_ABABA_issue = bw_BABA_rb + 7'd1;
wire [7:0] bw_ABABA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BABA_ra} : 8'd0);
assign bw_ABABA_ra = ({{1{1'b0}}, bw_ABABA_issue} > bw_ABABA_dep) ? {{1{1'b0}}, bw_ABABA_issue} : bw_ABABA_dep;
assign bw_ABABA_rb = bw_BABA_rb;

// bw_ABABB
wire [7:0] bw_ABABB_ra;
wire [7:0] bw_ABABB_rb;
wire [7:0] bw_ABABB_issue = bw_BABB_rb + 8'd1;
wire [7:0] bw_ABABB_dep = {{2{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BABB_ra} : 8'd0);
assign bw_ABABB_ra = (bw_ABABB_issue > bw_ABABB_dep) ? bw_ABABB_issue : bw_ABABB_dep;
assign bw_ABABB_rb = bw_BABB_rb;

// bw_ABBAA
wire [7:0] bw_ABBAA_ra;
wire [7:0] bw_ABBAA_rb;
wire [7:0] bw_ABBAA_issue = bw_BBAA_rb + 8'd1;
wire [7:0] bw_ABBAA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BBAA_ra} : 8'd0);
assign bw_ABBAA_ra = (bw_ABBAA_issue > bw_ABBAA_dep) ? bw_ABBAA_issue : bw_ABBAA_dep;
assign bw_ABBAA_rb = bw_BBAA_rb;

// bw_ABBAB
wire [7:0] bw_ABBAB_ra;
wire [7:0] bw_ABBAB_rb;
wire [7:0] bw_ABBAB_issue = bw_BBAB_rb + 8'd1;
wire [6:0] bw_ABBAB_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BBAB_ra} : 7'd0);
assign bw_ABBAB_ra = (bw_ABBAB_issue > {{1{1'b0}}, bw_ABBAB_dep}) ? bw_ABBAB_issue : {{1{1'b0}}, bw_ABBAB_dep};
assign bw_ABBAB_rb = bw_BBAB_rb;

// bw_ABBBA
wire [7:0] bw_ABBBA_ra;
wire [7:0] bw_ABBBA_rb;
wire [7:0] bw_ABBBA_issue = bw_BBBA_rb + 8'd1;
wire [6:0] bw_ABBBA_dep = {{1{1'b0}}, A_rev_lat[1]} + (A_dependent ? {{1{1'b0}}, bw_BBBA_ra} : 7'd0);
assign bw_ABBBA_ra = (bw_ABBBA_issue > {{1{1'b0}}, bw_ABBBA_dep}) ? bw_ABBBA_issue : {{1{1'b0}}, bw_ABBBA_dep};
assign bw_ABBBA_rb = bw_BBBA_rb;

// bw_BAAAA
wire [7:0] bw_BAAAA_ra;
wire [7:0] bw_BAAAA_rb;
wire [7:0] bw_BAAAA_issue = bw_AAAA_ra + 8'd1;
wire [5:0] bw_BAAAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AAAA_rb} : 6'd0);
assign bw_BAAAA_rb = (bw_BAAAA_issue > {{2{1'b0}}, bw_BAAAA_dep}) ? bw_BAAAA_issue : {{2{1'b0}}, bw_BAAAA_dep};
assign bw_BAAAA_ra = bw_AAAA_ra;

// bw_BAAAB
wire [7:0] bw_BAAAB_ra;
wire [7:0] bw_BAAAB_rb;
wire [7:0] bw_BAAAB_issue = bw_AAAB_ra + 8'd1;
wire [6:0] bw_BAAAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAB_rb} : 7'd0);
assign bw_BAAAB_rb = (bw_BAAAB_issue > {{1{1'b0}}, bw_BAAAB_dep}) ? bw_BAAAB_issue : {{1{1'b0}}, bw_BAAAB_dep};
assign bw_BAAAB_ra = bw_AAAB_ra;

// bw_BAABA
wire [7:0] bw_BAABA_ra;
wire [7:0] bw_BAABA_rb;
wire [7:0] bw_BAABA_issue = bw_AABA_ra + 8'd1;
wire [6:0] bw_BAABA_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AABA_rb} : 7'd0);
assign bw_BAABA_rb = (bw_BAABA_issue > {{1{1'b0}}, bw_BAABA_dep}) ? bw_BAABA_issue : {{1{1'b0}}, bw_BAABA_dep};
assign bw_BAABA_ra = bw_AABA_ra;

// bw_BAABB
wire [7:0] bw_BAABB_ra;
wire [7:0] bw_BAABB_rb;
wire [7:0] bw_BAABB_issue = bw_AABB_ra + 8'd1;
wire [7:0] bw_BAABB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AABB_rb} : 8'd0);
assign bw_BAABB_rb = (bw_BAABB_issue > bw_BAABB_dep) ? bw_BAABB_issue : bw_BAABB_dep;
assign bw_BAABB_ra = bw_AABB_ra;

// bw_BABAA
wire [7:0] bw_BABAA_ra;
wire [7:0] bw_BABAA_rb;
wire [7:0] bw_BABAA_issue = bw_ABAA_ra + 8'd1;
wire [7:0] bw_BABAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_ABAA_rb} : 8'd0);
assign bw_BABAA_rb = (bw_BABAA_issue > bw_BABAA_dep) ? bw_BABAA_issue : bw_BABAA_dep;
assign bw_BABAA_ra = bw_ABAA_ra;

// bw_BABAB
wire [6:0] bw_BABAB_ra;
wire [7:0] bw_BABAB_rb;
wire [6:0] bw_BABAB_issue = bw_ABAB_ra + 7'd1;
wire [7:0] bw_BABAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABAB_rb} : 8'd0);
assign bw_BABAB_rb = ({{1{1'b0}}, bw_BABAB_issue} > bw_BABAB_dep) ? {{1{1'b0}}, bw_BABAB_issue} : bw_BABAB_dep;
assign bw_BABAB_ra = bw_ABAB_ra;

// bw_BABBA
wire [6:0] bw_BABBA_ra;
wire [7:0] bw_BABBA_rb;
wire [6:0] bw_BABBA_issue = bw_ABBA_ra + 7'd1;
wire [7:0] bw_BABBA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABBA_rb} : 8'd0);
assign bw_BABBA_rb = ({{1{1'b0}}, bw_BABBA_issue} > bw_BABBA_dep) ? {{1{1'b0}}, bw_BABBA_issue} : bw_BABBA_dep;
assign bw_BABBA_ra = bw_ABBA_ra;

// bw_BBAAA
wire [7:0] bw_BBAAA_ra;
wire [7:0] bw_BBAAA_rb;
wire [7:0] bw_BBAAA_path = bw_BAAA_rb + {{2{1'b0}}, B_bw_step_1};
assign bw_BBAAA_rb = (bw_BBAAA_path > {{2{1'b0}}, B_rev_lat[1]}) ? bw_BBAAA_path : {{2{1'b0}}, B_rev_lat[1]};
assign bw_BBAAA_ra = bw_BAAA_ra;

// bw_BBAAB
wire [6:0] bw_BBAAB_ra;
wire [7:0] bw_BBAAB_rb;
wire [7:0] bw_BBAAB_path = {{1{1'b0}}, bw_BAAB_rb} + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAAB_rb = (bw_BBAAB_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAAB_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAAB_ra = bw_BAAB_ra;

// bw_BBABA
wire [6:0] bw_BBABA_ra;
wire [7:0] bw_BBABA_rb;
wire [7:0] bw_BBABA_path = {{1{1'b0}}, bw_BABA_rb} + {{2{1'b0}}, B_bw_step_2};
assign bw_BBABA_rb = (bw_BBABA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBABA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBABA_ra = bw_BABA_ra;

// bw_BBBAA
wire [6:0] bw_BBBAA_ra;
wire [7:0] bw_BBBAA_rb;
wire [7:0] bw_BBBAA_path = bw_BBAA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBBAA_rb = (bw_BBBAA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBBAA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBBAA_ra = bw_BBAA_ra;


//////// BACKWARD DEPTH 6 ////////
// bw_AAAAAA
wire [8:0] bw_AAAAAA_ra;
wire [0:0] bw_AAAAAA_rb;
wire [8:0] bw_AAAAAA_path = {{1{1'b0}}, bw_AAAAA_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AAAAAA_ra = (bw_AAAAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AAAAAA_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AAAAAA_rb = bw_AAAAA_rb;

// bw_AAAAAB
wire [7:0] bw_AAAAAB_ra;
wire [5:0] bw_AAAAAB_rb;
wire [7:0] bw_AAAAAB_path = bw_AAAAB_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAAAAB_ra = (bw_AAAAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAAAAB_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAAAAB_rb = bw_AAAAB_rb;

// bw_AAAABA
wire [7:0] bw_AAAABA_ra;
wire [5:0] bw_AAAABA_rb;
wire [7:0] bw_AAAABA_path = bw_AAABA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAAABA_ra = (bw_AAAABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAAABA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAAABA_rb = bw_AAABA_rb;

// bw_AAAABB
wire [7:0] bw_AAAABB_ra;
wire [6:0] bw_AAAABB_rb;
wire [7:0] bw_AAAABB_path = bw_AAABB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAAABB_ra = (bw_AAAABB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAAABB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAAABB_rb = bw_AAABB_rb;

// bw_AAABAA
wire [7:0] bw_AAABAA_ra;
wire [6:0] bw_AAABAA_rb;
wire [7:0] bw_AAABAA_path = bw_AABAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAABAA_ra = (bw_AAABAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAABAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAABAA_rb = bw_AABAA_rb;

// bw_AAABAB
wire [7:0] bw_AAABAB_ra;
wire [6:0] bw_AAABAB_rb;
wire [7:0] bw_AAABAB_path = bw_AABAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABAB_ra = (bw_AAABAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABAB_rb = bw_AABAB_rb;

// bw_AAABBA
wire [7:0] bw_AAABBA_ra;
wire [6:0] bw_AAABBA_rb;
wire [7:0] bw_AAABBA_path = bw_AABBA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABBA_ra = (bw_AAABBA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABBA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABBA_rb = bw_AABBA_rb;

// bw_AAABBB
wire [7:0] bw_AAABBB_ra;
wire [7:0] bw_AAABBB_rb;
wire [7:0] bw_AAABBB_path = bw_AABBB_ra + {{2{1'b0}}, A_bw_step_2};
assign bw_AAABBB_ra = (bw_AAABBB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AAABBB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AAABBB_rb = bw_AABBB_rb;

// bw_AABAAA
wire [7:0] bw_AABAAA_ra;
wire [7:0] bw_AABAAA_rb;
wire [7:0] bw_AABAAA_path = bw_ABAAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AABAAA_ra = (bw_AABAAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AABAAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AABAAA_rb = bw_ABAAA_rb;

// bw_AABAAB
wire [7:0] bw_AABAAB_ra;
wire [6:0] bw_AABAAB_rb;
wire [7:0] bw_AABAAB_path = bw_ABAAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABAAB_ra = (bw_AABAAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABAAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABAAB_rb = bw_ABAAB_rb;

// bw_AABABA
wire [7:0] bw_AABABA_ra;
wire [6:0] bw_AABABA_rb;
wire [7:0] bw_AABABA_path = bw_ABABA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABABA_ra = (bw_AABABA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABABA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABABA_rb = bw_ABABA_rb;

// bw_AABABB
wire [7:0] bw_AABABB_ra;
wire [7:0] bw_AABABB_rb;
wire [7:0] bw_AABABB_path = bw_ABABB_ra + {{2{1'b0}}, A_bw_step_2};
assign bw_AABABB_ra = (bw_AABABB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABABB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABABB_rb = bw_ABABB_rb;

// bw_AABBAA
wire [7:0] bw_AABBAA_ra;
wire [7:0] bw_AABBAA_rb;
wire [7:0] bw_AABBAA_path = bw_ABBAA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABBAA_ra = (bw_AABBAA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABBAA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABBAA_rb = bw_ABBAA_rb;

// bw_AABBAB
wire [7:0] bw_AABBAB_ra;
wire [7:0] bw_AABBAB_rb;
wire [7:0] bw_AABBAB_path = bw_ABBAB_ra + {{2{1'b0}}, A_bw_step_2};
assign bw_AABBAB_ra = (bw_AABBAB_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABBAB_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABBAB_rb = bw_ABBAB_rb;

// bw_AABBBA
wire [7:0] bw_AABBBA_ra;
wire [7:0] bw_AABBBA_rb;
wire [7:0] bw_AABBBA_path = bw_ABBBA_ra + {{2{1'b0}}, A_bw_step_2};
assign bw_AABBBA_ra = (bw_AABBBA_path > {{2{1'b0}}, A_rev_lat[2]}) ? bw_AABBBA_path : {{2{1'b0}}, A_rev_lat[2]};
assign bw_AABBBA_rb = bw_ABBBA_rb;

// bw_ABAAAA
wire [7:0] bw_ABAAAA_ra;
wire [7:0] bw_ABAAAA_rb;
wire [7:0] bw_ABAAAA_issue = bw_BAAAA_rb + 8'd1;
wire [7:0] bw_ABAAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAAAA_ra : 8'd0);
assign bw_ABAAAA_ra = (bw_ABAAAA_issue > bw_ABAAAA_dep) ? bw_ABAAAA_issue : bw_ABAAAA_dep;
assign bw_ABAAAA_rb = bw_BAAAA_rb;

// bw_ABAAAB
wire [7:0] bw_ABAAAB_ra;
wire [7:0] bw_ABAAAB_rb;
wire [7:0] bw_ABAAAB_issue = bw_BAAAB_rb + 8'd1;
wire [7:0] bw_ABAAAB_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAAAB_ra : 8'd0);
assign bw_ABAAAB_ra = (bw_ABAAAB_issue > bw_ABAAAB_dep) ? bw_ABAAAB_issue : bw_ABAAAB_dep;
assign bw_ABAAAB_rb = bw_BAAAB_rb;

// bw_ABAABA
wire [7:0] bw_ABAABA_ra;
wire [7:0] bw_ABAABA_rb;
wire [7:0] bw_ABAABA_issue = bw_BAABA_rb + 8'd1;
wire [7:0] bw_ABAABA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAABA_ra : 8'd0);
assign bw_ABAABA_ra = (bw_ABAABA_issue > bw_ABAABA_dep) ? bw_ABAABA_issue : bw_ABAABA_dep;
assign bw_ABAABA_rb = bw_BAABA_rb;

// bw_ABAABB
wire [7:0] bw_ABAABB_ra;
wire [7:0] bw_ABAABB_rb;
wire [7:0] bw_ABAABB_issue = bw_BAABB_rb + 8'd1;
wire [7:0] bw_ABAABB_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? bw_BAABB_ra : 8'd0);
assign bw_ABAABB_ra = (bw_ABAABB_issue > bw_ABAABB_dep) ? bw_ABAABB_issue : bw_ABAABB_dep;
assign bw_ABAABB_rb = bw_BAABB_rb;

// bw_ABABAA
wire [7:0] bw_ABABAA_ra;
wire [7:0] bw_ABABAA_rb;
wire [7:0] bw_ABABAA_issue = bw_BABAA_rb + 8'd1;
wire [7:0] bw_ABABAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BABAA_ra : 8'd0);
assign bw_ABABAA_ra = (bw_ABABAA_issue > bw_ABABAA_dep) ? bw_ABABAA_issue : bw_ABABAA_dep;
assign bw_ABABAA_rb = bw_BABAA_rb;

// bw_ABABAB
wire [7:0] bw_ABABAB_ra;
wire [7:0] bw_ABABAB_rb;
wire [7:0] bw_ABABAB_issue = bw_BABAB_rb + 8'd1;
wire [7:0] bw_ABABAB_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BABAB_ra} : 8'd0);
assign bw_ABABAB_ra = (bw_ABABAB_issue > bw_ABABAB_dep) ? bw_ABABAB_issue : bw_ABABAB_dep;
assign bw_ABABAB_rb = bw_BABAB_rb;

// bw_ABABBA
wire [7:0] bw_ABABBA_ra;
wire [7:0] bw_ABABBA_rb;
wire [7:0] bw_ABABBA_issue = bw_BABBA_rb + 8'd1;
wire [7:0] bw_ABABBA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BABBA_ra} : 8'd0);
assign bw_ABABBA_ra = (bw_ABABBA_issue > bw_ABABBA_dep) ? bw_ABABBA_issue : bw_ABABBA_dep;
assign bw_ABABBA_rb = bw_BABBA_rb;

// bw_ABBAAA
wire [7:0] bw_ABBAAA_ra;
wire [7:0] bw_ABBAAA_rb;
wire [7:0] bw_ABBAAA_issue = bw_BBAAA_rb + 8'd1;
wire [7:0] bw_ABBAAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BBAAA_ra : 8'd0);
assign bw_ABBAAA_ra = (bw_ABBAAA_issue > bw_ABBAAA_dep) ? bw_ABBAAA_issue : bw_ABBAAA_dep;
assign bw_ABBAAA_rb = bw_BBAAA_rb;

// bw_ABBAAB
wire [7:0] bw_ABBAAB_ra;
wire [7:0] bw_ABBAAB_rb;
wire [7:0] bw_ABBAAB_issue = bw_BBAAB_rb + 8'd1;
wire [7:0] bw_ABBAAB_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BBAAB_ra} : 8'd0);
assign bw_ABBAAB_ra = (bw_ABBAAB_issue > bw_ABBAAB_dep) ? bw_ABBAAB_issue : bw_ABBAAB_dep;
assign bw_ABBAAB_rb = bw_BBAAB_rb;

// bw_ABBABA
wire [7:0] bw_ABBABA_ra;
wire [7:0] bw_ABBABA_rb;
wire [7:0] bw_ABBABA_issue = bw_BBABA_rb + 8'd1;
wire [7:0] bw_ABBABA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BBABA_ra} : 8'd0);
assign bw_ABBABA_ra = (bw_ABBABA_issue > bw_ABBABA_dep) ? bw_ABBABA_issue : bw_ABBABA_dep;
assign bw_ABBABA_rb = bw_BBABA_rb;

// bw_ABBBAA
wire [7:0] bw_ABBBAA_ra;
wire [7:0] bw_ABBBAA_rb;
wire [7:0] bw_ABBBAA_issue = bw_BBBAA_rb + 8'd1;
wire [7:0] bw_ABBBAA_dep = {{2{1'b0}}, A_rev_lat[2]} + (A_dependent ? {{1{1'b0}}, bw_BBBAA_ra} : 8'd0);
assign bw_ABBBAA_ra = (bw_ABBBAA_issue > bw_ABBBAA_dep) ? bw_ABBBAA_issue : bw_ABBBAA_dep;
assign bw_ABBBAA_rb = bw_BBBAA_rb;

// bw_BAAAAA
wire [7:0] bw_BAAAAA_ra;
wire [7:0] bw_BAAAAA_rb;
wire [7:0] bw_BAAAAA_issue = bw_AAAAA_ra + 8'd1;
wire [5:0] bw_BAAAAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AAAAA_rb} : 6'd0);
assign bw_BAAAAA_rb = (bw_BAAAAA_issue > {{2{1'b0}}, bw_BAAAAA_dep}) ? bw_BAAAAA_issue : {{2{1'b0}}, bw_BAAAAA_dep};
assign bw_BAAAAA_ra = bw_AAAAA_ra;

// bw_BAAAAB
wire [7:0] bw_BAAAAB_ra;
wire [7:0] bw_BAAAAB_rb;
wire [7:0] bw_BAAAAB_issue = bw_AAAAB_ra + 8'd1;
wire [6:0] bw_BAAAAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAAB_rb} : 7'd0);
assign bw_BAAAAB_rb = (bw_BAAAAB_issue > {{1{1'b0}}, bw_BAAAAB_dep}) ? bw_BAAAAB_issue : {{1{1'b0}}, bw_BAAAAB_dep};
assign bw_BAAAAB_ra = bw_AAAAB_ra;

// bw_BAAABA
wire [7:0] bw_BAAABA_ra;
wire [7:0] bw_BAAABA_rb;
wire [7:0] bw_BAAABA_issue = bw_AAABA_ra + 8'd1;
wire [6:0] bw_BAAABA_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAABA_rb} : 7'd0);
assign bw_BAAABA_rb = (bw_BAAABA_issue > {{1{1'b0}}, bw_BAAABA_dep}) ? bw_BAAABA_issue : {{1{1'b0}}, bw_BAAABA_dep};
assign bw_BAAABA_ra = bw_AAABA_ra;

// bw_BAAABB
wire [7:0] bw_BAAABB_ra;
wire [7:0] bw_BAAABB_rb;
wire [7:0] bw_BAAABB_issue = bw_AAABB_ra + 8'd1;
wire [7:0] bw_BAAABB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAABB_rb} : 8'd0);
assign bw_BAAABB_rb = (bw_BAAABB_issue > bw_BAAABB_dep) ? bw_BAAABB_issue : bw_BAAABB_dep;
assign bw_BAAABB_ra = bw_AAABB_ra;

// bw_BAABAA
wire [7:0] bw_BAABAA_ra;
wire [7:0] bw_BAABAA_rb;
wire [7:0] bw_BAABAA_issue = bw_AABAA_ra + 8'd1;
wire [7:0] bw_BAABAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AABAA_rb} : 8'd0);
assign bw_BAABAA_rb = (bw_BAABAA_issue > bw_BAABAA_dep) ? bw_BAABAA_issue : bw_BAABAA_dep;
assign bw_BAABAA_ra = bw_AABAA_ra;

// bw_BAABAB
wire [7:0] bw_BAABAB_ra;
wire [7:0] bw_BAABAB_rb;
wire [7:0] bw_BAABAB_issue = bw_AABAB_ra + 8'd1;
wire [7:0] bw_BAABAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AABAB_rb} : 8'd0);
assign bw_BAABAB_rb = (bw_BAABAB_issue > bw_BAABAB_dep) ? bw_BAABAB_issue : bw_BAABAB_dep;
assign bw_BAABAB_ra = bw_AABAB_ra;

// bw_BAABBA
wire [7:0] bw_BAABBA_ra;
wire [7:0] bw_BAABBA_rb;
wire [7:0] bw_BAABBA_issue = bw_AABBA_ra + 8'd1;
wire [7:0] bw_BAABBA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AABBA_rb} : 8'd0);
assign bw_BAABBA_rb = (bw_BAABBA_issue > bw_BAABBA_dep) ? bw_BAABBA_issue : bw_BAABBA_dep;
assign bw_BAABBA_ra = bw_AABBA_ra;

// bw_BABAAA
wire [7:0] bw_BABAAA_ra;
wire [7:0] bw_BABAAA_rb;
wire [7:0] bw_BABAAA_issue = bw_ABAAA_ra + 8'd1;
wire [7:0] bw_BABAAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? bw_ABAAA_rb : 8'd0);
assign bw_BABAAA_rb = (bw_BABAAA_issue > bw_BABAAA_dep) ? bw_BABAAA_issue : bw_BABAAA_dep;
assign bw_BABAAA_ra = bw_ABAAA_ra;

// bw_BABAAB
wire [7:0] bw_BABAAB_ra;
wire [7:0] bw_BABAAB_rb;
wire [7:0] bw_BABAAB_issue = bw_ABAAB_ra + 8'd1;
wire [7:0] bw_BABAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABAAB_rb} : 8'd0);
assign bw_BABAAB_rb = (bw_BABAAB_issue > bw_BABAAB_dep) ? bw_BABAAB_issue : bw_BABAAB_dep;
assign bw_BABAAB_ra = bw_ABAAB_ra;

// bw_BABABA
wire [7:0] bw_BABABA_ra;
wire [7:0] bw_BABABA_rb;
wire [7:0] bw_BABABA_issue = bw_ABABA_ra + 8'd1;
wire [7:0] bw_BABABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_ABABA_rb} : 8'd0);
assign bw_BABABA_rb = (bw_BABABA_issue > bw_BABABA_dep) ? bw_BABABA_issue : bw_BABABA_dep;
assign bw_BABABA_ra = bw_ABABA_ra;

// bw_BABBAA
wire [7:0] bw_BABBAA_ra;
wire [7:0] bw_BABBAA_rb;
wire [7:0] bw_BABBAA_issue = bw_ABBAA_ra + 8'd1;
wire [7:0] bw_BABBAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABBAA_rb : 8'd0);
assign bw_BABBAA_rb = (bw_BABBAA_issue > bw_BABBAA_dep) ? bw_BABBAA_issue : bw_BABBAA_dep;
assign bw_BABBAA_ra = bw_ABBAA_ra;

// bw_BBAAAA
wire [7:0] bw_BBAAAA_ra;
wire [7:0] bw_BBAAAA_rb;
wire [7:0] bw_BBAAAA_path = bw_BAAAA_rb + {{2{1'b0}}, B_bw_step_1};
assign bw_BBAAAA_rb = (bw_BBAAAA_path > {{2{1'b0}}, B_rev_lat[1]}) ? bw_BBAAAA_path : {{2{1'b0}}, B_rev_lat[1]};
assign bw_BBAAAA_ra = bw_BAAAA_ra;

// bw_BBAAAB
wire [7:0] bw_BBAAAB_ra;
wire [7:0] bw_BBAAAB_rb;
wire [7:0] bw_BBAAAB_path = bw_BAAAB_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAAAB_rb = (bw_BBAAAB_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAAAB_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAAAB_ra = bw_BAAAB_ra;

// bw_BBAABA
wire [7:0] bw_BBAABA_ra;
wire [7:0] bw_BBAABA_rb;
wire [7:0] bw_BBAABA_path = bw_BAABA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAABA_rb = (bw_BBAABA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAABA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAABA_ra = bw_BAABA_ra;

// bw_BBABAA
wire [7:0] bw_BBABAA_ra;
wire [7:0] bw_BBABAA_rb;
wire [7:0] bw_BBABAA_path = bw_BABAA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBABAA_rb = (bw_BBABAA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBABAA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBABAA_ra = bw_BABAA_ra;

// bw_BBBAAA
wire [7:0] bw_BBBAAA_ra;
wire [7:0] bw_BBBAAA_rb;
wire [7:0] bw_BBBAAA_path = bw_BBAAA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBBAAA_rb = (bw_BBBAAA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBBAAA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBBAAA_ra = bw_BBAAA_ra;


//////// BACKWARD DEPTH 7 ////////
// bw_AAAAAAA
wire [8:0] bw_AAAAAAA_ra;
wire [0:0] bw_AAAAAAA_rb;
wire [8:0] bw_AAAAAAA_path = bw_AAAAAA_ra + {{3{1'b0}}, A_bw_step_6};
assign bw_AAAAAAA_ra = (bw_AAAAAAA_path > {{3{1'b0}}, A_rev_lat[6]}) ? bw_AAAAAAA_path : {{3{1'b0}}, A_rev_lat[6]};
assign bw_AAAAAAA_rb = bw_AAAAAA_rb;

// bw_AAAAAAB
wire [8:0] bw_AAAAAAB_ra;
wire [5:0] bw_AAAAAAB_rb;
wire [8:0] bw_AAAAAAB_path = {{1{1'b0}}, bw_AAAAAB_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AAAAAAB_ra = (bw_AAAAAAB_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AAAAAAB_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AAAAAAB_rb = bw_AAAAAB_rb;

// bw_AAAAABA
wire [8:0] bw_AAAAABA_ra;
wire [5:0] bw_AAAAABA_rb;
wire [8:0] bw_AAAAABA_path = {{1{1'b0}}, bw_AAAABA_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AAAAABA_ra = (bw_AAAAABA_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AAAAABA_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AAAAABA_rb = bw_AAAABA_rb;

// bw_AAAAABB
wire [8:0] bw_AAAAABB_ra;
wire [6:0] bw_AAAAABB_rb;
wire [8:0] bw_AAAAABB_path = {{1{1'b0}}, bw_AAAABB_ra} + {{3{1'b0}}, A_bw_step_4};
assign bw_AAAAABB_ra = (bw_AAAAABB_path > {{3{1'b0}}, A_rev_lat[4]}) ? bw_AAAAABB_path : {{3{1'b0}}, A_rev_lat[4]};
assign bw_AAAAABB_rb = bw_AAAABB_rb;

// bw_AAAABAA
wire [8:0] bw_AAAABAA_ra;
wire [6:0] bw_AAAABAA_rb;
wire [8:0] bw_AAAABAA_path = {{1{1'b0}}, bw_AAABAA_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AAAABAA_ra = (bw_AAAABAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AAAABAA_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AAAABAA_rb = bw_AAABAA_rb;

// bw_AAAABAB
wire [7:0] bw_AAAABAB_ra;
wire [6:0] bw_AAAABAB_rb;
wire [7:0] bw_AAAABAB_path = bw_AAABAB_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAAABAB_ra = (bw_AAAABAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAAABAB_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAAABAB_rb = bw_AAABAB_rb;

// bw_AAAABBA
wire [7:0] bw_AAAABBA_ra;
wire [6:0] bw_AAAABBA_rb;
wire [7:0] bw_AAAABBA_path = bw_AAABBA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAAABBA_ra = (bw_AAAABBA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAAABBA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAAABBA_rb = bw_AAABBA_rb;

// bw_AAAABBB
wire [8:0] bw_AAAABBB_ra;
wire [7:0] bw_AAAABBB_rb;
wire [8:0] bw_AAAABBB_path = {{1{1'b0}}, bw_AAABBB_ra} + {{3{1'b0}}, A_bw_step_3};
assign bw_AAAABBB_ra = (bw_AAAABBB_path > {{3{1'b0}}, A_rev_lat[3]}) ? bw_AAAABBB_path : {{3{1'b0}}, A_rev_lat[3]};
assign bw_AAAABBB_rb = bw_AAABBB_rb;

// bw_AAABAAA
wire [8:0] bw_AAABAAA_ra;
wire [7:0] bw_AAABAAA_rb;
wire [8:0] bw_AAABAAA_path = {{1{1'b0}}, bw_AABAAA_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AAABAAA_ra = (bw_AAABAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AAABAAA_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AAABAAA_rb = bw_AABAAA_rb;

// bw_AAABAAB
wire [7:0] bw_AAABAAB_ra;
wire [6:0] bw_AAABAAB_rb;
wire [7:0] bw_AAABAAB_path = bw_AABAAB_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAABAAB_ra = (bw_AAABAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAABAAB_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAABAAB_rb = bw_AABAAB_rb;

// bw_AAABABA
wire [7:0] bw_AAABABA_ra;
wire [6:0] bw_AAABABA_rb;
wire [7:0] bw_AAABABA_path = bw_AABABA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAABABA_ra = (bw_AAABABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAABABA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAABABA_rb = bw_AABABA_rb;

// bw_AAABABB
wire [7:0] bw_AAABABB_ra;
wire [7:0] bw_AAABABB_rb;
wire [7:0] bw_AAABABB_path = bw_AABABB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABABB_ra = (bw_AAABABB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABABB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABABB_rb = bw_AABABB_rb;

// bw_AAABBAA
wire [7:0] bw_AAABBAA_ra;
wire [7:0] bw_AAABBAA_rb;
wire [7:0] bw_AAABBAA_path = bw_AABBAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AAABBAA_ra = (bw_AAABBAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AAABBAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AAABBAA_rb = bw_AABBAA_rb;

// bw_AAABBAB
wire [7:0] bw_AAABBAB_ra;
wire [7:0] bw_AAABBAB_rb;
wire [7:0] bw_AAABBAB_path = bw_AABBAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABBAB_ra = (bw_AAABBAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABBAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABBAB_rb = bw_AABBAB_rb;

// bw_AAABBBA
wire [7:0] bw_AAABBBA_ra;
wire [7:0] bw_AAABBBA_rb;
wire [7:0] bw_AAABBBA_path = bw_AABBBA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AAABBBA_ra = (bw_AAABBBA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AAABBBA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AAABBBA_rb = bw_AABBBA_rb;

// bw_AABAAAA
wire [8:0] bw_AABAAAA_ra;
wire [7:0] bw_AABAAAA_rb;
wire [8:0] bw_AABAAAA_path = {{1{1'b0}}, bw_ABAAAA_ra} + {{3{1'b0}}, A_bw_step_5};
assign bw_AABAAAA_ra = (bw_AABAAAA_path > {{3{1'b0}}, A_rev_lat[5]}) ? bw_AABAAAA_path : {{3{1'b0}}, A_rev_lat[5]};
assign bw_AABAAAA_rb = bw_ABAAAA_rb;

// bw_AABAAAB
wire [7:0] bw_AABAAAB_ra;
wire [7:0] bw_AABAAAB_rb;
wire [7:0] bw_AABAAAB_path = bw_ABAAAB_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AABAAAB_ra = (bw_AABAAAB_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AABAAAB_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AABAAAB_rb = bw_ABAAAB_rb;

// bw_AABAABA
wire [7:0] bw_AABAABA_ra;
wire [7:0] bw_AABAABA_rb;
wire [7:0] bw_AABAABA_path = bw_ABAABA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AABAABA_ra = (bw_AABAABA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AABAABA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AABAABA_rb = bw_ABAABA_rb;

// bw_AABAABB
wire [7:0] bw_AABAABB_ra;
wire [7:0] bw_AABAABB_rb;
wire [7:0] bw_AABAABB_path = bw_ABAABB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABAABB_ra = (bw_AABAABB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABAABB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABAABB_rb = bw_ABAABB_rb;

// bw_AABABAA
wire [7:0] bw_AABABAA_ra;
wire [7:0] bw_AABABAA_rb;
wire [7:0] bw_AABABAA_path = bw_ABABAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AABABAA_ra = (bw_AABABAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AABABAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AABABAA_rb = bw_ABABAA_rb;

// bw_AABABAB
wire [7:0] bw_AABABAB_ra;
wire [7:0] bw_AABABAB_rb;
wire [7:0] bw_AABABAB_path = bw_ABABAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABABAB_ra = (bw_AABABAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABABAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABABAB_rb = bw_ABABAB_rb;

// bw_AABABBA
wire [7:0] bw_AABABBA_ra;
wire [7:0] bw_AABABBA_rb;
wire [7:0] bw_AABABBA_path = bw_ABABBA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABABBA_ra = (bw_AABABBA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABABBA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABABBA_rb = bw_ABABBA_rb;

// bw_AABBAAA
wire [7:0] bw_AABBAAA_ra;
wire [7:0] bw_AABBAAA_rb;
wire [7:0] bw_AABBAAA_path = bw_ABBAAA_ra + {{2{1'b0}}, A_bw_step_4};
assign bw_AABBAAA_ra = (bw_AABBAAA_path > {{2{1'b0}}, A_rev_lat[4]}) ? bw_AABBAAA_path : {{2{1'b0}}, A_rev_lat[4]};
assign bw_AABBAAA_rb = bw_ABBAAA_rb;

// bw_AABBAAB
wire [7:0] bw_AABBAAB_ra;
wire [7:0] bw_AABBAAB_rb;
wire [7:0] bw_AABBAAB_path = bw_ABBAAB_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABBAAB_ra = (bw_AABBAAB_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABBAAB_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABBAAB_rb = bw_ABBAAB_rb;

// bw_AABBABA
wire [7:0] bw_AABBABA_ra;
wire [7:0] bw_AABBABA_rb;
wire [7:0] bw_AABBABA_path = bw_ABBABA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABBABA_ra = (bw_AABBABA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABBABA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABBABA_rb = bw_ABBABA_rb;

// bw_AABBBAA
wire [7:0] bw_AABBBAA_ra;
wire [7:0] bw_AABBBAA_rb;
wire [7:0] bw_AABBBAA_path = bw_ABBBAA_ra + {{2{1'b0}}, A_bw_step_3};
assign bw_AABBBAA_ra = (bw_AABBBAA_path > {{2{1'b0}}, A_rev_lat[3]}) ? bw_AABBBAA_path : {{2{1'b0}}, A_rev_lat[3]};
assign bw_AABBBAA_rb = bw_ABBBAA_rb;

// bw_ABAAAAA
wire [8:0] bw_ABAAAAA_ra;
wire [7:0] bw_ABAAAAA_rb;
wire [7:0] bw_ABAAAAA_issue = bw_BAAAAA_rb + 8'd1;
wire [8:0] bw_ABAAAAA_dep = {{3{1'b0}}, A_rev_lat[5]} + (A_dependent ? {{1{1'b0}}, bw_BAAAAA_ra} : 9'd0);
assign bw_ABAAAAA_ra = ({{1{1'b0}}, bw_ABAAAAA_issue} > bw_ABAAAAA_dep) ? {{1{1'b0}}, bw_ABAAAAA_issue} : bw_ABAAAAA_dep;
assign bw_ABAAAAA_rb = bw_BAAAAA_rb;

// bw_ABAAAAB
wire [7:0] bw_ABAAAAB_ra;
wire [7:0] bw_ABAAAAB_rb;
wire [7:0] bw_ABAAAAB_issue = bw_BAAAAB_rb + 8'd1;
wire [7:0] bw_ABAAAAB_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAAAAB_ra : 8'd0);
assign bw_ABAAAAB_ra = (bw_ABAAAAB_issue > bw_ABAAAAB_dep) ? bw_ABAAAAB_issue : bw_ABAAAAB_dep;
assign bw_ABAAAAB_rb = bw_BAAAAB_rb;

// bw_ABAAABA
wire [7:0] bw_ABAAABA_ra;
wire [7:0] bw_ABAAABA_rb;
wire [7:0] bw_ABAAABA_issue = bw_BAAABA_rb + 8'd1;
wire [7:0] bw_ABAAABA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAAABA_ra : 8'd0);
assign bw_ABAAABA_ra = (bw_ABAAABA_issue > bw_ABAAABA_dep) ? bw_ABAAABA_issue : bw_ABAAABA_dep;
assign bw_ABAAABA_rb = bw_BAAABA_rb;

// bw_ABAAABB
wire [7:0] bw_ABAAABB_ra;
wire [7:0] bw_ABAAABB_rb;
wire [7:0] bw_ABAAABB_issue = bw_BAAABB_rb + 8'd1;
wire [7:0] bw_ABAAABB_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAAABB_ra : 8'd0);
assign bw_ABAAABB_ra = (bw_ABAAABB_issue > bw_ABAAABB_dep) ? bw_ABAAABB_issue : bw_ABAAABB_dep;
assign bw_ABAAABB_rb = bw_BAAABB_rb;

// bw_ABAABAA
wire [7:0] bw_ABAABAA_ra;
wire [7:0] bw_ABAABAA_rb;
wire [7:0] bw_ABAABAA_issue = bw_BAABAA_rb + 8'd1;
wire [7:0] bw_ABAABAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BAABAA_ra : 8'd0);
assign bw_ABAABAA_ra = (bw_ABAABAA_issue > bw_ABAABAA_dep) ? bw_ABAABAA_issue : bw_ABAABAA_dep;
assign bw_ABAABAA_rb = bw_BAABAA_rb;

// bw_ABAABAB
wire [7:0] bw_ABAABAB_ra;
wire [7:0] bw_ABAABAB_rb;
wire [7:0] bw_ABAABAB_issue = bw_BAABAB_rb + 8'd1;
wire [7:0] bw_ABAABAB_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAABAB_ra : 8'd0);
assign bw_ABAABAB_ra = (bw_ABAABAB_issue > bw_ABAABAB_dep) ? bw_ABAABAB_issue : bw_ABAABAB_dep;
assign bw_ABAABAB_rb = bw_BAABAB_rb;

// bw_ABAABBA
wire [7:0] bw_ABAABBA_ra;
wire [7:0] bw_ABAABBA_rb;
wire [7:0] bw_ABAABBA_issue = bw_BAABBA_rb + 8'd1;
wire [7:0] bw_ABAABBA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BAABBA_ra : 8'd0);
assign bw_ABAABBA_ra = (bw_ABAABBA_issue > bw_ABAABBA_dep) ? bw_ABAABBA_issue : bw_ABAABBA_dep;
assign bw_ABAABBA_rb = bw_BAABBA_rb;

// bw_ABABAAA
wire [7:0] bw_ABABAAA_ra;
wire [7:0] bw_ABABAAA_rb;
wire [7:0] bw_ABABAAA_issue = bw_BABAAA_rb + 8'd1;
wire [7:0] bw_ABABAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BABAAA_ra : 8'd0);
assign bw_ABABAAA_ra = (bw_ABABAAA_issue > bw_ABABAAA_dep) ? bw_ABABAAA_issue : bw_ABABAAA_dep;
assign bw_ABABAAA_rb = bw_BABAAA_rb;

// bw_ABABAAB
wire [7:0] bw_ABABAAB_ra;
wire [7:0] bw_ABABAAB_rb;
wire [7:0] bw_ABABAAB_issue = bw_BABAAB_rb + 8'd1;
wire [7:0] bw_ABABAAB_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BABAAB_ra : 8'd0);
assign bw_ABABAAB_ra = (bw_ABABAAB_issue > bw_ABABAAB_dep) ? bw_ABABAAB_issue : bw_ABABAAB_dep;
assign bw_ABABAAB_rb = bw_BABAAB_rb;

// bw_ABABABA
wire [7:0] bw_ABABABA_ra;
wire [7:0] bw_ABABABA_rb;
wire [7:0] bw_ABABABA_issue = bw_BABABA_rb + 8'd1;
wire [7:0] bw_ABABABA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BABABA_ra : 8'd0);
assign bw_ABABABA_ra = (bw_ABABABA_issue > bw_ABABABA_dep) ? bw_ABABABA_issue : bw_ABABABA_dep;
assign bw_ABABABA_rb = bw_BABABA_rb;

// bw_ABABBAA
wire [7:0] bw_ABABBAA_ra;
wire [7:0] bw_ABABBAA_rb;
wire [7:0] bw_ABABBAA_issue = bw_BABBAA_rb + 8'd1;
wire [7:0] bw_ABABBAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BABBAA_ra : 8'd0);
assign bw_ABABBAA_ra = (bw_ABABBAA_issue > bw_ABABBAA_dep) ? bw_ABABBAA_issue : bw_ABABBAA_dep;
assign bw_ABABBAA_rb = bw_BABBAA_rb;

// bw_ABBAAAA
wire [7:0] bw_ABBAAAA_ra;
wire [7:0] bw_ABBAAAA_rb;
wire [7:0] bw_ABBAAAA_issue = bw_BBAAAA_rb + 8'd1;
wire [7:0] bw_ABBAAAA_dep = {{2{1'b0}}, A_rev_lat[4]} + (A_dependent ? bw_BBAAAA_ra : 8'd0);
assign bw_ABBAAAA_ra = (bw_ABBAAAA_issue > bw_ABBAAAA_dep) ? bw_ABBAAAA_issue : bw_ABBAAAA_dep;
assign bw_ABBAAAA_rb = bw_BBAAAA_rb;

// bw_ABBAAAB
wire [7:0] bw_ABBAAAB_ra;
wire [7:0] bw_ABBAAAB_rb;
wire [7:0] bw_ABBAAAB_issue = bw_BBAAAB_rb + 8'd1;
wire [7:0] bw_ABBAAAB_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BBAAAB_ra : 8'd0);
assign bw_ABBAAAB_ra = (bw_ABBAAAB_issue > bw_ABBAAAB_dep) ? bw_ABBAAAB_issue : bw_ABBAAAB_dep;
assign bw_ABBAAAB_rb = bw_BBAAAB_rb;

// bw_ABBAABA
wire [7:0] bw_ABBAABA_ra;
wire [7:0] bw_ABBAABA_rb;
wire [7:0] bw_ABBAABA_issue = bw_BBAABA_rb + 8'd1;
wire [7:0] bw_ABBAABA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BBAABA_ra : 8'd0);
assign bw_ABBAABA_ra = (bw_ABBAABA_issue > bw_ABBAABA_dep) ? bw_ABBAABA_issue : bw_ABBAABA_dep;
assign bw_ABBAABA_rb = bw_BBAABA_rb;

// bw_ABBABAA
wire [7:0] bw_ABBABAA_ra;
wire [7:0] bw_ABBABAA_rb;
wire [7:0] bw_ABBABAA_issue = bw_BBABAA_rb + 8'd1;
wire [7:0] bw_ABBABAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BBABAA_ra : 8'd0);
assign bw_ABBABAA_ra = (bw_ABBABAA_issue > bw_ABBABAA_dep) ? bw_ABBABAA_issue : bw_ABBABAA_dep;
assign bw_ABBABAA_rb = bw_BBABAA_rb;

// bw_ABBBAAA
wire [7:0] bw_ABBBAAA_ra;
wire [7:0] bw_ABBBAAA_rb;
wire [7:0] bw_ABBBAAA_issue = bw_BBBAAA_rb + 8'd1;
wire [7:0] bw_ABBBAAA_dep = {{2{1'b0}}, A_rev_lat[3]} + (A_dependent ? bw_BBBAAA_ra : 8'd0);
assign bw_ABBBAAA_ra = (bw_ABBBAAA_issue > bw_ABBBAAA_dep) ? bw_ABBBAAA_issue : bw_ABBBAAA_dep;
assign bw_ABBBAAA_rb = bw_BBBAAA_rb;

// bw_BAAAAAA
wire [8:0] bw_BAAAAAA_ra;
wire [8:0] bw_BAAAAAA_rb;
wire [8:0] bw_BAAAAAA_issue = bw_AAAAAA_ra + 9'd1;
wire [5:0] bw_BAAAAAA_dep = B_rev_lat[0] + (B_dependent ? {{5{1'b0}}, bw_AAAAAA_rb} : 6'd0);
assign bw_BAAAAAA_rb = (bw_BAAAAAA_issue > {{3{1'b0}}, bw_BAAAAAA_dep}) ? bw_BAAAAAA_issue : {{3{1'b0}}, bw_BAAAAAA_dep};
assign bw_BAAAAAA_ra = bw_AAAAAA_ra;

// bw_BAAAAAB
wire [7:0] bw_BAAAAAB_ra;
wire [7:0] bw_BAAAAAB_rb;
wire [7:0] bw_BAAAAAB_issue = bw_AAAAAB_ra + 8'd1;
wire [6:0] bw_BAAAAAB_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAAAB_rb} : 7'd0);
assign bw_BAAAAAB_rb = (bw_BAAAAAB_issue > {{1{1'b0}}, bw_BAAAAAB_dep}) ? bw_BAAAAAB_issue : {{1{1'b0}}, bw_BAAAAAB_dep};
assign bw_BAAAAAB_ra = bw_AAAAAB_ra;

// bw_BAAAABA
wire [7:0] bw_BAAAABA_ra;
wire [7:0] bw_BAAAABA_rb;
wire [7:0] bw_BAAAABA_issue = bw_AAAABA_ra + 8'd1;
wire [6:0] bw_BAAAABA_dep = {{1{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAAABA_rb} : 7'd0);
assign bw_BAAAABA_rb = (bw_BAAAABA_issue > {{1{1'b0}}, bw_BAAAABA_dep}) ? bw_BAAAABA_issue : {{1{1'b0}}, bw_BAAAABA_dep};
assign bw_BAAAABA_ra = bw_AAAABA_ra;

// bw_BAAAABB
wire [7:0] bw_BAAAABB_ra;
wire [7:0] bw_BAAAABB_rb;
wire [7:0] bw_BAAAABB_issue = bw_AAAABB_ra + 8'd1;
wire [7:0] bw_BAAAABB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAAABB_rb} : 8'd0);
assign bw_BAAAABB_rb = (bw_BAAAABB_issue > bw_BAAAABB_dep) ? bw_BAAAABB_issue : bw_BAAAABB_dep;
assign bw_BAAAABB_ra = bw_AAAABB_ra;

// bw_BAAABAA
wire [7:0] bw_BAAABAA_ra;
wire [7:0] bw_BAAABAA_rb;
wire [7:0] bw_BAAABAA_issue = bw_AAABAA_ra + 8'd1;
wire [7:0] bw_BAAABAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? {{1{1'b0}}, bw_AAABAA_rb} : 8'd0);
assign bw_BAAABAA_rb = (bw_BAAABAA_issue > bw_BAAABAA_dep) ? bw_BAAABAA_issue : bw_BAAABAA_dep;
assign bw_BAAABAA_ra = bw_AAABAA_ra;

// bw_BAAABAB
wire [7:0] bw_BAAABAB_ra;
wire [7:0] bw_BAAABAB_rb;
wire [7:0] bw_BAAABAB_issue = bw_AAABAB_ra + 8'd1;
wire [7:0] bw_BAAABAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAABAB_rb} : 8'd0);
assign bw_BAAABAB_rb = (bw_BAAABAB_issue > bw_BAAABAB_dep) ? bw_BAAABAB_issue : bw_BAAABAB_dep;
assign bw_BAAABAB_ra = bw_AAABAB_ra;

// bw_BAAABBA
wire [7:0] bw_BAAABBA_ra;
wire [7:0] bw_BAAABBA_rb;
wire [7:0] bw_BAAABBA_issue = bw_AAABBA_ra + 8'd1;
wire [7:0] bw_BAAABBA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AAABBA_rb} : 8'd0);
assign bw_BAAABBA_rb = (bw_BAAABBA_issue > bw_BAAABBA_dep) ? bw_BAAABBA_issue : bw_BAAABBA_dep;
assign bw_BAAABBA_ra = bw_AAABBA_ra;

// bw_BAABAAA
wire [7:0] bw_BAABAAA_ra;
wire [7:0] bw_BAABAAA_rb;
wire [7:0] bw_BAABAAA_issue = bw_AABAAA_ra + 8'd1;
wire [7:0] bw_BAABAAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? bw_AABAAA_rb : 8'd0);
assign bw_BAABAAA_rb = (bw_BAABAAA_issue > bw_BAABAAA_dep) ? bw_BAABAAA_issue : bw_BAABAAA_dep;
assign bw_BAABAAA_ra = bw_AABAAA_ra;

// bw_BAABAAB
wire [7:0] bw_BAABAAB_ra;
wire [7:0] bw_BAABAAB_rb;
wire [7:0] bw_BAABAAB_issue = bw_AABAAB_ra + 8'd1;
wire [7:0] bw_BAABAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AABAAB_rb} : 8'd0);
assign bw_BAABAAB_rb = (bw_BAABAAB_issue > bw_BAABAAB_dep) ? bw_BAABAAB_issue : bw_BAABAAB_dep;
assign bw_BAABAAB_ra = bw_AABAAB_ra;

// bw_BAABABA
wire [7:0] bw_BAABABA_ra;
wire [7:0] bw_BAABABA_rb;
wire [7:0] bw_BAABABA_issue = bw_AABABA_ra + 8'd1;
wire [7:0] bw_BAABABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? {{1{1'b0}}, bw_AABABA_rb} : 8'd0);
assign bw_BAABABA_rb = (bw_BAABABA_issue > bw_BAABABA_dep) ? bw_BAABABA_issue : bw_BAABABA_dep;
assign bw_BAABABA_ra = bw_AABABA_ra;

// bw_BAABBAA
wire [7:0] bw_BAABBAA_ra;
wire [7:0] bw_BAABBAA_rb;
wire [7:0] bw_BAABBAA_issue = bw_AABBAA_ra + 8'd1;
wire [7:0] bw_BAABBAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_AABBAA_rb : 8'd0);
assign bw_BAABBAA_rb = (bw_BAABBAA_issue > bw_BAABBAA_dep) ? bw_BAABBAA_issue : bw_BAABBAA_dep;
assign bw_BAABBAA_ra = bw_AABBAA_ra;

// bw_BABAAAA
wire [7:0] bw_BABAAAA_ra;
wire [7:0] bw_BABAAAA_rb;
wire [7:0] bw_BABAAAA_issue = bw_ABAAAA_ra + 8'd1;
wire [7:0] bw_BABAAAA_dep = {{2{1'b0}}, B_rev_lat[1]} + (B_dependent ? bw_ABAAAA_rb : 8'd0);
assign bw_BABAAAA_rb = (bw_BABAAAA_issue > bw_BABAAAA_dep) ? bw_BABAAAA_issue : bw_BABAAAA_dep;
assign bw_BABAAAA_ra = bw_ABAAAA_ra;

// bw_BABAAAB
wire [7:0] bw_BABAAAB_ra;
wire [7:0] bw_BABAAAB_rb;
wire [7:0] bw_BABAAAB_issue = bw_ABAAAB_ra + 8'd1;
wire [7:0] bw_BABAAAB_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABAAAB_rb : 8'd0);
assign bw_BABAAAB_rb = (bw_BABAAAB_issue > bw_BABAAAB_dep) ? bw_BABAAAB_issue : bw_BABAAAB_dep;
assign bw_BABAAAB_ra = bw_ABAAAB_ra;

// bw_BABAABA
wire [7:0] bw_BABAABA_ra;
wire [7:0] bw_BABAABA_rb;
wire [7:0] bw_BABAABA_issue = bw_ABAABA_ra + 8'd1;
wire [7:0] bw_BABAABA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABAABA_rb : 8'd0);
assign bw_BABAABA_rb = (bw_BABAABA_issue > bw_BABAABA_dep) ? bw_BABAABA_issue : bw_BABAABA_dep;
assign bw_BABAABA_ra = bw_ABAABA_ra;

// bw_BABABAA
wire [7:0] bw_BABABAA_ra;
wire [7:0] bw_BABABAA_rb;
wire [7:0] bw_BABABAA_issue = bw_ABABAA_ra + 8'd1;
wire [7:0] bw_BABABAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABABAA_rb : 8'd0);
assign bw_BABABAA_rb = (bw_BABABAA_issue > bw_BABABAA_dep) ? bw_BABABAA_issue : bw_BABABAA_dep;
assign bw_BABABAA_ra = bw_ABABAA_ra;

// bw_BABBAAA
wire [7:0] bw_BABBAAA_ra;
wire [7:0] bw_BABBAAA_rb;
wire [7:0] bw_BABBAAA_issue = bw_ABBAAA_ra + 8'd1;
wire [7:0] bw_BABBAAA_dep = {{2{1'b0}}, B_rev_lat[2]} + (B_dependent ? bw_ABBAAA_rb : 8'd0);
assign bw_BABBAAA_rb = (bw_BABBAAA_issue > bw_BABBAAA_dep) ? bw_BABBAAA_issue : bw_BABBAAA_dep;
assign bw_BABBAAA_ra = bw_ABBAAA_ra;

// bw_BBAAAAA
wire [7:0] bw_BBAAAAA_ra;
wire [8:0] bw_BBAAAAA_rb;
wire [8:0] bw_BBAAAAA_path = {{1{1'b0}}, bw_BAAAAA_rb} + {{3{1'b0}}, B_bw_step_1};
assign bw_BBAAAAA_rb = (bw_BBAAAAA_path > {{3{1'b0}}, B_rev_lat[1]}) ? bw_BBAAAAA_path : {{3{1'b0}}, B_rev_lat[1]};
assign bw_BBAAAAA_ra = bw_BAAAAA_ra;

// bw_BBAAAAB
wire [7:0] bw_BBAAAAB_ra;
wire [7:0] bw_BBAAAAB_rb;
wire [7:0] bw_BBAAAAB_path = bw_BAAAAB_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAAAAB_rb = (bw_BBAAAAB_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAAAAB_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAAAAB_ra = bw_BAAAAB_ra;

// bw_BBAAABA
wire [7:0] bw_BBAAABA_ra;
wire [7:0] bw_BBAAABA_rb;
wire [7:0] bw_BBAAABA_path = bw_BAAABA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAAABA_rb = (bw_BBAAABA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAAABA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAAABA_ra = bw_BAAABA_ra;

// bw_BBAABAA
wire [7:0] bw_BBAABAA_ra;
wire [7:0] bw_BBAABAA_rb;
wire [7:0] bw_BBAABAA_path = bw_BAABAA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBAABAA_rb = (bw_BBAABAA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBAABAA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBAABAA_ra = bw_BAABAA_ra;

// bw_BBABAAA
wire [7:0] bw_BBABAAA_ra;
wire [7:0] bw_BBABAAA_rb;
wire [7:0] bw_BBABAAA_path = bw_BABAAA_rb + {{2{1'b0}}, B_bw_step_2};
assign bw_BBABAAA_rb = (bw_BBABAAA_path > {{2{1'b0}}, B_rev_lat[2]}) ? bw_BBABAAA_path : {{2{1'b0}}, B_rev_lat[2]};
assign bw_BBABAAA_ra = bw_BABAAA_ra;

// bw_BBBAAAA
wire [7:0] bw_BBBAAAA_ra;
wire [8:0] bw_BBBAAAA_rb;
wire [8:0] bw_BBBAAAA_path = {{1{1'b0}}, bw_BBAAAA_rb} + {{3{1'b0}}, B_bw_step_2};
assign bw_BBBAAAA_rb = (bw_BBBAAAA_path > {{3{1'b0}}, B_rev_lat[2]}) ? bw_BBBAAAA_path : {{3{1'b0}}, B_rev_lat[2]};
assign bw_BBBAAAA_ra = bw_BBAAAA_ra;

