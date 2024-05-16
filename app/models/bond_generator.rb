require 'set'
require 'csv'

class BondGenerator

    
    def initialize
        @bond_map = {}
        CSV.foreach("/home/sme777/Desktop/hexoland/app/assets/sequences/bond.csv") do |row|
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

    def randomize_sides(side, number)
        if number == 1
            if side == "S14"
                return group_randomizer(BondGenerator.singles_s14_sides[0], number) + group_randomizer(BondGenerator.singles_s14_sides[1], number)
            elsif side == "S25"
                return group_randomizer(BondGenerator.singles_s25_sides[0], number) + group_randomizer(BondGenerator.singles_s25_sides[1], number)
            elsif side == "S36"
                return group_randomizer(BondGenerator.singles_s36_sides[0], number) + group_randomizer(BondGenerator.singles_s36_sides[1], number)
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


    #### Generate Side Bonds ####
    #############################
    ######## Parameters #########
    ### Side: S14, S25, S36 #####
    ### Count: # of bond sets ###
    ## Number: # of edge bonds ##
    # Overlap: max edge overlap #
    #############################
    #############################
    def generate_sides(side, reference=[], count=1, number=4, max_overlap=0.5, min_strength=0.0, max_strength=110.0)
        sides = reference.map(&:dup)
        current_count = reference.size

        while sides.size < count
            candidate = randomize_sides(side, number)
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
            if current_count > 1000
                current_count = 0
                sides = []
            end
        end
        sides
    end

    def compute_similiarity_matrix(sides)
        sim_mat = []
        sides.each do |side1|
            side_vec = []
            sides.each do |side2|
                total_sum = 0
                unique_set = Set.new(side1[0] + side2[0])
                unique_set.each do |x|
                    total_sum += (side1[0] + side2[0]).count(x) - 1
                end
                side_vec << total_sum.to_f / side1[0].length
            end
            sim_mat << side_vec
        end
        sim_mat
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

bg = BondGenerator.new

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

s14_4s4b = bg.generate_sides("S14", [], count=8, number=2, overlap=0.25)
s25_4s4b = bg.generate_sides("S25", [], count=8, number=2, overlap=0.25)
s36_4s4b = bg.generate_sides("S36", [], count=8, number=2, overlap=0.25)

m1a_7m = bg.sequence_generator({
    "S3" => [s36_4s4b[0][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[0][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[3][0]), "BS"]
})

m2a_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[0][0], "BS"],
    "S2" => [s25_4s4b[0][0], "BS"],
    "S3" => [s36_4s4b[1][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[2][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[2][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[3][0]), "BS"]
})

m3a_7m = bg.sequence_generator({
    "S4" => [bg.complement_side(s14_4s4b[1][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[0][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[0][0]), "BS"]
})

m4a_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[1][0], "BS"],
    "S5" => [bg.complement_side(s25_4s4b[1][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[1][0]), "BS"]
})

m5a_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[2][0], "BS"],
    "S2" => [s25_4s4b[1][0], "BS"],
    "S6" => [bg.complement_side(s36_4s4b[2][0]), "BS"]
})

m6a_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[3][0], "BS"],
    "S2" => [s25_4s4b[2][0], "BS"],
    "S3" => [s36_4s4b[2][0], "BS"],
})

m7a_7m = bg.sequence_generator({
    "S2" => [s25_4s4b[3][0], "BS"],
    "S3" => [s36_4s4b[3][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[3][0]), "BS"]
})


# bottom layer

m1b_7m = bg.sequence_generator({
    "S3" => [s36_4s4b[4][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[4][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[7][0]), "BS"]
})

m2b_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[4][0], "BS"],
    "S2" => [s25_4s4b[4][0], "BS"],
    "S3" => [s36_4s4b[5][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[6][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[6][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[7][0]), "BS"]
})

m3b_7m = bg.sequence_generator({
    "S4" => [bg.complement_side(s14_4s4b[5][0]), "BS"],
    "S5" => [bg.complement_side(s25_4s4b[4][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[4][0]), "BS"]
})

m4b_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[5][0], "BS"],
    "S5" => [bg.complement_side(s25_4s4b[5][0]), "BS"],
    "S6" => [bg.complement_side(s36_4s4b[5][0]), "BS"]
})

m5b_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[6][0], "BS"],
    "S2" => [s25_4s4b[5][0], "BS"],
    "S6" => [bg.complement_side(s36_4s4b[6][0]), "BS"]
})

m6b_7m = bg.sequence_generator({
    "S1" => [s14_4s4b[7][0], "BS"],
    "S2" => [s25_4s4b[6][0], "BS"],
    "S3" => [s36_4s4b[6][0], "BS"],
})

m7b_7m = bg.sequence_generator({
    "S2" => [s25_4s4b[7][0], "BS"],
    "S3" => [s36_4s4b[7][0], "BS"],
    "S4" => [bg.complement_side(s14_4s4b[7][0]), "BS"]
})

z_2x7_6h_tail_bonds = bg.z_bond_sampler(3, 7, "TAIL", 0.34)
z_2x7_6h_head_bonds = bg.z_complement_side(z_2x7_6h_tail_bonds)

m1a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[0]) + bg.add_z_bonds("HEAD", [])
m2a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[1]) + bg.add_z_bonds("HEAD", [])
m3a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[2]) + bg.add_z_bonds("HEAD", [])
m4a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[3]) + bg.add_z_bonds("HEAD", [])
m5a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[4]) + bg.add_z_bonds("HEAD", [])
m6a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[5]) + bg.add_z_bonds("HEAD", [])
m7a_z_seqs = bg.add_z_bonds("TAIL", z_2x7_6h_tail_bonds[6]) + bg.add_z_bonds("HEAD", [])

m1b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[0]) + bg.add_z_bonds("TAIL", [])
m2b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[1]) + bg.add_z_bonds("TAIL", [])
m3b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[2]) + bg.add_z_bonds("TAIL", [])
m4b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[3]) + bg.add_z_bonds("TAIL", [])
m5b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[4]) + bg.add_z_bonds("TAIL", [])
m6b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[5]) + bg.add_z_bonds("TAIL", [])
m7b_z_seqs = bg.add_z_bonds("HEAD", z_2x7_6h_head_bonds[6]) + bg.add_z_bonds("TAIL", [])

s_2x7_m1a_w_z = m1a_7m + m1a_z_seqs
s_2x7_m2a_w_z = m2a_7m + m2a_z_seqs
s_2x7_m3a_w_z = m3a_7m + m3a_z_seqs
s_2x7_m4a_w_z = m4a_7m + m4a_z_seqs
s_2x7_m5a_w_z = m5a_7m + m5a_z_seqs
s_2x7_m6a_w_z = m6a_7m + m6a_z_seqs
s_2x7_m7a_w_z = m7a_7m + m7a_z_seqs

s_2x7_m1b_w_z = m1b_7m + m1b_z_seqs
s_2x7_m2b_w_z = m2b_7m + m2b_z_seqs
s_2x7_m3b_w_z = m3b_7m + m3b_z_seqs
s_2x7_m4b_w_z = m4b_7m + m4b_z_seqs
s_2x7_m5b_w_z = m5b_7m + m5b_z_seqs
s_2x7_m6b_w_z = m6b_7m + m6b_z_seqs
s_2x7_m7b_w_z = m7b_7m + m7b_z_seqs

bg.to_csv(["Sequence"] + s_2x7_m1a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/1a.csv")
bg.to_csv(["Sequence"] + s_2x7_m2a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/2a.csv")
bg.to_csv(["Sequence"] + s_2x7_m3a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/3a.csv")
bg.to_csv(["Sequence"] + s_2x7_m4a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/4a.csv")
bg.to_csv(["Sequence"] + s_2x7_m5a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/5a.csv")
bg.to_csv(["Sequence"] + s_2x7_m6a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/6a.csv")
bg.to_csv(["Sequence"] + s_2x7_m7a_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/7a.csv")

bg.to_csv(["Sequence"] + s_2x7_m1b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/1b.csv")
bg.to_csv(["Sequence"] + s_2x7_m2b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/2b.csv")
bg.to_csv(["Sequence"] + s_2x7_m3b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/3b.csv")
bg.to_csv(["Sequence"] + s_2x7_m4b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/4b.csv")
bg.to_csv(["Sequence"] + s_2x7_m5b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/5b.csv")
bg.to_csv(["Sequence"] + s_2x7_m6b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/6b.csv")
bg.to_csv(["Sequence"] + s_2x7_m7b_w_z, "/home/sme777/Desktop/hexoland/sequences/tower/2x7M/7b.csv")
