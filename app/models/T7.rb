### T7

### Layer 1

m1a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[0][0], "BS"],
    "S2" => [s25_handles[0][0], "BS"],
    "S3" => [s36_handles[0][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[10][0]), "BS"]
    "S5" => [bg.complement_side(s25_half_handles[2][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[0][0]), "BS"]
})

m2a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[1][0], "BS"],
    "S2" => [s25_handles[1][0], "BS"],
    "S3" => [s36_half_handles[11][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[11][0]), "BS"],
    "S5" => [bg.complement_side(s25_half_handles[9][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
})

m3a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[2][0], "BS"],
    "S2" => [s25_half_handles[7][0], "BS"],
    "S3" => [s36_half_handles[10][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[6][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
})

m4a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[3][0], "BS"],
    "S2" => [s25_handles[3][0], "BS"],
    "S3" => [s36_handles[1][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
})

m5a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[2][0], "BS"],
    "S2" => [s25_handles[2][0], "BS"],
    "S3" => [s36_handles[2][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[0][0]), "BS"],
    "S5" => [bg.complement_side(s25_half_handles[1][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[5][0]), "BS"]
})

m6a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[3][0], "BS"],
    "S2" => [s25_half_handles[5][0], "BS"],
    "S3" => [s36_handles[3][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[2][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[4][0]), "BS"]
})

m7a_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[4][0], "BS"],
    "S2" => [s25_half_handles[6][0], "BS"],
    "S3" => [s36_half_handles[9][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
})

### Layer 2

m1b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[4+0][0], "BS"],
    "S2" => [s25_handles[4+0][0], "BS"],
    "S3" => [s36_handles[4+0][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[10+12][0]), "BS"]
    "S5" => [bg.complement_side(s25_half_handles[2+12][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[0+12][0]), "BS"]
})

m2b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[4+1][0], "BS"],
    "S2" => [s25_handles[4+1][0], "BS"],
    "S3" => [s36_half_handles[12+11][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[11+12][0]), "BS"],
    "S5" => [bg.complement_side(s25_half_handles[12+9][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[4+0][0]), "BS"]
})

m3b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[4+2][0], "BS"],
    "S2" => [s25_half_handles[7+12][0], "BS"],
    "S3" => [s36_half_handles[12+10][0], "BS"],
    "S4" => [bg.complement_side(s14_half_handles[6+12][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[4+1][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[4+1][0]), "BS"]
})

m4b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_handles[4+3][0], "BS"],
    "S2" => [s25_handles[4+3][0], "BS"],
    "S3" => [s36_handles[4+1][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[4+1][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[4+0][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[4+2][0]), "BS"]
})

m5b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[12+2][0], "BS"],
    "S2" => [s25_handles[4+2][0], "BS"],
    "S3" => [s36_handles[4+2][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[4+0][0]), "BS"]
    "S5" => [bg.complement_side(s25_half_handles[1+12][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[5+12][0]), "BS"]
})

m6b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[12+3][0], "BS"],
    "S2" => [s25_half_handles[5+12][0], "BS"],
    "S3" => [s36_handles[4+3][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[4+3][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[4+2][0]), "BS"]
    "S6" => [bg.complement_side(s36_half_handles[4+12][0]), "BS"]
})

m7b_2x7M_T7 = bg.sequence_generator({
    "S1" => [s14_half_handles[12+4][0], "BS"],
    "S2" => [s25_half_handles[6+12][0], "BS"],
    "S3" => [s36_half_handles[12+9][0], "BS"],
    "S4" => [bg.complement_side(s14_handles[4+2][0]), "BS"],
    "S5" => [bg.complement_side(s25_handles[4+3][0]), "BS"],
    "S6" => [bg.complement_side(s36_handles[4+3][0]), "BS"]
})