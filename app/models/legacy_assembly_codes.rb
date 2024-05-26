# dim_S14_4s4b = bg.generate_sides("S14", count=11, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=55.0)
# dim_S25_4s4b = bg.generate_sides("S25", count=11, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=55.0)
# dim_S36_4s4b = bg.generate_sides("S36", count=11, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=55.0)

# full_s14 = bg.generate_sides("S14", count=3, number=4, overlap=0.5, weak_strength_min=98.0, weak_strength_max=105.0)
# full_s25 = bg.generate_sides("S25", count=3, number=4, overlap=0.5, weak_strength_min=98.0, weak_strength_max=105.0)
# full_s36 = bg.generate_sides("S36", count=3, number=4, overlap=0.5, weak_strength_min=98.0, weak_strength_max=105.0)

# hept_m1_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[5][0],
#     "S2" => dim_S25_4s4b[7][0],
#     "S3" => dim_S36_4s4b[7][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[4][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[3][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[4][0])
# })

# hept_m2_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[6][0],
#     "S2" => dim_S25_4s4b[8][0],
#     "S3" => full_s36[1][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[5][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[4][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[5][0])
# })

# hept_m3_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[9][0],
#     "S2" => dim_S25_4s4b[10][0],
#     "S3" => dim_S36_4s4b[9][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[8][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[7][0]),
#     "S6" => bg.complement_side(full_s36[1][0])
# })

# hept_m4_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[8][0],
#     "S2" => dim_S25_4s4b[9][0],
#     "S3" => dim_S36_4s4b[8][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[7][0]),
#     "S5" => bg.complement_side(full_s25[1][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[7][0])
# })

# hept_m5_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[4][0],
#     "S2" => full_s25[1][0],
#     "S3" => dim_S36_4s4b[6][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[3][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[2][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[3][0])
# })

# hept_m6_4s4b = bg.sequence_generator({
#     "S1" => full_s14[1][0],
#     "S2" => dim_S25_4s4b[3][0],
#     "S3" => dim_S36_4s4b[3][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[1][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[0][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[1][0])
# })

# hept_m7_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[2][0],
#     "S2" => dim_S25_4s4b[4][0],
#     "S3" => dim_S36_4s4b[4][0],
#     "S4" => bg.complement_side(full_s14[1][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[1][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[2][0])
# })

# hept_m8_4s4b = bg.sequence_generator({
#     "S3" => full_s36[0][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[6][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[5][0])
# })

# hept_m9_4s4b = bg.sequence_generator({
#     "S3" => dim_S36_4s4b[10][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[9][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[8][0]),
#     "S6" => bg.complement_side(full_s36[0][0])
# })

# hept_m10_4s4b = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[2][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[10][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[10][0])
# })

# hept_m11_4s4b = bg.sequence_generator({
#     "S1" => full_s14[2][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[10][0]),
#     "S5" => bg.complement_side(dim_S25_4s4b[9][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[9][0])
# })

# hept_m12_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[10][0],
#     "S5" => bg.complement_side(full_s25[2][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[8][0])
# })

# hept_m13_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[7][0],
#     "S2" => full_s25[2][0],
#     "S5" => bg.complement_side(dim_S25_4s4b[6][0]),
#     "S6" => bg.complement_side(dim_S36_4s4b[6][0])
# })

# hept_m14_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[3][0],
#     "S2" => dim_S25_4s4b[6][0],
#     "S6" => bg.complement_side(full_s36[2][0])
# })

# hept_m15_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[1][0],
#     "S2" => dim_S25_4s4b[2][0],
#     "S3" => full_s36[2][0],
#     "S6" => bg.complement_side(dim_S36_4s4b[0][0])
# })

# hept_m16_4s4b = bg.sequence_generator({
#     "S1" => full_s14[0][0],
#     "S2" => dim_S25_4s4b[0][0],
#     "S3" => dim_S36_4s4b[0][0]
# })

# hept_m17_4s4b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[0][0],
#     "S2" => dim_S25_4s4b[1][0],
#     "S3" => dim_S36_4s4b[1][0],
#     "S4" => bg.complement_side(full_s14[0][0])
# })

# hept_m18_4s4b = bg.sequence_generator({
#     "S2" => full_s25[0][0],
#     "S3" => dim_S36_4s4b[2][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[0][0])
# })

# hept_m19_4s4b = bg.sequence_generator({
#     "S2" => dim_S25_4s4b[5][0],
#     "S3" => dim_S36_4s4b[5][0],
#     "S4" => bg.complement_side(dim_S14_4s4b[2][0]),
#     "S5" => bg.complement_side(full_s25[0][0])
# })

# bg.to_csv(["Sequence"] + hept_m1_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M1.csv")
# bg.to_csv(["Sequence"] + hept_m2_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M2.csv")
# bg.to_csv(["Sequence"] + hept_m3_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M3.csv")
# bg.to_csv(["Sequence"] + hept_m4_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M4.csv")
# bg.to_csv(["Sequence"] + hept_m5_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M5.csv")
# bg.to_csv(["Sequence"] + hept_m6_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M6.csv")
# bg.to_csv(["Sequence"] + hept_m7_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M7.csv")
# bg.to_csv(["Sequence"] + hept_m8_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M8.csv")
# bg.to_csv(["Sequence"] + hept_m9_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M9.csv")
# bg.to_csv(["Sequence"] + hept_m10_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M10.csv")
# bg.to_csv(["Sequence"] + hept_m11_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M11.csv")
# bg.to_csv(["Sequence"] + hept_m12_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M12.csv")
# bg.to_csv(["Sequence"] + hept_m13_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M13.csv")
# bg.to_csv(["Sequence"] + hept_m14_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M14.csv")
# bg.to_csv(["Sequence"] + hept_m15_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M15.csv")
# bg.to_csv(["Sequence"] + hept_m16_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M16.csv")
# bg.to_csv(["Sequence"] + hept_m17_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M17.csv")
# bg.to_csv(["Sequence"] + hept_m18_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M18.csv")
# bg.to_csv(["Sequence"] + hept_m19_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M19.csv")

# dim_S14_2s6b = bg.generate_sides("S14", count=1, number=1, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)
# dim_S25_2s6b = bg.generate_sides("S25", count=1, number=1, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)
# dim_S36_2s6b = bg.generate_sides("S36", count=1, number=1, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)

# dim_S14_4s4b = bg.generate_sides("S14", count=4, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)
# dim_S25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)
# dim_S36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0.25, weak_strength_min=0.0, weak_strength_max=50.0)

# full_s14 = bg.generate_sides("S14", count=2, number=4, overlap=0.25)
# # full_s25 = bg.generate_sides("S25", count=1, number=4, overlap=0.25)
# full_s36 = bg.generate_sides("S36", count=1, number=4, overlap=0.25)



# hept_m1_4s4b_asym = bg.sequence_generator({
#     "S1" => full_s14[0][0], "S4" => bg.complement_side(dim_S14_4s4b[2][0]), \
#     "S2" => dim_S25_4s4b[0][0], "S5" => bg.complement_side(dim_S25_4s4b[2][0]), \
#     "S3" => dim_S36_4s4b[0][0], "S6" => bg.complement_side(dim_S36_4s4b[2][0])
#     })

# hept_m2_4s4b_asym = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[0][0]), "S5" => bg.complement_side(dim_S25_4s4b[3][0]), "S3" => dim_S36_4s4b[3][0]
# })

# hept_m3_4s4b_asym = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[1][0]), "S5" => bg.complement_side(dim_S25_4s4b[0][0]), "S6" => bg.complement_side(dim_S36_4s4b[3][0])
# })

# hept_m4_4s4b_asym = bg.sequence_generator({
#     "S1" => full_s14[1][0], "S5" => bg.complement_side(dim_S25_4s4b[1][0]), "S6" => bg.complement_side(dim_S36_4s4b[0][0])
# })

# hept_m5_4s4b_asym = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[2][0], "S2" => dim_S25_4s4b[1][0], "S6" => bg.complement_side(full_s36[0][0])
# })

# hept_m6_4s4b_asym = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[3][0], "S2" => dim_S25_4s4b[2][0], "S3" => full_s36[0][0]
# })

# hept_m7_4s4b_asym = bg.sequence_generator({
#     "S4" => bg.complement_side(dim_S14_4s4b[3][0]), "S2" => dim_S25_4s4b[3][0], "S3" => dim_S36_4s4b[2][0]
# })

# bg.to_csv(["Sequence"] + hept_m1_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M1.csv")
# bg.to_csv(["Sequence"] + hept_m2_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M2.csv")
# bg.to_csv(["Sequence"] + hept_m3_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M3.csv")
# bg.to_csv(["Sequence"] + hept_m4_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M4.csv")
# bg.to_csv(["Sequence"] + hept_m5_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M5.csv")
# bg.to_csv(["Sequence"] + hept_m6_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M6.csv")
# bg.to_csv(["Sequence"] + hept_m7_4s4b_asym, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-4S4B-ASYM/M7.csv")

# hept_m1_2s6b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[0][0], "S4" => bg.complement_side(dim_S14_4s4b[1][0]), \
#     "S2" => dim_S25_4s4b[1][0], "S5" => bg.complement_side(dim_S25_4s4b[0][0]), \
#     "S3" => dim_S36_4s4b[0][0], "S6" => bg.complement_side(dim_S36_4s4b[1][0])})

# hept_m2_2s6b = bg.sequence_generator({
#     "S4" => bg.complement_side(dim_S14_4s4b[0][0]), 
#     "S5" => bg.complement_side(dim_S25_2s6b[0][0]), 
#     "S3" => full_s36[0][0]})

# hept_m3_2s6b = bg.sequence_generator({
#     "S4" => bg.complement_side(dim_S14_2s6b[0][0]), 
#     "S5" => bg.complement_side(dim_S25_4s4b[1][0]), 
#     "S6" => bg.complement_side(full_s36[0][0])})

# hept_m4_2s6b = bg.sequence_generator({
#     "S1" => dim_S14_2s6b[0][0], 
#     "S5" => bg.complement_side(full_s25[0][0]), 
#     "S6" => bg.complement_side(dim_S36_4s4b[0][0])})

# hept_m5_2s6b = bg.sequence_generator({
#     "S1" => dim_S14_4s4b[1][0], 
#     "S2" => full_s25[0][0], 
#     "S6" => bg.complement_side(dim_S36_2s6b[0][0])})

# hept_m6_2s6b = bg.sequence_generator({
#     "S1" => full_s14[0][0], 
#     "S2" => dim_S25_4s4b[0][0], 
#     "S3" => dim_S36_2s6b[0][0]})

# hept_m7_2s6b = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[0][0]),
#     "S2" => dim_S25_2s6b[0][0], 
#     "S3" => dim_S36_4s4b[1][0]})


# bg.to_csv(hept_m1_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M1.csv")
# bg.to_csv(hept_m2_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M2.csv")
# bg.to_csv(hept_m3_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M3.csv")
# bg.to_csv(hept_m4_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M4.csv")
# bg.to_csv(hept_m5_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M5.csv")
# bg.to_csv(hept_m6_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M6.csv")
# bg.to_csv(hept_m7_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M-4S4B-SYM/M7.csv")

# z_8h_tail_bonds = bg.z_bond_sampler(4, 2, "TAIL", 0.5)
# z_8h_head_bonds = bg.z_bond_sampler(4, 2, "HEAD", 0.5)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_8h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_8h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])

# dim_S36_8s = bg.generate_sides("S36", count=2, number=4, overlap=0.25, weak_strength_min=98.0, weak_strength_max=102.0)

# m1a_8s = bg.sequence_generator({"S3" => dim_S36_8s[0][0]})
# m2a_8s = bg.sequence_generator({"S6" => bg.complement_side(dim_S36_8s[0][0])})
# m1b_8s = bg.sequence_generator({"S3" => dim_S36_8s[1][0]})
# m2b_8s = bg.sequence_generator({"S6" => bg.complement_side(dim_S36_8s[1][0])})

# m1a_final = m1a_z_seqs + m1a_8s
# m2a_final = m2a_z_seqs + m2a_8s
# m1b_final = m1b_z_seqs + m1b_8s
# m2b_final = m2b_z_seqs + m2b_8s

# bg.to_csv(m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S8H/M1A.csv")
# bg.to_csv(m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S8H/M2A.csv")
# bg.to_csv(m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S8H/M1B.csv")
# bg.to_csv(m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S8H/M2B.csv")


# All Full Bonds

# full_s14 = bg.generate_sides("S14", count=4, number=4, overlap=0.5)
# full_s25 = bg.generate_sides("S25", count=4, number=4, overlap=0.5)
# full_s36 = bg.generate_sides("S36", count=4, number=4, overlap=0.5)



# hept_m1_8s = bg.sequence_generator({
#     "S1" => full_s14[3][0], "S4" => bg.complement_side(full_s14[1][0]), \
#     "S2" => full_s25[0][0], "S5" => bg.complement_side(full_s25[2][0]), \
#     "S3" => full_s36[0][0], "S6" => bg.complement_side(full_s36[2][0])
#     })

# hept_m2_8s = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[3][0]), "S5" => bg.complement_side(full_s25[3][0]), "S3" => full_s36[1][0]
# })

# hept_m3_8s = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[0][0]), "S5" => bg.complement_side(full_s25[0][0]), "S6" => bg.complement_side(full_s36[1][0])
# })

# hept_m4_8s = bg.sequence_generator({
#     "S1" => full_s14[0][0], "S5" => bg.complement_side(full_s25[1][0]), "S6" => bg.complement_side(full_s36[0][0])
# })

# hept_m5_8s = bg.sequence_generator({
#     "S1" => full_s14[1][0], "S2" => full_s25[1][0], "S6" => bg.complement_side(full_s36[3][0])
# })

# hept_m6_8s = bg.sequence_generator({
#     "S1" => full_s14[2][0], "S2" => full_s25[2][0], "S3" => full_s36[3][0]
# })

# hept_m7_8s = bg.sequence_generator({
#     "S4" => bg.complement_side(full_s14[2][0]), "S2" => full_s25[3][0], "S3" => full_s36[2][0]
# })

# bg.to_csv(["Sequence"] + hept_m1_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M1.csv")
# bg.to_csv(["Sequence"] + hept_m2_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M2.csv")
# bg.to_csv(["Sequence"] + hept_m3_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M3.csv")
# bg.to_csv(["Sequence"] + hept_m4_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M4.csv")
# bg.to_csv(["Sequence"] + hept_m5_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M5.csv")
# bg.to_csv(["Sequence"] + hept_m6_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M6.csv")
# bg.to_csv(["Sequence"] + hept_m7_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-8S-FULL/M7.csv")



# Skeleton 7M

# s14_8s = bg.generate_sides("S14", count=1, number=4, overlap=0.25)
# s14_6s2b = bg.generate_sides("S14", count=1, number=3, overlap=0.25)
# s14_4s4b = bg.generate_sides("S14", count=2, number=2, overlap=0.25)

# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0.25)


# hept_m1_skel = bg.sequence_generator({
#     "S1" => s14_6s2b[0][0], "S4" => bg.complement_side(s14_8s[0][0]), \
#     "S2" => s25_4s4b[0][0], "S5" => bg.complement_side(s25_4s4b[2][0]), \
#     "S3" => s36_4s4b[0][0], "S6" => bg.complement_side(s36_4s4b[2][0])
#     })

# hept_m2_skel = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_6s2b[0][0]), "S5" => bg.complement_side(s25_4s4b[3][0]), "S3" => s36_4s4b[1][0]
# })

# hept_m3_skel = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[0][0]), "S5" => bg.complement_side(s25_4s4b[0][0]), "S6" => bg.complement_side(s36_4s4b[1][0])
# })

# hept_m4_skel = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0], "S5" => bg.complement_side(s25_4s4b[1][0]), "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# hept_m5_skel = bg.sequence_generator({
#     "S1" => s14_8s[0][0], "S2" => s25_4s4b[1][0], "S6" => bg.complement_side(s36_4s4b[3][0])
# })

# hept_m6_skel = bg.sequence_generator({
#     "S1" => s14_4s4b[1][0], "S2" => s25_4s4b[2][0], "S3" => s36_4s4b[3][0]
# })

# hept_m7_skel = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[1][0]), "S2" => s25_4s4b[3][0], "S3" => s36_4s4b[2][0]
# })

# bg.to_csv(["Sequence"] + hept_m1_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M1.csv")
# bg.to_csv(["Sequence"] + hept_m2_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M2.csv")
# bg.to_csv(["Sequence"] + hept_m3_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M3.csv")
# bg.to_csv(["Sequence"] + hept_m4_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M4.csv")
# bg.to_csv(["Sequence"] + hept_m5_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M5.csv")
# bg.to_csv(["Sequence"] + hept_m6_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M6.csv")
# bg.to_csv(["Sequence"] + hept_m7_skel, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/7M-SKEL/M7.csv")


# 3M Variants

# s14_8s = bg.generate_sides("S14", count=1, number=4, overlap=0.25)

# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.5)
# s25_4s4b = bg.generate_sides("S25", count=1, number=2, overlap=0.5)
# s25_2s6b = bg.generate_sides("S25", count=1, number=1, overlap=0.5)

# s36_6s2b = bg.generate_sides("S36", count=1, number=3, overlap=0.5)
# s36_4s4b = bg.generate_sides("S36", count=1, number=2, overlap=0.5)
# s36_2s6b = bg.generate_sides("S36", count=1, number=1, overlap=0.5)

# # 6S2B

# tri_m1_6s2b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], "S2" => s25_6s2b[0][0]
# })

# tri_m2_6s2b = bg.sequence_generator({
#     "S3" => s36_6s2b[0][0], "S4" => bg.complement_side(s14_8s[0][0])
# })

# tri_m3_6s2b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_6s2b[0][0]), "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# # 4S4B

# tri_m1_4s4b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], "S2" => s25_4s4b[0][0]
# })

# tri_m2_4s4b = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0], "S4" => bg.complement_side(s14_8s[0][0])
# })

# tri_m3_4s4b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[0][0]), "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# # 2S6B

# tri_m1_2s6b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], "S2" => s25_2s6b[0][0]
# })

# tri_m2_2s6b = bg.sequence_generator({
#     "S3" => s36_2s6b[0][0], "S4" => bg.complement_side(s14_8s[0][0])
# })

# tri_m3_2s6b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_2s6b[0][0]), "S6" => bg.complement_side(s36_2s6b[0][0])
# })

# bg.to_csv(["Sequence"] + tri_m1_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M1_6S2B.csv")
# bg.to_csv(["Sequence"] + tri_m2_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M2_6S2B.csv")
# bg.to_csv(["Sequence"] + tri_m3_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M3_6S2B.csv")

# bg.to_csv(["Sequence"] + tri_m1_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M1_4S4B.csv")
# bg.to_csv(["Sequence"] + tri_m2_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M2_4S4B.csv")
# bg.to_csv(["Sequence"] + tri_m3_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M3_4S4B.csv")

# bg.to_csv(["Sequence"] + tri_m1_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M1_2S6B.csv")
# bg.to_csv(["Sequence"] + tri_m2_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M2_2S6B.csv")
# bg.to_csv(["Sequence"] + tri_m3_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M/M3_2S6B.csv")


# 4M Variants

# s14_8s = bg.generate_sides("S14", count=2, number=4, overlap=0.25)
# puts s14_8s.inspect
# s14_8s = [[["H61_L_P", "H61_R_P", "H60_R_P", "H60_L_P", "H57_R_P", "H56_R_S", "H57_L_S", "H56_L_S"], 101.4], [["H60_L_S", "H61_R_S", "H61_L_P", "H60_R_S", "H57_L_P", "H56_L_P", "H57_R_S", "H56_R_P"], 90.0]]

# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.5)
# s36_6s2b = bg.generate_sides("S36", count=2, number=3, overlap=0.5)

# s25_4s4b = bg.generate_sides("S25", count=1, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=2, number=2, overlap=0.25)

# s25_2s6b = bg.generate_sides("S25", count=1, number=1, overlap=0.5)
# s36_2s6b = bg.generate_sides("S36", count=2, number=1, overlap=0.5)

# # 6S2B

# tet_m1_6s2b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], 
#     "S2" => s25_6s2b[0][0],
#     "S3" => s36_6s2b[0][0],
# })

# tet_m2_6s2b = bg.sequence_generator({
#     "S3" => s36_6s2b[1][0], 
#     "S4" => bg.complement_side(s14_8s[0][0])
# })

# tet_m3_6s2b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# tet_m4_6s2b = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_6s2b[0][0]), 
#     "S6" => bg.complement_side(s36_6s2b[1][0])
# })


# # # 4s4b

# tet_m1_4s4b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], 
#     "S2" => s25_4s4b[0][0],
#     "S3" => s36_4s4b[0][0],
# })

# tet_m2_4s4b = bg.sequence_generator({
#     "S3" => s36_4s4b[1][0], 
#     "S4" => bg.complement_side(s14_8s[0][0])
# })

# tet_m3_4s4b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# tet_m4_4s4b = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_4s4b[0][0]), 
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })


# # # 2s6b

# tet_m1_2s6b = bg.sequence_generator({
#     "S1" => s14_8s[0][0], 
#     "S2" => s25_2s6b[0][0],
#     "S3" => s36_2s6b[0][0],
# })

# tet_m2_2s6b = bg.sequence_generator({
#     "S3" => s36_2s6b[1][0], 
#     "S4" => bg.complement_side(s14_8s[0][0])
# })

# tet_m3_2s6b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S6" => bg.complement_side(s36_2s6b[0][0])
# })

# tet_m4_2s6b = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_2s6b[0][0]), 
#     "S6" => bg.complement_side(s36_2s6b[1][0])
# })


# bg.to_csv(["Sequence"] + tet_m1_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M1_6S2B.csv")
# bg.to_csv(["Sequence"] + tet_m2_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M2_6S2B.csv")
# bg.to_csv(["Sequence"] + tet_m3_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M3_6S2B.csv")
# bg.to_csv(["Sequence"] + tet_m4_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M4_6S2B.csv")


# bg.to_csv(["Sequence"] + tet_m1_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M1_4S4B.csv")
# bg.to_csv(["Sequence"] + tet_m2_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M2_4S4B.csv")
# bg.to_csv(["Sequence"] + tet_m3_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M3_4S4B.csv")
# bg.to_csv(["Sequence"] + tet_m4_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M4_4S4B.csv")


# bg.to_csv(["Sequence"] + tet_m1_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M1_2S6B.csv")
# bg.to_csv(["Sequence"] + tet_m2_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M2_2S6B.csv")
# bg.to_csv(["Sequence"] + tet_m3_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M3_2S6B.csv")
# bg.to_csv(["Sequence"] + tet_m4_2s6b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M/M4_2S6B.csv")


# z_6h_tail_bonds = bg.z_bond_sampler(3, 2, "TAIL", 0.5)
# z_6h_head_bonds = bg.z_bond_sampler(3, 2, "HEAD", 0.5)
# # puts z_6h_tail_bonds[0].size z_6h_head_bonds.size

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])

# m1a_8s = bg.sequence_generator({"S1" => s14_8s[0][0]})
# m2a_8s = bg.sequence_generator({"S4" => bg.complement_side(s14_8s[0][0])})
# m1b_8s = bg.sequence_generator({"S1" => s14_8s[1][0]})
# m2b_8s = bg.sequence_generator({"S4" => bg.complement_side(s14_8s[1][0])})

# m1a_final = m1a_z_seqs + m1a_8s
# m2a_final = m2a_z_seqs + m2a_8s
# m1b_final = m1b_z_seqs + m1b_8s
# m2b_final = m2b_z_seqs + m2b_8s

# bg.to_csv(m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S6H/M1A.csv")
# bg.to_csv(m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S6H/M2A.csv")
# bg.to_csv(m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S6H/M1B.csv")
# bg.to_csv(m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2M-8S6H/M2B.csv")


# 6M Variants

# s14_8s = bg.generate_sides("S14", count=1, number=4, overlap=0.25)
# s25_8s = bg.generate_sides("S25", count=1, number=4, overlap=0.25)
# s36_8s = bg.generate_sides("S36", count=1, number=4, overlap=0.25)

# s14_6s2b = bg.generate_sides("S14", count=1, number=3, overlap=0.25)
# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.25)
# s36_6s2b = bg.generate_sides("S36", count=1, number=3, overlap=0.25)

# s14_4s4b = bg.generate_sides("S14", count=1, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=1, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=1, number=2, overlap=0.25)

# hex_m1_6s2b = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S3" => s36_6s2b[0][0]
# })

# hex_m2_6s2b = bg.sequence_generator({
#     "S2" => s25_6s2b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0])
# })

# hex_m3_6s2b = bg.sequence_generator({
#     "S3" => s36_8s[0][0],
#     "S5" => bg.complement_side(s25_6s2b[0][0]) 
# })

# hex_m4_6s2b = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_6s2b[0][0]),
#     "S6" => bg.complement_side(s36_8s[0][0])
# })

# hex_m5_6s2b = bg.sequence_generator({
#     "S1" => s14_6s2b[0][0],
#     "S5" => bg.complement_side(s25_8s[0][0])
# })

# hex_m6_6s2b = bg.sequence_generator({
#     "S2" => s25_8s[0][0],
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# # 4S4B

# hex_m1_4s4b = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S3" => s36_4s4b[0][0]
# })

# hex_m2_4s4b = bg.sequence_generator({
#     "S2" => s25_4s4b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0])
# })

# hex_m3_4s4b = bg.sequence_generator({
#     "S3" => s36_8s[0][0],
#     "S5" => bg.complement_side(s25_4s4b[0][0]) 
# })

# hex_m4_4s4b = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_8s[0][0])
# })

# hex_m5_4s4b = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S5" => bg.complement_side(s25_8s[0][0])
# })

# hex_m6_4s4b = bg.sequence_generator({
#     "S2" => s25_8s[0][0],
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# bg.to_csv(["Sequence"] + hex_m1_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M1_6S2B.csv")
# bg.to_csv(["Sequence"] + hex_m2_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M2_6S2B.csv")
# bg.to_csv(["Sequence"] + hex_m3_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M3_6S2B.csv")
# bg.to_csv(["Sequence"] + hex_m4_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M4_6S2B.csv")
# bg.to_csv(["Sequence"] + hex_m5_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M5_6S2B.csv")
# bg.to_csv(["Sequence"] + hex_m6_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M6_6S2B.csv")

# bg.to_csv(["Sequence"] + hex_m1_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M1_4S4B.csv")
# bg.to_csv(["Sequence"] + hex_m2_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M2_4S4B.csv")
# bg.to_csv(["Sequence"] + hex_m3_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M3_4S4B.csv")
# bg.to_csv(["Sequence"] + hex_m4_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M4_4S4B.csv")
# bg.to_csv(["Sequence"] + hex_m5_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M5_4S4B.csv")
# bg.to_csv(["Sequence"] + hex_m6_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6M/M6_4S4B.csv")


# # XY Bonds
# s14_8s = bg.generate_sides("S14", count=2, number=4, overlap=0.25)

# s25_4s4b = bg.generate_sides("S25", count=2, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=2, number=2, overlap=0.25)

# m1a_8s = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_4s4b[0][0]    
# })
# m2a_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0])
# })
# m3a_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# m1b_8s = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_4s4b[1][0]    
# })
# m2b_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0])
# })
# m3b_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[1][0]),
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })


# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 3, "TAIL", 0.34)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# m1a_final = m1a_z_seqs + m1a_8s
# m2a_final = m2a_z_seqs + m2a_8s
# m3a_final = m3a_z_seqs + m3a_8s

# m1b_final = m1b_z_seqs + m1b_8s
# m2b_final = m2b_z_seqs + m2b_8s
# m3b_final = m3b_z_seqs + m3b_8s

# bg.to_csv(["Sequence"] + m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M1A.csv")
# bg.to_csv(["Sequence"] + m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M2A.csv")
# bg.to_csv(["Sequence"] + m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M3A.csv")

# bg.to_csv(["Sequence"] + m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M1B.csv")
# bg.to_csv(["Sequence"] + m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M2B.csv")
# bg.to_csv(["Sequence"] + m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M-6H/M3B.csv")

### Making a 4x3M = 12 components

# XY Bonds
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0.5)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0.5)

# m1a_8s = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_4s4b[0][0]    
# })
# m2a_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0])
# })
# m3a_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# m1b_8s = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_4s4b[1][0]    
# })
# m2b_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0])
# })
# m3b_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[1][0]),
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })

# m1c_8s = bg.sequence_generator({
#     "S1" => s14_8s[2][0],
#     "S2" => s25_4s4b[2][0]    
# })
# m2c_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[2][0],
#     "S4" => bg.complement_side(s14_8s[2][0])
# })
# m3c_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[2][0]),
#     "S6" => bg.complement_side(s36_4s4b[2][0])
# })

# m1d_8s = bg.sequence_generator({
#     "S1" => s14_8s[3][0],
#     "S2" => s25_4s4b[3][0]    
# })
# m2d_8s = bg.sequence_generator({
#     "S3" => s36_4s4b[3][0],
#     "S4" => bg.complement_side(s14_8s[3][0])
# })
# m3d_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[3][0]),
#     "S6" => bg.complement_side(s36_4s4b[3][0])
# })


# z_6h_tail_bonds = bg.z_bond_sampler(3, 9, "TAIL", 0.67)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[0])
# m2b_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[1])
# m3b_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[2])

# m1c_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[6]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[3])
# m2c_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[7]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[4])
# m3c_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[8]) + bg.add_z_bonds("HEAD", z_6h_head_bonds[5])

# m1d_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[6]) + bg.add_z_bonds("TAIL", [])
# m2d_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[7]) + bg.add_z_bonds("TAIL", [])
# m3d_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[8]) + bg.add_z_bonds("TAIL", [])


# m1a_final = m1a_z_seqs + m1a_8s
# m2a_final = m2a_z_seqs + m2a_8s
# m3a_final = m3a_z_seqs + m3a_8s

# m1b_final = m1b_z_seqs + m1b_8s
# m2b_final = m2b_z_seqs + m2b_8s
# m3b_final = m3b_z_seqs + m3b_8s

# m1c_final = m1c_z_seqs + m1c_8s
# m2c_final = m2c_z_seqs + m2c_8s
# m3c_final = m3c_z_seqs + m3c_8s

# m1d_final = m1d_z_seqs + m1d_8s
# m2d_final = m2d_z_seqs + m2d_8s
# m3d_final = m3d_z_seqs + m3d_8s

# bg.to_csv(["Sequence"] + m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M1A.csv")
# bg.to_csv(["Sequence"] + m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M2A.csv")
# bg.to_csv(["Sequence"] + m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M3A.csv")

# bg.to_csv(["Sequence"] + m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M1B.csv")
# bg.to_csv(["Sequence"] + m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M2B.csv")
# bg.to_csv(["Sequence"] + m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M3B.csv")

# bg.to_csv(["Sequence"] + m1c_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M1C.csv")
# bg.to_csv(["Sequence"] + m2c_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M2C.csv")
# bg.to_csv(["Sequence"] + m3c_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M3C.csv")

# bg.to_csv(["Sequence"] + m1d_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M1D.csv")
# bg.to_csv(["Sequence"] + m2d_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M2D.csv")
# bg.to_csv(["Sequence"] + m3d_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4x3M-6H/M3D.csv")



# 6MX Bonds


# s14_8s = bg.generate_sides("S14", count=1, number=4, overlap=0.25)

# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.25)
# s36_6s2b = bg.generate_sides("S36", count=1, number=3, overlap=0.25)

# s14_4s4b = bg.generate_sides("S14", count=2, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=2, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=2, number=2, overlap=0.25)


# m1_6mx = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_6s2b[0][0],    
#     "S3" => s36_4s4b[0][0],
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })

# m2_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[0][0],
#     "S3" => s36_6s2b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0]),
#     "S5" => bg.complement_side(s25_4s4b[1][0])
# })
# m3_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S4" => bg.complement_side(s14_4s4b[1][0]),
#     "S5" => bg.complement_side(s25_6s2b[0][0]),
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# m4_6mx = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[0][0]),
#     "S5" => bg.complement_side(s25_4s4b[0][0])
# })

# m5_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[1][0],
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# m6_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[1][0],
#     "S3" => s36_4s4b[1][0]
# })


# bg.to_csv(["Sequence"] + m1_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M1.csv")
# bg.to_csv(["Sequence"] + m2_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M2.csv")
# bg.to_csv(["Sequence"] + m3_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M3.csv")

# bg.to_csv(["Sequence"] + m4_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M4.csv")
# bg.to_csv(["Sequence"] + m5_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M5.csv")
# bg.to_csv(["Sequence"] + m6_6mx, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/6MX/M6.csv")



# # 2x3M + 2x3M (4S4B + 4S4B)
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_4s4b = bg.generate_sides("S25", count=8, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)

# s25_4s4b_core = s25_4s4b[0, 4]
# s25_4s4b_sides = s25_4s4b[4, 8]

# s36_4s4b_core = s36_4s4b[0, 4]
# s36_4s4b_sides = s36_4s4b[4, 6]


# ### T1 ###

# #### Bottom Layer ####

# t1_m1a = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_4s4b_sides[0][0],
#     "S6" => bg.complement_side(s36_4s4b_core[0][0])
# })
# t1_m2a = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[1][0],
#     "S3" => s36_4s4b_sides[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0]),
#     "S5" => bg.complement_side(s25_4s4b_core[0][0])
# })

# t1_m3a = bg.sequence_generator({
#     "S2" => s25_4s4b_core[0][0],
#     "S3" => s36_4s4b_core[0][0]
# })

# #### Top Layer ####

# t1_m1b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_4s4b_sides[2][0],
#     "S6" => bg.complement_side(s36_4s4b_core[1][0])
# })
# t1_m2b = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[3][0],
#     "S3" => s36_4s4b_sides[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_4s4b_core[1][0])
# })

# t1_m3b = bg.sequence_generator({
#     "S2" => s25_4s4b_core[1][0],
#     "S3" => s36_4s4b_core[1][0]
# })

# ### T2 ###

# t2_m1a = bg.sequence_generator({
#     "S1" => s14_8s[2][0],
#     "S2" => s25_4s4b_core[2][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[0][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[0][0])
# })
# t2_m2a = bg.sequence_generator({
#     "S3" => s36_4s4b_core[2][0],
#     "S4" => bg.complement_side(s14_8s[2][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[1][0])
# })

# t2_m3a = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b_core[2][0]),
#     "S6" => bg.complement_side(s36_4s4b_core[2][0])
# })

# #### Top Layer ####

# t2_m1b = bg.sequence_generator({
#     "S1" => s14_8s[3][0],
#     "S2" => s25_4s4b_core[3][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[2][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[1][0])
# })
# t2_m2b = bg.sequence_generator({
#     "S3" => s36_4s4b_core[3][0],
#     "S4" => bg.complement_side(s14_8s[3][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[3][0])
# })

# t2_m3b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b_core[3][0]),
#     "S6" => bg.complement_side(s36_4s4b_core[3][0])
# })

# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 6, "TAIL", 0.67)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])

# t1_m1a_final = t1_m1a_z_seqs + t1_m1a
# t1_m2a_final = t1_m2a_z_seqs + t1_m2a
# t1_m3a_final = t1_m3a_z_seqs + t1_m3a

# t1_m1b_final = t1_m1b_z_seqs + t1_m1b
# t1_m2b_final = t1_m2b_z_seqs + t1_m2b
# t1_m3b_final = t1_m3b_z_seqs + t1_m3b

# t2_m1a_final = t2_m1a_z_seqs + t2_m1a
# t2_m2a_final = t2_m2a_z_seqs + t2_m2a
# t2_m3a_final = t2_m3a_z_seqs + t2_m3a

# t2_m1b_final = t2_m1b_z_seqs + t2_m1b
# t2_m2b_final = t2_m2b_z_seqs + t2_m2b
# t2_m3b_final = t2_m3b_z_seqs + t2_m3b


# bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M1A.csv")
# bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M2A.csv")
# bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M3A.csv")

# bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M1B.csv")
# bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M2B.csv")
# bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T1_M3B.csv")

# bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M1A.csv")
# bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M2A.csv")
# bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M3A.csv")

# bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M1B.csv")
# bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M2B.csv")
# bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B/T2_M3B.csv")


# # 2x3M + 2x3M (4S4B + 6S2B)
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_6s2b_core = bg.generate_sides("S25", count=4, number=3, overlap=0.5)
# s25_4s4b_sides = bg.generate_sides("S25", count=4, number=2, overlap=0.25)

# s36_6s2b_core = bg.generate_sides("S36", count=4, number=3, overlap=0.5)
# s36_4s4b_sides = bg.generate_sides("S36", count=4, number=2, overlap=0.25)

# ### T1 ###

# #### Bottom Layer ####

# t1_m1a = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_4s4b_sides[0][0],
#     "S6" => bg.complement_side(s36_6s2b_core[0][0])
# })
# t1_m2a = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[1][0],
#     "S3" => s36_4s4b_sides[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0]),
#     "S5" => bg.complement_side(s25_6s2b_core[0][0])
# })

# t1_m3a = bg.sequence_generator({
#     "S2" => s25_6s2b_core[0][0],
#     "S3" => s36_6s2b_core[0][0]
# })

# #### Top Layer ####

# t1_m1b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_4s4b_sides[2][0],
#     "S6" => bg.complement_side(s36_6s2b_core[1][0])
# })
# t1_m2b = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[3][0],
#     "S3" => s36_4s4b_sides[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_6s2b_core[1][0])
# })

# t1_m3b = bg.sequence_generator({
#     "S2" => s25_6s2b_core[1][0],
#     "S3" => s36_6s2b_core[1][0]
# })

# ### T2 ###

# t2_m1a = bg.sequence_generator({
#     "S1" => s14_8s[2][0],
#     "S2" => s25_6s2b_core[2][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[0][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[0][0])
# })
# t2_m2a = bg.sequence_generator({
#     "S3" => s36_6s2b_core[2][0],
#     "S4" => bg.complement_side(s14_8s[2][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[1][0])
# })

# t2_m3a = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_6s2b_core[2][0]),
#     "S6" => bg.complement_side(s36_6s2b_core[2][0])
# })

# #### Top Layer ####

# t2_m1b = bg.sequence_generator({
#     "S1" => s14_8s[3][0],
#     "S2" => s25_6s2b_core[3][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[2][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[1][0])
# })
# t2_m2b = bg.sequence_generator({
#     "S3" => s36_6s2b_core[3][0],
#     "S4" => bg.complement_side(s14_8s[3][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[3][0])
# })

# t2_m3b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_6s2b_core[3][0]),
#     "S6" => bg.complement_side(s36_6s2b_core[3][0])
# })

# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 6, "TAIL", 0.67)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])

# t1_m1a_final = t1_m1a_z_seqs + t1_m1a
# t1_m2a_final = t1_m2a_z_seqs + t1_m2a
# t1_m3a_final = t1_m3a_z_seqs + t1_m3a

# t1_m1b_final = t1_m1b_z_seqs + t1_m1b
# t1_m2b_final = t1_m2b_z_seqs + t1_m2b
# t1_m3b_final = t1_m3b_z_seqs + t1_m3b

# t2_m1a_final = t2_m1a_z_seqs + t2_m1a
# t2_m2a_final = t2_m2a_z_seqs + t2_m2a
# t2_m3a_final = t2_m3a_z_seqs + t2_m3a

# t2_m1b_final = t2_m1b_z_seqs + t2_m1b
# t2_m2b_final = t2_m2b_z_seqs + t2_m2b
# t2_m3b_final = t2_m3b_z_seqs + t2_m3b


# bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M1A.csv")
# bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M2A.csv")
# bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M3A.csv")

# bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M1B.csv")
# bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M2B.csv")
# bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T1_M3B.csv")

# bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M1A.csv")
# bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M2A.csv")
# bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M3A.csv")

# bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M1B.csv")
# bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M2B.csv")
# bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3M+2x3M-4S4B+/T2_M3B.csv")



# 6MX Bonds


# s14_8s = bg.generate_sides("S14", count=2, number=4, overlap=0.25)

# s25_6s2b = bg.generate_sides("S25", count=2, number=3, overlap=0.25)
# s36_6s2b = bg.generate_sides("S36", count=2, number=3, overlap=0.25)

# s14_4s4b = bg.generate_sides("S14", count=4, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0.25)


# t1_m1_6mx = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_6s2b[0][0],    
#     "S3" => s36_4s4b[0][0],
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })

# t1_m2_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[0][0],
#     "S3" => s36_6s2b[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0]),
#     "S5" => bg.complement_side(s25_4s4b[1][0])
# })

# t1_m3_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S4" => bg.complement_side(s14_4s4b[1][0]),
#     "S5" => bg.complement_side(s25_6s2b[0][0]),
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# t1_m4_6mx = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[0][0]),
#     "S5" => bg.complement_side(s25_4s4b[0][0])
# })

# t1_m5_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[1][0],
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# t1_m6_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[1][0],
#     "S3" => s36_4s4b[1][0]
# })

# # Top layer

# t2_m1_6mx = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_6s2b[1][0],    
#     "S3" => s36_4s4b[2][0],
#     "S6" => bg.complement_side(s36_4s4b[3][0])
# })

# t2_m2_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[2][0],
#     "S3" => s36_6s2b[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_4s4b[3][0])
# })

# t2_m3_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[2][0],
#     "S4" => bg.complement_side(s14_4s4b[3][0]),
#     "S5" => bg.complement_side(s25_6s2b[1][0]),
#     "S6" => bg.complement_side(s36_6s2b[1][0])
# })

# t2_m4_6mx = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[2][0]),
#     "S5" => bg.complement_side(s25_4s4b[2][0])
# })

# t2_m5_6mx = bg.sequence_generator({
#     "S1" => s14_4s4b[3][0],
#     "S6" => bg.complement_side(s36_4s4b[2][0])
# })

# t2_m6_6mx = bg.sequence_generator({
#     "S2" => s25_4s4b[3][0],
#     "S3" => s36_4s4b[3][0]
# })




# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 3, "TAIL", 0.34)
# puts z_6h_tail_bonds.inspect
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m4_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# t1_m5_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# t1_m6_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# t2_m1_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t2_m2_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t2_m3_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])

# t2_m4_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# t2_m5_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# t2_m6_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])

# t1_m1_final = t1_m1_z_seqs + t1_m1_6mx
# t1_m2_final = t1_m2_z_seqs + t1_m2_6mx
# t1_m3_final = t1_m3_z_seqs + t1_m3_6mx

# t1_m4_final = t1_m4_z_seqs + t1_m4_6mx
# t1_m5_final = t1_m5_z_seqs + t1_m5_6mx
# t1_m6_final = t1_m6_z_seqs + t1_m6_6mx

# t2_m1_final = t2_m1_z_seqs + t2_m1_6mx
# t2_m2_final = t2_m2_z_seqs + t2_m2_6mx
# t2_m3_final = t2_m3_z_seqs + t2_m3_6mx

# t2_m4_final = t2_m4_z_seqs + t2_m4_6mx
# t2_m5_final = t2_m5_z_seqs + t2_m5_6mx
# t2_m6_final = t2_m6_z_seqs + t2_m6_6mx



# bg.to_csv(["Sequence"] + t1_m1_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M1.csv")
# bg.to_csv(["Sequence"] + t1_m2_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M2.csv")
# bg.to_csv(["Sequence"] + t1_m3_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M3.csv")

# bg.to_csv(["Sequence"] + t1_m4_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M4.csv")
# bg.to_csv(["Sequence"] + t1_m5_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M5.csv")
# bg.to_csv(["Sequence"] + t1_m6_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T1_M6.csv")

# bg.to_csv(["Sequence"] + t2_m1_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M1.csv")
# bg.to_csv(["Sequence"] + t2_m2_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M2.csv")
# bg.to_csv(["Sequence"] + t2_m3_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M3.csv")

# bg.to_csv(["Sequence"] + t2_m4_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M4.csv")
# bg.to_csv(["Sequence"] + t2_m5_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M5.csv")
# bg.to_csv(["Sequence"] + t2_m6_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x6MX/T2_M6.csv")


# s14_6s2b = bg.generate_sides("S14", count=15, number=2, overlap=0.5)
# puts s14_6s2b.inspect
# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.25)
# s36_6s2b = bg.generate_sides("S36", count=1, number=3, overlap=0.25)

# s14_4s4b = bg.generate_sides("S14", count=1, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=1, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=1, number=2, overlap=0.25)


# t3_6s2b_m1 = bg.sequence_generator({
#     "S1" => s14_6s2b[0][0],
#     "S2" => s25_6s2b[0][0],    
# })

# t3_6s2b_m2 = bg.sequence_generator({
#     "S3" => s36_6s2b[0][0],
#     "S4" => bg.complement_side(s14_6s2b[0][0]),
# })

# t3_6s2b_m3 = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_6s2b[0][0]),
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })


# t3_4s4b_m1 = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S2" => s25_4s4b[0][0],    
# })

# t3_4s4b_m2 = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0],
#     "S4" => bg.complement_side(s14_4s4b[0][0]),
# })

# t3_4s4b_m3 = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# bg.to_csv(["Sequence"] + t3_6s2b_m1, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M1_6S2B.csv")
# bg.to_csv(["Sequence"] + t3_6s2b_m2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M2_6S2B.csv")
# bg.to_csv(["Sequence"] + t3_6s2b_m3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M3_6S2B.csv")

# bg.to_csv(["Sequence"] + t3_4s4b_m1, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M1_4S4B.csv")
# bg.to_csv(["Sequence"] + t3_4s4b_m2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M2_4S4B.csv")
# bg.to_csv(["Sequence"] + t3_4s4b_m3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-MISC/M3_4S4B.csv")


# 2x3M + 2x3M (4S4B + 4S4B) (hierarchical)
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_4s4b = bg.generate_sides("S25", count=8, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)

# s25_4s4b_core = s25_4s4b[0, 4]
# s25_4s4b_sides = s25_4s4b[4, 8]

# s36_4s4b_core = s36_4s4b[0, 4]
# s36_4s4b_sides = s36_4s4b[4, 6]


# ### T1 ###

# #### Bottom Layer ####

# t1_m1a = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_4s4b_sides[0][0],
#     "S6" => bg.complement_side(s36_4s4b_core[0][0])
# })
# t1_m2a = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[1][0],
#     "S3" => s36_4s4b_sides[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0]),
#     "S5" => bg.complement_side(s25_4s4b_core[0][0])
# })

# t1_m3a = bg.sequence_generator({
#     "S2" => s25_4s4b_core[0][0],
#     "S3" => s36_4s4b_core[0][0]
# })

# #### Top Layer ####

# t1_m1b = bg.sequence_generator({
#     "S1" => s14_8s[1][0],
#     "S2" => s25_4s4b_sides[2][0],
#     "S6" => bg.complement_side(s36_4s4b_core[1][0])
# })
# t1_m2b = bg.sequence_generator({
#     "S2" => s25_4s4b_sides[3][0],
#     "S3" => s36_4s4b_sides[1][0],
#     "S4" => bg.complement_side(s14_8s[1][0]),
#     "S5" => bg.complement_side(s25_4s4b_core[1][0])
# })

# t1_m3b = bg.sequence_generator({
#     "S2" => s25_4s4b_core[1][0],
#     "S3" => s36_4s4b_core[1][0]
# })

# ### T2 ###

# #### Bottom Layer ####

# t2_m1a = bg.sequence_generator({
#     "S1" => s14_8s[2][0],
#     "S2" => s25_4s4b_core[2][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[0][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[0][0])
# })
# t2_m2a = bg.sequence_generator({
#     "S3" => s36_4s4b_core[2][0],
#     "S4" => bg.complement_side(s14_8s[2][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[1][0])
# })

# t2_m3a = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b_core[2][0]),
#     "S6" => bg.complement_side(s36_4s4b_core[2][0])
# })

# #### Top Layer ####

# t2_m1b = bg.sequence_generator({
#     "S1" => s14_8s[3][0],
#     "S2" => s25_4s4b_core[3][0],
#     "S5" => bg.complement_side(s25_4s4b_sides[2][0]),
#     "S6" => bg.complement_side(s36_4s4b_sides[1][0])
# })
# t2_m2b = bg.sequence_generator({
#     "S3" => s36_4s4b_core[3][0],
#     "S4" => bg.complement_side(s14_8s[3][0]),
#     "S5" => bg.complement_side(s25_4s4b_sides[3][0])
# })

# t2_m3b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b_core[3][0]),
#     "S6" => bg.complement_side(s36_4s4b_core[3][0])
# })

# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 3, "TAIL", 0.34)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])

# t1_m1a_final = t1_m1a_z_seqs + t1_m1a
# t1_m2a_final = t1_m2a_z_seqs + t1_m2a
# t1_m3a_final = t1_m3a_z_seqs + t1_m3a

# t1_m1b_final = t1_m1b_z_seqs + t1_m1b
# t1_m2b_final = t1_m2b_z_seqs + t1_m2b
# t1_m3b_final = t1_m3b_z_seqs + t1_m3b

# t2_m1a_final = t2_m1a_z_seqs + t2_m1a
# t2_m2a_final = t2_m2a_z_seqs + t2_m2a
# t2_m3a_final = t2_m3a_z_seqs + t2_m3a

# t2_m1b_final = t2_m1b_z_seqs + t2_m1b
# t2_m2b_final = t2_m2b_z_seqs + t2_m2b
# t2_m3b_final = t2_m3b_z_seqs + t2_m3b


# bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M1A.csv")
# bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M2A.csv")
# bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M3A.csv")

# bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M1B.csv")
# bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M2B.csv")
# bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T1_M3B.csv")

# bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M1A.csv")
# bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M2A.csv")
# bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M3A.csv")

# bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M1B.csv")
# bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M2B.csv")
# bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/hierarch/2x3M+2x3M-4S4B/T2_M3B.csv")


# 3M Re-studied
# s14_8s = bg.generate_sides("S14", count=1, number=4, overlap=0.25)
# s25_8s = bg.generate_sides("S25", count=1, number=4, overlap=0.25)
# s36_8s = bg.generate_sides("S36", count=1, number=4, overlap=0.25)

# m1_8s = bg.sequence_generator({
#     "S1" => s14_8s[0][0],
#     "S2" => s25_8s[0][0]    
# })
# m2_8s = bg.sequence_generator({
#     "S3" => s36_8s[0][0],
#     "S4" => bg.complement_side(s14_8s[0][0])
# })
# m3_8s = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_8s[0][0]),
#     "S6" => bg.complement_side(s36_8s[0][0])
# })

# s14_6s2b = bg.generate_sides("S14", count=1, number=3, overlap=0.25)
# s25_6s2b = bg.generate_sides("S25", count=1, number=3, overlap=0.25)
# s36_6s2b = bg.generate_sides("S36", count=1, number=3, overlap=0.25)

# m1_6s2b = bg.sequence_generator({
#     "S1" => s14_6s2b[0][0],
#     "S2" => s25_6s2b[0][0]    
# })
# m2_6s2b = bg.sequence_generator({
#     "S3" => s36_6s2b[0][0],
#     "S4" => bg.complement_side(s14_6s2b[0][0])
# })
# m3_6s2b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_6s2b[0][0]),
#     "S6" => bg.complement_side(s36_6s2b[0][0])
# })

# s14_4s4b = bg.generate_sides("S14", count=1, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=1, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=1, number=2, overlap=0.25)

# m1_4s4b = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S2" => s25_4s4b[0][0]    
# })
# m2_4s4b = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0],
#     "S4" => bg.complement_side(s14_4s4b[0][0])
# })
# m3_4s4b = bg.sequence_generator({
#     "S5" => bg.complement_side(s25_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# bg.to_csv(["Sequence"] + m1_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M1_8S.csv")
# bg.to_csv(["Sequence"] + m2_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M2_8S.csv")
# bg.to_csv(["Sequence"] + m3_8s, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M3_8S.csv")

# bg.to_csv(["Sequence"] + m1_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M1_6S2B.csv")
# bg.to_csv(["Sequence"] + m2_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M2_6S2B.csv")
# bg.to_csv(["Sequence"] + m3_6s2b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M3_6S2B.csv")

# bg.to_csv(["Sequence"] + m1_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M1_4S4B.csv")
# bg.to_csv(["Sequence"] + m2_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M2_4S4B.csv")
# bg.to_csv(["Sequence"] + m3_4s4b, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3M-NEW/M3_4S4B.csv")


# 10M CORE
# s14_4s4b = bg.generate_sides("S14", count=6, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=6, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)

# s36_8s = bg.generate_sides("S36", count=1, number=4, overlap=0.25)

# m1_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[0][0],
#     "S2" => s25_4s4b[0][0],
#     "S3" => s36_8s[0][0],
#     "S4" => bg.complement_side(s14_4s4b[4][0]),
#     "S5" => bg.complement_side(s25_4s4b[4][0]),
#     "S6" => bg.complement_side(s36_4s4b[5][0])
# })

# m2_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[1][0],
#     "S2" => s25_4s4b[1][0],
#     "S3" => s36_4s4b[2][0],
#     "S4" => bg.complement_side(s14_4s4b[3][0]),
#     "S5" => bg.complement_side(s25_4s4b[3][0]),
#     "S6" => bg.complement_side(s36_8s[0][0])
# })

# m3_10M = bg.sequence_generator({
#     "S3" => s36_4s4b[0][0],
#     "S4" => bg.complement_side(s14_4s4b[0][0]),
#     "S5" => bg.complement_side(s25_4s4b[5][0])
# })

# m4_10M = bg.sequence_generator({
#     "S3" => s36_4s4b[1][0],
#     "S4" => bg.complement_side(s14_4s4b[1][0]),
#     "S5" => bg.complement_side(s25_4s4b[0][0]),
#     "S6" => bg.complement_side(s36_4s4b[0][0])
# })

# m5_10M = bg.sequence_generator({
#     "S4" => bg.complement_side(s14_4s4b[2][0]),
#     "S5" => bg.complement_side(s25_4s4b[1][0]),
#     "S6" => bg.complement_side(s36_4s4b[1][0])
# })

# m6_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[2][0],
#     "S5" => bg.complement_side(s25_4s4b[2][0]),
#     "S6" => bg.complement_side(s36_4s4b[2][0])
# })

# m7_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[3][0],
#     "S2" => s25_4s4b[2][0],
#     "S6" => bg.complement_side(s36_4s4b[3][0])
# })

# m8_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[4][0],
#     "S2" => s25_4s4b[3][0],
#     "S3" => s36_4s4b[3][0],
#     "S6" => bg.complement_side(s36_4s4b[4][0])
# })

# m9_10M = bg.sequence_generator({
#     "S1" => s14_4s4b[5][0],
#     "S2" => s25_4s4b[4][0],
#     "S3" => s36_4s4b[4][0],
# })

# m10_10M = bg.sequence_generator({
#     "S2" => s25_4s4b[5][0],
#     "S3" => s36_4s4b[5][0],
#     "S4" => bg.complement_side(s14_4s4b[5][0]),
# })


# bg.to_csv(["Sequence"] + m1_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M1.csv")
# bg.to_csv(["Sequence"] + m2_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M2.csv")
# bg.to_csv(["Sequence"] + m3_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M3.csv")
# bg.to_csv(["Sequence"] + m4_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M4.csv")
# bg.to_csv(["Sequence"] + m5_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M5.csv")

# bg.to_csv(["Sequence"] + m6_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M6.csv")
# bg.to_csv(["Sequence"] + m7_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M7.csv")
# bg.to_csv(["Sequence"] + m8_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M8.csv")
# bg.to_csv(["Sequence"] + m9_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M9.csv")
# bg.to_csv(["Sequence"] + m10_10M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/10M/M10.csv")


# 2x3M + 2x3M (4S4B + 2S6B) (hierarchical) (fhcjk)
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_4s4b_core = bg.generate_sides("S25", count=4, number=2, overlap=0.25)
# s25_2s6b_sides = bg.generate_sides("S25", count=4, number=1, overlap=0.25)

# s36_4s4b_core = bg.generate_sides("S36", count=4, number=2, overlap=0.25)
# s36_2s6b_sides = bg.generate_sides("S36", count=4, number=1, overlap=0.25)

# ### T1 ###

# #### Bottom Layer ####

# t1_m1a = bg.sequence_generator({
#     "S1" => [s14_8s[0][0], "BS"],
#     "S2" => [s25_2s6b_sides[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[0][0]), "BS"]
# })
# t1_m2a = bg.sequence_generator({
#     "S2" => [s25_2s6b_sides[1][0], "BS"],
#     "S3" => [s36_2s6b_sides[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_core[0][0]), "BS"]
# })

# t1_m3a = bg.sequence_generator({
#     "S2" => [s25_4s4b_core[0][0], "BS"],
#     "S3" => [s36_4s4b_core[0][0], "BS"]
# })

# #### Top Layer ####

# t1_m1b = bg.sequence_generator({
#     "S1" => [s14_8s[1][0], "BS"],
#     "S2" => [s25_2s6b_sides[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[1][0]), "BS"]
# })
# t1_m2b = bg.sequence_generator({
#     "S2" => [s25_2s6b_sides[3][0], "BS"],
#     "S3" => [s36_2s6b_sides[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_core[1][0]), "BS"]
# })

# t1_m3b = bg.sequence_generator({
#     "S2" => [s25_4s4b_core[1][0], "BS"],
#     "S3" => [s36_4s4b_core[1][0], "BS"]
# })

# ### T2 ###

# t2_m1a = bg.sequence_generator({
#     "S1" => [s14_8s[2][0], "BS"],
#     "S2" => [s25_4s4b_core[2][0], "BS"],
#     "S5" => [bg.complement_side(s25_2s6b_sides[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_2s6b_sides[0][0]), "BS"]
# })
# t2_m2a = bg.sequence_generator({
#     "S3" => [s36_4s4b_core[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_2s6b_sides[1][0]), "BS"]
# })

# t2_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b_core[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[2][0]), "BS"]
# })

# #### Top Layer ####

# t2_m1b = bg.sequence_generator({
#     "S1" => [s14_8s[3][0], "BS"],
#     "S2" => [s25_4s4b_core[3][0], "BS"],
#     "S5" => [bg.complement_side(s25_2s6b_sides[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_2s6b_sides[1][0]), "BS"]
# })
# t2_m2b = bg.sequence_generator({
#     "S3" => [s36_4s4b_core[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_2s6b_sides[3][0]), "BS"]
# })

# t2_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b_core[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[3][0]), "BS"]
# })


# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 3, "TAIL", 0.34)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])

# t1_m1a_final = t1_m1a_z_seqs + t1_m1a
# t1_m2a_final = t1_m2a_z_seqs + t1_m2a
# t1_m3a_final = t1_m3a_z_seqs + t1_m3a

# t1_m1b_final = t1_m1b_z_seqs + t1_m1b
# t1_m2b_final = t1_m2b_z_seqs + t1_m2b
# t1_m3b_final = t1_m3b_z_seqs + t1_m3b

# t2_m1a_final = t2_m1a_z_seqs + t2_m1a
# t2_m2a_final = t2_m2a_z_seqs + t2_m2a
# t2_m3a_final = t2_m3a_z_seqs + t2_m3a

# t2_m1b_final = t2_m1b_z_seqs + t2_m1b
# t2_m2b_final = t2_m2b_z_seqs + t2_m2b
# t2_m3b_final = t2_m3b_z_seqs + t2_m3b


# bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M1A.csv")
# bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M2A.csv")
# bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M3A.csv")

# bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M1B.csv")
# bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M2B.csv")
# bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T1_M3B.csv")

# bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M1A.csv")
# bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M2A.csv")
# bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M3A.csv")

# bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M1B.csv")
# bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M2B.csv")
# bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/fhcjk/T2_M3B.csv")


# 2x3M + 2x3M (4S4B + 4S4O) (hierarchical) (akopz)
# s14_8s = bg.generate_sides("S14", count=4, number=4, overlap=0.5)

# s25_4s4b = bg.generate_sides("S25", count=8, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)

# s25_4s4b_core = s25_4s4b[0, 4]
# s25_4s4b_sides = s25_4s4b[4, 8]

# s36_4s4b_core = s36_4s4b[0, 4]
# s36_4s4b_sides = s36_4s4b[4, 6]

# ### T1 ###

# #### Bottom Layer ####

# t1_m1a = bg.sequence_generator({
#     "S1" => [s14_8s[0][0], "BS"],
#     "S2" => [s25_4s4b_sides[0][0], "S"],
#     "S6" => [bg.complement_side(s36_4s4b_core[0][0]), "BS"]
# })
# t1_m2a = bg.sequence_generator({
#     "S2" => [s25_4s4b_sides[1][0], "S"],
#     "S3" => [s36_4s4b_sides[0][0], "S"],
#     "S4" => [bg.complement_side(s14_8s[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_core[0][0]), "BS"]
# })

# t1_m3a = bg.sequence_generator({
#     "S2" => [s25_4s4b_core[0][0], "BS"],
#     "S3" => [s36_4s4b_core[0][0], "BS"]
# })

# #### Top Layer ####

# t1_m1b = bg.sequence_generator({
#     "S1" => [s14_8s[1][0], "BS"],
#     "S2" => [s25_4s4b_sides[2][0], "S"],
#     "S6" => [bg.complement_side(s36_4s4b_core[1][0]), "BS"]
# })
# t1_m2b = bg.sequence_generator({
#     "S2" => [s25_4s4b_sides[3][0], "S"],
#     "S3" => [s36_4s4b_sides[1][0], "S"],
#     "S4" => [bg.complement_side(s14_8s[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_core[1][0]), "BS"]
# })

# t1_m3b = bg.sequence_generator({
#     "S2" => [s25_4s4b_core[1][0], "BS"],
#     "S3" => [s36_4s4b_core[1][0], "BS"]
# })

# ### T2 ###

# #### Bottom Layer ####

# t2_m1a = bg.sequence_generator({
#     "S1" => [s14_8s[2][0], "BS"],
#     "S2" => [s25_4s4b_core[2][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_sides[0][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b_sides[0][0]), "S"],
# })
# t2_m2a = bg.sequence_generator({
#     "S3" => [s36_4s4b_core[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_sides[1][0]), "S"]
# })

# t2_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b_core[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[2][0]), "BS"]
# })

# #### Top Layer ####

# t2_m1b = bg.sequence_generator({
#     "S1" => [s14_8s[3][0], "BS"],
#     "S2" => [s25_4s4b_core[3][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_sides[2][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b_sides[1][0]), "S"]
# })
# t2_m2b = bg.sequence_generator({
#     "S3" => [s36_4s4b_core[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_sides[3][0]), "S"]
# })

# t2_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b_core[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_core[3][0]), "BS"]
# })

# # # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 4, "TAIL", 0.5)
# puts z_6h_tail_bonds.inspect
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# t1_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t1_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t1_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t1_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t1_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t1_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])


# t2_m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# t2_m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# t2_m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# t2_m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# t2_m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# t2_m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])

# t1_m1a_final = t1_m1a_z_seqs + t1_m1a
# t1_m2a_final = t1_m2a_z_seqs + t1_m2a
# t1_m3a_final = t1_m3a_z_seqs + t1_m3a

# t1_m1b_final = t1_m1b_z_seqs + t1_m1b
# t1_m2b_final = t1_m2b_z_seqs + t1_m2b
# t1_m3b_final = t1_m3b_z_seqs + t1_m3b

# t2_m1a_final = t2_m1a_z_seqs + t2_m1a
# t2_m2a_final = t2_m2a_z_seqs + t2_m2a
# t2_m3a_final = t2_m3a_z_seqs + t2_m3a

# t2_m1b_final = t2_m1b_z_seqs + t2_m1b
# t2_m2b_final = t2_m2b_z_seqs + t2_m2b
# t2_m3b_final = t2_m3b_z_seqs + t2_m3b


# bg.to_csv(["Sequence"] + t1_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M1A.csv")
# bg.to_csv(["Sequence"] + t1_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M2A.csv")
# bg.to_csv(["Sequence"] + t1_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M3A.csv")

# bg.to_csv(["Sequence"] + t1_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M1B.csv")
# bg.to_csv(["Sequence"] + t1_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M2B.csv")
# bg.to_csv(["Sequence"] + t1_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T1_M3B.csv")

# bg.to_csv(["Sequence"] + t2_m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M1A.csv")
# bg.to_csv(["Sequence"] + t2_m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M2A.csv")
# bg.to_csv(["Sequence"] + t2_m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M3A.csv")

# bg.to_csv(["Sequence"] + t2_m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M1B.csv")
# bg.to_csv(["Sequence"] + t2_m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M2B.csv")
# bg.to_csv(["Sequence"] + t2_m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/akopz/T2_M3B.csv")


# 4M Designs

# (8S + 4S4B)
# s14_8s = bg.generate_sides("S14", count=2, number=4, overlap=0.25)

# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0)

# # Bottom

# m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"]
# })

# m2a = bg.sequence_generator({
#     "S1" => [s14_8s[0][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4a = bg.sequence_generator({
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"]
# })

# # Top

# m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_8s[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"]
# })

# m2b = bg.sequence_generator({
#     "S1" => [s14_8s[1][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m4b = bg.sequence_generator({
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"]
# })

# z_6h_tail_bonds = bg.z_bond_sampler(3, 4, "TAIL", 0.5)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])

# m1a_final = m1a_z_seqs + m1a
# m2a_final = m2a_z_seqs + m2a
# m3a_final = m3a_z_seqs + m3a
# m4a_final = m4a_z_seqs + m4a

# m1b_final = m1b_z_seqs + m1b
# m2b_final = m2b_z_seqs + m2b
# m3b_final = m3b_z_seqs + m3b
# m4b_final = m4b_z_seqs + m4b

# bg.to_csv(["Sequence"] + m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M1A_8S.csv")
# bg.to_csv(["Sequence"] + m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M2A_8S.csv")
# bg.to_csv(["Sequence"] + m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M3A_8S.csv")
# bg.to_csv(["Sequence"] + m4a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M4A_8S.csv")

# bg.to_csv(["Sequence"] + m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M1B_8S.csv")
# bg.to_csv(["Sequence"] + m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M2B_8S.csv")
# bg.to_csv(["Sequence"] + m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M3B_8S.csv")
# bg.to_csv(["Sequence"] + m4b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M4B_8S.csv")


# ALL 4S4B
# s14_4s4b = bg.generate_sides("S14", count=2, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0)

# # Bottom

# m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"]
# })

# m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4a = bg.sequence_generator({
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"]
# })

# # Top

# m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"]
# })

# m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m4b = bg.sequence_generator({
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"]
# })


# # Z Bonds
# z_6h_tail_bonds = bg.z_bond_sampler(3, 4, "TAIL", 0.5)
# z_6h_head_bonds = bg.z_complement_side(z_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])

# m1a_final = m1a_z_seqs + m1a
# m2a_final = m2a_z_seqs + m2a
# m3a_final = m3a_z_seqs + m3a
# m4a_final = m4a_z_seqs + m4a

# m1b_final = m1b_z_seqs + m1b
# m2b_final = m2b_z_seqs + m2b
# m3b_final = m3b_z_seqs + m3b
# m4b_final = m4b_z_seqs + m4b


# bg.to_csv(["Sequence"] + m1a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M1A_4S4B.csv")
# bg.to_csv(["Sequence"] + m2a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M2A_4S4B.csv")
# bg.to_csv(["Sequence"] + m3a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M3A_4S4B.csv")
# bg.to_csv(["Sequence"] + m4a_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M4A_4S4B.csv")

# bg.to_csv(["Sequence"] + m1b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M1B_4S4B.csv")
# bg.to_csv(["Sequence"] + m2b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M2B_4S4B.csv")
# bg.to_csv(["Sequence"] + m3b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M3B_4S4B.csv")
# bg.to_csv(["Sequence"] + m4b_final, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/4M-NEW/M4B_4S4B.csv")


# 6ML

# s14_4s4b = bg.generate_sides("S14", count=3, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", count=2, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0)

# m1_6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m2_6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m3_6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4_6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"]
# })

# m5_6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m6_6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
# })

# bg.to_csv(["Sequence"] + m1_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m1.csv")
# bg.to_csv(["Sequence"] + m2_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m2.csv")
# bg.to_csv(["Sequence"] + m3_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m3.csv")
# bg.to_csv(["Sequence"] + m4_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m4.csv")
# bg.to_csv(["Sequence"] + m5_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m5.csv")
# bg.to_csv(["Sequence"] + m6_6ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6ml/m6.csv")

# 6MX

# s14_4s4b = bg.generate_sides("S14", count=3, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", count=3, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=3, number=2, overlap=0)


# m1_6mx = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m2_6mx = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m3_6mx = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4_6mx = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# m5_6mx = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
# })

# m6_6mx = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m1.csv")
# bg.to_csv(["Sequence"] + m2_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m2.csv")
# bg.to_csv(["Sequence"] + m3_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m3.csv")
# bg.to_csv(["Sequence"] + m4_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m4.csv")
# bg.to_csv(["Sequence"] + m5_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m5.csv")
# bg.to_csv(["Sequence"] + m6_6mx, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/6mx/m6.csv")

# 8ML

# s14_4s4b = bg.generate_sides("S14", count=4, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", count=3, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=6, number=2, overlap=0.25)


# m1_8ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m2_8ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_8ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_8ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_8ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
# })

# m6_8ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_8ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_8ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m1.csv")
# bg.to_csv(["Sequence"] + m2_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m2.csv")
# bg.to_csv(["Sequence"] + m3_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m3.csv")
# bg.to_csv(["Sequence"] + m4_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m4.csv")
# bg.to_csv(["Sequence"] + m5_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m5.csv")
# bg.to_csv(["Sequence"] + m6_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m6.csv")
# bg.to_csv(["Sequence"] + m7_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m7.csv")
# bg.to_csv(["Sequence"] + m8_8ml, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/8ml/m8.csv")

# 7M

# s14_4s4b = bg.generate_sides("S14", count=4, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", count=4, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", count=4, number=2, overlap=0)

# m1_7m = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"]
# })

# m2_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m3_7m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m5_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m6_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
# })

# m7_7m = bg.sequence_generator({
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m1.csv")
# bg.to_csv(["Sequence"] + m2_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m2.csv")
# bg.to_csv(["Sequence"] + m3_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m3.csv")
# bg.to_csv(["Sequence"] + m4_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m4.csv")
# bg.to_csv(["Sequence"] + m5_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m5.csv")
# bg.to_csv(["Sequence"] + m6_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m6.csv")
# bg.to_csv(["Sequence"] + m7_7m, "/home/sme777/Desktop/hexoland/sequences/4s4b_shapes/7m/m7.csv")


# 16M

# s14_4s4b = bg.generate_sides("S14", count=12, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", count=9, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", count=12, number=2, overlap=0.25)

# m1_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m1.csv")
# bg.to_csv(["Sequence"] + m2_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m2.csv")
# bg.to_csv(["Sequence"] + m3_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m3.csv")
# bg.to_csv(["Sequence"] + m4_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m4.csv")
# bg.to_csv(["Sequence"] + m5_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m5.csv")
# bg.to_csv(["Sequence"] + m6_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m6.csv")
# bg.to_csv(["Sequence"] + m7_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m7.csv")
# bg.to_csv(["Sequence"] + m8_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m8.csv")
# bg.to_csv(["Sequence"] + m9_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m9.csv")
# bg.to_csv(["Sequence"] + m10_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m10.csv")
# bg.to_csv(["Sequence"] + m11_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m11.csv")
# bg.to_csv(["Sequence"] + m12_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m12.csv")
# bg.to_csv(["Sequence"] + m13_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m13.csv")
# bg.to_csv(["Sequence"] + m14_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m14.csv")
# bg.to_csv(["Sequence"] + m15_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m15.csv")
# bg.to_csv(["Sequence"] + m16_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/16M/m16.csv")


# 16M

# s14_4s4b_no_ref = bg.generate_sides("S14", [], count=12, number=2, overlap=0.25)
# s14_4s4b_w_ref = bg.generate_sides("S14", s14_4s4b_no_ref, count=14, number=2, overlap=0.5)

# s25_4s4b_no_ref = bg.generate_sides("S25", [], count=12, number=2, overlap=0.25)
# s25_4s4b_w_ref = bg.generate_sides("S25", s25_4s4b_no_ref, count=14, number=2, overlap=0.5)

# s36_4s4b_no_ref = bg.generate_sides("S36", [], count=12, number=2, overlap=0.25)
# s36_4s4b_w_ref = bg.generate_sides("S36", s36_4s4b_no_ref, count=14, number=2, overlap=0.5)



# m1_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[0][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[0][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[0][0], "BS"]
# })

# m2_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[1][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[1][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[0][0]), "BS"]
# })

# m3_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[2][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[1][0]), "BS"]
# })

# m4_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[3][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[6][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[4][0]), "BS"]
# })

# m5_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[4][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[8][0]), "BS"]
# })

# m6_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[5][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[3][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[0][0]), "BS"]
# })

# m7_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[6][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[4][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[2][0]), "BS"]
# })

# m8_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[7][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[5][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[3][0]), "BS"]
# })

# m9_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[8][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[10][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[7][0]), "BS"]
# })

# m10_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[10][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[11][0]), "BS"]
# })

# m11_19m = bg.sequence_generator({
#     "S2" => [s25_4s4b_w_ref[7][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[5][0]), "BS"]
# })

# m12_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[10][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[8][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[5][0]), "BS"]
# })

# m13_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[11][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[9][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[6][0]), "BS"]
# })

# m14_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[12][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[13][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[9][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[10][0]), "BS"]
# })

# m15_19m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[13][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[13][0]), "BS"]
# })

# m16_19m = bg.sequence_generator({
#     "S2" => [s25_4s4b_w_ref[11][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[7][0]), "BS"],
# })

# m17_19m = bg.sequence_generator({
#     "S1" => [s14_4s4b_w_ref[13][0], "BS"],
#     "S2" => [s25_4s4b_w_ref[12][0], "BS"],
#     "S3" => [s36_4s4b_w_ref[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[9][0]), "BS"]
# })

# m18_19m = bg.sequence_generator({
#     "S3" => [s36_4s4b_w_ref[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[12][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[12][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b_w_ref[12][0]), "BS"]
# })

# m19_19m = bg.sequence_generator({
#     "S3" => [s36_4s4b_w_ref[12][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b_w_ref[13][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b_w_ref[11][0]), "BS"],
# })


# bg.to_csv(["Sequence"] + m1_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m1.csv")
# bg.to_csv(["Sequence"] + m2_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m2.csv")
# bg.to_csv(["Sequence"] + m3_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m3.csv")
# bg.to_csv(["Sequence"] + m4_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m4.csv")
# bg.to_csv(["Sequence"] + m5_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m5.csv")
# bg.to_csv(["Sequence"] + m6_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m6.csv")
# bg.to_csv(["Sequence"] + m7_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m7.csv")
# bg.to_csv(["Sequence"] + m8_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m8.csv")
# bg.to_csv(["Sequence"] + m9_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m9.csv")
# bg.to_csv(["Sequence"] + m10_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m10.csv")
# bg.to_csv(["Sequence"] + m11_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m11.csv")
# bg.to_csv(["Sequence"] + m12_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m12.csv")
# bg.to_csv(["Sequence"] + m13_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m13.csv")
# bg.to_csv(["Sequence"] + m14_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m14.csv")
# bg.to_csv(["Sequence"] + m15_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m15.csv")
# bg.to_csv(["Sequence"] + m16_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m16.csv")
# bg.to_csv(["Sequence"] + m17_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m17.csv")
# bg.to_csv(["Sequence"] + m18_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m18.csv")
# bg.to_csv(["Sequence"] + m19_19m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/19M/m19.csv")


# Max number of bonds is 25 with 33% overlap


# 2x3M
# s14_4s4b = bg.generate_sides("S14", [], count=2, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", [], count=2, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", [], count=2, number=2, overlap=0)

# s_2x3_m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# s_2x3_m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
# })

# s_2x3_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# s_2x3_m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# s_2x3_m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
# })

# s_2x3_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# # Z bonds
# z_2x6h_tail_bonds = bg.z_bond_sampler(3, 3, "TAIL", 0)
# z_2x6h_head_bonds = bg.z_complement_side(z_2x6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_2x6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_2x6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_2x6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])

# s_2x3_m1a_w_z = s_2x3_m1a + m1a_z_seqs
# s_2x3_m2a_w_z = s_2x3_m2a + m2a_z_seqs
# s_2x3_m3a_w_z = s_2x3_m3a + m3a_z_seqs

# s_2x3_m1b_w_z = s_2x3_m1b + m1b_z_seqs
# s_2x3_m2b_w_z = s_2x3_m2b + m2b_z_seqs
# s_2x3_m3b_w_z = s_2x3_m3b + m3b_z_seqs


# bg.to_csv(["Sequence"] + s_2x3_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/1a.csv")
# bg.to_csv(["Sequence"] + s_2x3_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/2a.csv")
# bg.to_csv(["Sequence"] + s_2x3_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/3a.csv")

# bg.to_csv(["Sequence"] + s_2x3_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/1b.csv")
# bg.to_csv(["Sequence"] + s_2x3_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/2b.csv")
# bg.to_csv(["Sequence"] + s_2x3_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x3M/3b.csv")


# 3x3M
# s14_4s4b = bg.generate_sides("S14", [], count=3, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", [], count=3, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", [], count=3, number=2, overlap=0)

# s_3x3_m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# s_3x3_m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
# })

# s_3x3_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# s_3x3_m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# s_3x3_m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
# })

# s_3x3_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# s_3x3_m1c = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# s_3x3_m2c = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
# })

# s_3x3_m3c = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# # # Z bonds
# z_3x6h_tail_bonds = bg.z_bond_sampler(3, 6, "TAIL", 0)
# z_3x6h_head_bonds = bg.z_complement_side(z_3x6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[0]) + bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[3])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[1]) + bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[4])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[2]) + bg.add_z_bonds("TAIL", z_3x6h_tail_bonds[5])

# m1c_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# m2c_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# m3c_z_seqs = bg.add_z_bonds("HEAD", z_3x6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])


# s_3x3_m1a_w_z = s_3x3_m1a + m1a_z_seqs
# s_3x3_m2a_w_z = s_3x3_m2a + m2a_z_seqs
# s_3x3_m3a_w_z = s_3x3_m3a + m3a_z_seqs

# s_3x3_m1b_w_z = s_3x3_m1b + m1b_z_seqs
# s_3x3_m2b_w_z = s_3x3_m2b + m2b_z_seqs
# s_3x3_m3b_w_z = s_3x3_m3b + m3b_z_seqs

# s_3x3_m1c_w_z = s_3x3_m1c + m1c_z_seqs
# s_3x3_m2c_w_z = s_3x3_m2c + m2c_z_seqs
# s_3x3_m3c_w_z = s_3x3_m3c + m3c_z_seqs

# bg.to_csv(["Sequence"] + s_3x3_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/1a.csv")
# bg.to_csv(["Sequence"] + s_3x3_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/2a.csv")
# bg.to_csv(["Sequence"] + s_3x3_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/3a.csv")

# bg.to_csv(["Sequence"] + s_3x3_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/1b.csv")
# bg.to_csv(["Sequence"] + s_3x3_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/2b.csv")
# bg.to_csv(["Sequence"] + s_3x3_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/3b.csv")

# bg.to_csv(["Sequence"] + s_3x3_m1c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/1c.csv")
# bg.to_csv(["Sequence"] + s_3x3_m2c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/2c.csv")
# bg.to_csv(["Sequence"] + s_3x3_m3c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/3x3M/3c.csv")



# 4x3M
# s14_4s4b = bg.generate_sides("S14", [], count=4, number=2, overlap=0)
# s25_4s4b = bg.generate_sides("S25", [], count=4, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", [], count=4, number=2, overlap=0)

# s_4x3_m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# s_4x3_m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
# })

# s_4x3_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# s_4x3_m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# s_4x3_m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
# })

# s_4x3_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# s_4x3_m1c = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# s_4x3_m2c = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
# })

# s_4x3_m3c = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# s_4x3_m1d = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# s_4x3_m2d = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
# })

# s_4x3_m3d = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# # Z bonds
# z_4x6h_tail_bonds = bg.z_bond_sampler(3, 9, "TAIL", 0.34)
# z_4x6h_head_bonds = bg.z_complement_side(z_4x6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[0]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[3])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[1]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[4])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[2]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[5])

# m1c_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[3]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[6])
# m2c_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[4]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[7])
# m3c_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[5]) + bg.add_z_bonds("TAIL", z_4x6h_tail_bonds[8])

# m1d_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[6]) + bg.add_z_bonds("TAIL", [])
# m2d_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[7]) + bg.add_z_bonds("TAIL", [])
# m3d_z_seqs = bg.add_z_bonds("HEAD", z_4x6h_head_bonds[8]) + bg.add_z_bonds("TAIL", [])

# s_4x3_m1a_w_z = s_4x3_m1a + m1a_z_seqs
# s_4x3_m2a_w_z = s_4x3_m2a + m2a_z_seqs
# s_4x3_m3a_w_z = s_4x3_m3a + m3a_z_seqs

# s_4x3_m1b_w_z = s_4x3_m1b + m1b_z_seqs
# s_4x3_m2b_w_z = s_4x3_m2b + m2b_z_seqs
# s_4x3_m3b_w_z = s_4x3_m3b + m3b_z_seqs

# s_4x3_m1c_w_z = s_4x3_m1c + m1c_z_seqs
# s_4x3_m2c_w_z = s_4x3_m2c + m2c_z_seqs
# s_4x3_m3c_w_z = s_4x3_m3c + m3c_z_seqs

# s_4x3_m1d_w_z = s_4x3_m1d + m1d_z_seqs
# s_4x3_m2d_w_z = s_4x3_m2d + m2d_z_seqs
# s_4x3_m3d_w_z = s_4x3_m3d + m3d_z_seqs

# bg.to_csv(["Sequence"] + s_4x3_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/1a.csv")
# bg.to_csv(["Sequence"] + s_4x3_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/2a.csv")
# bg.to_csv(["Sequence"] + s_4x3_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/3a.csv")

# bg.to_csv(["Sequence"] + s_4x3_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/1b.csv")
# bg.to_csv(["Sequence"] + s_4x3_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/2b.csv")
# bg.to_csv(["Sequence"] + s_4x3_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/3b.csv")

# bg.to_csv(["Sequence"] + s_4x3_m1c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/1c.csv")
# bg.to_csv(["Sequence"] + s_4x3_m2c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/2c.csv")
# bg.to_csv(["Sequence"] + s_4x3_m3c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/3c.csv")

# bg.to_csv(["Sequence"] + s_4x3_m1d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/1d.csv")
# bg.to_csv(["Sequence"] + s_4x3_m2d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/2d.csv")
# bg.to_csv(["Sequence"] + s_4x3_m3d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/4x3M/3d.csv")

# 5x3M
# s14_4s4b = bg.generate_sides("S14", [], count=5, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", [], count=5, number=2, overlap=0.25)
# s36_4s4b = bg.generate_sides("S36", [], count=5, number=2, overlap=0.25)

# s_5x3_m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# s_5x3_m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
# })

# s_5x3_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# s_5x3_m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# s_5x3_m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
# })

# s_5x3_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# s_5x3_m1c = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# s_5x3_m2c = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
# })

# s_5x3_m3c = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# s_5x3_m1d = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# s_5x3_m2d = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
# })

# s_5x3_m3d = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# s_5x3_m1e = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# s_5x3_m2e = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
# })

# s_5x3_m3e = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# # Z bonds
# z_5x6h_tail_bonds = bg.z_bond_sampler(3, 12, "TAIL", 0.34)
# z_5x6h_head_bonds = bg.z_complement_side(z_5x6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[0]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[3])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[1]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[4])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[2]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[5])

# m1c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[3]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[6])
# m2c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[4]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[7])
# m3c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[5]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[8])

# m1d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[6]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[9])
# m2d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[7]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[10])
# m3d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[8]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[11])

# m1e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[9]) + bg.add_z_bonds("TAIL", [])
# m2e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[10]) + bg.add_z_bonds("TAIL", [])
# m3e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[11]) + bg.add_z_bonds("TAIL", [])

# s_5x3_m1a_w_z = s_5x3_m1a + m1a_z_seqs
# s_5x3_m2a_w_z = s_5x3_m2a + m2a_z_seqs
# s_5x3_m3a_w_z = s_5x3_m3a + m3a_z_seqs

# s_5x3_m1b_w_z = s_5x3_m1b + m1b_z_seqs
# s_5x3_m2b_w_z = s_5x3_m2b + m2b_z_seqs
# s_5x3_m3b_w_z = s_5x3_m3b + m3b_z_seqs

# s_5x3_m1c_w_z = s_5x3_m1c + m1c_z_seqs
# s_5x3_m2c_w_z = s_5x3_m2c + m2c_z_seqs
# s_5x3_m3c_w_z = s_5x3_m3c + m3c_z_seqs

# s_5x3_m1d_w_z = s_5x3_m1d + m1d_z_seqs
# s_5x3_m2d_w_z = s_5x3_m2d + m2d_z_seqs
# s_5x3_m3d_w_z = s_5x3_m3d + m3d_z_seqs

# s_5x3_m1e_w_z = s_5x3_m1e + m1e_z_seqs
# s_5x3_m2e_w_z = s_5x3_m2e + m2e_z_seqs
# s_5x3_m3e_w_z = s_5x3_m3e + m3e_z_seqs

# bg.to_csv(["Sequence"] + s_5x3_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/1a.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/2a.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/3a.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/1b.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/2b.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/3b.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/1c.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/2c.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/3c.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/1d.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/2d.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/3d.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/1e.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/2e.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/5x3M/3e.csv")


# 2x6ML

# s14_4s4b = bg.generate_sides("S14", [], count=6, number=2, overlap=0.25)
# s25_4s4b = bg.generate_sides("S25", [], count=4, number=2, overlap=0)
# s36_4s4b = bg.generate_sides("S36", [], count=8, number=2, overlap=0.25)

# m1a_2x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m2a_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m3a_2x6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4a_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"]
# })

# m5a_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m6a_2x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
# })


# # layer 2

# m1b_2x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m2b_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m3b_2x6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m4b_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"]
# })

# m5b_2x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m6b_2x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
# })


# z_2x6_6h_tail_bonds = bg.z_bond_sampler(3, 6, "TAIL", 0)
# z_2x6_6h_head_bonds = bg.z_complement_side(z_2x6_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_2x6_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# m5b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# m6b_z_seqs = bg.add_z_bonds("HEAD", z_2x6_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])


# s_2x6_m1a_w_z = m1a_2x6ml + m1a_z_seqs
# s_2x6_m2a_w_z = m2a_2x6ml + m2a_z_seqs
# s_2x6_m3a_w_z = m3a_2x6ml + m3a_z_seqs
# s_2x6_m4a_w_z = m4a_2x6ml + m4a_z_seqs
# s_2x6_m5a_w_z = m5a_2x6ml + m5a_z_seqs
# s_2x6_m6a_w_z = m6a_2x6ml + m6a_z_seqs

# s_2x6_m1b_w_z = m1b_2x6ml + m1b_z_seqs
# s_2x6_m2b_w_z = m2b_2x6ml + m2b_z_seqs
# s_2x6_m3b_w_z = m3b_2x6ml + m3b_z_seqs
# s_2x6_m4b_w_z = m4b_2x6ml + m4b_z_seqs
# s_2x6_m5b_w_z = m5b_2x6ml + m5b_z_seqs
# s_2x6_m6b_w_z = m6b_2x6ml + m6b_z_seqs

# bg.to_csv(["Sequence"] + s_2x6_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/1a.csv")
# bg.to_csv(["Sequence"] + s_2x6_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/2a.csv")
# bg.to_csv(["Sequence"] + s_2x6_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/3a.csv")
# bg.to_csv(["Sequence"] + s_2x6_m4a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/4a.csv")
# bg.to_csv(["Sequence"] + s_2x6_m5a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/5a.csv")
# bg.to_csv(["Sequence"] + s_2x6_m6a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/6a.csv")

# bg.to_csv(["Sequence"] + s_2x6_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/1b.csv")
# bg.to_csv(["Sequence"] + s_2x6_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/2b.csv")
# bg.to_csv(["Sequence"] + s_2x6_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/3b.csv")
# bg.to_csv(["Sequence"] + s_2x6_m4b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/4b.csv")
# bg.to_csv(["Sequence"] + s_2x6_m5b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/5b.csv")
# bg.to_csv(["Sequence"] + s_2x6_m6b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x6M/6b.csv")


# 7M

# s14_4s4b = bg.generate_sides("S14", [], count=8, number=2, overlap=0.5)
# s25_4s4b = bg.generate_sides("S25", [], count=8, number=2, overlap=0.5)
# s36_4s4b = bg.generate_sides("S36", [], count=8, number=2, overlap=0.5)

# puts bg.best_sides_out_of("S14", 50,  [], count=14, number=2, overlap=0.5, godmode=false).inspect


# bg.draw_matrix(bg.compute_similiarity_matrix(s14_4s4b))
# puts bg.compute_assembly_score(bg.compute_similiarity_matrix(s14_4s4b)).inspect
# m1a_7m = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"]
# })

# m2a_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m3a_7m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4a_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m5a_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m6a_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
# })

# m7a_7m = bg.sequence_generator({
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })


# # bottom layer

# m1b_7m = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"]
# })

# m2b_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m3b_7m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m4b_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m5b_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m6b_7m = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
# })

# m7b_7m = bg.sequence_generator({
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"]
# })

# z_2x7_6h_tail_bonds = bg.z_bond_sampler(3, 7, "TAIL", 0.34)
# z_2x7_6h_head_bonds = bg.z_complement_side(z_2x7_6h_tail_bonds)

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
# m7a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
# m5b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
# m6b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])
# m7b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[6]) + bg.add_z_bonds("TAIL", [])

# s_2x7_m1a_w_z = m1a_7m + m1a_z_seqs
# s_2x7_m2a_w_z = m2a_7m + m2a_z_seqs
# s_2x7_m3a_w_z = m3a_7m + m3a_z_seqs
# s_2x7_m4a_w_z = m4a_7m + m4a_z_seqs
# s_2x7_m5a_w_z = m5a_7m + m5a_z_seqs
# s_2x7_m6a_w_z = m6a_7m + m6a_z_seqs
# s_2x7_m7a_w_z = m7a_7m + m7a_z_seqs

# s_2x7_m1b_w_z = m1b_7m + m1b_z_seqs
# s_2x7_m2b_w_z = m2b_7m + m2b_z_seqs
# s_2x7_m3b_w_z = m3b_7m + m3b_z_seqs
# s_2x7_m4b_w_z = m4b_7m + m4b_z_seqs
# s_2x7_m5b_w_z = m5b_7m + m5b_z_seqs
# s_2x7_m6b_w_z = m6b_7m + m6b_z_seqs
# s_2x7_m7b_w_z = m7b_7m + m7b_z_seqs

# bg.to_csv(["Sequence"] + s_2x7_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/1a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/2a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/3a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m4a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/4a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m5a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/5a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m6a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/6a.csv")
# bg.to_csv(["Sequence"] + s_2x7_m7a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/7a.csv")

# bg.to_csv(["Sequence"] + s_2x7_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/1b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/2b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/3b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m4b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/4b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m5b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/5b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m6b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/6b.csv")
# bg.to_csv(["Sequence"] + s_2x7_m7b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/7b.csv")


# s14_4s4b_no_ref, score1 = bg.best_sides_out_of("S14", 3, [], count=12, number=2, overlap=0.25, godmode=false)
# puts s14_4s4b_no_ref.inspect, score1
# s25_4s4b_no_ref, score2 = bg.best_sides_out_of("S25", 6, [], count=12, number=2, overlap=0.25, godmode=false)
# puts s25_4s4b_no_ref.inspect, score2
# s36_4s4b_no_ref, score3 = bg.best_sides_out_of("S36", 3, [], count=12, number=2, overlap=0.25, godmode=false)
# puts s36_4s4b_no_ref.inspect, score3


# neighbor_map = {
#     "M1": {
#         "S3" => "M3",
#         "S4" => "M2"
#     },

#     "M2": {
#         "S1" => "M1",
#         "S2" => "M3"
#     },

#     "M3": {
#         "S5" => "M2",
#         "S6" => "M1"
#     }
# }

# bg.build_from_neighbors(neighbor_map, trials=10)

# 3x6ML

# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 25, [], count=9, number=2, overlap=0.25, godmode=false)
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 50, [], count=6, number=2, overlap=0.25, godmode=false)
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 5, [], count=12, number=2, overlap=0.25, godmode=false)

# puts score_s14, score_s25, score_s36

# m1a_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m2a_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m3a_3x6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4a_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"]
# })

# m5a_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m6a_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
# })


# # layer 2

# m1b_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m2b_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m3b_3x6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m4b_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"]
# })

# m5b_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m6b_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
# })

# # layer 3


# m1c_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[4+4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3+3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3+2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7+4][0]), "BS"]
# })

# m2c_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[3+3][0], "BS"],
#     "S2" => [s25_4s4b[2+2][0], "BS"],
#     "S3" => [s36_4s4b[5+4][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6+4][0]), "BS"]
# })

# m3c_3x6ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5+3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2+2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4+4][0]), "BS"]
# })

# m4c_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[4+3][0], "BS"],
#     "S2" => [s25_4s4b[3+2][0], "BS"],
#     "S3" => [s36_4s4b[6+4][0], "BS"]
# })

# m5c_3x6ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[5+3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5+4][0]), "BS"]
# })

# m6c_3x6ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[7+4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4+3][0]), "BS"],
# })


# z_3x6_6h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 12, "TAIL", 0.34, 100)
# z_3x6_6h_head_bonds = bg.z_complement_side(z_3x6_6h_tail_bonds)

# puts z_score

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[6])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[7])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[8])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[9])
# m5b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[10])
# m6b_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", z_3x6_6h_tail_bonds[11])

# m1c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[6]) + bg.add_z_bonds("TAIL", [])
# m2c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[7]) + bg.add_z_bonds("TAIL", [])
# m3c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[8]) + bg.add_z_bonds("TAIL", [])
# m4c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[9]) + bg.add_z_bonds("TAIL", [])
# m5c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[10]) + bg.add_z_bonds("TAIL", [])
# m6c_z_seqs = bg.add_z_bonds("HEAD", z_3x6_6h_head_bonds[11]) + bg.add_z_bonds("TAIL", [])

# s_3x6_m1a_w_z = m1a_3x6ml + m1a_z_seqs
# s_3x6_m2a_w_z = m2a_3x6ml + m2a_z_seqs
# s_3x6_m3a_w_z = m3a_3x6ml + m3a_z_seqs
# s_3x6_m4a_w_z = m4a_3x6ml + m4a_z_seqs
# s_3x6_m5a_w_z = m5a_3x6ml + m5a_z_seqs
# s_3x6_m6a_w_z = m6a_3x6ml + m6a_z_seqs

# s_3x6_m1b_w_z = m1b_3x6ml + m1b_z_seqs
# s_3x6_m2b_w_z = m2b_3x6ml + m2b_z_seqs
# s_3x6_m3b_w_z = m3b_3x6ml + m3b_z_seqs
# s_3x6_m4b_w_z = m4b_3x6ml + m4b_z_seqs
# s_3x6_m5b_w_z = m5b_3x6ml + m5b_z_seqs
# s_3x6_m6b_w_z = m6b_3x6ml + m6b_z_seqs

# s_3x6_m1c_w_z = m1c_3x6ml + m1c_z_seqs
# s_3x6_m2c_w_z = m2c_3x6ml + m2c_z_seqs
# s_3x6_m3c_w_z = m3c_3x6ml + m3c_z_seqs
# s_3x6_m4c_w_z = m4c_3x6ml + m4c_z_seqs
# s_3x6_m5c_w_z = m5c_3x6ml + m5c_z_seqs
# s_3x6_m6c_w_z = m6c_3x6ml + m6c_z_seqs

# bg.to_csv(["Sequence"] + s_3x6_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/1a.csv")
# bg.to_csv(["Sequence"] + s_3x6_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/2a.csv")
# bg.to_csv(["Sequence"] + s_3x6_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/3a.csv")
# bg.to_csv(["Sequence"] + s_3x6_m4a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/4a.csv")
# bg.to_csv(["Sequence"] + s_3x6_m5a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/5a.csv")
# bg.to_csv(["Sequence"] + s_3x6_m6a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/6a.csv")

# bg.to_csv(["Sequence"] + s_3x6_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/1b.csv")
# bg.to_csv(["Sequence"] + s_3x6_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/2b.csv")
# bg.to_csv(["Sequence"] + s_3x6_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/3b.csv")
# bg.to_csv(["Sequence"] + s_3x6_m4b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/4b.csv")
# bg.to_csv(["Sequence"] + s_3x6_m5b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/5b.csv")
# bg.to_csv(["Sequence"] + s_3x6_m6b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/6b.csv")

# bg.to_csv(["Sequence"] + s_3x6_m1c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/1c.csv")
# bg.to_csv(["Sequence"] + s_3x6_m2c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/2c.csv")
# bg.to_csv(["Sequence"] + s_3x6_m3c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/3c.csv")
# bg.to_csv(["Sequence"] + s_3x6_m4c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/4c.csv")
# bg.to_csv(["Sequence"] + s_3x6_m5c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/5c.csv")
# bg.to_csv(["Sequence"] + s_3x6_m6c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/3x6M/6c.csv")


# 5x3M
# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 100, [], count=5, number=2, overlap=0.25, godmode=false)
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 100, [], count=5, number=2, overlap=0.25, godmode=false)
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 100, [], count=5, number=2, overlap=0.25, godmode=false)
# p score_s14, score_s25, score_s36
# p s14_4s4b, s25_4s4b, s36_4s4b
# # 1A 

# s_5x3_m1a = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# s_5x3_m2a = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
# })

# s_5x3_m3a = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# # 1B

# s_5x3_m1b = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# s_5x3_m2b = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
# })

# s_5x3_m3b = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# # 1C

# s_5x3_m1c = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# s_5x3_m2c = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
# })

# s_5x3_m3c = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# # 1D

# s_5x3_m1d = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# s_5x3_m2d = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
# })

# s_5x3_m3d = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# # 1E

# s_5x3_m1e = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# s_5x3_m2e = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
# })

# s_5x3_m3e = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# # Z bonds
# z_5x6h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 12, "TAIL", 0.34, 100)
# z_5x6h_head_bonds = bg.z_complement_side(z_5x6h_tail_bonds)
# p z_score
# m1a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[0]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[3])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[1]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[4])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[2]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[5])

# m1c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[3]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[6])
# m2c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[4]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[7])
# m3c_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[5]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[8])

# m1d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[6]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[9])
# m2d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[7]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[10])
# m3d_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[8]) + bg.add_z_bonds("TAIL", z_5x6h_tail_bonds[11])

# m1e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[9]) + bg.add_z_bonds("TAIL", [])
# m2e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[10]) + bg.add_z_bonds("TAIL", [])
# m3e_z_seqs = bg.add_z_bonds("HEAD", z_5x6h_head_bonds[11]) + bg.add_z_bonds("TAIL", [])

# s_5x3_m1a_w_z = s_5x3_m1a + m1a_z_seqs
# s_5x3_m2a_w_z = s_5x3_m2a + m2a_z_seqs
# s_5x3_m3a_w_z = s_5x3_m3a + m3a_z_seqs

# s_5x3_m1b_w_z = s_5x3_m1b + m1b_z_seqs
# s_5x3_m2b_w_z = s_5x3_m2b + m2b_z_seqs
# s_5x3_m3b_w_z = s_5x3_m3b + m3b_z_seqs

# s_5x3_m1c_w_z = s_5x3_m1c + m1c_z_seqs
# s_5x3_m2c_w_z = s_5x3_m2c + m2c_z_seqs
# s_5x3_m3c_w_z = s_5x3_m3c + m3c_z_seqs

# s_5x3_m1d_w_z = s_5x3_m1d + m1d_z_seqs
# s_5x3_m2d_w_z = s_5x3_m2d + m2d_z_seqs
# s_5x3_m3d_w_z = s_5x3_m3d + m3d_z_seqs

# s_5x3_m1e_w_z = s_5x3_m1e + m1e_z_seqs
# s_5x3_m2e_w_z = s_5x3_m2e + m2e_z_seqs
# s_5x3_m3e_w_z = s_5x3_m3e + m3e_z_seqs

# bg.to_csv(["Sequence"] + s_5x3_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/1a.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/2a.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/3a.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/1b.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/2b.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/3b.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/1c.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/2c.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3c_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/3c.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/1d.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/2d.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3d_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/3d.csv")

# bg.to_csv(["Sequence"] + s_5x3_m1e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/1e.csv")
# bg.to_csv(["Sequence"] + s_5x3_m2e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/2e.csv")
# bg.to_csv(["Sequence"] + s_5x3_m3e_w_z, "/home/sme777/Desktop/hexoland/sequences/tower2/5x3M/3e.csv")



# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 100, [], count=5, number=2, overlap=0.25, godmode=false)
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 100, [], count=4, number=2, overlap=0.25, godmode=false)
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 100, [], count=8, number=2, overlap=0.25, godmode=false)

# p score_s14, score_s25, score_s36

# m1_10ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
# })

# m2_10ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"]
# })

# m3_10ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m4_10ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m5_10ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m6_10ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m7_10ml = bg.sequence_generator({
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m8_10ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m9_10ml = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m10_10ml = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/1a.csv")
# bg.to_csv(["Sequence"] + m2_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/2a.csv")
# bg.to_csv(["Sequence"] + m3_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/3a.csv")
# bg.to_csv(["Sequence"] + m4_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/4a.csv")
# bg.to_csv(["Sequence"] + m5_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/5a.csv")
# bg.to_csv(["Sequence"] + m6_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/6a.csv")
# bg.to_csv(["Sequence"] + m7_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/7a.csv")
# bg.to_csv(["Sequence"] + m8_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/8a.csv")
# bg.to_csv(["Sequence"] + m9_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/9a.csv")
# bg.to_csv(["Sequence"] + m10_10ml, "/home/sme777/Desktop/hexoland/sequences/10ML/10a.csv")


# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 1, [], count=12, number=2, overlap=0.25, godmode=false)
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 1, [], count=9, number=2, overlap=0.25, godmode=false)
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 1, [], count=12, number=2, overlap=0.25, godmode=false)

# puts score_s14, score_s25, score_s36

# s14_6s2b, score_s14 = bg.best_sides_out_of("S14", 20, [], count=4, number=3, overlap=0.376, godmode=false)
# s25_6s2b, score_s25 = bg.best_sides_out_of("S25", 20, [], count=4, number=3, overlap=0.376, godmode=false)
# s36_6s2b, score_s36 = bg.best_sides_out_of("S36", 20, [], count=2, number=3, overlap=0.376, godmode=false)

# puts score_s14, score_s25, score_s36

# PASSIVE 2x2x2 Hex

# m1a_2x2x2_pass = bg.sequence_generator({
#     "S1" => [s14_6s2b[0][0], "BS"],
#     "S2" => [s25_6s2b[0][0], "BS"]
# })

# m2a_2x2x2_pass = bg.sequence_generator({
#     "S2" => [s25_6s2b[1][0], "BS"],
#     "S3" => [s36_6s2b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_6s2b[0][0]), "BS"]
# })

# m3a_2x2x2_pass = bg.sequence_generator({
#     "S1" => [s14_6s2b[1][0], "BS"],
#     "S5" => [bg.complement_side(s25_6s2b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_6s2b[0][0]), "BS"]
# })

# m4a_2x2x2_pass = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_6s2b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_6s2b[1][0]), "BS"]
# })

# m1b_2x2x2_pass = bg.sequence_generator({
#     "S1" => [s14_6s2b[2][0], "BS"],
#     "S2" => [s25_6s2b[2][0], "BS"]
# })

# m2b_2x2x2_pass = bg.sequence_generator({
#     "S2" => [s25_6s2b[3][0], "BS"],
#     "S3" => [s36_6s2b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_6s2b[2][0]), "BS"]
# })

# m3b_2x2x2_pass = bg.sequence_generator({
#     "S1" => [s14_6s2b[3][0], "BS"],
#     "S5" => [bg.complement_side(s25_6s2b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_6s2b[1][0]), "BS"]
# })

# m4b_2x2x2_pass = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_6s2b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_6s2b[3][0]), "BS"]
# })

# Active 2x2x2 w 4S4B


# m1a_2x2x2_4s4b = bg.sequence_generator({

# })

# m2a_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m3a_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m4a_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m1b_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m2b_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m3b_2x2x2_4s4b = bg.sequence_generator({
    
# })

# m4b_2x2x2_4s4b = bg.sequence_generator({
    
# })

# Active 2x2x2 w 4S4O

# m1a_2x2x2_4s4o = bg.sequence_generator({

# })

# m2a_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m3a_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m4a_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m1b_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m2b_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m3b_2x2x2_4s4o = bg.sequence_generator({
    
# })

# m4b_2x2x2_4s4o = bg.sequence_generator({
    
# })


# z_2x2x2_6h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 4, "TAIL", 0.0, 20)
# z_2x2x2_6h_head_bonds = bg.z_complement_side(z_2x2x2_6h_tail_bonds)

# puts z_score

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x2x2_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x2x2_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x2x2_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_2x2x2_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("HEAD", z_2x2x2_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
# m2b_z_seqs = bg.add_z_bonds("HEAD", z_2x2x2_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
# m3b_z_seqs = bg.add_z_bonds("HEAD", z_2x2x2_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
# m4b_z_seqs = bg.add_z_bonds("HEAD", z_2x2x2_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])

# Passive 2x2x2

# m1a_2x2x2_pass_w_z = m1a_2x2x2_pass + m1a_z_seqs
# m2a_2x2x2_pass_w_z = m2a_2x2x2_pass + m2a_z_seqs
# m3a_2x2x2_pass_w_z = m3a_2x2x2_pass + m3a_z_seqs
# m4a_2x2x2_pass_w_z = m4a_2x2x2_pass + m4a_z_seqs

# m1b_2x2x2_pass_w_z = m1b_2x2x2_pass + m1b_z_seqs
# m2b_2x2x2_pass_w_z = m2b_2x2x2_pass + m2b_z_seqs
# m3b_2x2x2_pass_w_z = m3b_2x2x2_pass + m3b_z_seqs
# m4b_2x2x2_pass_w_z = m4b_2x2x2_pass + m4b_z_seqs

# Active (4S4B) 2x2x2

# m1a_2x2x2_4s4b_w_z = m1a_2x2x2_4s4b + m1a_z_seqs
# m2a_2x2x2_4s4b_w_z = m2a_2x2x2_4s4b + m2a_z_seqs
# m3a_2x2x2_4s4b_w_z = m3a_2x2x2_4s4b + m3a_z_seqs
# m4a_2x2x2_4s4b_w_z = m4a_2x2x2_4s4b + m4a_z_seqs

# m1b_2x2x2_4s4b_w_z = m1b_2x2x2_4s4b + m1b_z_seqs
# m2b_2x2x2_4s4b_w_z = m2b_2x2x2_4s4b + m2b_z_seqs
# m3b_2x2x2_4s4b_w_z = m3b_2x2x2_4s4b + m3b_z_seqs
# m4b_2x2x2_4s4b_w_z = m4b_2x2x2_4s4b + m4b_z_seqs

# Active (4S4O) 2x2x2

# m1a_2x2x2_4s4o_w_z = m1a_2x2x2_4s4o + m1a_z_seqs
# m2a_2x2x2_4s4o_w_z = m2a_2x2x2_4s4o + m2a_z_seqs
# m3a_2x2x2_4s4o_w_z = m3a_2x2x2_4s4o + m3a_z_seqs
# m4a_2x2x2_4s4o_w_z = m4a_2x2x2_4s4o + m4a_z_seqs

# m1b_2x2x2_4s4o_w_z = m1b_2x2x2_4s4o + m1b_z_seqs
# m2b_2x2x2_4s4o_w_z = m2b_2x2x2_4s4o + m2b_z_seqs
# m3b_2x2x2_4s4o_w_z = m3b_2x2x2_4s4o + m3b_z_seqs
# m4b_2x2x2_4s4o_w_z = m4b_2x2x2_4s4o + m4b_z_seqs


# Passive 2x2x2

# bg.to_csv(["Sequence"] + m1a_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/2a.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/3a.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/4a.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/2b.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/3b.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_pass_w_z, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2x2/pass/4b.csv")

# Active (4S4B) 2x2x2

# bg.to_csv(["Sequence"] + m1a_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/2a.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/3a.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/4a.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/2b.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/3b.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_4s4b_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4b/4b.csv")

# Active (4S4O) 2x2x2

# bg.to_csv(["Sequence"] + m1a_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/2a.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/3a.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/4a.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/2b.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/3b.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_4s4o_w_z, "/home/sme777/Desktop/hexoland/sequences/2x2x2/4s4o/4b.csv")


# 9M -- 3x3

# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 100, [], count=6, number=2, overlap=0.25, godmode=false)
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 100, [], count=4, number=2, overlap=0.25, godmode=false)
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 100, [], count=6, number=2, overlap=0.25, godmode=false)

# puts score_s14, score_s25, score_s36

# m1_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m5_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m6_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# m8_3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m9_3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/1a.csv")
# bg.to_csv(["Sequence"] + m2_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/2a.csv")
# bg.to_csv(["Sequence"] + m3_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/3a.csv")

# bg.to_csv(["Sequence"] + m4_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/4a.csv")
# bg.to_csv(["Sequence"] + m5_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/5a.csv")
# bg.to_csv(["Sequence"] + m6_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/6a.csv")

# bg.to_csv(["Sequence"] + m7_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/7a.csv")
# bg.to_csv(["Sequence"] + m8_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/8a.csv")
# bg.to_csv(["Sequence"] + m9_3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/9M-3x3/9a.csv")

# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S14 Score with 25% overlap only -- #{score_s14}"
# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 100, s14_4s4b, count=20, number=2, overlap=0.5, godmode=false)
# puts "S14 Score with 50% overlap allowed -- #{score_s14}"

# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S25 Score with 25% overlap only -- #{score_s25}"
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 100, s25_4s4b, count=16, number=2, overlap=0.5, godmode=false)
# puts "S25 Score with 50% overlap allowed -- #{score_s25}"

# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S36 Score with 25% overlap only -- #{score_s36}"
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 100, s36_4s4b, count=20, number=2, overlap=0.5, godmode=false)
# puts "S36 Score with 50% overlap allowed -- #{score_s36}"


# m1_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m6_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m7_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m10_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m11_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"]
# })

# m12_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[9][0], "BS"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "BS"],
#     "S2" => [s25_4s4b[10][0], "BS"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m14_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "BS"],
#     "S2" => [s25_4s4b[11][0], "BS"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m15_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# m16_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "BS"],
#     "S3" => [s36_4s4b[12][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"]
# })

# m17_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[16][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "BS"],
#     "S3" => [s36_4s4b[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "BS"]
# })

# m18_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[17][0], "BS"],
#     "S2" => [s25_4s4b[14][0], "BS"],
#     "S3" => [s36_4s4b[14][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "BS"]
# })

# m19_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[18][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "BS"],
#     "S3" => [s36_4s4b[15][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "BS"]
# })

# m20_25M = bg.sequence_generator({
#     "S1" => [s14_4s4b[19][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "BS"]
# })

# m21_25M = bg.sequence_generator({
#     "S3" => [s36_4s4b[16][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "BS"]
# })

# m22_25M = bg.sequence_generator({
#     "S3" => [s36_4s4b[17][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[16][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[16][0]), "BS"]
# })

# m23_25M = bg.sequence_generator({
#     "S3" => [s36_4s4b[18][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[17][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[17][0]), "BS"]
# })

# m24_25M = bg.sequence_generator({
#     "S3" => [s36_4s4b[19][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[18][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[14][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[18][0]), "BS"]
# })

# m25_25M = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[19][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[19][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m1.csv")
# bg.to_csv(["Sequence"] + m2_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m2.csv")
# bg.to_csv(["Sequence"] + m3_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m3.csv")
# bg.to_csv(["Sequence"] + m4_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m4.csv")
# bg.to_csv(["Sequence"] + m5_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m5.csv")

# bg.to_csv(["Sequence"] + m6_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m6.csv")
# bg.to_csv(["Sequence"] + m7_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m7.csv")
# bg.to_csv(["Sequence"] + m8_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m8.csv")
# bg.to_csv(["Sequence"] + m9_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m9.csv")
# bg.to_csv(["Sequence"] + m10_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m10.csv")

# bg.to_csv(["Sequence"] + m11_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m11.csv")
# bg.to_csv(["Sequence"] + m12_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m12.csv")
# bg.to_csv(["Sequence"] + m13_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m13.csv")
# bg.to_csv(["Sequence"] + m14_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m14.csv")
# bg.to_csv(["Sequence"] + m15_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m15.csv")

# bg.to_csv(["Sequence"] + m16_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m16.csv")
# bg.to_csv(["Sequence"] + m17_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m17.csv")
# bg.to_csv(["Sequence"] + m18_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m18.csv")
# bg.to_csv(["Sequence"] + m19_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m19.csv")
# bg.to_csv(["Sequence"] + m20_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m20.csv")

# bg.to_csv(["Sequence"] + m21_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m21.csv")
# bg.to_csv(["Sequence"] + m22_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m22.csv")
# bg.to_csv(["Sequence"] + m23_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m23.csv")
# bg.to_csv(["Sequence"] + m24_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m24.csv")
# bg.to_csv(["Sequence"] + m25_25M, "/home/sme777/Desktop/hexoland/sequences/25M/m25.csv")

# base_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# bg.to_csv(["Sequence"] + base_seqs, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/base_z_seqs.csv")


 # 6x6M
# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S14 Score with 25% overlap only -- #{score_s14}"
# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 50, s14_4s4b, count=30, number=2, overlap=0.5, godmode=false)
# puts "S14 Score with 50% overlap allowed -- #{score_s14}"

# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S25 Score with 25% overlap only -- #{score_s25}"
# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 50, s25_4s4b, count=25, number=2, overlap=0.5, godmode=false)
# puts "S25 Score with 50% overlap allowed -- #{score_s25}"

# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S36 Score with 25% overlap only -- #{score_s36}"
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 50, s36_4s4b, count=30, number=2, overlap=0.5, godmode=false)
# puts "S25 Score with 50% overlap allowed -- #{score_s36}"


# m1_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m6_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m7_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m8_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m10_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m11_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[9][0], "BS"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m12_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m13_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "BS"],
#     "S2" => [s25_4s4b[10][0], "BS"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"]
# })

# m14_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "BS"],
#     "S2" => [s25_4s4b[11][0], "BS"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m15_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "BS"],
#     "S3" => [s36_4s4b[12][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# m16_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "BS"],
#     "S3" => [s36_4s4b[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "BS"]
# })

# m17_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[16][0], "BS"],
#     "S2" => [s25_4s4b[14][0], "BS"],
#     "S3" => [s36_4s4b[14][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "BS"]
# })

# m18_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[17][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "BS"]
# })

# m19_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[18][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "BS"],
#     "S3" => [s36_4s4b[15][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "BS"]
# })

# m20_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[19][0], "BS"],
#     "S2" => [s25_4s4b[16][0], "BS"],
#     "S3" => [s36_4s4b[16][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "BS"]
# })

# m21_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[20][0], "BS"],
#     "S2" => [s25_4s4b[17][0], "BS"],
#     "S3" => [s36_4s4b[17][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[16][0]), "BS"]
# })

# m22_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[21][0], "BS"],
#     "S2" => [s25_4s4b[18][0], "BS"],
#     "S3" => [s36_4s4b[18][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[17][0]), "BS"]
# })

# m23_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[22][0], "BS"],
#     "S2" => [s25_4s4b[19][0], "BS"],
#     "S3" => [s36_4s4b[19][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[16][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[18][0]), "BS"]
# })

# m24_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[23][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[17][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[14][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[19][0]), "BS"]
# })

# m25_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[24][0], "BS"],
#     "S2" => [s25_4s4b[20][0], "BS"],
#     "S3" => [s36_4s4b[20][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[18][0]), "BS"]
# })

# m26_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[25][0], "BS"],
#     "S2" => [s25_4s4b[21][0], "BS"],
#     "S3" => [s36_4s4b[21][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[19][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[20][0]), "BS"]
# })

# m27_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[26][0], "BS"],
#     "S2" => [s25_4s4b[22][0], "BS"],
#     "S3" => [s36_4s4b[22][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[20][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[16][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[21][0]), "BS"]
# })

# m28_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[27][0], "BS"],
#     "S2" => [s25_4s4b[23][0], "BS"],
#     "S3" => [s36_4s4b[23][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[21][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[17][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[22][0]), "BS"]
# })

# m29_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[28][0], "BS"],
#     "S2" => [s25_4s4b[24][0], "BS"],
#     "S3" => [s36_4s4b[24][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[22][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[18][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[23][0]), "BS"]
# })

# m30_36M = bg.sequence_generator({
#     "S1" => [s14_4s4b[29][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[23][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[19][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[24][0]), "BS"]
# })

# m31_36M = bg.sequence_generator({
#     "S3" => [s36_4s4b[25][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[24][0]), "BS"]
# })

# m32_36M = bg.sequence_generator({
#     "S3" => [s36_4s4b[26][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[25][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[20][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[25][0]), "BS"]
# })

# m33_36M = bg.sequence_generator({
#     "S3" => [s36_4s4b[27][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[26][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[21][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[26][0]), "BS"]
# })

# m34_36M = bg.sequence_generator({
#     "S3" => [s36_4s4b[28][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[27][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[22][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[27][0]), "BS"]
# })

# m35_36M = bg.sequence_generator({
#     "S3" => [s36_4s4b[29][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[28][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[23][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[28][0]), "BS"]
# })

# m36_36M = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[29][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[24][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[29][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m1.csv")
# bg.to_csv(["Sequence"] + m2_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m2.csv")
# bg.to_csv(["Sequence"] + m3_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m3.csv")
# bg.to_csv(["Sequence"] + m4_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m4.csv")
# bg.to_csv(["Sequence"] + m5_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m5.csv")
# bg.to_csv(["Sequence"] + m6_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m6.csv")

# bg.to_csv(["Sequence"] + m7_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m7.csv")
# bg.to_csv(["Sequence"] + m8_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m8.csv")
# bg.to_csv(["Sequence"] + m9_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m9.csv")
# bg.to_csv(["Sequence"] + m10_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m10.csv")
# bg.to_csv(["Sequence"] + m11_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m11.csv")
# bg.to_csv(["Sequence"] + m12_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m12.csv")

# bg.to_csv(["Sequence"] + m13_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m13.csv")
# bg.to_csv(["Sequence"] + m14_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m14.csv")
# bg.to_csv(["Sequence"] + m15_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m15.csv")
# bg.to_csv(["Sequence"] + m16_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m16.csv")
# bg.to_csv(["Sequence"] + m17_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m17.csv")
# bg.to_csv(["Sequence"] + m18_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m18.csv")

# bg.to_csv(["Sequence"] + m19_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m19.csv")
# bg.to_csv(["Sequence"] + m20_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m20.csv")
# bg.to_csv(["Sequence"] + m21_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m21.csv")
# bg.to_csv(["Sequence"] + m22_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m22.csv")
# bg.to_csv(["Sequence"] + m23_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m23.csv")
# bg.to_csv(["Sequence"] + m24_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m24.csv")

# bg.to_csv(["Sequence"] + m25_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m25.csv")
# bg.to_csv(["Sequence"] + m26_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m26.csv")
# bg.to_csv(["Sequence"] + m27_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m27.csv")
# bg.to_csv(["Sequence"] + m28_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m28.csv")
# bg.to_csv(["Sequence"] + m29_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m29.csv")
# bg.to_csv(["Sequence"] + m30_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m30.csv")

# bg.to_csv(["Sequence"] + m31_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m31.csv")
# bg.to_csv(["Sequence"] + m32_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m32.csv")
# bg.to_csv(["Sequence"] + m33_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m33.csv")
# bg.to_csv(["Sequence"] + m34_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m34.csv")
# bg.to_csv(["Sequence"] + m35_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m35.csv")
# bg.to_csv(["Sequence"] + m36_36M, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/36M/m36.csv")


# 3x3x3M

# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S14 Score with 25% overlap only -- #{score_s14}"
# s14_4s4b, score_s14 = bg.best_sides_out_of("S14", 100, s14_4s4b, count=18, number=2, overlap=0.5, godmode=false)
# puts "S14 Score with 50% overlap allowed -- #{score_s14}"

# s25_4s4b, score_s25 = bg.best_sides_out_of("S25", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S25 Score with 25% overlap only -- #{score_s25}"

# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S36 Score with 25% overlap only -- #{score_s36}"
# s36_4s4b, score_s36 = bg.best_sides_out_of("S36", 100, s36_4s4b, count=18, number=2, overlap=0.5, godmode=false)
# puts "S36 Score with 50% overlap only -- #{score_s36}"


# m1a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m5a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m6a_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7a_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# m8a_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m9a_3x3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })


# m1b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0+6][0], "BS"],
#     "S2" => [s25_4s4b[0+4][0], "BS"],
#     "S3" => [s36_4s4b[0+6][0], "BS"]
# })

# m2b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1+6][0], "BS"],
#     "S2" => [s25_4s4b[1+4][0], "BS"],
#     "S3" => [s36_4s4b[1+6][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0+6][0]), "BS"]
# })

# m3b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2+6][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1+6][0]), "BS"]
# })

# m4b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[3+6][0], "BS"],
#     "S2" => [s25_4s4b[2+4][0], "BS"],
#     "S3" => [s36_4s4b[2+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0+6][0]), "BS"]
# })

# m5b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4+6][0], "BS"],
#     "S2" => [s25_4s4b[3+4][0], "BS"],
#     "S3" => [s36_4s4b[3+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2+6][0]), "BS"]
# })

# m6b_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[5+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3+6][0]), "BS"]
# })

# m7b_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[4+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3+6][0]), "BS"]
# })

# m8b_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[5+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4+6][0]), "BS"]
# })

# m9b_3x3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5+6][0]), "BS"]
# })

# m1c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0+6+6][0], "BS"],
#     "S2" => [s25_4s4b[0+4+4][0], "BS"],
#     "S3" => [s36_4s4b[0+6+6][0], "BS"]
# })

# m2c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1+6+6][0], "BS"],
#     "S2" => [s25_4s4b[1+4+4][0], "BS"],
#     "S3" => [s36_4s4b[1+6+6][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0+6+6][0]), "BS"]
# })

# m3c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2+6+6][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1+6+6][0]), "BS"]
# })

# m4c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[3+6+6][0], "BS"],
#     "S2" => [s25_4s4b[2+4+4][0], "BS"],
#     "S3" => [s36_4s4b[2+6+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0+6+6][0]), "BS"]
# })

# m5c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4+6+6][0], "BS"],
#     "S2" => [s25_4s4b[3+4+4][0], "BS"],
#     "S3" => [s36_4s4b[3+6+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1+6+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0+4+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2+6+6][0]), "BS"]
# })

# m6c_3x3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[5+6+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2+6+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1+4+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3+6+6][0]), "BS"]
# })

# m7c_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[4+6+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3+6+6][0]), "BS"]
# })

# m8c_3x3x3 = bg.sequence_generator({
#     "S3" => [s36_4s4b[5+6+6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4+6+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2+4+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4+6+6][0]), "BS"]
# })

# m9c_3x3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[5+6+6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3+4+4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5+6+6][0]), "BS"]
# })


# z_3x3x3_4h_tail_bonds, z_score = bg.best_z_bonds_out_of(2, 18, "TAIL", 0.5, 500)
# z_3x3x3_4h_head_bonds = bg.z_complement_side(z_3x3x3_4h_tail_bonds)

# puts z_score

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
# m7a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])
# m8a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[7]) + bg.add_z_bonds("HEAD", [])
# m9a_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[8]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[9]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[0])
# m2b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[10]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[1])
# m3b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[11]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[2])
# m4b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[12]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[3])
# m5b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[13]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[4])
# m6b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[14]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[5])
# m7b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[15]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[6])
# m8b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[16]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[7])
# m9b_z_seqs = bg.add_z_bonds("TAIL", z_3x3x3_4h_tail_bonds[17]) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[8])

# m1c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[9])
# m2c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[10])
# m3c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[11])
# m4c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[12])
# m5c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[13])
# m6c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[14])
# m7c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[15])
# m8c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[16])
# m9c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_3x3x3_4h_head_bonds[17])


# m1a_3x3x3 = m1a_3x3x3 + m1a_z_seqs
# m2a_3x3x3 = m2a_3x3x3 + m2a_z_seqs
# m3a_3x3x3 = m3a_3x3x3 + m3a_z_seqs
# m4a_3x3x3 = m4a_3x3x3 + m4a_z_seqs
# m5a_3x3x3 = m5a_3x3x3 + m5a_z_seqs
# m6a_3x3x3 = m6a_3x3x3 + m6a_z_seqs
# m7a_3x3x3 = m7a_3x3x3 + m7a_z_seqs
# m8a_3x3x3 = m8a_3x3x3 + m8a_z_seqs
# m9a_3x3x3 = m9a_3x3x3 + m9a_z_seqs

# m1b_3x3x3 = m1b_3x3x3 + m1b_z_seqs
# m2b_3x3x3 = m2b_3x3x3 + m2b_z_seqs
# m3b_3x3x3 = m3b_3x3x3 + m3b_z_seqs
# m4b_3x3x3 = m4b_3x3x3 + m4b_z_seqs
# m5b_3x3x3 = m5b_3x3x3 + m5b_z_seqs
# m6b_3x3x3 = m6b_3x3x3 + m6b_z_seqs
# m7b_3x3x3 = m7b_3x3x3 + m7b_z_seqs
# m8b_3x3x3 = m8b_3x3x3 + m8b_z_seqs
# m9b_3x3x3 = m9b_3x3x3 + m9b_z_seqs

# m1c_3x3x3 = m1c_3x3x3 + m1c_z_seqs
# m2c_3x3x3 = m2c_3x3x3 + m2c_z_seqs
# m3c_3x3x3 = m3c_3x3x3 + m3c_z_seqs
# m4c_3x3x3 = m4c_3x3x3 + m4c_z_seqs
# m5c_3x3x3 = m5c_3x3x3 + m5c_z_seqs
# m6c_3x3x3 = m6c_3x3x3 + m6c_z_seqs
# m7c_3x3x3 = m7c_3x3x3 + m7c_z_seqs
# m8c_3x3x3 = m8c_3x3x3 + m8c_z_seqs
# m9c_3x3x3 = m9c_3x3x3 + m9c_z_seqs

# bg.to_csv(["Sequence"] + m1a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/1a.csv")
# bg.to_csv(["Sequence"] + m2a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/2a.csv")
# bg.to_csv(["Sequence"] + m3a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/3a.csv")
# bg.to_csv(["Sequence"] + m4a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/4a.csv")
# bg.to_csv(["Sequence"] + m5a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/5a.csv")
# bg.to_csv(["Sequence"] + m6a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/6a.csv")
# bg.to_csv(["Sequence"] + m7a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/7a.csv")
# bg.to_csv(["Sequence"] + m8a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/8a.csv")
# bg.to_csv(["Sequence"] + m9a_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/9a.csv")

# bg.to_csv(["Sequence"] + m1b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/1b.csv")
# bg.to_csv(["Sequence"] + m2b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/2b.csv")
# bg.to_csv(["Sequence"] + m3b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/3b.csv")
# bg.to_csv(["Sequence"] + m4b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/4b.csv")
# bg.to_csv(["Sequence"] + m5b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/5b.csv")
# bg.to_csv(["Sequence"] + m6b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/6b.csv")
# bg.to_csv(["Sequence"] + m7b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/7b.csv")
# bg.to_csv(["Sequence"] + m8b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/8b.csv")
# bg.to_csv(["Sequence"] + m9b_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/9b.csv")

# bg.to_csv(["Sequence"] + m1c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/1c.csv")
# bg.to_csv(["Sequence"] + m2c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/2c.csv")
# bg.to_csv(["Sequence"] + m3c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/3c.csv")
# bg.to_csv(["Sequence"] + m4c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/4c.csv")
# bg.to_csv(["Sequence"] + m5c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/5c.csv")
# bg.to_csv(["Sequence"] + m6c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/6c.csv")
# bg.to_csv(["Sequence"] + m7c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/7c.csv")
# bg.to_csv(["Sequence"] + m8c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/8c.csv")
# bg.to_csv(["Sequence"] + m9c_3x3x3, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/3x3x3/9c.csv")
