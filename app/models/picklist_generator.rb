require 'csv'

class PicklistGenerator
    def initialize
        @hex_plate = Daru::DataFrame.from_csv("/home/sme777/Desktop/hexoland/app/assets/sequences/plate.csv")
    end

    def new_picklist(sequences, volume, destination)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        df = Daru::DataFrame.new({}, order: columns)
        counter = 1
        @hex_plate.each_row do |row|
            if sequences.include?(row["Sequence2"])
                destination_row = [row["Plate Name"], "384PP_AQ_BP", row["Well Position"], row["Sequence2"], "Destination[1]", destination, volume]
                df.add_row(destination_row)
            end
        end
        df
    end

    def generate_picklist(design_map, vol_arr, dest_arr)
        # byebug
        seq_arr = convert_design_map_to_sequences(design_map)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        main_picklist = Daru::DataFrame.new({}, order: columns)

        seq_arr.each_with_index do |seqs, idx|
            sub_picklist = new_picklist(seqs, vol_arr[idx], dest_arr[idx])
            filtered_sub_picklist = sub_picklist.filter_rows { |row| row['Source Plate Name'] != 'New Hex Core' }
            main_picklist = main_picklist.concat(filtered_sub_picklist)
        end
        main_picklist
    end


    def convert_design_map_to_sequences(design_map)
        seq_arr = []
        design_map.each do |key ,value|
            seq_arr << value[0]
        end
        seq_arr
    end
end