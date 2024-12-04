# app/models/assembly.rb
require 'json'

class Assembly < ApplicationRecord
    def compute_neighbors()
      assembly_map = JSON.parse(self.design_map)
      structures = assembly_map.keys
      normalized_assembly_map = normalize_assembly_map(assembly_map)
      [assemble_design_map(normalized_assembly_map, get_spacings)]
    end
  
    def normalize_bonds
      monomer_bonds = normalize_assembly_map(JSON.parse(design_map))
      normalize_bonds_map = {}
      monomer_bonds.each do |monomer, sides|
        normalize_bonds_map[monomer] = {}
        # byebug
        sides.each do |side, bonds|
          unless side == "Sequences"
            if bonds[0].is_a?(Array)
              normalize_bonds_map[monomer][side] = send("#{side}_order", [bonds[0][0], bonds[1]])
            else
              normalize_bonds_map[monomer][side] = send("#{side}_order", bonds)
            end
            
          end
        end
      end
      normalize_bonds_map
    end

    def normalize_assembly_map(assembly_map)
      return assembly_map.values.first if assembly_map.size == 1
      normalized_assembly_map = {}
      assembly_map.each do |structure, local_map|
        local_map.each do |monomer, bonds|
          normalized_assembly_map["#{monomer}#{structure[-2..-1]}"] = add_self_reference(bonds.dup, structure[-2..-1])
        end
      end
      normalized_assembly_map
    end

    def add_self_reference(bonds, number)
      bonds.each do |monomer, bds|
        if !bds[0].include?("#") && !bds[0].is_a?(Array)
          bds[0] = "#{bds[0]}#{number}"
        else
          bds[0] = bds[0][0]
        end
      end
      bonds
    end

    private
  
    def assemble_design_map(assembly_map, spacings)
      horiz, vert, depth = spacings[:horiz], spacings[:vert], spacings[:depth]
      horiz3_4 = horiz * 3 / 4.0
      horiz3_8 = horiz * 3 / 8.0
      vert_div_sqrt3 = vert / Math.sqrt(3)
      # byebug
      monomer_map = construct_monomer_map(assembly_map)
      start_pos = { x: 0, y: 0, z: 0 }
  
      # Use a hash to ensure unique entries by monomer
      assembly_block = {}
  
      assembly_map.each do |monomer, sides|
        monomer_map[monomer] ||= start_pos.dup
        assembly_block[monomer] ||= { position: monomer_map[monomer].dup, monomer: monomer }
  
        hex_pos = monomer_map[monomer]
        # byebug
        sides.each do |side, neighbors|
          neighbor = neighbors.first
          next if monomer_map[neighbor] || side == "Sequences"
  
          neighbor_pos = case side
                         when "S1"
                           { x: hex_pos[:x] + horiz3_4, y: hex_pos[:y], z: hex_pos[:z] }
                         when "S2"
                           { x: hex_pos[:x] + horiz3_8, y: hex_pos[:y], z: hex_pos[:z] + vert_div_sqrt3 }
                         when "S3"
                           { x: hex_pos[:x] - horiz3_8, y: hex_pos[:y], z: hex_pos[:z] + vert_div_sqrt3 }
                         when "S4"
                           { x: hex_pos[:x] - horiz3_4, y: hex_pos[:y], z: hex_pos[:z] }
                         when "S5"
                           { x: hex_pos[:x] - horiz3_8, y: hex_pos[:y], z: hex_pos[:z] - vert_div_sqrt3 }
                         when "S6"
                           { x: hex_pos[:x] - horiz3_8, y: hex_pos[:y], z: hex_pos[:z] - vert_div_sqrt3 }
                         when "ZU"
                           { x: hex_pos[:x], y: hex_pos[:y] + depth + 4.5, z: hex_pos[:z] }
                         when "ZD"
                           { x: hex_pos[:x], y: hex_pos[:y] - (depth + 4.5), z: hex_pos[:z] }
                         end
  
          if neighbor_pos
            monomer_map[neighbor] = neighbor_pos
            assembly_block[neighbor] ||= { position: neighbor_pos, monomer: neighbor }
          end
        end
      end
      # Convert the hash to an array to match the original return format
      assembly_block.values
    end
  
    def construct_monomer_map(assembly_map)
      assembly_map.keys.map { |monomer| [monomer, nil] }.to_h
    end
  
    def get_spacings
      { horiz: 3.0 / 2.0 * 1.5 * 24, vert: Math.sqrt(3) * 1.5 * 24, depth: 50 }
    end

    ####
    # 0 -- socket; 1 -- plug, '-' -- absent/neutral, 'x' -- repulsive
    # Example:
    # [0, '-', 1, 'x', 'x', 1, 0, '-']
    ####
    def configure_bond_type(bond)
      case bond[6..]
      when "P"
        1
      when "S"
        0
      when "BS"
        '-'
      when "B"
        'x'
      else
        raise "Unknown type of bond"
      end
    end

    def S1_order(bonds)
      helix_order = ["H61", "H60", "H57", "H56"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H61_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H61_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H60_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H60_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H57_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H57_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H56_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H56_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def S2_order(bonds)
      helix_order = ["H54", "H53", "H50", "H49"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H54_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H54_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H53_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H53_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H50_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H50_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H49_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H49_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def S3_order(bonds)
      helix_order = ["H47", "H46", "H43", "H42"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H47_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H47_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H46_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H46_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H43_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H43_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H42_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H42_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def S4_order(bonds)
      helix_order = ["H40", "H39", "H36", "H35"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H40_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H40_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H39_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H39_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H36_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H36_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H35_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H35_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def S5_order(bonds)
      helix_order = ["H33", "H32", "H71", "H70"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H33_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H33_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H32_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H32_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H71_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H71_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H70_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H70_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def S6_order(bonds)
      helix_order = ["H68", "H67", "H64", "H63"]
      bond_arr = Array.new(8, '-')
      bonds[1][0].each do |bond|
        case bond[0, 5]
        when "H68_L"
          bond_arr[0] = configure_bond_type(bond)
        when "H68_R"
          bond_arr[1] = configure_bond_type(bond)
        when "H67_L"
          bond_arr[2] = configure_bond_type(bond)
        when "H67_R"
          bond_arr[3] = configure_bond_type(bond)
        when "H64_L"
          bond_arr[4] = configure_bond_type(bond)
        when "H64_R"
          bond_arr[5] = configure_bond_type(bond)
        when "H63_L"
          bond_arr[6] = configure_bond_type(bond)
        when "H63_R"
          bond_arr[7] = configure_bond_type(bond)
        else
        end
      end
      bond_arr
    end

    def ZU_order(bonds)
      # helix_order = (0..71).map { |i| "H#{i}" }
      # bond_arr = Array.new(72, 'x')
      bond_arr = Array.new(72, 'x') 
      bonds[1].each do |bond|
        if bond.is_a?(Array)
          bond.each do |sub_bond|
            helices = sub_bond.split("_")
            helices.each do |helix|
              # byebug
              bond_arr[zBondToIndex[helix]] = 1
            end
          end
        else
          helices = bond.split("_")
          helices.each do |helix|
            # byebug
            bond_arr[zBondToIndex[helix]] = 1
          end
        end
      end
      bond_arr
    end

    def ZD_order(bonds)
      bond_arr = Array.new(72, 'x') 
      bonds[1].each do |bond|
        if bond.is_a?(Array)
          bond.each do |sub_bond|
            helices = sub_bond.split("_")
            helices.each do |helix|
              bond_arr[zBondToIndex[helix]] = 1
            end
          end
        else
          helices = bond.split("_")
          helices.each do |helix|
            bond_arr[zBondToIndex[helix]] = 1
          end
        end
      end
      bond_arr
    end

    def zBondToIndex
      {
        "H21" => 0, "H4" => 1, "H48" => 2, "H60" => 3, "H20" => 4, "H5" => 5, "H59" => 6, "H47" => 7,
        "H69" => 8, "H52" => 9, "H61" => 10, "H7" => 11, "H12" => 12, "H6" => 13, "H3" => 14, "H70" => 15,
        "H50" => 16, "H43" => 17, "H38" => 18, "H13" => 19, "H37" => 20, "H57" => 21, "H35" => 22, "H39" => 23,
        "H25" => 24, "H51" => 25, "H65" => 26, "H36" => 27, "H67" => 28, "H58" => 29, "H32" => 30, "H68" => 31,
        "H24" => 32, "H0" => 33, "H8" => 34, "H40" => 35, "H30" => 36, "H33" => 37, "H26" => 38, "H71" => 39,
        "H27" => 40, "H10" => 41, "H62" => 42, "H44" => 43, "H63" => 44, "H41" => 45, "H64" => 46, "H34" => 47,
        "H42" => 48, "H53" => 49, "H66" => 50, "H16" => 51, "H54" => 52, "H23" => 53, "H18" => 54, "H31" => 55,
        "H2" => 56, "H9" => 57, "H1" => 58, "H45" => 59, "H56" => 60, "H14" => 61, "H22" => 62, "H55" => 63,
        "H29" => 64, "H11" => 65, "H15" => 66, "H46" => 67, "H49" => 68, "H28" => 69, "H17" => 70, "H19" => 71
    } end

    def z_attractive_bonds
      
    end
end
  