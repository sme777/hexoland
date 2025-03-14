require 'set'
require 'csv'
require 'timeout'

# BOND_PATH = "/home/spetrosyan/Desktop/hexoland/app/assets/sequences/bond.csv"
# BASIC_Z_PATH = "/home/spetrosyan/Desktop/hexoland/app/assets/sequences/basic_z.csv"

BOND_PATH =  Rails.root.join("app/assets/sequences/bond.csv")
BASIC_Z_PATH = Rails.root.join("app/assets/sequences/basic_z.csv")

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
        if seq == "BS"
            return 0.5
        end
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
        
        if (number == 0.5 || number == 1.5 || number == 2.5) || (number * 2 > 4)
            if side == "S14"
                return group_randomizer(BondGenerator.single_s14_sides[0] + BondGenerator.single_s14_sides[1], number * 2)
            elsif side == "S25"
                return group_randomizer(BondGenerator.single_s25_sides[0] + BondGenerator.single_s25_sides[1], number * 2)
            elsif side == "S36"
                return group_randomizer(BondGenerator.single_s36_sides[0] + BondGenerator.single_s36_sides[1], number * 2)
            end
        end
        # p "we should not be here"
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
                    (count > 4 ? sample_from_hinges(BondGenerator.s14_hinges, false).flatten : sample_from_hinges(BondGenerator.s14_hinges, true).flatten)
            elsif side == "S25"
                return type == "handles" ? 
                    group_randomizer(BondGenerator.s25_sides[0], number) + group_randomizer(BondGenerator.s25_sides[1], number) :
                    (count > 4 ? sample_from_hinges(BondGenerator.s25_hinges, false).flatten : sample_from_hinges(BondGenerator.s25_hinges, true).flatten)
            elsif side == "S36"
                return type == "handles" ? 
                    group_randomizer(BondGenerator.s36_sides[0], number) + group_randomizer(BondGenerator.s36_sides[1], number) :
                    (count > 4 ? sample_from_hinges(BondGenerator.s36_hinges, false).flatten : sample_from_hinges(BondGenerator.s36_hinges, true).flatten)
            end
        end

        # end
    end

    def group_randomizer(elements, number)
        random_samples = []
        # p number
        while random_samples.size != number
            random_element = elements.sample
            ### Only filter out poral bonds when number is equal to 2 ###
            ### By doing this we disallow any two band directly next to each other ###
            ### NOTE this is only possible with bonds less than 5 ###
            if number < 5
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

    def get_even_combinations(group_a_bonds, group_b_bonds)
        get_combinations(group_a_bonds, group_b_bonds)
    end

    def get_odd_combinations(group_a_bonds, group_b_bonds)
        three_bond_combinations = []
      
        total_combinations = [group_a_bonds, group_b_bonds].map(&:size).min
      
        total_combinations.times do
          if rand(2).zero?
            # Choose 2 bonds from group_a_bonds and 1 from group_b_bonds
            group_a_bonds.combination(2).each do |bond_a_pair|
              # Check if the first 5 characters of the two bonds from group_a_bonds don't overlap
              next if bond_a_pair[0][0..4] == bond_a_pair[1][0..4]
      
              group_b_bonds.each do |bond_b|
                combination = bond_a_pair + [bond_b]
      
                # Sort the combination to ensure consistent ordering
                combination.sort_by! do |x|
                  class_order = x.is_a?(String) ? 0 : 1  # Strings first, Arrays last
                  [class_order, x.to_s]
                end
      
                three_bond_combinations << combination
              end
            end
          else
            # Choose 2 bonds from group_b_bonds and 1 from group_a_bonds
            group_b_bonds.combination(2).each do |bond_b_pair|
              # Check if the first 5 characters of the two bonds from group_b_bonds don't overlap
              next if bond_b_pair[0][0..4] == bond_b_pair[1][0..4]
      
              group_a_bonds.each do |bond_a|
                combination = bond_b_pair + [bond_a]
      
                # Sort the combination to ensure consistent ordering
                combination.sort_by! do |x|
                  class_order = x.is_a?(String) ? 0 : 1  # Strings first, Arrays last
                  [class_order, x.to_s]
                end
      
                three_bond_combinations << combination
              end
            end
          end
        end
      
        # Remove duplicates by converting the array to a set and back to an array
        three_bond_combinations.uniq!
        three_bond_combinations
    end
      

    def get_combinations(*groups)
        all_combinations = []
    
        # Recursive function to generate combinations for any number of groups
        def generate_combinations(current_combination, remaining_groups, all_combinations)
            if remaining_groups.empty?
                # Sort each combination to ensure consistent ordering
                sorted_combination = current_combination.sort_by do |x|
                    class_order = x.is_a?(String) ? 0 : 1  # Strings first, Arrays last
                    [class_order, x.to_s]  # Sort by class order, then by string representation
                end
                all_combinations << sorted_combination
            else
                current_group = remaining_groups[0]
                current_group.each do |bond|
                    generate_combinations(current_combination + [bond], remaining_groups[1..], all_combinations)
                end
            end
        end
    
        # Start the recursive combination generation
        generate_combinations([], groups, all_combinations)
        
        # Remove duplicates by converting the array to a set and back to an array
        all_combinations.uniq
    end

    def best_sides_out_of_w_reference(side, ref_bonds, samples, bond_count)
        # Classify bonds into groups
        # byebug
        if side == "S14"
            bonds_list = BondGenerator.s14_sides.flatten
            group_a_bonds = bonds_list.select { |bond| bond.start_with?('H60', 'H61') }
            group_b_bonds = bonds_list.select { |bond| bond.start_with?('H56', 'H57') }
            if bond_count.even?
                combinations = get_even_combinations(group_a_bonds, group_b_bonds)
            else
                combinations = get_odd_combinations(group_a_bonds, group_b_bonds)
            end         
        elsif side == "S25"
            bonds_list = BondGenerator.s25_sides.flatten
            group_a_bonds = bonds_list.select { |bond| bond.start_with?('H54', 'H53') }
            group_b_bonds = bonds_list.select { |bond| bond.start_with?('H50', 'H49') }
            if bond_count.even?
                combinations = get_even_combinations(group_a_bonds, group_b_bonds)
            else
                combinations = get_odd_combinations(group_a_bonds, group_b_bonds)
            end
        elsif side == "S36"
            bonds_list = BondGenerator.s36_sides.flatten
            group_a_bonds = bonds_list.select { |bond| bond.start_with?('H46', 'H47') }
            group_b_bonds = bonds_list.select { |bond| bond.start_with?('H42', 'H43') }
            if bond_count.even?
                combinations = get_even_combinations(group_a_bonds, group_b_bonds)
            else
                combinations = get_odd_combinations(group_a_bonds, group_b_bonds)
            end
        elsif side == "Z"
            if bond_count == 1
                combinations = BondGenerator.tail_z_helices.map {|bond| [bond]}
            elsif bond_count == 2
                combinations = get_combinations(BondGenerator.tail_groups_2bonds[0], BondGenerator.tail_groups_2bonds[1])
            elsif bond_count == 4
                combinations = get_combinations(BondGenerator.tail_groups_4bonds[0], 
                                                BondGenerator.tail_groups_4bonds[1],
                                                BondGenerator.tail_groups_4bonds[2],
                                                BondGenerator.tail_groups_4bonds[3])
            end
        end
        # Generate all possible two-bond combinations with one bond from each group
      
        # Calculate overlap with four-bond systems for each two-bond combination
        overlap_with_ref_bonds = {}
        combinations.each do |two_bond|
          total_overlap = 0
          two_bond_set = two_bond.to_set
          ref_bonds.each do |four_bond|
            overlap = (two_bond_set & four_bond.to_set).size
            total_overlap += overlap
          end
          overlap_with_ref_bonds[two_bond] = total_overlap
        end
      
        # Initialize selected two-bond systems
        selected_two_bond_systems = []
        remaining_two_bond_systems = combinations.dup
      
        while selected_two_bond_systems.size < samples && !remaining_two_bond_systems.empty?
          # Evaluate each candidate two-bond system
          best_two_bond = nil
          minimal_cost = nil
      
          remaining_two_bond_systems.each do |candidate|
            # Overlap with four-bond systems
            overlap_four_bond = overlap_with_ref_bonds[candidate]
      
            # Mutual overlap with already selected two-bond systems
            mutual_overlap = selected_two_bond_systems.sum do |selected|
              (candidate.to_set & selected.to_set).size
            end
      
            # Total cost (Weights can be adjusted if necessary)
            total_cost = overlap_four_bond + mutual_overlap
      
            if minimal_cost.nil? || total_cost < minimal_cost
              minimal_cost = total_cost
              best_two_bond = candidate
            end
          end
      
          # Add the best candidate to the selected list
          if best_two_bond
            selected_two_bond_systems << best_two_bond
            remaining_two_bond_systems.delete(best_two_bond)
          else
            break # No suitable candidate found
          end
        end
        
        filtered_bonds = []
        selected_two_bond_systems.each do |bonds|
            if side == "Z"
                filtered_bonds << bonds
            else
                filtered_bonds << [bonds, sum_fes_of(bonds)]
        
            end
        end
        filtered_bonds
      end 

    def best_sides_out_of(side, type="handles", samples=10, reference=[], count=1, number=4, max_overlap=0.5, godemode=False, min_strength=0.0, max_strength=110.0)
        if number == 0
          return [Array.new(count) { [[], []] }, 0]
        end

        if number == 0
            return [[], 0]
        end
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

    def configure_blocks(design_map)
      blocks = design_map.keys
      structure_map = {}
      messages = []
      structure = blocks[0]
      if blocks.size == 1
        if !design_map[structure]["building_blocks"].nil?
          raise ArgumentError, "The building block cannot be non-empty for single structures."
        end
        bond_families = design_map[structure]["bond_families"]
        bond_map = design_map[structure]["bond_map"]
        structure_map["metadata"] = {
            "building_blocks" => design_map[structure]["building_blocks"],
            "ignore_generation" => design_map[structure]["ignore_generation"],
            "repulsive_type" => design_map[structure]["repulsive_type"],
            "bond_families" => bond_families,
        }
        
        bond_families.each do |bond_family_name, bond_family_params|
            begin
                Timeout.timeout(60) do
                    structure_map[structure] = build_from_neighbors(bond_map, bond_family_name, bond_family_params)
                end
            rescue Timeout::Error
                Rails.logger.error "The process took too long and was terminated."
                raise "The process took too long to complete."
            end    
        end
                                       
      else
        # First build structures with no dependencies
        
        structure_map["metadata"] = []
        blocks.each do |block|
          next unless design_map[block]["building_blocks"].nil?
          bond_families = design_map[block]["bond_families"]
          bond_map = design_map[block]["bond_map"]
          structure_map["metadata"] << [{
            "building_blocks" => design_map[block]["building_blocks"],
            "ignore_generation" => design_map[block]["ignore_generation"],
            "bond_families" => bond_families,
          }]
          bond_families.each do |bond_family_name, bond_family_params|
            begin
                Timeout.timeout(60) do
                    structure_map[block] = build_from_neighbors(bond_map, bond_family_name, bond_family_params)
                end
            rescue Timeout::Error
                Rails.logger.error "The process took too long and was terminated."
                raise "The process took too long to complete."
            end    
          end
        end

        # second build structures with no 1 layer dependencies
        blocks.each do |block|
            bond_families = design_map[block]["bond_families"]
            bond_map = design_map[block]["bond_map"]
            structure_map["metadata"] << [{
                "building_blocks" => design_map[block]["building_blocks"],
                "ignore_generation" => design_map[block]["ignore_generation"],
                "bond_families" => bond_families,
            }]
            next if design_map[block]["building_blocks"].nil?
            
            used_bonds = {"S1" => [], "S2" => [], "S3" => [], "ZU" => []}

            design_map[block]["building_blocks"].each do |component, quantity|
                count_bonds(structure_map[component]).each do |key, bonds|
                    used_bonds[key] << bonds
                end
                quantity.times do |idx|
                    structure_map["#{component}##{idx+1}"] = Marshal.load(Marshal.dump(structure_map[component]))
                end
            end

            bond_families.each do |bond_family_name, bond_family_params|
                begin 
                    Timeout.timeout(60) do
                    pairing_map, block_messages = build_from_blocks(bond_map, bond_family_name, bond_family_params)
                    next if pairing_map.nil?
                    messages << block_messages
    
                    pairing_map.each do |pairing, bonds|
                        pair1, pair2 = pairing.split('-')
                        # For 2x7M#1-2x7M#2
                        name1, idx1 = pair1.split('#') # This would be 2x7M and 1 for example
                        name2, idx2 = pair2.split('#') # This would be 2x7M and 2 for example
        
                        bonds.each do |bond_name, bond|
                            monomer, block_id = bond_name[/(.*)#/, 1], bond_name[/#(.*)/, 1]
                            name = block_id == idx1 ? name1 : name2
                            bond.each do |side, bs|
                                structure_map["#{name}##{block_id}"][monomer][side] = bs
                            end
                        end
                    end
                    structure_map
                    end
                rescue Timeout::Error
                    Rails.logger.error "The process took too long and was terminated."
                    raise "The process took too long to complete."
                end   
            end
             
        end
      end

        # delete any blocks that should be ignored
        design_map.each do |block_name, block_map|
            if block_map["ignore_generation"] && structure_map.include?(block_name)
                structure_map.delete(block_name)
            end
        end

        [structure_map, messages]
    end


    def adjust_repulsive_bonds(structure_map)
        structure_map.each do |structure, bond_map|
            next if structure == "metadata"
            bond_map.each do |block, side_map|
                side_map.each do |side, bds|

                    if bds[0].is_a?(Array)
                        bond_type = bds[0][1]
                        b_count, t_count = bond_type.match(/(\d+)B(\d+)T/).captures.map(&:to_i)
                        t_bonds = []
                        
                        BondGenerator.orbitals[side].each do |orbital|
                            break if t_bonds.size == t_count
                            next unless !bds[1][0].any? { |bond| bond.include?(orbital) }
                            if !BondGenerator.exception_pairs.keys.include?(orbital)
                                t_bonds << "#{orbital}_B"
                            end
                        end 
                        bds[1][0] = bds[1][0] + t_bonds                       
                    end
                end
            end
        end
        structure_map
    end

    def find_common_attr_bonds(bond_families, keyword)
        attr_bond_map = {}
        bond_families.each do |family_name, family_attributes|
            if attr_bond_map.key?(family_attributes[keyword])
                attr_bond_map[family_attributes[keyword]] += 1
            else
                attr_bond_map[family_attributes[keyword]] = 1
            end 
        end
        attr_bond_map.max_by { |key, value| value }.first
        
    end

    def count_bonds(block)
        interface_map = {"S1" => [], "S2" => [], "S3" => [], "ZU" => []}
        block.each do |key, bond_map|
            bond_map.each do |key, bonds|
                if key == "S1" || key == "S2" || key == "S3"
                    interface_map[key] << bonds[1][0]
                elsif key == "ZU"
                    interface_map[key] << bonds[1]
                end 
            end
        end
        interface_map
    end

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

    def evaluate_bonds(parent, design1, design2, side)
        unless design1.nil?
            overlap_score1 = compute_overlap_score(parent, design1)

            overlap_score2 = compute_overlap_score(parent, design2)
            

            ["Optimized Score for #{side}: #{overlap_score1.round(2)}", "Regular Score for #{side}: #{overlap_score2.round(2)}"] 
        end
    end

    def build_from_blocks(block_map, bond_family_name, bond_family_params)
        messages = []
        
        s1_side_count, s2_side_count, s3_side_count = 0, 0, 0
        s4_side_count, s5_side_count, s6_side_count = 0, 0, 0
        z_tail_count, z_head_count = 0, 0
        block_map.each do |pairing, bonding|
            # block_map[pairing].each do |monomer|
            bonding.each do |monomer, sides|
                sides.each do |side, neighbor|
                    if side == "S1" && neighbor[1] == bond_family_name
                        s1_side_count += 1
                    elsif side == "S2" && neighbor[1] == bond_family_name
                        s2_side_count += 1
                    elsif side == "S3" && neighbor[1] == bond_family_name
                        s3_side_count += 1
                    elsif side == "S4" && neighbor[1] == bond_family_name
                        s4_side_count += 1
                    elsif side == "S5" && neighbor[1] == bond_family_name
                        s5_side_count += 1
                    elsif side == "S6" && neighbor[1] == bond_family_name
                        s6_side_count += 1
                    elsif side == "ZU" && neighbor[1] == bond_family_name
                        z_tail_count += 1
                    elsif side == "ZD" && neighbor[1] == bond_family_name
                        z_head_count += 1
                    end
                end
            end
        end
        ### Set S14, S25, S36 side count 
        s14_side_count, last_s14_idx = [s1_side_count, s4_side_count].max, [s1_side_count, s4_side_count].min
        s25_side_count, last_s25_idx = [s2_side_count, s5_side_count].max, [s2_side_count, s5_side_count].min
        s36_side_count, last_s36_idx = [s3_side_count, s6_side_count].max, [s3_side_count, s6_side_count].min
        z_count, last_z_idx = [z_tail_count, z_head_count].max, [z_tail_count, z_head_count].min
        
        ### Check if all bonds are 0, meaning this bond family is noy used
        if s14_side_count == 0 && s25_side_count == 0 && s36_side_count == 0 && z_count == 0
            return nil, nil
        end
        # s14s = best_sides_out_of_w_reference("S14", used_bonds["S1"][0], s14_side_count, attr_bonds) unless s14_side_count == 0
        # s25s = best_sides_out_of_w_reference("S25", used_bonds["S2"][0], s25_side_count, attr_bonds) unless s25_side_count == 0
        # s36s = best_sides_out_of_w_reference("S36", used_bonds["S3"][0], s36_side_count, attr_bonds) unless s36_side_count == 0
        
        s14s, s14_score = best_sides_out_of("S14", "handles", 
                                    bond_family_params["xy_trials"], [],
                                    count=s14_side_count, 
                                    number=bond_family_params["bonds_attractive"]/2.0, 
                                    overlap=bond_family_params["max_xy_overlap"],
                                    godmode=false, 
                                    bond_family_params["min_xy_fe"],
                                    bond_family_params["max_xy_fe"]) unless s14_side_count == 0

        s25s, s25_score = best_sides_out_of("S25", "handles", 
                                    bond_family_params["xy_trials"], [],
                                    count=s25_side_count, 
                                    number=bond_family_params["bonds_attractive"]/2.0, 
                                    overlap=bond_family_params["max_xy_overlap"],
                                    godmode=false, 
                                    bond_family_params["min_xy_fe"],
                                    bond_family_params["max_xy_fe"]) unless s25_side_count == 0

        s36s, s36_score = best_sides_out_of("S36", "handles", 
                                    bond_family_params["xy_trials"], [],
                                    count=s36_side_count, 
                                    number=bond_family_params["bonds_attractive"]/2.0, 
                                    overlap=bond_family_params["max_xy_overlap"],
                                    godmode=false, 
                                    bond_family_params["min_xy_fe"],
                                    bond_family_params["max_xy_fe"]) unless s36_side_count == 0

        z_tails, z_score = best_z_bonds_out_of(bond_family_params["z_bonds"], 
                                                z_count, 
                                                bond_family_params["max_z_overlap"], 
                                                bond_family_params["z_trials"], 
                                                bond_family_params["min_z_fe"], 
                                                bond_family_params["max_z_fe"]) unless z_count == 0

        s14_idx, s25_idx, s36_idx, z_idx = 0, 0, 0, 0
        # first iterate over sides S1, S2, S3 to assign the bonds
        block_map.each do |pairing, bonding|  
            bonding.each do |monomer, sides|
                sides.each do |side, neighbor_conn|
                    neighbor, conn = neighbor_conn[0], neighbor_conn[1]
                    if side == "S1" && conn == bond_family_name
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s14s[s14_idx][0], s14_score]]
                        s14_idx += 1
                    elsif side == "S2" && conn == bond_family_name
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s25s[s25_idx][0], s25_score]]
                        s25_idx += 1
                    elsif side == "S3" && conn == bond_family_name
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s36s[s36_idx][0], s36_score]]
                        s36_idx += 1
                    elsif side == "ZU" && conn == bond_family_name
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [z_tails[z_idx], z_score]]
                        z_idx += 1
                    end
                end
            end
        end

        curr_last_s14_idx_count, curr_last_s25_idx_count, curr_last_s36_idx_count = last_s14_idx, last_s25_idx, last_s36_idx
        curr_z_idx_count = last_z_idx
        # second iterate over sides S4, S5, S6 to assign the complementary bonds
        block_map.each do |pairing, bonding|
            bonding.each do |monomer, sides|
                sides.each do |side, neighbor_conn|
                    neighbor, conn = neighbor_conn[0], neighbor_conn[1]
                    if side == "S4" && conn == bond_family_name
                        if block_map[pairing][neighbor].nil?
                            s4_bonds = complement_side(s14s[curr_last_s14_idx_count][0])
                            curr_last_s14_idx_count += 1
                        else
                            s4_bonds = complement_side(block_map[pairing][neighbor]["S1"][1][0])
                        end

                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s4_bonds, s14_score]]

                    elsif side == "S5" && conn == bond_family_name
                        if block_map[pairing][neighbor].nil?
                            s5_bonds = complement_side(s25s[curr_last_s25_idx_count][0])
                            curr_last_s25_idx_count += 1
                        else
                            s5_bonds = complement_side(block_map[pairing][neighbor]["S2"][1][0])
                        end
                        
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s5_bonds, s25_score]]
                    elsif side == "S6" && conn == bond_family_name
                        if block_map[pairing][neighbor].nil?
                            s6_bonds = complement_side(s36s[curr_last_s36_idx_count][0])
                            curr_last_s36_idx_count += 1
                        else
                            s6_bonds = complement_side(block_map[pairing][neighbor]["S3"][1][0])
                        end
                        
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [s6_bonds, s36_score]]

                    elsif side == "ZD" && conn == bond_family_name
                        if block_map[pairing][neighbor].nil?
                            z_head = z_complement_side([z_tails[curr_z_idx_count]])
                            curr_z_idx_count += 1
                        else
                            z_head = z_complement_side([block_map[pairing][neighbor]["ZU"][1][0]])
                        end
                        
                        block_map[pairing][monomer][side] = [block_map[pairing][monomer][side], [z_head[0], z_score]]

                    end
                end
            end
        end

        [block_map, messages]
    end

    def build_from_neighbors(neighbor_map, bond_family_name, bond_family_params)
        # Stores sequence list for each monomer
        block_sequences = {}
        # Stores neighbor map for information
        # block_neighbors = {}
        # Count of each side
        s1_side_count, s2_side_count, s3_side_count = 0, 0, 0
        s4_side_count, s5_side_count, s6_side_count = 0, 0, 0
        z_tail_count, z_head_count = 0, 0
        neighbor_map.each do |block, neighbors|
            block_sequences[block] = []
            neighbors.each do |side, neighbor|
                # block_neighbors[block] = {}
                if side == "S1" && neighbor[1] == bond_family_name
                    s1_side_count += 1
                elsif side == "S2" && neighbor[1] == bond_family_name
                    s2_side_count += 1
                elsif side == "S3" && neighbor[1] == bond_family_name
                    s3_side_count += 1
                elsif side == "S4" && neighbor[1] == bond_family_name
                    s4_side_count += 1
                elsif side == "S5" && neighbor[1] == bond_family_name
                    s5_side_count += 1
                elsif side == "S6" && neighbor[1] == bond_family_name
                    s6_side_count += 1
                elsif side == "ZU" && neighbor[1] == bond_family_name
                    z_tail_count += 1
                elsif side == "ZD" && neighbor[1] == bond_family_name
                    z_head_count += 1
                end
            end
        end
        ### Set S14, S25, S36 side count 
        s14_side_count, last_s14_idx = [s1_side_count, s4_side_count].max, [s1_side_count, s4_side_count].min
        s25_side_count, last_s25_idx = [s2_side_count, s5_side_count].max, [s2_side_count, s5_side_count].min
        s36_side_count, last_s36_idx = [s3_side_count, s6_side_count].max, [s3_side_count, s6_side_count].min
        z_count, last_z_idx = [z_tail_count, z_head_count].max, [z_tail_count, z_head_count].min
        
        ### Generate the Bond of Each Side
        s14s, s14_score = best_sides_out_of("S14", "handles", 
                                            bond_family_params["xy_trials"], [], 
                                            count=s14_side_count, 
                                            number=bond_family_params["bonds_attractive"]/2.0, 
                                            overlap=bond_family_params["max_xy_overlap"],
                                            godmode=false, 
                                            bond_family_params["min_xy_fe"], 
                                            bond_family_params["max_xy_fe"]) unless s14_side_count == 0
        
        s25s, s25_score = best_sides_out_of("S25", "handles", 
                                            bond_family_params["xy_trials"], [], 
                                            count=s25_side_count, 
                                            number=bond_family_params["bonds_attractive"]/2.0, 
                                            overlap=bond_family_params["max_xy_overlap"], 
                                            godmode=false, 
                                            bond_family_params["min_xy_fe"], 
                                            bond_family_params["max_xy_fe"]) unless s25_side_count == 0
        
        s36s, s36_score = best_sides_out_of("S36", "handles", 
                                            bond_family_params["xy_trials"], [], 
                                            count=s36_side_count, 
                                            number=bond_family_params["bonds_attractive"]/2.0, 
                                            overlap=bond_family_params["max_xy_overlap"], 
                                            godmode=false, 
                                            bond_family_params["min_xy_fe"], 
                                            bond_family_params["max_xy_fe"]) unless s36_side_count == 0
        
        z_tails, z_score = best_z_bonds_out_of(bond_family_params["z_bonds"], 
                                        z_count, 
                                        bond_family_params["max_z_overlap"], 
                                        bond_family_params["z_trials"], 
                                        bond_family_params["min_z_fe"], 
                                        bond_family_params["max_z_fe"]) unless z_count == 0
        s14_idx, s25_idx, s36_idx, z_idx = 0, 0, 0, 0
        neighbor_map.each do |block, neighbors|
            neighbors.each do |side, neighbor|
                if side == "S1" && neighbor[1] == bond_family_name
                    if s14s.size == 0
                        # block_neighbors[block][side] = [[], s14_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [[], s14_score]]
                    else
                        # block_neighbors[block][side] = [s14s[s14_idx][0], s14_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [s14s[s14_idx][0], s14_score]]
                    end
                    s14_idx += 1
                elsif side == "S2" && neighbor[1] == bond_family_name
                    if s25s.size == 0
                        # block_neighbors[block][side] = [[], s25_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [[], s25_score]]
                    else
                        # block_neighbors[block][side] = [s25s[s25_idx][0], s25_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [s25s[s25_idx][0], s25_score]]
                    end

                    s25_idx += 1
                elsif side == "S3" && neighbor[1] == bond_family_name
                    if s36s.size == 0
                        # block_neighbors[block][side] = [[], s36_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [[], s36_score]]
                    else
                        # block_neighbors[block][side] = [s36s[s36_idx][0], s36_score]
                        neighbor_map[block][side] = [neighbor_map[block][side], [s36s[s36_idx][0], s36_score]]
                    end
                    s36_idx += 1
                elsif side == "ZU" && neighbor[1] == bond_family_name
                    neighbor_map[block][side] = [neighbor_map[block][side], [z_tails[z_idx], z_score]]
                    z_idx += 1
                end
            end
        end
        curr_last_s14_idx_count, curr_last_s25_idx_count, curr_last_s36_idx_count = last_s14_idx, last_s25_idx, last_s36_idx
        curr_z_idx_count = last_z_idx

        neighbor_map.each do |block, neighbors|
            neighbors.each do |side, neighbor_group|
                neighbor = neighbor_group[0]
                if side == "S4" && neighbor_group[1] == bond_family_name
                    if neighbor_map[neighbor].nil?
                        s4_bonds = complement_side(s14s[curr_last_s14_idx_count][0])
                        curr_last_s14_idx_count += 1
                    else
                        s4_bonds = complement_side(neighbor_map[neighbor]["S1"][1][0])
                    end
                    
                    # block_neighbors[block][side] = [s4_bonds, s14_score]
                    neighbor_map[block][side] = [neighbor_map[block][side], [s4_bonds, s14_score]]
                elsif side == "S5" && neighbor_group[1] == bond_family_name
                    if neighbor_map[neighbor].nil?
                        s5_bonds = complement_side(s25s[curr_last_s25_idx_count][0])
                        curr_last_s25_idx_count += 1
                    else
                        s5_bonds = complement_side(neighbor_map[neighbor]["S2"][1][0])
                    end
                    neighbor_map[block][side] = [neighbor_map[block][side], [s5_bonds, s25_score]]
                elsif side == "S6" && neighbor_group[1] == bond_family_name
                    if neighbor_map[neighbor].nil?
                        s6_bonds = complement_side(s36s[curr_last_s36_idx_count][0])
                        curr_last_s36_idx_count += 1
                    else
                        s6_bonds = complement_side(neighbor_map[neighbor]["S3"][1][0])
                    end
                    neighbor_map[block][side] = [neighbor_map[block][side], [s6_bonds, s36_score]]
                elsif side == "ZD" && neighbor_group[1] == bond_family_name
                    if neighbor_map[neighbor].nil?
                        z_head = z_complement_side([z_tails[curr_z_idx_count]])
                        curr_z_idx_count += 1
                    else
                        z_head = z_complement_side([neighbor_map[neighbor]["ZU"][1][0]])
                    end
                    neighbor_map[block][side] = [neighbor_map[block][side], [z_head[0], z_score]]
                end
            end
        end
        neighbor_map
    end

    def generate_sequences(bond_map, metadata)
        bond_map.each do |pairing, bonding|
            next if pairing == "metadata"
            bonding.each do |block, neighbors|
                # bond_family = neighbors[0][1]
                # repulsive_type = (metadata.nil? || metadata[bond_family]["repulsive_type"].nil?) ? "B" : metadata[bond_family]["repulsive_type"]

                all_seqs = sequence_generator(bonding[block], "X")
                all_seqs += @basic_zs

                if bonding[block].keys.include?("ZU") #include_z_bonds && 
                    all_seqs += add_z_bonds("TAIL", bonding[block]["ZU"][1][0])
                else
                    all_seqs += add_z_bonds("TAIL", [])
                end

                if bonding[block].keys.include?("ZD") #include_z_bonds && 
                    all_seqs += add_z_bonds("HEAD", bonding[block]["ZD"][1][0])
                else
                    all_seqs += add_z_bonds("HEAD", [])
                end
                if all_seqs.size != 112
                    byebug
                  raise StandardError, "Sequences is not the right number!"
                end
                bonding[block]["Sequences"] = all_seqs
            end
        end
        bond_map
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


    def sequence_generator(hex, repulsive_type)
        seq_arr = []
        
        BondGenerator.sides.each do |side|
            if hex[side].nil?
                seq_arr << add_blockers(side, repulsive_type)
            else
                seq_arr << add_bonds(side, hex[side][1][0], "BS") # hex[side][1][1] this will always be BS since we don't want poly-T right next to a sticky end
                seq_arr << add_repulsive(side, hex[side][1][0], repulsive_type)
                seq_arr << add_neutrals(side, hex[side][1][0], "BS", repulsive_type)
            end
        end
        seq_arr.flat_map { |sublist| Array(sublist) }.uniq
    end


    def add_repulsive(side, bonds, repulsive_type)
        seqs = []
        bonds.each do |bond|
            if bond.end_with?("_B")
                seqs << @bond_map[bond]
            end
        end
        seqs
    end

    def add_neutrals(side, bonds, type, repulsive_type)
        neutral_seqs = []
        # multi = false
        # # byebug
        # if !(type == "BS" || type == "T")
        #   multi = true
        #   b_count, t_count = type.match(/(\d+)B(\d+)T/).captures.map(&:to_i)
        #   t_bonds_assigned = 0
        #   type = "BS"
        # end
        # Parse the 'type' argument to dynamically assign bonds like '4B2T'
        
        # Initialize bond type index
        # bond_idx = 0

        BondGenerator.orbitals[side].each do |orbital|
            next unless !bonds.any? { |bond| bond.include?(orbital) }
            if !BondGenerator.exception_pairs.keys.include?(orbital)
                # if multi && (t_bonds_assigned < t_count)
                #     neutral_seqs << @bond_map["#{orbital}_B"]
                #     t_bonds_assigned += 1
                # else
                neutral_seqs << @bond_map["#{orbital}_#{type}"]
                # end
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
                    puts "Bonds BS-BS unavailable here and will be subed with TTTTT-TTTTT: #{orbital}, #{pair}"
                    if @bond_map["#{orbital}_B_AND_#{pair}_B"]
                        neutral_seqs << @bond_map["#{orbital}_B_AND_#{pair}_B"]
                    elsif @bond_map["#{pair}_B_AND_#{orbital}_B"]
                        neutral_seqs << @bond_map["#{pair}_B_AND_#{orbital}_B"]
                    else
                        raise "Bond not found with locations #{orbital} and #{pair}"
                    end                    
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
    def add_blockers(side, repulsive_type)
        blocker_seqs = []
        blocker_map = {
            "S1" => ["H61", "H60", "H57", "H56"],
            "S2" => ["H54", "H53", "H50", "H49"],
            "S3" => ["H47", "H46", "H43", "H42"],
            "S4" => ["H35", "H36", "H39", "H40"],
            "S5" => ["H70", "H71", "H32", "H33"],
            "S6" => ["H68", "H67", "H64", "H63"]
        }

        exceptions_B = {
            "S1" => ["H60_R_B_AND_H61_R_B"],
            "S2" => [],
            "S3" => ["H42_L_B_AND_H43_L_B", "H46_L_B_AND_H47_L_B"],
            "S4" => [],
            "S5" => ["H71_L_B_AND_H70_L_B", "H33_L_B_AND_H32_L_B"],
            "S6" => []
        }

        exceptions_O = {
            "S1" => ["H60_R_O_AND_H61_R_O"],
            "S2" => [],
            "S3" => ["H42_L_O_AND_H43_L_O", "H46_L_O_AND_H47_L_O"],
            "S4" => [],
            "S5" => ["H71_L_O_AND_H70_L_O", "H33_L_O_AND_H32_L_O"],
            "S6" => []
        }

        exceptions_S = {
            "S1" => ["H60_R_S_AND_H61_R_S"],
            "S2" => [],
            "S3" => ["H42_L_S_AND_H43_L_S", "H46_L_S_AND_H47_L_S"],
            "S4" => [],
            "S5" => ["H71_L_S_AND_H70_L_S", "H33_L_S_AND_H32_L_S"],
            "S6" => []
        }

        exceptions_X = {
            "S1" => ["H60_R_X_AND_H61_R_X"],
            "S2" => [],
            "S3" => ["H42_L_X_AND_H43_L_X", "H46_L_X_AND_H47_L_X"],
            "S4" => [],
            "S5" => ["H71_L_X_AND_H70_L_X", "H33_L_X_AND_H32_L_X"],
            "S6" => []
        }

        blocker_map[side].each do |helix| 
            if repulsive_type == "B"
                blocker_seqs << @bond_map["#{helix}_L_B"] unless @bond_map["#{helix}_L_B"].nil?
                blocker_seqs << @bond_map["#{helix}_R_B"] unless @bond_map["#{helix}_R_B"].nil?
            elsif repulsive_type == "O"
                blocker_seqs << @bond_map["#{helix}_L_O"] unless @bond_map["#{helix}_L_O"].nil?
                blocker_seqs << @bond_map["#{helix}_R_O"] unless @bond_map["#{helix}_R_O"].nil?
            elsif repulsive_type == "S"
                blocker_seqs << @bond_map["#{helix}_L_S"] unless @bond_map["#{helix}_L_S"].nil?
                blocker_seqs << @bond_map["#{helix}_R_S"] unless @bond_map["#{helix}_R_S"].nil?
            elsif repulsive_type == "X"
                blocker_seqs << @bond_map["#{helix}_L_X"] unless @bond_map["#{helix}_L_X"].nil?
                blocker_seqs << @bond_map["#{helix}_R_X"] unless @bond_map["#{helix}_R_X"].nil?
            end
        end

        if repulsive_type == "B"
            exceptions_B[side].each do |exception|
                blocker_seqs << @bond_map[exception]
            end
        elsif repulsive_type == "O"
            exceptions_O[side].each do |exception|
                blocker_seqs << @bond_map[exception]
            end
        elsif repulsive_type == "S"
            exceptions_S[side].each do |exception|
                blocker_seqs << @bond_map[exception]
            end
        elsif repulsive_type == "X"
            exceptions_X[side].each do |exception|
                blocker_seqs << @bond_map[exception]
            end
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

    def compute_z_fe(arr)

        # BondGenerator.bond2gibbs_z.each do |key, values|
        #     p values
        #     next unless values != []
        #     fes = values.map {|bond| BondGenerator.fe_of(bond) }
        #     p "Free energy of bond #{key} is #{fes}, and total of #{fes.sum}"
        # end


        fe = 0.0
        arr.each do |bonds|
            if bonds.is_a?(Array)
                query_bonds =  BondGenerator.bond2gibbs_z["#{bonds[0]}_&_#{bonds[1]}"]
                p bonds if query_bonds.nil?
            else
                query_bonds = BondGenerator.bond2gibbs_z[bonds]
                p bonds if query_bonds.nil?
            end
            query_bonds.each do |seq|
                fe += BondGenerator.fe_of(seq)
            end
        end
        fe
    end

    def z_bond_sampler(count, number, max_overlap, min_ge=0, max_ge=120)
        # all_edges = BondGenerator.tail_groups.map { |group| group.sample }
        random_samples = []
        capacity = count > 10 ? 1000 : 500
        current_count = 0
        while random_samples.size  != number
            # random_helices = BondGenerator.tail_groups_4bonds.map {|group| group.sample }
            if count == 2
                random_helices = BondGenerator.tail_groups_2bonds.map {|group| group.sample }
            elsif count == 3
                random_helices = BondGenerator.tail_groups_3bonds.map {|group| group.sample }
            elsif count == 4
                random_helices = BondGenerator.tail_groups_4bonds.map {|group| group.sample }
            elsif count == 5
                random_helices = BondGenerator.tail_groups_5bonds.map {|group| group.sample }
            elsif count == 6
                random_helices = BondGenerator.tail_groups_6bonds.map {|group| group.sample }
            else
                random_helices = BondGenerator.tail_groups_1bonds.sample(count)
            end
            # random_samples_fe = 
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
            group_fe = compute_z_fe(random_helices)
            if should_add && (group_fe > min_ge && group_fe < max_ge)
                random_samples << random_helices
                # p group_fe
            end

            current_count += 1

            # Reset Sides if Stuck at Local Minima
            if current_count > capacity
                current_count = 0
                random_samples = []
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

    def best_z_bonds_out_of(bond_size, bond_quantity, max_overlap, trials, min_ge=0, max_ge=120)
        sample_map = sample_z_bonds(bond_size, bond_quantity, max_overlap, trials, min_ge, max_ge)
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

    def sample_z_bonds(bond_size, bond_quantity, max_overlap, trials, min_ge=0, max_ge=120)
        sample_map = []
        trials.times do |_|
            bonds = z_bond_sampler(bond_size, bond_quantity, max_overlap, min_ge, max_ge)
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
        # byebug if all_z_bonds.include?(nil)
        all_edges = side == "TAIL" ? BondGenerator.tail_z_helices : BondGenerator.head_z_helices

        # H58_H59, H58#1_H59#1 

        all_edges.each do |helix_group|
            if helix_group.kind_of?(Array)
                puts "#{helix_group[0]}_Z_#{side}_P" if @bond_map["#{helix_group[0]}_Z_#{side}_P"].nil?
                puts "#{helix_group[1]}_Z_#{side}_P" if @bond_map["#{helix_group[1]}_Z_#{side}_P"].nil?
                all_z_bonds << @bond_map["#{helix_group[0]}_Z_#{side}_P"] unless any_non_continuous_substring?(bonds.flatten, helix_group[0]) #bonds.flatten.include?(helix_group[0])
                all_z_bonds << @bond_map["#{helix_group[1]}_Z_#{side}_P"] unless any_non_continuous_substring?(bonds.flatten, helix_group[1]) #bonds.flatten.include?(helix_group[1])
            else
                puts "#{helix_group}_Z_#{side}_P" if @bond_map["#{helix_group}_Z_#{side}_P"].nil?
                all_z_bonds << @bond_map["#{helix_group}_Z_#{side}_P"] unless any_non_continuous_substring?(bonds.flatten, helix_group) #bonds.include?(helix_group)
            end
        end
        all_z_bonds
    end

    def any_non_continuous_substring?(array, reference)
        new_array = array.map {|elem| elem.gsub(/#\d*/, '')}
        new_array.include?(reference)
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

    # def self.tail_groups_2bonds
    #   [
    #     ["H1_H2", "H34_H3", "H4_H5", ["H35_H36", "H37_H38"], "H66_H67", ["H27", "H25_H26"], "H62_H63", ["H21_H22", "H23_H24"]],
    #     ["H10_H11", "H8_H9", "H44_H45", "H12_H13", "H48_H49", "H58_H59", ["H18", "H19_H20"], ["H55", "H53_H54"], "H16_H17", "H50_H51"]
    #   ]
    # end

    def self.tail_groups_4bonds
        [
            ["H1_H2", "H34_H3", "H4#1_H5#1", "H4#2_H5#2", ["H35_H36", "H37_H38"], ["H39_H40", "H41"]],
            ["H8#1_H9#1", "H8#2_H9#2", "H44_H45", "H10#1_H11#1", "H10#2_H11#2", "H12_H13"],
            ["H48#1_H49#1", "H48#2_H49#2", "H50#1_H51#1", "H50#2_H51#2", "H16#1_H17#1", "H16#2_H17#2", ["H55", "H53_H54"], ["H18", "H19_H20"]],
            ["H58#1_H59#1", "H58#2_H59#2", ["H21_H22", "H23_H24"], "H62_H63", "H66_H67", ["H27#1", "H25#1_H26#1"], ["H27#2", "H25#2_H26#2"]],
        ]
    end

    def self.tail_groups_5bonds
        [
            ["H1_H2", "H34_H3", "H66_H67", ["H27#1", "H25#1_H26#1"], ["H27#2", "H25#2_H26#2"]],
            ["H4#1_H5#1", "H4#2_H5#2", ["H35_H36", "H37_H38"], "H8#1_H9#1", "H8#2_H9#2", ["H39_H40", "H41"]],
            ["H44_H45", "H10#1_H11#1", "H10#2_H11#2", "H12_H13", "H48#1_H49#1", "H48#2_H49#2"],
            ["H50#1_H51#1", "H50#2_H51#2", "H16#1_H17#1", "H16#2_H17#2", ["H55", "H53_H54"]],
            [["H18", "H19_H20"], "H58#1_H59#1", "H58#2_H59#2", ["H21_H22", "H23_H24"], "H62_H63"],
        ]
    end

    def self.tail_groups_6bonds
        [
            ["H1_H2", "H34_H3", "H4#1_H5#1", "H4#2_H5#2", ["H35_H36", "H37_H38"]],
            ["H8#1_H9#1", "H8#2_H9#2", "H44_H45", ["H39_H40", "H41"]],
            ["H10#1_H11#1", "H10#2_H11#2", "H12_H13", "H48#1_H49#1", "H48#2_H49#2"],
            ["H50#1_H51#1", "H50#2_H51#2", "H16#1_H17#1", "H16#2_H17#2", ["H55", "H53_H54"]],
            [["H18", "H19_H20"], "H58#1_H59#1", "H58#2_H59#2", ["H21_H22", "H23_H24"]],
            ["H62_H63", "H66_H67", ["H27#1", "H25#1_H26#1"], ["H27#2", "H25#2_H26#2"]]

        ]
    end

    # def self.tail_groups_3bonds
    #     [["H1_H2", "H34_H3", "H4_H5", ["H35_H36", "H37_H38"]],
    #      ["H10_H11", "H8_H9", "H44_H45", "H12_H13", "H48_H49", "H50_H51"],
    #      ["H66_H67", ["H27", "H25_H26"], "H62_H63", ["H21_H22", "H23_H24"], "H58_H59", ["H18", "H19_H20"], ["H55", "H53_H54"]]]
    # end

    def self.tail_groups_1bonds
        ["H58#1_H59#1", "H50#1_H51#1", "H48#1_H49#1", ["H39_H40", "H41"], ["H27#1", "H25#1_H26#1"], "H16#1_H17#1", "H10#1_H11#1", "H8#1_H9#1", "H4#1_H5#1", 
        "H58#2_H59#2", "H50#2_H51#2", "H48#2_H49#2", ["H27#2", "H25#2_H26#2"], "H16#2_H17#2", "H10#2_H11#2", "H8#2_H9#2", "H4#2_H5#2",
        "H1_H2", ["H35_H36", "H37_H38"], "H44_H45", "H66_H67",  "H62_H63", "H34_H3", "H12_H13", 
        ["H55", "H53_H54"], ["H21_H22", "H23_H24"], ["H18", "H19_H20"]]
    end

    # def self.head_groups_1bonds
    #     ["H58#1_H59#1",  "H50#1_H51#1", "H48#1_H49#1", "H26#1_H27#1", "H16#1_H17#1", "H10#1_H11#1",
    #     "H8#1_H9#1", "H4#1_H5#1", "H58#2_H59#2",  "H50#2_H51#2", "H48#2_H49#2", "H40_H41", "H26#2_H27#2", "H16#2_H17#2", "H10#2_H11#2",
    #     "H8#2_H9#2", "H4#2_H5#2", ["H67_H68", "H66_H65"], "H44_H45", "H36_H37", "H1_H2",
    #     "H34_H3", "H12_H13", ["H63_H64", "H62"], "H54_H55", ["H22", "H23_H24"], ["H18", "H19_H20"]]
    # end

    def self.tail_z_helices
        ["H58_H59", "H50_H51", "H48_H49", ["H39_H40", "H41"], ["H27", "H25_H26"], "H16_H17", "H10_H11", "H8_H9", "H4_H5",
        "H1_H2", ["H35_H36", "H37_H38"], "H44_H45", "H66_H67",  "H62_H63", "H34_H3", "H12_H13", 
        ["H55", "H53_H54"], ["H21_H22", "H23_H24"], ["H18", "H19_H20"]]
    end

    def self.head_z_helices
        ["H58_H59",  "H50_H51", "H48_H49", "H40_H41", "H26_H27", "H16_H17", "H10_H11",
        "H8_H9", "H4_H5", ["H67_H68", "H66_H65"], "H44_H45", "H36_H37", "H1_H2",
        "H34_H3", "H12_H13", ["H63_H64", "H62"], "H54_H55", ["H22", "H23_H24"], ["H18", "H19_H20"]]
    end

    def self.tail2head
        {
            "H1_H2" => "H1_H2",
            "H16#1_H17#1" => "H16#1_H17#1",
            "H16#2_H17#2" => "H16#2_H17#2",
            "H35_H36" => "H36_H37",
            "H37_H38" => "H36_H37",
            "H44_H45" => "H44_H45",
            "H58#1_H59#1" => "H58#1_H59#1",
            "H58#2_H59#2" => "H58#2_H59#2",
            "H66_H67" => ["H67_H68", "H66_H65"],
            "H62_H63" => ["H63_H64", "H62"],
            "H48#1_H49#1" => "H48#1_H49#1",
            "H48#2_H49#2" => "H48#2_H49#2",
            "H34_H3" => "H34_H3",
            "H12_H13" => "H12_H13",
            "H10#1_H11#1" => "H10#1_H11#1",
            "H10#2_H11#2" => "H10#2_H11#2",
            "H8#1_H9#1" => "H8#1_H9#1",
            "H8#2_H9#2" => "H8#2_H9#2",
            "H4#1_H5#1" => "H4#1_H5#1",
            "H4#2_H5#2" => "H4#2_H5#2",
            "H50#1_H51#1" => "H50#1_H51#1",
            "H50#2_H51#2" => "H50#2_H51#2",
            "H55" => "H54_H55",
            "H53_H54" => "H54_H55",
            "H27#1" => "H26#1_H27#1",
            "H25#1_H26#1" => "H26#1_H27#1",
            "H27#2" => "H26#2_H27#2",
            "H25#2_H26#2" => "H26#2_H27#2",
            "H21_H22" => ["H22", "H23_H24"],
            "H23_H24" => ["H22", "H23_H24"],
            "H18" => ["H18", "H19_H20"],
            "H19_H20" => ["H18", "H19_H20"],
            "H39_H40" => "H40_H41",
            "H41" => "H40_H41"
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

    # def self.singles_s36_sides
    #     [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P"], ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P"]]
    # end

    # def self.singles_s25_sides
    #     [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P"], ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P"]]
    # end

    # def self.singles_s14_sides
    #     [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P"], ["H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"]]
    # end

    def self.single_s36_sides
        [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"],
         ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
    end

    def self.single_s25_sides
        [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"],
         ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]]
    end

    def self.single_s14_sides
        [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"],
         ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]]
    end

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

    def compute_z_bond_fe
        BondGenerator.bond2gibbs_z.each do |key, values|
            p values
            next unless values != []
            fes = values.map {|bond| BondGenerator.fe_of(bond) }
            # p "Free energy of bond #{key} is #{fes}, and total of #{fes.sum}"
        end
    end

    def self.bond2gibbs_z
        {
            "H1_H2" => ["AGAAATT", "AGACTTT"],
            "H16#1_H17#1" => ["CGGCCTT", "AGCCCTT"],
            "H16#2_H17#2" => ["AACTATA", "TACCGAC"],
            "H35_H36_&_H37_H38" => ["AGTAAGC", "GTCATAC", "BS", "BS"],
            "H44_H45" => ["GGTGTAG", "TAGGTGT"],
            "H58#1_H59#1" => ["CATCATA", "CCCCAGC"],
            "H58#2_H59#2" => ["CAATAAC", "TTTGACA"],
            "H66_H67" => ["CCAACAG", "GCAAACT", "BS", "BS"],
            "H62_H63" => ["ATATAAT", "TTGCTGA", "BS"],
            "H48#1_H49#1" => ["GCATGTC", "GGAACCC"],
            "H48#2_H49#2" => ["AAACTAG", "CCAATAG"],
            "H34_H3" => ["TTGTAGA", "AAGTATT"],
            "H12_H13" => ["AATTTGC", "AACTGAT"],
            "H10#1_H11#1" => ["ACGAGCG", "AACAACT"],
            "H10#2_H11#2" => ["GAATAGA", "TTCTTTC"],
            "H8#1_H9#1" => ["TCCTTAT", "TAGAGCC"],
            "H8#2_H9#2" => ["TGTCAAA", "CCATTCC"],
            "H4#1_H5#1" => ["CTCCGGC", "TACAGGA"],
            "H4#2_H5#2" => ["CTTTATC", "ATTAGGT"],
            "H50#1_H51#1" => ["ATGAATT", "TCAGGTC"],
            "H50#2_H51#2" => ["AAGCTAA", "TAGTAAT"],
            "H55_&_H53_H54" => ["CAGCAGC", "GAAAGAC", "BS"],
            "H27#1_&_H25#1_H26#1" => ["CGGTCAT", "GTTTTCA", "BS"],
            "H27#2_&_H25#2_H26#2" => ["TGGGTTC", "ATACCTA", "BS"],
            "H21_H22_&_H23_H24" => ["CTGGTTT", "GTCCACG", "BS", "BS"],
            "H18_&_H19_H20" => ["GGCGCGT", "GCTACAG", "BS", "BS", "BS"],
            "H39_H40_&_H41" => ["CGTATAT", "GGGATGA", "BS"]
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

# bg = BondGenerator.new

# s14_handles, s14_handles_score = bg.best_sides_out_of("S14", "handles", 1, [], count=1, number=4, overlap=0.0, godmode=false)

# p s14_handles, s14_handles_score

# p bg.group_randomizer(BondGenerator.s14_sides[0] + BondGenerator.s14_sides[1], 5)

# # p s14_handles, s14_handles_score 
# # p "Handle S14 score: #{s14_handles_score}"
# # s25_handles, s25_handles_score = bg.best_sides_out_of("S25", "handles", 1, [], count=48, number=1, overlap=0.5, godmode=false)
# # p s25_handles, s25_handles_score
# # p "Handle S25 score: #{s25_handles_score}"
# s36_handles, s36_handles_score = bg.best_sides_out_of("S36", "handles", 1, [], count=6, number=3, overlap=0.34, godmode=false)
# p s36_handles, s36_handles_score
# p "Handle S36 score: #{s36_handles_score}"

# z_12h_tail_bonds, z_score = bg.best_z_bonds_out_of(6, 7, 0.17, 100, 0, 200)
# z_12h_head_bonds = bg.z_complement_side(z_12h_tail_bonds)
# # basic_zs = bg.get_basic_zs
# p z_score

# z_12h_tail_bonds.each do |bds|
#   p bds
# end

