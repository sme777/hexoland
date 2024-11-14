require 'json'

class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "1x4")
        @assembly_map = @assembly[:assembly_map].to_json
    end
end
