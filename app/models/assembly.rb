# app/models/assembly.rb
require 'json'

class Assembly < ApplicationRecord
    def compute_neighbors()
      assembly_map = JSON.parse(self.design_map)
      structures = assembly_map.keys
      structure_assembly_array = []
  
      structures.each do |key|
        structure_assembly_array << assemble_design_map(assembly_map[key], get_spacings)
      end
  
      structure_assembly_array
    end
  
    private
  
    def assemble_design_map(assembly_map, spacings)
      horiz, vert, depth = spacings[:horiz], spacings[:vert], spacings[:depth]
      horiz3_4 = horiz * 3 / 4.0
      horiz3_8 = horiz * 3 / 8.0
      vert_div_sqrt3 = vert / Math.sqrt(3)
  
      monomer_map = construct_monomer_map(assembly_map)
      start_pos = { x: 0, y: 0, z: 0 }
  
      # Use a hash to ensure unique entries by monomer
      assembly_block = {}
  
      assembly_map.each do |monomer, sides|
        monomer_map[monomer] ||= start_pos.dup
        assembly_block[monomer] ||= { position: monomer_map[monomer].dup, monomer: monomer }
  
        hex_pos = monomer_map[monomer]
  
        sides.each do |side, neighbors|
          neighbor = neighbors.first
          next if monomer_map[neighbor]
  
          neighbor_pos = case side
                         when "S1"
                           { x: hex_pos[:x] + horiz3_4, y: hex_pos[:y], z: hex_pos[:z] }
                         when "S2"
                           { x: hex_pos[:x] + horiz3_8, y: hex_pos[:y], z: hex_pos[:z] - vert_div_sqrt3 }
                         when "S3"
                           { x: hex_pos[:x] - horiz3_8, y: hex_pos[:y], z: hex_pos[:z] - vert_div_sqrt3 }
                         when "S4"
                           { x: hex_pos[:x] - horiz3_4, y: hex_pos[:y], z: hex_pos[:z] }
                         when "S5"
                           { x: hex_pos[:x] + horiz3_8, y: hex_pos[:y], z: hex_pos[:z] + vert_div_sqrt3 }
                         when "S6"
                           { x: hex_pos[:x] - horiz3_8, y: hex_pos[:y], z: hex_pos[:z] + vert_div_sqrt3 }
                         when "ZU"
                           { x: hex_pos[:x], y: hex_pos[:y] + depth + 0.5, z: hex_pos[:z] }
                         when "ZD"
                           { x: hex_pos[:x], y: hex_pos[:y] - (depth + 0.5), z: hex_pos[:z] }
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
end
  