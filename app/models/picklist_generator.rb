require 'csv'

class PicklistGenerator
    def initialize
        @hex_plate = Daru::DataFrame.from_csv(Rails.root.join("app/assets/sequences/plate.csv"))
    end

    def new_picklist(sequences, volume, destination, core_counter, core_volume)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        df = Daru::DataFrame.new({}, order: columns)
        counter = 1
        @hex_plate.each_row do |row|
            if sequences[1].include?(row["Sequence2"])
                destination_row = [row["Plate Name"], "384PP_AQ_BP", row["Well Position"], "#{sequences[0]}-#{row["Sequence2"]}", "Destination[1]", destination, volume]
                df.add_row(destination_row)
            end
        end
        df.add_row(["Hex Core Bonds", "384PP_AQ_BP", "#{col2row[core_counter]}14", "Core Mix", "Destination[1]", destination, core_volume])
        df
    end

    def generate_picklist(design_map, final_volume, scaffold_start_concetration, staple_ratio, 
        scaffold_final_concetration, staple_concetration, wells, add_buffer, add_scaffold)
        
        staple_volume = (final_volume.to_f * 10**-6 * (staple_ratio.to_f * scaffold_final_concetration.to_f * 10**-9) / (staple_concetration.to_f * 10**-6)) * 10**9
        scaffold_volume = (final_volume.to_f * 10**-6 * (scaffold_final_concetration.to_f * 10**-9) / (scaffold_start_concetration.to_f * 10**-9)) * 10**9
        core_volume = ((staple_volume / 8.0) * 96).to_i
        buffer_volume = final_volume.to_f * 10**3 - (staple_volume * 112)- scaffold_volume - core_volume
        
        staple_volume = round_to_nearest_25(staple_volume)
        scaffold_volume = round_to_nearest_25(scaffold_volume)
        core_volume = round_to_nearest_25(core_volume)
        buffer_volume = round_to_nearest_25(buffer_volume)
        core_counter = 0
        
        seq_arr = convert_design_map_to_sequences(design_map)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        main_picklist = Daru::DataFrame.new({}, order: columns)
        # byebug
        seq_arr.each_with_index do |seqs, idx|
            sub_picklist = new_picklist(seqs, staple_volume, wells[idx], (core_counter+1).to_s, core_volume)
            filtered_sub_picklist = sub_picklist.filter_rows { |row| row['Source Plate Name'] != 'New Hex Core' }
            main_picklist = main_picklist.concat(filtered_sub_picklist)
            core_counter = (core_counter + 1) % 16 
        end

        if add_buffer

            buffer_counter1 = 1
            buffer_counter2 = "A"

            buffer_picklist = Daru::DataFrame.new({}, order: columns)
            wells.each_with_index do |well, idx|
                buffer_picklist.add_row(["FoB20 Buffer", "384PP_AQ_BP", "#{buffer_counter2}#{buffer_counter1}", "Core Mix", "Destination[1]", well, buffer_volume])
                buffer_counter1 += 1
                if buffer_counter1 > 24
                    buffer_counter1 = 1
                    buffer_counter2 = buffer_counter2.next

                    if buffer_counter2 > "P"
                      buffer_counter1 = 1
                      buffer_counter2 = "A"
                    end
                end

            end
            main_picklist = main_picklist.concat(buffer_picklist)
        end

        # if add_scaffold
        #     scaffold_picklist = Daru::DataFrame.new({}, order: columns)

        # end

        main_picklist
    end

    def round_to_nearest_25(number)
        (number / 25.0).round * 25
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