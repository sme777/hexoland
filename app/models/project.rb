require_relative '../lib/constants.rb'

class Project < ApplicationRecord
    ############# Description ################
    ### This class handles conversion from ###
    ### the coordinate system of the grid  ###
    ### to neighbor, side, and sequence    ###
    ### based on the design in scadnano    ###
    ### the output is a picklist file or a ###
    ### list of sequences that would need  ###
    ### to be added together. This module  ###
    ### uses Gibbs free energy to model    ###
    ### preferred and unpreferred interac- ###
    ### ions in the grid system.           ###
    ##########################################


    def initialize()
    end

    def sum_free_energeis(bonds):
        return sum([bond2gibbs[bond] for bond in bonds])
        
    def compute_free_energy(seq):
        free_energy = 0
        for i in range(len(seq)):
            if i == len(seq)-1:
                break
            free_energy += neighbor_thermodynamics[f"{seq[i]}{seq[i+1]}"]
        return round(free_energy, 4)

    def group_randomizer(arr, number):
        random_samples = []
        for _ in range(number):
            random_element = random.choice(arr)
            should_add = True
            for selected in random_samples:
                variant1 = random_element[0] + str(int(random_element[1:3]) + 1) + random_element[3:]
                variant2 = random_element[0] + str(int(random_element[1:3]) - 1) + random_element[3:]
                
                if selected[:5] == variant1 or selected[:5] == variant2 or any(random_element[:6] in string for string in random_samples):
                    should_add = False
                    break
            
            if should_add:
                random_samples.append(random_element)
        return random_samples
    end

    def sampler(helices, left, right):
        selections = []
        for helix in helices:
            selections.extend([helix + random.sample(left, 1)[0], helix + random.sample(right, 1)[0]])
        return selections
    end


    def randomize_sides(side, number, mode=""):

        s36_sides = [["H42_L_S", "H43_L_S", "H42_L_P", "H43_L_P", "H42_R_S", "H43_R_S", "H42_R_P", "H43_R_P"], \
                        ["H46_L_S", "H47_L_S", "H46_L_P", "H47_L_P", "H46_R_S", "H47_R_S", "H46_R_P", "H47_R_P"]]
        s14_sides = [["H60_L_S", "H61_L_S", "H60_L_P", "H61_L_P", "H60_R_S", "H61_R_S", "H60_R_P", "H61_R_P"], \
                        ["H56_L_S", "H57_L_S", "H56_L_P", "H57_L_P", "H56_R_S", "H57_R_S", "H56_R_P", "H57_R_P"]]
        s25_sides = [["H54_L_S", "H53_L_S", "H54_L_P", "H53_L_P", "H54_R_S", "H53_R_S", "H54_R_P", "H53_R_P"], \
                        ["H50_L_S", "H49_L_S", "H50_L_P", "H49_L_P", "H50_R_S", "H49_R_S", "H50_R_P", "H49_R_P"]]
        
        s36_helices = ["H42", "H43", "H46", "H47"]
        s14_helices = ["H60", "H61", "H56", "H57"]
        s25_helices = ["H54", "H53", "H50", "H49"]
        
        options_left = ["_L_S", "_L_P"]
        options_right = ["_R_S", "_R_P"]
        
        if side == "S14":
            if mode == "full":
                return sampler(s14_helices, options_left, options_right)
            return group_randomizer(s14_sides[0], number) + group_randomizer(s14_sides[1], number)
        elif side == "S25":
            if mode == "full":
                return sampler(s25_helices, options_left, options_right)
            return group_randomizer(s25_sides[0], number) + group_randomizer(s25_sides[1], number)
        elif side == "S36":
            if mode == "full":
                return sampler(s36_helices, options_left, options_right)
            return group_randomizer(s36_sides[0], number) + group_randomizer(s36_sides[1], number)
    end

    def generate_sides(side, count=1, number=4, overlap=0.5, \
        weak_strength_min=49.0, weak_strength_max=52.0, \
        strong_strength_min=95.0, strong_strength_max=105.0,
        mode=""):
        sides = []
        current_count = 0
        strength_max = weak_strength_max if mode == "" else strong_strength_max
        strength_min = weak_strength_min if mode == "" else strong_strength_min

        while len(sides) < count:
        candidate = randomize_sides(side, number, mode)
        if not (strength_min < sum_free_energeis(candidate) < strength_max) \
        or (len(candidate) != 4 and mode == "") \
        or (len(candidate) != 8 and mode == "full"):
        continue
        side_overlap = False
        for side_tuple in sides:
        overlap_percent = sum((candidate + side_tuple[0]).count(x) - 1 for x in set(candidate + side_tuple[0])) / len(candidate)
        if overlap_percent > overlap:
            side_overlap = True
            break
        # Accept Candidate
        if not side_overlap:
        sides.append((candidate, sum_free_energeis(candidate)))
        current_count += 1

        # Reset Sides if stuck at a local minima
        if current_count > 1000:
        current_count = 0
        sides = []
        return sides
    end

    def complement_side(selection):

        helix_comp = {
            "H61": "H35",
            "H60": "H36",
            "H57": "H39",
            "H56": "H40",
            "H42": "H68",
            "H43": "H67",
            "H46": "H64",
            "H47": "H63",
            "H54": "H70",
            "H53": "H71",
            "H50": "H32",
            "H49": "H33"
        }
    
        plug2socket = {
            "P": "S",
            "S": "P"
        }
    
    
        return [(helix_comp[s[:3]] + s[3:6] + plug2socket[s[-1]]) for s in selection] 
    end

    def sequence_generator(monomer, max_size=8):
    
        def add_blockers(side):
            blocked_seqs = []
            blocker_map = {"S1": ["H61", "H60", "H57", "H56"],
                           "S2": ["H54", "H53", "H50", "H49"],
                           "S3": ["H47", "H46", "H43", "H42"],
                           "S4": ["H35", "H36", "H39", "H40"],
                           "S5": ["H70", "H71", "H32", "H33"],
                           "S6": ["H68", "H67", "H64", "H63"]}
            exceptions = {
                "S1": ["H60_R_B_AND_H61_R_B"],
                "S2": [],
                "S3": ["H42_L_B_AND_H43_L_B", "H46_L_B_AND_H47_L_B"],
                "S4": [],
                "S5": ["H71_L_B_AND_H70_L_B", "H33_L_B_AND_H32_L_B"],
                "S6": []
            }
            for helix in blocker_map[side]:
                if len(bond_map[(bond_map['Name']==f'{helix}_L_B')]) > 0:
                    blocked_seqs.append(bond_map[(bond_map['Name']==f'{helix}_L_B')]["Sequence"].tolist()[0])
                if len(bond_map[(bond_map['Name']==f'{helix}_R_B')]) > 0:
                    blocked_seqs.append(bond_map[(bond_map['Name']==f'{helix}_R_B')]["Sequence"].tolist()[0])
                    
    
            for exception in exceptions[side]:
                blocked_seqs.append(bond_map[(bond_map['Name']==exception)]["Sequence"].tolist()[0])
    
            return blocked_seqs
        
        def add_plugs_and_sockets(side, bonds, max_size):
            
            plugs_and_sockets = []
            orbitals = {
                "S1": ["H61_R", "H61_L", "H60_R", "H60_L", "H57_R", "H57_L", "H56_R", "H56_L"],
                "S2": ["H54_R", "H54_L", "H53_R", "H53_L", "H50_R", "H50_L", "H49_R", "H49_L"],
                "S3": ["H47_R", "H47_L", "H46_R", "H46_L", "H43_R", "H43_L", "H42_R", "H42_L"],
                "S4": ["H35_R", "H35_L", "H36_R", "H36_L", "H39_R", "H39_L", "H40_R", "H40_L"],
                "S5": ["H70_R", "H70_L", "H71_R", "H71_L", "H32_R", "H32_L", "H33_R", "H33_L"],
                "S6": ["H68_R", "H68_L", "H67_R", "H67_L", "H64_R", "H64_L", "H63_R", "H63_L"]
            }
    
            exception_pairs = {
                "H71_L": "H70_L",
                "H70_L": "H71_L",
                "H33_L": "H32_L",
                "H32_L": "H33_L",
                "H60_R": "H61_R",
                "H61_R": "H60_R",
                "H42_L": "H43_L",
                "H43_L": "H42_L",
                "H46_L": "H47_L",
                "H47_L": "H46_L",
            }
    
            # Add vacant sockets for partially filled sides
            for orbital in orbitals[side]:
                if any(orbital in string for string in bonds):
                    continue
                else:
                    if orbital not in exception_pairs:
                        # plugs_and_sockets.append(f"{orbital}_S")
                        plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{orbital}_S")]["Sequence"].tolist()[0])
                    elif orbital in exception_pairs and not any(exception_pairs[orbital] in string for string in bonds):
                        if len(bond_map[(bond_map['Name']==f"{orbital}_S_AND_{exception_pairs[orbital]}_S")]) > 0:
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{orbital}_S_AND_{exception_pairs[orbital]}_S")]["Sequence"].tolist()[0])
                        if len(bond_map[(bond_map['Name']==f"{exception_pairs[orbital]}_S_AND_{orbital}_S")]) > 0:
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{exception_pairs[orbital]}_S_AND_{orbital}_S")]["Sequence"].tolist()[0])
    
    
            for bond in bonds:
                if len(bond_map[(bond_map['Name']==bond)]) > 0:
                    # plugs_and_sockets.append(bond)
                    plugs_and_sockets.append(bond_map[(bond_map['Name']==bond)]["Sequence"].tolist()[0])
                else:
                    pair = exception_pairs[bond[:5]]
                    exists = next((string for string in bonds if pair in string), None)
                    if exists is not None:
                        if len(bond_map[(bond_map['Name']==f"{bond}_AND_{exists}")]) > 0:
                            # plugs_and_sockets.append(f"{bond}_AND_{exists}")
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{bond}_AND_{exists}")]["Sequence"].tolist()[0])
                        elif len(bond_map[(bond_map['Name']==f"{exists}_AND_{bond}")]) > 0:
                            # plugs_and_sockets.append(f"{exists}_AND_{bond}")
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{exists}_AND_{bond}")]["Sequence"].tolist()[0])
                    else:
                        if len(bond_map[(bond_map['Name']==f"{bond}_AND_{pair}_S")]) > 0:
                            # plugs_and_sockets.append(f"{bond}_AND_{pair}_S")
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{bond}_AND_{pair}_S")]["Sequence"].tolist()[0])
                        elif len(bond_map[(bond_map['Name']==f"{pair}_S_AND_{bond}")]) > 0:
                            # plugs_and_sockets.append(f"{pair}_S_AND_{bond}")
                            plugs_and_sockets.append(bond_map[(bond_map['Name']==f"{pair}_S_AND_{bond}")]["Sequence"].tolist()[0])
            # print(len(plugs_and_sockets))
            return plugs_and_sockets
    
        seq_arr = []
        sides = ["S1", "S2", "S3", "S4", "S5", "S6"]
    
        for side in sides:
            if side not in monomer:
                seq_arr.append(add_blockers(side))
            else:
                seq_arr.append(add_plugs_and_sockets(side, monomer[side], max_size))
    
        
        return list(set([item for sublist in seq_arr for item in (sublist if isinstance(sublist, list) else [sublist])])) #[list(set(arr)) for arr in seq_arr]
            
    
    end


    def to_picklist()
        
    end

    def to_csv()
        
    end
        
end
