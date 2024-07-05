require 'set'
require 'csv'

BOND_PATH = "/Users/samsonpetrosyan/Desktop/hexoland/app/assets/sequences/bond.csv"
BASIC_Z_PATH ="/Users/samsonpetrosyan/Desktop/hexoland/app/assets/sequences/basic_z.csv"

BOND_LINUX_PATH = "/home/spetrosyan/Desktop/hexoland/app/assets/sequences/bond.csv"
BASIC_Z_LINUX_PATH = "/home/spetrosyan/Desktop/hexoland/app/assets/sequences/basic_z.csv"

class BondGenerator

    
    def initialize
        @bond_map = {}
        @basic_zs= []
        CSV.foreach(BOND_PATH) do |row|
            @bond_map[row[0]] = row[1]
        end

        CSV.foreach(BASIC_Z_PATH) do |row|
            @basic_zs << row[1]
        end
        @basic_zs = @basic_zs[1..]
    end

    def get_basic_zs
        @basic_zs
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

    def randomize_sides(side, count, number, type="handles",godmode=false)
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
                    return type == "handles" ? 
                        group_randomizer(BondGenerator.s14_sides[0], number) + group_randomizer(BondGenerator.s14_sides[1], number) :
                        (count > 8 ? sample_from_hinges(BondGenerator.s14_hinges, false).flatten : sample_from_hinges(BondGenerator.s14_hinges, true).flatten)
                elsif side == "S25"
                    return type == "handles" ? 
                        group_randomizer(BondGenerator.s25_sides[0], number) + group_randomizer(BondGenerator.s25_sides[1], number) :
                        (count > 8 ? sample_from_hinges(BondGenerator.s25_hinges, false).flatten : sample_from_hinges(BondGenerator.s25_hinges, true).flatten)
                elsif side == "S36"
                    return type == "handles" ? 
                        group_randomizer(BondGenerator.s36_sides[0], number) + group_randomizer(BondGenerator.s36_sides[1], number) :
                        (count > 8 ? sample_from_hinges(BondGenerator.s36_hinges, false).flatten : sample_from_hinges(BondGenerator.s36_hinges, true).flatten)
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

    def sample_from_handles(elements, number)

    end

    def sample_from_hinges(elements, only_alternate=true)
        bonds = []
        group1, group2 = elements[0], elements[1]
        group1_bonds = group1.sample.map {|group| group.sample }
        group2_bonds = group2.sample.map {|group| group.sample }
        # p only_alternate
        if only_alternate
            # p group1_bonds
            # p "hi"
            while group1_bonds[0][4] == group2_bonds[0][4]
                group2_bonds = group2.sample.map {|group| group.sample }
            end
            bonds << group1_bonds
            bonds << group2_bonds
        else
            # while group1_bonds[0][4] != group2_bonds[0][4]
            #     group2_bonds = group2.sample.map {|group| group.sample }
            # end
            bonds << group1_bonds
            bonds << group2_bonds
        end
        bonds
    end

    def best_sides_out_of(side, type="handles", samples=10, reference=[], count=1, number=4, max_overlap=0.5, godemode=False, min_strength=0.0, max_strength=110.0)
        sample_map = sample_sides(side, type, samples, reference, count, number, max_overlap, godemode, min_strength, max_strength)
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

    def sample_sides(side, type="handles", samples=10, reference=[], count=1, number=4, max_overlap=0.5, godemode=false, min_strength=0.0, max_strength=110.0)
        sample_map = []
        samples.times do |_|
            sides = generate_sides(side, type, reference, count, number, max_overlap, godemode, min_strength, max_strength)
            sides_sim_mad = compute_similiarity_matrix(sides)
            assembly_rows, assmebly_score = compute_assembly_score(sides_sim_mad)
            sample_map << [sides, assmebly_score]
        end
        sample_map
    end

    def build_from_neighbors(neighbor_map)
        # Stores sequence list for each monomer
        block_sequences = {}
        # Stores neighbor map for information
        block_neighbors = {}
        # Count of each side
        s1_side_count, s2_side_count, s3_side_count = 0, 0, 0
        s4_side_count, s5_side_count, s6_side_count = 0, 0, 0
        z_tail_count, z_head_count = 0, 0
        neighbor_map.each do |block, neighbors|
            block_sequences[block] = []
            neighbors.each do |side, neighbor|
                block_neighbors[block] = {}
                if side == "S1"
                    s1_side_count += 1
                elsif side == "S2"
                    s2_side_count += 1
                elsif side == "S3"
                    s3_side_count += 1
                elsif side == "S4"
                    s4_side_count += 1
                elsif side == "S5"
                    s5_side_count += 1
                elsif side == "S6"
                    s6_side_count += 1
                elsif side == "ZU"
                    z_tail_count += 1
                elsif side == "ZD"
                    z_head_count += 1
                end
            end
        end

        ### Set S14, S25, S36 side count 
        s14_side_count, last_s14_idx = [s1_side_count, s4_side_count].max, [s1_side_count, s4_side_count].min
        s25_side_count, last_s25_idx = [s2_side_count, s5_side_count].max, [s2_side_count, s5_side_count].min
        s36_side_count, last_s36_idx = [s3_side_count, s6_side_count].max, [s3_side_count, s6_side_count].min
        z_count, last_z_idx = [z_tail_count, z_head_count].max, [z_tail_count, z_head_count].min
        ### Generate the Sides

        # Emperical Rules for the number of Trials  
        trials=5

        s14s, _ = best_sides_out_of("S14", "handles", trials, [], count=s14_side_count, number=2, overlap=0.25, godmode=false) unless s14_side_count == 0
        s25s, _ = best_sides_out_of("S25", "handles", trials, [], count=s25_side_count, number=2, overlap=0.25, godmode=false) unless s25_side_count == 0
        s36s, _ = best_sides_out_of("S36", "handles", trials, [], count=s36_side_count, number=2, overlap=0.25, godmode=false) unless s36_side_count == 0
        z_tails, _ = best_z_bonds_out_of(3, z_count, 0.51, 100) unless z_count == 0
        
        s14_idx, s25_idx, s36_idx, z_idx = 0, 0, 0, 0

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
                elsif side == "ZU"
                    # block_neighbors[block][side] = z_tails[z_idx][0]
                    neighbor_map[block][side] = [neighbor_map[block][side], z_tails[z_idx]]
                    z_idx += 1
                end
            end
        end

        curr_last_s14_idx_count, curr_last_s25_idx_count, curr_last_s36_idx_count = last_s14_idx, last_s25_idx, last_s36_idx
        curr_z_idx_count = last_z_idx

        neighbor_map.each do |block, neighbors|
            neighbors.each do |side, neighbor|
                
                if side == "S4"
                    if block_neighbors[neighbor].nil?
                        s4_bonds = complement_side(s14s[curr_last_s14_idx_count][0])
                        curr_last_s14_idx_count += 1
                    else
                        s4_bonds = complement_side(block_neighbors[neighbor]["S1"][0])
                    end
                    
                    block_neighbors[block][side] = [s4_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s4_bonds, "BS"]]
                elsif side == "S5"
                    if block_neighbors[neighbor].nil?
                        s5_bonds = complement_side(s25s[curr_last_s25_idx_count][0])
                        curr_last_s25_idx_count += 1
                    else
                        s5_bonds = complement_side(block_neighbors[neighbor]["S2"][0])
                    end

                    block_neighbors[block][side] = [s5_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s5_bonds, "BS"]]
                elsif side == "S6"
                    if block_neighbors[neighbor].nil?
                        s6_bonds = complement_side(s36s[curr_last_s36_idx_count][0])
                        curr_last_s36_idx_count += 1
                    else
                        s6_bonds = complement_side(block_neighbors[neighbor]["S3"][0])
                    end

                    block_neighbors[block][side] = [s6_bonds, "BS"]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s6_bonds, "BS"]]
                elsif side == "ZD"
                    if neighbor_map[neighbor].nil?
                        z_head = z_complement_side([z_tails[curr_z_idx_count]])
                        curr_z_idx_count += 1
                    else
                        z_head = z_complement_side([neighbor_map[neighbor]["ZU"][1]])
                    end
                    
                    neighbor_map[block][side] = [neighbor_map[block][side], z_head[0]]
                end
            end
        end

        block_neighbors.each do |block, bonds|
            block_sequences[block] = sequence_generator(bonds)
        end


        neighbor_map.each do |block, neighbors|
            all_seqs = block_sequences[block]
            include_z_bonds = neighbor_map[block].keys.include?("ZU") || neighbor_map[block].keys.include?("ZD")
            if include_z_bonds
                all_seqs += @basic_zs
            end

            if include_z_bonds && neighbor_map[block].keys.include?("ZU")
                all_seqs += add_z_bonds("TAIL", neighbor_map[block]["ZU"][1])
            else
                all_seqs += add_z_bonds("TAIL", [])
            end

            if include_z_bonds && neighbor_map[block].keys.include?("ZD")
                all_seqs += add_z_bonds("HEAD", neighbor_map[block]["ZD"][1])
            else
                all_seqs += add_z_bonds("HEAD", [])
            end

            neighbor_map[block] = [all_seqs, neighbor_map[block]]
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
    def generate_sides(face, type="handles",reference=[], count=1, number=4, max_overlap=0.5, godmode=False, min_strength=0.0, max_strength=110.0)
        sides = reference.map(&:dup)
        current_count = reference.size
        capacity = count > 25 ? 10000 : 500
        while sides.size < count
            candidate = randomize_sides(face, count, number, type, godmode)
            # p max_overlap
            next unless (min_strength < sum_fes_of(candidate) && sum_fes_of(candidate) < max_strength)
            side_overlap = false
            sides.each do |side|
                total_sum = 0
                unique_set = Set.new(candidate + side[0])
                unique_set.each do |x|
                    total_sum += (candidate + side[0]).count(x) - 1
                end
                overlap = total_sum.to_f / candidate.length
                if overlap > max_overlap || (type=="handles" && uneven_bonds_exist?(face, candidate, sides))
                    # p overlap
                    # p candidate, side[0]
                    # p unique_set, total_sum
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

    def uneven_bonds_exist?(side, candidate, sides)
        helix_pair1,  helix_pair2 = BondGenerator.helix_pairs[side]
        sides.each do |side|
            overlap_helices = []
            side[0].each do |bond1|
                candidate.each do |bond2|
                    overlap_helices << bond1 if bond1 == bond2
                end
            end

            
            if overlap_helices.size > 2
                return true
            end

            if overlap_helices.size > 1 && 
                (
                (overlap_helices.all? { |h| helix_pair1.include?(h) }) || 
                (overlap_helices.all? { |h| helix_pair2.include?(h) }) 
                )
                return true
            end
        end
        return false
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
                # if type == "B"
                #     # switch to open since T not available for exception pairs
                #     type = "S"
                # end
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
                    # if type == "B"
                    #     # switch to open since blocked not available for exception pairs
                    #     type = "S"
                    # end
                    bond_seqs << @bond_map["#{bond}_AND_#{pair}_#{type}"] unless @bond_map["#{bond}_AND_#{pair}_#{type}"].nil?
                    bond_seqs << @bond_map["#{pair}_#{type}_AND_#{bond}"] unless @bond_map["#{pair}_#{type}_AND_#{bond}"].nil?
                end
            end
        end
        bond_seqs
    end

    def z_bond_sampler(count, number, max_overlap)
        # all_edges = BondGenerator.tail_groups.map { |group| group.sample }
        random_samples = []
        while random_samples.size  != number
            random_helices = BondGenerator.tail_groups_4bonds.map {|group| group.sample }
            # random_helices = BondGenerator.tail_groups.map {|group| group.sample } # sample one per group
            # random_helices = BondGenerator.tail_z_helices.sample(count) # sample randomly
            # random_helices = BondGenerator.tail_groups.flatten.sample(count)
            # random_helices = BondGenerator.tail_groups_4bonds.map { |group| group.sample }.flatten
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

    def best_z_bonds_out_of(bond_size, bond_quantity, max_overlap, trials)
        
        sample_map = sample_z_bonds(bond_size, bond_quantity, max_overlap, trials)
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

    def sample_z_bonds(bond_size, bond_quantity, max_overlap, trials)
        sample_map = []
        trials.times do |_|
            bonds = z_bond_sampler(bond_size, bond_quantity, max_overlap)
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
            if bond.is_a?(Array)
                bond.each do |b|
                    all_z_bonds << @bond_map["#{b}_Z_#{side}"]
                end
            else
                all_z_bonds << @bond_map["#{bond}_Z_#{side}"]
            end
        end
        all_edges = side == "TAIL" ? BondGenerator.tail_z_helices : BondGenerator.head_z_helices

        all_edges.each do |helix_group|
            if helix_group.kind_of?(Array)
                puts "#{helix_group[0]}_Z_#{side}_P" if @bond_map["#{helix_group[0]}_Z_#{side}_P"].nil?
                puts "#{helix_group[1]}_Z_#{side}_P" if @bond_map["#{helix_group[1]}_Z_#{side}_P"].nil?
                all_z_bonds << @bond_map["#{helix_group[0]}_Z_#{side}_P"] unless bonds.flatten.include?(helix_group[0])
                all_z_bonds << @bond_map["#{helix_group[1]}_Z_#{side}_P"] unless bonds.flatten.include?(helix_group[1])
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
                if helix.is_a?(Array)
                    group_selection << BondGenerator.tail2head[helix[0]]
                else
                    group_selection << BondGenerator.tail2head[helix]
                end
                
            end
            comp_selection << group_selection.flatten.uniq
        end
        comp_selection
    end

    def recover_bonds(seqs)
        bonds = []
        seqs.each do |seq|
            # p seq
            bond = @bond_map.invert[seq]
            # p bond
            next if bond.nil? || bond[-1] == "P"
            bonds << bond
        end
        bonds[1..-1]
    end

    def recover_only_z_bonds(seqs)
        all_bonds = recover_bonds(seqs)
        z_bonds = []
        all_bonds.each do |bond|
            if bond.include?("Z")
                z_bonds << bond
            end
        end
        z_bonds
    end

    def to_csv(seqs, path)
        CSV.open(path, 'w') do |csv|
            seqs.each do |s|
              csv << [s]
            end
        end
    end

    def read_csv(path)
        seqs = []
        CSV.foreach(path) do |row|
            seqs << row[0]
        end
        seqs
    end

    def draw_matrix(matrix)
        matrix.each do |row|
          puts row.join(" ")
        end
    end

    def self.helix_pairs

        {
            "S14" => [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"],
                        ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]],

            "S25" => [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"],
                        ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]],

            "S36" => [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"],
                        ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
        }

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

    def self.tail_groups_4bonds
        [
            ["H1_H2", "H34_H3", "H4_H5", ["H35_H36", "H37_H38"]],
            ["H10_H11", "H8_H9", "H44_H45", "H12_H13", "H48_H49"],
            ["H66_H67", ["H27", "H25_H26"], "H62_H63", ["H21_H22", "H23_H24"]],
            ["H58_H59", ["H18", "H19_H20"], ["H55", "H53_H54"], "H16_H17", "H50_H51"]
        ]
    end

    def self.tail_groups
        [["H1_H2", "H34_H3", "H4_H5", ["H35_H36", "H37_H38"]],
         ["H10_H11", "H8_H9", "H44_H45", "H12_H13", "H48_H49", "H50_H51"],
         ["H66_H67", ["H27", "H25_H26"], "H62_H63", ["H21_H22", "H23_H24"], "H58_H59", ["H18", "H19_H20"], ["H55", "H53_H54"]]]
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


    ### BONDS FOR HINGES
    def self.s14_hinges
        [[[["H60_L_S", "H60_L_P"], ["H61_L_S", "H61_L_P"]], [["H60_R_S", "H60_R_P"], ["H61_R_S", "H61_R_P"]]],
         [[["H56_L_S", "H56_L_P"], ["H57_L_S", "H57_L_P"]], [["H56_R_S", "H56_R_P"], ["H57_R_S", "H57_R_P"]]]]
    end

    def self.s25_hinges
        [[[["H54_L_S", "H54_L_P"], ["H53_L_S", "H53_L_P"]], [["H54_R_S", "H54_R_P"], ["H53_R_S", "H53_R_P"]]],
         [[["H50_L_S", "H50_L_P"], ["H49_L_S", "H49_L_P"]], [["H50_R_S", "H50_R_P"], ["H49_R_S", "H49_R_P"]]]]
    end

    def self.s36_hinges
        [[[["H42_L_S", "H42_L_P"], ["H43_L_S", "H43_L_P"]], [["H42_R_S", "H42_R_P"], ["H43_R_S", "H43_R_P"]]],
         [[["H46_L_S", "H46_L_P"], ["H47_L_S", "H47_L_P"]], [["H46_R_S", "H46_R_P"], ["H47_R_S", "H47_R_P"]]]]
    end

    # def self.s25_hinges

    # end

    # def self.s36_hinges

    # end

    # def self.s14_handles
    #     [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"],
    #     ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]]
    # end

    # def self.s25_handles
    #     [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"],
    #     ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]]
    # end

    # def self.s36_handles
    #     [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"],
    #     ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
    # end

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


# puts z_3x6_6h_tail_bonds.inspect, z_score
# bg = BondGenerator.new
# 16M#A

# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s14_score
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s25_score
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s36_score


# m1_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "BS"],
#     "S3" => [s36_4s4b[12][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[14][0], "BS"],
#     "S3" => [s36_4s4b[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "BS"],
#     "S3" => [s36_4s4b[14][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "BS"],
#     "S2" => [s25_4s4b[9][0], "BS"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "BS"],
#     "S2" => [s25_4s4b[10][0], "BS"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "BS"],
#     "S2" => [s25_4s4b[11][0], "BS"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_A = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "BS"],
#     "S3" => [s36_4s4b[15][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # # 16M#B

# m1_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "BS"],
# })

# m2_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "BS"],
# })

# m6_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[14][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "BS"],
# })

# m10_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "BS"],
#     "S2" => [s25_4s4b[10][0], "BS"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "BS"],
# })

# m14_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "BS"],
#     "S2" => [s25_4s4b[11][0], "BS"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "BS"],
#     "S2" => [s25_4s4b[9][0], "BS"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_B = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#C

# m1_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "BS"],
# })

# m2_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "BS"],
#     "S3" => [s36_4s4b[13][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "BS"],
#     "S3" => [s36_4s4b[14][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_C = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "BS"],
#     "S3" => [s36_4s4b[15][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_C = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_C = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_C = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_C = bg.sequence_generator({
#     "S3" => [s36_4s4b[12][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#D

# m1_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "BS"]
# })

# m2_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "BS"]
# })

# m6_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "BS"]
# })

# m10_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_D = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_D = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "BS"]
# })

# m14_16m_D = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_D = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_D = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m1A.csv")
# bg.to_csv(["Sequence"] + m2_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m2A.csv")
# bg.to_csv(["Sequence"] + m3_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m3A.csv")
# bg.to_csv(["Sequence"] + m4_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m4A.csv")
# bg.to_csv(["Sequence"] + m5_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m5A.csv")
# bg.to_csv(["Sequence"] + m6_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m6A.csv")
# bg.to_csv(["Sequence"] + m7_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m7A.csv")
# bg.to_csv(["Sequence"] + m8_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m8A.csv")
# bg.to_csv(["Sequence"] + m9_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m9A.csv")
# bg.to_csv(["Sequence"] + m10_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m10A.csv")
# bg.to_csv(["Sequence"] + m11_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m11A.csv")
# bg.to_csv(["Sequence"] + m12_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m12A.csv")
# bg.to_csv(["Sequence"] + m13_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m13A.csv")
# bg.to_csv(["Sequence"] + m14_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m14A.csv")
# bg.to_csv(["Sequence"] + m15_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m15A.csv")
# bg.to_csv(["Sequence"] + m16_16m_A, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m16A.csv")


# bg.to_csv(["Sequence"] + m1_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m1B.csv")
# bg.to_csv(["Sequence"] + m2_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m2B.csv")
# bg.to_csv(["Sequence"] + m3_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m3B.csv")
# bg.to_csv(["Sequence"] + m4_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m4B.csv")
# bg.to_csv(["Sequence"] + m5_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m5B.csv")
# bg.to_csv(["Sequence"] + m6_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m6B.csv")
# bg.to_csv(["Sequence"] + m7_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m7B.csv")
# bg.to_csv(["Sequence"] + m8_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m8B.csv")
# bg.to_csv(["Sequence"] + m9_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m9B.csv")
# bg.to_csv(["Sequence"] + m10_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m10B.csv")
# bg.to_csv(["Sequence"] + m11_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m11B.csv")
# bg.to_csv(["Sequence"] + m12_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m12B.csv")
# bg.to_csv(["Sequence"] + m13_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m13B.csv")
# bg.to_csv(["Sequence"] + m14_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m14B.csv")
# bg.to_csv(["Sequence"] + m15_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m15B.csv")
# bg.to_csv(["Sequence"] + m16_16m_B, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m16B.csv")

# bg.to_csv(["Sequence"] + m1_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m1C.csv")
# bg.to_csv(["Sequence"] + m2_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m2C.csv")
# bg.to_csv(["Sequence"] + m3_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m3C.csv")
# bg.to_csv(["Sequence"] + m4_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m4C.csv")
# bg.to_csv(["Sequence"] + m5_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m5C.csv")
# bg.to_csv(["Sequence"] + m6_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m6C.csv")
# bg.to_csv(["Sequence"] + m7_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m7C.csv")
# bg.to_csv(["Sequence"] + m8_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m8C.csv")
# bg.to_csv(["Sequence"] + m9_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m9C.csv")
# bg.to_csv(["Sequence"] + m10_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m10C.csv")
# bg.to_csv(["Sequence"] + m11_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m11C.csv")
# bg.to_csv(["Sequence"] + m12_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m12C.csv")
# bg.to_csv(["Sequence"] + m13_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m13C.csv")
# bg.to_csv(["Sequence"] + m14_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m14C.csv")
# bg.to_csv(["Sequence"] + m15_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m15C.csv")
# bg.to_csv(["Sequence"] + m16_16m_C, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m16C.csv")

# bg.to_csv(["Sequence"] + m1_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m1D.csv")
# bg.to_csv(["Sequence"] + m2_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m2D.csv")
# bg.to_csv(["Sequence"] + m3_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m3D.csv")
# bg.to_csv(["Sequence"] + m4_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m4D.csv")
# bg.to_csv(["Sequence"] + m5_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m5D.csv")
# bg.to_csv(["Sequence"] + m6_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m6D.csv")
# bg.to_csv(["Sequence"] + m7_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m7D.csv")
# bg.to_csv(["Sequence"] + m8_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m8D.csv")
# bg.to_csv(["Sequence"] + m9_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m9D.csv")
# bg.to_csv(["Sequence"] + m10_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m10D.csv")
# bg.to_csv(["Sequence"] + m11_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m11D.csv")
# bg.to_csv(["Sequence"] + m12_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m12D.csv")
# bg.to_csv(["Sequence"] + m13_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m13D.csv")
# bg.to_csv(["Sequence"] + m14_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m14D.csv")
# bg.to_csv(["Sequence"] + m15_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m15D.csv")
# bg.to_csv(["Sequence"] + m16_16m_D, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M/m16D.csv")

# 64M of 4x16M but with 4S4O on the borders

# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s14_score
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s25_score
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s36_score


# m1_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "S"],
#     "S3" => [s36_4s4b[12][0], "S"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[14][0], "S"],
#     "S3" => [s36_4s4b[13][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "S"],
#     "S3" => [s36_4s4b[14][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "S"],
#     "S2" => [s25_4s4b[9][0], "S"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "S"],
#     "S2" => [s25_4s4b[10][0], "S"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "S"],
#     "S2" => [s25_4s4b[11][0], "S"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_A_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "S"],
#     "S2" => [s25_4s4b[12][0], "S"],
#     "S3" => [s36_4s4b[15][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # # 16M#B

# m1_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "S"],
# })

# m2_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "S"],
# })

# m6_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[14][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "S"],
# })

# m10_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "S"],
#     "S2" => [s25_4s4b[10][0], "S"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "S"],
# })

# m14_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "S"],
#     "S2" => [s25_4s4b[11][0], "S"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "S"],
#     "S2" => [s25_4s4b[9][0], "S"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_B_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#C

# m1_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "S"],
# })

# m2_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "S"],
#     "S3" => [s36_4s4b[13][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "S"],
#     "S3" => [s36_4s4b[14][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_C_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "S"],
#     "S3" => [s36_4s4b[15][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_C_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_C_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_C_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_C_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[12][0], "S"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#D

# m1_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "S"]
# })

# m2_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "S"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "S"]
# })

# m6_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "S"]
# })

# m10_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_D_O = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_D_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "S"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "S"]
# })

# m14_16m_D_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_D_O = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_D_O = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m1A_O.csv")
# bg.to_csv(["Sequence"] + m2_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m2A_O.csv")
# bg.to_csv(["Sequence"] + m3_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m3A_O.csv")
# bg.to_csv(["Sequence"] + m4_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m4A_O.csv")
# bg.to_csv(["Sequence"] + m5_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m5A_O.csv")
# bg.to_csv(["Sequence"] + m6_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m6A_O.csv")
# bg.to_csv(["Sequence"] + m7_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m7A_O.csv")
# bg.to_csv(["Sequence"] + m8_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m8A_O.csv")
# bg.to_csv(["Sequence"] + m9_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m9A_O.csv")
# bg.to_csv(["Sequence"] + m10_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m10A_O.csv")
# bg.to_csv(["Sequence"] + m11_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m11A_O.csv")
# bg.to_csv(["Sequence"] + m12_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m12A_O.csv")
# bg.to_csv(["Sequence"] + m13_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m13A_O.csv")
# bg.to_csv(["Sequence"] + m14_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m14A_O.csv")
# bg.to_csv(["Sequence"] + m15_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m15A_O.csv")
# bg.to_csv(["Sequence"] + m16_16m_A_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m16A_O.csv")


# bg.to_csv(["Sequence"] + m1_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m1B_O.csv")
# bg.to_csv(["Sequence"] + m2_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m2B_O.csv")
# bg.to_csv(["Sequence"] + m3_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m3B_O.csv")
# bg.to_csv(["Sequence"] + m4_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m4B_O.csv")
# bg.to_csv(["Sequence"] + m5_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m5B_O.csv")
# bg.to_csv(["Sequence"] + m6_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m6B_O.csv")
# bg.to_csv(["Sequence"] + m7_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m7B_O.csv")
# bg.to_csv(["Sequence"] + m8_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m8B_O.csv")
# bg.to_csv(["Sequence"] + m9_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m9B_O.csv")
# bg.to_csv(["Sequence"] + m10_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m10B_O.csv")
# bg.to_csv(["Sequence"] + m11_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m11B_O.csv")
# bg.to_csv(["Sequence"] + m12_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m12B_O.csv")
# bg.to_csv(["Sequence"] + m13_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m13B_O.csv")
# bg.to_csv(["Sequence"] + m14_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m14B_O.csv")
# bg.to_csv(["Sequence"] + m15_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m15B_O.csv")
# bg.to_csv(["Sequence"] + m16_16m_B_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m16B_O.csv")

# bg.to_csv(["Sequence"] + m1_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m1C_O.csv")
# bg.to_csv(["Sequence"] + m2_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m2C_O.csv")
# bg.to_csv(["Sequence"] + m3_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m3C_O.csv")
# bg.to_csv(["Sequence"] + m4_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m4C_O.csv")
# bg.to_csv(["Sequence"] + m5_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m5C_O.csv")
# bg.to_csv(["Sequence"] + m6_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m6C_O.csv")
# bg.to_csv(["Sequence"] + m7_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m7C_O.csv")
# bg.to_csv(["Sequence"] + m8_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m8C_O.csv")
# bg.to_csv(["Sequence"] + m9_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m9C_O.csv")
# bg.to_csv(["Sequence"] + m10_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m10C_O.csv")
# bg.to_csv(["Sequence"] + m11_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m11C_O.csv")
# bg.to_csv(["Sequence"] + m12_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m12C_O.csv")
# bg.to_csv(["Sequence"] + m13_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m13C_O.csv")
# bg.to_csv(["Sequence"] + m14_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m14C_O.csv")
# bg.to_csv(["Sequence"] + m15_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m15C_O.csv")
# bg.to_csv(["Sequence"] + m16_16m_C_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m16C_O.csv")

# bg.to_csv(["Sequence"] + m1_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m1D_O.csv")
# bg.to_csv(["Sequence"] + m2_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m2D_O.csv")
# bg.to_csv(["Sequence"] + m3_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m3D_O.csv")
# bg.to_csv(["Sequence"] + m4_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m4D_O.csv")
# bg.to_csv(["Sequence"] + m5_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m5D_O.csv")
# bg.to_csv(["Sequence"] + m6_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m6D_O.csv")
# bg.to_csv(["Sequence"] + m7_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m7D_O.csv")
# bg.to_csv(["Sequence"] + m8_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m8D_O.csv")
# bg.to_csv(["Sequence"] + m9_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m9D_O.csv")
# bg.to_csv(["Sequence"] + m10_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m10D_O.csv")
# bg.to_csv(["Sequence"] + m11_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m11D_O.csv")
# bg.to_csv(["Sequence"] + m12_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m12D_O.csv")
# bg.to_csv(["Sequence"] + m13_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m13D_O.csv")
# bg.to_csv(["Sequence"] + m14_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m14D_O.csv")
# bg.to_csv(["Sequence"] + m15_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m15D_O.csv")
# bg.to_csv(["Sequence"] + m16_16m_D_O, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_O/m16D_O.csv")


# # 64M of 4x16M but with 4S4T on the borders

# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s14_score
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s25_score
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 1, [], count=16, number=2, overlap=0.5, godmode=false)
# p s36_score


# m1_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m2_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "B"],
#     "S3" => [s36_4s4b[12][0], "B"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[14][0], "B"],
#     "S3" => [s36_4s4b[13][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "B"],
#     "S3" => [s36_4s4b[14][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "B"],
#     "S2" => [s25_4s4b[9][0], "B"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "B"],
#     "S2" => [s25_4s4b[10][0], "B"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "B"],
#     "S2" => [s25_4s4b[11][0], "B"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_A_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "B"],
#     "S2" => [s25_4s4b[12][0], "B"],
#     "S3" => [s36_4s4b[15][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # # 16M#B

# m1_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "B"],
# })

# m2_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "B"],
# })

# m6_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[14][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "B"],
# })

# m10_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[14][0], "B"],
#     "S2" => [s25_4s4b[10][0], "B"],
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "B"],
# })

# m14_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[12][0], "B"],
#     "S2" => [s25_4s4b[11][0], "B"],
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[15][0], "B"],
#     "S2" => [s25_4s4b[9][0], "B"],
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_B_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[13][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#C

# m1_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "B"],
# })

# m2_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S2" => [s25_4s4b[13][0], "B"],
#     "S3" => [s36_4s4b[13][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m6_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
# })

# m7_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[6][0], "BS"],
#     "S2" => [s25_4s4b[5][0], "BS"],
#     "S3" => [s36_4s4b[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
# })

# m8_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S2" => [s25_4s4b[15][0], "B"],
#     "S3" => [s36_4s4b[14][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# m10_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_C_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S2" => [s25_4s4b[12][0], "B"],
#     "S3" => [s36_4s4b[15][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_C_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"]
# })

# m14_16m_C_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_C_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_C_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[12][0], "B"],
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# # 16M#D

# m1_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[14][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[13][0]), "B"]
# })

# m2_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[12][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[10][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[15][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[11][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m4_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[13][0]), "B"],
#     "S5" => [bg.complement_side(s25_4s4b[9][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })

# m5_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"],
#     "S2" => [s25_4s4b[3][0], "BS"],
#     "S3" => [s36_4s4b[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[13][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[14][0]), "B"]
# })

# m6_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[5][0], "BS"],
#     "S2" => [s25_4s4b[4][0], "BS"],
#     "S3" => [s36_4s4b[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" =>to schedule a meeting, I am available anytime this week
# m8_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
# })

# m9_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[8][0], "BS"],
#     "S2" => [s25_4s4b[6][0], "BS"],
#     "S3" => [s36_4s4b[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[15][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[15][0]), "B"]
# })

# m10_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[9][0], "BS"],
#     "S2" => [s25_4s4b[7][0], "BS"],
#     "S3" => [s36_4s4b[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
# })

# m11_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[10][0], "BS"],
#     "S2" => [s25_4s4b[8][0], "BS"],
#     "S3" => [s36_4s4b[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
# })

# m12_16m_D_T = bg.sequence_generator({
#     "S1" => [s14_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8][0]), "BS"]
# })

# m13_16m_D_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[12][0]), "B"],
#     "S6" => [bg.complement_side(s36_4s4b[12][0]), "B"]
# })

# m14_16m_D_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[9][0]), "BS"]
# })

# m15_16m_D_T = bg.sequence_generator({
#     "S3" => [s36_4s4b[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[10][0]), "BS"]
# })

# m16_16m_D_T = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[11][0]), "BS"]
# })

# bg.to_csv(["Sequence"] + m1_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m1A_T.csv")
# bg.to_csv(["Sequence"] + m2_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m2A_T.csv")
# bg.to_csv(["Sequence"] + m3_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m3A_T.csv")
# bg.to_csv(["Sequence"] + m4_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m4A_T.csv")
# bg.to_csv(["Sequence"] + m5_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m5A_T.csv")
# bg.to_csv(["Sequence"] + m6_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m6A_T.csv")
# bg.to_csv(["Sequence"] + m7_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m7A_T.csv")
# bg.to_csv(["Sequence"] + m8_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m8A_T.csv")
# bg.to_csv(["Sequence"] + m9_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m9A_T.csv")
# bg.to_csv(["Sequence"] + m10_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m10A_T.csv")
# bg.to_csv(["Sequence"] + m11_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m11A_T.csv")
# bg.to_csv(["Sequence"] + m12_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m12A_T.csv")
# bg.to_csv(["Sequence"] + m13_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m13A_T.csv")
# bg.to_csv(["Sequence"] + m14_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m14A_T.csv")
# bg.to_csv(["Sequence"] + m15_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m15A_T.csv")
# bg.to_csv(["Sequence"] + m16_16m_A_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m16A_T.csv")


# bg.to_csv(["Sequence"] + m1_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m1B_T.csv")
# bg.to_csv(["Sequence"] + m2_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m2B_T.csv")
# bg.to_csv(["Sequence"] + m3_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m3B_T.csv")
# bg.to_csv(["Sequence"] + m4_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m4B_T.csv")
# bg.to_csv(["Sequence"] + m5_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m5B_T.csv")
# bg.to_csv(["Sequence"] + m6_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m6B_T.csv")
# bg.to_csv(["Sequence"] + m7_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m7B_T.csv")
# bg.to_csv(["Sequence"] + m8_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m8B_T.csv")
# bg.to_csv(["Sequence"] + m9_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m9B_T.csv")
# bg.to_csv(["Sequence"] + m10_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m10B_T.csv")
# bg.to_csv(["Sequence"] + m11_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m11B_T.csv")
# bg.to_csv(["Sequence"] + m12_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m12B_T.csv")
# bg.to_csv(["Sequence"] + m13_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m13B_T.csv")
# bg.to_csv(["Sequence"] + m14_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m14B_T.csv")
# bg.to_csv(["Sequence"] + m15_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m15B_T.csv")
# bg.to_csv(["Sequence"] + m16_16m_B_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m16B_T.csv")

# bg.to_csv(["Sequence"] + m1_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m1C_T.csv")
# bg.to_csv(["Sequence"] + m2_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m2C_T.csv")
# bg.to_csv(["Sequence"] + m3_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m3C_T.csv")
# bg.to_csv(["Sequence"] + m4_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m4C_T.csv")
# bg.to_csv(["Sequence"] + m5_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m5C_T.csv")
# bg.to_csv(["Sequence"] + m6_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m6C_T.csv")
# bg.to_csv(["Sequence"] + m7_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m7C_T.csv")
# bg.to_csv(["Sequence"] + m8_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m8C_T.csv")
# bg.to_csv(["Sequence"] + m9_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m9C_T.csv")
# bg.to_csv(["Sequence"] + m10_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m10C_T.csv")
# bg.to_csv(["Sequence"] + m11_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m11C_T.csv")
# bg.to_csv(["Sequence"] + m12_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m12C_T.csv")
# bg.to_csv(["Sequence"] + m13_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m13C_T.csv")
# bg.to_csv(["Sequence"] + m14_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m14C_T.csv")
# bg.to_csv(["Sequence"] + m15_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m15C_T.csv")
# bg.to_csv(["Sequence"] + m16_16m_C_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m16C_T.csv")

# bg.to_csv(["Sequence"] + m1_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m1D_T.csv")
# bg.to_csv(["Sequence"] + m2_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m2D_T.csv")
# bg.to_csv(["Sequence"] + m3_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m3D_T.csv")
# bg.to_csv(["Sequence"] + m4_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m4D_T.csv")
# bg.to_csv(["Sequence"] + m5_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m5D_T.csv")
# bg.to_csv(["Sequence"] + m6_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m6D_T.csv")
# bg.to_csv(["Sequence"] + m7_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m7D_T.csv")
# bg.to_csv(["Sequence"] + m8_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m8D_T.csv")
# bg.to_csv(["Sequence"] + m9_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m9D_T.csv")
# bg.to_csv(["Sequence"] + m10_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m10D_T.csv")
# bg.to_csv(["Sequence"] + m11_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m11D_T.csv")
# bg.to_csv(["Sequence"] + m12_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m12D_T.csv")
# bg.to_csv(["Sequence"] + m13_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m13D_T.csv")
# bg.to_csv(["Sequence"] + m14_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m14D_T.csv")
# bg.to_csv(["Sequence"] + m15_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m15D_T.csv")
# bg.to_csv(["Sequence"] + m16_16m_D_T, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/64M_T/m16D_T.csv")
# bg.best_sides_out_of("S14", 1, [], count=16, number=2, overlap=0.5, godmode=false)

# 2x16M

# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S14 score: #{s14_score}"
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 25, [], count=9, number=2, overlap=0.25, godmode=false)
# puts "S25 score: #{s25_score}"
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "S36 score: #{s36_score}"

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

# # Z bonds
# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 5, [], count=12, number=2, overlap=0.25, godmode=false)

# # z_2x16h_tail_bonds = bg.z_bond_sampler(9, 3, "TAIL", 0.34)
# # z_2x16h_head_bonds = bg.z_complement_side(z_2x16h_tail_bonds)

# z_2x16h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 9, 0.34, 100)
# z_2x16h_head_bonds = bg.z_complement_side(z_2x16h_tail_bonds)
# p z_score

# m1a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m7a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m8a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m9a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
# m10a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m11a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])
# m12a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m13a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m14a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[7]) + bg.add_z_bonds("HEAD", [])
# m15a_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m16a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[8]) + bg.add_z_bonds("HEAD", [])


# m1b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m2b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[0])
# m3b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[1])
# m4b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[2])
# m5b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[3])
# m6b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[4])
# m7b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m8b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m9b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[5])
# m10b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m11b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[6])
# m12b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m13b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m14b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[7])
# m15b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", [])
# m16b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[8])

# m1a_16m = m1_16m + m1a_z_seqs
# m2a_16m = m2_16m + m2a_z_seqs
# m3a_16m = m3_16m + m3a_z_seqs
# m4a_16m = m4_16m + m4a_z_seqs
# m5a_16m = m5_16m + m5a_z_seqs
# m6a_16m = m6_16m + m6a_z_seqs
# m7a_16m = m7_16m + m7a_z_seqs
# m8a_16m = m8_16m + m8a_z_seqs
# m9a_16m = m9_16m + m9a_z_seqs
# m10a_16m = m10_16m + m10a_z_seqs
# m11a_16m = m11_16m + m11a_z_seqs
# m12a_16m = m12_16m + m12a_z_seqs
# m13a_16m = m13_16m + m13a_z_seqs
# m14a_16m = m14_16m + m14a_z_seqs
# m15a_16m = m15_16m + m15a_z_seqs
# m16a_16m = m16_16m + m16a_z_seqs

# m1b_16m = m1_16m + m1b_z_seqs
# m2b_16m = m2_16m + m2b_z_seqs
# m3b_16m = m3_16m + m3b_z_seqs
# m4b_16m = m4_16m + m4b_z_seqs
# m5b_16m = m5_16m + m5b_z_seqs
# m6b_16m = m6_16m + m6b_z_seqs
# m7b_16m = m7_16m + m7b_z_seqs
# m8b_16m = m8_16m + m8b_z_seqs
# m9b_16m = m9_16m + m9b_z_seqs
# m10b_16m = m10_16m + m10b_z_seqs
# m11b_16m = m11_16m + m11b_z_seqs
# m12b_16m = m12_16m + m12b_z_seqs
# m13b_16m = m13_16m + m13b_z_seqs
# m14b_16m = m14_16m + m14b_z_seqs
# m15b_16m = m15_16m + m15b_z_seqs
# m16b_16m = m16_16m + m16b_z_seqs


# bg.to_csv(["Sequence"] + m1a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m1a.csv")
# bg.to_csv(["Sequence"] + m2a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m2a.csv")
# bg.to_csv(["Sequence"] + m3a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m3a.csv")
# bg.to_csv(["Sequence"] + m4a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m4a.csv")
# bg.to_csv(["Sequence"] + m5a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m5a.csv")
# bg.to_csv(["Sequence"] + m6a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m6a.csv")
# bg.to_csv(["Sequence"] + m7a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m7a.csv")
# bg.to_csv(["Sequence"] + m8a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m8a.csv")
# bg.to_csv(["Sequence"] + m9a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m9a.csv")
# bg.to_csv(["Sequence"] + m10a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m10a.csv")
# bg.to_csv(["Sequence"] + m11a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m11a.csv")
# bg.to_csv(["Sequence"] + m12a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m12a.csv")
# bg.to_csv(["Sequence"] + m13a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m13a.csv")
# bg.to_csv(["Sequence"] + m14a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m14a.csv")
# bg.to_csv(["Sequence"] + m15a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m15a.csv")
# bg.to_csv(["Sequence"] + m16a_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m16a.csv")

# bg.to_csv(["Sequence"] + m1b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m1b.csv")
# bg.to_csv(["Sequence"] + m2b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m2b.csv")
# bg.to_csv(["Sequence"] + m3b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m3b.csv")
# bg.to_csv(["Sequence"] + m4b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m4b.csv")
# bg.to_csv(["Sequence"] + m5b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m5b.csv")
# bg.to_csv(["Sequence"] + m6b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m6b.csv")
# bg.to_csv(["Sequence"] + m7b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m7b.csv")
# bg.to_csv(["Sequence"] + m8b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m8b.csv")
# bg.to_csv(["Sequence"] + m9b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m9b.csv")
# bg.to_csv(["Sequence"] + m10b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m10b.csv")
# bg.to_csv(["Sequence"] + m11b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m11b.csv")
# bg.to_csv(["Sequence"] + m12b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m12b.csv")
# bg.to_csv(["Sequence"] + m13b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m13b.csv")
# bg.to_csv(["Sequence"] + m14b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m14b.csv")
# bg.to_csv(["Sequence"] + m15b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m15b.csv")
# bg.to_csv(["Sequence"] + m16b_16m, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x16M/m16b.csv")


# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 1, [], count=2, number=2, overlap=0.0, godmode=false)
# p s14_4s4b
# z_2x2_4h_tail_bonds = bg.z_bond_sampler(4, 2, 0.0)
# z_2x2_4h_head_bonds = bg.z_complement_side(z_2x2_4h_tail_bonds)
# p z_2x2_4h_tail_bonds

# m1a_2x2 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"]
# })

# m2a_2x2 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m1b_2x2 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"]
# })

# m2b_2x2 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x2_4h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x2_4h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x2_4h_head_bonds[0])
# m2b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x2_4h_head_bonds[1])

# m1a_2x2 += m1a_z_seqs
# m2a_2x2 += m2a_z_seqs

# m1b_2x2 += m1b_z_seqs
# m2b_2x2 += m2b_z_seqs

# bg.to_csv(["Sequence"] + m1a_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2_4H/m1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2_4H/m2a.csv")

# bg.to_csv(["Sequence"] + m1b_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2_4H/m1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x2_4H/m2b.csv")

# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 1, [], count=2, number=2, overlap=0.0, godmode=false)
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 1, [], count=2, number=2, overlap=0.0, godmode=false)
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 1, [], count=2, number=2, overlap=0.0, godmode=false)

# p s14_4s4b
# p s25_4s4b
# p s36_4s4b

# z_2x2_4h_tail_bonds = bg.z_bond_sampler(4, 3, 0.0)
# z_2x2_4h_head_bonds = bg.z_complement_side(z_2x2_4h_tail_bonds)
# p z_2x2_4h_tail_bonds

# m1a_2x2 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S2" => [s25_4s4b[0][0], "BS"]
# })

# m2a_2x2 = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m3a_2x2 = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# # Layer 2

# m1b_2x2 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S2" => [s25_4s4b[1][0], "BS"]
# })

# m2b_2x2 = bg.sequence_generator({
#     "S3" => [s36_4s4b[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# m3b_2x2 = bg.sequence_generator({
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })
    

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x2_4h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x2_4h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x2_4h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x2_4h_head_bonds[0])
# m2b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x2_4h_head_bonds[1])
# m3b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x2_4h_head_bonds[2])

# m1a_2x2 += m1a_z_seqs
# m2a_2x2 += m2a_z_seqs
# m3a_2x2 += m3a_z_seqs

# m1b_2x2 += m1b_z_seqs
# m2b_2x2 += m2b_z_seqs
# m3b_2x2 += m3b_z_seqs

# bg.to_csv(["Sequence"] + m1a_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m2a.csv")
# bg.to_csv(["Sequence"] + m3a_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m3a.csv")

# bg.to_csv(["Sequence"] + m1b_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m2b.csv")
# bg.to_csv(["Sequence"] + m3b_2x2, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/2x3_4H/m3b.csv")


# s14_4s4b, s14_score = bg.best_sides_out_of("S14", 50, [], count=10, number=2, overlap=0.25, godmode=false)
# p "S14 score #{s14_score}"
# s25_4s4b, s25_score = bg.best_sides_out_of("S25", 50, [], count=10, number=2, overlap=0.25, godmode=false)
# p "S25 score #{s25_score}"
# s36_4s4b, s36_score = bg.best_sides_out_of("S36", 50, [], count=10, number=2, overlap=0.25, godmode=false)
# p "S36 score #{s36_score}"

# z_5x6_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 24, 0.51, 1)
# z_5x6_head_bonds = bg.z_complement_side(z_5x6_tail_bonds)
# p z_score

# m1a_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"]
# })

# m2a_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
# })

# m3a_5x6 = bg.sequence_generator({
#     "S3" => [s36_4s4b[0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
# })

# m4a_5x6 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m5a_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
# })

# m6a_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# # L2
# m1b_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2+0][0], "BS"],
#     "S3" => [s36_4s4b[2+1][0], "BS"]
# })

# m2b_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[2+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[2+0][0]), "BS"],
# })

# m3b_5x6 = bg.sequence_generator({
#     "S3" => [s36_4s4b[2+0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2+0][0]), "BS"],
# })

# m4b_5x6 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2+1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2+0][0]), "BS"]
# })

# m5b_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2+1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2+1][0]), "BS"],
# })

# m6b_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[2+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2+1][0]), "BS"]
# })
# # L3
# m1c_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4+0][0], "BS"],
#     "S3" => [s36_4s4b[4+1][0], "BS"]
# })

# m2c_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[4+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[4+0][0]), "BS"],
# })

# m3c_5x6 = bg.sequence_generator({
#     "S3" => [s36_4s4b[4+0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4+0][0]), "BS"],
# })

# m4c_5x6 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[4+1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4+0][0]), "BS"]
# })

# m5c_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[4+1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[4+1][0]), "BS"],
# })

# m6c_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[4+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[4+1][0]), "BS"]
# })
# # L4
# m1d_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[6+0][0], "BS"],
#     "S3" => [s36_4s4b[6+1][0], "BS"]
# })

# m2d_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[6+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[6+0][0]), "BS"],
# })

# m3d_5x6 = bg.sequence_generator({
#     "S3" => [s36_4s4b[6+0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6+0][0]), "BS"],
# })

# m4d_5x6 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[6+1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6+0][0]), "BS"]
# })

# m5d_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[6+1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[6+1][0]), "BS"],
# })

# m6d_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[6+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[6+1][0]), "BS"]
# })
# # L5
# m1e_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[8+0][0], "BS"],
#     "S3" => [s36_4s4b[8+1][0], "BS"]
# })

# m2e_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[8+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_4s4b[8+0][0]), "BS"],
# })

# m3e_5x6 = bg.sequence_generator({
#     "S3" => [s36_4s4b[8+0][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8+0][0]), "BS"],
# })

# m4e_5x6 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[8+1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8+0][0]), "BS"]
# })

# m5e_5x6 = bg.sequence_generator({
#     "S1" => [s14_4s4b[8+1][0], "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[8+1][0]), "BS"],
# })

# m6e_5x6 = bg.sequence_generator({
#     "S2" => [s25_4s4b[8+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[8+1][0]), "BS"]
# })

# ### Save To Csv

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])

# m1b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[6]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[0])
# m2b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[7]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[1])
# m3b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[8]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[2])
# m4b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[9]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[3])
# m5b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[10]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[4])
# m6b_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[11]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[5])

# m1c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[12]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[6])
# m2c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[13]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[7])
# m3c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[14]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[8])
# m4c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[15]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[9])
# m5c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[16]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[10])
# m6c_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[17]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[11])

# m1d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[18]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[12])
# m2d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[19]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[13])
# m3d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[20]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[14])
# m4d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[21]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[15])
# m5d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[22]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[16])
# m6d_z_seqs = bg.add_z_bonds("TAIL", z_5x6_tail_bonds[23]) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[17])

# m1e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[18])
# m2e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[19])
# m3e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[20])
# m4e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[21])
# m5e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[22])
# m6e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_5x6_head_bonds[23])


# m1a_5x6 += m1a_z_seqs
# m2a_5x6 += m2a_z_seqs
# m3a_5x6 += m3a_z_seqs
# m4a_5x6 += m4a_z_seqs
# m5a_5x6 += m5a_z_seqs
# m6a_5x6 += m6a_z_seqs

# m1b_5x6 += m1b_z_seqs
# m2b_5x6 += m2b_z_seqs
# m3b_5x6 += m3b_z_seqs
# m4b_5x6 += m4b_z_seqs
# m5b_5x6 += m5b_z_seqs
# m6b_5x6 += m6b_z_seqs

# m1c_5x6 += m1c_z_seqs
# m2c_5x6 += m2c_z_seqs
# m3c_5x6 += m3c_z_seqs
# m4c_5x6 += m4c_z_seqs
# m5c_5x6 += m5c_z_seqs
# m6c_5x6 += m6c_z_seqs

# m1d_5x6 += m1d_z_seqs
# m2d_5x6 += m2d_z_seqs
# m3d_5x6 += m3d_z_seqs
# m4d_5x6 += m4d_z_seqs
# m5d_5x6 += m5d_z_seqs
# m6d_5x6 += m6d_z_seqs

# m1e_5x6 += m1e_z_seqs
# m2e_5x6 += m2e_z_seqs
# m3e_5x6 += m3e_z_seqs
# m4e_5x6 += m4e_z_seqs
# m5e_5x6 += m5e_z_seqs
# m6e_5x6 += m6e_z_seqs

# bg.to_csv(["Sequence"] + m1a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m1a.csv")
# bg.to_csv(["Sequence"] + m2a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m2a.csv")
# bg.to_csv(["Sequence"] + m3a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m3a.csv")
# bg.to_csv(["Sequence"] + m4a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m4a.csv")
# bg.to_csv(["Sequence"] + m5a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m5a.csv")
# bg.to_csv(["Sequence"] + m6a_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m6a.csv")

# bg.to_csv(["Sequence"] + m1b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m1b.csv")
# bg.to_csv(["Sequence"] + m2b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m2b.csv")
# bg.to_csv(["Sequence"] + m3b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m3b.csv")
# bg.to_csv(["Sequence"] + m4b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m4b.csv")
# bg.to_csv(["Sequence"] + m5b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m5b.csv")
# bg.to_csv(["Sequence"] + m6b_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m6b.csv")

# bg.to_csv(["Sequence"] + m1c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m1c.csv")
# bg.to_csv(["Sequence"] + m2c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m2c.csv")
# bg.to_csv(["Sequence"] + m3c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m3c.csv")
# bg.to_csv(["Sequence"] + m4c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m4c.csv")
# bg.to_csv(["Sequence"] + m5c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m5c.csv")
# bg.to_csv(["Sequence"] + m6c_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m6c.csv")

# bg.to_csv(["Sequence"] + m1d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m1d.csv")
# bg.to_csv(["Sequence"] + m2d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m2d.csv")
# bg.to_csv(["Sequence"] + m3d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m3d.csv")
# bg.to_csv(["Sequence"] + m4d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m4d.csv")
# bg.to_csv(["Sequence"] + m5d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m5d.csv")
# bg.to_csv(["Sequence"] + m6d_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m6d.csv")

# bg.to_csv(["Sequence"] + m1e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m1e.csv")
# bg.to_csv(["Sequence"] + m2e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m2e.csv")
# bg.to_csv(["Sequence"] + m3e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m3e.csv")
# bg.to_csv(["Sequence"] + m4e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m4e.csv")
# bg.to_csv(["Sequence"] + m5e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m5e.csv")
# bg.to_csv(["Sequence"] + m6e_5x6, "/Users/samsonpetrosyan/Desktop/hexoland/sequences/5x6M/m6e.csv")

# 2x16M in One-POT
bg = BondGenerator.new

# s14_handles, s14_handles_score = bg.best_sides_out_of("S14", "handles", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "Handle S14 score: #{s14_handles_score}"
# s25_handles, s25_handles_score = bg.best_sides_out_of("S25", "handles", 25, [], count=9, number=2, overlap=0.25, godmode=false)
# puts "Handle S25 score: #{s25_handles_score}"
# s36_handles, s36_handles_score = bg.best_sides_out_of("S36", "handles", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "Handle S36 score: #{s36_handles_score}"


# s14_hinges, s14_hinges_score = bg.best_sides_out_of("S14", "hinges", 50, [], count=8, number=2, overlap=0.5, godmode=false)
# puts "Hinge S14 score: #{s14_hinges_score}"
# s25_hinges, s25_hinges_score = bg.best_sides_out_of("S25", "hinges", 50, [], count=13, number=2, overlap=0.5, godmode=false)
# puts "Hinge S25 score: #{s25_hinges_score}"
# s36_hinges, s36_hinges_score = bg.best_sides_out_of("S36", "hinges", 50, [], count=8, number=2, overlap=0.5, godmode=false)
# puts "Hinge S36 score: #{s36_hinges_score}"


# p "Sample S14 handle: #{s14_handles[0]} and hinge: #{s14_hinges[0]}"
# p "Sample S25 handle: #{s25_handles[0]} and hinge: #{s25_hinges[0]}"
# p "Sample S36 handle: #{s36_handles[0]} and hinge: #{s36_hinges[0]}"


# m1_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"]
# })

# m2_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_handles[1][0], "BS"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m3_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[2][0], "BS"],
#     "S2" => [s25_handles[2][0], "BS"],
#     "S3" => [s36_handles[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# m4_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[3][0], "BS"],
#     "S2" => [s25_hinges[0][0], "B"], # HINGE
#     "S3" => [s36_hinges[0][0], "B"],  # HINGE
#     "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
# })

# m5_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[4][0], "BS"],
#     "S2" => [s25_handles[3][0], "BS"],
#     "S3" => [s36_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m6_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[5][0], "BS"],
#     "S2" => [s25_handles[4][0], "BS"],
#     "S3" => [s36_handles[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
# })

# m7_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[6][0], "BS"],
#     "S2" => [s25_handles[5][0], "BS"],
#     "S3" => [s36_handles[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4][0]), "BS"]
# })

# m8_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[7][0], "BS"],
#     "S2" => [s25_hinges[1][0], "B"],  # HINGE
#     "S3" => [s36_hinges[1][0], "B"],  # HINGE
#     "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[5][0]), "BS"]
# })

# m9_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[8][0], "BS"],
#     "S2" => [s25_handles[6][0], "BS"],
#     "S3" => [s36_handles[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4][0]), "BS"]
# })

# m10_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[9][0], "BS"],
#     "S2" => [s25_handles[7][0], "BS"],
#     "S3" => [s36_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[6][0]), "BS"]
# })

# m11_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[10][0], "BS"],
#     "S2" => [s25_handles[8][0], "BS"],
#     "S3" => [s36_handles[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[7][0]), "BS"]
# })

# m12_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[11][0], "BS"],
#     "S2" => [s25_hinges[2][0], "B"],  # HINGE
#     "S3" => [s36_hinges[2][0], "B"],  # HINGE
#     "S4" => [bg.complement_side(s14_handles[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[8][0]), "BS"]
# })

# m13_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[0][0], "B"],  # HINGE
#     "S2" => [s25_hinges[3][0], "B"],  # HINGE
#     "S3" => [s36_handles[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[8][0]), "BS"]
# })

# m14_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[1][0], "B"],  # HINGE
#     "S2" => [s25_hinges[4][0], "B"],  # HINGE
#     "S3" => [s36_handles[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[9][0]), "BS"]
# })

# m15_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[2][0], "B"],  # HINGE
#     "S2" => [s25_hinges[5][0], "B"],  # HINGE
#     "S3" => [s36_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[10][0]), "BS"]
# })

# m16_16m_A_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[3][0], "B"],  # HINGE
#     "S2" => [s25_hinges[6][0], "B"],  # HINGE
#     "S3" => [s36_hinges[3][0], "B"],  # HINGE
#     "S4" => [bg.complement_side(s14_handles[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[11][0]), "BS"]
# })

# # 16M#B

# m1_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_hinges[0][0]), "B"],
# })

# m2_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_handles[1][0], "BS"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m3_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[2][0], "BS"],
#     "S2" => [s25_handles[2][0], "BS"],
#     "S3" => [s36_handles[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# m4_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[3][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
# })

# m5_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[4][0], "BS"],
#     "S2" => [s25_handles[3][0], "BS"],
#     "S3" => [s36_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[0][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[1][0]), "B"],
# })

# m6_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[5][0], "BS"],
#     "S2" => [s25_handles[4][0], "BS"],
#     "S3" => [s36_handles[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
# })

# m7_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[6][0], "BS"],
#     "S2" => [s25_handles[5][0], "BS"],
#     "S3" => [s36_handles[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4][0]), "BS"]
# })

# m8_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[5][0]), "BS"]
# })

# m9_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[8][0], "BS"],
#     "S2" => [s25_handles[6][0], "BS"],
#     "S3" => [s36_handles[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[1][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[2][0]), "B"],
# })

# m10_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[9][0], "BS"],
#     "S2" => [s25_handles[7][0], "BS"],
#     "S3" => [s36_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[6][0]), "BS"]
# })

# m11_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[10][0], "BS"],
#     "S2" => [s25_handles[8][0], "BS"],
#     "S3" => [s36_handles[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[7][0]), "BS"]
# })

# m12_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[8][0]), "BS"]
# })

# m13_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[4][0], "B"],
#     "S2" => [s25_hinges[7][0], "B"],
#     "S3" => [s36_handles[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[2][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[3][0]), "B"],
# })

# m14_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[5][0], "B"],
#     "S2" => [s25_hinges[8][0], "B"],
#     "S3" => [s36_handles[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[9][0]), "BS"]
# })

# m15_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[6][0], "B"],
#     "S2" => [s25_hinges[9][0], "B"],
#     "S3" => [s36_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[10][0]), "BS"]
# })

# m16_16m_B_HiHa = bg.sequence_generator({
#     "S1" => [s14_hinges[7][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[11][0]), "BS"]
# })

# # 16M#C

# m1_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[0][0]), "B"],
# })

# m2_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_handles[1][0], "BS"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[1][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[3][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m3_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[2][0], "BS"],
#     "S2" => [s25_handles[2][0], "BS"],
#     "S3" => [s36_handles[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[2][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[4][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# m4_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[3][0], "BS"],
#     "S2" => [s25_hinges[10][0], "B"],
#     "S3" => [s36_hinges[4][0], "B"],
#     "S4" => [bg.complement_side(s14_hinges[3][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[5][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
# })

# m5_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[4][0], "BS"],
#     "S2" => [s25_handles[3][0], "BS"],
#     "S3" => [s36_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m6_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[5][0], "BS"],
#     "S2" => [s25_handles[4][0], "BS"],
#     "S3" => [s36_handles[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
# })

# m7_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[6][0], "BS"],
#     "S2" => [s25_handles[5][0], "BS"],
#     "S3" => [s36_handles[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4][0]), "BS"]
# })

# m8_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[7][0], "BS"],
#     "S2" => [s25_hinges[11][0], "B"],
#     "S3" => [s36_hinges[5][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[5][0]), "BS"]
# })

# m9_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[8][0], "BS"],
#     "S2" => [s25_handles[6][0], "BS"],
#     "S3" => [s36_handles[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4][0]), "BS"]
# })

# m10_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[9][0], "BS"],
#     "S2" => [s25_handles[7][0], "BS"],
#     "S3" => [s36_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[6][0]), "BS"]
# })

# m11_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[10][0], "BS"],
#     "S2" => [s25_handles[8][0], "BS"],
#     "S3" => [s36_handles[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[7][0]), "BS"]
# })

# m12_16m_C_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[11][0], "BS"],
#     "S2" => [s25_hinges[12][0], "B"],
#     "S3" => [s36_hinges[6][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[8][0]), "BS"]
# })

# m13_16m_C_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[8][0]), "BS"]
# })

# m14_16m_C_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[9][0]), "BS"]
# })

# m15_16m_C_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[10][0]), "BS"]
# })

# m16_16m_C_HiHa = bg.sequence_generator({
#     "S3" => [s36_hinges[7][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[11][0]), "BS"]
# })

# # 16M#D

# m1_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[4][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[6][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[4][0]), "B"]
# })

# m2_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_handles[1][0], "BS"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[5][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[7][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m3_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[2][0], "BS"],
#     "S2" => [s25_handles[2][0], "BS"],
#     "S3" => [s36_handles[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[6][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[8][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# m4_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[7][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[9][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
# })

# m5_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[4][0], "BS"],
#     "S2" => [s25_handles[3][0], "BS"],
#     "S3" => [s36_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[10][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[5][0]), "B"]
# })

# m6_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[5][0], "BS"],
#     "S2" => [s25_handles[4][0], "BS"],
#     "S3" => [s36_handles[4][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
# })

# m7_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[6][0], "BS"],
#     "S2" => [s25_handles[5][0], "BS"],
#     "S3" => [s36_handles[5][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4][0]), "BS"]
# })

# m8_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[2][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[5][0]), "BS"]
# })

# m9_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[8][0], "BS"],
#     "S2" => [s25_handles[6][0], "BS"],
#     "S3" => [s36_handles[6][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[11][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[6][0]), "B"]
# })

# m10_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[9][0], "BS"],
#     "S2" => [s25_handles[7][0], "BS"],
#     "S3" => [s36_handles[7][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[5][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[6][0]), "BS"]
# })

# m11_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[10][0], "BS"],
#     "S2" => [s25_handles[8][0], "BS"],
#     "S3" => [s36_handles[8][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[6][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[7][0]), "BS"]
# })

# m12_16m_D_HiHa = bg.sequence_generator({
#     "S1" => [s14_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[7][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[5][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[8][0]), "BS"]
# })

# m13_16m_D_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[9][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[8][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[12][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[7][0]), "B"]
# })

# m14_16m_D_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[10][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[9][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[6][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[9][0]), "BS"]
# })

# m15_16m_D_HiHa = bg.sequence_generator({
#     "S3" => [s36_handles[11][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[10][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[7][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[10][0]), "BS"]
# })

# m16_16m_D_HiHa = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[11][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[8][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[11][0]), "BS"]
# })

# LINUX_PATH = "/home/spetrosyan/Desktop/hexoland/sequences/"

# bg.to_csv(["Sequence"] + m1_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m1A_HiHa.csv")
# bg.to_csv(["Sequence"] + m2_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m2A_HiHa.csv")
# bg.to_csv(["Sequence"] + m3_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m3A_HiHa.csv")
# bg.to_csv(["Sequence"] + m4_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m4A_HiHa.csv")
# bg.to_csv(["Sequence"] + m5_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m5A_HiHa.csv")
# bg.to_csv(["Sequence"] + m6_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m6A_HiHa.csv")
# bg.to_csv(["Sequence"] + m7_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m7A_HiHa.csv")
# bg.to_csv(["Sequence"] + m8_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m8A_HiHa.csv")
# bg.to_csv(["Sequence"] + m9_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m9A_HiHa.csv")
# bg.to_csv(["Sequence"] + m10_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m10A_HiHa.csv")
# bg.to_csv(["Sequence"] + m11_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m11A_HiHa.csv")
# bg.to_csv(["Sequence"] + m12_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m12A_HiHa.csv")
# bg.to_csv(["Sequence"] + m13_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m13A_HiHa.csv")
# bg.to_csv(["Sequence"] + m14_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m14A_HiHa.csv")
# bg.to_csv(["Sequence"] + m15_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m15A_HiHa.csv")
# bg.to_csv(["Sequence"] + m16_16m_A_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m16A_HiHa.csv")

# bg.to_csv(["Sequence"] + m1_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m1B_HiHa.csv")
# bg.to_csv(["Sequence"] + m2_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m2B_HiHa.csv")
# bg.to_csv(["Sequence"] + m3_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m3B_HiHa.csv")
# bg.to_csv(["Sequence"] + m4_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m4B_HiHa.csv")
# bg.to_csv(["Sequence"] + m5_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m5B_HiHa.csv")
# bg.to_csv(["Sequence"] + m6_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m6B_HiHa.csv")
# bg.to_csv(["Sequence"] + m7_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m7B_HiHa.csv")
# bg.to_csv(["Sequence"] + m8_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m8B_HiHa.csv")
# bg.to_csv(["Sequence"] + m9_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m9B_HiHa.csv")
# bg.to_csv(["Sequence"] + m10_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m10B_HiHa.csv")
# bg.to_csv(["Sequence"] + m11_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m11B_HiHa.csv")
# bg.to_csv(["Sequence"] + m12_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m12B_HiHa.csv")
# bg.to_csv(["Sequence"] + m13_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m13B_HiHa.csv")
# bg.to_csv(["Sequence"] + m14_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m14B_HiHa.csv")
# bg.to_csv(["Sequence"] + m15_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m15B_HiHa.csv")
# bg.to_csv(["Sequence"] + m16_16m_B_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m16B_HiHa.csv")

# bg.to_csv(["Sequence"] + m1_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m1C_HiHa.csv")
# bg.to_csv(["Sequence"] + m2_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m2C_HiHa.csv")
# bg.to_csv(["Sequence"] + m3_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m3C_HiHa.csv")
# bg.to_csv(["Sequence"] + m4_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m4C_HiHa.csv")
# bg.to_csv(["Sequence"] + m5_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m5C_HiHa.csv")
# bg.to_csv(["Sequence"] + m6_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m6C_HiHa.csv")
# bg.to_csv(["Sequence"] + m7_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m7C_HiHa.csv")
# bg.to_csv(["Sequence"] + m8_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m8C_HiHa.csv")
# bg.to_csv(["Sequence"] + m9_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m9C_HiHa.csv")
# bg.to_csv(["Sequence"] + m10_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m10C_HiHa.csv")
# bg.to_csv(["Sequence"] + m11_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m11C_HiHa.csv")
# bg.to_csv(["Sequence"] + m12_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m12C_HiHa.csv")
# bg.to_csv(["Sequence"] + m13_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m13C_HiHa.csv")
# bg.to_csv(["Sequence"] + m14_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m14C_HiHa.csv")
# bg.to_csv(["Sequence"] + m15_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m15C_HiHa.csv")
# bg.to_csv(["Sequence"] + m16_16m_C_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m16C_HiHa.csv")

# bg.to_csv(["Sequence"] + m1_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m1D_HiHa.csv")
# bg.to_csv(["Sequence"] + m2_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m2D_HiHa.csv")
# bg.to_csv(["Sequence"] + m3_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m3D_HiHa.csv")
# bg.to_csv(["Sequence"] + m4_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m4D_HiHa.csv")
# bg.to_csv(["Sequence"] + m5_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m5D_HiHa.csv")
# bg.to_csv(["Sequence"] + m6_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m6D_HiHa.csv")
# bg.to_csv(["Sequence"] + m7_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m7D_HiHa.csv")
# bg.to_csv(["Sequence"] + m8_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m8D_HiHa.csv")
# bg.to_csv(["Sequence"] + m9_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m9D_HiHa.csv")
# bg.to_csv(["Sequence"] + m10_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m10D_HiHa.csv")
# bg.to_csv(["Sequence"] + m11_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m11D_HiHa.csv")
# bg.to_csv(["Sequence"] + m12_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m12D_HiHa.csv")
# bg.to_csv(["Sequence"] + m13_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m13D_HiHa.csv")
# bg.to_csv(["Sequence"] + m14_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m14D_HiHa.csv")
# bg.to_csv(["Sequence"] + m15_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m15D_HiHa.csv")
# bg.to_csv(["Sequence"] + m16_16m_D_HiHa, "#{LINUX_PATH}64M_HiHa_V2/m16D_HiHa.csv")

# bg = BondGenerator.new

# s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 150, [], count=5, number=2, overlap=0.25, godmode=false)
# puts "Handle S14 score: #{s14_handles_score}"
# s25_4s4b, s25_handles_score = bg.best_sides_out_of("S25", "handles", 25, [], count=9, number=2, overlap=0.25, godmode=false)
# puts "Handle S25 score: #{s25_handles_score}"
# s36_4s4b, s36_handles_score = bg.best_sides_out_of("S36", "handles", 5, [], count=12, number=2, overlap=0.25, godmode=false)
# puts "Handle S36 score: #{s36_handles_score}"

# # p "Sample S14 handle: #{s14_handles[0]} and hinge: #{s14_hinges[0]}"
# # p "Sample S25 handle: #{s25_handles[0]} and hinge: #{s25_hinges[0]}"
# # p "Sample S36 handle: #{s36_handles[0]} and hinge: #{s36_hinges[0]}"

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

# Z bonds
# bg = BondGenerator.new

# s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 150, [], count=5, number=2, overlap=0.25, godmode=false)
# puts "Handle S14 score: #{s14_handles_score}"
# z_2x16h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 8, 0.25, 100)
# p z_2x16h_tail_bonds
# p z_score
# z_2x16h_head_bonds = bg.z_complement_side(z_2x16h_tail_bonds)
# p z_2x16h_head_bonds
# p "Z score is: #{z_score}"
# p z_2x16h_tail_bonds
# p z_2x16h_head_bonds

# m01a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m02a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m03a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m04a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m05a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m06a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
# m07a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])
# m08a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[7]) + bg.add_z_bonds("HEAD", [])
# m09a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[8]) + bg.add_z_bonds("HEAD", [])
# m10a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[9]) + bg.add_z_bonds("HEAD", [])
# m11a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[10]) + bg.add_z_bonds("HEAD", [])
# m12a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[11]) + bg.add_z_bonds("HEAD", [])
# m13a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[12]) + bg.add_z_bonds("HEAD", [])
# m14a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[13]) + bg.add_z_bonds("HEAD", [])
# m15a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[14]) + bg.add_z_bonds("HEAD", [])
# m16a_z_seqs = bg.add_z_bonds("TAIL", z_2x16h_tail_bonds[15]) + bg.add_z_bonds("HEAD", [])


# m01b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[0])
# m02b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[1])
# m03b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[2])
# m04b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[3])
# m05b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[4])
# m06b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[5])
# m07b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[6])
# m08b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[7])
# m09b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[8])
# m10b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[9])
# m11b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[10])
# m12b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[11])
# m13b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[12])
# m14b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[13])
# m15b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[14])
# m16b_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_2x16h_head_bonds[15])

# m01a_16m = m1_16m + m01a_z_seqs
# m02a_16m = m2_16m + m02a_z_seqs
# m03a_16m = m3_16m + m03a_z_seqs
# m04a_16m = m4_16m + m04a_z_seqs
# m05a_16m = m5_16m + m05a_z_seqs
# m06a_16m = m6_16m + m06a_z_seqs
# m07a_16m = m7_16m + m07a_z_seqs
# m08a_16m = m8_16m + m08a_z_seqs
# m09a_16m = m9_16m + m09a_z_seqs
# m10a_16m = m10_16m + m10a_z_seqs
# m11a_16m = m11_16m + m11a_z_seqs
# m12a_16m = m12_16m + m12a_z_seqs
# m13a_16m = m13_16m + m13a_z_seqs
# m14a_16m = m14_16m + m14a_z_seqs
# m15a_16m = m15_16m + m15a_z_seqs
# m16a_16m = m16_16m + m16a_z_seqs

# m01b_16m = m1_16m + m01b_z_seqs
# m02b_16m = m2_16m + m02b_z_seqs
# m03b_16m = m3_16m + m03b_z_seqs
# m04b_16m = m4_16m + m04b_z_seqs
# m05b_16m = m5_16m + m05b_z_seqs
# m06b_16m = m6_16m + m06b_z_seqs
# m07b_16m = m7_16m + m07b_z_seqs
# m08b_16m = m8_16m + m08b_z_seqs
# m09b_16m = m9_16m + m09b_z_seqs
# m10b_16m = m10_16m + m10b_z_seqs
# m11b_16m = m11_16m + m11b_z_seqs
# m12b_16m = m12_16m + m12b_z_seqs
# m13b_16m = m13_16m + m13b_z_seqs
# m14b_16m = m14_16m + m14b_z_seqs
# m15b_16m = m15_16m + m15b_z_seqs
# m16b_16m = m16_16m + m16b_z_seqs

LINUX_SAVE_PATH = "/home/spetrosyan/Desktop/hexoland/sequences/"

# bg.to_csv(["Sequence"] + m01a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m01a.csv")
# bg.to_csv(["Sequence"] + m02a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m02a.csv")
# bg.to_csv(["Sequence"] + m03a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m03a.csv")
# bg.to_csv(["Sequence"] + m04a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m04a.csv")
# bg.to_csv(["Sequence"] + m05a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m05a.csv")
# bg.to_csv(["Sequence"] + m06a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m06a.csv")
# bg.to_csv(["Sequence"] + m07a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m07a.csv")
# bg.to_csv(["Sequence"] + m08a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m08a.csv")
# bg.to_csv(["Sequence"] + m09a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m09a.csv")
# bg.to_csv(["Sequence"] + m10a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m10a.csv")
# bg.to_csv(["Sequence"] + m11a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m11a.csv")
# bg.to_csv(["Sequence"] + m12a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m12a.csv")
# bg.to_csv(["Sequence"] + m13a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m13a.csv")
# bg.to_csv(["Sequence"] + m14a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m14a.csv")
# bg.to_csv(["Sequence"] + m15a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m15a.csv")
# bg.to_csv(["Sequence"] + m16a_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m16a.csv")

# bg.to_csv(["Sequence"] + m01b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m01b.csv")
# bg.to_csv(["Sequence"] + m02b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m02b.csv")
# bg.to_csv(["Sequence"] + m03b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m03b.csv")
# bg.to_csv(["Sequence"] + m04b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m04b.csv")
# bg.to_csv(["Sequence"] + m05b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m05b.csv")
# bg.to_csv(["Sequence"] + m06b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m06b.csv")
# bg.to_csv(["Sequence"] + m07b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m07b.csv")
# bg.to_csv(["Sequence"] + m08b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m08b.csv")
# bg.to_csv(["Sequence"] + m09b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m09b.csv")
# bg.to_csv(["Sequence"] + m10b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m10b.csv")
# bg.to_csv(["Sequence"] + m11b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m11b.csv")
# bg.to_csv(["Sequence"] + m12b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m12b.csv")
# bg.to_csv(["Sequence"] + m13b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m13b.csv")
# bg.to_csv(["Sequence"] + m14b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m14b.csv")
# bg.to_csv(["Sequence"] + m15b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m15b.csv")
# bg.to_csv(["Sequence"] + m16b_16m, "#{LINUX_SAVE_PATH}2x16M_8H/m16b.csv")

# z_2x16h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 48, 0.5, 1)
# p z_score

# bg = BondGenerator.new

# # s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 150, [], count=5, number=2, overlap=0.25, godmode=false)
# # p s14_4s4b
# # p "Handle S14 score: #{s14_handles_score}"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 4, 0, 200)
# p z_8h_tail_bonds
# p "Z score: #{z_score}"

# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# p z_8h_head_bonds

# ### Linear Chain 1

# m1a_tw = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"]
# })

# m1b_tw = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"]
# })

# m1c_tw = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"]
# })

# m1d_tw = bg.sequence_generator({
#     "S1" => [s14_4s4b[3][0], "BS"]
# })

# m1e_tw = bg.sequence_generator({
#     "S1" => [s14_4s4b[4][0], "BS"]
# })

# ### Linear Chain 2

# m2a_tw = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m2b_tw = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# m2c_tw = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })

# m2d_tw = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
# })

# m2e_tw = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"]
# })

# # 1x2

# m1a_1x2_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_1x2_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_1x2_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_1x2_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# # 1x3

# m1a_1x3_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_1x3_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_1x3_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_1x3_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# m1c_1x3_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m2c_1x3_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# # 1x4

# m1a_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# m1c_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[4]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m2c_1x4_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[5]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# m1d_1x4_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[4])
# m2d_1x4_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[5])

# # 1x5

# m1a_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])

# m1b_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# m1c_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[4]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m2c_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[5]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# m1d_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[6]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[4])
# m2d_1x5_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[7]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[5])

# m1e_1x5_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[6])
# m2e_1x5_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[7])

# # 1x2

# m1a_1x2 = m1a_tw + m1a_1x2_z_seqs
# m1b_1x2 = m1b_tw + m1b_1x2_z_seqs

# m2a_1x2 = m2a_tw + m2a_1x2_z_seqs
# m2b_1x2 = m2b_tw + m2b_1x2_z_seqs

# # 1x3

# m1a_1x3 = m1a_tw + m1a_1x3_z_seqs
# m1b_1x3 = m1b_tw + m1b_1x3_z_seqs
# m1c_1x3 = m1c_tw + m1c_1x3_z_seqs

# m2a_1x3 = m2a_tw + m2a_1x3_z_seqs
# m2b_1x3 = m2b_tw + m2b_1x3_z_seqs
# m2c_1x3 = m2c_tw + m2c_1x3_z_seqs

# # 1x4

# m1a_1x4 = m1a_tw + m1a_1x4_z_seqs
# m1b_1x4 = m1b_tw + m1b_1x4_z_seqs
# m1c_1x4 = m1c_tw + m1c_1x4_z_seqs
# m1d_1x4 = m1d_tw + m1d_1x4_z_seqs

# m2a_1x4 = m2a_tw + m2a_1x4_z_seqs
# m2b_1x4 = m2b_tw + m2b_1x4_z_seqs
# m2c_1x4 = m2c_tw + m2c_1x4_z_seqs
# m2d_1x4 = m2d_tw + m2d_1x4_z_seqs

# # 1x5

# m1a_1x5 = m1a_tw + m1a_1x5_z_seqs
# m1b_1x5 = m1b_tw + m1b_1x5_z_seqs
# m1c_1x5 = m1c_tw + m1c_1x5_z_seqs
# m1d_1x5 = m1d_tw + m1d_1x5_z_seqs
# m1e_1x5 = m1e_tw + m1e_1x5_z_seqs

# m2a_1x5 = m2a_tw + m2a_1x5_z_seqs
# m2b_1x5 = m2b_tw + m2b_1x5_z_seqs
# m2c_1x5 = m2c_tw + m2c_1x5_z_seqs
# m2d_1x5 = m2d_tw + m2d_1x5_z_seqs
# m2e_1x5 = m2e_tw + m2e_1x5_z_seqs

# basic_zs = bg.get_basic_zs
# # p "Basic Z: #{bg.basic_zs}"

# # 1x2
# bg.to_csv(["Sequence"] + m1a_1x2 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1a_1x2.csv")
# bg.to_csv(["Sequence"] + m1b_1x2 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1b_1x2.csv")

# bg.to_csv(["Sequence"] + m2a_1x2 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2a_1x2.csv")
# bg.to_csv(["Sequence"] + m2b_1x2 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2b_1x2.csv")

# # 1x3
# bg.to_csv(["Sequence"] + m1a_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1a_1x3.csv")
# bg.to_csv(["Sequence"] + m1b_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1b_1x3.csv")
# bg.to_csv(["Sequence"] + m1c_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1c_1x3.csv")

# bg.to_csv(["Sequence"] + m2a_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2a_1x3.csv")
# bg.to_csv(["Sequence"] + m2b_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2b_1x3.csv")
# bg.to_csv(["Sequence"] + m2c_1x3 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2c_1x3.csv")

# # 1x4
# bg.to_csv(["Sequence"] + m1a_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1a_1x4.csv")
# bg.to_csv(["Sequence"] + m1b_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1b_1x4.csv")
# bg.to_csv(["Sequence"] + m1c_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1c_1x4.csv")
# bg.to_csv(["Sequence"] + m1d_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1d_1x4.csv")

# bg.to_csv(["Sequence"] + m2a_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2a_1x4.csv")
# bg.to_csv(["Sequence"] + m2b_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2b_1x4.csv")
# bg.to_csv(["Sequence"] + m2c_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2c_1x4.csv")
# bg.to_csv(["Sequence"] + m2d_1x4 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2d_1x4.csv")

# # 1x5
# bg.to_csv(["Sequence"] + m1a_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1a_1x5.csv")
# bg.to_csv(["Sequence"] + m1b_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1b_1x5.csv")
# bg.to_csv(["Sequence"] + m1c_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1c_1x5.csv")
# bg.to_csv(["Sequence"] + m1d_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1d_1x5.csv")
# bg.to_csv(["Sequence"] + m1e_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m1e_1x5.csv")

# bg.to_csv(["Sequence"] + m2a_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2a_1x5.csv")
# bg.to_csv(["Sequence"] + m2b_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2b_1x5.csv")
# bg.to_csv(["Sequence"] + m2c_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2c_1x5.csv")
# bg.to_csv(["Sequence"] + m2d_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2d_1x5.csv")
# bg.to_csv(["Sequence"] + m2e_1x5 + basic_zs, "#{LINUX_SAVE_PATH}1xTW/m2e_1x5.csv")

# ext = "/Users/samsonpetrosyan/Desktop/hexoland/sequences/1xTW/"
# files = ["m1a_1x2.csv", "m2a_1x2.csv", "m1b_1x3.csv", "m2b_1x3.csv", "m1c_1x3.csv", "m2c_1x3.csv", "m1d_1x4.csv", "m2d_1x4.csv", "m1e_1x5.csv", "m2e_1x5.csv"]

# files.each do |file|
#     all_seqs =  bg.read_csv(ext + file)
#     all_bonds = bg.recover_only_z_bonds(all_seqs)
    
#     p file, all_bonds
# end


# bg = BondGenerator.new

# # s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 150, [], count=5, number=2, overlap=0.25, godmode=false)
# # p s14_4s4b
# # p "Handle S14 score: #{s14_handles_score}"

# MAC_SAVE_PATH = "/Users/samsonpetrosyan/Desktop/hexoland/sequences/"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 4, 0, 1)
# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# basic_zs = bg.get_basic_zs
# p z_8h_tail_bonds
# p "Z score: #{z_score}"

# m1_tmp = bg.sequence_generator({
    
# })

# m1a_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m1b_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m1c_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])
# m1d_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m1e_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# m1a = m1_tmp + m1a_z_seqs
# m1b = m1_tmp + m1b_z_seqs
# m1c = m1_tmp + m1c_z_seqs
# m1d = m1_tmp + m1d_z_seqs
# m1e = m1_tmp + m1e_z_seqs

# bg.to_csv(["Sequence"] + m1a + basic_zs, "#{MAC_SAVE_PATH}1xTW2/m1a_1x5.csv")
# bg.to_csv(["Sequence"] + m1b + basic_zs, "#{MAC_SAVE_PATH}1xTW2/m1b_1x5.csv")
# bg.to_csv(["Sequence"] + m1c + basic_zs, "#{MAC_SAVE_PATH}1xTW2/m1c_1x5.csv")
# bg.to_csv(["Sequence"] + m1d + basic_zs, "#{MAC_SAVE_PATH}1xTW2/m1d_1x5.csv")
# bg.to_csv(["Sequence"] + m1e + basic_zs, "#{MAC_SAVE_PATH}1xTW2/m1e_1x5.csv")

# bg = BondGenerator.new

# s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 1, [], count=3, number=2, overlap=0.0, godmode=false)
# p s14_4s4b
# p "Handle S14 score: #{s14_handles_score}"

# MAC_SAVE_PATH = "/Users/samsonpetrosyan/Desktop/hexoland/sequences/"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 4, 0, 1)
# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# basic_zs = bg.get_basic_zs
# p z_8h_tail_bonds
# p z_8h_head_bonds
# p "Z score: #{z_score}"

# m1a_1x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"]
# })

# m1b_1x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"]
# })

# m1c_1x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"]
# })

# m2a_1x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"]
# })

# m2b_1x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"]
# })

# m2c_1x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"]
# })


# m1a_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m1b_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m1c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# m2a_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m2b_z_seqs = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m2c_z_seqs = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])


# bg.to_csv(["Sequence"] + m1a_1x3 + m1a_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m1a_1x3.csv")
# bg.to_csv(["Sequence"] + m1b_1x3 + m1b_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m1b_1x3.csv")
# bg.to_csv(["Sequence"] + m1c_1x3 + m1c_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m1c_1x3.csv")

# bg.to_csv(["Sequence"] + m2a_1x3 + m2a_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m2a_1x3.csv")
# bg.to_csv(["Sequence"] + m2b_1x3 + m2b_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m2b_1x3.csv")
# bg.to_csv(["Sequence"] + m2c_1x3 + m2c_z_seqs + basic_zs, "#{MAC_SAVE_PATH}1xTW3/m2c_1x3.csv")

# [[["H60_R_P", "H61_L_P", "H56_R_P", "H56_L_S"], 48.8], [["H60_L_S", "H61_R_S", "H56_L_P", "H56_R_S"], 50.1], [["H61_R_P", "H60_L_P", "H57_R_P", "H57_L_P"], 50.8]]
# "Handle S14 score: 0.0"
# [[["H21_H22", "H23_H24"], "H62_H63", ["H35_H36", "H37_H38"], "H44_H45"], ["H48_H49", "H1_H2", ["H18", "H19_H20"], ["H55", "H53_H54"]], [["H27", "H25_H26"], "H4_H5", "H16_H17", "H10_H11"], ["H34_H3", "H12_H13", "H50_H51", "H66_H67"]]
# "Z score: 0.0"


# bg = BondGenerator.new

# s14_handles, s14_handles_score = bg.best_sides_out_of("S14", "handles", 10, [], count=4, number=2, overlap=0.0, godmode=false)
# s25_handles, s25_handles_score = bg.best_sides_out_of("S25", "handles", 10, [], count=2, number=2, overlap=0.0, godmode=false)
# s36_handles, s36_handles_score = bg.best_sides_out_of("S36", "handles", 10, [], count=4, number=2, overlap=0.0, godmode=false)


# s14_hinges, s14_hinges_score = bg.best_sides_out_of("S14", "hinges", 10, [], count=4, number=2, overlap=0.0, godmode=false)
# s25_hinges, s25_hinges_score = bg.best_sides_out_of("S25", "hinges", 10, [], count=2, number=2, overlap=0.0, godmode=false)
# s36_hinges, s36_hinges_score = bg.best_sides_out_of("S36", "hinges", 10, [], count=4, number=2, overlap=0.0, godmode=false)


# p s14_handles, s14_hinges 
# p "Handle S14 score: #{s14_handles_score}"
# p "Hinge S14 score: #{s14_hinges_score}"

# p s25_handles, s25_hinges
# p "Handle S25 score: #{s25_handles_score}"
# p "Hinge S25 score: #{s25_hinges_score}"

# p s36_handles, s36_hinges
# p "Handle S36 score: #{s36_handles_score}"
# p "Hinge S36 score: #{s36_hinges_score}"

# # Layer 1

# m1a_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"]

# })

# m2a_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_hinges[0][0], "B"],
#     "S2" => [s25_hinges[0][0], "B"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m3a_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_hinges[1][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"]

# })

# m2b_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_hinges[2+0][0], "B"],
#     "S2" => [s25_hinges[1+0][0], "B"],
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"]
# })

# m3b_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_bot = bg.sequence_generator({
#     "S1" => [s14_hinges[2+1][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

# ### Hierarhical Stage II

# # Layer 1

# m1a_2x2x2_top = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[0][0]), "B"]

# })

# m2a_2x2x2_top = bg.sequence_generator({
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m3a_2x2x2_top = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[1][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[0][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_top = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_top = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[2][0]), "B"],

# })

# m2b_2x2x2_top = bg.sequence_generator({
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"]
# })

# m3b_2x2x2_top = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[3][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[1][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_top = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

# MAC_SAVE_PATH = "/Users/samsonpetrosyan/Desktop/hexoland/sequences/"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 4, 0, 10)
# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# basic_zs = bg.get_basic_zs
# p z_8h_tail_bonds, z_8h_head_bonds, z_score

# m1a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])

# m1b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])
# m3b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m4b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# bg.to_csv(["Sequence"] + m1a_2x2x2_bot + m1a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m1a_bot.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_bot + m2a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m2a_bot.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_bot + m3a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m3a_bot.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_bot + m4a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m4a_bot.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_bot + m1b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m1b_bot.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_bot + m2b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m2b_bot.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_bot + m3b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m3b_bot.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_bot + m4b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m4b_bot.csv")

# bg.to_csv(["Sequence"] + m1a_2x2x2_top + m1a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m1a_top.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_top + m2a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m2a_top.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_top + m3a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m3a_top.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_top + m4a_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m4a_top.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_top + m1b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m1b_top.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_top + m2b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m2b_top.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_top + m3b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m3b_top.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_top + m4b_z + basic_zs, "#{MAC_SAVE_PATH}hi-ha-2x2x2x2/m4b_top.csv")

# bg = BondGenerator.new
# s14_4s4b, s14_handles_score = bg.best_sides_out_of("S14", "handles", 1, [], count=3, number=2, overlap=0.0, godmode=false, min_strength=47.0, max_strength=53.0)
# p s14_4s4b
# p "Handle S14 score: #{s14_handles_score}"

# s25_4s4b, s25_handles_score = bg.best_sides_out_of("S25", "handles", 1, [], count=3, number=2, overlap=0.0, godmode=false, min_strength=47.0, max_strength=53.0)
# p s25_4s4b
# p "Handle S25 score: #{s25_handles_score}"

# s36_4s4b, s36_handles_score = bg.best_sides_out_of("S36", "handles", 1, [], count=3, number=2, overlap=0.0, godmode=false, min_strength=47.0, max_strength=53.0)
# p s36_4s4b
# p "Handle S36 score: #{s36_handles_score}"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 6, 0.25, 100)
# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)

# p z_8h_tail_bonds, z_8h_head_bonds, z_score

# basic_zs = bg.get_basic_zs

# # Monomer 1

# m1a_3x3 = bg.sequence_generator({
#     "S2" => [s25_4s4b[0][0], "BS"],
#     "S3" => [s36_4s4b[0][0], "BS"]
# })

# m1b_3x3 = bg.sequence_generator({
#     "S2" => [s25_4s4b[1][0], "BS"],
#     "S3" => [s36_4s4b[1][0], "BS"]
# })

# m1c_3x3 = bg.sequence_generator({
#     "S2" => [s25_4s4b[2][0], "BS"],
#     "S3" => [s36_4s4b[2][0], "BS"]
# })

# # Monomer 2

# m2a_3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"]
# })

# m2b_3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"]
# })

# m2c_3x3 = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"]
# })

# # Monomer 3

# m3a_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
# })

# m3b_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
# })

# m3c_3x3 = bg.sequence_generator({
#     "S1" => [s14_4s4b[2][0], "BS"],
#     "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
# })


# m1a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m1b_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m1c_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])

# m2a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m2b_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m2c_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])

# m3a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m3b_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[5]) + bg.add_z_bonds("HEAD", z_8h_head_bonds[4])
# m3c_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[5])


# bg.to_csv(["Sequence"] + m1a_3x3 + m1a_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m1a.csv")
# bg.to_csv(["Sequence"] + m1b_3x3 + m1b_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m1b.csv")
# bg.to_csv(["Sequence"] + m1c_3x3 + m1c_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m1c.csv")

# bg.to_csv(["Sequence"] + m2a_3x3 + m2a_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m2a.csv")
# bg.to_csv(["Sequence"] + m2b_3x3 + m2b_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m2b.csv")
# bg.to_csv(["Sequence"] + m2c_3x3 + m2c_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m2c.csv")

# bg.to_csv(["Sequence"] + m3a_3x3 + m3a_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m3a.csv")
# bg.to_csv(["Sequence"] + m3b_3x3 + m3b_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m3b.csv")
# bg.to_csv(["Sequence"] + m3c_3x3 + m3c_z + basic_zs, "#{LINUX_SAVE_PATH}3x3M/m3c.csv")


# bg = BondGenerator.new

# s14_handles, s14_handles_score = bg.best_sides_out_of("S14", "handles", 1, [], count=4, number=2, overlap=0.0, godmode=false, min_strength=45.0, max_strength=55.0)
# s25_handles, s25_handles_score = bg.best_sides_out_of("S25", "handles", 1, [], count=2, number=2, overlap=0.0, godmode=false, min_strength=45.0, max_strength=55.0)
# s36_handles, s36_handles_score = bg.best_sides_out_of("S36", "handles", 1, [], count=4, number=2, overlap=0.0, godmode=false, min_strength=45.0, max_strength=55.0)
# p s14_handles, s14_handles_score 
# p "Handle S14 score: #{s14_handles_score}"
# # p "Hinge S14 score: #{s14_hinges_score}"

# p s25_handles, s25_handles_score
# p "Handle S25 score: #{s25_handles_score}"
# # p "Hinge S25 score: #{s25_hinges_score}"

# p s36_handles, s36_handles_score
# p "Handle S36 score: #{s36_handles_score}"
# # p "Hinge S36 score: #{s36_hinges_score}"

# s14_hinges, s14_hinges_score = bg.best_sides_out_of("S14", "hinges", 1, [], count=8, number=2, overlap=0.5, godmode=false, min_strength=45.0, max_strength=55.0)

# p s14_hinges, s14_hinges_score 
# p "Hinge S14 score: #{s14_hinges_score}"

# s25_hinges, s25_hinges_score = bg.best_sides_out_of("S25", "hinges", 1, [], count=10, number=2, overlap=0.5, godmode=false, min_strength=45.0, max_strength=55.0)

# p s25_hinges, s25_hinges_score 
# p "Hinge S25 score: #{s25_hinges_score}"

# s36_hinges, s36_hinges_score = bg.best_sides_out_of("S36", "hinges", 1, [], count=8, number=2, overlap=0.5, godmode=false, min_strength=45.0, max_strength=55.0)

# p s36_hinges, s36_hinges_score 
# p "Hinge S36 score: #{s36_hinges_score}"

# ### Hierarhical Stage I

# # Layer 1

# m1a_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"]

# })

# m2a_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_hinges[0][0], "B"],
#     "S2" => [s25_hinges[0][0], "B"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m3a_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_hinges[2][0], "B"],
#     "S3" => [s36_hinges[0][0], "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_hinges[1][0], "B"],
#     "S2" => [s25_hinges[1][0], "B"],
#     "S3" => [s36_hinges[1][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"]

# })

# m2b_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_hinges[2][0], "B"],
#     "S2" => [s25_hinges[3][0], "B"],
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"]
# })

# m3b_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S2" => [s25_hinges[5][0], "B"],
#     "S3" => [s36_hinges[2][0], "B"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_bot_left = bg.sequence_generator({
#     "S1" => [s14_hinges[3][0], "B"],
#     "S2" => [s25_hinges[4][0], "B"],
#     "S3" => [s36_hinges[3][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

# ### Hierarhical Stage II

# # Layer 1

# m1a_2x2x2_top_left = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[0][0]), "B"]

# })

# m2a_2x2x2_top_left = bg.sequence_generator({
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m3a_2x2x2_top_left = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_hinges[6][0], "B"],
#     "S3" => [s36_hinges[4][0], "B"],
#     "S4" => [bg.complement_side(s14_hinges[1][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[0][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_top_left = bg.sequence_generator({
#     "S3" => [s36_hinges[5][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_top_left = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[2][0]), "B"],

# })

# m2b_2x2x2_top_left = bg.sequence_generator({
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"]
# })

# m3b_2x2x2_top_left = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S2" => [s25_hinges[7][0], "B"],
#     "S3" => [s36_hinges[6][0], "B"],
#     "S4" => [bg.complement_side(s14_hinges[3][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[3][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_top_left = bg.sequence_generator({
#     "S3" => [s36_hinges[7][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

# ### Hierarhical Stage III


# # Layer 1

# m1a_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S6" => [bg.complement_side(s36_hinges[0][0]), "B"]

# })

# m2a_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_hinges[4][0], "B"],
#     "S2" => [s25_hinges[8][0], "B"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[2][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[1][0]), "B"]
# })

# m3a_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_hinges[5][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"],
#     "S6" => [bg.complement_side(s36_hinges[2][0]), "B"]

# })

# m2b_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_hinges[6][0], "B"],
#     "S2" => [s25_hinges[9][0], "B"],
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[5][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[3][0]), "B"]
# })

# m3b_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_bot_right = bg.sequence_generator({
#     "S1" => [s14_hinges[7][0], "B"],
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

# ### Hierarhical Stage IV

# # Layer 1

# m1a_2x2x2_top_right = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[4][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[1][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[4][0]), "B"]

# })

# m2a_2x2x2_top_right = bg.sequence_generator({
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[6][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[5][0]), "B"]
# })

# m3a_2x2x2_top_right = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[5][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[8][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m4a_2x2x2_top_right = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# # Layer 2

# m1b_2x2x2_top_right = bg.sequence_generator({
#     "S1" => [s14_handles[2+0][0], "BS"],
#     "S2" => [s25_handles[1+0][0], "BS"],
#     "S3" => [s36_handles[2+0][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[6][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[4][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[6][0]), "B"]

# })

# m2b_2x2x2_top_right = bg.sequence_generator({
#     "S3" => [s36_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[2+0][0]), "BS"],
#     "S5" => [bg.complement_side(s25_hinges[7][0]), "B"],
#     "S6" => [bg.complement_side(s36_hinges[7][0]), "B"]
# })

# m3b_2x2x2_top_right = bg.sequence_generator({
#     "S1" => [s14_handles[2+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_hinges[7][0]), "B"],
#     "S5" => [bg.complement_side(s25_hinges[9][0]), "B"],
#     "S6" => [bg.complement_side(s36_handles[2+0][0]), "BS"]
# })

# m4b_2x2x2_top_right = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[2+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[1+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2+1][0]), "BS"]
# })

MAC_SAVE_PATH = "/Users/samsonpetrosyan/Desktop/hexoland/sequences/"

# z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(3, 4, 0, 10)
# z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# basic_zs = bg.get_basic_zs
# p z_8h_tail_bonds, z_8h_head_bonds, z_score

# m1a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])

# m1b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])
# m3b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m4b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])


# bg.to_csv(["Sequence"] + m1a_2x2x2_bot_left + m1a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1a_bot_left.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_bot_left + m2a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2a_bot_left.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_bot_left + m3a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3a_bot_left.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_bot_left + m4a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4a_bot_left.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_bot_left + m1b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1b_bot_left.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_bot_left + m2b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2b_bot_left.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_bot_left + m3b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3b_bot_left.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_bot_left + m4b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4b_bot_left.csv")

# bg.to_csv(["Sequence"] + m1a_2x2x2_top_left + m1a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1a_top_left.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_top_left + m2a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2a_top_left.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_top_left + m3a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3a_top_left.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_top_left + m4a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4a_top_left.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_top_left + m1b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1b_top_left.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_top_left + m2b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2b_top_left.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_top_left + m3b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3b_top_left.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_top_left + m4b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4b_top_left.csv")

# bg.to_csv(["Sequence"] + m1a_2x2x2_bot_right + m1a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1a_bot_right.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_bot_right + m2a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2a_bot_right.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_bot_right + m3a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3a_bot_right.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_bot_right + m4a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4a_bot_right.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_bot_right + m1b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1b_bot_right.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_bot_right + m2b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2b_bot_right.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_bot_right + m3b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3b_bot_right.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_bot_right + m4b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4b_bot_right.csv")

# bg.to_csv(["Sequence"] + m1a_2x2x2_top_right + m1a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1a_top_right.csv")
# bg.to_csv(["Sequence"] + m2a_2x2x2_top_right + m2a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2a_top_right.csv")
# bg.to_csv(["Sequence"] + m3a_2x2x2_top_right + m3a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3a_top_right.csv")
# bg.to_csv(["Sequence"] + m4a_2x2x2_top_right + m4a_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4a_top_right.csv")

# bg.to_csv(["Sequence"] + m1b_2x2x2_top_right + m1b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m1b_top_right.csv")
# bg.to_csv(["Sequence"] + m2b_2x2x2_top_right + m2b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m2b_top_right.csv")
# bg.to_csv(["Sequence"] + m3b_2x2x2_top_right + m3b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m3b_top_right.csv")
# bg.to_csv(["Sequence"] + m4b_2x2x2_top_right + m4b_z + basic_zs, "#{MAC_SAVE_PATH}2x2x2x4/m4b_top_right.csv")


bg = BondGenerator.new

# s14_handles, s14_handles_score = bg.best_sides_out_of("S14", "handles", 10, [], count=8, number=2, overlap=0.25, godmode=false, min_strength=47.0, max_strength=55.0)
# s25_handles, s25_handles_score = bg.best_sides_out_of("S25", "handles", 10, [], count=8, number=2, overlap=0.25, godmode=false, min_strength=47.0, max_strength=55.0)
# s36_handles, s36_handles_score = bg.best_sides_out_of("S36", "handles", 10, [], count=8, number=2, overlap=0.25, godmode=false, min_strength=47.0, max_strength=55.0)
# p s14_handles, s14_handles_score 
# p "Handle S14 score: #{s14_handles_score}"

# p s25_handles, s25_handles_score
# p "Handle S25 score: #{s25_handles_score}"

# p s36_handles, s36_handles_score
# p "Handle S36 score: #{s36_handles_score}"

# ### Layer 1

# m1a_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[0][0], "BS"],
#     "S2" => [s25_handles[0][0], "BS"],
#     "S3" => [s36_handles[0][0], "BS"]
# })

# m2a_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[1][0], "BS"],
#     "S2" => [s25_handles[1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[0][0]), "BS"]
# })

# m3a_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[2][0], "BS"],
#     "S5" => [bg.complement_side(s25_handles[1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[1][0]), "BS"]
# })

# m4a_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[3][0], "BS"],
#     "S2" => [s25_handles[3][0], "BS"],
#     "S3" => [s36_handles[1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[2][0]), "BS"]
# })

# m5a_2x7m = bg.sequence_generator({
#     "S2" => [s25_handles[2][0], "BS"],
#     "S3" => [s36_handles[2][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[0][0]), "BS"]
# })

# m6a_2x7m = bg.sequence_generator({
#     "S3" => [s36_handles[3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[2][0]), "BS"]
# })

# m7a_2x7m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[3][0]), "BS"]
# })

# ### Layer 2

# m1b_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[4+0][0], "BS"],
#     "S2" => [s25_handles[4+0][0], "BS"],
#     "S3" => [s36_handles[4+0][0], "BS"]
# })

# m2b_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[4+1][0], "BS"],
#     "S2" => [s25_handles[4+1][0], "BS"],
#     "S6" => [bg.complement_side(s36_handles[4+0][0]), "BS"]
# })

# m3b_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[4+2][0], "BS"],
#     "S5" => [bg.complement_side(s25_handles[4+1][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4+1][0]), "BS"]
# })

# m4b_2x7m = bg.sequence_generator({
#     "S1" => [s14_handles[4+3][0], "BS"],
#     "S2" => [s25_handles[4+3][0], "BS"],
#     "S3" => [s36_handles[4+1][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4+1][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4+0][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4+2][0]), "BS"]
# })

# m5b_2x7m = bg.sequence_generator({
#     "S2" => [s25_handles[4+2][0], "BS"],
#     "S3" => [s36_handles[4+2][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4+0][0]), "BS"]
# })

# m6b_2x7m = bg.sequence_generator({
#     "S3" => [s36_handles[4+3][0], "BS"],
#     "S4" => [bg.complement_side(s14_handles[4+3][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4+2][0]), "BS"]
# })

# m7b_2x7m = bg.sequence_generator({
#     "S4" => [bg.complement_side(s14_handles[4+2][0]), "BS"],
#     "S5" => [bg.complement_side(s25_handles[4+3][0]), "BS"],
#     "S6" => [bg.complement_side(s36_handles[4+3][0]), "BS"]
# })

z_8h_tail_bonds, z_score = bg.best_z_bonds_out_of(4, 12, 0.4, 10)
z_8h_head_bonds = bg.z_complement_side(z_8h_tail_bonds)
# basic_zs = bg.get_basic_zs
p z_8h_tail_bonds, z_8h_head_bonds, z_score

# m1a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
# m2a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
# m3a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
# m4a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
# m5a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
# m6a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
# m7a_z = bg.add_z_bonds("TAIL", z_8h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])

# m1b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[0])
# m2b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[1])
# m3b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[2])
# m4b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[3])
# m5b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[4])
# m6b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[5])
# m7b_z = bg.add_z_bonds("TAIL", []) + bg.add_z_bonds("HEAD", z_8h_head_bonds[6])


# bg.to_csv(["Sequence"] + m1a_2x7m + m1a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m1a.csv")
# bg.to_csv(["Sequence"] + m2a_2x7m + m2a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m2a.csv")
# bg.to_csv(["Sequence"] + m3a_2x7m + m3a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m3a.csv")
# bg.to_csv(["Sequence"] + m4a_2x7m + m4a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m4a.csv")
# bg.to_csv(["Sequence"] + m5a_2x7m + m5a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m5a.csv")
# bg.to_csv(["Sequence"] + m6a_2x7m + m6a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m6a.csv")
# bg.to_csv(["Sequence"] + m7a_2x7m + m7a_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m7a.csv")

# bg.to_csv(["Sequence"] + m1b_2x7m + m1b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m1b.csv")
# bg.to_csv(["Sequence"] + m2b_2x7m + m2b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m2b.csv")
# bg.to_csv(["Sequence"] + m3b_2x7m + m3b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m3b.csv")
# bg.to_csv(["Sequence"] + m4b_2x7m + m4b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m4b.csv")
# bg.to_csv(["Sequence"] + m5b_2x7m + m5b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m5b.csv")
# bg.to_csv(["Sequence"] + m6b_2x7m + m6b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m6b.csv")
# bg.to_csv(["Sequence"] + m7b_2x7m + m7b_z + basic_zs, "#{MAC_SAVE_PATH}2x7M/m7b.csv")
