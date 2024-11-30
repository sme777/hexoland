require 'json'

class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "2M")
        @assembly_map = @assembly[:assembly_map].to_json
        @bond_map = @assembly.normalize_bonds.to_json     
    end
end
