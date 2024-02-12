# Side 1
61_L_S, H61_L_P = "TGATAAA", "TCCTCAT"
H60_L_S, H60_L_P = "CATCGCC", "TAAAGCC"
H57_L_S, H57_L_P = "GAGGAAG", "AATAAGT"
H56_L_S, H56_L_P = "TTTTCAT", "TTTAACG"

# Side 2
H54_L_S, H54_L_P = "CTTTTGC", "GGGGGTA"
H53_L_S, H53_L_P = "AAGGCCG", "ATAGTAA"
H50_L_S, H50_L_P = "GACAGCC", "AACCGCC"
H49_L_S, H49_L_P = "TTCCACA", "TCCCTCA"

# Side 3
H47_L_S, H47_L_P = "CGCCATA", "CAGACCA"
H46_L_S, H46_L_P = "TCAGAAC", "GGCGCAA"
H43_L_S, H43_L_P = "GACTCCT", "TAACGCC"
H42_L_S, H42_L_P = "AGGCTGA", "AAAAGGA"

### RIGHT SIDE ### 

# Side 1
H61_R_S, H61_R_P = "TGCGAAC", "TCCGGCC"
H60_R_S, H60_R_P = "GAGTAGA", "GGCAGCC"
H57_R_S, H57_R_P = "TGTACCA", "AAACGAC"
H56_R_S, H56_R_P = "AAAACAT", "CGTTGTA"

# Side 2
H54_R_S, H54_R_P = "AATATGA", "ATTCATT"
H53_R_S, H53_R_P = "TATTCAA", "CATAAAT"
H50_R_S, H50_R_P = "AACAAGA", "GGTGGTG"
H49_R_S, H49_R_P = "GAATCGA", "CACCGTC"

# Side 3
H47_R_S, H47_R_P = "CCAATAG", "GAGGTCA"
H46_R_S, H46_R_P = "GAACGCC", "TTGATAA"
H43_R_S, H43_R_P = "CTTTCCG", "TAATTCG"
H42_R_S, H42_R_P = "GCACCGC", "CGCGTTT"

BOND2GIBBS = {
    "H61_L_S": compute_free_energy(H61_L_S),
    "H60_L_S": compute_free_energy(H60_L_S),
    "H57_L_S": compute_free_energy(H57_L_S),
    "H56_L_S": compute_free_energy(H56_L_S),
    "H61_L_P": compute_free_energy(H61_L_P),
    "H60_L_P": compute_free_energy(H60_L_P),
    "H57_L_P": compute_free_energy(H57_L_P),
    "H56_L_P": compute_free_energy(H56_L_P),
    "H54_L_S": compute_free_energy(H54_L_S),
    "H53_L_S": compute_free_energy(H53_L_S),
    "H50_L_S": compute_free_energy(H50_L_S),
    "H49_L_S": compute_free_energy(H49_L_S),
    "H54_L_P": compute_free_energy(H54_L_P),
    "H53_L_P": compute_free_energy(H53_L_P),
    "H50_L_P": compute_free_energy(H50_L_P),
    "H49_L_P": compute_free_energy(H49_L_P),
    "H47_L_S": compute_free_energy(H47_L_S),
    "H46_L_S": compute_free_energy(H46_L_S),
    "H43_L_S": compute_free_energy(H43_L_S),
    "H42_L_S": compute_free_energy(H42_L_S),
    "H47_L_P": compute_free_energy(H47_L_P),
    "H46_L_P": compute_free_energy(H46_L_P),
    "H43_L_P": compute_free_energy(H43_L_P),
    "H42_L_P": compute_free_energy(H42_L_P),
    "H61_R_S": compute_free_energy(H61_R_S),
    "H60_R_S": compute_free_energy(H60_R_S),
    "H57_R_S": compute_free_energy(H57_R_S),
    "H56_R_S": compute_free_energy(H56_R_S),
    "H61_R_P": compute_free_energy(H61_R_P),
    "H60_R_P": compute_free_energy(H60_R_P),
    "H57_R_P": compute_free_energy(H57_R_P),
    "H56_R_P": compute_free_energy(H56_R_P),
    "H54_R_S": compute_free_energy(H54_R_S),
    "H53_R_S": compute_free_energy(H53_R_S),
    "H50_R_S": compute_free_energy(H50_R_S),
    "H49_R_S": compute_free_energy(H49_R_S),
    "H54_R_P": compute_free_energy(H54_R_P),
    "H53_R_P": compute_free_energy(H53_R_P),
    "H50_R_P": compute_free_energy(H50_R_P),
    "H49_R_P": compute_free_energy(H49_R_P),
    "H47_R_S": compute_free_energy(H47_R_S),
    "H46_R_S": compute_free_energy(H46_R_S),
    "H43_R_S": compute_free_energy(H43_R_S),
    "H42_R_S": compute_free_energy(H42_R_S),
    "H47_R_P": compute_free_energy(H47_R_P),
    "H46_R_P": compute_free_energy(H46_R_P),
    "H43_R_P": compute_free_energy(H43_R_P),
    "H42_R_P": compute_free_energy(H42_R_P)
}

NN_ESTIMATES = {
    "AA" : 1.9,
    "AT" : 1.5,
    "AC" : 1.3,
    "AG" : 1.6,
    "TA" : 0.9,
    "TT" : 1.9,
    "TC" : 1.6,
    "TG" : 1.9,
    "CA" : 1.9,
    "CT" : 1.6,
    "CG" : 3.6,
    "CC" : 3.1,
    "GT" : 1.3,
    "GA" : 1.6,
    "GC" : 3.1,
    "GG" : 3.1
}