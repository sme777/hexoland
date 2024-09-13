require 'csv'

class PicklistGenerator
    def initialize
        @hex_plate = Daru::DataFrame.from_csv(Rails.root.join("app/assets/sequences/plate.csv"))
    end

    def new_picklist(sequences, volume, destination, core_counter)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        df = Daru::DataFrame.new({}, order: columns)
        counter = 1
        @hex_plate.each_row do |row|
            if sequences[1].include?(row["Sequence2"])
                destination_row = [row["Plate Name"], "384PP_AQ_BP", row["Well Position"], "#{sequences[0]}-#{row["Sequence2"]}", "Destination[1]", destination, volume]
                df.add_row(destination_row)
            end
        end
        df.add_row(["New Hex Bonds", "384PP_AQ_BP", "#{col2row[core_counter]}14", "Core Mix", "Destination[1]", destination, 600])
        df
    end

    def generate_picklist(design_map, vol_arr, dest_arr)
        core_counter = 0
        seq_arr = convert_design_map_to_sequences(design_map)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        main_picklist = Daru::DataFrame.new({}, order: columns)
        # byebug
        seq_arr.each_with_index do |seqs, idx|
            sub_picklist = new_picklist(seqs, vol_arr[idx], dest_arr[idx], (core_counter+1).to_s)
            filtered_sub_picklist = sub_picklist.filter_rows { |row| row['Source Plate Name'] != 'New Hex Core' }
            main_picklist = main_picklist.concat(filtered_sub_picklist)
            core_counter = (core_counter + 1) % 16 
        end
        main_picklist
    end


    def convert_design_map_to_sequences(design_map)
        seq_arr = []
        design_map.each do |key1, monomer|
            monomer.each do |key2, bond|
                seq_arr << ["#{key1}-#{key2}", bond["Sequences"]]
            end
        end
        seq_arr
    end

    def col2row
        {
            "1" => "A",
            "2" => "B",
            "3" => "C",
            "4" => "D",
            "5" => "E",
            "6" => "F",
            "7" => "G",
            "8" => "H",
            "9" => "I",
            "10" => "J",
            "11" => "K",
            "12" => "L",
            "13" => "M",
            "14" => "N",
            "15" => "O",
            "16" => "P",
        }
    end
end