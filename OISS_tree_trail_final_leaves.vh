//////// TAIL LEAVES ////////

// l44_BBBBAAAA
wire [8:0] t_BBB_b_sl, t_BBB_b_finish;
wire [8:0] t_BBB_a_dep_start, t_BBB_a_finish, t_BBB_max;
wire [8:0] l44_BBBBAAAA_cycle;
assign t_BBB_b_sl = (B_dependent && (n_BBB_fb > n_BBB_ready)) ?
                    n_BBB_fb : n_BBB_ready;
assign t_BBB_b_finish = t_BBB_b_sl + B_lat_ext[3];
assign t_BBB_a_dep_start = (n_BBB_fa > (t_BBB_b_sl + 9'd1)) ?
                           n_BBB_fa : (t_BBB_b_sl + 9'd1);
assign t_BBB_a_finish = A_dependent ?
                        (t_BBB_a_dep_start + A_dep_sum_0) :
                        (t_BBB_b_sl + A_ind_tail_0);
assign t_BBB_max = (t_BBB_b_finish > n_BBB_fm) ?
                   t_BBB_b_finish : n_BBB_fm;
assign l44_BBBBAAAA_cycle = (t_BBB_a_finish > t_BBB_max) ?
                              t_BBB_a_finish : t_BBB_max;

// l44_ABBBBAAA
wire [8:0] t_ABBB_b_sl, t_ABBB_b_finish;
wire [8:0] t_ABBB_a_dep_start, t_ABBB_a_finish, t_ABBB_max;
wire [8:0] l44_ABBBBAAA_cycle;
assign t_ABBB_b_sl = (B_dependent && (n_ABBB_fb > n_ABBB_ready)) ?
                    n_ABBB_fb : n_ABBB_ready;
assign t_ABBB_b_finish = t_ABBB_b_sl + B_lat_ext[3];
assign t_ABBB_a_dep_start = (n_ABBB_fa > (t_ABBB_b_sl + 9'd1)) ?
                           n_ABBB_fa : (t_ABBB_b_sl + 9'd1);
assign t_ABBB_a_finish = A_dependent ?
                        (t_ABBB_a_dep_start + A_dep_sum_1) :
                        (t_ABBB_b_sl + A_ind_tail_1);
assign t_ABBB_max = (t_ABBB_b_finish > n_ABBB_fm) ?
                   t_ABBB_b_finish : n_ABBB_fm;
assign l44_ABBBBAAA_cycle = (t_ABBB_a_finish > t_ABBB_max) ?
                              t_ABBB_a_finish : t_ABBB_max;

// l44_BABBBAAA
wire [8:0] t_BABB_b_sl, t_BABB_b_finish;
wire [8:0] t_BABB_a_dep_start, t_BABB_a_finish, t_BABB_max;
wire [8:0] l44_BABBBAAA_cycle;
assign t_BABB_b_sl = (B_dependent && (n_BABB_fb > n_BABB_ready)) ?
                    n_BABB_fb : n_BABB_ready;
assign t_BABB_b_finish = t_BABB_b_sl + B_lat_ext[3];
assign t_BABB_a_dep_start = (n_BABB_fa > (t_BABB_b_sl + 9'd1)) ?
                           n_BABB_fa : (t_BABB_b_sl + 9'd1);
assign t_BABB_a_finish = A_dependent ?
                        (t_BABB_a_dep_start + A_dep_sum_1) :
                        (t_BABB_b_sl + A_ind_tail_1);
assign t_BABB_max = (t_BABB_b_finish > n_BABB_fm) ?
                   t_BABB_b_finish : n_BABB_fm;
assign l44_BABBBAAA_cycle = (t_BABB_a_finish > t_BABB_max) ?
                              t_BABB_a_finish : t_BABB_max;

// l44_BBABBAAA
wire [8:0] t_BBAB_b_sl, t_BBAB_b_finish;
wire [8:0] t_BBAB_a_dep_start, t_BBAB_a_finish, t_BBAB_max;
wire [8:0] l44_BBABBAAA_cycle;
assign t_BBAB_b_sl = (B_dependent && (n_BBAB_fb > n_BBAB_ready)) ?
                    n_BBAB_fb : n_BBAB_ready;
assign t_BBAB_b_finish = t_BBAB_b_sl + B_lat_ext[3];
assign t_BBAB_a_dep_start = (n_BBAB_fa > (t_BBAB_b_sl + 9'd1)) ?
                           n_BBAB_fa : (t_BBAB_b_sl + 9'd1);
assign t_BBAB_a_finish = A_dependent ?
                        (t_BBAB_a_dep_start + A_dep_sum_1) :
                        (t_BBAB_b_sl + A_ind_tail_1);
assign t_BBAB_max = (t_BBAB_b_finish > n_BBAB_fm) ?
                   t_BBAB_b_finish : n_BBAB_fm;
assign l44_BBABBAAA_cycle = (t_BBAB_a_finish > t_BBAB_max) ?
                              t_BBAB_a_finish : t_BBAB_max;

// l44_BBBABAAA
wire [8:0] t_BBBA_b_sl, t_BBBA_b_finish;
wire [8:0] t_BBBA_a_dep_start, t_BBBA_a_finish, t_BBBA_max;
wire [8:0] l44_BBBABAAA_cycle;
assign t_BBBA_b_sl = (B_dependent && (n_BBBA_fb > n_BBBA_ready)) ?
                    n_BBBA_fb : n_BBBA_ready;
assign t_BBBA_b_finish = t_BBBA_b_sl + B_lat_ext[3];
assign t_BBBA_a_dep_start = (n_BBBA_fa > (t_BBBA_b_sl + 9'd1)) ?
                           n_BBBA_fa : (t_BBBA_b_sl + 9'd1);
assign t_BBBA_a_finish = A_dependent ?
                        (t_BBBA_a_dep_start + A_dep_sum_1) :
                        (t_BBBA_b_sl + A_ind_tail_1);
assign t_BBBA_max = (t_BBBA_b_finish > n_BBBA_fm) ?
                   t_BBBA_b_finish : n_BBBA_fm;
assign l44_BBBABAAA_cycle = (t_BBBA_a_finish > t_BBBA_max) ?
                              t_BBBA_a_finish : t_BBBA_max;

// l44_AABBBBAA
wire [8:0] t_AABBB_b_sl, t_AABBB_b_finish;
wire [8:0] t_AABBB_a_dep_start, t_AABBB_a_finish, t_AABBB_max;
wire [8:0] l44_AABBBBAA_cycle;
assign t_AABBB_b_sl = (B_dependent && (n_AABBB_fb > n_AABBB_ready)) ?
                    n_AABBB_fb : n_AABBB_ready;
assign t_AABBB_b_finish = t_AABBB_b_sl + B_lat_ext[3];
assign t_AABBB_a_dep_start = (n_AABBB_fa > (t_AABBB_b_sl + 9'd1)) ?
                           n_AABBB_fa : (t_AABBB_b_sl + 9'd1);
assign t_AABBB_a_finish = A_dependent ?
                        (t_AABBB_a_dep_start + A_dep_sum_2) :
                        (t_AABBB_b_sl + A_ind_tail_2);
assign t_AABBB_max = (t_AABBB_b_finish > n_AABBB_fm) ?
                   t_AABBB_b_finish : n_AABBB_fm;
assign l44_AABBBBAA_cycle = (t_AABBB_a_finish > t_AABBB_max) ?
                              t_AABBB_a_finish : t_AABBB_max;

// l44_ABABBBAA
wire [8:0] t_ABABB_b_sl, t_ABABB_b_finish;
wire [8:0] t_ABABB_a_dep_start, t_ABABB_a_finish, t_ABABB_max;
wire [8:0] l44_ABABBBAA_cycle;
assign t_ABABB_b_sl = (B_dependent && (n_ABABB_fb > n_ABABB_ready)) ?
                    n_ABABB_fb : n_ABABB_ready;
assign t_ABABB_b_finish = t_ABABB_b_sl + B_lat_ext[3];
assign t_ABABB_a_dep_start = (n_ABABB_fa > (t_ABABB_b_sl + 9'd1)) ?
                           n_ABABB_fa : (t_ABABB_b_sl + 9'd1);
assign t_ABABB_a_finish = A_dependent ?
                        (t_ABABB_a_dep_start + A_dep_sum_2) :
                        (t_ABABB_b_sl + A_ind_tail_2);
assign t_ABABB_max = (t_ABABB_b_finish > n_ABABB_fm) ?
                   t_ABABB_b_finish : n_ABABB_fm;
assign l44_ABABBBAA_cycle = (t_ABABB_a_finish > t_ABABB_max) ?
                              t_ABABB_a_finish : t_ABABB_max;

// l44_ABBABBAA
wire [8:0] t_ABBAB_b_sl, t_ABBAB_b_finish;
wire [8:0] t_ABBAB_a_dep_start, t_ABBAB_a_finish, t_ABBAB_max;
wire [8:0] l44_ABBABBAA_cycle;
assign t_ABBAB_b_sl = (B_dependent && (n_ABBAB_fb > n_ABBAB_ready)) ?
                    n_ABBAB_fb : n_ABBAB_ready;
assign t_ABBAB_b_finish = t_ABBAB_b_sl + B_lat_ext[3];
assign t_ABBAB_a_dep_start = (n_ABBAB_fa > (t_ABBAB_b_sl + 9'd1)) ?
                           n_ABBAB_fa : (t_ABBAB_b_sl + 9'd1);
assign t_ABBAB_a_finish = A_dependent ?
                        (t_ABBAB_a_dep_start + A_dep_sum_2) :
                        (t_ABBAB_b_sl + A_ind_tail_2);
assign t_ABBAB_max = (t_ABBAB_b_finish > n_ABBAB_fm) ?
                   t_ABBAB_b_finish : n_ABBAB_fm;
assign l44_ABBABBAA_cycle = (t_ABBAB_a_finish > t_ABBAB_max) ?
                              t_ABBAB_a_finish : t_ABBAB_max;

// l44_ABBBABAA
wire [8:0] t_ABBBA_b_sl, t_ABBBA_b_finish;
wire [8:0] t_ABBBA_a_dep_start, t_ABBBA_a_finish, t_ABBBA_max;
wire [8:0] l44_ABBBABAA_cycle;
assign t_ABBBA_b_sl = (B_dependent && (n_ABBBA_fb > n_ABBBA_ready)) ?
                    n_ABBBA_fb : n_ABBBA_ready;
assign t_ABBBA_b_finish = t_ABBBA_b_sl + B_lat_ext[3];
assign t_ABBBA_a_dep_start = (n_ABBBA_fa > (t_ABBBA_b_sl + 9'd1)) ?
                           n_ABBBA_fa : (t_ABBBA_b_sl + 9'd1);
assign t_ABBBA_a_finish = A_dependent ?
                        (t_ABBBA_a_dep_start + A_dep_sum_2) :
                        (t_ABBBA_b_sl + A_ind_tail_2);
assign t_ABBBA_max = (t_ABBBA_b_finish > n_ABBBA_fm) ?
                   t_ABBBA_b_finish : n_ABBBA_fm;
assign l44_ABBBABAA_cycle = (t_ABBBA_a_finish > t_ABBBA_max) ?
                              t_ABBBA_a_finish : t_ABBBA_max;

// l44_BAABBBAA
wire [8:0] t_BAABB_b_sl, t_BAABB_b_finish;
wire [8:0] t_BAABB_a_dep_start, t_BAABB_a_finish, t_BAABB_max;
wire [8:0] l44_BAABBBAA_cycle;
assign t_BAABB_b_sl = (B_dependent && (n_BAABB_fb > n_BAABB_ready)) ?
                    n_BAABB_fb : n_BAABB_ready;
assign t_BAABB_b_finish = t_BAABB_b_sl + B_lat_ext[3];
assign t_BAABB_a_dep_start = (n_BAABB_fa > (t_BAABB_b_sl + 9'd1)) ?
                           n_BAABB_fa : (t_BAABB_b_sl + 9'd1);
assign t_BAABB_a_finish = A_dependent ?
                        (t_BAABB_a_dep_start + A_dep_sum_2) :
                        (t_BAABB_b_sl + A_ind_tail_2);
assign t_BAABB_max = (t_BAABB_b_finish > n_BAABB_fm) ?
                   t_BAABB_b_finish : n_BAABB_fm;
assign l44_BAABBBAA_cycle = (t_BAABB_a_finish > t_BAABB_max) ?
                              t_BAABB_a_finish : t_BAABB_max;

// l44_BABABBAA
wire [8:0] t_BABAB_b_sl, t_BABAB_b_finish;
wire [8:0] t_BABAB_a_dep_start, t_BABAB_a_finish, t_BABAB_max;
wire [8:0] l44_BABABBAA_cycle;
assign t_BABAB_b_sl = (B_dependent && (n_BABAB_fb > n_BABAB_ready)) ?
                    n_BABAB_fb : n_BABAB_ready;
assign t_BABAB_b_finish = t_BABAB_b_sl + B_lat_ext[3];
assign t_BABAB_a_dep_start = (n_BABAB_fa > (t_BABAB_b_sl + 9'd1)) ?
                           n_BABAB_fa : (t_BABAB_b_sl + 9'd1);
assign t_BABAB_a_finish = A_dependent ?
                        (t_BABAB_a_dep_start + A_dep_sum_2) :
                        (t_BABAB_b_sl + A_ind_tail_2);
assign t_BABAB_max = (t_BABAB_b_finish > n_BABAB_fm) ?
                   t_BABAB_b_finish : n_BABAB_fm;
assign l44_BABABBAA_cycle = (t_BABAB_a_finish > t_BABAB_max) ?
                              t_BABAB_a_finish : t_BABAB_max;

// l44_BABBABAA
wire [8:0] t_BABBA_b_sl, t_BABBA_b_finish;
wire [8:0] t_BABBA_a_dep_start, t_BABBA_a_finish, t_BABBA_max;
wire [8:0] l44_BABBABAA_cycle;
assign t_BABBA_b_sl = (B_dependent && (n_BABBA_fb > n_BABBA_ready)) ?
                    n_BABBA_fb : n_BABBA_ready;
assign t_BABBA_b_finish = t_BABBA_b_sl + B_lat_ext[3];
assign t_BABBA_a_dep_start = (n_BABBA_fa > (t_BABBA_b_sl + 9'd1)) ?
                           n_BABBA_fa : (t_BABBA_b_sl + 9'd1);
assign t_BABBA_a_finish = A_dependent ?
                        (t_BABBA_a_dep_start + A_dep_sum_2) :
                        (t_BABBA_b_sl + A_ind_tail_2);
assign t_BABBA_max = (t_BABBA_b_finish > n_BABBA_fm) ?
                   t_BABBA_b_finish : n_BABBA_fm;
assign l44_BABBABAA_cycle = (t_BABBA_a_finish > t_BABBA_max) ?
                              t_BABBA_a_finish : t_BABBA_max;

// l44_BBAABBAA
wire [8:0] t_BBAAB_b_sl, t_BBAAB_b_finish;
wire [8:0] t_BBAAB_a_dep_start, t_BBAAB_a_finish, t_BBAAB_max;
wire [8:0] l44_BBAABBAA_cycle;
assign t_BBAAB_b_sl = (B_dependent && (n_BBAAB_fb > n_BBAAB_ready)) ?
                    n_BBAAB_fb : n_BBAAB_ready;
assign t_BBAAB_b_finish = t_BBAAB_b_sl + B_lat_ext[3];
assign t_BBAAB_a_dep_start = (n_BBAAB_fa > (t_BBAAB_b_sl + 9'd1)) ?
                           n_BBAAB_fa : (t_BBAAB_b_sl + 9'd1);
assign t_BBAAB_a_finish = A_dependent ?
                        (t_BBAAB_a_dep_start + A_dep_sum_2) :
                        (t_BBAAB_b_sl + A_ind_tail_2);
assign t_BBAAB_max = (t_BBAAB_b_finish > n_BBAAB_fm) ?
                   t_BBAAB_b_finish : n_BBAAB_fm;
assign l44_BBAABBAA_cycle = (t_BBAAB_a_finish > t_BBAAB_max) ?
                              t_BBAAB_a_finish : t_BBAAB_max;

// l44_BBABABAA
wire [8:0] t_BBABA_b_sl, t_BBABA_b_finish;
wire [8:0] t_BBABA_a_dep_start, t_BBABA_a_finish, t_BBABA_max;
wire [8:0] l44_BBABABAA_cycle;
assign t_BBABA_b_sl = (B_dependent && (n_BBABA_fb > n_BBABA_ready)) ?
                    n_BBABA_fb : n_BBABA_ready;
assign t_BBABA_b_finish = t_BBABA_b_sl + B_lat_ext[3];
assign t_BBABA_a_dep_start = (n_BBABA_fa > (t_BBABA_b_sl + 9'd1)) ?
                           n_BBABA_fa : (t_BBABA_b_sl + 9'd1);
assign t_BBABA_a_finish = A_dependent ?
                        (t_BBABA_a_dep_start + A_dep_sum_2) :
                        (t_BBABA_b_sl + A_ind_tail_2);
assign t_BBABA_max = (t_BBABA_b_finish > n_BBABA_fm) ?
                   t_BBABA_b_finish : n_BBABA_fm;
assign l44_BBABABAA_cycle = (t_BBABA_a_finish > t_BBABA_max) ?
                              t_BBABA_a_finish : t_BBABA_max;

// l44_BBBAABAA
wire [8:0] t_BBBAA_b_sl, t_BBBAA_b_finish;
wire [8:0] t_BBBAA_a_dep_start, t_BBBAA_a_finish, t_BBBAA_max;
wire [8:0] l44_BBBAABAA_cycle;
assign t_BBBAA_b_sl = (B_dependent && (n_BBBAA_fb > n_BBBAA_ready)) ?
                    n_BBBAA_fb : n_BBBAA_ready;
assign t_BBBAA_b_finish = t_BBBAA_b_sl + B_lat_ext[3];
assign t_BBBAA_a_dep_start = (n_BBBAA_fa > (t_BBBAA_b_sl + 9'd1)) ?
                           n_BBBAA_fa : (t_BBBAA_b_sl + 9'd1);
assign t_BBBAA_a_finish = A_dependent ?
                        (t_BBBAA_a_dep_start + A_dep_sum_2) :
                        (t_BBBAA_b_sl + A_ind_tail_2);
assign t_BBBAA_max = (t_BBBAA_b_finish > n_BBBAA_fm) ?
                   t_BBBAA_b_finish : n_BBBAA_fm;
assign l44_BBBAABAA_cycle = (t_BBBAA_a_finish > t_BBBAA_max) ?
                              t_BBBAA_a_finish : t_BBBAA_max;

// l44_AAABBBBA
wire [8:0] t_AAABBB_b_sl, t_AAABBB_b_finish;
wire [8:0] t_AAABBB_a_dep_start, t_AAABBB_a_finish, t_AAABBB_max;
wire [8:0] l44_AAABBBBA_cycle;
assign t_AAABBB_b_sl = (B_dependent && (n_AAABBB_fb > n_AAABBB_ready)) ?
                    n_AAABBB_fb : n_AAABBB_ready;
assign t_AAABBB_b_finish = t_AAABBB_b_sl + B_lat_ext[3];
assign t_AAABBB_a_dep_start = (n_AAABBB_fa > (t_AAABBB_b_sl + 9'd1)) ?
                           n_AAABBB_fa : (t_AAABBB_b_sl + 9'd1);
assign t_AAABBB_a_finish = A_dependent ?
                        (t_AAABBB_a_dep_start + A_dep_sum_3) :
                        (t_AAABBB_b_sl + A_ind_tail_3);
assign t_AAABBB_max = (t_AAABBB_b_finish > n_AAABBB_fm) ?
                   t_AAABBB_b_finish : n_AAABBB_fm;
assign l44_AAABBBBA_cycle = (t_AAABBB_a_finish > t_AAABBB_max) ?
                              t_AAABBB_a_finish : t_AAABBB_max;

// l44_AABABBBA
wire [8:0] t_AABABB_b_sl, t_AABABB_b_finish;
wire [8:0] t_AABABB_a_dep_start, t_AABABB_a_finish, t_AABABB_max;
wire [8:0] l44_AABABBBA_cycle;
assign t_AABABB_b_sl = (B_dependent && (n_AABABB_fb > n_AABABB_ready)) ?
                    n_AABABB_fb : n_AABABB_ready;
assign t_AABABB_b_finish = t_AABABB_b_sl + B_lat_ext[3];
assign t_AABABB_a_dep_start = (n_AABABB_fa > (t_AABABB_b_sl + 9'd1)) ?
                           n_AABABB_fa : (t_AABABB_b_sl + 9'd1);
assign t_AABABB_a_finish = A_dependent ?
                        (t_AABABB_a_dep_start + A_dep_sum_3) :
                        (t_AABABB_b_sl + A_ind_tail_3);
assign t_AABABB_max = (t_AABABB_b_finish > n_AABABB_fm) ?
                   t_AABABB_b_finish : n_AABABB_fm;
assign l44_AABABBBA_cycle = (t_AABABB_a_finish > t_AABABB_max) ?
                              t_AABABB_a_finish : t_AABABB_max;

// l44_AABBABBA
wire [8:0] t_AABBAB_b_sl, t_AABBAB_b_finish;
wire [8:0] t_AABBAB_a_dep_start, t_AABBAB_a_finish, t_AABBAB_max;
wire [8:0] l44_AABBABBA_cycle;
assign t_AABBAB_b_sl = (B_dependent && (n_AABBAB_fb > n_AABBAB_ready)) ?
                    n_AABBAB_fb : n_AABBAB_ready;
assign t_AABBAB_b_finish = t_AABBAB_b_sl + B_lat_ext[3];
assign t_AABBAB_a_dep_start = (n_AABBAB_fa > (t_AABBAB_b_sl + 9'd1)) ?
                           n_AABBAB_fa : (t_AABBAB_b_sl + 9'd1);
assign t_AABBAB_a_finish = A_dependent ?
                        (t_AABBAB_a_dep_start + A_dep_sum_3) :
                        (t_AABBAB_b_sl + A_ind_tail_3);
assign t_AABBAB_max = (t_AABBAB_b_finish > n_AABBAB_fm) ?
                   t_AABBAB_b_finish : n_AABBAB_fm;
assign l44_AABBABBA_cycle = (t_AABBAB_a_finish > t_AABBAB_max) ?
                              t_AABBAB_a_finish : t_AABBAB_max;

// l44_AABBBABA
wire [8:0] t_AABBBA_b_sl, t_AABBBA_b_finish;
wire [8:0] t_AABBBA_a_dep_start, t_AABBBA_a_finish, t_AABBBA_max;
wire [8:0] l44_AABBBABA_cycle;
assign t_AABBBA_b_sl = (B_dependent && (n_AABBBA_fb > n_AABBBA_ready)) ?
                    n_AABBBA_fb : n_AABBBA_ready;
assign t_AABBBA_b_finish = t_AABBBA_b_sl + B_lat_ext[3];
assign t_AABBBA_a_dep_start = (n_AABBBA_fa > (t_AABBBA_b_sl + 9'd1)) ?
                           n_AABBBA_fa : (t_AABBBA_b_sl + 9'd1);
assign t_AABBBA_a_finish = A_dependent ?
                        (t_AABBBA_a_dep_start + A_dep_sum_3) :
                        (t_AABBBA_b_sl + A_ind_tail_3);
assign t_AABBBA_max = (t_AABBBA_b_finish > n_AABBBA_fm) ?
                   t_AABBBA_b_finish : n_AABBBA_fm;
assign l44_AABBBABA_cycle = (t_AABBBA_a_finish > t_AABBBA_max) ?
                              t_AABBBA_a_finish : t_AABBBA_max;

// l44_ABAABBBA
wire [8:0] t_ABAABB_b_sl, t_ABAABB_b_finish;
wire [8:0] t_ABAABB_a_dep_start, t_ABAABB_a_finish, t_ABAABB_max;
wire [8:0] l44_ABAABBBA_cycle;
assign t_ABAABB_b_sl = (B_dependent && (n_ABAABB_fb > n_ABAABB_ready)) ?
                    n_ABAABB_fb : n_ABAABB_ready;
assign t_ABAABB_b_finish = t_ABAABB_b_sl + B_lat_ext[3];
assign t_ABAABB_a_dep_start = (n_ABAABB_fa > (t_ABAABB_b_sl + 9'd1)) ?
                           n_ABAABB_fa : (t_ABAABB_b_sl + 9'd1);
assign t_ABAABB_a_finish = A_dependent ?
                        (t_ABAABB_a_dep_start + A_dep_sum_3) :
                        (t_ABAABB_b_sl + A_ind_tail_3);
assign t_ABAABB_max = (t_ABAABB_b_finish > n_ABAABB_fm) ?
                   t_ABAABB_b_finish : n_ABAABB_fm;
assign l44_ABAABBBA_cycle = (t_ABAABB_a_finish > t_ABAABB_max) ?
                              t_ABAABB_a_finish : t_ABAABB_max;

// l44_ABABABBA
wire [8:0] t_ABABAB_b_sl, t_ABABAB_b_finish;
wire [8:0] t_ABABAB_a_dep_start, t_ABABAB_a_finish, t_ABABAB_max;
wire [8:0] l44_ABABABBA_cycle;
assign t_ABABAB_b_sl = (B_dependent && (n_ABABAB_fb > n_ABABAB_ready)) ?
                    n_ABABAB_fb : n_ABABAB_ready;
assign t_ABABAB_b_finish = t_ABABAB_b_sl + B_lat_ext[3];
assign t_ABABAB_a_dep_start = (n_ABABAB_fa > (t_ABABAB_b_sl + 9'd1)) ?
                           n_ABABAB_fa : (t_ABABAB_b_sl + 9'd1);
assign t_ABABAB_a_finish = A_dependent ?
                        (t_ABABAB_a_dep_start + A_dep_sum_3) :
                        (t_ABABAB_b_sl + A_ind_tail_3);
assign t_ABABAB_max = (t_ABABAB_b_finish > n_ABABAB_fm) ?
                   t_ABABAB_b_finish : n_ABABAB_fm;
assign l44_ABABABBA_cycle = (t_ABABAB_a_finish > t_ABABAB_max) ?
                              t_ABABAB_a_finish : t_ABABAB_max;

// l44_ABABBABA
wire [8:0] t_ABABBA_b_sl, t_ABABBA_b_finish;
wire [8:0] t_ABABBA_a_dep_start, t_ABABBA_a_finish, t_ABABBA_max;
wire [8:0] l44_ABABBABA_cycle;
assign t_ABABBA_b_sl = (B_dependent && (n_ABABBA_fb > n_ABABBA_ready)) ?
                    n_ABABBA_fb : n_ABABBA_ready;
assign t_ABABBA_b_finish = t_ABABBA_b_sl + B_lat_ext[3];
assign t_ABABBA_a_dep_start = (n_ABABBA_fa > (t_ABABBA_b_sl + 9'd1)) ?
                           n_ABABBA_fa : (t_ABABBA_b_sl + 9'd1);
assign t_ABABBA_a_finish = A_dependent ?
                        (t_ABABBA_a_dep_start + A_dep_sum_3) :
                        (t_ABABBA_b_sl + A_ind_tail_3);
assign t_ABABBA_max = (t_ABABBA_b_finish > n_ABABBA_fm) ?
                   t_ABABBA_b_finish : n_ABABBA_fm;
assign l44_ABABBABA_cycle = (t_ABABBA_a_finish > t_ABABBA_max) ?
                              t_ABABBA_a_finish : t_ABABBA_max;

// l44_ABBAABBA
wire [8:0] t_ABBAAB_b_sl, t_ABBAAB_b_finish;
wire [8:0] t_ABBAAB_a_dep_start, t_ABBAAB_a_finish, t_ABBAAB_max;
wire [8:0] l44_ABBAABBA_cycle;
assign t_ABBAAB_b_sl = (B_dependent && (n_ABBAAB_fb > n_ABBAAB_ready)) ?
                    n_ABBAAB_fb : n_ABBAAB_ready;
assign t_ABBAAB_b_finish = t_ABBAAB_b_sl + B_lat_ext[3];
assign t_ABBAAB_a_dep_start = (n_ABBAAB_fa > (t_ABBAAB_b_sl + 9'd1)) ?
                           n_ABBAAB_fa : (t_ABBAAB_b_sl + 9'd1);
assign t_ABBAAB_a_finish = A_dependent ?
                        (t_ABBAAB_a_dep_start + A_dep_sum_3) :
                        (t_ABBAAB_b_sl + A_ind_tail_3);
assign t_ABBAAB_max = (t_ABBAAB_b_finish > n_ABBAAB_fm) ?
                   t_ABBAAB_b_finish : n_ABBAAB_fm;
assign l44_ABBAABBA_cycle = (t_ABBAAB_a_finish > t_ABBAAB_max) ?
                              t_ABBAAB_a_finish : t_ABBAAB_max;

// l44_ABBABABA
wire [8:0] t_ABBABA_b_sl, t_ABBABA_b_finish;
wire [8:0] t_ABBABA_a_dep_start, t_ABBABA_a_finish, t_ABBABA_max;
wire [8:0] l44_ABBABABA_cycle;
assign t_ABBABA_b_sl = (B_dependent && (n_ABBABA_fb > n_ABBABA_ready)) ?
                    n_ABBABA_fb : n_ABBABA_ready;
assign t_ABBABA_b_finish = t_ABBABA_b_sl + B_lat_ext[3];
assign t_ABBABA_a_dep_start = (n_ABBABA_fa > (t_ABBABA_b_sl + 9'd1)) ?
                           n_ABBABA_fa : (t_ABBABA_b_sl + 9'd1);
assign t_ABBABA_a_finish = A_dependent ?
                        (t_ABBABA_a_dep_start + A_dep_sum_3) :
                        (t_ABBABA_b_sl + A_ind_tail_3);
assign t_ABBABA_max = (t_ABBABA_b_finish > n_ABBABA_fm) ?
                   t_ABBABA_b_finish : n_ABBABA_fm;
assign l44_ABBABABA_cycle = (t_ABBABA_a_finish > t_ABBABA_max) ?
                              t_ABBABA_a_finish : t_ABBABA_max;

// l44_ABBBAABA
wire [8:0] t_ABBBAA_b_sl, t_ABBBAA_b_finish;
wire [8:0] t_ABBBAA_a_dep_start, t_ABBBAA_a_finish, t_ABBBAA_max;
wire [8:0] l44_ABBBAABA_cycle;
assign t_ABBBAA_b_sl = (B_dependent && (n_ABBBAA_fb > n_ABBBAA_ready)) ?
                    n_ABBBAA_fb : n_ABBBAA_ready;
assign t_ABBBAA_b_finish = t_ABBBAA_b_sl + B_lat_ext[3];
assign t_ABBBAA_a_dep_start = (n_ABBBAA_fa > (t_ABBBAA_b_sl + 9'd1)) ?
                           n_ABBBAA_fa : (t_ABBBAA_b_sl + 9'd1);
assign t_ABBBAA_a_finish = A_dependent ?
                        (t_ABBBAA_a_dep_start + A_dep_sum_3) :
                        (t_ABBBAA_b_sl + A_ind_tail_3);
assign t_ABBBAA_max = (t_ABBBAA_b_finish > n_ABBBAA_fm) ?
                   t_ABBBAA_b_finish : n_ABBBAA_fm;
assign l44_ABBBAABA_cycle = (t_ABBBAA_a_finish > t_ABBBAA_max) ?
                              t_ABBBAA_a_finish : t_ABBBAA_max;

// l44_BAAABBBA
wire [8:0] t_BAAABB_b_sl, t_BAAABB_b_finish;
wire [8:0] t_BAAABB_a_dep_start, t_BAAABB_a_finish, t_BAAABB_max;
wire [8:0] l44_BAAABBBA_cycle;
assign t_BAAABB_b_sl = (B_dependent && (n_BAAABB_fb > n_BAAABB_ready)) ?
                    n_BAAABB_fb : n_BAAABB_ready;
assign t_BAAABB_b_finish = t_BAAABB_b_sl + B_lat_ext[3];
assign t_BAAABB_a_dep_start = (n_BAAABB_fa > (t_BAAABB_b_sl + 9'd1)) ?
                           n_BAAABB_fa : (t_BAAABB_b_sl + 9'd1);
assign t_BAAABB_a_finish = A_dependent ?
                        (t_BAAABB_a_dep_start + A_dep_sum_3) :
                        (t_BAAABB_b_sl + A_ind_tail_3);
assign t_BAAABB_max = (t_BAAABB_b_finish > n_BAAABB_fm) ?
                   t_BAAABB_b_finish : n_BAAABB_fm;
assign l44_BAAABBBA_cycle = (t_BAAABB_a_finish > t_BAAABB_max) ?
                              t_BAAABB_a_finish : t_BAAABB_max;

// l44_BAABABBA
wire [8:0] t_BAABAB_b_sl, t_BAABAB_b_finish;
wire [8:0] t_BAABAB_a_dep_start, t_BAABAB_a_finish, t_BAABAB_max;
wire [8:0] l44_BAABABBA_cycle;
assign t_BAABAB_b_sl = (B_dependent && (n_BAABAB_fb > n_BAABAB_ready)) ?
                    n_BAABAB_fb : n_BAABAB_ready;
assign t_BAABAB_b_finish = t_BAABAB_b_sl + B_lat_ext[3];
assign t_BAABAB_a_dep_start = (n_BAABAB_fa > (t_BAABAB_b_sl + 9'd1)) ?
                           n_BAABAB_fa : (t_BAABAB_b_sl + 9'd1);
assign t_BAABAB_a_finish = A_dependent ?
                        (t_BAABAB_a_dep_start + A_dep_sum_3) :
                        (t_BAABAB_b_sl + A_ind_tail_3);
assign t_BAABAB_max = (t_BAABAB_b_finish > n_BAABAB_fm) ?
                   t_BAABAB_b_finish : n_BAABAB_fm;
assign l44_BAABABBA_cycle = (t_BAABAB_a_finish > t_BAABAB_max) ?
                              t_BAABAB_a_finish : t_BAABAB_max;

// l44_BAABBABA
wire [8:0] t_BAABBA_b_sl, t_BAABBA_b_finish;
wire [8:0] t_BAABBA_a_dep_start, t_BAABBA_a_finish, t_BAABBA_max;
wire [8:0] l44_BAABBABA_cycle;
assign t_BAABBA_b_sl = (B_dependent && (n_BAABBA_fb > n_BAABBA_ready)) ?
                    n_BAABBA_fb : n_BAABBA_ready;
assign t_BAABBA_b_finish = t_BAABBA_b_sl + B_lat_ext[3];
assign t_BAABBA_a_dep_start = (n_BAABBA_fa > (t_BAABBA_b_sl + 9'd1)) ?
                           n_BAABBA_fa : (t_BAABBA_b_sl + 9'd1);
assign t_BAABBA_a_finish = A_dependent ?
                        (t_BAABBA_a_dep_start + A_dep_sum_3) :
                        (t_BAABBA_b_sl + A_ind_tail_3);
assign t_BAABBA_max = (t_BAABBA_b_finish > n_BAABBA_fm) ?
                   t_BAABBA_b_finish : n_BAABBA_fm;
assign l44_BAABBABA_cycle = (t_BAABBA_a_finish > t_BAABBA_max) ?
                              t_BAABBA_a_finish : t_BAABBA_max;

// l44_BABAABBA
wire [8:0] t_BABAAB_b_sl, t_BABAAB_b_finish;
wire [8:0] t_BABAAB_a_dep_start, t_BABAAB_a_finish, t_BABAAB_max;
wire [8:0] l44_BABAABBA_cycle;
assign t_BABAAB_b_sl = (B_dependent && (n_BABAAB_fb > n_BABAAB_ready)) ?
                    n_BABAAB_fb : n_BABAAB_ready;
assign t_BABAAB_b_finish = t_BABAAB_b_sl + B_lat_ext[3];
assign t_BABAAB_a_dep_start = (n_BABAAB_fa > (t_BABAAB_b_sl + 9'd1)) ?
                           n_BABAAB_fa : (t_BABAAB_b_sl + 9'd1);
assign t_BABAAB_a_finish = A_dependent ?
                        (t_BABAAB_a_dep_start + A_dep_sum_3) :
                        (t_BABAAB_b_sl + A_ind_tail_3);
assign t_BABAAB_max = (t_BABAAB_b_finish > n_BABAAB_fm) ?
                   t_BABAAB_b_finish : n_BABAAB_fm;
assign l44_BABAABBA_cycle = (t_BABAAB_a_finish > t_BABAAB_max) ?
                              t_BABAAB_a_finish : t_BABAAB_max;

// l44_BABABABA
wire [8:0] t_BABABA_b_sl, t_BABABA_b_finish;
wire [8:0] t_BABABA_a_dep_start, t_BABABA_a_finish, t_BABABA_max;
wire [8:0] l44_BABABABA_cycle;
assign t_BABABA_b_sl = (B_dependent && (n_BABABA_fb > n_BABABA_ready)) ?
                    n_BABABA_fb : n_BABABA_ready;
assign t_BABABA_b_finish = t_BABABA_b_sl + B_lat_ext[3];
assign t_BABABA_a_dep_start = (n_BABABA_fa > (t_BABABA_b_sl + 9'd1)) ?
                           n_BABABA_fa : (t_BABABA_b_sl + 9'd1);
assign t_BABABA_a_finish = A_dependent ?
                        (t_BABABA_a_dep_start + A_dep_sum_3) :
                        (t_BABABA_b_sl + A_ind_tail_3);
assign t_BABABA_max = (t_BABABA_b_finish > n_BABABA_fm) ?
                   t_BABABA_b_finish : n_BABABA_fm;
assign l44_BABABABA_cycle = (t_BABABA_a_finish > t_BABABA_max) ?
                              t_BABABA_a_finish : t_BABABA_max;

// l44_BABBAABA
wire [8:0] t_BABBAA_b_sl, t_BABBAA_b_finish;
wire [8:0] t_BABBAA_a_dep_start, t_BABBAA_a_finish, t_BABBAA_max;
wire [8:0] l44_BABBAABA_cycle;
assign t_BABBAA_b_sl = (B_dependent && (n_BABBAA_fb > n_BABBAA_ready)) ?
                    n_BABBAA_fb : n_BABBAA_ready;
assign t_BABBAA_b_finish = t_BABBAA_b_sl + B_lat_ext[3];
assign t_BABBAA_a_dep_start = (n_BABBAA_fa > (t_BABBAA_b_sl + 9'd1)) ?
                           n_BABBAA_fa : (t_BABBAA_b_sl + 9'd1);
assign t_BABBAA_a_finish = A_dependent ?
                        (t_BABBAA_a_dep_start + A_dep_sum_3) :
                        (t_BABBAA_b_sl + A_ind_tail_3);
assign t_BABBAA_max = (t_BABBAA_b_finish > n_BABBAA_fm) ?
                   t_BABBAA_b_finish : n_BABBAA_fm;
assign l44_BABBAABA_cycle = (t_BABBAA_a_finish > t_BABBAA_max) ?
                              t_BABBAA_a_finish : t_BABBAA_max;

// l44_BBAAABBA
wire [8:0] t_BBAAAB_b_sl, t_BBAAAB_b_finish;
wire [8:0] t_BBAAAB_a_dep_start, t_BBAAAB_a_finish, t_BBAAAB_max;
wire [8:0] l44_BBAAABBA_cycle;
assign t_BBAAAB_b_sl = (B_dependent && (n_BBAAAB_fb > n_BBAAAB_ready)) ?
                    n_BBAAAB_fb : n_BBAAAB_ready;
assign t_BBAAAB_b_finish = t_BBAAAB_b_sl + B_lat_ext[3];
assign t_BBAAAB_a_dep_start = (n_BBAAAB_fa > (t_BBAAAB_b_sl + 9'd1)) ?
                           n_BBAAAB_fa : (t_BBAAAB_b_sl + 9'd1);
assign t_BBAAAB_a_finish = A_dependent ?
                        (t_BBAAAB_a_dep_start + A_dep_sum_3) :
                        (t_BBAAAB_b_sl + A_ind_tail_3);
assign t_BBAAAB_max = (t_BBAAAB_b_finish > n_BBAAAB_fm) ?
                   t_BBAAAB_b_finish : n_BBAAAB_fm;
assign l44_BBAAABBA_cycle = (t_BBAAAB_a_finish > t_BBAAAB_max) ?
                              t_BBAAAB_a_finish : t_BBAAAB_max;

// l44_BBAABABA
wire [8:0] t_BBAABA_b_sl, t_BBAABA_b_finish;
wire [8:0] t_BBAABA_a_dep_start, t_BBAABA_a_finish, t_BBAABA_max;
wire [8:0] l44_BBAABABA_cycle;
assign t_BBAABA_b_sl = (B_dependent && (n_BBAABA_fb > n_BBAABA_ready)) ?
                    n_BBAABA_fb : n_BBAABA_ready;
assign t_BBAABA_b_finish = t_BBAABA_b_sl + B_lat_ext[3];
assign t_BBAABA_a_dep_start = (n_BBAABA_fa > (t_BBAABA_b_sl + 9'd1)) ?
                           n_BBAABA_fa : (t_BBAABA_b_sl + 9'd1);
assign t_BBAABA_a_finish = A_dependent ?
                        (t_BBAABA_a_dep_start + A_dep_sum_3) :
                        (t_BBAABA_b_sl + A_ind_tail_3);
assign t_BBAABA_max = (t_BBAABA_b_finish > n_BBAABA_fm) ?
                   t_BBAABA_b_finish : n_BBAABA_fm;
assign l44_BBAABABA_cycle = (t_BBAABA_a_finish > t_BBAABA_max) ?
                              t_BBAABA_a_finish : t_BBAABA_max;

// l44_BBABAABA
wire [8:0] t_BBABAA_b_sl, t_BBABAA_b_finish;
wire [8:0] t_BBABAA_a_dep_start, t_BBABAA_a_finish, t_BBABAA_max;
wire [8:0] l44_BBABAABA_cycle;
assign t_BBABAA_b_sl = (B_dependent && (n_BBABAA_fb > n_BBABAA_ready)) ?
                    n_BBABAA_fb : n_BBABAA_ready;
assign t_BBABAA_b_finish = t_BBABAA_b_sl + B_lat_ext[3];
assign t_BBABAA_a_dep_start = (n_BBABAA_fa > (t_BBABAA_b_sl + 9'd1)) ?
                           n_BBABAA_fa : (t_BBABAA_b_sl + 9'd1);
assign t_BBABAA_a_finish = A_dependent ?
                        (t_BBABAA_a_dep_start + A_dep_sum_3) :
                        (t_BBABAA_b_sl + A_ind_tail_3);
assign t_BBABAA_max = (t_BBABAA_b_finish > n_BBABAA_fm) ?
                   t_BBABAA_b_finish : n_BBABAA_fm;
assign l44_BBABAABA_cycle = (t_BBABAA_a_finish > t_BBABAA_max) ?
                              t_BBABAA_a_finish : t_BBABAA_max;

// l44_BBBAAABA
wire [8:0] t_BBBAAA_b_sl, t_BBBAAA_b_finish;
wire [8:0] t_BBBAAA_a_dep_start, t_BBBAAA_a_finish, t_BBBAAA_max;
wire [8:0] l44_BBBAAABA_cycle;
assign t_BBBAAA_b_sl = (B_dependent && (n_BBBAAA_fb > n_BBBAAA_ready)) ?
                    n_BBBAAA_fb : n_BBBAAA_ready;
assign t_BBBAAA_b_finish = t_BBBAAA_b_sl + B_lat_ext[3];
assign t_BBBAAA_a_dep_start = (n_BBBAAA_fa > (t_BBBAAA_b_sl + 9'd1)) ?
                           n_BBBAAA_fa : (t_BBBAAA_b_sl + 9'd1);
assign t_BBBAAA_a_finish = A_dependent ?
                        (t_BBBAAA_a_dep_start + A_dep_sum_3) :
                        (t_BBBAAA_b_sl + A_ind_tail_3);
assign t_BBBAAA_max = (t_BBBAAA_b_finish > n_BBBAAA_fm) ?
                   t_BBBAAA_b_finish : n_BBBAAA_fm;
assign l44_BBBAAABA_cycle = (t_BBBAAA_a_finish > t_BBBAAA_max) ?
                              t_BBBAAA_a_finish : t_BBBAAA_max;


//////// FINAL LEAVES ////////

// depth-7 branches

wire [8:0] n_AAAAAAA_ready = n_AAAAAAA_sl + 9'd1;
wire [8:0] n_AAAAAAB_ready = n_AAAAAAB_sl + 9'd1;
wire [8:0] n_AAAAABA_ready = n_AAAAABA_sl + 9'd1;
wire [8:0] n_AAAAABB_ready = n_AAAAABB_sl + 9'd1;
wire [8:0] n_AAAABAA_ready = n_AAAABAA_sl + 9'd1;
wire [8:0] n_AAAABAB_ready = n_AAAABAB_sl + 9'd1;
wire [8:0] n_AAAABBA_ready = n_AAAABBA_sl + 9'd1;
wire [8:0] n_AAAABBB_ready = n_AAAABBB_sl + 9'd1;
wire [8:0] n_AAABAAA_ready = n_AAABAAA_sl + 9'd1;
wire [8:0] n_AAABAAB_ready = n_AAABAAB_sl + 9'd1;
wire [8:0] n_AAABABA_ready = n_AAABABA_sl + 9'd1;
wire [8:0] n_AAABABB_ready = n_AAABABB_sl + 9'd1;
wire [8:0] n_AAABBAA_ready = n_AAABBAA_sl + 9'd1;
wire [8:0] n_AAABBAB_ready = n_AAABBAB_sl + 9'd1;
wire [8:0] n_AAABBBA_ready = n_AAABBBA_sl + 9'd1;
wire [8:0] n_AABAAAA_ready = n_AABAAAA_sl + 9'd1;
wire [8:0] n_AABAAAB_ready = n_AABAAAB_sl + 9'd1;
wire [8:0] n_AABAABA_ready = n_AABAABA_sl + 9'd1;
wire [8:0] n_AABAABB_ready = n_AABAABB_sl + 9'd1;
wire [8:0] n_AABABAA_ready = n_AABABAA_sl + 9'd1;
wire [8:0] n_AABABAB_ready = n_AABABAB_sl + 9'd1;
wire [8:0] n_AABABBA_ready = n_AABABBA_sl + 9'd1;
wire [8:0] n_AABBAAA_ready = n_AABBAAA_sl + 9'd1;
wire [8:0] n_AABBAAB_ready = n_AABBAAB_sl + 9'd1;
wire [8:0] n_AABBABA_ready = n_AABBABA_sl + 9'd1;
wire [8:0] n_AABBBAA_ready = n_AABBBAA_sl + 9'd1;
wire [8:0] n_ABAAAAA_ready = n_ABAAAAA_sl + 9'd1;
wire [8:0] n_ABAAAAB_ready = n_ABAAAAB_sl + 9'd1;
wire [8:0] n_ABAAABA_ready = n_ABAAABA_sl + 9'd1;
wire [8:0] n_ABAAABB_ready = n_ABAAABB_sl + 9'd1;
wire [8:0] n_ABAABAA_ready = n_ABAABAA_sl + 9'd1;
wire [8:0] n_ABAABAB_ready = n_ABAABAB_sl + 9'd1;
wire [8:0] n_ABAABBA_ready = n_ABAABBA_sl + 9'd1;
wire [8:0] n_ABABAAA_ready = n_ABABAAA_sl + 9'd1;
wire [8:0] n_ABABAAB_ready = n_ABABAAB_sl + 9'd1;
wire [8:0] n_ABABABA_ready = n_ABABABA_sl + 9'd1;
wire [8:0] n_ABABBAA_ready = n_ABABBAA_sl + 9'd1;
wire [8:0] n_ABBAAAA_ready = n_ABBAAAA_sl + 9'd1;
wire [8:0] n_ABBAAAB_ready = n_ABBAAAB_sl + 9'd1;
wire [8:0] n_ABBAABA_ready = n_ABBAABA_sl + 9'd1;
wire [8:0] n_ABBABAA_ready = n_ABBABAA_sl + 9'd1;
wire [8:0] n_ABBBAAA_ready = n_ABBBAAA_sl + 9'd1;
wire [8:0] n_BAAAAAA_ready = n_BAAAAAA_sl + 9'd1;
wire [8:0] n_BAAAAAB_ready = n_BAAAAAB_sl + 9'd1;
wire [8:0] n_BAAAABA_ready = n_BAAAABA_sl + 9'd1;
wire [8:0] n_BAAAABB_ready = n_BAAAABB_sl + 9'd1;
wire [8:0] n_BAAABAA_ready = n_BAAABAA_sl + 9'd1;
wire [8:0] n_BAAABAB_ready = n_BAAABAB_sl + 9'd1;
wire [8:0] n_BAAABBA_ready = n_BAAABBA_sl + 9'd1;
wire [8:0] n_BAABAAA_ready = n_BAABAAA_sl + 9'd1;
wire [8:0] n_BAABAAB_ready = n_BAABAAB_sl + 9'd1;
wire [8:0] n_BAABABA_ready = n_BAABABA_sl + 9'd1;
wire [8:0] n_BAABBAA_ready = n_BAABBAA_sl + 9'd1;
wire [8:0] n_BABAAAA_ready = n_BABAAAA_sl + 9'd1;
wire [8:0] n_BABAAAB_ready = n_BABAAAB_sl + 9'd1;
wire [8:0] n_BABAABA_ready = n_BABAABA_sl + 9'd1;
wire [8:0] n_BABABAA_ready = n_BABABAA_sl + 9'd1;
wire [8:0] n_BABBAAA_ready = n_BABBAAA_sl + 9'd1;
wire [8:0] n_BBAAAAA_ready = n_BBAAAAA_sl + 9'd1;
wire [8:0] n_BBAAAAB_ready = n_BBAAAAB_sl + 9'd1;
wire [8:0] n_BBAAABA_ready = n_BBAAABA_sl + 9'd1;
wire [8:0] n_BBAABAA_ready = n_BBAABAA_sl + 9'd1;
wire [8:0] n_BBABAAA_ready = n_BBABAAA_sl + 9'd1;
wire [8:0] n_BBBAAAA_ready = n_BBBAAAA_sl + 9'd1;

// l80_AAAAAAAA / l71_AAAAAAAB
wire [8:0] f_AAAAAAAA;
wire [8:0] f_AAAAAAAB;
wire [8:0] l80_AAAAAAAA_cycle, l71_AAAAAAAB_cycle;
assign f_AAAAAAAA = ((A_dependent && (n_AAAAAAA_fa > n_AAAAAAA_ready)) ?
                   n_AAAAAAA_fa : n_AAAAAAA_ready) + A_lat_ext[7];
assign f_AAAAAAAB = n_AAAAAAA_ready + B_lat_ext[0];
assign l80_AAAAAAAA_cycle = (f_AAAAAAAA > n_AAAAAAA_fm) ?
                              f_AAAAAAAA : n_AAAAAAA_fm;
assign l71_AAAAAAAB_cycle = (f_AAAAAAAB > n_AAAAAAA_fm) ?
                              f_AAAAAAAB : n_AAAAAAA_fm;

// l71_AAAAAABA / l62_AAAAAABB
wire [8:0] f_AAAAAABA;
wire [8:0] f_AAAAAABB;
wire [8:0] l71_AAAAAABA_cycle, l62_AAAAAABB_cycle;
assign f_AAAAAABA = ((A_dependent && (n_AAAAAAB_fa > n_AAAAAAB_ready)) ?
                   n_AAAAAAB_fa : n_AAAAAAB_ready) + A_lat_ext[6];
assign f_AAAAAABB = ((B_dependent && (n_AAAAAAB_fb > n_AAAAAAB_ready)) ?
                   n_AAAAAAB_fb : n_AAAAAAB_ready) + B_lat_ext[1];
assign l71_AAAAAABA_cycle = (f_AAAAAABA > n_AAAAAAB_fm) ?
                              f_AAAAAABA : n_AAAAAAB_fm;
assign l62_AAAAAABB_cycle = (f_AAAAAABB > n_AAAAAAB_fm) ?
                              f_AAAAAABB : n_AAAAAAB_fm;

// l71_AAAAABAA / l62_AAAAABAB
wire [8:0] f_AAAAABAA;
wire [8:0] f_AAAAABAB;
wire [8:0] l71_AAAAABAA_cycle, l62_AAAAABAB_cycle;
assign f_AAAAABAA = ((A_dependent && (n_AAAAABA_fa > n_AAAAABA_ready)) ?
                   n_AAAAABA_fa : n_AAAAABA_ready) + A_lat_ext[6];
assign f_AAAAABAB = ((B_dependent && (n_AAAAABA_fb > n_AAAAABA_ready)) ?
                   n_AAAAABA_fb : n_AAAAABA_ready) + B_lat_ext[1];
assign l71_AAAAABAA_cycle = (f_AAAAABAA > n_AAAAABA_fm) ?
                              f_AAAAABAA : n_AAAAABA_fm;
assign l62_AAAAABAB_cycle = (f_AAAAABAB > n_AAAAABA_fm) ?
                              f_AAAAABAB : n_AAAAABA_fm;

// l62_AAAAABBA / l53_AAAAABBB
wire [8:0] f_AAAAABBA;
wire [8:0] f_AAAAABBB;
wire [8:0] l62_AAAAABBA_cycle, l53_AAAAABBB_cycle;
assign f_AAAAABBA = ((A_dependent && (n_AAAAABB_fa > n_AAAAABB_ready)) ?
                   n_AAAAABB_fa : n_AAAAABB_ready) + A_lat_ext[5];
assign f_AAAAABBB = ((B_dependent && (n_AAAAABB_fb > n_AAAAABB_ready)) ?
                   n_AAAAABB_fb : n_AAAAABB_ready) + B_lat_ext[2];
assign l62_AAAAABBA_cycle = (f_AAAAABBA > n_AAAAABB_fm) ?
                              f_AAAAABBA : n_AAAAABB_fm;
assign l53_AAAAABBB_cycle = (f_AAAAABBB > n_AAAAABB_fm) ?
                              f_AAAAABBB : n_AAAAABB_fm;

// l71_AAAABAAA / l62_AAAABAAB
wire [8:0] f_AAAABAAA;
wire [8:0] f_AAAABAAB;
wire [8:0] l71_AAAABAAA_cycle, l62_AAAABAAB_cycle;
assign f_AAAABAAA = ((A_dependent && (n_AAAABAA_fa > n_AAAABAA_ready)) ?
                   n_AAAABAA_fa : n_AAAABAA_ready) + A_lat_ext[6];
assign f_AAAABAAB = ((B_dependent && (n_AAAABAA_fb > n_AAAABAA_ready)) ?
                   n_AAAABAA_fb : n_AAAABAA_ready) + B_lat_ext[1];
assign l71_AAAABAAA_cycle = (f_AAAABAAA > n_AAAABAA_fm) ?
                              f_AAAABAAA : n_AAAABAA_fm;
assign l62_AAAABAAB_cycle = (f_AAAABAAB > n_AAAABAA_fm) ?
                              f_AAAABAAB : n_AAAABAA_fm;

// l62_AAAABABA / l53_AAAABABB
wire [8:0] f_AAAABABA;
wire [8:0] f_AAAABABB;
wire [8:0] l62_AAAABABA_cycle, l53_AAAABABB_cycle;
assign f_AAAABABA = ((A_dependent && (n_AAAABAB_fa > n_AAAABAB_ready)) ?
                   n_AAAABAB_fa : n_AAAABAB_ready) + A_lat_ext[5];
assign f_AAAABABB = ((B_dependent && (n_AAAABAB_fb > n_AAAABAB_ready)) ?
                   n_AAAABAB_fb : n_AAAABAB_ready) + B_lat_ext[2];
assign l62_AAAABABA_cycle = (f_AAAABABA > n_AAAABAB_fm) ?
                              f_AAAABABA : n_AAAABAB_fm;
assign l53_AAAABABB_cycle = (f_AAAABABB > n_AAAABAB_fm) ?
                              f_AAAABABB : n_AAAABAB_fm;

// l62_AAAABBAA / l53_AAAABBAB
wire [8:0] f_AAAABBAA;
wire [8:0] f_AAAABBAB;
wire [8:0] l62_AAAABBAA_cycle, l53_AAAABBAB_cycle;
assign f_AAAABBAA = ((A_dependent && (n_AAAABBA_fa > n_AAAABBA_ready)) ?
                   n_AAAABBA_fa : n_AAAABBA_ready) + A_lat_ext[5];
assign f_AAAABBAB = ((B_dependent && (n_AAAABBA_fb > n_AAAABBA_ready)) ?
                   n_AAAABBA_fb : n_AAAABBA_ready) + B_lat_ext[2];
assign l62_AAAABBAA_cycle = (f_AAAABBAA > n_AAAABBA_fm) ?
                              f_AAAABBAA : n_AAAABBA_fm;
assign l53_AAAABBAB_cycle = (f_AAAABBAB > n_AAAABBA_fm) ?
                              f_AAAABBAB : n_AAAABBA_fm;

// l53_AAAABBBA / l44_AAAABBBB
wire [8:0] f_AAAABBBA;
wire [8:0] f_AAAABBBB;
wire [8:0] l53_AAAABBBA_cycle, l44_AAAABBBB_cycle;
assign f_AAAABBBA = ((A_dependent && (n_AAAABBB_fa > n_AAAABBB_ready)) ?
                   n_AAAABBB_fa : n_AAAABBB_ready) + A_lat_ext[4];
assign f_AAAABBBB = ((B_dependent && (n_AAAABBB_fb > n_AAAABBB_ready)) ?
                   n_AAAABBB_fb : n_AAAABBB_ready) + B_lat_ext[3];
assign l53_AAAABBBA_cycle = (f_AAAABBBA > n_AAAABBB_fm) ?
                              f_AAAABBBA : n_AAAABBB_fm;
assign l44_AAAABBBB_cycle = (f_AAAABBBB > n_AAAABBB_fm) ?
                              f_AAAABBBB : n_AAAABBB_fm;

// l71_AAABAAAA / l62_AAABAAAB
wire [8:0] f_AAABAAAA;
wire [8:0] f_AAABAAAB;
wire [8:0] l71_AAABAAAA_cycle, l62_AAABAAAB_cycle;
assign f_AAABAAAA = ((A_dependent && (n_AAABAAA_fa > n_AAABAAA_ready)) ?
                   n_AAABAAA_fa : n_AAABAAA_ready) + A_lat_ext[6];
assign f_AAABAAAB = ((B_dependent && (n_AAABAAA_fb > n_AAABAAA_ready)) ?
                   n_AAABAAA_fb : n_AAABAAA_ready) + B_lat_ext[1];
assign l71_AAABAAAA_cycle = (f_AAABAAAA > n_AAABAAA_fm) ?
                              f_AAABAAAA : n_AAABAAA_fm;
assign l62_AAABAAAB_cycle = (f_AAABAAAB > n_AAABAAA_fm) ?
                              f_AAABAAAB : n_AAABAAA_fm;

// l62_AAABAABA / l53_AAABAABB
wire [8:0] f_AAABAABA;
wire [8:0] f_AAABAABB;
wire [8:0] l62_AAABAABA_cycle, l53_AAABAABB_cycle;
assign f_AAABAABA = ((A_dependent && (n_AAABAAB_fa > n_AAABAAB_ready)) ?
                   n_AAABAAB_fa : n_AAABAAB_ready) + A_lat_ext[5];
assign f_AAABAABB = ((B_dependent && (n_AAABAAB_fb > n_AAABAAB_ready)) ?
                   n_AAABAAB_fb : n_AAABAAB_ready) + B_lat_ext[2];
assign l62_AAABAABA_cycle = (f_AAABAABA > n_AAABAAB_fm) ?
                              f_AAABAABA : n_AAABAAB_fm;
assign l53_AAABAABB_cycle = (f_AAABAABB > n_AAABAAB_fm) ?
                              f_AAABAABB : n_AAABAAB_fm;

// l62_AAABABAA / l53_AAABABAB
wire [8:0] f_AAABABAA;
wire [8:0] f_AAABABAB;
wire [8:0] l62_AAABABAA_cycle, l53_AAABABAB_cycle;
assign f_AAABABAA = ((A_dependent && (n_AAABABA_fa > n_AAABABA_ready)) ?
                   n_AAABABA_fa : n_AAABABA_ready) + A_lat_ext[5];
assign f_AAABABAB = ((B_dependent && (n_AAABABA_fb > n_AAABABA_ready)) ?
                   n_AAABABA_fb : n_AAABABA_ready) + B_lat_ext[2];
assign l62_AAABABAA_cycle = (f_AAABABAA > n_AAABABA_fm) ?
                              f_AAABABAA : n_AAABABA_fm;
assign l53_AAABABAB_cycle = (f_AAABABAB > n_AAABABA_fm) ?
                              f_AAABABAB : n_AAABABA_fm;

// l53_AAABABBA / l44_AAABABBB
wire [8:0] f_AAABABBA;
wire [8:0] f_AAABABBB;
wire [8:0] l53_AAABABBA_cycle, l44_AAABABBB_cycle;
assign f_AAABABBA = ((A_dependent && (n_AAABABB_fa > n_AAABABB_ready)) ?
                   n_AAABABB_fa : n_AAABABB_ready) + A_lat_ext[4];
assign f_AAABABBB = ((B_dependent && (n_AAABABB_fb > n_AAABABB_ready)) ?
                   n_AAABABB_fb : n_AAABABB_ready) + B_lat_ext[3];
assign l53_AAABABBA_cycle = (f_AAABABBA > n_AAABABB_fm) ?
                              f_AAABABBA : n_AAABABB_fm;
assign l44_AAABABBB_cycle = (f_AAABABBB > n_AAABABB_fm) ?
                              f_AAABABBB : n_AAABABB_fm;

// l62_AAABBAAA / l53_AAABBAAB
wire [8:0] f_AAABBAAA;
wire [8:0] f_AAABBAAB;
wire [8:0] l62_AAABBAAA_cycle, l53_AAABBAAB_cycle;
assign f_AAABBAAA = ((A_dependent && (n_AAABBAA_fa > n_AAABBAA_ready)) ?
                   n_AAABBAA_fa : n_AAABBAA_ready) + A_lat_ext[5];
assign f_AAABBAAB = ((B_dependent && (n_AAABBAA_fb > n_AAABBAA_ready)) ?
                   n_AAABBAA_fb : n_AAABBAA_ready) + B_lat_ext[2];
assign l62_AAABBAAA_cycle = (f_AAABBAAA > n_AAABBAA_fm) ?
                              f_AAABBAAA : n_AAABBAA_fm;
assign l53_AAABBAAB_cycle = (f_AAABBAAB > n_AAABBAA_fm) ?
                              f_AAABBAAB : n_AAABBAA_fm;

// l53_AAABBABA / l44_AAABBABB
wire [8:0] f_AAABBABA;
wire [8:0] f_AAABBABB;
wire [8:0] l53_AAABBABA_cycle, l44_AAABBABB_cycle;
assign f_AAABBABA = ((A_dependent && (n_AAABBAB_fa > n_AAABBAB_ready)) ?
                   n_AAABBAB_fa : n_AAABBAB_ready) + A_lat_ext[4];
assign f_AAABBABB = ((B_dependent && (n_AAABBAB_fb > n_AAABBAB_ready)) ?
                   n_AAABBAB_fb : n_AAABBAB_ready) + B_lat_ext[3];
assign l53_AAABBABA_cycle = (f_AAABBABA > n_AAABBAB_fm) ?
                              f_AAABBABA : n_AAABBAB_fm;
assign l44_AAABBABB_cycle = (f_AAABBABB > n_AAABBAB_fm) ?
                              f_AAABBABB : n_AAABBAB_fm;

// l53_AAABBBAA / l44_AAABBBAB
wire [8:0] f_AAABBBAA;
wire [8:0] f_AAABBBAB;
wire [8:0] l53_AAABBBAA_cycle, l44_AAABBBAB_cycle;
assign f_AAABBBAA = ((A_dependent && (n_AAABBBA_fa > n_AAABBBA_ready)) ?
                   n_AAABBBA_fa : n_AAABBBA_ready) + A_lat_ext[4];
assign f_AAABBBAB = ((B_dependent && (n_AAABBBA_fb > n_AAABBBA_ready)) ?
                   n_AAABBBA_fb : n_AAABBBA_ready) + B_lat_ext[3];
assign l53_AAABBBAA_cycle = (f_AAABBBAA > n_AAABBBA_fm) ?
                              f_AAABBBAA : n_AAABBBA_fm;
assign l44_AAABBBAB_cycle = (f_AAABBBAB > n_AAABBBA_fm) ?
                              f_AAABBBAB : n_AAABBBA_fm;

// l71_AABAAAAA / l62_AABAAAAB
wire [8:0] f_AABAAAAA;
wire [8:0] f_AABAAAAB;
wire [8:0] l71_AABAAAAA_cycle, l62_AABAAAAB_cycle;
assign f_AABAAAAA = ((A_dependent && (n_AABAAAA_fa > n_AABAAAA_ready)) ?
                   n_AABAAAA_fa : n_AABAAAA_ready) + A_lat_ext[6];
assign f_AABAAAAB = ((B_dependent && (n_AABAAAA_fb > n_AABAAAA_ready)) ?
                   n_AABAAAA_fb : n_AABAAAA_ready) + B_lat_ext[1];
assign l71_AABAAAAA_cycle = (f_AABAAAAA > n_AABAAAA_fm) ?
                              f_AABAAAAA : n_AABAAAA_fm;
assign l62_AABAAAAB_cycle = (f_AABAAAAB > n_AABAAAA_fm) ?
                              f_AABAAAAB : n_AABAAAA_fm;

// l62_AABAAABA / l53_AABAAABB
wire [8:0] f_AABAAABA;
wire [8:0] f_AABAAABB;
wire [8:0] l62_AABAAABA_cycle, l53_AABAAABB_cycle;
assign f_AABAAABA = ((A_dependent && (n_AABAAAB_fa > n_AABAAAB_ready)) ?
                   n_AABAAAB_fa : n_AABAAAB_ready) + A_lat_ext[5];
assign f_AABAAABB = ((B_dependent && (n_AABAAAB_fb > n_AABAAAB_ready)) ?
                   n_AABAAAB_fb : n_AABAAAB_ready) + B_lat_ext[2];
assign l62_AABAAABA_cycle = (f_AABAAABA > n_AABAAAB_fm) ?
                              f_AABAAABA : n_AABAAAB_fm;
assign l53_AABAAABB_cycle = (f_AABAAABB > n_AABAAAB_fm) ?
                              f_AABAAABB : n_AABAAAB_fm;

// l62_AABAABAA / l53_AABAABAB
wire [8:0] f_AABAABAA;
wire [8:0] f_AABAABAB;
wire [8:0] l62_AABAABAA_cycle, l53_AABAABAB_cycle;
assign f_AABAABAA = ((A_dependent && (n_AABAABA_fa > n_AABAABA_ready)) ?
                   n_AABAABA_fa : n_AABAABA_ready) + A_lat_ext[5];
assign f_AABAABAB = ((B_dependent && (n_AABAABA_fb > n_AABAABA_ready)) ?
                   n_AABAABA_fb : n_AABAABA_ready) + B_lat_ext[2];
assign l62_AABAABAA_cycle = (f_AABAABAA > n_AABAABA_fm) ?
                              f_AABAABAA : n_AABAABA_fm;
assign l53_AABAABAB_cycle = (f_AABAABAB > n_AABAABA_fm) ?
                              f_AABAABAB : n_AABAABA_fm;

// l53_AABAABBA / l44_AABAABBB
wire [8:0] f_AABAABBA;
wire [8:0] f_AABAABBB;
wire [8:0] l53_AABAABBA_cycle, l44_AABAABBB_cycle;
assign f_AABAABBA = ((A_dependent && (n_AABAABB_fa > n_AABAABB_ready)) ?
                   n_AABAABB_fa : n_AABAABB_ready) + A_lat_ext[4];
assign f_AABAABBB = ((B_dependent && (n_AABAABB_fb > n_AABAABB_ready)) ?
                   n_AABAABB_fb : n_AABAABB_ready) + B_lat_ext[3];
assign l53_AABAABBA_cycle = (f_AABAABBA > n_AABAABB_fm) ?
                              f_AABAABBA : n_AABAABB_fm;
assign l44_AABAABBB_cycle = (f_AABAABBB > n_AABAABB_fm) ?
                              f_AABAABBB : n_AABAABB_fm;

// l62_AABABAAA / l53_AABABAAB
wire [8:0] f_AABABAAA;
wire [8:0] f_AABABAAB;
wire [8:0] l62_AABABAAA_cycle, l53_AABABAAB_cycle;
assign f_AABABAAA = ((A_dependent && (n_AABABAA_fa > n_AABABAA_ready)) ?
                   n_AABABAA_fa : n_AABABAA_ready) + A_lat_ext[5];
assign f_AABABAAB = ((B_dependent && (n_AABABAA_fb > n_AABABAA_ready)) ?
                   n_AABABAA_fb : n_AABABAA_ready) + B_lat_ext[2];
assign l62_AABABAAA_cycle = (f_AABABAAA > n_AABABAA_fm) ?
                              f_AABABAAA : n_AABABAA_fm;
assign l53_AABABAAB_cycle = (f_AABABAAB > n_AABABAA_fm) ?
                              f_AABABAAB : n_AABABAA_fm;

// l53_AABABABA / l44_AABABABB
wire [8:0] f_AABABABA;
wire [8:0] f_AABABABB;
wire [8:0] l53_AABABABA_cycle, l44_AABABABB_cycle;
assign f_AABABABA = ((A_dependent && (n_AABABAB_fa > n_AABABAB_ready)) ?
                   n_AABABAB_fa : n_AABABAB_ready) + A_lat_ext[4];
assign f_AABABABB = ((B_dependent && (n_AABABAB_fb > n_AABABAB_ready)) ?
                   n_AABABAB_fb : n_AABABAB_ready) + B_lat_ext[3];
assign l53_AABABABA_cycle = (f_AABABABA > n_AABABAB_fm) ?
                              f_AABABABA : n_AABABAB_fm;
assign l44_AABABABB_cycle = (f_AABABABB > n_AABABAB_fm) ?
                              f_AABABABB : n_AABABAB_fm;

// l53_AABABBAA / l44_AABABBAB
wire [8:0] f_AABABBAA;
wire [8:0] f_AABABBAB;
wire [8:0] l53_AABABBAA_cycle, l44_AABABBAB_cycle;
assign f_AABABBAA = ((A_dependent && (n_AABABBA_fa > n_AABABBA_ready)) ?
                   n_AABABBA_fa : n_AABABBA_ready) + A_lat_ext[4];
assign f_AABABBAB = ((B_dependent && (n_AABABBA_fb > n_AABABBA_ready)) ?
                   n_AABABBA_fb : n_AABABBA_ready) + B_lat_ext[3];
assign l53_AABABBAA_cycle = (f_AABABBAA > n_AABABBA_fm) ?
                              f_AABABBAA : n_AABABBA_fm;
assign l44_AABABBAB_cycle = (f_AABABBAB > n_AABABBA_fm) ?
                              f_AABABBAB : n_AABABBA_fm;

// l62_AABBAAAA / l53_AABBAAAB
wire [8:0] f_AABBAAAA;
wire [8:0] f_AABBAAAB;
wire [8:0] l62_AABBAAAA_cycle, l53_AABBAAAB_cycle;
assign f_AABBAAAA = ((A_dependent && (n_AABBAAA_fa > n_AABBAAA_ready)) ?
                   n_AABBAAA_fa : n_AABBAAA_ready) + A_lat_ext[5];
assign f_AABBAAAB = ((B_dependent && (n_AABBAAA_fb > n_AABBAAA_ready)) ?
                   n_AABBAAA_fb : n_AABBAAA_ready) + B_lat_ext[2];
assign l62_AABBAAAA_cycle = (f_AABBAAAA > n_AABBAAA_fm) ?
                              f_AABBAAAA : n_AABBAAA_fm;
assign l53_AABBAAAB_cycle = (f_AABBAAAB > n_AABBAAA_fm) ?
                              f_AABBAAAB : n_AABBAAA_fm;

// l53_AABBAABA / l44_AABBAABB
wire [8:0] f_AABBAABA;
wire [8:0] f_AABBAABB;
wire [8:0] l53_AABBAABA_cycle, l44_AABBAABB_cycle;
assign f_AABBAABA = ((A_dependent && (n_AABBAAB_fa > n_AABBAAB_ready)) ?
                   n_AABBAAB_fa : n_AABBAAB_ready) + A_lat_ext[4];
assign f_AABBAABB = ((B_dependent && (n_AABBAAB_fb > n_AABBAAB_ready)) ?
                   n_AABBAAB_fb : n_AABBAAB_ready) + B_lat_ext[3];
assign l53_AABBAABA_cycle = (f_AABBAABA > n_AABBAAB_fm) ?
                              f_AABBAABA : n_AABBAAB_fm;
assign l44_AABBAABB_cycle = (f_AABBAABB > n_AABBAAB_fm) ?
                              f_AABBAABB : n_AABBAAB_fm;

// l53_AABBABAA / l44_AABBABAB
wire [8:0] f_AABBABAA;
wire [8:0] f_AABBABAB;
wire [8:0] l53_AABBABAA_cycle, l44_AABBABAB_cycle;
assign f_AABBABAA = ((A_dependent && (n_AABBABA_fa > n_AABBABA_ready)) ?
                   n_AABBABA_fa : n_AABBABA_ready) + A_lat_ext[4];
assign f_AABBABAB = ((B_dependent && (n_AABBABA_fb > n_AABBABA_ready)) ?
                   n_AABBABA_fb : n_AABBABA_ready) + B_lat_ext[3];
assign l53_AABBABAA_cycle = (f_AABBABAA > n_AABBABA_fm) ?
                              f_AABBABAA : n_AABBABA_fm;
assign l44_AABBABAB_cycle = (f_AABBABAB > n_AABBABA_fm) ?
                              f_AABBABAB : n_AABBABA_fm;

// l53_AABBBAAA / l44_AABBBAAB
wire [8:0] f_AABBBAAA;
wire [8:0] f_AABBBAAB;
wire [8:0] l53_AABBBAAA_cycle, l44_AABBBAAB_cycle;
assign f_AABBBAAA = ((A_dependent && (n_AABBBAA_fa > n_AABBBAA_ready)) ?
                   n_AABBBAA_fa : n_AABBBAA_ready) + A_lat_ext[4];
assign f_AABBBAAB = ((B_dependent && (n_AABBBAA_fb > n_AABBBAA_ready)) ?
                   n_AABBBAA_fb : n_AABBBAA_ready) + B_lat_ext[3];
assign l53_AABBBAAA_cycle = (f_AABBBAAA > n_AABBBAA_fm) ?
                              f_AABBBAAA : n_AABBBAA_fm;
assign l44_AABBBAAB_cycle = (f_AABBBAAB > n_AABBBAA_fm) ?
                              f_AABBBAAB : n_AABBBAA_fm;

// l71_ABAAAAAA / l62_ABAAAAAB
wire [8:0] f_ABAAAAAA;
wire [8:0] f_ABAAAAAB;
wire [8:0] l71_ABAAAAAA_cycle, l62_ABAAAAAB_cycle;
assign f_ABAAAAAA = ((A_dependent && (n_ABAAAAA_fa > n_ABAAAAA_ready)) ?
                   n_ABAAAAA_fa : n_ABAAAAA_ready) + A_lat_ext[6];
assign f_ABAAAAAB = ((B_dependent && (n_ABAAAAA_fb > n_ABAAAAA_ready)) ?
                   n_ABAAAAA_fb : n_ABAAAAA_ready) + B_lat_ext[1];
assign l71_ABAAAAAA_cycle = (f_ABAAAAAA > n_ABAAAAA_fm) ?
                              f_ABAAAAAA : n_ABAAAAA_fm;
assign l62_ABAAAAAB_cycle = (f_ABAAAAAB > n_ABAAAAA_fm) ?
                              f_ABAAAAAB : n_ABAAAAA_fm;

// l62_ABAAAABA / l53_ABAAAABB
wire [8:0] f_ABAAAABA;
wire [8:0] f_ABAAAABB;
wire [8:0] l62_ABAAAABA_cycle, l53_ABAAAABB_cycle;
assign f_ABAAAABA = ((A_dependent && (n_ABAAAAB_fa > n_ABAAAAB_ready)) ?
                   n_ABAAAAB_fa : n_ABAAAAB_ready) + A_lat_ext[5];
assign f_ABAAAABB = ((B_dependent && (n_ABAAAAB_fb > n_ABAAAAB_ready)) ?
                   n_ABAAAAB_fb : n_ABAAAAB_ready) + B_lat_ext[2];
assign l62_ABAAAABA_cycle = (f_ABAAAABA > n_ABAAAAB_fm) ?
                              f_ABAAAABA : n_ABAAAAB_fm;
assign l53_ABAAAABB_cycle = (f_ABAAAABB > n_ABAAAAB_fm) ?
                              f_ABAAAABB : n_ABAAAAB_fm;

// l62_ABAAABAA / l53_ABAAABAB
wire [8:0] f_ABAAABAA;
wire [8:0] f_ABAAABAB;
wire [8:0] l62_ABAAABAA_cycle, l53_ABAAABAB_cycle;
assign f_ABAAABAA = ((A_dependent && (n_ABAAABA_fa > n_ABAAABA_ready)) ?
                   n_ABAAABA_fa : n_ABAAABA_ready) + A_lat_ext[5];
assign f_ABAAABAB = ((B_dependent && (n_ABAAABA_fb > n_ABAAABA_ready)) ?
                   n_ABAAABA_fb : n_ABAAABA_ready) + B_lat_ext[2];
assign l62_ABAAABAA_cycle = (f_ABAAABAA > n_ABAAABA_fm) ?
                              f_ABAAABAA : n_ABAAABA_fm;
assign l53_ABAAABAB_cycle = (f_ABAAABAB > n_ABAAABA_fm) ?
                              f_ABAAABAB : n_ABAAABA_fm;

// l53_ABAAABBA / l44_ABAAABBB
wire [8:0] f_ABAAABBA;
wire [8:0] f_ABAAABBB;
wire [8:0] l53_ABAAABBA_cycle, l44_ABAAABBB_cycle;
assign f_ABAAABBA = ((A_dependent && (n_ABAAABB_fa > n_ABAAABB_ready)) ?
                   n_ABAAABB_fa : n_ABAAABB_ready) + A_lat_ext[4];
assign f_ABAAABBB = ((B_dependent && (n_ABAAABB_fb > n_ABAAABB_ready)) ?
                   n_ABAAABB_fb : n_ABAAABB_ready) + B_lat_ext[3];
assign l53_ABAAABBA_cycle = (f_ABAAABBA > n_ABAAABB_fm) ?
                              f_ABAAABBA : n_ABAAABB_fm;
assign l44_ABAAABBB_cycle = (f_ABAAABBB > n_ABAAABB_fm) ?
                              f_ABAAABBB : n_ABAAABB_fm;

// l62_ABAABAAA / l53_ABAABAAB
wire [8:0] f_ABAABAAA;
wire [8:0] f_ABAABAAB;
wire [8:0] l62_ABAABAAA_cycle, l53_ABAABAAB_cycle;
assign f_ABAABAAA = ((A_dependent && (n_ABAABAA_fa > n_ABAABAA_ready)) ?
                   n_ABAABAA_fa : n_ABAABAA_ready) + A_lat_ext[5];
assign f_ABAABAAB = ((B_dependent && (n_ABAABAA_fb > n_ABAABAA_ready)) ?
                   n_ABAABAA_fb : n_ABAABAA_ready) + B_lat_ext[2];
assign l62_ABAABAAA_cycle = (f_ABAABAAA > n_ABAABAA_fm) ?
                              f_ABAABAAA : n_ABAABAA_fm;
assign l53_ABAABAAB_cycle = (f_ABAABAAB > n_ABAABAA_fm) ?
                              f_ABAABAAB : n_ABAABAA_fm;

// l53_ABAABABA / l44_ABAABABB
wire [8:0] f_ABAABABA;
wire [8:0] f_ABAABABB;
wire [8:0] l53_ABAABABA_cycle, l44_ABAABABB_cycle;
assign f_ABAABABA = ((A_dependent && (n_ABAABAB_fa > n_ABAABAB_ready)) ?
                   n_ABAABAB_fa : n_ABAABAB_ready) + A_lat_ext[4];
assign f_ABAABABB = ((B_dependent && (n_ABAABAB_fb > n_ABAABAB_ready)) ?
                   n_ABAABAB_fb : n_ABAABAB_ready) + B_lat_ext[3];
assign l53_ABAABABA_cycle = (f_ABAABABA > n_ABAABAB_fm) ?
                              f_ABAABABA : n_ABAABAB_fm;
assign l44_ABAABABB_cycle = (f_ABAABABB > n_ABAABAB_fm) ?
                              f_ABAABABB : n_ABAABAB_fm;

// l53_ABAABBAA / l44_ABAABBAB
wire [8:0] f_ABAABBAA;
wire [8:0] f_ABAABBAB;
wire [8:0] l53_ABAABBAA_cycle, l44_ABAABBAB_cycle;
assign f_ABAABBAA = ((A_dependent && (n_ABAABBA_fa > n_ABAABBA_ready)) ?
                   n_ABAABBA_fa : n_ABAABBA_ready) + A_lat_ext[4];
assign f_ABAABBAB = ((B_dependent && (n_ABAABBA_fb > n_ABAABBA_ready)) ?
                   n_ABAABBA_fb : n_ABAABBA_ready) + B_lat_ext[3];
assign l53_ABAABBAA_cycle = (f_ABAABBAA > n_ABAABBA_fm) ?
                              f_ABAABBAA : n_ABAABBA_fm;
assign l44_ABAABBAB_cycle = (f_ABAABBAB > n_ABAABBA_fm) ?
                              f_ABAABBAB : n_ABAABBA_fm;

// l62_ABABAAAA / l53_ABABAAAB
wire [8:0] f_ABABAAAA;
wire [8:0] f_ABABAAAB;
wire [8:0] l62_ABABAAAA_cycle, l53_ABABAAAB_cycle;
assign f_ABABAAAA = ((A_dependent && (n_ABABAAA_fa > n_ABABAAA_ready)) ?
                   n_ABABAAA_fa : n_ABABAAA_ready) + A_lat_ext[5];
assign f_ABABAAAB = ((B_dependent && (n_ABABAAA_fb > n_ABABAAA_ready)) ?
                   n_ABABAAA_fb : n_ABABAAA_ready) + B_lat_ext[2];
assign l62_ABABAAAA_cycle = (f_ABABAAAA > n_ABABAAA_fm) ?
                              f_ABABAAAA : n_ABABAAA_fm;
assign l53_ABABAAAB_cycle = (f_ABABAAAB > n_ABABAAA_fm) ?
                              f_ABABAAAB : n_ABABAAA_fm;

// l53_ABABAABA / l44_ABABAABB
wire [8:0] f_ABABAABA;
wire [8:0] f_ABABAABB;
wire [8:0] l53_ABABAABA_cycle, l44_ABABAABB_cycle;
assign f_ABABAABA = ((A_dependent && (n_ABABAAB_fa > n_ABABAAB_ready)) ?
                   n_ABABAAB_fa : n_ABABAAB_ready) + A_lat_ext[4];
assign f_ABABAABB = ((B_dependent && (n_ABABAAB_fb > n_ABABAAB_ready)) ?
                   n_ABABAAB_fb : n_ABABAAB_ready) + B_lat_ext[3];
assign l53_ABABAABA_cycle = (f_ABABAABA > n_ABABAAB_fm) ?
                              f_ABABAABA : n_ABABAAB_fm;
assign l44_ABABAABB_cycle = (f_ABABAABB > n_ABABAAB_fm) ?
                              f_ABABAABB : n_ABABAAB_fm;

// l53_ABABABAA / l44_ABABABAB
wire [8:0] f_ABABABAA;
wire [8:0] f_ABABABAB;
wire [8:0] l53_ABABABAA_cycle, l44_ABABABAB_cycle;
assign f_ABABABAA = ((A_dependent && (n_ABABABA_fa > n_ABABABA_ready)) ?
                   n_ABABABA_fa : n_ABABABA_ready) + A_lat_ext[4];
assign f_ABABABAB = ((B_dependent && (n_ABABABA_fb > n_ABABABA_ready)) ?
                   n_ABABABA_fb : n_ABABABA_ready) + B_lat_ext[3];
assign l53_ABABABAA_cycle = (f_ABABABAA > n_ABABABA_fm) ?
                              f_ABABABAA : n_ABABABA_fm;
assign l44_ABABABAB_cycle = (f_ABABABAB > n_ABABABA_fm) ?
                              f_ABABABAB : n_ABABABA_fm;

// l53_ABABBAAA / l44_ABABBAAB
wire [8:0] f_ABABBAAA;
wire [8:0] f_ABABBAAB;
wire [8:0] l53_ABABBAAA_cycle, l44_ABABBAAB_cycle;
assign f_ABABBAAA = ((A_dependent && (n_ABABBAA_fa > n_ABABBAA_ready)) ?
                   n_ABABBAA_fa : n_ABABBAA_ready) + A_lat_ext[4];
assign f_ABABBAAB = ((B_dependent && (n_ABABBAA_fb > n_ABABBAA_ready)) ?
                   n_ABABBAA_fb : n_ABABBAA_ready) + B_lat_ext[3];
assign l53_ABABBAAA_cycle = (f_ABABBAAA > n_ABABBAA_fm) ?
                              f_ABABBAAA : n_ABABBAA_fm;
assign l44_ABABBAAB_cycle = (f_ABABBAAB > n_ABABBAA_fm) ?
                              f_ABABBAAB : n_ABABBAA_fm;

// l62_ABBAAAAA / l53_ABBAAAAB
wire [8:0] f_ABBAAAAA;
wire [8:0] f_ABBAAAAB;
wire [8:0] l62_ABBAAAAA_cycle, l53_ABBAAAAB_cycle;
assign f_ABBAAAAA = ((A_dependent && (n_ABBAAAA_fa > n_ABBAAAA_ready)) ?
                   n_ABBAAAA_fa : n_ABBAAAA_ready) + A_lat_ext[5];
assign f_ABBAAAAB = ((B_dependent && (n_ABBAAAA_fb > n_ABBAAAA_ready)) ?
                   n_ABBAAAA_fb : n_ABBAAAA_ready) + B_lat_ext[2];
assign l62_ABBAAAAA_cycle = (f_ABBAAAAA > n_ABBAAAA_fm) ?
                              f_ABBAAAAA : n_ABBAAAA_fm;
assign l53_ABBAAAAB_cycle = (f_ABBAAAAB > n_ABBAAAA_fm) ?
                              f_ABBAAAAB : n_ABBAAAA_fm;

// l53_ABBAAABA / l44_ABBAAABB
wire [8:0] f_ABBAAABA;
wire [8:0] f_ABBAAABB;
wire [8:0] l53_ABBAAABA_cycle, l44_ABBAAABB_cycle;
assign f_ABBAAABA = ((A_dependent && (n_ABBAAAB_fa > n_ABBAAAB_ready)) ?
                   n_ABBAAAB_fa : n_ABBAAAB_ready) + A_lat_ext[4];
assign f_ABBAAABB = ((B_dependent && (n_ABBAAAB_fb > n_ABBAAAB_ready)) ?
                   n_ABBAAAB_fb : n_ABBAAAB_ready) + B_lat_ext[3];
assign l53_ABBAAABA_cycle = (f_ABBAAABA > n_ABBAAAB_fm) ?
                              f_ABBAAABA : n_ABBAAAB_fm;
assign l44_ABBAAABB_cycle = (f_ABBAAABB > n_ABBAAAB_fm) ?
                              f_ABBAAABB : n_ABBAAAB_fm;

// l53_ABBAABAA / l44_ABBAABAB
wire [8:0] f_ABBAABAA;
wire [8:0] f_ABBAABAB;
wire [8:0] l53_ABBAABAA_cycle, l44_ABBAABAB_cycle;
assign f_ABBAABAA = ((A_dependent && (n_ABBAABA_fa > n_ABBAABA_ready)) ?
                   n_ABBAABA_fa : n_ABBAABA_ready) + A_lat_ext[4];
assign f_ABBAABAB = ((B_dependent && (n_ABBAABA_fb > n_ABBAABA_ready)) ?
                   n_ABBAABA_fb : n_ABBAABA_ready) + B_lat_ext[3];
assign l53_ABBAABAA_cycle = (f_ABBAABAA > n_ABBAABA_fm) ?
                              f_ABBAABAA : n_ABBAABA_fm;
assign l44_ABBAABAB_cycle = (f_ABBAABAB > n_ABBAABA_fm) ?
                              f_ABBAABAB : n_ABBAABA_fm;

// l53_ABBABAAA / l44_ABBABAAB
wire [8:0] f_ABBABAAA;
wire [8:0] f_ABBABAAB;
wire [8:0] l53_ABBABAAA_cycle, l44_ABBABAAB_cycle;
assign f_ABBABAAA = ((A_dependent && (n_ABBABAA_fa > n_ABBABAA_ready)) ?
                   n_ABBABAA_fa : n_ABBABAA_ready) + A_lat_ext[4];
assign f_ABBABAAB = ((B_dependent && (n_ABBABAA_fb > n_ABBABAA_ready)) ?
                   n_ABBABAA_fb : n_ABBABAA_ready) + B_lat_ext[3];
assign l53_ABBABAAA_cycle = (f_ABBABAAA > n_ABBABAA_fm) ?
                              f_ABBABAAA : n_ABBABAA_fm;
assign l44_ABBABAAB_cycle = (f_ABBABAAB > n_ABBABAA_fm) ?
                              f_ABBABAAB : n_ABBABAA_fm;

// l53_ABBBAAAA / l44_ABBBAAAB
wire [8:0] f_ABBBAAAA;
wire [8:0] f_ABBBAAAB;
wire [8:0] l53_ABBBAAAA_cycle, l44_ABBBAAAB_cycle;
assign f_ABBBAAAA = ((A_dependent && (n_ABBBAAA_fa > n_ABBBAAA_ready)) ?
                   n_ABBBAAA_fa : n_ABBBAAA_ready) + A_lat_ext[4];
assign f_ABBBAAAB = ((B_dependent && (n_ABBBAAA_fb > n_ABBBAAA_ready)) ?
                   n_ABBBAAA_fb : n_ABBBAAA_ready) + B_lat_ext[3];
assign l53_ABBBAAAA_cycle = (f_ABBBAAAA > n_ABBBAAA_fm) ?
                              f_ABBBAAAA : n_ABBBAAA_fm;
assign l44_ABBBAAAB_cycle = (f_ABBBAAAB > n_ABBBAAA_fm) ?
                              f_ABBBAAAB : n_ABBBAAA_fm;

// l71_BAAAAAAA / l62_BAAAAAAB
wire [8:0] f_BAAAAAAA;
wire [8:0] f_BAAAAAAB;
wire [8:0] l71_BAAAAAAA_cycle, l62_BAAAAAAB_cycle;
assign f_BAAAAAAA = ((A_dependent && (n_BAAAAAA_fa > n_BAAAAAA_ready)) ?
                   n_BAAAAAA_fa : n_BAAAAAA_ready) + A_lat_ext[6];
assign f_BAAAAAAB = ((B_dependent && (n_BAAAAAA_fb > n_BAAAAAA_ready)) ?
                   n_BAAAAAA_fb : n_BAAAAAA_ready) + B_lat_ext[1];
assign l71_BAAAAAAA_cycle = (f_BAAAAAAA > n_BAAAAAA_fm) ?
                              f_BAAAAAAA : n_BAAAAAA_fm;
assign l62_BAAAAAAB_cycle = (f_BAAAAAAB > n_BAAAAAA_fm) ?
                              f_BAAAAAAB : n_BAAAAAA_fm;

// l62_BAAAAABA / l53_BAAAAABB
wire [8:0] f_BAAAAABA;
wire [8:0] f_BAAAAABB;
wire [8:0] l62_BAAAAABA_cycle, l53_BAAAAABB_cycle;
assign f_BAAAAABA = ((A_dependent && (n_BAAAAAB_fa > n_BAAAAAB_ready)) ?
                   n_BAAAAAB_fa : n_BAAAAAB_ready) + A_lat_ext[5];
assign f_BAAAAABB = ((B_dependent && (n_BAAAAAB_fb > n_BAAAAAB_ready)) ?
                   n_BAAAAAB_fb : n_BAAAAAB_ready) + B_lat_ext[2];
assign l62_BAAAAABA_cycle = (f_BAAAAABA > n_BAAAAAB_fm) ?
                              f_BAAAAABA : n_BAAAAAB_fm;
assign l53_BAAAAABB_cycle = (f_BAAAAABB > n_BAAAAAB_fm) ?
                              f_BAAAAABB : n_BAAAAAB_fm;

// l62_BAAAABAA / l53_BAAAABAB
wire [8:0] f_BAAAABAA;
wire [8:0] f_BAAAABAB;
wire [8:0] l62_BAAAABAA_cycle, l53_BAAAABAB_cycle;
assign f_BAAAABAA = ((A_dependent && (n_BAAAABA_fa > n_BAAAABA_ready)) ?
                   n_BAAAABA_fa : n_BAAAABA_ready) + A_lat_ext[5];
assign f_BAAAABAB = ((B_dependent && (n_BAAAABA_fb > n_BAAAABA_ready)) ?
                   n_BAAAABA_fb : n_BAAAABA_ready) + B_lat_ext[2];
assign l62_BAAAABAA_cycle = (f_BAAAABAA > n_BAAAABA_fm) ?
                              f_BAAAABAA : n_BAAAABA_fm;
assign l53_BAAAABAB_cycle = (f_BAAAABAB > n_BAAAABA_fm) ?
                              f_BAAAABAB : n_BAAAABA_fm;

// l53_BAAAABBA / l44_BAAAABBB
wire [8:0] f_BAAAABBA;
wire [8:0] f_BAAAABBB;
wire [8:0] l53_BAAAABBA_cycle, l44_BAAAABBB_cycle;
assign f_BAAAABBA = ((A_dependent && (n_BAAAABB_fa > n_BAAAABB_ready)) ?
                   n_BAAAABB_fa : n_BAAAABB_ready) + A_lat_ext[4];
assign f_BAAAABBB = ((B_dependent && (n_BAAAABB_fb > n_BAAAABB_ready)) ?
                   n_BAAAABB_fb : n_BAAAABB_ready) + B_lat_ext[3];
assign l53_BAAAABBA_cycle = (f_BAAAABBA > n_BAAAABB_fm) ?
                              f_BAAAABBA : n_BAAAABB_fm;
assign l44_BAAAABBB_cycle = (f_BAAAABBB > n_BAAAABB_fm) ?
                              f_BAAAABBB : n_BAAAABB_fm;

// l62_BAAABAAA / l53_BAAABAAB
wire [8:0] f_BAAABAAA;
wire [8:0] f_BAAABAAB;
wire [8:0] l62_BAAABAAA_cycle, l53_BAAABAAB_cycle;
assign f_BAAABAAA = ((A_dependent && (n_BAAABAA_fa > n_BAAABAA_ready)) ?
                   n_BAAABAA_fa : n_BAAABAA_ready) + A_lat_ext[5];
assign f_BAAABAAB = ((B_dependent && (n_BAAABAA_fb > n_BAAABAA_ready)) ?
                   n_BAAABAA_fb : n_BAAABAA_ready) + B_lat_ext[2];
assign l62_BAAABAAA_cycle = (f_BAAABAAA > n_BAAABAA_fm) ?
                              f_BAAABAAA : n_BAAABAA_fm;
assign l53_BAAABAAB_cycle = (f_BAAABAAB > n_BAAABAA_fm) ?
                              f_BAAABAAB : n_BAAABAA_fm;

// l53_BAAABABA / l44_BAAABABB
wire [8:0] f_BAAABABA;
wire [8:0] f_BAAABABB;
wire [8:0] l53_BAAABABA_cycle, l44_BAAABABB_cycle;
assign f_BAAABABA = ((A_dependent && (n_BAAABAB_fa > n_BAAABAB_ready)) ?
                   n_BAAABAB_fa : n_BAAABAB_ready) + A_lat_ext[4];
assign f_BAAABABB = ((B_dependent && (n_BAAABAB_fb > n_BAAABAB_ready)) ?
                   n_BAAABAB_fb : n_BAAABAB_ready) + B_lat_ext[3];
assign l53_BAAABABA_cycle = (f_BAAABABA > n_BAAABAB_fm) ?
                              f_BAAABABA : n_BAAABAB_fm;
assign l44_BAAABABB_cycle = (f_BAAABABB > n_BAAABAB_fm) ?
                              f_BAAABABB : n_BAAABAB_fm;

// l53_BAAABBAA / l44_BAAABBAB
wire [8:0] f_BAAABBAA;
wire [8:0] f_BAAABBAB;
wire [8:0] l53_BAAABBAA_cycle, l44_BAAABBAB_cycle;
assign f_BAAABBAA = ((A_dependent && (n_BAAABBA_fa > n_BAAABBA_ready)) ?
                   n_BAAABBA_fa : n_BAAABBA_ready) + A_lat_ext[4];
assign f_BAAABBAB = ((B_dependent && (n_BAAABBA_fb > n_BAAABBA_ready)) ?
                   n_BAAABBA_fb : n_BAAABBA_ready) + B_lat_ext[3];
assign l53_BAAABBAA_cycle = (f_BAAABBAA > n_BAAABBA_fm) ?
                              f_BAAABBAA : n_BAAABBA_fm;
assign l44_BAAABBAB_cycle = (f_BAAABBAB > n_BAAABBA_fm) ?
                              f_BAAABBAB : n_BAAABBA_fm;

// l62_BAABAAAA / l53_BAABAAAB
wire [8:0] f_BAABAAAA;
wire [8:0] f_BAABAAAB;
wire [8:0] l62_BAABAAAA_cycle, l53_BAABAAAB_cycle;
assign f_BAABAAAA = ((A_dependent && (n_BAABAAA_fa > n_BAABAAA_ready)) ?
                   n_BAABAAA_fa : n_BAABAAA_ready) + A_lat_ext[5];
assign f_BAABAAAB = ((B_dependent && (n_BAABAAA_fb > n_BAABAAA_ready)) ?
                   n_BAABAAA_fb : n_BAABAAA_ready) + B_lat_ext[2];
assign l62_BAABAAAA_cycle = (f_BAABAAAA > n_BAABAAA_fm) ?
                              f_BAABAAAA : n_BAABAAA_fm;
assign l53_BAABAAAB_cycle = (f_BAABAAAB > n_BAABAAA_fm) ?
                              f_BAABAAAB : n_BAABAAA_fm;

// l53_BAABAABA / l44_BAABAABB
wire [8:0] f_BAABAABA;
wire [8:0] f_BAABAABB;
wire [8:0] l53_BAABAABA_cycle, l44_BAABAABB_cycle;
assign f_BAABAABA = ((A_dependent && (n_BAABAAB_fa > n_BAABAAB_ready)) ?
                   n_BAABAAB_fa : n_BAABAAB_ready) + A_lat_ext[4];
assign f_BAABAABB = ((B_dependent && (n_BAABAAB_fb > n_BAABAAB_ready)) ?
                   n_BAABAAB_fb : n_BAABAAB_ready) + B_lat_ext[3];
assign l53_BAABAABA_cycle = (f_BAABAABA > n_BAABAAB_fm) ?
                              f_BAABAABA : n_BAABAAB_fm;
assign l44_BAABAABB_cycle = (f_BAABAABB > n_BAABAAB_fm) ?
                              f_BAABAABB : n_BAABAAB_fm;

// l53_BAABABAA / l44_BAABABAB
wire [8:0] f_BAABABAA;
wire [8:0] f_BAABABAB;
wire [8:0] l53_BAABABAA_cycle, l44_BAABABAB_cycle;
assign f_BAABABAA = ((A_dependent && (n_BAABABA_fa > n_BAABABA_ready)) ?
                   n_BAABABA_fa : n_BAABABA_ready) + A_lat_ext[4];
assign f_BAABABAB = ((B_dependent && (n_BAABABA_fb > n_BAABABA_ready)) ?
                   n_BAABABA_fb : n_BAABABA_ready) + B_lat_ext[3];
assign l53_BAABABAA_cycle = (f_BAABABAA > n_BAABABA_fm) ?
                              f_BAABABAA : n_BAABABA_fm;
assign l44_BAABABAB_cycle = (f_BAABABAB > n_BAABABA_fm) ?
                              f_BAABABAB : n_BAABABA_fm;

// l53_BAABBAAA / l44_BAABBAAB
wire [8:0] f_BAABBAAA;
wire [8:0] f_BAABBAAB;
wire [8:0] l53_BAABBAAA_cycle, l44_BAABBAAB_cycle;
assign f_BAABBAAA = ((A_dependent && (n_BAABBAA_fa > n_BAABBAA_ready)) ?
                   n_BAABBAA_fa : n_BAABBAA_ready) + A_lat_ext[4];
assign f_BAABBAAB = ((B_dependent && (n_BAABBAA_fb > n_BAABBAA_ready)) ?
                   n_BAABBAA_fb : n_BAABBAA_ready) + B_lat_ext[3];
assign l53_BAABBAAA_cycle = (f_BAABBAAA > n_BAABBAA_fm) ?
                              f_BAABBAAA : n_BAABBAA_fm;
assign l44_BAABBAAB_cycle = (f_BAABBAAB > n_BAABBAA_fm) ?
                              f_BAABBAAB : n_BAABBAA_fm;

// l62_BABAAAAA / l53_BABAAAAB
wire [8:0] f_BABAAAAA;
wire [8:0] f_BABAAAAB;
wire [8:0] l62_BABAAAAA_cycle, l53_BABAAAAB_cycle;
assign f_BABAAAAA = ((A_dependent && (n_BABAAAA_fa > n_BABAAAA_ready)) ?
                   n_BABAAAA_fa : n_BABAAAA_ready) + A_lat_ext[5];
assign f_BABAAAAB = ((B_dependent && (n_BABAAAA_fb > n_BABAAAA_ready)) ?
                   n_BABAAAA_fb : n_BABAAAA_ready) + B_lat_ext[2];
assign l62_BABAAAAA_cycle = (f_BABAAAAA > n_BABAAAA_fm) ?
                              f_BABAAAAA : n_BABAAAA_fm;
assign l53_BABAAAAB_cycle = (f_BABAAAAB > n_BABAAAA_fm) ?
                              f_BABAAAAB : n_BABAAAA_fm;

// l53_BABAAABA / l44_BABAAABB
wire [8:0] f_BABAAABA;
wire [8:0] f_BABAAABB;
wire [8:0] l53_BABAAABA_cycle, l44_BABAAABB_cycle;
assign f_BABAAABA = ((A_dependent && (n_BABAAAB_fa > n_BABAAAB_ready)) ?
                   n_BABAAAB_fa : n_BABAAAB_ready) + A_lat_ext[4];
assign f_BABAAABB = ((B_dependent && (n_BABAAAB_fb > n_BABAAAB_ready)) ?
                   n_BABAAAB_fb : n_BABAAAB_ready) + B_lat_ext[3];
assign l53_BABAAABA_cycle = (f_BABAAABA > n_BABAAAB_fm) ?
                              f_BABAAABA : n_BABAAAB_fm;
assign l44_BABAAABB_cycle = (f_BABAAABB > n_BABAAAB_fm) ?
                              f_BABAAABB : n_BABAAAB_fm;

// l53_BABAABAA / l44_BABAABAB
wire [8:0] f_BABAABAA;
wire [8:0] f_BABAABAB;
wire [8:0] l53_BABAABAA_cycle, l44_BABAABAB_cycle;
assign f_BABAABAA = ((A_dependent && (n_BABAABA_fa > n_BABAABA_ready)) ?
                   n_BABAABA_fa : n_BABAABA_ready) + A_lat_ext[4];
assign f_BABAABAB = ((B_dependent && (n_BABAABA_fb > n_BABAABA_ready)) ?
                   n_BABAABA_fb : n_BABAABA_ready) + B_lat_ext[3];
assign l53_BABAABAA_cycle = (f_BABAABAA > n_BABAABA_fm) ?
                              f_BABAABAA : n_BABAABA_fm;
assign l44_BABAABAB_cycle = (f_BABAABAB > n_BABAABA_fm) ?
                              f_BABAABAB : n_BABAABA_fm;

// l53_BABABAAA / l44_BABABAAB
wire [8:0] f_BABABAAA;
wire [8:0] f_BABABAAB;
wire [8:0] l53_BABABAAA_cycle, l44_BABABAAB_cycle;
assign f_BABABAAA = ((A_dependent && (n_BABABAA_fa > n_BABABAA_ready)) ?
                   n_BABABAA_fa : n_BABABAA_ready) + A_lat_ext[4];
assign f_BABABAAB = ((B_dependent && (n_BABABAA_fb > n_BABABAA_ready)) ?
                   n_BABABAA_fb : n_BABABAA_ready) + B_lat_ext[3];
assign l53_BABABAAA_cycle = (f_BABABAAA > n_BABABAA_fm) ?
                              f_BABABAAA : n_BABABAA_fm;
assign l44_BABABAAB_cycle = (f_BABABAAB > n_BABABAA_fm) ?
                              f_BABABAAB : n_BABABAA_fm;

// l53_BABBAAAA / l44_BABBAAAB
wire [8:0] f_BABBAAAA;
wire [8:0] f_BABBAAAB;
wire [8:0] l53_BABBAAAA_cycle, l44_BABBAAAB_cycle;
assign f_BABBAAAA = ((A_dependent && (n_BABBAAA_fa > n_BABBAAA_ready)) ?
                   n_BABBAAA_fa : n_BABBAAA_ready) + A_lat_ext[4];
assign f_BABBAAAB = ((B_dependent && (n_BABBAAA_fb > n_BABBAAA_ready)) ?
                   n_BABBAAA_fb : n_BABBAAA_ready) + B_lat_ext[3];
assign l53_BABBAAAA_cycle = (f_BABBAAAA > n_BABBAAA_fm) ?
                              f_BABBAAAA : n_BABBAAA_fm;
assign l44_BABBAAAB_cycle = (f_BABBAAAB > n_BABBAAA_fm) ?
                              f_BABBAAAB : n_BABBAAA_fm;

// l62_BBAAAAAA / l53_BBAAAAAB
wire [8:0] f_BBAAAAAA;
wire [8:0] f_BBAAAAAB;
wire [8:0] l62_BBAAAAAA_cycle, l53_BBAAAAAB_cycle;
assign f_BBAAAAAA = ((A_dependent && (n_BBAAAAA_fa > n_BBAAAAA_ready)) ?
                   n_BBAAAAA_fa : n_BBAAAAA_ready) + A_lat_ext[5];
assign f_BBAAAAAB = ((B_dependent && (n_BBAAAAA_fb > n_BBAAAAA_ready)) ?
                   n_BBAAAAA_fb : n_BBAAAAA_ready) + B_lat_ext[2];
assign l62_BBAAAAAA_cycle = (f_BBAAAAAA > n_BBAAAAA_fm) ?
                              f_BBAAAAAA : n_BBAAAAA_fm;
assign l53_BBAAAAAB_cycle = (f_BBAAAAAB > n_BBAAAAA_fm) ?
                              f_BBAAAAAB : n_BBAAAAA_fm;

// l53_BBAAAABA / l44_BBAAAABB
wire [8:0] f_BBAAAABA;
wire [8:0] f_BBAAAABB;
wire [8:0] l53_BBAAAABA_cycle, l44_BBAAAABB_cycle;
assign f_BBAAAABA = ((A_dependent && (n_BBAAAAB_fa > n_BBAAAAB_ready)) ?
                   n_BBAAAAB_fa : n_BBAAAAB_ready) + A_lat_ext[4];
assign f_BBAAAABB = ((B_dependent && (n_BBAAAAB_fb > n_BBAAAAB_ready)) ?
                   n_BBAAAAB_fb : n_BBAAAAB_ready) + B_lat_ext[3];
assign l53_BBAAAABA_cycle = (f_BBAAAABA > n_BBAAAAB_fm) ?
                              f_BBAAAABA : n_BBAAAAB_fm;
assign l44_BBAAAABB_cycle = (f_BBAAAABB > n_BBAAAAB_fm) ?
                              f_BBAAAABB : n_BBAAAAB_fm;

// l53_BBAAABAA / l44_BBAAABAB
wire [8:0] f_BBAAABAA;
wire [8:0] f_BBAAABAB;
wire [8:0] l53_BBAAABAA_cycle, l44_BBAAABAB_cycle;
assign f_BBAAABAA = ((A_dependent && (n_BBAAABA_fa > n_BBAAABA_ready)) ?
                   n_BBAAABA_fa : n_BBAAABA_ready) + A_lat_ext[4];
assign f_BBAAABAB = ((B_dependent && (n_BBAAABA_fb > n_BBAAABA_ready)) ?
                   n_BBAAABA_fb : n_BBAAABA_ready) + B_lat_ext[3];
assign l53_BBAAABAA_cycle = (f_BBAAABAA > n_BBAAABA_fm) ?
                              f_BBAAABAA : n_BBAAABA_fm;
assign l44_BBAAABAB_cycle = (f_BBAAABAB > n_BBAAABA_fm) ?
                              f_BBAAABAB : n_BBAAABA_fm;

// l53_BBAABAAA / l44_BBAABAAB
wire [8:0] f_BBAABAAA;
wire [8:0] f_BBAABAAB;
wire [8:0] l53_BBAABAAA_cycle, l44_BBAABAAB_cycle;
assign f_BBAABAAA = ((A_dependent && (n_BBAABAA_fa > n_BBAABAA_ready)) ?
                   n_BBAABAA_fa : n_BBAABAA_ready) + A_lat_ext[4];
assign f_BBAABAAB = ((B_dependent && (n_BBAABAA_fb > n_BBAABAA_ready)) ?
                   n_BBAABAA_fb : n_BBAABAA_ready) + B_lat_ext[3];
assign l53_BBAABAAA_cycle = (f_BBAABAAA > n_BBAABAA_fm) ?
                              f_BBAABAAA : n_BBAABAA_fm;
assign l44_BBAABAAB_cycle = (f_BBAABAAB > n_BBAABAA_fm) ?
                              f_BBAABAAB : n_BBAABAA_fm;

// l53_BBABAAAA / l44_BBABAAAB
wire [8:0] f_BBABAAAA;
wire [8:0] f_BBABAAAB;
wire [8:0] l53_BBABAAAA_cycle, l44_BBABAAAB_cycle;
assign f_BBABAAAA = ((A_dependent && (n_BBABAAA_fa > n_BBABAAA_ready)) ?
                   n_BBABAAA_fa : n_BBABAAA_ready) + A_lat_ext[4];
assign f_BBABAAAB = ((B_dependent && (n_BBABAAA_fb > n_BBABAAA_ready)) ?
                   n_BBABAAA_fb : n_BBABAAA_ready) + B_lat_ext[3];
assign l53_BBABAAAA_cycle = (f_BBABAAAA > n_BBABAAA_fm) ?
                              f_BBABAAAA : n_BBABAAA_fm;
assign l44_BBABAAAB_cycle = (f_BBABAAAB > n_BBABAAA_fm) ?
                              f_BBABAAAB : n_BBABAAA_fm;

// l53_BBBAAAAA / l44_BBBAAAAB
wire [8:0] f_BBBAAAAA;
wire [8:0] f_BBBAAAAB;
wire [8:0] l53_BBBAAAAA_cycle, l44_BBBAAAAB_cycle;
assign f_BBBAAAAA = ((A_dependent && (n_BBBAAAA_fa > n_BBBAAAA_ready)) ?
                   n_BBBAAAA_fa : n_BBBAAAA_ready) + A_lat_ext[4];
assign f_BBBAAAAB = ((B_dependent && (n_BBBAAAA_fb > n_BBBAAAA_ready)) ?
                   n_BBBAAAA_fb : n_BBBAAAA_ready) + B_lat_ext[3];
assign l53_BBBAAAAA_cycle = (f_BBBAAAAA > n_BBBAAAA_fm) ?
                              f_BBBAAAAA : n_BBBAAAA_fm;
assign l44_BBBAAAAB_cycle = (f_BBBAAAAB > n_BBBAAAA_fm) ?
                              f_BBBAAAAB : n_BBBAAAA_fm;
