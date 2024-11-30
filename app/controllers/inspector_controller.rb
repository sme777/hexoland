require 'json'

class InspectorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "2x3x3")
        @assembly_map = @assembly[:assembly_map].to_json
        @bond_map = @assembly.normalize_bonds.to_json 
        # byebug
    end
end
