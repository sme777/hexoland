class SimulatorController < ApplicationController
    def index
        @assembly = Assembly.find_by(name: "Z-4-S23")
    end
end
