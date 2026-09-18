//////// CANDIDATE BANK ////////

// A = 1, B = 0
// path[7] is the first issued instruction
// Invalid candidate slots use cycle = 9'd511

// candidate 00
wire [8:0] cand_00_cycle;
wire [7:0] cand_00_path;
assign cand_00_cycle = (B_len == 3'd0) ? l80_AAAAAAAA_cycle :
                       (B_len == 3'd1) ? l71_AAAAAAAB_cycle :
                       (B_len == 3'd2) ? l62_AAAAAABB_cycle :
                       (B_len == 3'd3) ? l53_AAAAABBB_cycle :
                       (B_len == 3'd4) ? l44_AAAABBBB_cycle : 9'd511;
assign cand_00_path = (B_len == 3'd0) ? 8'b11111111 :
                      (B_len == 3'd1) ? 8'b11111110 :
                      (B_len == 3'd2) ? 8'b11111100 :
                      (B_len == 3'd3) ? 8'b11111000 :
                      (B_len == 3'd4) ? 8'b11110000 : 8'd0;

// candidate 01
wire [8:0] cand_01_cycle;
wire [7:0] cand_01_path;
assign cand_01_cycle = (B_len == 3'd1) ? l71_AAAAAABA_cycle :
                       (B_len == 3'd2) ? l62_AAAAABAB_cycle :
                       (B_len == 3'd3) ? l53_AAAABABB_cycle :
                       (B_len == 3'd4) ? l44_AAABABBB_cycle : 9'd511;
assign cand_01_path = (B_len == 3'd1) ? 8'b11111101 :
                      (B_len == 3'd2) ? 8'b11111010 :
                      (B_len == 3'd3) ? 8'b11110100 :
                      (B_len == 3'd4) ? 8'b11101000 : 8'd0;

// candidate 02
wire [8:0] cand_02_cycle;
wire [7:0] cand_02_path;
assign cand_02_cycle = (B_len == 3'd1) ? l71_AAAAABAA_cycle :
                       (B_len == 3'd2) ? l62_AAAAABBA_cycle :
                       (B_len == 3'd3) ? l53_AAAABBAB_cycle :
                       (B_len == 3'd4) ? l44_AAABBABB_cycle : 9'd511;
assign cand_02_path = (B_len == 3'd1) ? 8'b11111011 :
                      (B_len == 3'd2) ? 8'b11111001 :
                      (B_len == 3'd3) ? 8'b11110010 :
                      (B_len == 3'd4) ? 8'b11100100 : 8'd0;

// candidate 03
wire [8:0] cand_03_cycle;
wire [7:0] cand_03_path;
assign cand_03_cycle = (B_len == 3'd1) ? l71_AAAABAAA_cycle :
                       (B_len == 3'd2) ? l62_AAAABAAB_cycle :
                       (B_len == 3'd3) ? l53_AAAABBBA_cycle :
                       (B_len == 3'd4) ? l44_AAABBBAB_cycle : 9'd511;
assign cand_03_path = (B_len == 3'd1) ? 8'b11110111 :
                      (B_len == 3'd2) ? 8'b11110110 :
                      (B_len == 3'd3) ? 8'b11110001 :
                      (B_len == 3'd4) ? 8'b11100010 : 8'd0;

// candidate 04
wire [8:0] cand_04_cycle;
wire [7:0] cand_04_path;
assign cand_04_cycle = (B_len == 3'd1) ? l71_AAABAAAA_cycle :
                       (B_len == 3'd2) ? l62_AAAABABA_cycle :
                       (B_len == 3'd3) ? l53_AAABAABB_cycle :
                       (B_len == 3'd4) ? l44_AAABBBBA_cycle : 9'd511;
assign cand_04_path = (B_len == 3'd1) ? 8'b11101111 :
                      (B_len == 3'd2) ? 8'b11110101 :
                      (B_len == 3'd3) ? 8'b11101100 :
                      (B_len == 3'd4) ? 8'b11100001 : 8'd0;

// candidate 05
wire [8:0] cand_05_cycle;
wire [7:0] cand_05_path;
assign cand_05_cycle = (B_len == 3'd1) ? l71_AABAAAAA_cycle :
                       (B_len == 3'd2) ? l62_AAAABBAA_cycle :
                       (B_len == 3'd3) ? l53_AAABABAB_cycle :
                       (B_len == 3'd4) ? l44_AABAABBB_cycle : 9'd511;
assign cand_05_path = (B_len == 3'd1) ? 8'b11011111 :
                      (B_len == 3'd2) ? 8'b11110011 :
                      (B_len == 3'd3) ? 8'b11101010 :
                      (B_len == 3'd4) ? 8'b11011000 : 8'd0;

// candidate 06
wire [8:0] cand_06_cycle;
wire [7:0] cand_06_path;
assign cand_06_cycle = (B_len == 3'd1) ? l71_ABAAAAAA_cycle :
                       (B_len == 3'd2) ? l62_AAABAAAB_cycle :
                       (B_len == 3'd3) ? l53_AAABABBA_cycle :
                       (B_len == 3'd4) ? l44_AABABABB_cycle : 9'd511;
assign cand_06_path = (B_len == 3'd1) ? 8'b10111111 :
                      (B_len == 3'd2) ? 8'b11101110 :
                      (B_len == 3'd3) ? 8'b11101001 :
                      (B_len == 3'd4) ? 8'b11010100 : 8'd0;

// candidate 07
wire [8:0] cand_07_cycle;
wire [7:0] cand_07_path;
assign cand_07_cycle = (B_len == 3'd1) ? l71_BAAAAAAA_cycle :
                       (B_len == 3'd2) ? l62_AAABAABA_cycle :
                       (B_len == 3'd3) ? l53_AAABBAAB_cycle :
                       (B_len == 3'd4) ? l44_AABABBAB_cycle : 9'd511;
assign cand_07_path = (B_len == 3'd1) ? 8'b01111111 :
                      (B_len == 3'd2) ? 8'b11101101 :
                      (B_len == 3'd3) ? 8'b11100110 :
                      (B_len == 3'd4) ? 8'b11010010 : 8'd0;

// candidate 08
wire [8:0] cand_08_cycle;
wire [7:0] cand_08_path;
assign cand_08_cycle = (B_len == 3'd2) ? l62_AAABABAA_cycle :
                       (B_len == 3'd3) ? l53_AAABBABA_cycle :
                       (B_len == 3'd4) ? l44_AABABBBA_cycle : 9'd511;
assign cand_08_path = (B_len == 3'd2) ? 8'b11101011 :
                      (B_len == 3'd3) ? 8'b11100101 :
                      (B_len == 3'd4) ? 8'b11010001 : 8'd0;

// candidate 09
wire [8:0] cand_09_cycle;
wire [7:0] cand_09_path;
assign cand_09_cycle = (B_len == 3'd2) ? l62_AAABBAAA_cycle :
                       (B_len == 3'd3) ? l53_AAABBBAA_cycle :
                       (B_len == 3'd4) ? l44_AABBAABB_cycle : 9'd511;
assign cand_09_path = (B_len == 3'd2) ? 8'b11100111 :
                      (B_len == 3'd3) ? 8'b11100011 :
                      (B_len == 3'd4) ? 8'b11001100 : 8'd0;

// candidate 10
wire [8:0] cand_10_cycle;
wire [7:0] cand_10_path;
assign cand_10_cycle = (B_len == 3'd2) ? l62_AABAAAAB_cycle :
                       (B_len == 3'd3) ? l53_AABAAABB_cycle :
                       (B_len == 3'd4) ? l44_AABBABAB_cycle : 9'd511;
assign cand_10_path = (B_len == 3'd2) ? 8'b11011110 :
                      (B_len == 3'd3) ? 8'b11011100 :
                      (B_len == 3'd4) ? 8'b11001010 : 8'd0;

// candidate 11
wire [8:0] cand_11_cycle;
wire [7:0] cand_11_path;
assign cand_11_cycle = (B_len == 3'd2) ? l62_AABAAABA_cycle :
                       (B_len == 3'd3) ? l53_AABAABAB_cycle :
                       (B_len == 3'd4) ? l44_AABBABBA_cycle : 9'd511;
assign cand_11_path = (B_len == 3'd2) ? 8'b11011101 :
                      (B_len == 3'd3) ? 8'b11011010 :
                      (B_len == 3'd4) ? 8'b11001001 : 8'd0;

// candidate 12
wire [8:0] cand_12_cycle;
wire [7:0] cand_12_path;
assign cand_12_cycle = (B_len == 3'd2) ? l62_AABAABAA_cycle :
                       (B_len == 3'd3) ? l53_AABAABBA_cycle :
                       (B_len == 3'd4) ? l44_AABBBAAB_cycle : 9'd511;
assign cand_12_path = (B_len == 3'd2) ? 8'b11011011 :
                      (B_len == 3'd3) ? 8'b11011001 :
                      (B_len == 3'd4) ? 8'b11000110 : 8'd0;

// candidate 13
wire [8:0] cand_13_cycle;
wire [7:0] cand_13_path;
assign cand_13_cycle = (B_len == 3'd2) ? l62_AABABAAA_cycle :
                       (B_len == 3'd3) ? l53_AABABAAB_cycle :
                       (B_len == 3'd4) ? l44_AABBBABA_cycle : 9'd511;
assign cand_13_path = (B_len == 3'd2) ? 8'b11010111 :
                      (B_len == 3'd3) ? 8'b11010110 :
                      (B_len == 3'd4) ? 8'b11000101 : 8'd0;

// candidate 14
wire [8:0] cand_14_cycle;
wire [7:0] cand_14_path;
assign cand_14_cycle = (B_len == 3'd2) ? l62_AABBAAAA_cycle :
                       (B_len == 3'd3) ? l53_AABABABA_cycle :
                       (B_len == 3'd4) ? l44_AABBBBAA_cycle : 9'd511;
assign cand_14_path = (B_len == 3'd2) ? 8'b11001111 :
                      (B_len == 3'd3) ? 8'b11010101 :
                      (B_len == 3'd4) ? 8'b11000011 : 8'd0;

// candidate 15
wire [8:0] cand_15_cycle;
wire [7:0] cand_15_path;
assign cand_15_cycle = (B_len == 3'd2) ? l62_ABAAAAAB_cycle :
                       (B_len == 3'd3) ? l53_AABABBAA_cycle :
                       (B_len == 3'd4) ? l44_ABAAABBB_cycle : 9'd511;
assign cand_15_path = (B_len == 3'd2) ? 8'b10111110 :
                      (B_len == 3'd3) ? 8'b11010011 :
                      (B_len == 3'd4) ? 8'b10111000 : 8'd0;

// candidate 16
wire [8:0] cand_16_cycle;
wire [7:0] cand_16_path;
assign cand_16_cycle = (B_len == 3'd2) ? l62_ABAAAABA_cycle :
                       (B_len == 3'd3) ? l53_AABBAAAB_cycle :
                       (B_len == 3'd4) ? l44_ABAABABB_cycle : 9'd511;
assign cand_16_path = (B_len == 3'd2) ? 8'b10111101 :
                      (B_len == 3'd3) ? 8'b11001110 :
                      (B_len == 3'd4) ? 8'b10110100 : 8'd0;

// candidate 17
wire [8:0] cand_17_cycle;
wire [7:0] cand_17_path;
assign cand_17_cycle = (B_len == 3'd2) ? l62_ABAAABAA_cycle :
                       (B_len == 3'd3) ? l53_AABBAABA_cycle :
                       (B_len == 3'd4) ? l44_ABAABBAB_cycle : 9'd511;
assign cand_17_path = (B_len == 3'd2) ? 8'b10111011 :
                      (B_len == 3'd3) ? 8'b11001101 :
                      (B_len == 3'd4) ? 8'b10110010 : 8'd0;

// candidate 18
wire [8:0] cand_18_cycle;
wire [7:0] cand_18_path;
assign cand_18_cycle = (B_len == 3'd2) ? l62_ABAABAAA_cycle :
                       (B_len == 3'd3) ? l53_AABBABAA_cycle :
                       (B_len == 3'd4) ? l44_ABAABBBA_cycle : 9'd511;
assign cand_18_path = (B_len == 3'd2) ? 8'b10110111 :
                      (B_len == 3'd3) ? 8'b11001011 :
                      (B_len == 3'd4) ? 8'b10110001 : 8'd0;

// candidate 19
wire [8:0] cand_19_cycle;
wire [7:0] cand_19_path;
assign cand_19_cycle = (B_len == 3'd2) ? l62_ABABAAAA_cycle :
                       (B_len == 3'd3) ? l53_AABBBAAA_cycle :
                       (B_len == 3'd4) ? l44_ABABAABB_cycle : 9'd511;
assign cand_19_path = (B_len == 3'd2) ? 8'b10101111 :
                      (B_len == 3'd3) ? 8'b11000111 :
                      (B_len == 3'd4) ? 8'b10101100 : 8'd0;

// candidate 20
wire [8:0] cand_20_cycle;
wire [7:0] cand_20_path;
assign cand_20_cycle = (B_len == 3'd2) ? l62_ABBAAAAA_cycle :
                       (B_len == 3'd3) ? l53_ABAAAABB_cycle :
                       (B_len == 3'd4) ? l44_ABABABAB_cycle : 9'd511;
assign cand_20_path = (B_len == 3'd2) ? 8'b10011111 :
                      (B_len == 3'd3) ? 8'b10111100 :
                      (B_len == 3'd4) ? 8'b10101010 : 8'd0;

// candidate 21
wire [8:0] cand_21_cycle;
wire [7:0] cand_21_path;
assign cand_21_cycle = (B_len == 3'd2) ? l62_BAAAAAAB_cycle :
                       (B_len == 3'd3) ? l53_ABAAABAB_cycle :
                       (B_len == 3'd4) ? l44_ABABABBA_cycle : 9'd511;
assign cand_21_path = (B_len == 3'd2) ? 8'b01111110 :
                      (B_len == 3'd3) ? 8'b10111010 :
                      (B_len == 3'd4) ? 8'b10101001 : 8'd0;

// candidate 22
wire [8:0] cand_22_cycle;
wire [7:0] cand_22_path;
assign cand_22_cycle = (B_len == 3'd2) ? l62_BAAAAABA_cycle :
                       (B_len == 3'd3) ? l53_ABAAABBA_cycle :
                       (B_len == 3'd4) ? l44_ABABBAAB_cycle : 9'd511;
assign cand_22_path = (B_len == 3'd2) ? 8'b01111101 :
                      (B_len == 3'd3) ? 8'b10111001 :
                      (B_len == 3'd4) ? 8'b10100110 : 8'd0;

// candidate 23
wire [8:0] cand_23_cycle;
wire [7:0] cand_23_path;
assign cand_23_cycle = (B_len == 3'd2) ? l62_BAAAABAA_cycle :
                       (B_len == 3'd3) ? l53_ABAABAAB_cycle :
                       (B_len == 3'd4) ? l44_ABABBABA_cycle : 9'd511;
assign cand_23_path = (B_len == 3'd2) ? 8'b01111011 :
                      (B_len == 3'd3) ? 8'b10110110 :
                      (B_len == 3'd4) ? 8'b10100101 : 8'd0;

// candidate 24
wire [8:0] cand_24_cycle;
wire [7:0] cand_24_path;
assign cand_24_cycle = (B_len == 3'd2) ? l62_BAAABAAA_cycle :
                       (B_len == 3'd3) ? l53_ABAABABA_cycle :
                       (B_len == 3'd4) ? l44_ABABBBAA_cycle : 9'd511;
assign cand_24_path = (B_len == 3'd2) ? 8'b01110111 :
                      (B_len == 3'd3) ? 8'b10110101 :
                      (B_len == 3'd4) ? 8'b10100011 : 8'd0;

// candidate 25
wire [8:0] cand_25_cycle;
wire [7:0] cand_25_path;
assign cand_25_cycle = (B_len == 3'd2) ? l62_BAABAAAA_cycle :
                       (B_len == 3'd3) ? l53_ABAABBAA_cycle :
                       (B_len == 3'd4) ? l44_ABBAAABB_cycle : 9'd511;
assign cand_25_path = (B_len == 3'd2) ? 8'b01101111 :
                      (B_len == 3'd3) ? 8'b10110011 :
                      (B_len == 3'd4) ? 8'b10011100 : 8'd0;

// candidate 26
wire [8:0] cand_26_cycle;
wire [7:0] cand_26_path;
assign cand_26_cycle = (B_len == 3'd2) ? l62_BABAAAAA_cycle :
                       (B_len == 3'd3) ? l53_ABABAAAB_cycle :
                       (B_len == 3'd4) ? l44_ABBAABAB_cycle : 9'd511;
assign cand_26_path = (B_len == 3'd2) ? 8'b01011111 :
                      (B_len == 3'd3) ? 8'b10101110 :
                      (B_len == 3'd4) ? 8'b10011010 : 8'd0;

// candidate 27
wire [8:0] cand_27_cycle;
wire [7:0] cand_27_path;
assign cand_27_cycle = (B_len == 3'd2) ? l62_BBAAAAAA_cycle :
                       (B_len == 3'd3) ? l53_ABABAABA_cycle :
                       (B_len == 3'd4) ? l44_ABBAABBA_cycle : 9'd511;
assign cand_27_path = (B_len == 3'd2) ? 8'b00111111 :
                      (B_len == 3'd3) ? 8'b10101101 :
                      (B_len == 3'd4) ? 8'b10011001 : 8'd0;

// candidate 28
wire [8:0] cand_28_cycle;
wire [7:0] cand_28_path;
assign cand_28_cycle = (B_len == 3'd3) ? l53_ABABABAA_cycle :
                       (B_len == 3'd4) ? l44_ABBABAAB_cycle : 9'd511;
assign cand_28_path = (B_len == 3'd3) ? 8'b10101011 :
                      (B_len == 3'd4) ? 8'b10010110 : 8'd0;

// candidate 29
wire [8:0] cand_29_cycle;
wire [7:0] cand_29_path;
assign cand_29_cycle = (B_len == 3'd3) ? l53_ABABBAAA_cycle :
                       (B_len == 3'd4) ? l44_ABBABABA_cycle : 9'd511;
assign cand_29_path = (B_len == 3'd3) ? 8'b10100111 :
                      (B_len == 3'd4) ? 8'b10010101 : 8'd0;

// candidate 30
wire [8:0] cand_30_cycle;
wire [7:0] cand_30_path;
assign cand_30_cycle = (B_len == 3'd3) ? l53_ABBAAAAB_cycle :
                       (B_len == 3'd4) ? l44_ABBABBAA_cycle : 9'd511;
assign cand_30_path = (B_len == 3'd3) ? 8'b10011110 :
                      (B_len == 3'd4) ? 8'b10010011 : 8'd0;

// candidate 31
wire [8:0] cand_31_cycle;
wire [7:0] cand_31_path;
assign cand_31_cycle = (B_len == 3'd3) ? l53_ABBAAABA_cycle :
                       (B_len == 3'd4) ? l44_ABBBAAAB_cycle : 9'd511;
assign cand_31_path = (B_len == 3'd3) ? 8'b10011101 :
                      (B_len == 3'd4) ? 8'b10001110 : 8'd0;

// candidate 32
wire [8:0] cand_32_cycle;
wire [7:0] cand_32_path;
assign cand_32_cycle = (B_len == 3'd3) ? l53_ABBAABAA_cycle :
                       (B_len == 3'd4) ? l44_ABBBAABA_cycle : 9'd511;
assign cand_32_path = (B_len == 3'd3) ? 8'b10011011 :
                      (B_len == 3'd4) ? 8'b10001101 : 8'd0;

// candidate 33
wire [8:0] cand_33_cycle;
wire [7:0] cand_33_path;
assign cand_33_cycle = (B_len == 3'd3) ? l53_ABBABAAA_cycle :
                       (B_len == 3'd4) ? l44_ABBBABAA_cycle : 9'd511;
assign cand_33_path = (B_len == 3'd3) ? 8'b10010111 :
                      (B_len == 3'd4) ? 8'b10001011 : 8'd0;

// candidate 34
wire [8:0] cand_34_cycle;
wire [7:0] cand_34_path;
assign cand_34_cycle = (B_len == 3'd3) ? l53_ABBBAAAA_cycle :
                       (B_len == 3'd4) ? l44_ABBBBAAA_cycle : 9'd511;
assign cand_34_path = (B_len == 3'd3) ? 8'b10001111 :
                      (B_len == 3'd4) ? 8'b10000111 : 8'd0;

// candidate 35
wire [8:0] cand_35_cycle;
wire [7:0] cand_35_path;
assign cand_35_cycle = (B_len == 3'd3) ? l53_BAAAAABB_cycle :
                       (B_len == 3'd4) ? l44_BAAAABBB_cycle : 9'd511;
assign cand_35_path = (B_len == 3'd3) ? 8'b01111100 :
                      (B_len == 3'd4) ? 8'b01111000 : 8'd0;

// candidate 36
wire [8:0] cand_36_cycle;
wire [7:0] cand_36_path;
assign cand_36_cycle = (B_len == 3'd3) ? l53_BAAAABAB_cycle :
                       (B_len == 3'd4) ? l44_BAAABABB_cycle : 9'd511;
assign cand_36_path = (B_len == 3'd3) ? 8'b01111010 :
                      (B_len == 3'd4) ? 8'b01110100 : 8'd0;

// candidate 37
wire [8:0] cand_37_cycle;
wire [7:0] cand_37_path;
assign cand_37_cycle = (B_len == 3'd3) ? l53_BAAAABBA_cycle :
                       (B_len == 3'd4) ? l44_BAAABBAB_cycle : 9'd511;
assign cand_37_path = (B_len == 3'd3) ? 8'b01111001 :
                      (B_len == 3'd4) ? 8'b01110010 : 8'd0;

// candidate 38
wire [8:0] cand_38_cycle;
wire [7:0] cand_38_path;
assign cand_38_cycle = (B_len == 3'd3) ? l53_BAAABAAB_cycle :
                       (B_len == 3'd4) ? l44_BAAABBBA_cycle : 9'd511;
assign cand_38_path = (B_len == 3'd3) ? 8'b01110110 :
                      (B_len == 3'd4) ? 8'b01110001 : 8'd0;

// candidate 39
wire [8:0] cand_39_cycle;
wire [7:0] cand_39_path;
assign cand_39_cycle = (B_len == 3'd3) ? l53_BAAABABA_cycle :
                       (B_len == 3'd4) ? l44_BAABAABB_cycle : 9'd511;
assign cand_39_path = (B_len == 3'd3) ? 8'b01110101 :
                      (B_len == 3'd4) ? 8'b01101100 : 8'd0;

// candidate 40
wire [8:0] cand_40_cycle;
wire [7:0] cand_40_path;
assign cand_40_cycle = (B_len == 3'd3) ? l53_BAAABBAA_cycle :
                       (B_len == 3'd4) ? l44_BAABABAB_cycle : 9'd511;
assign cand_40_path = (B_len == 3'd3) ? 8'b01110011 :
                      (B_len == 3'd4) ? 8'b01101010 : 8'd0;

// candidate 41
wire [8:0] cand_41_cycle;
wire [7:0] cand_41_path;
assign cand_41_cycle = (B_len == 3'd3) ? l53_BAABAAAB_cycle :
                       (B_len == 3'd4) ? l44_BAABABBA_cycle : 9'd511;
assign cand_41_path = (B_len == 3'd3) ? 8'b01101110 :
                      (B_len == 3'd4) ? 8'b01101001 : 8'd0;

// candidate 42
wire [8:0] cand_42_cycle;
wire [7:0] cand_42_path;
assign cand_42_cycle = (B_len == 3'd3) ? l53_BAABAABA_cycle :
                       (B_len == 3'd4) ? l44_BAABBAAB_cycle : 9'd511;
assign cand_42_path = (B_len == 3'd3) ? 8'b01101101 :
                      (B_len == 3'd4) ? 8'b01100110 : 8'd0;

// candidate 43
wire [8:0] cand_43_cycle;
wire [7:0] cand_43_path;
assign cand_43_cycle = (B_len == 3'd3) ? l53_BAABABAA_cycle :
                       (B_len == 3'd4) ? l44_BAABBABA_cycle : 9'd511;
assign cand_43_path = (B_len == 3'd3) ? 8'b01101011 :
                      (B_len == 3'd4) ? 8'b01100101 : 8'd0;

// candidate 44
wire [8:0] cand_44_cycle;
wire [7:0] cand_44_path;
assign cand_44_cycle = (B_len == 3'd3) ? l53_BAABBAAA_cycle :
                       (B_len == 3'd4) ? l44_BAABBBAA_cycle : 9'd511;
assign cand_44_path = (B_len == 3'd3) ? 8'b01100111 :
                      (B_len == 3'd4) ? 8'b01100011 : 8'd0;

// candidate 45
wire [8:0] cand_45_cycle;
wire [7:0] cand_45_path;
assign cand_45_cycle = (B_len == 3'd3) ? l53_BABAAAAB_cycle :
                       (B_len == 3'd4) ? l44_BABAAABB_cycle : 9'd511;
assign cand_45_path = (B_len == 3'd3) ? 8'b01011110 :
                      (B_len == 3'd4) ? 8'b01011100 : 8'd0;

// candidate 46
wire [8:0] cand_46_cycle;
wire [7:0] cand_46_path;
assign cand_46_cycle = (B_len == 3'd3) ? l53_BABAAABA_cycle :
                       (B_len == 3'd4) ? l44_BABAABAB_cycle : 9'd511;
assign cand_46_path = (B_len == 3'd3) ? 8'b01011101 :
                      (B_len == 3'd4) ? 8'b01011010 : 8'd0;

// candidate 47
wire [8:0] cand_47_cycle;
wire [7:0] cand_47_path;
assign cand_47_cycle = (B_len == 3'd3) ? l53_BABAABAA_cycle :
                       (B_len == 3'd4) ? l44_BABAABBA_cycle : 9'd511;
assign cand_47_path = (B_len == 3'd3) ? 8'b01011011 :
                      (B_len == 3'd4) ? 8'b01011001 : 8'd0;

// candidate 48
wire [8:0] cand_48_cycle;
wire [7:0] cand_48_path;
assign cand_48_cycle = (B_len == 3'd3) ? l53_BABABAAA_cycle :
                       (B_len == 3'd4) ? l44_BABABAAB_cycle : 9'd511;
assign cand_48_path = (B_len == 3'd3) ? 8'b01010111 :
                      (B_len == 3'd4) ? 8'b01010110 : 8'd0;

// candidate 49
wire [8:0] cand_49_cycle;
wire [7:0] cand_49_path;
assign cand_49_cycle = (B_len == 3'd3) ? l53_BABBAAAA_cycle :
                       (B_len == 3'd4) ? l44_BABABABA_cycle : 9'd511;
assign cand_49_path = (B_len == 3'd3) ? 8'b01001111 :
                      (B_len == 3'd4) ? 8'b01010101 : 8'd0;

// candidate 50
wire [8:0] cand_50_cycle;
wire [7:0] cand_50_path;
assign cand_50_cycle = (B_len == 3'd3) ? l53_BBAAAAAB_cycle :
                       (B_len == 3'd4) ? l44_BABABBAA_cycle : 9'd511;
assign cand_50_path = (B_len == 3'd3) ? 8'b00111110 :
                      (B_len == 3'd4) ? 8'b01010011 : 8'd0;

// candidate 51
wire [8:0] cand_51_cycle;
wire [7:0] cand_51_path;
assign cand_51_cycle = (B_len == 3'd3) ? l53_BBAAAABA_cycle :
                       (B_len == 3'd4) ? l44_BABBAAAB_cycle : 9'd511;
assign cand_51_path = (B_len == 3'd3) ? 8'b00111101 :
                      (B_len == 3'd4) ? 8'b01001110 : 8'd0;

// candidate 52
wire [8:0] cand_52_cycle;
wire [7:0] cand_52_path;
assign cand_52_cycle = (B_len == 3'd3) ? l53_BBAAABAA_cycle :
                       (B_len == 3'd4) ? l44_BABBAABA_cycle : 9'd511;
assign cand_52_path = (B_len == 3'd3) ? 8'b00111011 :
                      (B_len == 3'd4) ? 8'b01001101 : 8'd0;

// candidate 53
wire [8:0] cand_53_cycle;
wire [7:0] cand_53_path;
assign cand_53_cycle = (B_len == 3'd3) ? l53_BBAABAAA_cycle :
                       (B_len == 3'd4) ? l44_BABBABAA_cycle : 9'd511;
assign cand_53_path = (B_len == 3'd3) ? 8'b00110111 :
                      (B_len == 3'd4) ? 8'b01001011 : 8'd0;

// candidate 54
wire [8:0] cand_54_cycle;
wire [7:0] cand_54_path;
assign cand_54_cycle = (B_len == 3'd3) ? l53_BBABAAAA_cycle :
                       (B_len == 3'd4) ? l44_BABBBAAA_cycle : 9'd511;
assign cand_54_path = (B_len == 3'd3) ? 8'b00101111 :
                      (B_len == 3'd4) ? 8'b01000111 : 8'd0;

// candidate 55
wire [8:0] cand_55_cycle;
wire [7:0] cand_55_path;
assign cand_55_cycle = (B_len == 3'd3) ? l53_BBBAAAAA_cycle :
                       (B_len == 3'd4) ? l44_BBAAAABB_cycle : 9'd511;
assign cand_55_path = (B_len == 3'd3) ? 8'b00011111 :
                      (B_len == 3'd4) ? 8'b00111100 : 8'd0;

// candidate 56
wire [8:0] cand_56_cycle;
wire [7:0] cand_56_path;
assign cand_56_cycle = (B_len == 3'd4) ? l44_BBAAABAB_cycle : 9'd511;
assign cand_56_path = (B_len == 3'd4) ? 8'b00111010 : 8'd0;

// candidate 57
wire [8:0] cand_57_cycle;
wire [7:0] cand_57_path;
assign cand_57_cycle = (B_len == 3'd4) ? l44_BBAAABBA_cycle : 9'd511;
assign cand_57_path = (B_len == 3'd4) ? 8'b00111001 : 8'd0;

// candidate 58
wire [8:0] cand_58_cycle;
wire [7:0] cand_58_path;
assign cand_58_cycle = (B_len == 3'd4) ? l44_BBAABAAB_cycle : 9'd511;
assign cand_58_path = (B_len == 3'd4) ? 8'b00110110 : 8'd0;

// candidate 59
wire [8:0] cand_59_cycle;
wire [7:0] cand_59_path;
assign cand_59_cycle = (B_len == 3'd4) ? l44_BBAABABA_cycle : 9'd511;
assign cand_59_path = (B_len == 3'd4) ? 8'b00110101 : 8'd0;

// candidate 60
wire [8:0] cand_60_cycle;
wire [7:0] cand_60_path;
assign cand_60_cycle = (B_len == 3'd4) ? l44_BBAABBAA_cycle : 9'd511;
assign cand_60_path = (B_len == 3'd4) ? 8'b00110011 : 8'd0;

// candidate 61
wire [8:0] cand_61_cycle;
wire [7:0] cand_61_path;
assign cand_61_cycle = (B_len == 3'd4) ? l44_BBABAAAB_cycle : 9'd511;
assign cand_61_path = (B_len == 3'd4) ? 8'b00101110 : 8'd0;

// candidate 62
wire [8:0] cand_62_cycle;
wire [7:0] cand_62_path;
assign cand_62_cycle = (B_len == 3'd4) ? l44_BBABAABA_cycle : 9'd511;
assign cand_62_path = (B_len == 3'd4) ? 8'b00101101 : 8'd0;

// candidate 63
wire [8:0] cand_63_cycle;
wire [7:0] cand_63_path;
assign cand_63_cycle = (B_len == 3'd4) ? l44_BBABABAA_cycle : 9'd511;
assign cand_63_path = (B_len == 3'd4) ? 8'b00101011 : 8'd0;

// candidate 64
wire [8:0] cand_64_cycle;
wire [7:0] cand_64_path;
assign cand_64_cycle = (B_len == 3'd4) ? l44_BBABBAAA_cycle : 9'd511;
assign cand_64_path = (B_len == 3'd4) ? 8'b00100111 : 8'd0;

// candidate 65
wire [8:0] cand_65_cycle;
wire [7:0] cand_65_path;
assign cand_65_cycle = (B_len == 3'd4) ? l44_BBBAAAAB_cycle : 9'd511;
assign cand_65_path = (B_len == 3'd4) ? 8'b00011110 : 8'd0;

// candidate 66
wire [8:0] cand_66_cycle;
wire [7:0] cand_66_path;
assign cand_66_cycle = (B_len == 3'd4) ? l44_BBBAAABA_cycle : 9'd511;
assign cand_66_path = (B_len == 3'd4) ? 8'b00011101 : 8'd0;

// candidate 67
wire [8:0] cand_67_cycle;
wire [7:0] cand_67_path;
assign cand_67_cycle = (B_len == 3'd4) ? l44_BBBAABAA_cycle : 9'd511;
assign cand_67_path = (B_len == 3'd4) ? 8'b00011011 : 8'd0;

// candidate 68
wire [8:0] cand_68_cycle;
wire [7:0] cand_68_path;
assign cand_68_cycle = (B_len == 3'd4) ? l44_BBBABAAA_cycle : 9'd511;
assign cand_68_path = (B_len == 3'd4) ? 8'b00010111 : 8'd0;

// candidate 69
wire [8:0] cand_69_cycle;
wire [7:0] cand_69_path;
assign cand_69_cycle = (B_len == 3'd4) ? l44_BBBBAAAA_cycle : 9'd511;
assign cand_69_path = (B_len == 3'd4) ? 8'b00001111 : 8'd0;
