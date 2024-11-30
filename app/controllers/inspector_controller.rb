require 'json'

class InspectorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "2x7Z-10H-2A2R4N")
        @assembly_map = @assembly[:assembly_map].to_json
        @bond_map = @assembly.normalize_bonds.to_json 
    end
end
