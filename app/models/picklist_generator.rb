require 'csv'

class PicklistGenerator
    def initialize
        @hex_plate = Daru::DataFrame.from_csv(' "/Users/samsonpetrosyan/Desktop/hexoland/app/assets/sequences/plate.csv"')
    end

    def new_picklist(sequences)
        columns = ['Source Plate Name', 'Source Plate Type', 'Source Well', 'Sample Comments', 'Destination Plate Name', 'Destination Well', 'Transfer Volume']
        df = Daru::DataFrame.new({}, order: columns)
        counter = 1
        @hex_plate.each_rwo do |row|
            if sequences.include?(row["Sequence"])
                df.add_row(row)
            end
        end
        df
    end

    def generate_picklist(seq_arr, dest_arr, vol_arr)

    end
end