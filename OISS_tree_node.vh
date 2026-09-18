//////// DEPTH 3 //////// 
// depth-2 branches
wire [5:0] n_AA_ready = n_AA_sl + 9'd1;
wire [1:0] n_AB_ready = n_AB_sl + 9'd1;
wire [1:0] n_BA_ready = n_BA_sl + 9'd1;
wire [5:0] n_BB_ready = n_BB_sl + 9'd1;

// n_AAA
wire [6:0] n_AAA_sl;
wire [7:0] n_AAA_fa;
wire [0:0] n_AAA_fb;
wire [7:0] n_AAA_fm;

assign n_AAA_sl = n_AA_sl + A_step_1;
assign n_AAA_fa = n_AA_sl + A_pair_1;
assign n_AAA_fb = n_AA_fb;
assign n_AAA_fm = (n_AAA_fa > n_AA_fm) ? n_AAA_fa : n_AA_fm;

// n_AAB
wire [5:0] n_AAB_sl;
wire [6:0] n_AAB_fa;
wire [6:0] n_AAB_fb;
wire [6:0] n_AAB_fm;

assign n_AAB_sl = n_AA_ready;
assign n_AAB_fa = n_AA_fa;
assign n_AAB_fb = n_AA_ready + B_lat_ext[0];
assign n_AAB_fm = (n_AAB_fb > n_AA_fm) ?  n_AAB_fb : n_AA_fm;

// n_ABA
wire [5:0] n_ABA_sl;
wire [6:0] n_ABA_fa;
wire [5:0] n_ABA_fb;
wire [6:0] n_ABA_fm;

assign n_ABA_sl = (A_dependent && (n_AB_fa > n_AB_ready)) ?
                  n_AB_fa : n_AB_ready;
assign n_ABA_fa = n_ABA_sl + A_lat_ext[1];
assign n_ABA_fb = n_AB_fb;
assign n_ABA_fm = (n_ABA_fa > n_AB_fm) ?
                  n_ABA_fa : n_AB_fm;

// n_ABB
wire [5:0] n_ABB_sl;
wire [5:0] n_ABB_fa;
wire [6:0] n_ABB_fb;
wire [6:0] n_ABB_fm;

assign n_ABB_sl = n_AB_sl + B_step_0;
assign n_ABB_fa = n_AB_fa;
assign n_ABB_fb = n_AB_sl + B_pair_0;
assign n_ABB_fm = (n_ABB_fb > n_AB_fm) ? n_ABB_fb : n_AB_fm;

// n_BAA
wire [5:0] n_BAA_sl;
wire [6:0] n_BAA_fa;
wire [5:0] n_BAA_fb;
wire [6:0] n_BAA_fm;

assign n_BAA_sl = n_BA_sl + A_step_0;
assign n_BAA_fa = n_BA_sl + A_pair_0;
assign n_BAA_fb = n_BA_fb;
assign n_BAA_fm = (n_BAA_fa > n_BA_fm) ? n_BAA_fa : n_BA_fm;

// n_BAB
wire [5:0] n_BAB_sl;
wire [5:0] n_BAB_fa;
wire [6:0] n_BAB_fb;
wire [6:0] n_BAB_fm;

assign n_BAB_sl = (B_dependent && (n_BA_fb > n_BA_ready)) ?
                  n_BA_fb : n_BA_ready;
assign n_BAB_fa = n_BA_fa;
assign n_BAB_fb = n_BAB_sl + B_lat_ext[1];
assign n_BAB_fm = (n_BAB_fb > n_BA_fm) ? n_BAB_fb : n_BA_fm;

// n_BBA
wire [5:0] n_BBA_sl;
wire [6:0] n_BBA_fa;
wire [6:0] n_BBA_fb;
wire [6:0] n_BBA_fm;

assign n_BBA_sl = n_BB_ready;
assign n_BBA_fa = n_BB_ready + A_lat_ext[0];
assign n_BBA_fb = n_BB_fb;
assign n_BBA_fm = (n_BBA_fa > n_BB_fm) ? n_BBA_fa : n_BB_fm;

// n_BBB
wire [6:0] n_BBB_sl;
wire [0:0] n_BBB_fa;
wire [7:0] n_BBB_fb;
wire [7:0] n_BBB_fm;

assign n_BBB_sl = n_BB_sl + B_step_1;
assign n_BBB_fa = n_BB_fa;
assign n_BBB_fb = n_BB_sl + B_pair_1;
assign n_BBB_fm = (n_BBB_fb > n_BB_fm) ? n_BBB_fb : n_BB_fm;

//////// DEPTH 4 ////////
// depth-3 branches
wire [6:0] n_AAA_ready = n_AAA_sl + 9'd1;
wire [5:0] n_AAB_ready = n_AAB_sl + 9'd1;
wire [5:0] n_ABA_ready = n_ABA_sl + 9'd1;
wire [5:0] n_ABB_ready = n_ABB_sl + 9'd1;
wire [5:0] n_BAA_ready = n_BAA_sl + 9'd1;
wire [5:0] n_BAB_ready = n_BAB_sl + 9'd1;
wire [5:0] n_BBA_ready = n_BBA_sl + 9'd1;
wire [6:0] n_BBB_ready = n_BBB_sl + 9'd1;

// n_AAAA
wire [7:0] n_AAAA_sl;
wire [7:0] n_AAAA_fa;
wire [0:0] n_AAAA_fb;
wire [7:0] n_AAAA_fm;

assign n_AAAA_sl = n_AAA_sl + A_step_2;
assign n_AAAA_fa = n_AAA_sl + A_pair_2;
assign n_AAAA_fb = n_AAA_fb;
assign n_AAAA_fm = (n_AAAA_fa > n_AAA_fm) ?
                   n_AAAA_fa : n_AAA_fm;


// n_AAAB
wire [6:0] n_AAAB_sl;
wire [7:0] n_AAAB_fa;
wire [7:0] n_AAAB_fb;
wire [7:0] n_AAAB_fm;

assign n_AAAB_sl = n_AAA_ready;
assign n_AAAB_fa = n_AAA_fa;
assign n_AAAB_fb = n_AAA_ready + B_lat_ext[0];
assign n_AAAB_fm = (n_AAAB_fb > n_AAA_fm) ?
                   n_AAAB_fb : n_AAA_fm;

// n_AABA
wire [6:0] n_AABA_sl;
wire [7:0] n_AABA_fa;
wire [6:0] n_AABA_fb;
wire [7:0] n_AABA_fm;

assign n_AABA_sl = (A_dependent && (n_AAB_fa > n_AAB_ready)) ?
                   n_AAB_fa : n_AAB_ready;
assign n_AABA_fa = n_AABA_sl + A_lat_ext[2];
assign n_AABA_fb = n_AAB_fb;
assign n_AABA_fm = (n_AABA_fa > n_AAB_fm) ?
                   n_AABA_fa : n_AAB_fm;

// n_AABB
wire [6:0] n_AABB_sl;
wire [6:0] n_AABB_fa;
wire [7:0] n_AABB_fb;
wire [7:0] n_AABB_fm;
assign n_AABB_sl = n_AAB_sl + B_step_0;
assign n_AABB_fa = n_AAB_fa;
assign n_AABB_fb = n_AAB_sl + B_pair_0;
assign n_AABB_fm = (n_AABB_fb > n_AAB_fm) ?
                   n_AABB_fb : n_AAB_fm;


// n_ABAA
wire [6:0] n_ABAA_sl;
wire [7:0] n_ABAA_fa;
wire [5:0] n_ABAA_fb;
wire [7:0] n_ABAA_fm;

assign n_ABAA_sl = n_ABA_sl + A_step_1;
assign n_ABAA_fa = n_ABA_sl + A_pair_1;
assign n_ABAA_fb = n_ABA_fb;
assign n_ABAA_fm = (n_ABAA_fa > n_ABA_fm) ?
                   n_ABAA_fa : n_ABA_fm;


// n_ABAB
wire [5:0] n_ABAB_sl;
wire [6:0] n_ABAB_fa;
wire [6:0] n_ABAB_fb;
wire [6:0] n_ABAB_fm;

assign n_ABAB_sl = (B_dependent && (n_ABA_fb > n_ABA_ready)) ?
                   n_ABA_fb : n_ABA_ready;
assign n_ABAB_fa = n_ABA_fa;
assign n_ABAB_fb = n_ABAB_sl + B_lat_ext[1];
assign n_ABAB_fm = (n_ABAB_fb > n_ABA_fm) ?
                   n_ABAB_fb : n_ABA_fm;


// n_ABBA
wire [5:0] n_ABBA_sl;
wire [6:0] n_ABBA_fa;
wire [6:0] n_ABBA_fb;
wire [6:0] n_ABBA_fm;

assign n_ABBA_sl = (A_dependent && (n_ABB_fa > n_ABB_ready)) ?
                   n_ABB_fa : n_ABB_ready;
assign n_ABBA_fa = n_ABBA_sl + A_lat_ext[1];
assign n_ABBA_fb = n_ABB_fb;
assign n_ABBA_fm = (n_ABBA_fa > n_ABB_fm) ?
                   n_ABBA_fa : n_ABB_fm;


// n_ABBB
wire [6:0] n_ABBB_sl;
wire [5:0] n_ABBB_fa;
wire [7:0] n_ABBB_fb;
wire [7:0] n_ABBB_fm;

assign n_ABBB_sl = n_ABB_sl + B_step_1;
assign n_ABBB_fa = n_ABB_fa;
assign n_ABBB_fb = n_ABB_sl + B_pair_1;
assign n_ABBB_fm = (n_ABBB_fb > n_ABB_fm) ?
                   n_ABBB_fb : n_ABB_fm;


// n_BAAA
wire [6:0] n_BAAA_sl;
wire [7:0] n_BAAA_fa;
wire [5:0] n_BAAA_fb;
wire [7:0] n_BAAA_fm;

assign n_BAAA_sl = n_BAA_sl + A_step_1;
assign n_BAAA_fa = n_BAA_sl + A_pair_1;
assign n_BAAA_fb = n_BAA_fb;
assign n_BAAA_fm = (n_BAAA_fa > n_BAA_fm) ?
                   n_BAAA_fa : n_BAA_fm;


// n_BAAB
wire [5:0] n_BAAB_sl;
wire [6:0] n_BAAB_fa;
wire [6:0] n_BAAB_fb;
wire [6:0] n_BAAB_fm;

assign n_BAAB_sl = (B_dependent && (n_BAA_fb > n_BAA_ready)) ?
                   n_BAA_fb : n_BAA_ready;
assign n_BAAB_fa = n_BAA_fa;
assign n_BAAB_fb = n_BAAB_sl + B_lat_ext[1];
assign n_BAAB_fm = (n_BAAB_fb > n_BAA_fm) ?
                   n_BAAB_fb : n_BAA_fm;


// n_BABA
wire [5:0] n_BABA_sl;
wire [6:0] n_BABA_fa;
wire [6:0] n_BABA_fb;
wire [6:0] n_BABA_fm;

assign n_BABA_sl = (A_dependent && (n_BAB_fa > n_BAB_ready)) ?
                   n_BAB_fa : n_BAB_ready;
assign n_BABA_fa = n_BABA_sl + A_lat_ext[1];
assign n_BABA_fb = n_BAB_fb;
assign n_BABA_fm = (n_BABA_fa > n_BAB_fm) ?
                   n_BABA_fa : n_BAB_fm;


// n_BABB
wire [6:0] n_BABB_sl;
wire [5:0] n_BABB_fa;
wire [7:0] n_BABB_fb;
wire [7:0] n_BABB_fm;

assign n_BABB_sl = n_BAB_sl + B_step_1;
assign n_BABB_fa = n_BAB_fa;
assign n_BABB_fb = n_BAB_sl + B_pair_1;
assign n_BABB_fm = (n_BABB_fb > n_BAB_fm) ?
                   n_BABB_fb : n_BAB_fm;


// n_BBAA
wire [6:0] n_BBAA_sl;
wire [7:0] n_BBAA_fa;
wire [6:0] n_BBAA_fb;
wire [7:0] n_BBAA_fm;

assign n_BBAA_sl = n_BBA_sl + A_step_0;
assign n_BBAA_fa = n_BBA_sl + A_pair_0;
assign n_BBAA_fb = n_BBA_fb;
assign n_BBAA_fm = (n_BBAA_fa > n_BBA_fm) ?
                   n_BBAA_fa : n_BBA_fm;


// n_BBAB
wire [6:0] n_BBAB_sl;
wire [6:0] n_BBAB_fa;
wire [7:0] n_BBAB_fb;
wire [7:0] n_BBAB_fm;

assign n_BBAB_sl = (B_dependent && (n_BBA_fb > n_BBA_ready)) ?
                   n_BBA_fb : n_BBA_ready;
assign n_BBAB_fa = n_BBA_fa;
assign n_BBAB_fb = n_BBAB_sl + B_lat_ext[2];
assign n_BBAB_fm = (n_BBAB_fb > n_BBA_fm) ?
                   n_BBAB_fb : n_BBA_fm;


// n_BBBA
wire [6:0] n_BBBA_sl;
wire [7:0] n_BBBA_fa;
wire [7:0] n_BBBA_fb;
wire [7:0] n_BBBA_fm;

assign n_BBBA_sl = n_BBB_ready;
assign n_BBBA_fa = n_BBB_ready + A_lat_ext[0];
assign n_BBBA_fb = n_BBB_fb;
assign n_BBBA_fm = (n_BBBA_fa > n_BBB_fm) ?
                   n_BBBA_fa : n_BBB_fm;


//////// DEPTH 5 ////////
// depth-4 branches
wire [7:0] n_AAAA_ready = n_AAAA_sl + 9'd1;
wire [6:0] n_AAAB_ready = n_AAAB_sl + 9'd1;
wire [6:0] n_AABA_ready = n_AABA_sl + 9'd1;
wire [6:0] n_AABB_ready = n_AABB_sl + 9'd1;
wire [6:0] n_ABAA_ready = n_ABAA_sl + 9'd1;
wire [5:0] n_ABAB_ready = n_ABAB_sl + 9'd1;
wire [5:0] n_ABBA_ready = n_ABBA_sl + 9'd1;
wire [6:0] n_ABBB_ready = n_ABBB_sl + 9'd1;
wire [6:0] n_BAAA_ready = n_BAAA_sl + 9'd1;
wire [5:0] n_BAAB_ready = n_BAAB_sl + 9'd1;
wire [5:0] n_BABA_ready = n_BABA_sl + 9'd1;
wire [6:0] n_BABB_ready = n_BABB_sl + 9'd1;
wire [6:0] n_BBAA_ready = n_BBAA_sl + 9'd1;
wire [6:0] n_BBAB_ready = n_BBAB_sl + 9'd1;
wire [6:0] n_BBBA_ready = n_BBBA_sl + 9'd1;

// n_AAAAA
wire [7:0] n_AAAAA_sl;
wire [7:0] n_AAAAA_fa;
wire [0:0] n_AAAAA_fb;
wire [7:0] n_AAAAA_fm;
assign n_AAAAA_sl = n_AAAA_sl + A_step_3;
assign n_AAAAA_fa = n_AAAA_sl + A_pair_3;
assign n_AAAAA_fb = n_AAAA_fb;
assign n_AAAAA_fm = (n_AAAAA_fa > n_AAAA_fm) ?
                    n_AAAAA_fa : n_AAAA_fm;

// n_AAAAB
wire [7:0] n_AAAAB_sl;
wire [7:0] n_AAAAB_fa;
wire [7:0] n_AAAAB_fb;
wire [7:0] n_AAAAB_fm;
assign n_AAAAB_sl = n_AAAA_ready;
assign n_AAAAB_fa = n_AAAA_fa;
assign n_AAAAB_fb = n_AAAA_ready + B_lat_ext[0];
assign n_AAAAB_fm = (n_AAAAB_fb > n_AAAA_fm) ?
                    n_AAAAB_fb : n_AAAA_fm;

// n_AAABA
wire [7:0] n_AAABA_sl;
wire [7:0] n_AAABA_fa;
wire [7:0] n_AAABA_fb;
wire [7:0] n_AAABA_fm;
assign n_AAABA_sl = (A_dependent && (n_AAAB_fa > n_AAAB_ready)) ?
                    n_AAAB_fa : n_AAAB_ready;
assign n_AAABA_fa = n_AAABA_sl + A_lat_ext[3];
assign n_AAABA_fb = n_AAAB_fb;
assign n_AAABA_fm = (n_AAABA_fa > n_AAAB_fm) ?
                    n_AAABA_fa : n_AAAB_fm;

// n_AAABB
wire [7:0] n_AAABB_sl;
wire [7:0] n_AAABB_fa;
wire [7:0] n_AAABB_fb;
wire [7:0] n_AAABB_fm;
assign n_AAABB_sl = n_AAAB_sl + B_step_0;
assign n_AAABB_fa = n_AAAB_fa;
assign n_AAABB_fb = n_AAAB_sl + B_pair_0;
assign n_AAABB_fm = (n_AAABB_fb > n_AAAB_fm) ?
                    n_AAABB_fb : n_AAAB_fm;

// n_AABAA
wire [7:0] n_AABAA_sl;
wire [7:0] n_AABAA_fa;
wire [6:0] n_AABAA_fb;
wire [7:0] n_AABAA_fm;
assign n_AABAA_sl = n_AABA_sl + A_step_2;
assign n_AABAA_fa = n_AABA_sl + A_pair_2;
assign n_AABAA_fb = n_AABA_fb;
assign n_AABAA_fm = (n_AABAA_fa > n_AABA_fm) ?
                    n_AABAA_fa : n_AABA_fm;

// n_AABAB
wire [6:0] n_AABAB_sl;
wire [7:0] n_AABAB_fa;
wire [7:0] n_AABAB_fb;
wire [7:0] n_AABAB_fm;
assign n_AABAB_sl = (B_dependent && (n_AABA_fb > n_AABA_ready)) ?
                    n_AABA_fb : n_AABA_ready;
assign n_AABAB_fa = n_AABA_fa;
assign n_AABAB_fb = n_AABAB_sl + B_lat_ext[1];
assign n_AABAB_fm = (n_AABAB_fb > n_AABA_fm) ?
                    n_AABAB_fb : n_AABA_fm;

// n_AABBA
wire [6:0] n_AABBA_sl;
wire [7:0] n_AABBA_fa;
wire [7:0] n_AABBA_fb;
wire [7:0] n_AABBA_fm;
assign n_AABBA_sl = (A_dependent && (n_AABB_fa > n_AABB_ready)) ?
                    n_AABB_fa : n_AABB_ready;
assign n_AABBA_fa = n_AABBA_sl + A_lat_ext[2];
assign n_AABBA_fb = n_AABB_fb;
assign n_AABBA_fm = (n_AABBA_fa > n_AABB_fm) ?
                    n_AABBA_fa : n_AABB_fm;

// n_AABBB
wire [7:0] n_AABBB_sl;
wire [6:0] n_AABBB_fa;
wire [7:0] n_AABBB_fb;
wire [7:0] n_AABBB_fm;
assign n_AABBB_sl = n_AABB_sl + B_step_1;
assign n_AABBB_fa = n_AABB_fa;
assign n_AABBB_fb = n_AABB_sl + B_pair_1;
assign n_AABBB_fm = (n_AABBB_fb > n_AABB_fm) ?
                    n_AABBB_fb : n_AABB_fm;

// n_ABAAA
wire [7:0] n_ABAAA_sl;
wire [7:0] n_ABAAA_fa;
wire [5:0] n_ABAAA_fb;
wire [7:0] n_ABAAA_fm;
assign n_ABAAA_sl = n_ABAA_sl + A_step_2;
assign n_ABAAA_fa = n_ABAA_sl + A_pair_2;
assign n_ABAAA_fb = n_ABAA_fb;
assign n_ABAAA_fm = (n_ABAAA_fa > n_ABAA_fm) ?
                    n_ABAAA_fa : n_ABAA_fm;

// n_ABAAB
wire [6:0] n_ABAAB_sl;
wire [7:0] n_ABAAB_fa;
wire [7:0] n_ABAAB_fb;
wire [7:0] n_ABAAB_fm;
assign n_ABAAB_sl = (B_dependent && (n_ABAA_fb > n_ABAA_ready)) ?
                    n_ABAA_fb : n_ABAA_ready;
assign n_ABAAB_fa = n_ABAA_fa;
assign n_ABAAB_fb = n_ABAAB_sl + B_lat_ext[1];
assign n_ABAAB_fm = (n_ABAAB_fb > n_ABAA_fm) ?
                    n_ABAAB_fb : n_ABAA_fm;

// n_ABABA
wire [6:0] n_ABABA_sl;
wire [7:0] n_ABABA_fa;
wire [6:0] n_ABABA_fb;
wire [7:0] n_ABABA_fm;
assign n_ABABA_sl = (A_dependent && (n_ABAB_fa > n_ABAB_ready)) ?
                    n_ABAB_fa : n_ABAB_ready;
assign n_ABABA_fa = n_ABABA_sl + A_lat_ext[2];
assign n_ABABA_fb = n_ABAB_fb;
assign n_ABABA_fm = (n_ABABA_fa > n_ABAB_fm) ?
                    n_ABABA_fa : n_ABAB_fm;

// n_ABABB
wire [6:0] n_ABABB_sl;
wire [6:0] n_ABABB_fa;
wire [7:0] n_ABABB_fb;
wire [7:0] n_ABABB_fm;
assign n_ABABB_sl = n_ABAB_sl + B_step_1;
assign n_ABABB_fa = n_ABAB_fa;
assign n_ABABB_fb = n_ABAB_sl + B_pair_1;
assign n_ABABB_fm = (n_ABABB_fb > n_ABAB_fm) ?
                    n_ABABB_fb : n_ABAB_fm;

// n_ABBAA
wire [6:0] n_ABBAA_sl;
wire [7:0] n_ABBAA_fa;
wire [6:0] n_ABBAA_fb;
wire [7:0] n_ABBAA_fm;
assign n_ABBAA_sl = n_ABBA_sl + A_step_1;
assign n_ABBAA_fa = n_ABBA_sl + A_pair_1;
assign n_ABBAA_fb = n_ABBA_fb;
assign n_ABBAA_fm = (n_ABBAA_fa > n_ABBA_fm) ?
                    n_ABBAA_fa : n_ABBA_fm;

// n_ABBAB
wire [6:0] n_ABBAB_sl;
wire [6:0] n_ABBAB_fa;
wire [7:0] n_ABBAB_fb;
wire [7:0] n_ABBAB_fm;
assign n_ABBAB_sl = (B_dependent && (n_ABBA_fb > n_ABBA_ready)) ?
                    n_ABBA_fb : n_ABBA_ready;
assign n_ABBAB_fa = n_ABBA_fa;
assign n_ABBAB_fb = n_ABBAB_sl + B_lat_ext[2];
assign n_ABBAB_fm = (n_ABBAB_fb > n_ABBA_fm) ?
                    n_ABBAB_fb : n_ABBA_fm;

// n_ABBBA
wire [6:0] n_ABBBA_sl;
wire [7:0] n_ABBBA_fa;
wire [7:0] n_ABBBA_fb;
wire [7:0] n_ABBBA_fm;
assign n_ABBBA_sl = (A_dependent && (n_ABBB_fa > n_ABBB_ready)) ?
                    n_ABBB_fa : n_ABBB_ready;
assign n_ABBBA_fa = n_ABBBA_sl + A_lat_ext[1];
assign n_ABBBA_fb = n_ABBB_fb;
assign n_ABBBA_fm = (n_ABBBA_fa > n_ABBB_fm) ?
                    n_ABBBA_fa : n_ABBB_fm;

// n_BAAAA
wire [7:0] n_BAAAA_sl;
wire [7:0] n_BAAAA_fa;
wire [5:0] n_BAAAA_fb;
wire [7:0] n_BAAAA_fm;
assign n_BAAAA_sl = n_BAAA_sl + A_step_2;
assign n_BAAAA_fa = n_BAAA_sl + A_pair_2;
assign n_BAAAA_fb = n_BAAA_fb;
assign n_BAAAA_fm = (n_BAAAA_fa > n_BAAA_fm) ?
                    n_BAAAA_fa : n_BAAA_fm;

// n_BAAAB
wire [6:0] n_BAAAB_sl;
wire [7:0] n_BAAAB_fa;
wire [7:0] n_BAAAB_fb;
wire [7:0] n_BAAAB_fm;
assign n_BAAAB_sl = (B_dependent && (n_BAAA_fb > n_BAAA_ready)) ?
                    n_BAAA_fb : n_BAAA_ready;
assign n_BAAAB_fa = n_BAAA_fa;
assign n_BAAAB_fb = n_BAAAB_sl + B_lat_ext[1];
assign n_BAAAB_fm = (n_BAAAB_fb > n_BAAA_fm) ?
                    n_BAAAB_fb : n_BAAA_fm;

// n_BAABA
wire [6:0] n_BAABA_sl;
wire [7:0] n_BAABA_fa;
wire [6:0] n_BAABA_fb;
wire [7:0] n_BAABA_fm;
assign n_BAABA_sl = (A_dependent && (n_BAAB_fa > n_BAAB_ready)) ?
                    n_BAAB_fa : n_BAAB_ready;
assign n_BAABA_fa = n_BAABA_sl + A_lat_ext[2];
assign n_BAABA_fb = n_BAAB_fb;
assign n_BAABA_fm = (n_BAABA_fa > n_BAAB_fm) ?
                    n_BAABA_fa : n_BAAB_fm;

// n_BAABB
wire [6:0] n_BAABB_sl;
wire [6:0] n_BAABB_fa;
wire [7:0] n_BAABB_fb;
wire [7:0] n_BAABB_fm;
assign n_BAABB_sl = n_BAAB_sl + B_step_1;
assign n_BAABB_fa = n_BAAB_fa;
assign n_BAABB_fb = n_BAAB_sl + B_pair_1;
assign n_BAABB_fm = (n_BAABB_fb > n_BAAB_fm) ?
                    n_BAABB_fb : n_BAAB_fm;

// n_BABAA
wire [6:0] n_BABAA_sl;
wire [7:0] n_BABAA_fa;
wire [6:0] n_BABAA_fb;
wire [7:0] n_BABAA_fm;
assign n_BABAA_sl = n_BABA_sl + A_step_1;
assign n_BABAA_fa = n_BABA_sl + A_pair_1;
assign n_BABAA_fb = n_BABA_fb;
assign n_BABAA_fm = (n_BABAA_fa > n_BABA_fm) ?
                    n_BABAA_fa : n_BABA_fm;

// n_BABAB
wire [6:0] n_BABAB_sl;
wire [6:0] n_BABAB_fa;
wire [7:0] n_BABAB_fb;
wire [7:0] n_BABAB_fm;
assign n_BABAB_sl = (B_dependent && (n_BABA_fb > n_BABA_ready)) ?
                    n_BABA_fb : n_BABA_ready;
assign n_BABAB_fa = n_BABA_fa;
assign n_BABAB_fb = n_BABAB_sl + B_lat_ext[2];
assign n_BABAB_fm = (n_BABAB_fb > n_BABA_fm) ?
                    n_BABAB_fb : n_BABA_fm;

// n_BABBA
wire [6:0] n_BABBA_sl;
wire [7:0] n_BABBA_fa;
wire [7:0] n_BABBA_fb;
wire [7:0] n_BABBA_fm;
assign n_BABBA_sl = (A_dependent && (n_BABB_fa > n_BABB_ready)) ?
                    n_BABB_fa : n_BABB_ready;
assign n_BABBA_fa = n_BABBA_sl + A_lat_ext[1];
assign n_BABBA_fb = n_BABB_fb;
assign n_BABBA_fm = (n_BABBA_fa > n_BABB_fm) ?
                    n_BABBA_fa : n_BABB_fm;

// n_BBAAA
wire [7:0] n_BBAAA_sl;
wire [7:0] n_BBAAA_fa;
wire [6:0] n_BBAAA_fb;
wire [7:0] n_BBAAA_fm;
assign n_BBAAA_sl = n_BBAA_sl + A_step_1;
assign n_BBAAA_fa = n_BBAA_sl + A_pair_1;
assign n_BBAAA_fb = n_BBAA_fb;
assign n_BBAAA_fm = (n_BBAAA_fa > n_BBAA_fm) ?
                    n_BBAAA_fa : n_BBAA_fm;

// n_BBAAB
wire [6:0] n_BBAAB_sl;
wire [7:0] n_BBAAB_fa;
wire [7:0] n_BBAAB_fb;
wire [7:0] n_BBAAB_fm;
assign n_BBAAB_sl = (B_dependent && (n_BBAA_fb > n_BBAA_ready)) ?
                    n_BBAA_fb : n_BBAA_ready;
assign n_BBAAB_fa = n_BBAA_fa;
assign n_BBAAB_fb = n_BBAAB_sl + B_lat_ext[2];
assign n_BBAAB_fm = (n_BBAAB_fb > n_BBAA_fm) ?
                    n_BBAAB_fb : n_BBAA_fm;

// n_BBABA
wire [6:0] n_BBABA_sl;
wire [7:0] n_BBABA_fa;
wire [7:0] n_BBABA_fb;
wire [7:0] n_BBABA_fm;
assign n_BBABA_sl = (A_dependent && (n_BBAB_fa > n_BBAB_ready)) ?
                    n_BBAB_fa : n_BBAB_ready;
assign n_BBABA_fa = n_BBABA_sl + A_lat_ext[1];
assign n_BBABA_fb = n_BBAB_fb;
assign n_BBABA_fm = (n_BBABA_fa > n_BBAB_fm) ?
                    n_BBABA_fa : n_BBAB_fm;

// n_BBBAA
wire [7:0] n_BBBAA_sl;
wire [7:0] n_BBBAA_fa;
wire [7:0] n_BBBAA_fb;
wire [7:0] n_BBBAA_fm;
assign n_BBBAA_sl = n_BBBA_sl + A_step_0;
assign n_BBBAA_fa = n_BBBA_sl + A_pair_0;
assign n_BBBAA_fb = n_BBBA_fb;
assign n_BBBAA_fm = (n_BBBAA_fa > n_BBBA_fm) ?
                    n_BBBAA_fa : n_BBBA_fm;

//////// DEPTH 6 ////////
// depth-5 branches
wire [7:0] n_AAAAA_ready = n_AAAAA_sl + 9'd1;
wire [7:0] n_AAAAB_ready = n_AAAAB_sl + 9'd1;
wire [7:0] n_AAABA_ready = n_AAABA_sl + 9'd1;
wire [7:0] n_AAABB_ready = n_AAABB_sl + 9'd1;
wire [7:0] n_AABAA_ready = n_AABAA_sl + 9'd1;
wire [6:0] n_AABAB_ready = n_AABAB_sl + 9'd1;
wire [6:0] n_AABBA_ready = n_AABBA_sl + 9'd1;
wire [7:0] n_AABBB_ready = n_AABBB_sl + 9'd1;
wire [7:0] n_ABAAA_ready = n_ABAAA_sl + 9'd1;
wire [6:0] n_ABAAB_ready = n_ABAAB_sl + 9'd1;
wire [6:0] n_ABABA_ready = n_ABABA_sl + 9'd1;
wire [6:0] n_ABABB_ready = n_ABABB_sl + 9'd1;
wire [6:0] n_ABBAA_ready = n_ABBAA_sl + 9'd1;
wire [6:0] n_ABBAB_ready = n_ABBAB_sl + 9'd1;
wire [6:0] n_ABBBA_ready = n_ABBBA_sl + 9'd1;
wire [7:0] n_BAAAA_ready = n_BAAAA_sl + 9'd1;
wire [6:0] n_BAAAB_ready = n_BAAAB_sl + 9'd1;
wire [6:0] n_BAABA_ready = n_BAABA_sl + 9'd1;
wire [6:0] n_BAABB_ready = n_BAABB_sl + 9'd1;
wire [6:0] n_BABAA_ready = n_BABAA_sl + 9'd1;
wire [6:0] n_BABAB_ready = n_BABAB_sl + 9'd1;
wire [6:0] n_BABBA_ready = n_BABBA_sl + 9'd1;
wire [7:0] n_BBAAA_ready = n_BBAAA_sl + 9'd1;
wire [6:0] n_BBAAB_ready = n_BBAAB_sl + 9'd1;
wire [6:0] n_BBABA_ready = n_BBABA_sl + 9'd1;
wire [7:0] n_BBBAA_ready = n_BBBAA_sl + 9'd1;

// n_AAAAAA
wire [7:0] n_AAAAAA_sl;
wire [8:0] n_AAAAAA_fa;
wire [0:0] n_AAAAAA_fb;
wire [8:0] n_AAAAAA_fm;
assign n_AAAAAA_sl = n_AAAAA_sl + A_step_4;
assign n_AAAAAA_fa = n_AAAAA_sl + A_pair_4;
assign n_AAAAAA_fb = n_AAAAA_fb;
assign n_AAAAAA_fm = (n_AAAAAA_fa > n_AAAAA_fm) ?
                     n_AAAAAA_fa : n_AAAAA_fm;

// n_AAAAAB
wire [7:0] n_AAAAAB_sl;
wire [7:0] n_AAAAAB_fa;
wire [7:0] n_AAAAAB_fb;
wire [7:0] n_AAAAAB_fm;
assign n_AAAAAB_sl = n_AAAAA_ready;
assign n_AAAAAB_fa = n_AAAAA_fa;
assign n_AAAAAB_fb = n_AAAAAB_sl + B_lat_ext[0];
assign n_AAAAAB_fm = (n_AAAAAB_fb > n_AAAAA_fm) ?
                     n_AAAAAB_fb : n_AAAAA_fm;

// n_AAAABA
wire [7:0] n_AAAABA_sl;
wire [7:0] n_AAAABA_fa;
wire [7:0] n_AAAABA_fb;
wire [7:0] n_AAAABA_fm;
assign n_AAAABA_sl = (A_dependent && (n_AAAAB_fa > n_AAAAB_ready)) ?
                     n_AAAAB_fa : n_AAAAB_ready;
assign n_AAAABA_fa = n_AAAABA_sl + A_lat_ext[4];
assign n_AAAABA_fb = n_AAAAB_fb;
assign n_AAAABA_fm = (n_AAAABA_fa > n_AAAAB_fm) ?
                     n_AAAABA_fa : n_AAAAB_fm;

// n_AAAABB
wire [7:0] n_AAAABB_sl;
wire [7:0] n_AAAABB_fa;
wire [7:0] n_AAAABB_fb;
wire [7:0] n_AAAABB_fm;
assign n_AAAABB_sl = n_AAAAB_sl + B_step_0;
assign n_AAAABB_fa = n_AAAAB_fa;
assign n_AAAABB_fb = n_AAAAB_sl + B_pair_0;
assign n_AAAABB_fm = (n_AAAABB_fb > n_AAAAB_fm) ?
                     n_AAAABB_fb : n_AAAAB_fm;

// n_AAABAA
wire [7:0] n_AAABAA_sl;
wire [7:0] n_AAABAA_fa;
wire [7:0] n_AAABAA_fb;
wire [7:0] n_AAABAA_fm;
assign n_AAABAA_sl = n_AAABA_sl + A_step_3;
assign n_AAABAA_fa = n_AAABA_sl + A_pair_3;
assign n_AAABAA_fb = n_AAABA_fb;
assign n_AAABAA_fm = (n_AAABAA_fa > n_AAABA_fm) ?
                     n_AAABAA_fa : n_AAABA_fm;

// n_AAABAB
wire [7:0] n_AAABAB_sl;
wire [7:0] n_AAABAB_fa;
wire [7:0] n_AAABAB_fb;
wire [7:0] n_AAABAB_fm;
assign n_AAABAB_sl = (B_dependent && (n_AAABA_fb > n_AAABA_ready)) ?
                     n_AAABA_fb : n_AAABA_ready;
assign n_AAABAB_fa = n_AAABA_fa;
assign n_AAABAB_fb = n_AAABAB_sl + B_lat_ext[1];
assign n_AAABAB_fm = (n_AAABAB_fb > n_AAABA_fm) ?
                     n_AAABAB_fb : n_AAABA_fm;

// n_AAABBA
wire [7:0] n_AAABBA_sl;
wire [7:0] n_AAABBA_fa;
wire [7:0] n_AAABBA_fb;
wire [7:0] n_AAABBA_fm;
assign n_AAABBA_sl = (A_dependent && (n_AAABB_fa > n_AAABB_ready)) ?
                     n_AAABB_fa : n_AAABB_ready;
assign n_AAABBA_fa = n_AAABBA_sl + A_lat_ext[3];
assign n_AAABBA_fb = n_AAABB_fb;
assign n_AAABBA_fm = (n_AAABBA_fa > n_AAABB_fm) ?
                     n_AAABBA_fa : n_AAABB_fm;

// n_AAABBB
wire [7:0] n_AAABBB_sl;
wire [7:0] n_AAABBB_fa;
wire [7:0] n_AAABBB_fb;
wire [7:0] n_AAABBB_fm;
assign n_AAABBB_sl = n_AAABB_sl + B_step_1;
assign n_AAABBB_fa = n_AAABB_fa;
assign n_AAABBB_fb = n_AAABB_sl + B_pair_1;
assign n_AAABBB_fm = (n_AAABBB_fb > n_AAABB_fm) ?
                     n_AAABBB_fb : n_AAABB_fm;

// n_AABAAA
wire [7:0] n_AABAAA_sl;
wire [7:0] n_AABAAA_fa;
wire [6:0] n_AABAAA_fb;
wire [7:0] n_AABAAA_fm;
assign n_AABAAA_sl = n_AABAA_sl + A_step_3;
assign n_AABAAA_fa = n_AABAA_sl + A_pair_3;
assign n_AABAAA_fb = n_AABAA_fb;
assign n_AABAAA_fm = (n_AABAAA_fa > n_AABAA_fm) ?
                     n_AABAAA_fa : n_AABAA_fm;

// n_AABAAB
wire [7:0] n_AABAAB_sl;
wire [7:0] n_AABAAB_fa;
wire [7:0] n_AABAAB_fb;
wire [7:0] n_AABAAB_fm;
assign n_AABAAB_sl = (B_dependent && (n_AABAA_fb > n_AABAA_ready)) ?
                     n_AABAA_fb : n_AABAA_ready;
assign n_AABAAB_fa = n_AABAA_fa;
assign n_AABAAB_fb = n_AABAAB_sl + B_lat_ext[1];
assign n_AABAAB_fm = (n_AABAAB_fb > n_AABAA_fm) ?
                     n_AABAAB_fb : n_AABAA_fm;

// n_AABABA
wire [7:0] n_AABABA_sl;
wire [7:0] n_AABABA_fa;
wire [7:0] n_AABABA_fb;
wire [7:0] n_AABABA_fm;
assign n_AABABA_sl = (A_dependent && (n_AABAB_fa > n_AABAB_ready)) ?
                     n_AABAB_fa : n_AABAB_ready;
assign n_AABABA_fa = n_AABABA_sl + A_lat_ext[3];
assign n_AABABA_fb = n_AABAB_fb;
assign n_AABABA_fm = (n_AABABA_fa > n_AABAB_fm) ?
                     n_AABABA_fa : n_AABAB_fm;

// n_AABABB
wire [7:0] n_AABABB_sl;
wire [7:0] n_AABABB_fa;
wire [7:0] n_AABABB_fb;
wire [7:0] n_AABABB_fm;
assign n_AABABB_sl = n_AABAB_sl + B_step_1;
assign n_AABABB_fa = n_AABAB_fa;
assign n_AABABB_fb = n_AABAB_sl + B_pair_1;
assign n_AABABB_fm = (n_AABABB_fb > n_AABAB_fm) ?
                     n_AABABB_fb : n_AABAB_fm;

// n_AABBAA
wire [7:0] n_AABBAA_sl;
wire [7:0] n_AABBAA_fa;
wire [7:0] n_AABBAA_fb;
wire [7:0] n_AABBAA_fm;
assign n_AABBAA_sl = n_AABBA_sl + A_step_2;
assign n_AABBAA_fa = n_AABBA_sl + A_pair_2;
assign n_AABBAA_fb = n_AABBA_fb;
assign n_AABBAA_fm = (n_AABBAA_fa > n_AABBA_fm) ?
                     n_AABBAA_fa : n_AABBA_fm;

// n_AABBAB
wire [7:0] n_AABBAB_sl;
wire [7:0] n_AABBAB_fa;
wire [7:0] n_AABBAB_fb;
wire [7:0] n_AABBAB_fm;
assign n_AABBAB_sl = (B_dependent && (n_AABBA_fb > n_AABBA_ready)) ?
                     n_AABBA_fb : n_AABBA_ready;
assign n_AABBAB_fa = n_AABBA_fa;
assign n_AABBAB_fb = n_AABBAB_sl + B_lat_ext[2];
assign n_AABBAB_fm = (n_AABBAB_fb > n_AABBA_fm) ?
                     n_AABBAB_fb : n_AABBA_fm;

// n_AABBBA
wire [7:0] n_AABBBA_sl;
wire [7:0] n_AABBBA_fa;
wire [7:0] n_AABBBA_fb;
wire [7:0] n_AABBBA_fm;
assign n_AABBBA_sl = (A_dependent && (n_AABBB_fa > n_AABBB_ready)) ?
                     n_AABBB_fa : n_AABBB_ready;
assign n_AABBBA_fa = n_AABBBA_sl + A_lat_ext[2];
assign n_AABBBA_fb = n_AABBB_fb;
assign n_AABBBA_fm = (n_AABBBA_fa > n_AABBB_fm) ?
                     n_AABBBA_fa : n_AABBB_fm;

// n_ABAAAA
wire [7:0] n_ABAAAA_sl;
wire [7:0] n_ABAAAA_fa;
wire [5:0] n_ABAAAA_fb;
wire [7:0] n_ABAAAA_fm;
assign n_ABAAAA_sl = n_ABAAA_sl + A_step_3;
assign n_ABAAAA_fa = n_ABAAA_sl + A_pair_3;
assign n_ABAAAA_fb = n_ABAAA_fb;
assign n_ABAAAA_fm = (n_ABAAAA_fa > n_ABAAA_fm) ?
                     n_ABAAAA_fa : n_ABAAA_fm;

// n_ABAAAB
wire [7:0] n_ABAAAB_sl;
wire [7:0] n_ABAAAB_fa;
wire [7:0] n_ABAAAB_fb;
wire [7:0] n_ABAAAB_fm;
assign n_ABAAAB_sl = (B_dependent && (n_ABAAA_fb > n_ABAAA_ready)) ?
                     n_ABAAA_fb : n_ABAAA_ready;
assign n_ABAAAB_fa = n_ABAAA_fa;
assign n_ABAAAB_fb = n_ABAAAB_sl + B_lat_ext[1];
assign n_ABAAAB_fm = (n_ABAAAB_fb > n_ABAAA_fm) ?
                     n_ABAAAB_fb : n_ABAAA_fm;

// n_ABAABA
wire [7:0] n_ABAABA_sl;
wire [7:0] n_ABAABA_fa;
wire [7:0] n_ABAABA_fb;
wire [7:0] n_ABAABA_fm;
assign n_ABAABA_sl = (A_dependent && (n_ABAAB_fa > n_ABAAB_ready)) ?
                     n_ABAAB_fa : n_ABAAB_ready;
assign n_ABAABA_fa = n_ABAABA_sl + A_lat_ext[3];
assign n_ABAABA_fb = n_ABAAB_fb;
assign n_ABAABA_fm = (n_ABAABA_fa > n_ABAAB_fm) ?
                     n_ABAABA_fa : n_ABAAB_fm;

// n_ABAABB
wire [7:0] n_ABAABB_sl;
wire [7:0] n_ABAABB_fa;
wire [7:0] n_ABAABB_fb;
wire [7:0] n_ABAABB_fm;
assign n_ABAABB_sl = n_ABAAB_sl + B_step_1;
assign n_ABAABB_fa = n_ABAAB_fa;
assign n_ABAABB_fb = n_ABAAB_sl + B_pair_1;
assign n_ABAABB_fm = (n_ABAABB_fb > n_ABAAB_fm) ?
                     n_ABAABB_fb : n_ABAAB_fm;

// n_ABABAA
wire [7:0] n_ABABAA_sl;
wire [7:0] n_ABABAA_fa;
wire [6:0] n_ABABAA_fb;
wire [7:0] n_ABABAA_fm;
assign n_ABABAA_sl = n_ABABA_sl + A_step_2;
assign n_ABABAA_fa = n_ABABA_sl + A_pair_2;
assign n_ABABAA_fb = n_ABABA_fb;
assign n_ABABAA_fm = (n_ABABAA_fa > n_ABABA_fm) ?
                     n_ABABAA_fa : n_ABABA_fm;

// n_ABABAB
wire [6:0] n_ABABAB_sl;
wire [7:0] n_ABABAB_fa;
wire [7:0] n_ABABAB_fb;
wire [7:0] n_ABABAB_fm;
assign n_ABABAB_sl = (B_dependent && (n_ABABA_fb > n_ABABA_ready)) ?
                     n_ABABA_fb : n_ABABA_ready;
assign n_ABABAB_fa = n_ABABA_fa;
assign n_ABABAB_fb = n_ABABAB_sl + B_lat_ext[2];
assign n_ABABAB_fm = (n_ABABAB_fb > n_ABABA_fm) ?
                     n_ABABAB_fb : n_ABABA_fm;

// n_ABABBA
wire [6:0] n_ABABBA_sl;
wire [7:0] n_ABABBA_fa;
wire [7:0] n_ABABBA_fb;
wire [7:0] n_ABABBA_fm;
assign n_ABABBA_sl = (A_dependent && (n_ABABB_fa > n_ABABB_ready)) ?
                     n_ABABB_fa : n_ABABB_ready;
assign n_ABABBA_fa = n_ABABBA_sl + A_lat_ext[2];
assign n_ABABBA_fb = n_ABABB_fb;
assign n_ABABBA_fm = (n_ABABBA_fa > n_ABABB_fm) ?
                     n_ABABBA_fa : n_ABABB_fm;

// n_ABBAAA
wire [7:0] n_ABBAAA_sl;
wire [7:0] n_ABBAAA_fa;
wire [6:0] n_ABBAAA_fb;
wire [7:0] n_ABBAAA_fm;
assign n_ABBAAA_sl = n_ABBAA_sl + A_step_2;
assign n_ABBAAA_fa = n_ABBAA_sl + A_pair_2;
assign n_ABBAAA_fb = n_ABBAA_fb;
assign n_ABBAAA_fm = (n_ABBAAA_fa > n_ABBAA_fm) ?
                     n_ABBAAA_fa : n_ABBAA_fm;

// n_ABBAAB
wire [6:0] n_ABBAAB_sl;
wire [7:0] n_ABBAAB_fa;
wire [7:0] n_ABBAAB_fb;
wire [7:0] n_ABBAAB_fm;
assign n_ABBAAB_sl = (B_dependent && (n_ABBAA_fb > n_ABBAA_ready)) ?
                     n_ABBAA_fb : n_ABBAA_ready;
assign n_ABBAAB_fa = n_ABBAA_fa;
assign n_ABBAAB_fb = n_ABBAAB_sl + B_lat_ext[2];
assign n_ABBAAB_fm = (n_ABBAAB_fb > n_ABBAA_fm) ?
                     n_ABBAAB_fb : n_ABBAA_fm;

// n_ABBABA
wire [6:0] n_ABBABA_sl;
wire [7:0] n_ABBABA_fa;
wire [7:0] n_ABBABA_fb;
wire [7:0] n_ABBABA_fm;
assign n_ABBABA_sl = (A_dependent && (n_ABBAB_fa > n_ABBAB_ready)) ?
                     n_ABBAB_fa : n_ABBAB_ready;
assign n_ABBABA_fa = n_ABBABA_sl + A_lat_ext[2];
assign n_ABBABA_fb = n_ABBAB_fb;
assign n_ABBABA_fm = (n_ABBABA_fa > n_ABBAB_fm) ?
                     n_ABBABA_fa : n_ABBAB_fm;

// n_ABBBAA
wire [7:0] n_ABBBAA_sl;
wire [7:0] n_ABBBAA_fa;
wire [7:0] n_ABBBAA_fb;
wire [7:0] n_ABBBAA_fm;
assign n_ABBBAA_sl = n_ABBBA_sl + A_step_1;
assign n_ABBBAA_fa = n_ABBBA_sl + A_pair_1;
assign n_ABBBAA_fb = n_ABBBA_fb;
assign n_ABBBAA_fm = (n_ABBBAA_fa > n_ABBBA_fm) ?
                     n_ABBBAA_fa : n_ABBBA_fm;

// n_BAAAAA
wire [7:0] n_BAAAAA_sl;
wire [7:0] n_BAAAAA_fa;
wire [5:0] n_BAAAAA_fb;
wire [7:0] n_BAAAAA_fm;
assign n_BAAAAA_sl = n_BAAAA_sl + A_step_3;
assign n_BAAAAA_fa = n_BAAAA_sl + A_pair_3;
assign n_BAAAAA_fb = n_BAAAA_fb;
assign n_BAAAAA_fm = (n_BAAAAA_fa > n_BAAAA_fm) ?
                     n_BAAAAA_fa : n_BAAAA_fm;

// n_BAAAAB
wire [7:0] n_BAAAAB_sl;
wire [7:0] n_BAAAAB_fa;
wire [7:0] n_BAAAAB_fb;
wire [7:0] n_BAAAAB_fm;
assign n_BAAAAB_sl = (B_dependent && (n_BAAAA_fb > n_BAAAA_ready)) ?
                     n_BAAAA_fb : n_BAAAA_ready;
assign n_BAAAAB_fa = n_BAAAA_fa;
assign n_BAAAAB_fb = n_BAAAAB_sl + B_lat_ext[1];
assign n_BAAAAB_fm = (n_BAAAAB_fb > n_BAAAA_fm) ?
                     n_BAAAAB_fb : n_BAAAA_fm;

// n_BAAABA
wire [7:0] n_BAAABA_sl;
wire [7:0] n_BAAABA_fa;
wire [7:0] n_BAAABA_fb;
wire [7:0] n_BAAABA_fm;
assign n_BAAABA_sl = (A_dependent && (n_BAAAB_fa > n_BAAAB_ready)) ?
                     n_BAAAB_fa : n_BAAAB_ready;
assign n_BAAABA_fa = n_BAAABA_sl + A_lat_ext[3];
assign n_BAAABA_fb = n_BAAAB_fb;
assign n_BAAABA_fm = (n_BAAABA_fa > n_BAAAB_fm) ?
                     n_BAAABA_fa : n_BAAAB_fm;

// n_BAAABB
wire [7:0] n_BAAABB_sl;
wire [7:0] n_BAAABB_fa;
wire [7:0] n_BAAABB_fb;
wire [7:0] n_BAAABB_fm;
assign n_BAAABB_sl = n_BAAAB_sl + B_step_1;
assign n_BAAABB_fa = n_BAAAB_fa;
assign n_BAAABB_fb = n_BAAAB_sl + B_pair_1;
assign n_BAAABB_fm = (n_BAAABB_fb > n_BAAAB_fm) ?
                     n_BAAABB_fb : n_BAAAB_fm;

// n_BAABAA
wire [7:0] n_BAABAA_sl;
wire [7:0] n_BAABAA_fa;
wire [6:0] n_BAABAA_fb;
wire [7:0] n_BAABAA_fm;
assign n_BAABAA_sl = n_BAABA_sl + A_step_2;
assign n_BAABAA_fa = n_BAABA_sl + A_pair_2;
assign n_BAABAA_fb = n_BAABA_fb;
assign n_BAABAA_fm = (n_BAABAA_fa > n_BAABA_fm) ?
                     n_BAABAA_fa : n_BAABA_fm;

// n_BAABAB
wire [6:0] n_BAABAB_sl;
wire [7:0] n_BAABAB_fa;
wire [7:0] n_BAABAB_fb;
wire [7:0] n_BAABAB_fm;
assign n_BAABAB_sl = (B_dependent && (n_BAABA_fb > n_BAABA_ready)) ?
                     n_BAABA_fb : n_BAABA_ready;
assign n_BAABAB_fa = n_BAABA_fa;
assign n_BAABAB_fb = n_BAABAB_sl + B_lat_ext[2];
assign n_BAABAB_fm = (n_BAABAB_fb > n_BAABA_fm) ?
                     n_BAABAB_fb : n_BAABA_fm;

// n_BAABBA
wire [6:0] n_BAABBA_sl;
wire [7:0] n_BAABBA_fa;
wire [7:0] n_BAABBA_fb;
wire [7:0] n_BAABBA_fm;
assign n_BAABBA_sl = (A_dependent && (n_BAABB_fa > n_BAABB_ready)) ?
                     n_BAABB_fa : n_BAABB_ready;
assign n_BAABBA_fa = n_BAABBA_sl + A_lat_ext[2];
assign n_BAABBA_fb = n_BAABB_fb;
assign n_BAABBA_fm = (n_BAABBA_fa > n_BAABB_fm) ?
                     n_BAABBA_fa : n_BAABB_fm;

// n_BABAAA
wire [7:0] n_BABAAA_sl;
wire [7:0] n_BABAAA_fa;
wire [6:0] n_BABAAA_fb;
wire [7:0] n_BABAAA_fm;
assign n_BABAAA_sl = n_BABAA_sl + A_step_2;
assign n_BABAAA_fa = n_BABAA_sl + A_pair_2;
assign n_BABAAA_fb = n_BABAA_fb;
assign n_BABAAA_fm = (n_BABAAA_fa > n_BABAA_fm) ?
                     n_BABAAA_fa : n_BABAA_fm;

// n_BABAAB
wire [6:0] n_BABAAB_sl;
wire [7:0] n_BABAAB_fa;
wire [7:0] n_BABAAB_fb;
wire [7:0] n_BABAAB_fm;
assign n_BABAAB_sl = (B_dependent && (n_BABAA_fb > n_BABAA_ready)) ?
                     n_BABAA_fb : n_BABAA_ready;
assign n_BABAAB_fa = n_BABAA_fa;
assign n_BABAAB_fb = n_BABAAB_sl + B_lat_ext[2];
assign n_BABAAB_fm = (n_BABAAB_fb > n_BABAA_fm) ?
                     n_BABAAB_fb : n_BABAA_fm;

// n_BABABA
wire [6:0] n_BABABA_sl;
wire [7:0] n_BABABA_fa;
wire [7:0] n_BABABA_fb;
wire [7:0] n_BABABA_fm;
assign n_BABABA_sl = (A_dependent && (n_BABAB_fa > n_BABAB_ready)) ?
                     n_BABAB_fa : n_BABAB_ready;
assign n_BABABA_fa = n_BABABA_sl + A_lat_ext[2];
assign n_BABABA_fb = n_BABAB_fb;
assign n_BABABA_fm = (n_BABABA_fa > n_BABAB_fm) ?
                     n_BABABA_fa : n_BABAB_fm;

// n_BABBAA
wire [7:0] n_BABBAA_sl;
wire [7:0] n_BABBAA_fa;
wire [7:0] n_BABBAA_fb;
wire [7:0] n_BABBAA_fm;
assign n_BABBAA_sl = n_BABBA_sl + A_step_1;
assign n_BABBAA_fa = n_BABBA_sl + A_pair_1;
assign n_BABBAA_fb = n_BABBA_fb;
assign n_BABBAA_fm = (n_BABBAA_fa > n_BABBA_fm) ?
                     n_BABBAA_fa : n_BABBA_fm;

// n_BBAAAA
wire [7:0] n_BBAAAA_sl;
wire [7:0] n_BBAAAA_fa;
wire [6:0] n_BBAAAA_fb;
wire [7:0] n_BBAAAA_fm;
assign n_BBAAAA_sl = n_BBAAA_sl + A_step_2;
assign n_BBAAAA_fa = n_BBAAA_sl + A_pair_2;
assign n_BBAAAA_fb = n_BBAAA_fb;
assign n_BBAAAA_fm = (n_BBAAAA_fa > n_BBAAA_fm) ?
                     n_BBAAAA_fa : n_BBAAA_fm;

// n_BBAAAB
wire [7:0] n_BBAAAB_sl;
wire [7:0] n_BBAAAB_fa;
wire [7:0] n_BBAAAB_fb;
wire [7:0] n_BBAAAB_fm;
assign n_BBAAAB_sl = (B_dependent && (n_BBAAA_fb > n_BBAAA_ready)) ?
                     n_BBAAA_fb : n_BBAAA_ready;
assign n_BBAAAB_fa = n_BBAAA_fa;
assign n_BBAAAB_fb = n_BBAAAB_sl + B_lat_ext[2];
assign n_BBAAAB_fm = (n_BBAAAB_fb > n_BBAAA_fm) ?
                     n_BBAAAB_fb : n_BBAAA_fm;

// n_BBAABA
wire [7:0] n_BBAABA_sl;
wire [7:0] n_BBAABA_fa;
wire [7:0] n_BBAABA_fb;
wire [7:0] n_BBAABA_fm;
assign n_BBAABA_sl = (A_dependent && (n_BBAAB_fa > n_BBAAB_ready)) ?
                     n_BBAAB_fa : n_BBAAB_ready;
assign n_BBAABA_fa = n_BBAABA_sl + A_lat_ext[2];
assign n_BBAABA_fb = n_BBAAB_fb;
assign n_BBAABA_fm = (n_BBAABA_fa > n_BBAAB_fm) ?
                     n_BBAABA_fa : n_BBAAB_fm;

// n_BBABAA
wire [7:0] n_BBABAA_sl;
wire [7:0] n_BBABAA_fa;
wire [7:0] n_BBABAA_fb;
wire [7:0] n_BBABAA_fm;
assign n_BBABAA_sl = n_BBABA_sl + A_step_1;
assign n_BBABAA_fa = n_BBABA_sl + A_pair_1;
assign n_BBABAA_fb = n_BBABA_fb;
assign n_BBABAA_fm = (n_BBABAA_fa > n_BBABA_fm) ?
                     n_BBABAA_fa : n_BBABA_fm;

// n_BBBAAA
wire [7:0] n_BBBAAA_sl;
wire [7:0] n_BBBAAA_fa;
wire [7:0] n_BBBAAA_fb;
wire [7:0] n_BBBAAA_fm;
assign n_BBBAAA_sl = n_BBBAA_sl + A_step_1;
assign n_BBBAAA_fa = n_BBBAA_sl + A_pair_1;
assign n_BBBAAA_fb = n_BBBAA_fb;
assign n_BBBAAA_fm = (n_BBBAAA_fa > n_BBBAA_fm) ?
                     n_BBBAAA_fa : n_BBBAA_fm;



//////// DEPTH 7 ////////
// depth-6 branches
wire [7:0] n_AAAAAA_ready = n_AAAAAA_sl + 9'd1;
wire [7:0] n_AAAAAB_ready = n_AAAAAB_sl + 9'd1;
wire [7:0] n_AAAABA_ready = n_AAAABA_sl + 9'd1;
wire [7:0] n_AAAABB_ready = n_AAAABB_sl + 9'd1;
wire [7:0] n_AAABAA_ready = n_AAABAA_sl + 9'd1;
wire [7:0] n_AAABAB_ready = n_AAABAB_sl + 9'd1;
wire [7:0] n_AAABBA_ready = n_AAABBA_sl + 9'd1;
wire [7:0] n_AAABBB_ready = n_AAABBB_sl + 9'd1;
wire [7:0] n_AABAAA_ready = n_AABAAA_sl + 9'd1;
wire [7:0] n_AABAAB_ready = n_AABAAB_sl + 9'd1;
wire [7:0] n_AABABA_ready = n_AABABA_sl + 9'd1;
wire [7:0] n_AABABB_ready = n_AABABB_sl + 9'd1;
wire [7:0] n_AABBAA_ready = n_AABBAA_sl + 9'd1;
wire [7:0] n_AABBAB_ready = n_AABBAB_sl + 9'd1;
wire [7:0] n_AABBBA_ready = n_AABBBA_sl + 9'd1;
wire [7:0] n_ABAAAA_ready = n_ABAAAA_sl + 9'd1;
wire [7:0] n_ABAAAB_ready = n_ABAAAB_sl + 9'd1;
wire [7:0] n_ABAABA_ready = n_ABAABA_sl + 9'd1;
wire [7:0] n_ABAABB_ready = n_ABAABB_sl + 9'd1;
wire [7:0] n_ABABAA_ready = n_ABABAA_sl + 9'd1;
wire [6:0] n_ABABAB_ready = n_ABABAB_sl + 9'd1;
wire [6:0] n_ABABBA_ready = n_ABABBA_sl + 9'd1;
wire [7:0] n_ABBAAA_ready = n_ABBAAA_sl + 9'd1;
wire [6:0] n_ABBAAB_ready = n_ABBAAB_sl + 9'd1;
wire [6:0] n_ABBABA_ready = n_ABBABA_sl + 9'd1;
wire [7:0] n_ABBBAA_ready = n_ABBBAA_sl + 9'd1;
wire [7:0] n_BAAAAA_ready = n_BAAAAA_sl + 9'd1;
wire [7:0] n_BAAAAB_ready = n_BAAAAB_sl + 9'd1;
wire [7:0] n_BAAABA_ready = n_BAAABA_sl + 9'd1;
wire [7:0] n_BAAABB_ready = n_BAAABB_sl + 9'd1;
wire [7:0] n_BAABAA_ready = n_BAABAA_sl + 9'd1;
wire [6:0] n_BAABAB_ready = n_BAABAB_sl + 9'd1;
wire [6:0] n_BAABBA_ready = n_BAABBA_sl + 9'd1;
wire [7:0] n_BABAAA_ready = n_BABAAA_sl + 9'd1;
wire [6:0] n_BABAAB_ready = n_BABAAB_sl + 9'd1;
wire [6:0] n_BABABA_ready = n_BABABA_sl + 9'd1;
wire [7:0] n_BABBAA_ready = n_BABBAA_sl + 9'd1;
wire [7:0] n_BBAAAA_ready = n_BBAAAA_sl + 9'd1;
wire [7:0] n_BBAAAB_ready = n_BBAAAB_sl + 9'd1;
wire [7:0] n_BBAABA_ready = n_BBAABA_sl + 9'd1;
wire [7:0] n_BBABAA_ready = n_BBABAA_sl + 9'd1;
wire [7:0] n_BBBAAA_ready = n_BBBAAA_sl + 9'd1;

// n_AAAAAAA
wire [8:0] n_AAAAAAA_sl;
wire [8:0] n_AAAAAAA_fa;
wire [0:0] n_AAAAAAA_fb;
wire [8:0] n_AAAAAAA_fm;
assign n_AAAAAAA_sl = n_AAAAAA_sl + A_step_5;
assign n_AAAAAAA_fa = n_AAAAAA_sl + A_pair_5;
assign n_AAAAAAA_fb = n_AAAAAA_fb;
assign n_AAAAAAA_fm = (n_AAAAAAA_fa > n_AAAAAA_fm) ?
                     n_AAAAAAA_fa : n_AAAAAA_fm;

// n_AAAAAAB
wire [7:0] n_AAAAAAB_sl;
wire [8:0] n_AAAAAAB_fa;
wire [8:0] n_AAAAAAB_fb;
wire [8:0] n_AAAAAAB_fm;
assign n_AAAAAAB_sl = n_AAAAAA_ready;
assign n_AAAAAAB_fa = n_AAAAAA_fa;
assign n_AAAAAAB_fb = n_AAAAAAB_sl + B_lat_ext[0];
assign n_AAAAAAB_fm = (n_AAAAAAB_fb > n_AAAAAA_fm) ?
                     n_AAAAAAB_fb : n_AAAAAA_fm;

// n_AAAAABA
wire [7:0] n_AAAAABA_sl;
wire [8:0] n_AAAAABA_fa;
wire [7:0] n_AAAAABA_fb;
wire [8:0] n_AAAAABA_fm;
assign n_AAAAABA_sl = (A_dependent && (n_AAAAAB_fa > n_AAAAAB_ready)) ?
                     n_AAAAAB_fa : n_AAAAAB_ready;
assign n_AAAAABA_fa = n_AAAAABA_sl + A_lat_ext[5];
assign n_AAAAABA_fb = n_AAAAAB_fb;
assign n_AAAAABA_fm = (n_AAAAABA_fa > n_AAAAAB_fm) ?
                     n_AAAAABA_fa : n_AAAAAB_fm;

// n_AAAAABB
wire [7:0] n_AAAAABB_sl;
wire [7:0] n_AAAAABB_fa;
wire [8:0] n_AAAAABB_fb;
wire [8:0] n_AAAAABB_fm;
assign n_AAAAABB_sl = n_AAAAAB_sl + B_step_0;
assign n_AAAAABB_fa = n_AAAAAB_fa;
assign n_AAAAABB_fb = n_AAAAAB_sl + B_pair_0;
assign n_AAAAABB_fm = (n_AAAAABB_fb > n_AAAAAB_fm) ?
                     n_AAAAABB_fb : n_AAAAAB_fm;

// n_AAAABAA
wire [7:0] n_AAAABAA_sl;
wire [8:0] n_AAAABAA_fa;
wire [7:0] n_AAAABAA_fb;
wire [8:0] n_AAAABAA_fm;
assign n_AAAABAA_sl = n_AAAABA_sl + A_step_4;
assign n_AAAABAA_fa = n_AAAABA_sl + A_pair_4;
assign n_AAAABAA_fb = n_AAAABA_fb;
assign n_AAAABAA_fm = (n_AAAABAA_fa > n_AAAABA_fm) ?
                     n_AAAABAA_fa : n_AAAABA_fm;

// n_AAAABAB
wire [7:0] n_AAAABAB_sl;
wire [7:0] n_AAAABAB_fa;
wire [7:0] n_AAAABAB_fb;
wire [7:0] n_AAAABAB_fm;
assign n_AAAABAB_sl = (B_dependent && (n_AAAABA_fb > n_AAAABA_ready)) ?
                     n_AAAABA_fb : n_AAAABA_ready;
assign n_AAAABAB_fa = n_AAAABA_fa;
assign n_AAAABAB_fb = n_AAAABAB_sl + B_lat_ext[1];
assign n_AAAABAB_fm = (n_AAAABAB_fb > n_AAAABA_fm) ?
                     n_AAAABAB_fb : n_AAAABA_fm;

// n_AAAABBA
wire [7:0] n_AAAABBA_sl;
wire [7:0] n_AAAABBA_fa;
wire [7:0] n_AAAABBA_fb;
wire [7:0] n_AAAABBA_fm;
assign n_AAAABBA_sl = (A_dependent && (n_AAAABB_fa > n_AAAABB_ready)) ?
                     n_AAAABB_fa : n_AAAABB_ready;
assign n_AAAABBA_fa = n_AAAABBA_sl + A_lat_ext[4];
assign n_AAAABBA_fb = n_AAAABB_fb;
assign n_AAAABBA_fm = (n_AAAABBA_fa > n_AAAABB_fm) ?
                     n_AAAABBA_fa : n_AAAABB_fm;

// n_AAAABBB
wire [7:0] n_AAAABBB_sl;
wire [7:0] n_AAAABBB_fa;
wire [8:0] n_AAAABBB_fb;
wire [8:0] n_AAAABBB_fm;
assign n_AAAABBB_sl = n_AAAABB_sl + B_step_1;
assign n_AAAABBB_fa = n_AAAABB_fa;
assign n_AAAABBB_fb = n_AAAABB_sl + B_pair_1;
assign n_AAAABBB_fm = (n_AAAABBB_fb > n_AAAABB_fm) ?
                     n_AAAABBB_fb : n_AAAABB_fm;

// n_AAABAAA
wire [7:0] n_AAABAAA_sl;
wire [8:0] n_AAABAAA_fa;
wire [7:0] n_AAABAAA_fb;
wire [8:0] n_AAABAAA_fm;
assign n_AAABAAA_sl = n_AAABAA_sl + A_step_4;
assign n_AAABAAA_fa = n_AAABAA_sl + A_pair_4;
assign n_AAABAAA_fb = n_AAABAA_fb;
assign n_AAABAAA_fm = (n_AAABAAA_fa > n_AAABAA_fm) ?
                     n_AAABAAA_fa : n_AAABAA_fm;

// n_AAABAAB
wire [7:0] n_AAABAAB_sl;
wire [7:0] n_AAABAAB_fa;
wire [7:0] n_AAABAAB_fb;
wire [7:0] n_AAABAAB_fm;
assign n_AAABAAB_sl = (B_dependent && (n_AAABAA_fb > n_AAABAA_ready)) ?
                     n_AAABAA_fb : n_AAABAA_ready;
assign n_AAABAAB_fa = n_AAABAA_fa;
assign n_AAABAAB_fb = n_AAABAAB_sl + B_lat_ext[1];
assign n_AAABAAB_fm = (n_AAABAAB_fb > n_AAABAA_fm) ?
                     n_AAABAAB_fb : n_AAABAA_fm;

// n_AAABABA
wire [7:0] n_AAABABA_sl;
wire [7:0] n_AAABABA_fa;
wire [7:0] n_AAABABA_fb;
wire [7:0] n_AAABABA_fm;
assign n_AAABABA_sl = (A_dependent && (n_AAABAB_fa > n_AAABAB_ready)) ?
                     n_AAABAB_fa : n_AAABAB_ready;
assign n_AAABABA_fa = n_AAABABA_sl + A_lat_ext[4];
assign n_AAABABA_fb = n_AAABAB_fb;
assign n_AAABABA_fm = (n_AAABABA_fa > n_AAABAB_fm) ?
                     n_AAABABA_fa : n_AAABAB_fm;

// n_AAABABB
wire [7:0] n_AAABABB_sl;
wire [7:0] n_AAABABB_fa;
wire [7:0] n_AAABABB_fb;
wire [7:0] n_AAABABB_fm;
assign n_AAABABB_sl = n_AAABAB_sl + B_step_1;
assign n_AAABABB_fa = n_AAABAB_fa;
assign n_AAABABB_fb = n_AAABAB_sl + B_pair_1;
assign n_AAABABB_fm = (n_AAABABB_fb > n_AAABAB_fm) ?
                     n_AAABABB_fb : n_AAABAB_fm;

// n_AAABBAA
wire [7:0] n_AAABBAA_sl;
wire [7:0] n_AAABBAA_fa;
wire [7:0] n_AAABBAA_fb;
wire [7:0] n_AAABBAA_fm;
assign n_AAABBAA_sl = n_AAABBA_sl + A_step_3;
assign n_AAABBAA_fa = n_AAABBA_sl + A_pair_3;
assign n_AAABBAA_fb = n_AAABBA_fb;
assign n_AAABBAA_fm = (n_AAABBAA_fa > n_AAABBA_fm) ?
                     n_AAABBAA_fa : n_AAABBA_fm;

// n_AAABBAB
wire [7:0] n_AAABBAB_sl;
wire [7:0] n_AAABBAB_fa;
wire [7:0] n_AAABBAB_fb;
wire [7:0] n_AAABBAB_fm;
assign n_AAABBAB_sl = (B_dependent && (n_AAABBA_fb > n_AAABBA_ready)) ?
                     n_AAABBA_fb : n_AAABBA_ready;
assign n_AAABBAB_fa = n_AAABBA_fa;
assign n_AAABBAB_fb = n_AAABBAB_sl + B_lat_ext[2];
assign n_AAABBAB_fm = (n_AAABBAB_fb > n_AAABBA_fm) ?
                     n_AAABBAB_fb : n_AAABBA_fm;

// n_AAABBBA
wire [7:0] n_AAABBBA_sl;
wire [7:0] n_AAABBBA_fa;
wire [7:0] n_AAABBBA_fb;
wire [7:0] n_AAABBBA_fm;
assign n_AAABBBA_sl = (A_dependent && (n_AAABBB_fa > n_AAABBB_ready)) ?
                     n_AAABBB_fa : n_AAABBB_ready;
assign n_AAABBBA_fa = n_AAABBBA_sl + A_lat_ext[3];
assign n_AAABBBA_fb = n_AAABBB_fb;
assign n_AAABBBA_fm = (n_AAABBBA_fa > n_AAABBB_fm) ?
                     n_AAABBBA_fa : n_AAABBB_fm;

// n_AABAAAA
wire [7:0] n_AABAAAA_sl;
wire [8:0] n_AABAAAA_fa;
wire [6:0] n_AABAAAA_fb;
wire [8:0] n_AABAAAA_fm;
assign n_AABAAAA_sl = n_AABAAA_sl + A_step_4;
assign n_AABAAAA_fa = n_AABAAA_sl + A_pair_4;
assign n_AABAAAA_fb = n_AABAAA_fb;
assign n_AABAAAA_fm = (n_AABAAAA_fa > n_AABAAA_fm) ?
                     n_AABAAAA_fa : n_AABAAA_fm;

// n_AABAAAB
wire [7:0] n_AABAAAB_sl;
wire [7:0] n_AABAAAB_fa;
wire [7:0] n_AABAAAB_fb;
wire [7:0] n_AABAAAB_fm;
assign n_AABAAAB_sl = (B_dependent && (n_AABAAA_fb > n_AABAAA_ready)) ?
                     n_AABAAA_fb : n_AABAAA_ready;
assign n_AABAAAB_fa = n_AABAAA_fa;
assign n_AABAAAB_fb = n_AABAAAB_sl + B_lat_ext[1];
assign n_AABAAAB_fm = (n_AABAAAB_fb > n_AABAAA_fm) ?
                     n_AABAAAB_fb : n_AABAAA_fm;

// n_AABAABA
wire [7:0] n_AABAABA_sl;
wire [7:0] n_AABAABA_fa;
wire [7:0] n_AABAABA_fb;
wire [7:0] n_AABAABA_fm;
assign n_AABAABA_sl = (A_dependent && (n_AABAAB_fa > n_AABAAB_ready)) ?
                     n_AABAAB_fa : n_AABAAB_ready;
assign n_AABAABA_fa = n_AABAABA_sl + A_lat_ext[4];
assign n_AABAABA_fb = n_AABAAB_fb;
assign n_AABAABA_fm = (n_AABAABA_fa > n_AABAAB_fm) ?
                     n_AABAABA_fa : n_AABAAB_fm;

// n_AABAABB
wire [7:0] n_AABAABB_sl;
wire [7:0] n_AABAABB_fa;
wire [7:0] n_AABAABB_fb;
wire [7:0] n_AABAABB_fm;
assign n_AABAABB_sl = n_AABAAB_sl + B_step_1;
assign n_AABAABB_fa = n_AABAAB_fa;
assign n_AABAABB_fb = n_AABAAB_sl + B_pair_1;
assign n_AABAABB_fm = (n_AABAABB_fb > n_AABAAB_fm) ?
                     n_AABAABB_fb : n_AABAAB_fm;

// n_AABABAA
wire [7:0] n_AABABAA_sl;
wire [7:0] n_AABABAA_fa;
wire [7:0] n_AABABAA_fb;
wire [7:0] n_AABABAA_fm;
assign n_AABABAA_sl = n_AABABA_sl + A_step_3;
assign n_AABABAA_fa = n_AABABA_sl + A_pair_3;
assign n_AABABAA_fb = n_AABABA_fb;
assign n_AABABAA_fm = (n_AABABAA_fa > n_AABABA_fm) ?
                     n_AABABAA_fa : n_AABABA_fm;

// n_AABABAB
wire [7:0] n_AABABAB_sl;
wire [7:0] n_AABABAB_fa;
wire [7:0] n_AABABAB_fb;
wire [7:0] n_AABABAB_fm;
assign n_AABABAB_sl = (B_dependent && (n_AABABA_fb > n_AABABA_ready)) ?
                     n_AABABA_fb : n_AABABA_ready;
assign n_AABABAB_fa = n_AABABA_fa;
assign n_AABABAB_fb = n_AABABAB_sl + B_lat_ext[2];
assign n_AABABAB_fm = (n_AABABAB_fb > n_AABABA_fm) ?
                     n_AABABAB_fb : n_AABABA_fm;

// n_AABABBA
wire [7:0] n_AABABBA_sl;
wire [7:0] n_AABABBA_fa;
wire [7:0] n_AABABBA_fb;
wire [7:0] n_AABABBA_fm;
assign n_AABABBA_sl = (A_dependent && (n_AABABB_fa > n_AABABB_ready)) ?
                     n_AABABB_fa : n_AABABB_ready;
assign n_AABABBA_fa = n_AABABBA_sl + A_lat_ext[3];
assign n_AABABBA_fb = n_AABABB_fb;
assign n_AABABBA_fm = (n_AABABBA_fa > n_AABABB_fm) ?
                     n_AABABBA_fa : n_AABABB_fm;

// n_AABBAAA
wire [7:0] n_AABBAAA_sl;
wire [7:0] n_AABBAAA_fa;
wire [7:0] n_AABBAAA_fb;
wire [7:0] n_AABBAAA_fm;
assign n_AABBAAA_sl = n_AABBAA_sl + A_step_3;
assign n_AABBAAA_fa = n_AABBAA_sl + A_pair_3;
assign n_AABBAAA_fb = n_AABBAA_fb;
assign n_AABBAAA_fm = (n_AABBAAA_fa > n_AABBAA_fm) ?
                     n_AABBAAA_fa : n_AABBAA_fm;

// n_AABBAAB
wire [7:0] n_AABBAAB_sl;
wire [7:0] n_AABBAAB_fa;
wire [7:0] n_AABBAAB_fb;
wire [7:0] n_AABBAAB_fm;
assign n_AABBAAB_sl = (B_dependent && (n_AABBAA_fb > n_AABBAA_ready)) ?
                     n_AABBAA_fb : n_AABBAA_ready;
assign n_AABBAAB_fa = n_AABBAA_fa;
assign n_AABBAAB_fb = n_AABBAAB_sl + B_lat_ext[2];
assign n_AABBAAB_fm = (n_AABBAAB_fb > n_AABBAA_fm) ?
                     n_AABBAAB_fb : n_AABBAA_fm;

// n_AABBABA
wire [7:0] n_AABBABA_sl;
wire [7:0] n_AABBABA_fa;
wire [7:0] n_AABBABA_fb;
wire [7:0] n_AABBABA_fm;
assign n_AABBABA_sl = (A_dependent && (n_AABBAB_fa > n_AABBAB_ready)) ?
                     n_AABBAB_fa : n_AABBAB_ready;
assign n_AABBABA_fa = n_AABBABA_sl + A_lat_ext[3];
assign n_AABBABA_fb = n_AABBAB_fb;
assign n_AABBABA_fm = (n_AABBABA_fa > n_AABBAB_fm) ?
                     n_AABBABA_fa : n_AABBAB_fm;

// n_AABBBAA
wire [7:0] n_AABBBAA_sl;
wire [7:0] n_AABBBAA_fa;
wire [7:0] n_AABBBAA_fb;
wire [7:0] n_AABBBAA_fm;
assign n_AABBBAA_sl = n_AABBBA_sl + A_step_2;
assign n_AABBBAA_fa = n_AABBBA_sl + A_pair_2;
assign n_AABBBAA_fb = n_AABBBA_fb;
assign n_AABBBAA_fm = (n_AABBBAA_fa > n_AABBBA_fm) ?
                     n_AABBBAA_fa : n_AABBBA_fm;

// n_ABAAAAA
wire [7:0] n_ABAAAAA_sl;
wire [8:0] n_ABAAAAA_fa;
wire [5:0] n_ABAAAAA_fb;
wire [8:0] n_ABAAAAA_fm;
assign n_ABAAAAA_sl = n_ABAAAA_sl + A_step_4;
assign n_ABAAAAA_fa = n_ABAAAA_sl + A_pair_4;
assign n_ABAAAAA_fb = n_ABAAAA_fb;
assign n_ABAAAAA_fm = (n_ABAAAAA_fa > n_ABAAAA_fm) ?
                     n_ABAAAAA_fa : n_ABAAAA_fm;

// n_ABAAAAB
wire [7:0] n_ABAAAAB_sl;
wire [7:0] n_ABAAAAB_fa;
wire [7:0] n_ABAAAAB_fb;
wire [7:0] n_ABAAAAB_fm;
assign n_ABAAAAB_sl = (B_dependent && (n_ABAAAA_fb > n_ABAAAA_ready)) ?
                     n_ABAAAA_fb : n_ABAAAA_ready;
assign n_ABAAAAB_fa = n_ABAAAA_fa;
assign n_ABAAAAB_fb = n_ABAAAAB_sl + B_lat_ext[1];
assign n_ABAAAAB_fm = (n_ABAAAAB_fb > n_ABAAAA_fm) ?
                     n_ABAAAAB_fb : n_ABAAAA_fm;

// n_ABAAABA
wire [7:0] n_ABAAABA_sl;
wire [7:0] n_ABAAABA_fa;
wire [7:0] n_ABAAABA_fb;
wire [7:0] n_ABAAABA_fm;
assign n_ABAAABA_sl = (A_dependent && (n_ABAAAB_fa > n_ABAAAB_ready)) ?
                     n_ABAAAB_fa : n_ABAAAB_ready;
assign n_ABAAABA_fa = n_ABAAABA_sl + A_lat_ext[4];
assign n_ABAAABA_fb = n_ABAAAB_fb;
assign n_ABAAABA_fm = (n_ABAAABA_fa > n_ABAAAB_fm) ?
                     n_ABAAABA_fa : n_ABAAAB_fm;

// n_ABAAABB
wire [7:0] n_ABAAABB_sl;
wire [7:0] n_ABAAABB_fa;
wire [7:0] n_ABAAABB_fb;
wire [7:0] n_ABAAABB_fm;
assign n_ABAAABB_sl = n_ABAAAB_sl + B_step_1;
assign n_ABAAABB_fa = n_ABAAAB_fa;
assign n_ABAAABB_fb = n_ABAAAB_sl + B_pair_1;
assign n_ABAAABB_fm = (n_ABAAABB_fb > n_ABAAAB_fm) ?
                     n_ABAAABB_fb : n_ABAAAB_fm;

// n_ABAABAA
wire [7:0] n_ABAABAA_sl;
wire [7:0] n_ABAABAA_fa;
wire [7:0] n_ABAABAA_fb;
wire [7:0] n_ABAABAA_fm;
assign n_ABAABAA_sl = n_ABAABA_sl + A_step_3;
assign n_ABAABAA_fa = n_ABAABA_sl + A_pair_3;
assign n_ABAABAA_fb = n_ABAABA_fb;
assign n_ABAABAA_fm = (n_ABAABAA_fa > n_ABAABA_fm) ?
                     n_ABAABAA_fa : n_ABAABA_fm;

// n_ABAABAB
wire [7:0] n_ABAABAB_sl;
wire [7:0] n_ABAABAB_fa;
wire [7:0] n_ABAABAB_fb;
wire [7:0] n_ABAABAB_fm;
assign n_ABAABAB_sl = (B_dependent && (n_ABAABA_fb > n_ABAABA_ready)) ?
                     n_ABAABA_fb : n_ABAABA_ready;
assign n_ABAABAB_fa = n_ABAABA_fa;
assign n_ABAABAB_fb = n_ABAABAB_sl + B_lat_ext[2];
assign n_ABAABAB_fm = (n_ABAABAB_fb > n_ABAABA_fm) ?
                     n_ABAABAB_fb : n_ABAABA_fm;

// n_ABAABBA
wire [7:0] n_ABAABBA_sl;
wire [7:0] n_ABAABBA_fa;
wire [7:0] n_ABAABBA_fb;
wire [7:0] n_ABAABBA_fm;
assign n_ABAABBA_sl = (A_dependent && (n_ABAABB_fa > n_ABAABB_ready)) ?
                     n_ABAABB_fa : n_ABAABB_ready;
assign n_ABAABBA_fa = n_ABAABBA_sl + A_lat_ext[3];
assign n_ABAABBA_fb = n_ABAABB_fb;
assign n_ABAABBA_fm = (n_ABAABBA_fa > n_ABAABB_fm) ?
                     n_ABAABBA_fa : n_ABAABB_fm;

// n_ABABAAA
wire [7:0] n_ABABAAA_sl;
wire [7:0] n_ABABAAA_fa;
wire [6:0] n_ABABAAA_fb;
wire [7:0] n_ABABAAA_fm;
assign n_ABABAAA_sl = n_ABABAA_sl + A_step_3;
assign n_ABABAAA_fa = n_ABABAA_sl + A_pair_3;
assign n_ABABAAA_fb = n_ABABAA_fb;
assign n_ABABAAA_fm = (n_ABABAAA_fa > n_ABABAA_fm) ?
                     n_ABABAAA_fa : n_ABABAA_fm;

// n_ABABAAB
wire [7:0] n_ABABAAB_sl;
wire [7:0] n_ABABAAB_fa;
wire [7:0] n_ABABAAB_fb;
wire [7:0] n_ABABAAB_fm;
assign n_ABABAAB_sl = (B_dependent && (n_ABABAA_fb > n_ABABAA_ready)) ?
                     n_ABABAA_fb : n_ABABAA_ready;
assign n_ABABAAB_fa = n_ABABAA_fa;
assign n_ABABAAB_fb = n_ABABAAB_sl + B_lat_ext[2];
assign n_ABABAAB_fm = (n_ABABAAB_fb > n_ABABAA_fm) ?
                     n_ABABAAB_fb : n_ABABAA_fm;

// n_ABABABA
wire [7:0] n_ABABABA_sl;
wire [7:0] n_ABABABA_fa;
wire [7:0] n_ABABABA_fb;
wire [7:0] n_ABABABA_fm;
assign n_ABABABA_sl = (A_dependent && (n_ABABAB_fa > n_ABABAB_ready)) ?
                     n_ABABAB_fa : n_ABABAB_ready;
assign n_ABABABA_fa = n_ABABABA_sl + A_lat_ext[3];
assign n_ABABABA_fb = n_ABABAB_fb;
assign n_ABABABA_fm = (n_ABABABA_fa > n_ABABAB_fm) ?
                     n_ABABABA_fa : n_ABABAB_fm;

// n_ABABBAA
wire [7:0] n_ABABBAA_sl;
wire [7:0] n_ABABBAA_fa;
wire [7:0] n_ABABBAA_fb;
wire [7:0] n_ABABBAA_fm;
assign n_ABABBAA_sl = n_ABABBA_sl + A_step_2;
assign n_ABABBAA_fa = n_ABABBA_sl + A_pair_2;
assign n_ABABBAA_fb = n_ABABBA_fb;
assign n_ABABBAA_fm = (n_ABABBAA_fa > n_ABABBA_fm) ?
                     n_ABABBAA_fa : n_ABABBA_fm;

// n_ABBAAAA
wire [7:0] n_ABBAAAA_sl;
wire [7:0] n_ABBAAAA_fa;
wire [6:0] n_ABBAAAA_fb;
wire [7:0] n_ABBAAAA_fm;
assign n_ABBAAAA_sl = n_ABBAAA_sl + A_step_3;
assign n_ABBAAAA_fa = n_ABBAAA_sl + A_pair_3;
assign n_ABBAAAA_fb = n_ABBAAA_fb;
assign n_ABBAAAA_fm = (n_ABBAAAA_fa > n_ABBAAA_fm) ?
                     n_ABBAAAA_fa : n_ABBAAA_fm;

// n_ABBAAAB
wire [7:0] n_ABBAAAB_sl;
wire [7:0] n_ABBAAAB_fa;
wire [7:0] n_ABBAAAB_fb;
wire [7:0] n_ABBAAAB_fm;
assign n_ABBAAAB_sl = (B_dependent && (n_ABBAAA_fb > n_ABBAAA_ready)) ?
                     n_ABBAAA_fb : n_ABBAAA_ready;
assign n_ABBAAAB_fa = n_ABBAAA_fa;
assign n_ABBAAAB_fb = n_ABBAAAB_sl + B_lat_ext[2];
assign n_ABBAAAB_fm = (n_ABBAAAB_fb > n_ABBAAA_fm) ?
                     n_ABBAAAB_fb : n_ABBAAA_fm;

// n_ABBAABA
wire [7:0] n_ABBAABA_sl;
wire [7:0] n_ABBAABA_fa;
wire [7:0] n_ABBAABA_fb;
wire [7:0] n_ABBAABA_fm;
assign n_ABBAABA_sl = (A_dependent && (n_ABBAAB_fa > n_ABBAAB_ready)) ?
                     n_ABBAAB_fa : n_ABBAAB_ready;
assign n_ABBAABA_fa = n_ABBAABA_sl + A_lat_ext[3];
assign n_ABBAABA_fb = n_ABBAAB_fb;
assign n_ABBAABA_fm = (n_ABBAABA_fa > n_ABBAAB_fm) ?
                     n_ABBAABA_fa : n_ABBAAB_fm;

// n_ABBABAA
wire [7:0] n_ABBABAA_sl;
wire [7:0] n_ABBABAA_fa;
wire [7:0] n_ABBABAA_fb;
wire [7:0] n_ABBABAA_fm;
assign n_ABBABAA_sl = n_ABBABA_sl + A_step_2;
assign n_ABBABAA_fa = n_ABBABA_sl + A_pair_2;
assign n_ABBABAA_fb = n_ABBABA_fb;
assign n_ABBABAA_fm = (n_ABBABAA_fa > n_ABBABA_fm) ?
                     n_ABBABAA_fa : n_ABBABA_fm;

// n_ABBBAAA
wire [7:0] n_ABBBAAA_sl;
wire [7:0] n_ABBBAAA_fa;
wire [7:0] n_ABBBAAA_fb;
wire [7:0] n_ABBBAAA_fm;
assign n_ABBBAAA_sl = n_ABBBAA_sl + A_step_2;
assign n_ABBBAAA_fa = n_ABBBAA_sl + A_pair_2;
assign n_ABBBAAA_fb = n_ABBBAA_fb;
assign n_ABBBAAA_fm = (n_ABBBAAA_fa > n_ABBBAA_fm) ?
                     n_ABBBAAA_fa : n_ABBBAA_fm;

// n_BAAAAAA
wire [7:0] n_BAAAAAA_sl;
wire [8:0] n_BAAAAAA_fa;
wire [5:0] n_BAAAAAA_fb;
wire [8:0] n_BAAAAAA_fm;
assign n_BAAAAAA_sl = n_BAAAAA_sl + A_step_4;
assign n_BAAAAAA_fa = n_BAAAAA_sl + A_pair_4;
assign n_BAAAAAA_fb = n_BAAAAA_fb;
assign n_BAAAAAA_fm = (n_BAAAAAA_fa > n_BAAAAA_fm) ?
                     n_BAAAAAA_fa : n_BAAAAA_fm;

// n_BAAAAAB
wire [7:0] n_BAAAAAB_sl;
wire [7:0] n_BAAAAAB_fa;
wire [7:0] n_BAAAAAB_fb;
wire [7:0] n_BAAAAAB_fm;
assign n_BAAAAAB_sl = (B_dependent && (n_BAAAAA_fb > n_BAAAAA_ready)) ?
                     n_BAAAAA_fb : n_BAAAAA_ready;
assign n_BAAAAAB_fa = n_BAAAAA_fa;
assign n_BAAAAAB_fb = n_BAAAAAB_sl + B_lat_ext[1];
assign n_BAAAAAB_fm = (n_BAAAAAB_fb > n_BAAAAA_fm) ?
                     n_BAAAAAB_fb : n_BAAAAA_fm;

// n_BAAAABA
wire [7:0] n_BAAAABA_sl;
wire [7:0] n_BAAAABA_fa;
wire [7:0] n_BAAAABA_fb;
wire [7:0] n_BAAAABA_fm;
assign n_BAAAABA_sl = (A_dependent && (n_BAAAAB_fa > n_BAAAAB_ready)) ?
                     n_BAAAAB_fa : n_BAAAAB_ready;
assign n_BAAAABA_fa = n_BAAAABA_sl + A_lat_ext[4];
assign n_BAAAABA_fb = n_BAAAAB_fb;
assign n_BAAAABA_fm = (n_BAAAABA_fa > n_BAAAAB_fm) ?
                     n_BAAAABA_fa : n_BAAAAB_fm;

// n_BAAAABB
wire [7:0] n_BAAAABB_sl;
wire [7:0] n_BAAAABB_fa;
wire [7:0] n_BAAAABB_fb;
wire [7:0] n_BAAAABB_fm;
assign n_BAAAABB_sl = n_BAAAAB_sl + B_step_1;
assign n_BAAAABB_fa = n_BAAAAB_fa;
assign n_BAAAABB_fb = n_BAAAAB_sl + B_pair_1;
assign n_BAAAABB_fm = (n_BAAAABB_fb > n_BAAAAB_fm) ?
                     n_BAAAABB_fb : n_BAAAAB_fm;

// n_BAAABAA
wire [7:0] n_BAAABAA_sl;
wire [7:0] n_BAAABAA_fa;
wire [7:0] n_BAAABAA_fb;
wire [7:0] n_BAAABAA_fm;
assign n_BAAABAA_sl = n_BAAABA_sl + A_step_3;
assign n_BAAABAA_fa = n_BAAABA_sl + A_pair_3;
assign n_BAAABAA_fb = n_BAAABA_fb;
assign n_BAAABAA_fm = (n_BAAABAA_fa > n_BAAABA_fm) ?
                     n_BAAABAA_fa : n_BAAABA_fm;

// n_BAAABAB
wire [7:0] n_BAAABAB_sl;
wire [7:0] n_BAAABAB_fa;
wire [7:0] n_BAAABAB_fb;
wire [7:0] n_BAAABAB_fm;
assign n_BAAABAB_sl = (B_dependent && (n_BAAABA_fb > n_BAAABA_ready)) ?
                     n_BAAABA_fb : n_BAAABA_ready;
assign n_BAAABAB_fa = n_BAAABA_fa;
assign n_BAAABAB_fb = n_BAAABAB_sl + B_lat_ext[2];
assign n_BAAABAB_fm = (n_BAAABAB_fb > n_BAAABA_fm) ?
                     n_BAAABAB_fb : n_BAAABA_fm;

// n_BAAABBA
wire [7:0] n_BAAABBA_sl;
wire [7:0] n_BAAABBA_fa;
wire [7:0] n_BAAABBA_fb;
wire [7:0] n_BAAABBA_fm;
assign n_BAAABBA_sl = (A_dependent && (n_BAAABB_fa > n_BAAABB_ready)) ?
                     n_BAAABB_fa : n_BAAABB_ready;
assign n_BAAABBA_fa = n_BAAABBA_sl + A_lat_ext[3];
assign n_BAAABBA_fb = n_BAAABB_fb;
assign n_BAAABBA_fm = (n_BAAABBA_fa > n_BAAABB_fm) ?
                     n_BAAABBA_fa : n_BAAABB_fm;

// n_BAABAAA
wire [7:0] n_BAABAAA_sl;
wire [7:0] n_BAABAAA_fa;
wire [6:0] n_BAABAAA_fb;
wire [7:0] n_BAABAAA_fm;
assign n_BAABAAA_sl = n_BAABAA_sl + A_step_3;
assign n_BAABAAA_fa = n_BAABAA_sl + A_pair_3;
assign n_BAABAAA_fb = n_BAABAA_fb;
assign n_BAABAAA_fm = (n_BAABAAA_fa > n_BAABAA_fm) ?
                     n_BAABAAA_fa : n_BAABAA_fm;

// n_BAABAAB
wire [7:0] n_BAABAAB_sl;
wire [7:0] n_BAABAAB_fa;
wire [7:0] n_BAABAAB_fb;
wire [7:0] n_BAABAAB_fm;
assign n_BAABAAB_sl = (B_dependent && (n_BAABAA_fb > n_BAABAA_ready)) ?
                     n_BAABAA_fb : n_BAABAA_ready;
assign n_BAABAAB_fa = n_BAABAA_fa;
assign n_BAABAAB_fb = n_BAABAAB_sl + B_lat_ext[2];
assign n_BAABAAB_fm = (n_BAABAAB_fb > n_BAABAA_fm) ?
                     n_BAABAAB_fb : n_BAABAA_fm;

// n_BAABABA
wire [7:0] n_BAABABA_sl;
wire [7:0] n_BAABABA_fa;
wire [7:0] n_BAABABA_fb;
wire [7:0] n_BAABABA_fm;
assign n_BAABABA_sl = (A_dependent && (n_BAABAB_fa > n_BAABAB_ready)) ?
                     n_BAABAB_fa : n_BAABAB_ready;
assign n_BAABABA_fa = n_BAABABA_sl + A_lat_ext[3];
assign n_BAABABA_fb = n_BAABAB_fb;
assign n_BAABABA_fm = (n_BAABABA_fa > n_BAABAB_fm) ?
                     n_BAABABA_fa : n_BAABAB_fm;

// n_BAABBAA
wire [7:0] n_BAABBAA_sl;
wire [7:0] n_BAABBAA_fa;
wire [7:0] n_BAABBAA_fb;
wire [7:0] n_BAABBAA_fm;
assign n_BAABBAA_sl = n_BAABBA_sl + A_step_2;
assign n_BAABBAA_fa = n_BAABBA_sl + A_pair_2;
assign n_BAABBAA_fb = n_BAABBA_fb;
assign n_BAABBAA_fm = (n_BAABBAA_fa > n_BAABBA_fm) ?
                     n_BAABBAA_fa : n_BAABBA_fm;

// n_BABAAAA
wire [7:0] n_BABAAAA_sl;
wire [7:0] n_BABAAAA_fa;
wire [6:0] n_BABAAAA_fb;
wire [7:0] n_BABAAAA_fm;
assign n_BABAAAA_sl = n_BABAAA_sl + A_step_3;
assign n_BABAAAA_fa = n_BABAAA_sl + A_pair_3;
assign n_BABAAAA_fb = n_BABAAA_fb;
assign n_BABAAAA_fm = (n_BABAAAA_fa > n_BABAAA_fm) ?
                     n_BABAAAA_fa : n_BABAAA_fm;

// n_BABAAAB
wire [7:0] n_BABAAAB_sl;
wire [7:0] n_BABAAAB_fa;
wire [7:0] n_BABAAAB_fb;
wire [7:0] n_BABAAAB_fm;
assign n_BABAAAB_sl = (B_dependent && (n_BABAAA_fb > n_BABAAA_ready)) ?
                     n_BABAAA_fb : n_BABAAA_ready;
assign n_BABAAAB_fa = n_BABAAA_fa;
assign n_BABAAAB_fb = n_BABAAAB_sl + B_lat_ext[2];
assign n_BABAAAB_fm = (n_BABAAAB_fb > n_BABAAA_fm) ?
                     n_BABAAAB_fb : n_BABAAA_fm;

// n_BABAABA
wire [7:0] n_BABAABA_sl;
wire [7:0] n_BABAABA_fa;
wire [7:0] n_BABAABA_fb;
wire [7:0] n_BABAABA_fm;
assign n_BABAABA_sl = (A_dependent && (n_BABAAB_fa > n_BABAAB_ready)) ?
                     n_BABAAB_fa : n_BABAAB_ready;
assign n_BABAABA_fa = n_BABAABA_sl + A_lat_ext[3];
assign n_BABAABA_fb = n_BABAAB_fb;
assign n_BABAABA_fm = (n_BABAABA_fa > n_BABAAB_fm) ?
                     n_BABAABA_fa : n_BABAAB_fm;

// n_BABABAA
wire [7:0] n_BABABAA_sl;
wire [7:0] n_BABABAA_fa;
wire [7:0] n_BABABAA_fb;
wire [7:0] n_BABABAA_fm;
assign n_BABABAA_sl = n_BABABA_sl + A_step_2;
assign n_BABABAA_fa = n_BABABA_sl + A_pair_2;
assign n_BABABAA_fb = n_BABABA_fb;
assign n_BABABAA_fm = (n_BABABAA_fa > n_BABABA_fm) ?
                     n_BABABAA_fa : n_BABABA_fm;

// n_BABBAAA
wire [7:0] n_BABBAAA_sl;
wire [7:0] n_BABBAAA_fa;
wire [7:0] n_BABBAAA_fb;
wire [7:0] n_BABBAAA_fm;
assign n_BABBAAA_sl = n_BABBAA_sl + A_step_2;
assign n_BABBAAA_fa = n_BABBAA_sl + A_pair_2;
assign n_BABBAAA_fb = n_BABBAA_fb;
assign n_BABBAAA_fm = (n_BABBAAA_fa > n_BABBAA_fm) ?
                     n_BABBAAA_fa : n_BABBAA_fm;

// n_BBAAAAA
wire [7:0] n_BBAAAAA_sl;
wire [8:0] n_BBAAAAA_fa;
wire [6:0] n_BBAAAAA_fb;
wire [8:0] n_BBAAAAA_fm;
assign n_BBAAAAA_sl = n_BBAAAA_sl + A_step_3;
assign n_BBAAAAA_fa = n_BBAAAA_sl + A_pair_3;
assign n_BBAAAAA_fb = n_BBAAAA_fb;
assign n_BBAAAAA_fm = (n_BBAAAAA_fa > n_BBAAAA_fm) ?
                     n_BBAAAAA_fa : n_BBAAAA_fm;

// n_BBAAAAB
wire [7:0] n_BBAAAAB_sl;
wire [7:0] n_BBAAAAB_fa;
wire [7:0] n_BBAAAAB_fb;
wire [7:0] n_BBAAAAB_fm;
assign n_BBAAAAB_sl = (B_dependent && (n_BBAAAA_fb > n_BBAAAA_ready)) ?
                     n_BBAAAA_fb : n_BBAAAA_ready;
assign n_BBAAAAB_fa = n_BBAAAA_fa;
assign n_BBAAAAB_fb = n_BBAAAAB_sl + B_lat_ext[2];
assign n_BBAAAAB_fm = (n_BBAAAAB_fb > n_BBAAAA_fm) ?
                     n_BBAAAAB_fb : n_BBAAAA_fm;

// n_BBAAABA
wire [7:0] n_BBAAABA_sl;
wire [7:0] n_BBAAABA_fa;
wire [7:0] n_BBAAABA_fb;
wire [7:0] n_BBAAABA_fm;
assign n_BBAAABA_sl = (A_dependent && (n_BBAAAB_fa > n_BBAAAB_ready)) ?
                     n_BBAAAB_fa : n_BBAAAB_ready;
assign n_BBAAABA_fa = n_BBAAABA_sl + A_lat_ext[3];
assign n_BBAAABA_fb = n_BBAAAB_fb;
assign n_BBAAABA_fm = (n_BBAAABA_fa > n_BBAAAB_fm) ?
                     n_BBAAABA_fa : n_BBAAAB_fm;

// n_BBAABAA
wire [7:0] n_BBAABAA_sl;
wire [7:0] n_BBAABAA_fa;
wire [7:0] n_BBAABAA_fb;
wire [7:0] n_BBAABAA_fm;
assign n_BBAABAA_sl = n_BBAABA_sl + A_step_2;
assign n_BBAABAA_fa = n_BBAABA_sl + A_pair_2;
assign n_BBAABAA_fb = n_BBAABA_fb;
assign n_BBAABAA_fm = (n_BBAABAA_fa > n_BBAABA_fm) ?
                     n_BBAABAA_fa : n_BBAABA_fm;

// n_BBABAAA
wire [7:0] n_BBABAAA_sl;
wire [7:0] n_BBABAAA_fa;
wire [7:0] n_BBABAAA_fb;
wire [7:0] n_BBABAAA_fm;
assign n_BBABAAA_sl = n_BBABAA_sl + A_step_2;
assign n_BBABAAA_fa = n_BBABAA_sl + A_pair_2;
assign n_BBABAAA_fb = n_BBABAA_fb;
assign n_BBABAAA_fm = (n_BBABAAA_fa > n_BBABAA_fm) ?
                     n_BBABAAA_fa : n_BBABAA_fm;

// n_BBBAAAA
wire [7:0] n_BBBAAAA_sl;
wire [8:0] n_BBBAAAA_fa;
wire [7:0] n_BBBAAAA_fb;
wire [8:0] n_BBBAAAA_fm;
assign n_BBBAAAA_sl = n_BBBAAA_sl + A_step_2;
assign n_BBBAAAA_fa = n_BBBAAA_sl + A_pair_2;
assign n_BBBAAAA_fb = n_BBBAAA_fb;
assign n_BBBAAAA_fm = (n_BBBAAAA_fa > n_BBBAAA_fm) ?
                     n_BBBAAAA_fa : n_BBBAAA_fm;
