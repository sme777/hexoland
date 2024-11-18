require 'json'

class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "Z-8-12H")
        @assembly_map = @assembly[:assembly_map].to_json
    end
end
