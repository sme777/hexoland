require 'set'

def compute_overlap_score(four_bond_systems, two_bond_systems)
    # Flatten and normalize bonds in the four-bond systems
    normalized_four_bonds = four_bond_systems.flatten.map do |bond|
      if bond.is_a?(Array)
        bond.flatten.join('_')  # Convert array to string
      else
        bond  # Bond is already a string
      end
    end
  
    # Flatten and normalize bonds in the two-bond systems
    normalized_two_bonds = two_bond_systems.flatten.map do |bond|
      if bond.is_a?(Array)
        bond.flatten.join('_')  # Convert array to string
      else
        bond  # Bond is already a string
      end
    end
  
    # Convert to sets for efficient comparison
    four_bond_set = normalized_four_bonds.to_set
    two_bond_set = normalized_two_bonds.to_set
  
    # Calculate the intersection and union
    intersection = four_bond_set & two_bond_set
    union = four_bond_set | two_bond_set
  
    # Calculate the Jaccard Index
    if union.size > 0
      overlap_score = intersection.size.to_f / union.size.to_f
    else
      overlap_score = 0.0
    end
  
    overlap_score
end
# Example usage:



# For Z bonds
puts "Bond comparison for Z"

# Define a four-bond system (array of 4 bonds)
four_bond_system = [["H1_H2", "H12_H13", "H66_H67", "H16_H17"], [["H35_H36", "H37_H38"], "H8_H9", ["H21_H22", "H23_H24"], "H16_H17"], [["H35_H36", "H37_H38"], "H12_H13", "H62_H63", ["H55", "H53_H54"]], ["H34_H3", "H44_H45", ["H21_H22", "H23_H24"], "H50_H51"], ["H1_H2", "H10_H11", ["H27", "H25_H26"], "H58_H59"], ["H4_H5", "H48_H49", "H66_H67", "H50_H51"], ["H4_H5", "H44_H45", "H62_H63", ["H18", "H19_H20"]]]

# Define a two-bond system (array of 2 bonds)
two_bond_system_opt = [["H10_H11", "H34_H3"], ["H8_H9", ["H27", "H25_H26"]], ["H1_H2", "H48_H49"], ["H34_H3", "H58_H59"], ["H4_H5", ["H18", "H19_H20"]], [["H35_H36", "H37_H38"], ["H55", "H53_H54"]], ["H10_H11", "H66_H67"]]
two_bond_system = [["H66_H67", "H58_H59"], [["H35_H36", "H37_H38"], "H8_H9"], [["H21_H22", "H23_H24"], "H12_H13"], ["H34_H3", "H44_H45"], ["H66_H67", "H16_H17"], [["H27", "H25_H26"], "H10_H11"], ["H4_H5", ["H18", "H19_H20"]]]
# Compute the normalized overlap score
overlap_score1 = compute_overlap_score(four_bond_system, two_bond_system_opt)

overlap_score2 = compute_overlap_score(four_bond_system, two_bond_system)

puts "Normalized Overlap Score for Optimized: #{overlap_score1.round(2)}"

puts "Normalized Overlap Score: #{overlap_score2.round(2)}"

puts "\n"

# For S14 bonds

puts "Bond comparison for XY Side 14"


# Define a four-bond system (array of 4 bonds)
four_bond_system = [["H60_R_P", "H60_L_P", "H57_R_P", "H57_L_S"], ["H61_L_P", "H61_R_P", "H56_L_S", "H57_R_P"], ["H61_L_S", "H60_R_P", "H56_R_S", "H56_L_P"], ["H60_L_S", "H60_R_S", "H56_L_P", "H57_R_S"], ["H61_L_P", "H61_R_S", "H57_L_S", "H57_R_S"], ["H60_L_P", "H61_R_S", "H56_R_P", "H56_L_P"], ["H60_L_S", "H61_R_S", "H56_R_S", "H57_L_P"], ["H61_L_S", "H61_R_P", "H56_R_P", "H57_L_S"]]

# Define a two-bond system (array of 2 bonds)
two_bond_system_opt = [["H56_L_S", "H60_R_S"], ["H57_L_P", "H60_L_S"], ["H56_L_S", "H61_L_S"], ["H57_L_P", "H60_L_P"], ["H56_R_S", "H61_L_P"], ["H57_R_S", "H60_R_S"]]
two_bond_system = [["H61_L_P", "H56_R_P"], ["H61_L_S", "H56_R_S"], ["H61_R_S", "H57_L_P"], ["H60_R_S", "H56_L_S"], ["H60_R_P", "H57_R_S"], ["H60_L_S", "H57_R_P"]]
# Compute the normalized overlap score
overlap_score1 = compute_overlap_score(four_bond_system, two_bond_system_opt)

overlap_score2 = compute_overlap_score(four_bond_system, two_bond_system)

puts "Normalized Overlap Score for Optimized: #{overlap_score1.round(2)}"

puts "Normalized Overlap Score: #{overlap_score2.round(2)}"
puts "\n"
# For S25 bonds

puts "Bond comparison for XY Side 25"


# Define a four-bond system (array of 4 bonds)
four_bond_system = [["H53_R_S", "H54_L_P", "H49_R_P", "H50_L_P"], ["H53_L_P", "H53_R_P", "H49_L_S", "H50_R_S"], ["H53_R_P", "H54_L_S", "H50_L_P", "H50_R_P"], ["H54_R_P", "H53_L_S", "H50_R_S", "H49_L_P"], ["H53_L_P", "H54_R_S", "H49_R_S", "H49_L_P"], ["H54_L_P", "H54_R_S", "H50_R_P", "H49_L_S"], ["H54_L_P", "H53_R_P", "H49_R_S", "H50_L_S"], ["H54_L_S", "H54_R_P", "H50_L_S", "H49_R_P"]]

# Define a two-bond system (array of 2 bonds)
two_bond_system_opt = [["H50_L_S", "H53_L_S"], ["H49_L_S", "H53_R_S"], ["H50_L_P", "H54_L_S"], ["H49_L_P", "H53_L_S"], ["H50_R_S", "H53_L_P"], ["H49_R_S", "H54_R_S"]]
two_bond_system = [["H53_R_P", "H49_R_S"], ["H54_L_P", "H49_L_S"], ["H53_L_S", "H50_L_S"], ["H53_L_P", "H50_R_P"], ["H54_R_S", "H49_L_P"], ["H54_R_P", "H50_R_S"]]
# Compute the normalized overlap score
overlap_score1 = compute_overlap_score(four_bond_system, two_bond_system_opt)

overlap_score2 = compute_overlap_score(four_bond_system, two_bond_system)

puts "Normalized Overlap Score for Optimized: #{overlap_score1.round(2)}"

puts "Normalized Overlap Score: #{overlap_score2.round(2)}"

puts "\n"

# For S36 bonds

puts "Bond comparison for XY Side 36"


# Define a four-bond system (array of 4 bonds)
four_bond_system = [["H42_R_P", "H42_L_P", "H46_L_S", "H47_R_P"], ["H43_L_S", "H42_R_S", "H47_R_S", "H46_L_S"], ["H42_R_P", "H43_L_P", "H47_R_S", "H47_L_S"], ["H43_R_S", "H43_L_P", "H46_R_P", "H46_L_S"], ["H43_L_P", "H42_R_S", "H47_R_P", "H47_L_P"], ["H42_R_P", "H43_L_S", "H47_L_P", "H46_R_P"], ["H42_L_P", "H43_R_S", "H47_R_S", "H46_L_P"], ["H42_L_S", "H43_R_S", "H46_R_S", "H47_L_P"]]

# Define a two-bond system (array of 2 bonds)
two_bond_system_opt = [["H43_R_P", "H47_L_S"], ["H42_L_S", "H46_L_P"], ["H43_R_P", "H46_R_S"], ["H42_L_S", "H47_L_S"], ["H43_L_S", "H46_L_P"], ["H42_L_P", "H46_R_S"]]
two_bond_system = [["H42_L_P", "H47_L_P"], ["H43_R_P", "H46_R_P"], ["H42_R_P", "H47_R_P"], ["H42_R_S", "H46_R_S"], ["H43_L_P", "H47_L_S"], ["H43_R_S", "H47_R_S"]]
# Compute the normalized overlap score
overlap_score1 = compute_overlap_score(four_bond_system, two_bond_system_opt)

overlap_score2 = compute_overlap_score(four_bond_system, two_bond_system)

puts "Normalized Overlap Score for Optimized: #{overlap_score1.round(2)}"

puts "Normalized Overlap Score: #{overlap_score2.round(2)}"