# 2x3M + 2x3M (4S4B + 4S4B)
s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

s25_4s4b = bg.generate_sides("S25", count=8, number=2, overlap=0.25)
s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)

s25_4s4b_core = s25_4s4b[0, 4]
s25_4s4b_sides = s25_4s4b[4, 8]

s36_4s4b_core = s36_4s4b[0, 4]
s36_4s4b_sides = s36_4s4b[4, 6]


### T1 ###

#### Bottom Layer ####

t1_m1a = bg.sequence_generator({
    "S1" => s14_8s[0][0],
    "S2" => s25_4s4b_sides[0][0],
    "S6" => bg.complement_side(s36_4s4b_core[0][0])
})
t1_m2a = bg.sequence_generator({
    "S2" => s25_4s4b_sides[1][0],
    "S3" => s36_4s4b_sides[0][0],
    "S4" => bg.complement_side(s14_8s[0][0]),
    "S5" => bg.complement_side(s25_4s4b_core[0][0])
})

t1_m3a = bg.sequence_generator({
    "S2" => s25_4s4b_core[0][0],
    "S3" => s36_4s4b_core[0][0]
})

#### Top Layer ####

t1_m1b = bg.sequence_generator({
    "S1" => s14_8s[1][0],
    "S2" => s25_4s4b_sides[2][0],
    "S6" => bg.complement_side(s36_4s4b_core[1][0])
})
t1_m2b = bg.sequence_generator({
    "S2" => s25_4s4b_sides[3][0],
    "S3" => s36_4s4b_sides[1][0],
    "S4" => bg.complement_side(s14_8s[1][0]),
    "S5" => bg.complement_side(s25_4s4b_core[1][0])
})

t1_m3b = bg.sequence_generator({
    "S2" => s25_4s4b_core[1][0],
    "S3" => s36_4s4b_core[1][0]
})

### T2 ###

t2_m1a = bg.sequence_generator({
    "S1" => s14_8s[2][0],
    "S2" => s25_4s4b_core[2][0],
    "S5" => bg.complement_side(s25_4s4b_sides[0][0]),
    "S6" => bg.complement_side(s36_4s4b_sides[0][0])
})
t2_m2a = bg.sequence_generator({
    "S3" => s36_4s4b_core[2][0],
    "S4" => bg.complement_side(s14_8s[2][0]),
    "S5" => bg.complement_side(s25_4s4b_sides[1][0])
})

t2_m3a = bg.sequence_generator({
    "S5" => bg.complement_side(s25_4s4b_core[2][0]),
    "S6" => bg.complement_side(s36_4s4b_core[2][0])
})

#### Top Layer ####

t2_m1b = bg.sequence_generator({
    "S1" => s14_8s[3][0],
    "S2" => s25_4s4b_core[3][0],
    "S5" => bg.complement_side(s25_4s4b_sides[2][0]),
    "S6" => bg.complement_side(s36_4s4b_sides[1][0])
})
t2_m2b = bg.sequence_generator({
    "S3" => s36_4s4b_core[3][0],
    "S4" => bg.complement_side(s14_8s[3][0]),
    "S5" => bg.complement_side(s25_4s4b_sides[3][0])
})

t2_m3b = bg.sequence_generator({
    "S5" => bg.complement_side(s25_4s4b_core[3][0]),
    "S6" => bg.complement_side(s36_4s4b_core[3][0])
})

# # Z Bonds
z_6h_tail_bonds = bg.z_bond_sampler(3, 6, "TAIL", 0.67)
z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])

t1_m1a_final = t1_m1a_z_seqs + t1_m1a
t1_m2a_final = t1_m2a_z_seqs + t1_m2a
t1_m3a_final = t1_m3a_z_seqs + t1_m3a

t1_m1b_final = t1_m1b_z_seqs + t1_m1b
t1_m2b_final = t1_m2b_z_seqs + t1_m2b
t1_m3b_final = t1_m3b_z_seqs + t1_m3b

t2_m1a_final = t2_m1a_z_seqs + t2_m1a
t2_m2a_final = t2_m2a_z_seqs + t2_m2a
t2_m3a_final = t2_m3a_z_seqs + t2_m3a

t2_m1b_final = t2_m1b_z_seqs + t2_m1b
t2_m2b_final = t2_m2b_z_seqs + t2_m2b
t2_m3b_final = t2_m3b_z_seqs + t2_m3b


bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M1A.csv")
bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M2A.csv")
bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M3A.csv")

bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M1B.csv")
bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M2B.csv")
bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M3B.csv")

bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M1A.csv")
bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M2A.csv")
bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M3A.csv")

bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M1B.csv")
bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M2B.csv")
bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M3B.csv")