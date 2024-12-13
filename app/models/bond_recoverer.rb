require 'set'
require 'csv'
require 'timeout'
require 'daru'

BOND_PATH =  Rails.root.join("app/assets/sequences/bond.csv")
BASIC_Z_PATH = Rails.root.join("app/assets/sequences/basic_z.csv")

class BondRecoverer
    
    def initialize
        @bond_map = {}
        CSV.foreach(BOND_PATH) do |row|
            @bond_map[row[1]] = row[0]
        end

    end

    def recover(file)
        design_map = {}
        CSV.foreach(file.tempfile, headers: true) do |row|
           structure, unit, sequence = extract_ids(row["Sample Comments"])
           side, bond = decrypt_sequence(sequence)
           if !bond.nil?
                if design_map[structure].nil?
                    design_map[structure] = {}
                    design_map[structure][unit] = {}
                    design_map[structure][unit][side] = ["?", [bond]]
                elsif design_map[structure][unit].nil?
                    design_map[structure][unit] = {}
                    design_map[structure][unit][side] = ["?", [bond]]
                elsif design_map[structure][unit][side].nil?
                    design_map[structure][unit][side] = ["?", [bond]]
                else
                    design_map[structure][unit][side][1] << bond
                end
            end
        end
        decrypt_interfaces(design_map)
    end

    def decrypt_interfaces(bond_map)
        bond_map
    end

    def decrypt_sequence(sequence)
        bond = @bond_map[sequence]
        if bond.nil?
            [nil, nil]
        else
            if bond.include?("AND")
                [nil, nil]
            elsif bond.include?("Z")
                [nil, nil]
            elsif bond.end_with?("_B") # don't include 5T bonds
                [nil, nil]
            else
                [extract_side(bond[..2]), bond]
            end
        end
    end

    def extract_side(helix)
        helix_map = {
            "S1" => ["H61", "H60", "H57", "H56"],
            "S2" => ["H54", "H53", "H50", "H49"],
            "S3" => ["H47", "H46", "H43", "H42"],
            "S4" => ["H40", "H39", "H36", "H35"],
            "S5" => ["H33", "H32", "H71", "H70"],
            "S6" => ["H68", "H67", "H64", "H63"]
        }

        helix_map.each do |side, helices|
            if helices.include?(helix)
                return side
            end
        end
        return nil
    end

    def extract_ids(row_item)
        match = row_item.match(/^(?<structure>.*)-(?<sequence>[A-Z]+)$/)
        if match
            structure = match[:structure]
            sequence = match[:sequence]
            unit = nil
            match2 = structure.match(/^(?<structure>.*)-(?<unit>.*)$/)
            if match2
                structure = match2[:structure]
                unit = match2[:unit]
            end
            [structure, unit, sequence]
        end
    end
end