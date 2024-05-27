require 'set'
require 'csv'

class BondGenerator

    
    def initialize
        @bond_map = {}
        CSV.foreach(Rails.root.join("app/assets/sequences/bond.csv")) do |row|
            @bond_map[row[0]] = row[1]
        end
    end

    ### Compute Free Eneregy of a the Given Sequence ###
    def BondGenerator.fe_of(seq)
        fe = 0
        seq.split("").each_with_index do |nt, idx|
            break unless idx != seq.size - 1
            fe += BondGenerator.nn["#{seq[idx]}#{seq[idx+1]}"]
        end
        fe.round(4)
    end

    ### Sum Free Eneregies of a the Given Bonds ###
    def sum_fes_of(bonds)
        fe_sum = 0
        bonds.each do |bond|
            fe_sum += BondGenerator.bond2gibbs[bond]
        end
        fe_sum.round(4)
    end

    def randomize_sides(side, number, godmode=false)
        if number == 1
            if side == "S14"
                return group_randomizer(BondGenerator.singles_s14_sides[0], number) + group_randomizer(BondGenerator.singles_s14_sides[1], number)
            elsif side == "S25"
                return group_randomizer(BondGenerator.singles_s25_sides[0], number) + group_randomizer(BondGenerator.singles_s25_sides[1], number)
            elsif side == "S36"
                return group_randomizer(BondGenerator.singles_s36_sides[0], number) + group_randomizer(BondGenerator.singles_s36_sides[1], number)
            end
        else
            if godmode
                if side == "S14"
                    return group_randomizer(BondGenerator.s14_sides[0] + BondGenerator.s14_sides[1], number*2) 
                elsif side == "S25"
                    return group_randomizer(BondGenerator.s25_sides[0] + BondGenerator.s25_sides[1], number*2)
                elsif side == "S36"
                    return group_randomizer(BondGenerator.s36_sides[0] + BondGenerator.s36_sides[1], number*2)
                end
            else
                if side == "S14"
                    return group_randomizer(BondGenerator.s14_sides[0], number) + group_randomizer(BondGenerator.s14_sides[1], number) 
                elsif side == "S25"
                    return group_randomizer(BondGenerator.s25_sides[0], number) + group_randomizer(BondGenerator.s25_sides[1], number)
                elsif side == "S36"
                    return group_randomizer(BondGenerator.s36_sides[0], number) + group_randomizer(BondGenerator.s36_sides[1], number)
                end
            end

        end
    end

    def group_randomizer(elements, number)
        random_samples = []
        while random_samples.size != number
            random_element = elements.sample
            ### Only filter out poral bonds when number is equal to 2 ###
            if number == 2
                variant1 = random_element[0] + (random_element[1, 3].to_i + 1).to_s + random_element.slice(3) + random_element.slice(4)
                variant2 = random_element[0] + (random_element[1, 3].to_i - 1).to_s + random_element.slice(3) + random_element.slice(4)
            else
                variant1 = ""
                variant2 = ""
            end
            should_add = true
            random_samples.each do |selected|
                if selected[0, 5] == variant1 || selected[0, 5] == variant2 || selected[0, 6] == random_element[0, 6] #|| 
                    # (number == 3 && BondGenerator.exception_pairs[selected[0, 5]].nil?)
                    should_add = false
                    break
                end   
            end
            random_samples << random_element unless !should_add
        end
        random_samples
    end

    def best_sides_out_of(side, samples=10, reference=[], count=1, number=4, max_overlap=0.5, godemode=False, min_strength=0.0, max_strength=110.0)
        sample_map = sample_sides(side, samples, reference, count, number, max_overlap, godemode, min_strength, max_strength)
        best_sample = []
        best_sample_score = Float::INFINITY
        sample_map.each do |sample|
            if sample[1] < best_sample_score
                best_sample = sample[0]
                best_sample_score = sample[1]
            end
        end
        [best_sample, best_sample_score]
    end

    def sample_sides(side, samples=10, reference=[], count=1, number=4, max_overlap=0.5, godemode=false, min_strength=0.0, max_strength=110.0)
        sample_map = []
        samples.times do |_|
            sides = generate_sides(side, reference, count, number, max_overlap, godemode)
            sides_sim_mad = compute_similiarity_matrix(sides)
            assembly_rows, assmebly_score = compute_assembly_score(sides_sim_mad)
            sample_map << [sides, assmebly_score]
        end
        sample_map
    end

    def generate_picklist(sequences, volumes, wells)

    end

    def build_from_neighbors(neighbor_map)
        # Stores sequence list for each monomer
        block_sequences = {}
        # Stores neighbor map for information
        block_neighbors = {}
        # Count of each side
        s14_side_count, s25_side_count, s36_side_count = 0, 0, 0
        neighbor_map.each do |block, neighbors|
            block_sequences[block] = []
            neighbors.each do |side, neighbor|
                block_neighbors[block] = {}
                if side == "S1"
                    s14_side_count += 1
                elsif side == "S2"
                    s25_side_count += 2
                elsif side == "S3"
                    s36_side_count += 3
                end
            end
        end

        ### Generate the Sides

        # Emperical Rules for the number of Trials  
        trials=5

        s14s, _ = best_sides_out_of("S14", trials, [], count=s14_side_count, number=2, overlap=0.25, godmode=false) unless s14_side_count == 0
        s25s, _ = best_sides_out_of("S25", trials, [], count=s25_side_count, number=2, overlap=0.25, godmode=false) unless s25_side_count == 0
        s36s, _ = best_sides_out_of("S36", trials, [], count=s36_side_count, number=2, overlap=0.25, godmode=false) unless s36_side_count == 0
        s14_idx, s25_idx, s36_idx = 0, 0, 0

        neighbor_map.each do |block, neighbors|
            neighbors.each do |side, neighbor|
                if side == "S1"
                    block_neighbors[block][side] = [s14s[s14_idx][0], "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s14s[s14_idx][0], "BS"]]
                    s14_idx += 1
                elsif side == "S2"
                    block_neighbors[block][side] = [s25s[s25_idx][0], "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s25s[s25_idx][0], "BS"]]
                    s25_idx += 1
                elsif side == "S3"
                    block_neighbors[block][side] = [s36s[s36_idx][0], "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s36s[s36_idx][0], "BS"]]
                    s36_idx += 1
                end
            end
        end

        neighbor_map.each do |block, neighbors|
            neighbors.each do |side, neighbor|
                
                if side == "S4"
                    s4_bonds = complement_side(block_neighbors[neighbor]["S1"][0])
                    block_neighbors[block][side] = [s4_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s4_bonds, "BS"]]
                elsif side == "S5"
                    s5_bonds = complement_side(block_neighbors[neighbor]["S2"][0])
                    block_neighbors[block][side] = [s5_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s5_bonds, "BS"]]
                elsif side == "S6"
                    s6_bonds = complement_side(block_neighbors[neighbor]["S3"][0])
                    block_neighbors[block][side] = [s6_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s6_bonds, "BS"]]
                end
            end
        end

        block_neighbors.each do |block, bonds|
            block_sequences[block] = sequence_generator(bonds)
        end


        neighbor_map.each do |block, neighbors|
            neighbor_map[block] = [block_sequences[block], neighbor_map[block]]
        end
        neighbor_map
    end

    #### Generate Side Bonds ####
    #############################
    ######## Parameters #########
    ### Side: S14, S25, S36 #####
    ### Count: # of bond sets ###
    ## Number: # of edge bonds ##
    # Overlap: max edge overlap #
    #############################
    #############################
    def generate_sides(side, reference=[], count=1, number=4, max_overlap=0.5, godmode=False, min_strength=0.0, max_strength=110.0)
        sides = reference.map(&:dup)
        current_count = reference.size
        capacity = count > 25 ? 1000 : 500
        while sides.size < count
            candidate = randomize_sides(side, number, godmode)
            next unless (min_strength < sum_fes_of(candidate) && sum_fes_of(candidate) < max_strength)
            side_overlap = false
            sides.each do |side|
                total_sum = 0
                unique_set = Set.new(candidate + side[0])
                unique_set.each do |x|
                    total_sum += (candidate + side[0]).count(x) - 1
                end
                overlap = total_sum.to_f / candidate.length
                if overlap > max_overlap
                    side_overlap = true
                    break
                end
            end

            # Accept Candidate
            if !side_overlap
                sides << [candidate, sum_fes_of(candidate)]
            end
            current_count += 1

            # Reset Sides if Stuck at Local Minima
            if current_count > capacity
                current_count = 0
                sides = []
            end
        end
        sides
    end

    def compute_similiarity_matrix(sides)
        sim_mat = []
        sides.each_with_index do |side1, idx1|
            side_vec = []
            sides.each_with_index do |side2, idx2|
                total_sum = 0
                unless idx1 == idx2
                    unique_set = Set.new(side1[0] + side2[0])
                    unique_set.each do |x|
                        total_sum += (side1[0] + side2[0]).count(x) - 1
                    end
                end
                side_vec << total_sum.to_f / side1[0].length
            end
            sim_mat << side_vec
        end
        sim_mat
    end

    def compute_assembly_score(assembly_matrix)
        items = assembly_matrix.size
        matrix_row_scores = []
        matrix_score = 0 
        assembly_matrix.each do |row|
            row_sum = 0
            row.each do |col|
                row_sum += col
            end
            row_sum /= items
            matrix_row_scores << row_sum
            matrix_score +=  row_sum
        end
        matrix_score /= matrix_row_scores.size
        [matrix_row_scores, matrix_score]
    end


    def sequence_generator(hex)
        seq_arr = []
        BondGenerator.sides.each do |side|
            if hex[side].nil?
                seq_arr << add_blockers(side)
            else
                seq_arr << add_bonds(side, hex[side][0], hex[side][1])
                seq_arr << add_neutrals(side, hex[side][0], hex[side][1])
            end
        end
        seq_arr.flat_map { |sublist| Array(sublist) }.uniq
    end

    def add_neutrals(side, bonds, type)
        neutral_seqs = []
        BondGenerator.orbitals[side].each do |orbital|
            next unless !bonds.any? { |bond| bond.include?(orbital) }
            if !BondGenerator.exception_pairs.keys.include?(orbital)
                neutral_seqs << @bond_map["#{orbital}_#{type}"]
            else
                pair = BondGenerator.exception_pairs[orbital.slice(0, 5)]
                next if bonds.any? { |bond| bond.include?(pair) }
                if !@bond_map["#{orbital}_#{type}_AND_#{pair}_#{type}"].nil?
                    neutral_seqs << @bond_map["#{orbital}_#{type}_AND_#{pair}_#{type}"]
                elsif !@bond_map["#{pair}_#{type}_AND_#{orbital}_#{type}"].nil?
                    neutral_seqs << @bond_map["#{pair}_#{type}_AND_#{orbital}_#{type}"]
                else
                    # puts "lol: #{orbital}, #{pair}"
                end

            end


        end
        neutral_seqs
    end

    #### Add Blockers (poly-T) for Passive Side ####
    ################################################
    ################ Parameters ####################
    ############## Side: S14, S25, S36 #############
    ################################################
    ################################################
    def add_blockers(side)
        blocker_seqs = []
        blocker_map = {
            "S1" => ["H61", "H60", "H57", "H56"],
            "S2" => ["H54", "H53", "H50", "H49"],
            "S3" => ["H47", "H46", "H43", "H42"],
            "S4" => ["H35", "H36", "H39", "H40"],
            "S5" => ["H70", "H71", "H32", "H33"],
            "S6" => ["H68", "H67", "H64", "H63"]
        }

        exceptions = {
            "S1" => ["H60_R_B_AND_H61_R_B"],
            "S2" => [],
            "S3" => ["H42_L_B_AND_H43_L_B", "H46_L_B_AND_H47_L_B"],
            "S4" => [],
            "S5" => ["H71_L_B_AND_H70_L_B", "H33_L_B_AND_H32_L_B"],
            "S6" => []
        }

        blocker_map[side].each do |helix| 
            blocker_seqs << @bond_map["#{helix}_L_B"] unless @bond_map["#{helix}_L_B"].nil?
            blocker_seqs << @bond_map["#{helix}_R_B"] unless @bond_map["#{helix}_R_B"].nil?
        end

        exceptions[side].each do |exception|
            blocker_seqs << @bond_map[exception]
        end
        blocker_seqs
    end


    ### Add XY Bonds (6nt default) for Active Side ###
    ##################################################
    ################# Parameters #####################
    ############## Side: S14, S25, S36 ###############
    ##################################################
    ##################################################
    def add_bonds(side, bonds, type)
        bond_seqs = []
        bonds.each do |bond|
            if !@bond_map[bond].nil?
                bond_seqs << @bond_map[bond]
            else
                pair = BondGenerator.exception_pairs[bond.slice(0, 5)]                
                exists = bonds.find { |b| b.include?(pair) } || nil
                if !exists.nil?
                    bond_seqs << @bond_map["#{bond}_AND_#{exists}"] unless @bond_map["#{bond}_AND_#{exists}"].nil?
                    bond_seqs << @bond_map["#{exists}_AND_#{bond}"] unless @bond_map["#{exists}_AND_#{bond}"].nil?
                else
                    bond_seqs << @bond_map["#{bond}_AND_#{pair}_#{type}"] unless @bond_map["#{bond}_AND_#{pair}_#{type}"].nil?
                    bond_seqs << @bond_map["#{pair}_#{type}_AND_#{bond}"] unless @bond_map["#{pair}_#{type}_AND_#{bond}"].nil?
                end
            end
        end
        bond_seqs
    end

    def z_bond_sampler(count, number, side, max_overlap)
        all_edges = side == "TAIL" ? BondGenerator.tail_z_helices : BondGenerator.head_z_helices
        random_samples = []
        while random_samples.size  != number
            random_helices = all_edges.sample(count).flatten
            should_add = true

            random_samples.each do |sample|
                total_sum = 0
                random_helices.each do |helix|
                    if sample.include?(helix)
                        total_sum += 1
                    end
                end
                overlap = total_sum.to_f / random_helices.size
                if overlap > max_overlap
                    should_add = false
                    break
                end
            end

            if should_add
                
                random_samples << random_helices
            end
        end
        random_samples
    end


    def compute_z_bond_matrix(bonds)
        sim_mat = []
        bonds.each_with_index do |block_bonds, idx1|
            sim_vec = []
            bonds.each_with_index do |orthogonal_bonds, idx2|
                total_sum = 0
                unless idx1 == idx2
                    unique_set = Set.new(block_bonds + orthogonal_bonds)
                    unique_set.each do |x|
                        total_sum += (block_bonds + orthogonal_bonds).count(x) - 1
                    end
                end
                sim_vec << (total_sum.to_f / block_bonds.size).round(3)
            end
            sim_mat << sim_vec
        end
        sim_mat
    end

    def best_z_bonds_out_of(bond_size, bond_quantity, side, max_overlap, trials)
        
        sample_map = sample_z_bonds(bond_size, bond_quantity, side, max_overlap, trials)
        best_sample = []
        best_sample_score = Float::INFINITY
        sample_map.each do |sample|
            if sample[1] < best_sample_score
                best_sample = sample[0]
                best_sample_score = sample[1]
            end
        end
        [best_sample, best_sample_score]
    end

    def sample_z_bonds(bond_size, bond_quantity, side, max_overlap, trials)
        sample_map = []
        trials.times do |_|
            bonds = z_bond_sampler(bond_size, bond_quantity, side, max_overlap)
            bonds_sim_mat = compute_z_bond_matrix(bonds)
            assembly_rows, assmebly_score = compute_assembly_score(bonds_sim_mat)
            sample_map << [bonds, assmebly_score]
        end
        sample_map
    end


    ### Add Z Bonds (6nt default) for Active Side ###
    #################################################
    ################# Parameters ####################
    ############### Side: TAIL or HEAD ##############
    ############  Bonds: list of helices ############
    #################################################
    #################################################
    def add_z_bonds(side, bonds)
        all_z_bonds = []
        bonds.each do |bond|
            all_z_bonds << @bond_map["#{bond}_Z_#{side}"]
        end

        all_edges = side == "TAIL" ? BondGenerator.tail_z_helices : BondGenerator.head_z_helices

        all_edges.each do |helix_group|
            if helix_group.kind_of?(Array)
                puts "#{helix_group[0]}_Z_#{side}_P" if @bond_map["#{helix_group[0]}_Z_#{side}_P"].nil?
                puts "#{helix_group[1]}_Z_#{side}_P" if @bond_map["#{helix_group[1]}_Z_#{side}_P"].nil?
                all_z_bonds << @bond_map["#{helix_group[0]}_Z_#{side}_P"] unless bonds.include?(helix_group[0])
                all_z_bonds << @bond_map["#{helix_group[1]}_Z_#{side}_P"] unless bonds.include?(helix_group[1])
            else
                puts "#{helix_group}_Z_#{side}_P" if @bond_map["#{helix_group}_Z_#{side}_P"].nil?
                all_z_bonds << @bond_map["#{helix_group}_Z_#{side}_P"] unless bonds.include?(helix_group)
            end
        end
        all_z_bonds
    end

    def complement_side(selection)
        helix_comp = {
            "H61" => "H35",
            "H60" => "H36",
            "H57" => "H39",
            "H56" => "H40",
            "H42" => "H68",
            "H43" => "H67",
            "H46" => "H64",
            "H47" => "H63",
            "H54" => "H70",
            "H53" => "H71",
            "H50" => "H32",
            "H49" => "H33"
        }
    
        plug2socket = {
            "P" => "S",
            "S" => "P"
        }

        selection.map { |s| helix_comp[s[0, 3]] + s[3, 3] + plug2socket[s[-1]] }
    end

    def z_complement_side(selection)
        comp_selection = []
        selection.each do |group|
            group_selection = []
            group.each do |helix|
                group_selection << BondGenerator.tail2head[helix]
            end
            comp_selection << group_selection.flatten.uniq
        end
        comp_selection
    end

    def to_csv(seqs, path)
        CSV.open(path, 'w') do |csv|
            seqs.each do |s|
              csv << [s]
            end
        end
    end

    def draw_matrix(matrix)
        matrix.each do |row|
          puts row.join(" ")
        end
    end
      

    def self.exception_pairs
        {
            "H71_L" => "H70_L",
            "H70_L" => "H71_L",
            "H33_L" => "H32_L",
            "H32_L" => "H33_L",
            "H60_R" => "H61_R",
            "H61_R" => "H60_R",
            "H42_L" => "H43_L",
            "H43_L" => "H42_L",
            "H46_L" => "H47_L",
            "H47_L" => "H46_L",
        }
    end

    def self.orbitals
        {
            "S1" => ["H61_R", "H61_L", "H60_R", "H60_L", "H57_R", "H57_L", "H56_R", "H56_L"],
            "S2" => ["H54_R", "H54_L", "H53_R", "H53_L", "H50_R", "H50_L", "H49_R", "H49_L"],
            "S3" => ["H47_R", "H47_L", "H46_R", "H46_L", "H43_R", "H43_L", "H42_R", "H42_L"],
            "S4" => ["H35_R", "H35_L", "H36_R", "H36_L", "H39_R", "H39_L", "H40_R", "H40_L"],
            "S5" => ["H70_R", "H70_L", "H71_R", "H71_L", "H32_R", "H32_L", "H33_R", "H33_L"],
            "S6" => ["H68_R", "H68_L", "H67_R", "H67_L", "H64_R", "H64_L", "H63_R", "H63_L"]
        }
    end

    def self.tail_z_helices
        ["H1_H2", "H16_H17", ["H35_H36", "H37_H38"], "H44_H45", "H58_H59", "H66_H67", 
        "H62_H63", "H48_H49", "H34_H3", "H12_H13", "H10_H11", "H8_H9", "H4_H5", "H50_H51", 
        ["H55", "H53_H54"], ["H27", "H25_H26"], ["H21_H22", "H23_H24"], ["H18", "H19_H20"]]
    end

    def self.head_z_helices
        [["H67_H68", "H66_H65"], "H58_H59", "H44_H45", "H36_H37", "H16_H17", "H1_H2",
        "H34_H3", "H48_H49", "H12_H13", "H10_H11", "H8_H9", "H4_H5", ["H63_H64", "H62"],
        "H26_H27", "H54_H55", ["H22", "H23_H24"], ["H18", "H19_H20"],  "H50_H51"]
    end

    def self.tail2head
        {
            "H1_H2" => "H1_H2",
            "H16_H17" => "H16_H17",
            "H35_H36" => "H36_H37",
            "H37_H38" => "H36_H37",
            "H44_H45" => "H44_H45",
            "H58_H59" => "H58_H59",
            "H66_H67" => ["H67_H68", "H66_H65"],
            "H62_H63" => ["H63_H64", "H62"],
            "H48_H49" => "H48_H49",
            "H34_H3" => "H34_H3",
            "H12_H13" => "H12_H13",
            "H10_H11" => "H10_H11",
            "H8_H9" => "H8_H9",
            "H4_H5" => "H4_H5",
            "H50_H51" => "H50_H51",
            "H55" => "H54_H55",
            "H53_H54" => "H54_H55",
            "H27" => "H26_H27",
            "H25_H26" => "H26_H27",
            "H21_H22" => ["H22", "H23_H24"],
            "H23_H24" => ["H22", "H23_H24"],
            "H18" => ["H18", "H19_H20"],
            "H19_H20" => ["H18", "H19_H20"]
        }
    end

    def self.sides
        ["S1", "S2", "S3", "S4", "S5", "S6"]
    end

    def self.s36_sides
        [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"],
         ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
    end

    def self.s25_sides
        [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"],
         ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]]
    end

    def self.s14_sides
        [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"],
         ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]]
    end

    def self.singles_s36_sides
        [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P"], ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P"]]
    end

    def self.singles_s25_sides
        [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P"], ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P"]]
    end

    def self.singles_s14_sides
        [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P"], ["H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"]]
    end

    # def self.single_s36_sides
    #     [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"],
    #      ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
    # end

    # def self.single_s25_sides
    #     [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"],
    #      ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]]
    # end

    # def self.single_s14_sides
    #     [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"],
    #      ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]]
    # end

    def self.s36_helices
        ["H42", "H43", "H46", "H47"]
    end

    def self.s25_helices
        ["H54", "H53", "H50", "H49"]
    end

    def self.s14_helices
        ["H60", "H61", "H56", "H57"]
    end


    def self.nn
        {
            "AA" => 1.9,
            "AT" => 1.5,
            "AC" => 1.3,
            "AG" => 1.6,
            "TA" => 0.9,
            "TT" => 1.9,
            "TC" => 1.6,
            "TG" => 1.9,
            "CA" => 1.9,
            "CT" => 1.6,
            "CG" => 3.6,
            "CC" => 3.1,
            "GT" => 1.3,
            "GA" => 1.6,
            "GC" => 3.1,
            "GG" => 3.1
        }
    end

    def self.bond2gibbs
        {
            "H61_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H61_L_S"]),
            "H60_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H60_L_S"]),
            "H57_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H57_L_S"]),
            "H56_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H56_L_S"]),
            "H61_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H61_L_P"]),
            "H60_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H60_L_P"]),
            "H57_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H57_L_P"]),
            "H56_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H56_L_P"]),
            "H54_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H54_L_S"]),
            "H53_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H53_L_S"]),
            "H50_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H50_L_S"]),
            "H49_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H49_L_S"]),
            "H54_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H54_L_P"]),
            "H53_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H53_L_P"]),
            "H50_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H50_L_P"]),
            "H49_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H49_L_P"]),
            "H47_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H47_L_S"]),
            "H46_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H46_L_S"]),
            "H43_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H43_L_S"]),
            "H42_L_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H42_L_S"]),
            "H47_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H47_L_P"]),
            "H46_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H46_L_P"]),
            "H43_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H43_L_P"]),
            "H42_L_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H42_L_P"]),
            "H61_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H61_R_S"]),
            "H60_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H60_R_S"]),
            "H57_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H57_R_S"]),
            "H56_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H56_R_S"]),
            "H61_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H61_R_P"]),
            "H60_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H60_R_P"]),
            "H57_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H57_R_P"]),
            "H56_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H56_R_P"]),
            "H54_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H54_R_S"]),
            "H53_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H53_R_S"]),
            "H50_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H50_R_S"]),
            "H49_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H49_R_S"]),
            "H54_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H54_R_P"]),
            "H53_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H53_R_P"]),
            "H50_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H50_R_P"]),
            "H49_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H49_R_P"]),
            "H47_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H47_R_S"]),
            "H46_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H46_R_S"]),
            "H43_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H43_R_S"]),
            "H42_R_S" => BondGenerator.fe_of(BondGenerator.bond2sequence["H42_R_S"]),
            "H47_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H47_R_P"]),
            "H46_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H46_R_P"]),
            "H43_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H43_R_P"]),
            "H42_R_P" => BondGenerator.fe_of(BondGenerator.bond2sequence["H42_R_P"])
        }
    end

    def self.bond2sequence
        {
            "H61_L_S" => "TGATAAA",
            "H61_L_P" => "TCCTCAT",
            "H60_L_S" => "CATCGCC",
            "H60_L_P" => "TAAAGCC",
            "H57_L_S" => "GAGGAAG",
            "H57_L_P" => "AATAAGT",
            "H56_L_S" => "TTTTCAT",
            "H56_L_P" => "TTTAACG",
            "H54_L_S" => "CTTTTGC",
            "H54_L_P" => "GGGGGTA",
            "H53_L_S" => "AAGGCCG",
            "H53_L_P" => "ATAGTAA",
            "H50_L_S" => "GACAGCC",
            "H50_L_P" => "AACCGCC",
            "H49_L_S" => "TTCCACA",
            "H49_L_P" => "TCCCTCA",
            "H47_L_S" => "CGCCATA",
            "H47_L_P" => "CAGACCA",
            "H46_L_S" => "TCAGAAC",
            "H46_L_P" => "GGCGCAA",
            "H43_L_S" => "GACTCCT",
            "H43_L_P" => "TAACGCC",
            "H42_L_S" => "AGGCTGA",
            "H42_L_P" => "AAAAGGA",
            "H61_R_S" => "TGCGAAC",
            "H61_R_P" => "TCCGGCC",
            "H60_R_S" => "GAGTAGA",
            "H60_R_P" => "GGCAGCC",
            "H57_R_S" => "TGTACCA",
            "H57_R_P" => "AAACGAC",
            "H56_R_S" => "AAAACAT",
            "H56_R_P" => "CGTTGTA",
            "H54_R_S" => "AATATGA",
            "H54_R_P" => "ATTCATT",
            "H53_R_S" => "TATTCAA",
            "H53_R_P" => "CATAAAT",
            "H50_R_S" => "AACAAGA",
            "H50_R_P" => "GGTGGTG",
            "H49_R_S" => "GAATCGA",
            "H49_R_P" => "CACCGTC",
            "H47_R_S" => "CCAATAG",
            "H47_R_P" => "GAGGTCA",
            "H46_R_S" => "GAACGCC",
            "H46_R_P" => "TTGATAA",
            "H43_R_S" => "CTTTCCG",
            "H43_R_P" => "TAATTCG",
            "H42_R_S" => "GCACCGC",
            "H42_R_P" => "CGCGTTT"
        }
    end
end
